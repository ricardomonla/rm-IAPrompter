#!/bin/bash
# ----------------------------------------------------
# Script Maestro de Despliegue MFM (Docker Compose + Seguridad + Auto-Fix)
# ----------------------------------------------------

# --- Definiciones ---
ELECTRON_DIR="app-interface"
ENV_FILE=".env"
DATA_DIR="./app-data"
# Nombre del contenedor definido en docker-compose.yml
CONTAINER_NAME="mfm-backend" 

# Colores para la terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}===== MFM Assistant Launcher =====${NC}"

# --- 0. Detección de Docker Compose ---
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo -e "${RED}❌ Error Crítico: No se encontró Docker Compose.${NC}"
    exit 1
fi
echo -e "ℹ️  Usando comando: ${YELLOW}$DOCKER_COMPOSE_CMD${NC}"

# --- 1. Verificación de Seguridad (.env) ---
if [ ! -f "$ENV_FILE" ] || ! grep -q "GEMINI_API_KEY_ENCRYPTED" "$ENV_FILE"; then
    echo -e "${YELLOW}>> Configuración de seguridad inicial necesaria.${NC}"
    
    read -sp "1. Introduce tu API Key de Gemini REAL: " REAL_API_KEY
    echo ""
    read -sp "2. Crea una Clave Maestra (la usarás para desbloquear la app): " MASTER_KEY
    echo ""
    
    if [ -z "$REAL_API_KEY" ] || [ -z "$MASTER_KEY" ]; then
        echo -e "${RED}Error: Las claves no pueden estar vacías.${NC}"
        exit 1
    fi

    echo "Encriptando credenciales..."
    # Cifrado usando contenedor temporal
    ENCRYPTED_VALUE=$(docker run --rm python:3.11-slim /bin/bash -c "
pip install cryptography > /dev/null 2>&1 && python -c '
import base64
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

master_key = \"$MASTER_KEY\".encode()
api_key = \"$REAL_API_KEY\"
salt = b\"mfm_assistant_salt\"

kdf = PBKDF2HMAC(algorithm=hashes.SHA256(), length=32, salt=salt, iterations=480000)
key = base64.urlsafe_b64encode(kdf.derive(master_key))
f = Fernet(key)
print(f.encrypt(api_key.encode()).decode())
'")

    if [ -z "$ENCRYPTED_VALUE" ]; then
        echo -e "${RED}Error: Falló la encriptación.${NC}"
        exit 1
    fi

    echo "GEMINI_API_KEY_ENCRYPTED=$ENCRYPTED_VALUE" > "$ENV_FILE"
    echo -e "${GREEN}✅ Archivo .env generado.${NC}"
fi

# --- 2. Preparación de Directorios ---
if [ ! -d "$DATA_DIR" ]; then
    mkdir -p "$DATA_DIR"
    echo -e "${GREEN}📂 Directorio de datos creado: $DATA_DIR${NC}"
fi

# --- 3. Lanzamiento del Backend (Con Auto-Reparación) ---
echo -e "${BLUE}>> Levantando servicios con Docker Compose...${NC}"

# >> LÓGICA DE AUTO-REPARACIÓN <<
# Verificar si el nombre del contenedor ya está pillado por un proceso antiguo o manual
if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo -e "${YELLOW}⚠️  Detectado contenedor antiguo '${CONTAINER_NAME}' bloqueando el despliegue.${NC}"
    echo -e "${YELLOW}   -> Eliminando conflicto automáticamente...${NC}"
    docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1
fi

# Limpieza estándar de compose
$DOCKER_COMPOSE_CMD down --remove-orphans > /dev/null 2>&1

# Levantamiento
$DOCKER_COMPOSE_CMD up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al iniciar Docker Compose. Verifica tu archivo docker-compose.yml${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Backend activo.${NC}"

# --- 4. Lanzamiento del Frontend (Electron) ---
echo -e "${BLUE}>> Lanzando Interfaz Electron...${NC}"

if [ -d "$ELECTRON_DIR" ]; then
    cd "$ELECTRON_DIR" || exit
    
    if [ ! -d "node_modules" ]; then
         echo "Instalando dependencias npm..."
         npm install > /dev/null 2>&1
    fi

    echo "Iniciando ventana..."
    npm start -- --disable-gpu & 
    ELECTRON_PID=$!
    
    echo -e "${GREEN}✨ Asistente ejecutándose.${NC}"
    echo "Presiona Ctrl+C para cerrar."
    
    wait $ELECTRON_PID
    
    echo -e "\n${YELLOW}Limpiando...${NC}"
    cd ..
    $DOCKER_COMPOSE_CMD down
    echo "Bye!"
else
    echo -e "${RED}❌ No se encontró el directorio $ELECTRON_DIR${NC}"
    cd ..
    $DOCKER_COMPOSE_CMD down
fi
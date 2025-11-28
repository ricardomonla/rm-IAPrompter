#!/bin/bash
# -----------------------------------------------------------------------------
# Autor: Lic. Ricardo MONLA
# Versión: v0.9.1
# Descripción: Script maestro de orquestación, seguridad y despliegue del MFM.
# -----------------------------------------------------------------------------

# --- Definiciones ---
ELECTRON_DIR="app-interface"
ENV_FILE=".env"
DATA_DIR="./app-data"
CONTAINER_NAME="mfm-backend" 
LOG_DIR="./app-logs"

# Change to script directory to ensure relative paths work from anywhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Funciones Modulares ---

function check_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        echo -e "${RED}❌ Error Crítico: No se encontró Docker Compose.${NC}"
        exit 1
    fi
    echo -e "ℹ️  Usando comando: ${YELLOW}$DOCKER_COMPOSE_CMD${NC}"
}

function setup_security() {
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
}

function prepare_directories() {
    if [ ! -d "$DATA_DIR" ]; then
        mkdir -p "$DATA_DIR"
        echo -e "${GREEN}📂 Directorio de datos creado: $DATA_DIR${NC}"
    fi

    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
    fi
}

function start_backend() {
    echo -e "${BLUE}>> Levantando servicios con Docker Compose...${NC}"

    # Auto-reparación de nombres conflictivos
    if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
        echo -e "${YELLOW}⚠️  Detectado contenedor antiguo. Limpiando...${NC}"
        docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1
    fi

    # Limpieza estándar
    $DOCKER_COMPOSE_CMD down --remove-orphans > /dev/null 2>&1

    # Levantamiento CON RECONSTRUCCIÓN (--build) para asegurar imagen optimizada
    $DOCKER_COMPOSE_CMD up -d --build

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error al iniciar Docker Compose. Verifica tu archivo docker-compose.yml${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Backend activo.${NC}"
}

function start_frontend() {
    echo -e "${BLUE}>> Lanzando Interfaz Electron ($ELECTRON_DIR)...${NC}"

    if [ -d "$ELECTRON_DIR" ]; then
        cd "$ELECTRON_DIR" || exit
        
        if [ ! -d "node_modules" ]; then
             echo "Instalando dependencias npm..."
             npm install > /dev/null 2>&1
        fi

        echo "Iniciando ventana..."
        
        # -- LÓGICA DE DEBUG Y LOGGING FRONTEND --
        if [ "$DEBUG_MODE" = true ]; then
            echo -e "${YELLOW}>> Ejecutando en modo DEBUG (Desvinculado)${NC}"
            echo -e "${YELLOW}>> Logs guardados en: $LOG_DIR${NC}"
            
            export MFM_DEBUG=true
            export ELECTRON_ENABLE_LOGGING=true
            
            npm start -- --disable-gpu --enable-logging --v=1 > "$FRONTEND_LOG_FILE" 2>&1 &
        else
            # Modo Normal Desvinculado
            npm start -- --disable-gpu &
        fi
        
        ELECTRON_PID=$!
        
        echo -e "${GREEN}✨ Asistente ejecutándose en modo desvinculado.${NC}"
        echo "La terminal se ha liberado. Usa --stop para detener."
        
        cd ..
    else
        echo -e "${RED}❌ No se encontró el directorio $ELECTRON_DIR${NC}"
        cd ..
        $DOCKER_COMPOSE_CMD down
    fi
}

function stop_services() {
    echo -e "${YELLOW}>> Deteniendo servicios...${NC}"
    $DOCKER_COMPOSE_CMD down
    # Kill electron if running
    pkill -f "electron" || true
    echo -e "${GREEN}✅ Servicios detenidos.${NC}"
}

# --- Gestión de Argumentos ---
DEBUG_MODE=false
STOP_MODE=false
RESTART_MODE=false

if [[ "$1" == "--debug" || "$1" == "-d" ]]; then
    DEBUG_MODE=true
    echo -e "${YELLOW}🐛 MODO DEBUG ACTIVADO 🐛${NC}"
fi

if [[ "$1" == "--stop" || "$1" == "-s" ]]; then
    STOP_MODE=true
fi

if [[ "$1" == "--restart" || "$1" == "-r" ]]; then
    RESTART_MODE=true
fi

echo -e "${BLUE}===== MFM Assistant Launcher (v0.9.1) =====${NC}"
echo -e "${BLUE}      Por Lic. Ricardo MONLA      ${NC}"

# --- Lógica Principal ---

check_docker_compose

if [ "$STOP_MODE" = true ]; then
    stop_services
    exit 0
fi

if [ "$RESTART_MODE" = true ]; then
    stop_services
fi
setup_security
prepare_directories
start_backend

# --- Logging del Backend ---
if [ "$DEBUG_MODE" = true ]; then
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKEND_LOG_FILE="$LOG_DIR/backend_$TIMESTAMP.log"
    FRONTEND_LOG_FILE="$LOG_DIR/frontend_$TIMESTAMP.log"

    echo -e "${YELLOW}>> Capturando logs del Backend en: $BACKEND_LOG_FILE${NC}"
    docker logs -f "$CONTAINER_NAME" > "$BACKEND_LOG_FILE" 2>&1 &
    DOCKER_LOG_PID=$!
fi

start_frontend

# Modo Desvinculado: No esperar, liberar terminal
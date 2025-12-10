#!/bin/bash

#  -----------------------------------------------------------------------------
#  Project:     rm-IAPrompter
#  File:        app-run.sh
#  Version:     v1.0.7
#  Date:        2025-12-10
#  Author:      Lic. Ricardo MONLA
#  Email:       rmonla@gmail.com
#  Description: Script para ejecutar la aplicación en un contenedor Docker.
#  Último Cambio: 2025-12-10 - Implementado menú interactivo con detección de estado y preguntas con opciones predeterminadas
#  -----------------------------------------------------------------------------

# --- Definiciones ---
ELECTRON_DIR="app-interface"
ENV_FILE=".env"
DATA_DIR="./app-data"
CONTAINER_NAME="rm-iaprompter-backend"
LOG_DIR="./app-logs"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Leer versión desde archivo centralizado
VERSION=$(node -e "const v=require('./app-data/app-version.js'); console.log(v.APP_VERSION);")

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variables de Estado
DEBUG_MODE=false
STOP_MODE=false
RESTART_MODE=false
RESTART_FRONTEND_MODE=false
RESTART_BACKEND_MODE=false
INTERACTIVE_MODE=false

# Variables de Estado de Aplicación
APP_RUNNING=false
FRONTEND_RUNNING=false
BACKEND_RUNNING=false

# --- Funciones ---

function ask_question() {
    local question="$1"
    local default="$2"
    local response
    
    if [ "$default" = "S" ]; then
        read -p "$question [S/n]: " response
        response=${response:-S}
    else
        read -p "$question [s/N]: " response
        response=${response:-N}
    fi
    
    echo "$response"
}

function show_usage() {
    echo "Uso: $0 [opciones]"
    echo "Opciones:"
    echo "  -d, --debug                 Ejecuta en modo debug con logging activo."
    echo "  -s, --stop                  Detiene todos los servicios."
    echo "  -r, --restart               Reinicia todos los servicios."
    echo "  -rf, --restart-frontend     Reinicia solo el frontend."
    echo "  -rb, --restart-backend      Reinicia solo el backend."
    echo "  -h, --help                  Muestra esta ayuda."
    echo ""
    echo "Ejemplos:"
    echo "  $0                          Inicia la aplicación normalmente."
    echo "  $0 --restart-frontend --debug  Reinicia el frontend en modo debug."
}

function check_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        echo -e "${RED}❌ Error Crítico: No se encontró Docker Compose.${NC}"
        exit 1
    fi
}

function setup_security() {
    # Solo ejecuta si no existe la clave o si el archivo no existe
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
        
        # --- BLOQUE DE ENCRIPTACIÓN ---
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
        # ------------------------------

        if [ -z "$ENCRYPTED_VALUE" ]; then
            echo -e "${RED}Error: Falló la encriptación. Verifica Docker.${NC}"
            exit 1
        fi

        echo "GEMINI_API_KEY_ENCRYPTED=$ENCRYPTED_VALUE" > "$ENV_FILE"
        echo -e "${GREEN}✅ Archivo .env generado correctamente.${NC}"
    fi
}

function stop_services() {
    echo -e "${YELLOW}>> Deteniendo servicios...${NC}"
    $DOCKER_COMPOSE_CMD down --remove-orphans
    pkill -f "electron" || true
    echo -e "${GREEN}✅ Servicios detenidos.${NC}"
}

function stop_frontend() {
    echo -e "${YELLOW}>> Deteniendo interfaz...${NC}"
    pkill -f "electron" || true
    echo -e "${GREEN}✅ Interfaz detenida.${NC}"
}

function stop_backend() {
    echo -e "${YELLOW}>> Deteniendo backend...${NC}"
    $DOCKER_COMPOSE_CMD down --remove-orphans
    echo -e "${GREEN}✅ Backend detenido.${NC}"
}

function check_app_status() {
    echo -e "${BLUE}>> Verificando estado de la aplicación...${NC}"
    
    # Verificar backend (Docker container)
    if docker compose ps | grep -q "backend"; then
        if docker compose ps backend | grep -q "Up"; then
            BACKEND_RUNNING=true
            echo -e "   ✅ Backend: ${GREEN}En ejecución${NC}"
        else
            BACKEND_RUNNING=false
            echo -e "   ❌ Backend: ${RED}Detenido${NC}"
        fi
    else
        BACKEND_RUNNING=false
        echo -e "   ❌ Backend: ${RED}No existe${NC}"
    fi
    
    # Verificar frontend (Electron process)
    if pgrep -f "electron" > /dev/null; then
        FRONTEND_RUNNING=true
        echo -e "   ✅ Frontend: ${GREEN}En ejecución${NC}"
    else
        FRONTEND_RUNNING=false
        echo -e "   ❌ Frontend: ${RED}Detenido${NC}"
    fi
    
    # Determinar estado general
    if [ "$BACKEND_RUNNING" = true ] && [ "$FRONTEND_RUNNING" = true ]; then
        APP_RUNNING=true
        echo -e "   🎯 Aplicación: ${GREEN}COMPLETA - Ambos servicios activos${NC}"
    elif [ "$BACKEND_RUNNING" = true ]; then
        APP_RUNNING=true
        echo -e "   ⚠️  Aplicación: ${YELLOW}PARCIAL - Backend activo, frontend detenido${NC}"
    else
        APP_RUNNING=false
        echo -e "   ❌ Aplicación: ${RED}DETENIDA - Ningún servicio activo${NC}"
    fi
}

function start_frontend() {
    echo -e "${BLUE}>> Iniciando Interfaz Electron ($ELECTRON_DIR)...${NC}"
    cd "$ELECTRON_DIR" || exit
    
    if [ ! -d "node_modules" ]; then
         echo "Instalando dependencias npm..."
         npm install > /dev/null 2>&1
    fi

    if [ "$DEBUG_MODE" = true ]; then
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        FRONTEND_LOG="../$LOG_DIR/frontend_$TIMESTAMP.log"
        echo -e "${CYAN}🐛 MODO DEBUG (LOGGING ACTIVO): La terminal se liberará.${NC}"
        
        export MFM_DEBUG=true
        export ELECTRON_ENABLE_LOGGING=true
        
        npm start -- --disable-gpu --enable-logging --v=1 > "$FRONTEND_LOG" 2>&1 &
        
        echo -e "${GREEN}✨ Interfaz iniciada.${NC}"
        echo -e "   📄 Log Frontend: ${YELLOW}$FRONTEND_LOG${NC}"
        echo -e "   Usa ${YELLOW}tail -f $FRONTEND_LOG${NC} para monitorear manualmente."
        
    else
        npm start -- --disable-gpu > /dev/null 2>&1 &
        echo -e "${GREEN}✨ Interfaz iniciada en segundo plano.${NC}"
    fi
    cd ..
}

function start_backend() {
    echo -e "${BLUE}>> Iniciando Backend...${NC}"
    $DOCKER_COMPOSE_CMD up -d --build
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error al iniciar Docker Compose.${NC}"
        exit 1
    fi
    if [ "$DEBUG_MODE" = true ]; then
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        BACKEND_LOG="$LOG_DIR/backend_$TIMESTAMP.log"
        echo -e "${CYAN}🐛 MODO DEBUG (LOGGING ACTIVO): La terminal se liberará.${NC}"
        
        docker logs -f "$CONTAINER_NAME" > "$BACKEND_LOG" 2>&1 &
        
        echo -e "${GREEN}✨ Backend iniciado.${NC}"
        echo -e "   📄 Log Backend:  ${YELLOW}$BACKEND_LOG${NC}"
        echo -e "   Usa ${YELLOW}tail -f $BACKEND_LOG${NC} para monitorear manualmente."
    else
        echo -e "${GREEN}✨ Backend iniciado en segundo plano.${NC}"
    fi
}

function interactive_menu() {
    while true; do
        echo -e "\n${CYAN}===== MENÚ INTERACTIVO =====${NC}"
        echo -e "${YELLOW}Estado actual:${NC}"
        if [ "$APP_RUNNING" = true ]; then
            echo -e "   🎯 Aplicación: ${GREEN}EN EJECUCIÓN${NC}"
        else
            echo -e "   ❌ Aplicación: ${RED}DETENIDA${NC}"
        fi
        echo ""
        echo "Seleccione una opción:"
        echo "1) Iniciar aplicación"
        echo "2) Detener aplicación"
        echo "3) Reiniciar aplicación"
        echo "4) Reiniciar solo Backend"
        echo "5) Reiniciar solo Frontend"
        echo "6) Ver logs"
        echo "7) Salir"
        echo ""
        read -p "Opción [1-7]: " choice
        
        case $choice in
            1)
                if [ "$APP_RUNNING" = true ]; then
                    echo -e "${YELLOW}⚠️  La aplicación ya está en ejecución.${NC}"
                else
                    echo -e "${BLUE}>> Iniciando aplicación...${NC}"
                    start_app
                    echo -e "${GREEN}✅ Aplicación iniciada.${NC}"
                fi
                ;;
            2)
                if [ "$APP_RUNNING" = false ]; then
                    echo -e "${YELLOW}⚠️  La aplicación ya está detenida.${NC}"
                else
                    echo -e "${BLUE}>> Deteniendo aplicación...${NC}"
                    stop_services
                    echo -e "${GREEN}✅ Aplicación detenida.${NC}"
                    echo ""
                    response=$(ask_question "¿Desea salir del menú?" "S")
                    if [[ $response =~ ^[Ss]$ ]]; then
                        echo -e "${GREEN}👋 Saliendo del menú interactivo.${NC}"
                        return 0
                    fi
                fi
                ;;
            3)
                echo -e "${BLUE}>> Reiniciando aplicación...${NC}"
                stop_services
                start_app
                echo -e "${GREEN}✅ Aplicación reiniciada.${NC}"
                ;;
            4)
                echo -e "${BLUE}>> Reiniciando Backend...${NC}"
                stop_backend
                start_backend
                echo -e "${GREEN}✅ Backend reiniciado.${NC}"
                ;;
            5)
                echo -e "${BLUE}>> Reiniciando Frontend...${NC}"
                stop_frontend
                start_frontend
                echo -e "${GREEN}✅ Frontend reiniciado.${NC}"
                ;;
            6)
                show_logs_menu
                ;;
            7)
                echo -e "${GREEN}👋 Saliendo del menú interactivo.${NC}"
                return 0
                ;;
            *)
                echo -e "${RED}❌ Opción inválida. Por favor, elija una opción del 1 al 7.${NC}"
                ;;
        esac
        
        echo ""
        read -p "Presione Enter para continuar..."
    done
}

function show_logs_menu() {
    echo ""
    echo "Seleccione qué logs desea ver:"
    echo "1) Backend (Docker)"
    echo "2) Frontend (Electron)"
    echo "3) Volver al menú principal"
    read -p "Opción [1-2-3]: " log_choice
    
    case $log_choice in
        1)
            if [ "$BACKEND_RUNNING" = true ]; then
                echo -e "${BLUE}>> Mostrando logs del Backend (Ctrl+C para salir)...${NC}"
                $DOCKER_COMPOSE_CMD logs -f "$CONTAINER_NAME"
            else
                echo -e "${RED}❌ El Backend no está en ejecución.${NC}"
            fi
            ;;
        2)
            if [ "$FRONTEND_RUNNING" = true ]; then
                echo -e "${BLUE}>> Mostrando logs del Frontend (Ctrl+C para salir)...${NC}"
                # Buscar el archivo de log más reciente
                LATEST_LOG=$(ls -t "$LOG_DIR"/frontend_*.log 2>/dev/null | head -1)
                if [ -n "$LATEST_LOG" ]; then
                    tail -f "$LATEST_LOG"
                else
                    echo -e "${YELLOW}⚠️  No se encontró archivo de log del Frontend.${NC}"
                fi
            else
                echo -e "${RED}❌ El Frontend no está en ejecución.${NC}"
            fi
            ;;
        3)
            return 0
            ;;
        *)
            echo -e "${RED}❌ Opción inválida.${NC}"
            ;;
    esac
}

function start_app() {
    # 1. Directorios
    if [ ! -d "$DATA_DIR" ]; then
        mkdir -p "$DATA_DIR"
        echo -e "${GREEN}📂 Directorio de datos creado.${NC}"
    fi
    mkdir -p "$LOG_DIR"

    # 2. Backend
    echo -e "${BLUE}>> Iniciando Backend...${NC}"

    $DOCKER_COMPOSE_CMD down --remove-orphans > /dev/null 2>&1

    $DOCKER_COMPOSE_CMD up -d --build

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error al iniciar Docker Compose.${NC}"
        exit 1
    fi

    # 3. Frontend
    echo -e "${BLUE}>> Iniciando Interfaz Electron ($ELECTRON_DIR)...${NC}"
    cd "$ELECTRON_DIR" || exit
    
    if [ ! -d "node_modules" ]; then
         echo "Instalando dependencias npm..."
         npm install > /dev/null 2>&1
    fi

    if [ "$DEBUG_MODE" = true ]; then
        # --- MODO DEBUG DESATENDIDO (BACKGROUND LOGGING) ---
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        BACKEND_LOG="../$LOG_DIR/backend_$TIMESTAMP.log"
        FRONTEND_LOG="../$LOG_DIR/frontend_$TIMESTAMP.log"

        echo -e "${CYAN}🐛 MODO DEBUG (LOGGING ACTIVO): La terminal se liberará.${NC}"
        
        export MFM_DEBUG=true
        export ELECTRON_ENABLE_LOGGING=true

        # Backend Logs: Redirección directa al archivo (sin tee, sin stdout)
        # Se ejecuta en background para no bloquear
        docker logs -f "$CONTAINER_NAME" > "$BACKEND_LOG" 2>&1 &
        
        # Frontend: Ejecución en background, toda la salida al archivo
        npm start -- --disable-gpu --enable-logging --v=1 > "$FRONTEND_LOG" 2>&1 &
        
        echo -e "${GREEN}✨ Aplicación iniciada.${NC}"
        echo -e "   📄 Log Backend:  ${YELLOW}$BACKEND_LOG${NC}"
        echo -e "   📄 Log Frontend: ${YELLOW}$FRONTEND_LOG${NC}"
        echo -e "   Usa ${YELLOW}tail -f $FRONTEND_LOG${NC} para monitorear manualmente."
        
        cd ..
    else
        # --- MODO PRODUCCIÓN (ESTÁNDAR) ---
        npm start -- --disable-gpu > /dev/null 2>&1 &
        echo -e "${GREEN}✨ Aplicación iniciada en segundo plano.${NC}"
        cd ..
    fi
}

# --- Procesamiento de Argumentos ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--debug) DEBUG_MODE=true ;;
        -s|--stop) STOP_MODE=true ;;
        -r|--restart) RESTART_MODE=true ;;
        -rf|--restart-frontend) RESTART_FRONTEND_MODE=true ;;
        -rb|--restart-backend) RESTART_BACKEND_MODE=true ;;
        -i|--interactive) INTERACTIVE_MODE=true ;;
        -h|--help) show_usage; exit 0 ;;
        *) echo "Opción desconocida: $1"; show_usage; exit 1 ;;
    esac
    shift
done

# --- Ejecución Principal ---
echo -e "${BLUE}===== rm-IAPrompter Launcher v${VERSION} =====${NC}"

check_docker_compose

# Verificar estado de la aplicación
check_app_status

# Modo interactivo: Si no se pasaron parámetros o se especificó --interactive
if [ "$INTERACTIVE_MODE" = true ] || ([ "$#" -eq 0 ] && [ "$STOP_MODE" = false ] && [ "$RESTART_MODE" = false ] && [ "$RESTART_FRONTEND_MODE" = false ] && [ "$RESTART_BACKEND_MODE" = false ]); then
    echo ""
    if [ "$APP_RUNNING" = true ]; then
        echo -e "${GREEN}🎯 La aplicación ya está en ejecución.${NC}"
        interactive_menu
    else
        echo -e "${YELLOW}⚠️  La aplicación no está en ejecución.${NC}"
        echo ""
        response=$(ask_question "¿Desea iniciar la aplicación?" "S")
        if [[ $response =~ ^[Ss]$ ]]; then
            setup_security
            start_app
            echo -e "${GREEN}✅ Aplicación iniciada exitosamente.${NC}"
            echo ""
            response=$(ask_question "¿Desea acceder al menú interactivo?" "S")
            if [[ $response =~ ^[Ss]$ ]]; then
                # Actualizar estado después de iniciar
                check_app_status
                interactive_menu
            fi
        else
            echo -e "${YELLOW}👋 Saliendo sin iniciar la aplicación.${NC}"
            exit 0
        fi
    fi
    exit 0
fi

# Modo de parámetros: Ejecutar según los parámetros pasados
if [ "$RESTART_MODE" = true ]; then
    stop_services
elif [ "$RESTART_FRONTEND_MODE" = true ] || [ "$RESTART_BACKEND_MODE" = true ]; then
    if [ "$RESTART_FRONTEND_MODE" = true ]; then
        stop_frontend
    fi
    if [ "$RESTART_BACKEND_MODE" = true ]; then
        stop_backend
    fi
fi

if [ "$STOP_MODE" = true ]; then
    stop_services
    exit 0
fi

setup_security

if [ "$RESTART_MODE" = true ] || ( [ "$RESTART_FRONTEND_MODE" = false ] && [ "$RESTART_BACKEND_MODE" = false ] ); then
    start_app
else
    if [ "$RESTART_FRONTEND_MODE" = true ]; then
        start_frontend
    fi
    if [ "$RESTART_BACKEND_MODE" = true ]; then
        start_backend
    fi
fi
# -----------------------------------------------------------------------------
# Autor: Lic. Ricardo MONLA
# Versión: v0.8.6
# Descripción: Backend Flask con cifrado Fernet, integración Gemini e inspección de procesos.
# -----------------------------------------------------------------------------

from flask import Flask, jsonify, request
import os
import json
import logging
import traceback
import google.generativeai as genai
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64
import threading

# Configuración básica de logging
logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

# Directorios de configuración
CONFIG_DIR = '/app/data'
CONFIG_FILE = os.path.join(CONFIG_DIR, 'config.json')
TEMPLATES_FILE = os.path.join(CONFIG_DIR, 'templates.json')

# Variables globales para el estado de la API y el modelo
GEMINI_KEY_ENCRYPTED = os.getenv('GEMINI_API_KEY_ENCRYPTED')
gemini_model = None
is_api_initialized = threading.Event()

# --- Cifrado Fernet y Funciones de Seguridad ---

class SecureConfig:
    def __init__(self, master_key_bytes):
        salt = b'mfm_assistant_salt' 
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=480000, 
        )
        self.key = base64.urlsafe_b64encode(kdf.derive(master_key_bytes))
        self.fernet = Fernet(self.key)

    def encrypt(self, data: str) -> str:
        return self.fernet.encrypt(data.encode()).decode()

    def decrypt(self, token: str) -> str:
        return self.fernet.decrypt(token.encode()).decode()

# --- Funciones de Configuración Persistente ---

def load_config():
    if not os.path.exists(CONFIG_DIR):
        try:
            os.makedirs(CONFIG_DIR)
        except OSError as e:
            logging.error(f"Error creating config dir: {e}")
            return {}
        
    if not os.path.exists(CONFIG_FILE):
        initial_config = {
            "favorite_process": "bash",
            "theme": "light",
            "chat_history": []
        }
        try:
            with open(CONFIG_FILE, 'w') as f:
                json.dump(initial_config, f, indent=4)
            return initial_config
        except Exception as e:
            logging.error(f"Error creating initial config file: {e}")
            return {}
    
    try:
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    except Exception as e:
        logging.error(f"Error reading config.json: {e}")
        return {}

def save_config(data):
    if not os.path.exists(CONFIG_DIR):
        os.makedirs(CONFIG_DIR)

    try:
        with open(CONFIG_FILE, 'w') as f:
            json.dump(data, f, indent=4)
        return True
    except Exception as e:
        logging.error(f"Error writing config.json: {e}")
        return False

# --- Funciones de Gestión de Plantillas ---

def load_templates():
    """Cargar plantillas de prompts desde archivo JSON"""
    if not os.path.exists(TEMPLATES_FILE):
        # Plantillas por defecto si el archivo no existe
        default_templates = [
            {"label": "Mejora de Prompt", "value": "Mejora la redacción del siguiente PROMPT teniendo en cuenta que va dirigido a una IA experta:"},
            {"label": "Generación de Código", "value": "Actúa como desarrollador Senior. Genera el código completo y funcional para:"},
            {"label": "Refactorización", "value": "Analiza el siguiente código, busca errores y refactoriza aplicando mejores prácticas:"},
            {"label": "Explicación Técnica", "value": "Explica detalladamente el funcionamiento lógico del siguiente fragmento:"}
        ]
        try:
            with open(TEMPLATES_FILE, 'w') as f:
                json.dump(default_templates, f, indent=4)
            return default_templates
        except Exception as e:
            logging.error(f"Error creating default templates file: {e}")
            return default_templates
    
    try:
        with open(TEMPLATES_FILE, 'r') as f:
            return json.load(f)
    except Exception as e:
        logging.error(f"Error reading templates.json: {e}")
        return []

def save_templates(templates_data):
    """Guardar plantillas en archivo JSON"""
    if not os.path.exists(CONFIG_DIR):
        os.makedirs(CONFIG_DIR)

    try:
        with open(TEMPLATES_FILE, 'w') as f:
            json.dump(templates_data, f, indent=4)
        return True
    except Exception as e:
        logging.error(f"Error writing templates.json: {e}")
        return False

# --- Inicialización de la API ---

def initialize_gemini(api_key: str):
    global gemini_model
    try:
        genai.configure(api_key=api_key)
        gemini_model = genai.GenerativeModel('gemini-2.5-flash',
                                             system_instruction="You are a direct and technical AI assistant, ideal for answering programming queries. Respond in a straightforward, technical manner without unnecessary fluff.")
        is_api_initialized.set() 
        logging.info("Gemini API initialized successfully.")
        return True
    except Exception as e:
        logging.error(f"Failed to initialize Gemini API: {e}")
        return False

# --- Endpoints de Seguridad y Configuración ---

@app.route('/api/initialize', methods=['POST'])
def initialize_api():
    global GEMINI_KEY_ENCRYPTED
    
    if not GEMINI_KEY_ENCRYPTED:
        return jsonify({"success": False, "message": "Clave cifrada no encontrada en entorno."}), 400
    
    data = request.get_json()
    master_key = data.get('master_key')
    
    if not master_key:
        return jsonify({"success": False, "message": "Clave Maestra no proporcionada."}), 400

    try:
        master_key_bytes = master_key.encode()
        secure_config = SecureConfig(master_key_bytes)
        decrypted_key = secure_config.decrypt(GEMINI_KEY_ENCRYPTED)
        
        if initialize_gemini(decrypted_key):
            return jsonify({"success": True, "message": "Sistema desbloqueado."})
        else:
            is_api_initialized.clear()
            return jsonify({"success": False, "message": "Fallo al configurar la API."}), 401
            
    except Exception as e:
        logging.error(f"Decryption error: {e}")
        is_api_initialized.clear()
        return jsonify({"success": False, "message": "Clave Maestra incorrecta."}), 401

@app.route('/api/is_initialized', methods=['GET'])
def is_initialized_status():
    return jsonify({"initialized": is_api_initialized.is_set()})

# --- Middleware de Seguridad ---

@app.before_request
def check_initialization():
    allowed_routes = ['/api/initialize', '/api/is_initialized', '/api/encrypt_key', '/api/status', '/api/get_config', '/api/save_config', '/api/get_templates', '/api/save_templates', '/api/add_template', '/api/delete_template']
    if request.path in allowed_routes:
        return
        
    if not is_api_initialized.is_set():
        return jsonify({"error": "API no inicializada. Por favor, proporcione la Clave Maestra."}), 403

# --- Endpoints Principales ---

@app.route('/api/query_gemini', methods=['POST'])
def query_gemini():
    data = request.get_json()
    if not data or 'query' not in data:
        return jsonify({"error": "Missing 'query'"}), 400

    try:
        response = gemini_model.generate_content(data['query'])
        return jsonify({"response": response.text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/check_process')
def check_process():
    # --- LÓGICA DE MONITOREO REAL ---
    process_name = request.args.get('process_name')
    if not process_name:
        return jsonify({"error": "Falta parámetro process_name"}), 400

    try:
        # Usamos /host/proc mapeado desde docker-compose
        proc_dir = '/host/proc/'
        if not os.path.exists(proc_dir):
            return jsonify({"is_running": False, "message": f"Error: No se puede acceder a {proc_dir}. Verifica docker-compose."})

        # Recorremos los PIDs
        for pid in os.listdir(proc_dir):
            if not pid.isdigit():
                continue
            
            # Leemos el nombre del comando
            comm_path = os.path.join(proc_dir, pid, 'comm')
            if os.path.exists(comm_path):
                try:
                    with open(comm_path, 'r') as f:
                        comm = f.read().strip()
                        # Comparamos (puedes hacer .lower() si quieres ser flexible)
                        if comm == process_name:
                            return jsonify({"is_running": True, "message": f"El proceso '{process_name}' está ACTIVO (PID: {pid})."})
                except (OSError, IOError):
                    continue # El proceso pudo haber terminado mientras leíamos

        return jsonify({"is_running": False, "message": f"El proceso '{process_name}' NO se encontró."})

    except Exception as e:
        logging.error(f"Error checking process: {e}")
        return jsonify({"is_running": False, "message": f"Error verificando: {str(e)}"})

# --- Persistencia ---

@app.route('/api/get_config', methods=['GET'])
def get_config():
    return jsonify(load_config())

@app.route('/api/save_config', methods=['POST'])
def save_config_endpoint():
    data = request.get_json()
    if not data or 'config_data' not in data:
        return jsonify({"success": False, "message": "Missing config_data"}), 400
    
    if save_config(data['config_data']):
        return jsonify({"success": True})
    else:
        return jsonify({"success": False, "message": "Error al guardar"}), 500

# --- Endpoints de Gestión de Plantillas ---

@app.route('/api/get_templates', methods=['GET'])
def get_templates():
    """Obtener todas las plantillas de prompts"""
    try:
        templates = load_templates()
        return jsonify({"success": True, "templates": templates})
    except Exception as e:
        logging.error(f"Error getting templates: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/api/save_templates', methods=['POST'])
def save_templates_endpoint():
    """Guardar todas las plantillas"""
    data = request.get_json()
    if not data or 'templates' not in data:
        return jsonify({"success": False, "message": "Missing templates"}), 400
    
    templates = data['templates']
    if not isinstance(templates, list):
        return jsonify({"success": False, "message": "Templates must be a list"}), 400
    
    if save_templates(templates):
        return jsonify({"success": True})
    else:
        return jsonify({"success": False, "message": "Error al guardar plantillas"}), 500

@app.route('/api/add_template', methods=['POST'])
def add_template_endpoint():
    """Agregar nueva plantilla"""
    data = request.get_json()
    if not data or 'label' not in data or 'value' not in data:
        return jsonify({"success": False, "message": "Missing label or value"}), 400
    
    label = data['label'].strip()
    value = data['value'].strip()
    
    if not label or not value:
        return jsonify({"success": False, "message": "Label and value cannot be empty"}), 400
    
    try:
        templates = load_templates()
        new_template = {"label": label, "value": value}
        templates.append(new_template)
        
        if save_templates(templates):
            return jsonify({"success": True, "message": "Plantilla agregada correctamente"})
        else:
            return jsonify({"success": False, "message": "Error al guardar plantilla"}), 500
    except Exception as e:
        logging.error(f"Error adding template: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/api/delete_template/<int:index>', methods=['DELETE'])
def delete_template_endpoint(index):
    """Eliminar plantilla por índice"""
    try:
        templates = load_templates()
        
        if index < 0 or index >= len(templates):
            return jsonify({"success": False, "message": "Índice de plantilla inválido"}), 400
        
        deleted_template = templates.pop(index)
        
        if save_templates(templates):
            return jsonify({"success": True, "message": f"Plantilla '{deleted_template['label']}' eliminada"})
        else:
            return jsonify({"success": False, "message": "Error al guardar cambios"}), 500
    except Exception as e:
        logging.error(f"Error deleting template: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
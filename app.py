from flask import Flask, jsonify, request
import os
import json
import logging
import traceback
import google.generativeai as genai

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

# Configure Gemini API
genai.configure(api_key=os.getenv('AIzaSyC1mvlI2BITv4FRJ7IzSD9GATYdUQWIsG8'))
model = genai.GenerativeModel('gemini-2.5-flash',
                              system_instruction="You are a direct and technical AI assistant, ideal for answering programming queries. Respond in a straightforward, technical manner without unnecessary fluff.")

@app.route('/api/status')
def status():
    return jsonify({"status": "API is operational"})

@app.route('/api/list_models')
def list_models():
    try:
        models = genai.list_models()
        model_names = [model.name for model in models]
        return jsonify({"models": model_names})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/check_host_access')
def check_host_access():
    try:
        processes = os.listdir('/host/proc/')
        return jsonify({"processes": processes})
    except Exception as e:
        return jsonify({"error": "Cannot access host /proc directory"})

@app.route('/api/query_gemini', methods=['POST'])
def query_gemini():
    data = request.get_json()
    if not data or 'query' not in data:
        return jsonify({"error": "Missing 'query' field in request"}), 400

    query = data['query']
    try:
        response = model.generate_content(query)
        return jsonify({"response": response.text})
    except Exception as e:
        logging.error("Error in query_gemini: %s", str(e))
        logging.error("Traceback: %s", traceback.format_exc())
        return jsonify({"error": str(e)}), 500

@app.route('/api/check_process')
def check_process():
    process_name = request.args.get('process_name')
    if not process_name:
        return jsonify({"error": "Missing process_name parameter"}), 400

    try:
        proc_dir = '/host/proc/'
        if not os.path.exists(proc_dir):
            return jsonify({"is_running": False, "message": f"El proceso {process_name} está inactivo. (No se puede acceder a /host/proc)"})

        for pid in os.listdir(proc_dir):
            if not pid.isdigit():
                continue
            comm_path = os.path.join(proc_dir, pid, 'comm')
            if os.path.exists(comm_path):
                with open(comm_path, 'r') as f:
                    comm = f.read().strip()
                    if comm == process_name:
                        return jsonify({"is_running": True, "message": f"El proceso {process_name} está activo."})

        return jsonify({"is_running": False, "message": f"El proceso {process_name} está inactivo."})

    except Exception as e:
        return jsonify({"is_running": False, "message": f"El proceso {process_name} está inactivo. Error: {str(e)}"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
# **Changelog**

Todos los cambios notables en el proyecto **Asistente de Escritorio MFM** se documentarán en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## **\[0.8.1\] \- 2025-11-25**

### **Añadido**

* **Seguridad:** Implementación de cifrado Fernet (AES) para la API Key de Gemini.  
* **Interfaz:** Pantalla de bloqueo/login que solicita una "Clave Maestra" para descifrar credenciales en memoria.  
* **Interfaz:** Sistema de pestañas para cambiar entre modo "Chat IA" y "Monitor de Procesos".  
* **Despliegue:** Script maestro app-run.sh con:  
  * Auto-detección de versión de Docker Compose.  
  * Asistente interactivo para generar el archivo .env cifrado.  
  * Lógica de auto-reparación para contenedores en conflicto.  
* **Backend:** Endpoint /api/initialize para manejar el desbloqueo del sistema.  
* **Backend:** Endpoint /api/version y archivo VERSION para rastreo de releases.  
* **Orquestación:** Archivo docker-compose.yml para gestionar servicios y volúmenes de forma declarativa.

### **Cambiado**

* **Arquitectura:** Eliminada la dependencia de construcción local (Dockerfile). Ahora se usa la imagen oficial python:3.11-slim directamente con instalación de dependencias en tiempo de ejecución.  
* **Persistencia:** Migración de almacenamiento de configuración a volumen mapeado ./mfm\_data.  
* **Documentación:** README.md reescrito para reflejar la nueva arquitectura segura y el uso de scripts automatizados.

### **Corregido**

* Error Conflict: container name already in use en el despliegue al reiniciar la aplicación.  
* Error ReferenceError: require is not defined en el proceso de renderizado de Electron.  
* Incompatibilidad de comandos entre docker-compose (v1) y docker compose (v2).  
* Restaurada la lógica de monitoreo de procesos /proc que se había omitido temporalmente durante la fase de implementación de cifrado.

## **\[0.5.0\] \- 2025-11-24**

### **Añadido**

* Integración básica con API de Google Gemini (modelo gemini-2.5-flash).  
* Funcionalidad de monitoreo de procesos mediante lectura de /proc en host Linux.  
* Interfaz flotante transparente básica en Electron.  
* Atajo global Ctrl+Shift+G para visibilidad.

### **Corregido**

* Error de inicialización de driver gráfico Intel (libva) mediante flag \--disable-gpu.  
* Error de importlib.metadata actualizando de Python 3.9 a 3.11.

## **\[0.1.0\] \- 2025-11-24**

### **Añadido**

* Estructura inicial del proyecto.  
* Dockerfile básico.  
* Servidor Flask "Hello World".
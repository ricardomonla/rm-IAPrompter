# **Asistente de Escritorio MFM (Modelo Funcional Mínimo)**

El **MFM** es un asistente de escritorio seguro, flotante y portátil diseñado para desarrolladores. Integra consultas de programación potenciadas por IA (**Gemini**) y capacidades de monitoreo del sistema en tiempo real, todo orquestado mediante contenedores.

El proyecto utiliza una arquitectura de microservicios:

1. **Backend:** API Flask ejecutándose en Docker (Python 3.11) con cifrado de grado militar (Fernet) y persistencia de datos.  
2. **Frontend:** Interfaz de escritorio construida con Electron, con diseño transparente, sistema de pestañas y pantalla de bloqueo de seguridad.

## **🚀 Características Principales**

* **🔒 Seguridad Primero:** Las API Keys nunca se guardan en texto plano. Se cifran y almacenan en .env utilizando una "Clave Maestra" que solo el usuario conoce.  
* **🐳 Portabilidad Total:** Uso de **Docker Compose** para orquestar el entorno sin depender de instalaciones locales de Python ni dependencias complejas.  
* **💾 Persistencia de Datos:** Guarda configuraciones, historial y preferencias en un volumen local (./mfm\_data).  
* **⚡ Modo Dual:** Interfaz moderna con pestañas para cambiar rápidamente entre **"Chat IA"** y **"Monitor de Procesos"**.  
* **🤖 Despliegue Inteligente:** Incluye un script app-run.sh que gestiona todo el ciclo de vida: configuración inicial, cifrado de credenciales, levantamiento de servicios y limpieza al cerrar.  
* **👀 Monitoreo Real:** Capacidad de verificar procesos activos en el Host Linux mediante el mapeo de /proc.

## **📋 Requisitos del Host**

* **Sistema Operativo:** Linux (Requerido para la funcionalidad de monitoreo de procesos /proc).  
* **Docker & Docker Compose:** Instalados y en ejecución.  
* **Node.js y npm:** Necesarios para ejecutar la interfaz gráfica de Electron.

## **🛠️ Instalación y Ejecución Rápida**

Olvídate de ejecutar comandos de Docker manualmente. El script maestro se encarga de la configuración, seguridad y despliegue.

### **1\. Preparación**

Asegúrate de estar en la carpeta raíz del proyecto y de que el script tenga permisos de ejecución:

chmod \+x app-run.sh

### **2\. Ejecutar el Asistente**

Lanza todo el sistema con un solo comando:

./app-run.sh

### **3\. Configuración de Seguridad (Solo la primera vez)**

Si es tu primera ejecución, el script detectará que no tienes credenciales cifradas y iniciará el asistente de seguridad en la terminal:

1. **API Key Real:** Te pedirá tu API Key de Gemini (obtenida en Google AI Studio).  
2. **Clave Maestra:** Te pedirá crear una contraseña personal. **¡Recuérdala\!** La necesitarás cada vez que inicies la app.  
3. **Cifrado Automático:** El script cifrará tu API Key y generará el archivo .env seguro (GEMINI\_API\_KEY\_ENCRYPTED).

## **🖥️ Guía de Uso**

### **1\. Desbloqueo del Sistema (Login)**

Al iniciar la interfaz gráfica, verás una pantalla de **"Acceso Restringido"**.

* Introduce la **Clave Maestra** que creaste durante la instalación.  
* Esto envía la clave al backend para descifrar la API Key en memoria y habilitar la conexión con Google Gemini.

### **2\. Pestaña: IA Chat**

* Selecciona la pestaña **"IA Chat"**.  
* Escribe consultas técnicas o de programación (ej: *"Explica el patrón Singleton en Python"*).  
* El indicador visual (QR) cambiará de color:  
  * 🔵 **Azul:** Pensando/Procesando.  
  * 🟢 **Verde:** Respuesta exitosa.  
  * 🔴 **Rojo:** Error.

### **3\. Pestaña: Monitor**

* Selecciona la pestaña **"Monitor"**.  
* Escribe el nombre exacto de un proceso de Linux (ej: dockerd, bash, code, firefox).  
* El sistema verificará en tiempo real si ese proceso está activo en tu máquina anfitriona.

## **🔧 Arquitectura Técnica**

### **Estructura de Archivos**

* **app-run.sh**: Script maestro. Detecta versiones de Docker, gestiona el cifrado de claves, auto-repara conflictos de contenedores y lanza la app.  
* **docker-compose.yml**: Define el servicio backend, redes y volúmenes. Usa la imagen oficial python:3.11-slim.  
* **app.py**: Backend Flask. Contiene la lógica de cifrado Fernet, endpoints de la API de Gemini y lectura del sistema de archivos /host/proc.  
* **electron-interface/**: Código fuente del frontend (HTML/CSS/JS).

### **Volúmenes Docker Configuradas**

* /proc:/host/proc:ro: **(Solo Lectura)** Permite al contenedor inspeccionar los procesos del host.  
* ./app.py:/app/app.py: Mapeo de código en vivo para desarrollo.  
* ./mfm\_data:/app/data: Persistencia de datos (configuración JSON) fuera del contenedor.

## **📡 Endpoints de la API**

El backend se expone localmente en http://localhost:5000.

| Método | Endpoint | Descripción |
| :---- | :---- | :---- |
| **POST** | /api/initialize | Recibe la master\_key para desbloquear el sistema y descifrar la API Key. |
| **GET** | /api/is\_initialized | Verifica si el sistema ya ha sido desbloqueado. |
| **POST** | /api/query\_gemini | Envía una consulta a la IA (Protegido). |
| **GET** | /api/check\_process | Verifica si un proceso existe por nombre (Protegido). |
| **GET** | /api/get\_config | Carga la configuración persistente del usuario. |
| **POST** | /api/save\_config | Guarda preferencias en el volumen persistente. |

## **❓ Solución de Problemas**

Error: "Docker Compose not found"  
El script app-run.sh intenta detectar automáticamente docker-compose o docker compose. Si falla, asegúrate de tener Docker Desktop o Docker Engine actualizado.  
Error: "Conflict. The container name is already in use"  
El script tiene una función de auto-reparación integrada. Simplemente ejecútalo de nuevo y limpiará los contenedores antiguos automáticamente.  
**La ventana aparece pero dice "Backend desconectado"**

1. Verifica que Docker esté corriendo (docker ps).  
2. Asegúrate de haber introducido correctamente la Clave Maestra.  
3. Revisa los logs del backend: docker logs mfm-backend.
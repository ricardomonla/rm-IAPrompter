# **Asistente de Escritorio MFM (Modelo Funcional Mínimo)**

El **MFM** es un asistente de escritorio seguro, flotante y portátil diseñado para desarrolladores. Integra consultas de programación potenciadas por IA (**Gemini**) y capacidades de monitoreo del sistema en tiempo real, todo orquestado mediante contenedores.  
El proyecto utiliza una arquitectura de microservicios:

1. **Backend:** API Flask ejecutándose en Docker (Python 3.11) con cifrado de grado militar (Fernet) y persistencia de datos.  
2. **Frontend:** Interfaz de escritorio construida con Electron, con diseño transparente, sistema de pestañas y pantalla de bloqueo de seguridad.

## **🚀 Características Principales**

* **🔒 Seguridad Primero:** Las API Keys nunca se guardan en texto plano. Se cifran y almacenan en .env utilizando una "Clave Maestra" que solo el usuario conoce.  
* **🐳 Portabilidad Total:** Uso de **Docker Compose** para orquestar el entorno sin depender de instalaciones locales de Python ni dependencias complejas.  
* **💾 Persistencia de Datos:** Guarda configuraciones, historial y preferencias en un volumen local (./app-data).  
* **⚡ Modos de Vista Adaptativos:**  
  * **Modo Mini:** Icono discreto (Cara Robótica) anclado en la esquina inferior derecha.  
  * **Modo Compacto:** Ventana emergente para consultas rápidas y login.  
  * **Modo Expandido:** Ventana centrada de gran tamaño para trabajo intensivo.  
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

*Para ver logs y depurar errores, usa: ./app-run.sh \--debug*

### **3\. Configuración de Seguridad (Solo la primera vez)**

Si es tu primera ejecución, el script detectará que no tienes credenciales cifradas y iniciará el asistente de seguridad en la terminal:

1. **API Key Real:** Te pedirá tu API Key de Gemini (obtenida en Google AI Studio).  
2. **Clave Maestra:** Te pedirá crear una contraseña personal. **¡Recuérdala\!** La necesitarás cada vez que inicies la app.  
3. **Cifrado Automático:** El script cifrará tu API Key y generará el archivo .env seguro (GEMINI\_API\_KEY\_ENCRYPTED).

## **🖥️ Guía de Uso**

### **1\. Desbloqueo del Sistema (Login)**

Al iniciar, la ventana aparecerá en **Modo Compacto** en la esquina inferior derecha con una pantalla de "Acceso Restringido".

* Introduce tu **Clave Maestra**.  
* Al desbloquear, el asistente se minimizará automáticamente al **Modo Mini** (icono flotante) para no estorbar.

### **2\. Interacción con Modos**

El asistente vive en la esquina inferior derecha, justo encima de la barra de tareas.

* **Clic en la Cara:** Alterna entre los modos:  
  * **Mini** \-\> **Compacto** (Consulta rápida) \-\> **Expandido** (Pantalla centrada) \-\> **Mini**.  
* **Botón 'X':** Minimiza inmediatamente al Modo Mini.

### **3\. Funcionalidades (Pestañas)**

* **IA Chat:** Escribe consultas técnicas. El indicador visual cambiará de color (Azul=Pensando, Verde=Éxito, Rojo=Error).  
* **Monitor:** Escribe el nombre de un proceso de Linux (ej: dockerd, bash) para verificar si está corriendo en tu máquina.

## **🔧 Arquitectura Técnica**

### **Estructura de Archivos**

* **app-run.sh**: Script maestro de orquestación.  
* **docker-compose.yml**: Define el servicio backend y los volúmenes.  
* **app.py**: Backend Flask (Cifrado, Gemini, Sistema).  
* **app-interface/**: Código fuente del frontend (Electron).  
* **app-data/**: Directorio local donde se persisten los datos del usuario.

### **Volúmenes Docker**

* /proc:/host/proc:ro: **(Solo Lectura)** Permite al contenedor inspeccionar los procesos del host.  
* ./app.py:/app/app.py: Mapeo de código en vivo para desarrollo.  
* ./app-data:/app/data: Persistencia de datos (configuración JSON) fuera del contenedor.

## **❓ Solución de Problemas**

La ventana no aparece o no responde a clics  
Ejecuta ./app-run.sh \--debug para abrir la consola de desarrollador y ver si hay errores de JavaScript o bloqueos de IPC.  
Error: "Conflict. The container name is already in use"  
El script tiene auto-reparación. Ejecútalo de nuevo y limpiará el contenedor conflictivo.  
**La ventana aparece pero dice "Backend desconectado"**

1. Verifica que Docker esté corriendo (docker ps).  
2. Revisa los logs del backend: docker logs mfm-backend.
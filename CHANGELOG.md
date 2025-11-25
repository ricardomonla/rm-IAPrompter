# **Changelog**

Todos los cambios notables en el proyecto **Asistente de Escritorio MFM** se documentarán en este archivo.  
El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## **\[0.8.2\] \- 2025-11-25**

### **Añadido**

* **Usabilidad:** Implementación de posicionamiento fijo inteligente en la esquina inferior derecha, respetando automáticamente el área de la barra de tareas.
* **Interfaz:** Ciclo de 3 modos de vista (Mini, Compacto, Expandido) activado mediante clic en el asistente.
* **Debugging:** Soporte para flag \--debug en app-run.sh que activa logs verbose y DevTools.
* **Documentación:** Archivo app-docs/02_mis-prompts.md con colección de prompts utilizados en el desarrollo.

### **Cambiado**

* **Refactorización:** Renombrado del directorio electron-interface a app-interface para mayor claridad.  
* **Refactorización:** Renombrado del directorio mfm\_data a app-data para consistencia.  
* **UX Simplificada:** Eliminada la funcionalidad de arrastre libre (Drag & Drop) en favor de una experiencia más estable y predecible con anclaje fijo.  
* **Mantenimiento:** Optimizado el archivo .gitignore con patrones completos para Python, Node.js/Electron y mejores prácticas de organización.

### **Corregido**

* **Inconsistencia de Rutas:** Sincronización de nombres de directorios entre app-run.sh, docker-compose.yml y documentación.  
* **Login:** Solucionado error de condición de carrera que impedía hacer clic después de desbloquear la aplicación.  
* **Estabilidad:** Corregido bucle de eventos en la gestión de estados de ventana de Electron.

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
* **Orquestación:** Archivo docker-compose.yml para gestionar servicios y volúmenes de forma declarativa.

### **Cambiado**

* **Arquitectura:** Eliminada la dependencia de construcción local (Dockerfile). Ahora se usa la imagen oficial python:3.11-slim.  
* **Persistencia:** Migración de almacenamiento de configuración a volumen mapeado.

## **\[0.5.0\] \- 2025-11-24**

### **Añadido**

* Integración básica con API de Google Gemini.  
* Funcionalidad de monitoreo de procesos mediante lectura de /proc.  
* Interfaz flotante transparente básica en Electron.

## **\[0.1.0\] \- 2025-11-24**

### **Añadido**

* Estructura inicial del proyecto.  
* Servidor Flask "Hello World".
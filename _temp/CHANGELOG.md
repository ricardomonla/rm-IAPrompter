# **Changelog**

Todos los cambios notables en el proyecto **Asistente de Escritorio MFM** se documentarán en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [2.4.0] - 2025-11-27

### Añadido

* **Funcionalidad de Pegar desde Portapapeles:** Restaurada la función "Pegar + Analizar" con botón dedicado en la interfaz para insertar contenido del portapapeles y analizarlo con la IA.
* **Opción --restart en Launcher:** Nuevo parámetro `--restart` para detener y reiniciar servicios en un solo comando.
* **Logging Dual Mejorado:** Separación estricta de logs backend/frontend en modo debug con timestamps únicos.
* **Desvinculación Completa en Debug:** El script se desvincula completamente de la consola en modo debug, permitiendo cerrar la terminal.

### Cambiado

* **Optimización del Script Launcher:** Refactorización completa de `app-run.sh` con funciones reutilizables, mejor manejo de errores y estructura modular (versión v0.9.1).
* **Actualización de Electron:** De v38.7.1 a v39.2.4 para compatibilidad con Node.js v22.
* **Interfaz Mejorada:** Ajustes en layout del editor para incluir botón de portapapeles.

### Corregido

* **Bug de Foco en Interfaz:** Resuelto crash en arranque causado por incompatibilidad de versiones, permitiendo funcionamiento correcto de eventos de minimización al perder foco.
* **Incompatibilidad Node.js/Electron:** Corregida la carga de APIs de Electron mediante actualización de versión.

## [2.2.0] - 2025-11-27

### Añadido

* **Layout Master-Detail:** Nuevo diseño con panel de visor (izquierda) y editor (derecha) para mejor experiencia de redacción.
* **Historial de Consultas:** Panel lateral con lista de consultas anteriores, navegación intuitiva.
* **Interfaz Mejorada:** Ventana expandida por defecto, mejor estética del foco en textarea, título actualizado a v2.2.
* **Navegación por Teclado:** Enter para enviar, Shift+Enter para salto de línea en el editor.

### Cambiado

* **Versión de la Interfaz:** Actualizada a v2.2.0 en package.json y main.js.

## [2.3.0] - 2025-11-27

### Añadido

* **Modo Desacoplado (Detached Mode):** El launcher `app-run.sh` ahora opera en modo asíncrono, liberando la terminal inmediatamente después de iniciar la aplicación. Permite cerrar la terminal sin interrumpir el funcionamiento del asistente.
* **Opción de Parada Segura:** Nuevo parámetro `--stop` (o `-s`) para detener ordenadamente todos los servicios activos (interfaz Electron y contenedores Docker).

### Cambiado

* **Actualización del Orquestador:** Script `app-run.sh` actualizado a versión v0.9.0 con verificación inteligente de servicios en ejecución, evitando reinicios innecesarios del backend y simplificación del flujo de lanzamiento.

### Removido

* **Limpieza de Documentación:** Eliminado archivo obsoleto `app-docs/02_mis-prompts.md` (prompt anterior para gestión de changelog).


## **[1.2.1] - 2025-11-27**

### **Corregido**

* Corrección en `app-run.sh` para permitir la ejecución del script desde fuera del directorio.

## **[1.2.0] - 2025-11-25**

### **Añadido**

* **Soporte Docker Completo:** Integración con Docker Compose y Dockerfile para despliegue optimizado y contenedorización del backend Flask.
* **Sistema de Logging Avanzado:** Logging a archivos en la carpeta `app-logs/` para debugging, monitoreo y trazabilidad de operaciones.
* **Documentación del Proyecto:** Carpeta `app-docs/` con prompts iniciales, guías de uso y documentación técnica.
* **Reorganización de Directorios:** Optimización de la estructura del proyecto con directorios dedicados (`app-data/`, `app-interface/`, `app-logs/`, `app-docs/`) para mejor mantenibilidad.
* **Archivo .dockerignore:** Exclusión de archivos innecesarios en la construcción de imágenes Docker.

## **[1.1.0] - 2025-11-25**

### **Añadido**

* **Menú de Autocompletado:** Implementado un menú visual flotante al escribir `//` en el input. Permite seleccionar comandos (`/clear`, `/reset`) usando las flechas del teclado y Enter.
* **Experiencia de Terminal:** Navegación fluida entre sugerencias sin perder el foco del input.

## **[1.0.0] - 2025-11-25**

### **Añadido**

* **Persistencia de Sesión:** El historial de chat ahora se guarda automáticamente en `localStorage`. La conversación se restaura al reiniciar la aplicación.
* **Comandos Slash:**
    * `/clear`: Limpia la pantalla visualmente pero mantiene la memoria de la sesión.
    * `/reset`: Realiza un borrado completo (Hard Reset) del historial visual y de la memoria local.
* **Copiado Inteligente:** Cada bloque de código generado por la IA ahora incluye un botón flotante **"Copiar"** en la esquina superior derecha.
* **Exportación:** Botón 💾 para descargar la conversación completa como un archivo Markdown (`.md`) con fecha y hora.

### **Cambiado**

* **Refactorización:** Limpieza general del código JS para soportar modularidad.

## **[0.9.9] - 2025-11-25**

### **Añadido**

* **Renderizado Rico:** Integración de `marked.js` para visualizar Markdown (negritas, listas, tablas) en las respuestas.
* **Syntax Highlighting:** Integración de `highlight.js` con el tema *Atom One Dark* para colorear bloques de código automáticamente.
* **Historial de Comandos:** Navegación tipo terminal (Flecha Arriba/Abajo) en el input para recuperar consultas anteriores.
* **Análisis de Portapapeles:** Botón 📋 ("Pegar y Analizar") que lee el portapapeles y prepara una consulta automática para la IA.

### **Corregido**

* **Conflicto Electron/CDN:** Solucionado el bug crítico donde las librerías externas fallaban al cargar debido a la presencia de `module.exports` en el entorno de Electron.

## **[0.9.8] - 2025-11-25**

### **Añadido**

* **Auto-Minimizar:** La aplicación ahora detecta cuando pierde el foco (clic fuera de la ventana) y se reduce automáticamente al modo "Mini" (Hexágono).

## **[0.9.7] - 2025-11-25**

### **Añadido**

* **Zoom Dinámico:** Control de tamaño de fuente mediante `Ctrl + Scroll` del mouse, ajustando la legibilidad sin romper el layout.

---

## **[0.9.6] - 2025-11-25**

### **Añadido**

* **Identidad Visual:** Nuevo diseño de **"Núcleo Hexagonal"** animado en SVG.
* **Layout:** Nueva disposición **"Side-by-Side" (Lado a Lado)**.

### **Cambiado**

* **Estabilidad UX:** Eliminadas las transiciones CSS de tamaño para corregir saltos visuales en Linux.
* **Modo Mini:** Ajustado a **60x60px**.

## **[0.8.7] - 2025-11-25**

### **Añadido**

* **Debug:** Soporte robusto para logging a archivo con `./app-run.sh --debug`.

## **[0.8.1] - 2025-11-25**

### **Añadido**

* **Seguridad:** Cifrado Fernet (AES) para API Keys.
* **Despliegue:** Script maestro `app-run.sh`.

## **[0.1.0] - 2025-11-24**

### **Añadido**

* Estructura inicial del proyecto (Flask + Electron).
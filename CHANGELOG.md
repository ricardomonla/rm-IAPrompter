# **Changelog**

Todos los cambios notables en el proyecto **Asistente de Escritorio MFM** se documentarán en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### **Añadido**

* **Refactorización Completa del Sistema de Plantillas:** Implementada migración completa del sistema modal a navegación directa tipo carrusel con barra de herramientas.
    * **Nueva Interfaz:** Eliminación del botón de configuración (⚙) y reemplazo por barra de herramientas horizontal con 6 botones funcionales.
    * **Navegación Directa:** Sistema de carrusel para navegar entre plantillas con botones `//`, `<`, `>`, `✎`, `❐`.
    * **Edición In-Place:** Modo de edición implementado directamente en el textarea sin necesidad de modales.
    * **Toggle de Edición:** Un solo botón funciona como editar/guardar (`✎` ↔ `💾`) con deshabilitación automática de otros controles durante edición.
    * **Backend Enhancement:** Agregados 4 nuevos endpoints API (`/api/get_templates`, `/api/save_templates`, `/api/add_template`, `/api/delete_template`) para gestión completa de plantillas.
    * **Frontend Refactoring:** Modificado `app-interface/index.html` para usar llamadas API asíncronas en lugar de operaciones de archivos locales.
    * **Data Persistence:** Unificada la gestión de datos en el directorio `app-data/` junto con `config.json`.
    * **API Security:** Integrados nuevos endpoints en el sistema de autenticación sin requerir inicialización de API.

### **Corregido**

* **Bug Crítico del Toggle de Edición:** Solucionado problema donde el botón de editar/guardado no regresaba correctamente al modo lectura.
    * **Lógica de Estado:** Corregida la función `toggleEditMode()` para eliminar conflictos de estado y referencias obsoletas.
    * **Referencias Obsoletas:** Eliminadas todas las referencias a `ui.saveTemplateBtn` (botón eliminado) que causaban errores.
    * **Validación de Guardado:** Mejorado el manejo de errores en la función `saveCurrentTemplate()`.
    * **Feedback Visual:** Implementados logs de debug para monitoreo del estado de edición.

### **Cambiado**

* **Optimización de Interfaz:** Eliminación del botón redundante de guardado para interfaz más limpia.
* **Estados de Botones:** Implementado sistema de deshabilitación visual y funcional durante el modo edición.
* **Persistencia de Datos:** Migración completa de plantillas de prompts desde `app-interface/mfm_templates.json` hacia `app-data/templates.json` para centralizar persistencia de datos.

## **[3.0.1] - 2025-12-02**

### **Cambiado**

* **Actualización de Dependencias:** Cambiada la versión de Electron a 18.3.15 para compatibilidad con Node 18, y ajustados los engines en package.json.
* **Script de Inicio:** Modificaciones en `app-run.sh` para mejorar el manejo de logs y procesos en background.
* **Configuración Docker:** Ajustes en `docker-compose.yml` para optimización del contenedor backend.
* **Interfaz de Usuario:** Actualizaciones en `main.js` para usar destructuring de módulos Electron y cambio a `app.on('ready')` en lugar de `app.whenReady().then()`.
* **Archivos de Interfaz:** Modificaciones en `index.html`, adición de `mfm_templates.json` y `styles.css` para nuevas funcionalidades.
* **Control de Versiones:** Actualizado `.gitignore` para excluir archivos temporales adicionales.

### **Corregido**

* **Compatibilidad Electron:** Intentos de corrección para problemas de carga de APIs en el entorno actual (pendiente de verificación en otros sistemas).

## **[3.0.0] - 2025-12-01**

### **Añadido**

* **Refactorización Mayor del Layout:** Implementado diseño modular de 3 sectores.
    * **Sector 1 (Izquierda):** Panel de visualización exclusivo para respuestas de la IA (65% ancho).
    * **Sector 2 (Superior Derecha):** Área de cabeceras con autocompletado activado por `//` para seleccionar plantillas.
    * **Sector 3 (Inferior Derecha):** Editor dedicado para el cuerpo del prompt (35% ancho total derecho).
* **Autocompletado de Cabeceras:** Menú flotante con plantillas predefinidas al escribir `//` en el sector de cabeceras.
* **Renderizado Limpio:** La visualización ahora muestra únicamente la respuesta de la IA, ocultando el prompt del usuario para una salida más limpia.
* **Botones de Copia Mejorados:** Funcionalidad de copiar código con feedback visual.

### **Cambiado**

* **Eliminación del Historial Visual:** Removido el panel de historial; la sesión se maneja internamente sin mostrar historial en la UI.
* **Título de la Aplicación:** Actualizado a "MFM Assistant v3.0 - Modular Layout".
* **Comentarios de Versión:** Actualizados en `main.js` a v3.0.0.

### **Corregido**

* **Compatibilidad de Layout:** Ajustes en CSS para el nuevo diseño de 3 sectores, optimizando el uso del espacio.

## **[2.4.1] - 2025-11-28**

### **Añadido**

* **Restauración de Funcionalidades Perdidas:** Re-implementadas características de la versión 1.x en la interfaz 2.x.
    * **Análisis Automático de Portapapeles:** El botón 📋 PEGAR ahora prepara consulta automática con contenido del portapapeles y la envía directamente a la IA.
    * **Comandos Slash:** Restaurados `/clear` (limpia pantalla manteniendo historial) y `/reset` (reinicio completo).
    * **Exportación de Conversaciones:** Botón 💾 EXPORTAR en panel de historial para descargar conversación como Markdown.
    * **Menú de Autocompletado:** Al escribir `//` aparece menú flotante para comandos, navegable con flechas.

### **Corregido**

* **Bug de Auto-Minimización:** Removida la ocultación automática al perder foco para prevenir desaparición de la app dejando solo el hexágono.

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
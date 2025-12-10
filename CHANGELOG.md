# **Changelog**

Todos los cambios notables en el proyecto **rm-IAPrompter** se documentarán en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.1.12] - 2025-12-10

### **Cambiado**

* **Reorganización de Archivos:** Movidos `app-flask.py` y `app-version.js` al directorio `app-data/` para centralizar todos los archivos de datos y configuración.
  * **Actualización de Referencias:** Modificados `app-run.sh`, `docker-compose.yml` y `Dockerfile` para reflejar las nuevas ubicaciones de los archivos.
  * **Versionado Individual:** Incrementadas versiones en encabezados de archivos modificados (`app-run.sh` v1.0.6, `docker-compose.yml` 1.0.3, `Dockerfile` 1.0.2).
  * **Compatibilidad Mantenida:** La aplicación continúa funcionando correctamente con la nueva estructura de directorios.

## [3.1.11] - 2025-12-07

### **Mejorado**

* **Script de Lanzamiento Mejorado:** Implementadas nuevas opciones de reinicio selectivo para componentes individuales.
    * **Reinicio de Frontend:** Opción `--restart-frontend` para detener e iniciar únicamente la interfaz Electron.
    * **Reinicio de Backend:** Opción `--restart-backend` para detener e iniciar únicamente el contenedor Docker del backend.
    * **Modo Debug Combinable:** El flag `--debug` puede combinarse con cualquier opción de reinicio para ejecutar en modo debug con logging activo.
    * **Ayuda Integrada:** Añadida función `show_usage()` con opciones `-h` y `--help` para mostrar ayuda detallada y ejemplos de uso.

## [3.1.10] - 2025-12-07

### **Corregido**

* **Lógica de Reinicio en Script de Lanzamiento:** Implementada funcionalidad para el flag `--restart` que detiene instancias previas de la aplicación antes de iniciar nuevas.
    * **Terminación Graceful:** Añadida llamada a `stop_services()` cuando se usa `--restart`, previniendo elementos visuales superpuestos como hexágonos múltiples.
    * **Estabilidad Mejorada:** La aplicación ahora reinicia correctamente sin instancias residuales ejecutándose en segundo plano.

## [3.1.9] - 2025-12-07

### **Mejorado**

* **Generación Estructurada de Prompts:** Implementada generación de prompts con formato estandarizado de 4 secciones obligatorias.
    * **Secciones Estructuradas:** Los prompts generados ahora incluyen siempre [ROLE], [INSTRUCTIONS], [OUTPUT FORMAT], [USER REQUEST].
    * **Arquitectura de Prompts:** Modificada función `sendAI()` en `index.html` para inyectar meta-instrucciones invisibles al usuario.
    * **Consistencia Mejorada:** Todos los prompts generados siguen un formato técnico optimizado para mejores resultados de IA.

### **Corregido**

* **Scrollbar Vertical en Panel de Resultados:** Implementada regla CSS `overflow-y: scroll;` para mostrar scrollbar vertical de manera consistente.
    * **Visibilidad Mejorada:** El scrollbar ahora es siempre visible, facilitando la navegación en contenido largo.
    * **Experiencia de Usuario:** Eliminada la dependencia del contenido para mostrar el scrollbar.

## [3.1.8] - 2025-12-07

### **Mejorado**

* **Funcionalidad de Exportación Markdown:** Mejorada la exportación >>MD para solicitar ubicación de guardado al usuario y sugerir nombre de archivo personalizado.
    * **Diálogo de Guardado:** Implementado diálogo nativo de selección de archivo en lugar de guardado automático en directorio Descargas.
    * **Nombre de Archivo Sugerido:** Actualizado formato a `YYYYMMDD-HHMM_TítuloPrompt.md` utilizando el título de la plantilla actual.
    * **Función getCurrentDocumentTitle():** Añadida función para obtener el título del documento actual basado en la etiqueta de la plantilla activa.
    * **Compatibilidad:** Mantenida funcionalidad de exportación TXT sin modificaciones.

## [3.1.7] - 2025-12-06

### **Corregido**

* **Lógica de Cambio de Modos:** Solucionado problema crítico de variable `app` redeclarada que causaba fallo de inicio de la aplicación.
    * **Conflicto de Variables:** Eliminada redeclaración de `app` en el handler IPC `save-file` que causaba `TypeError: Cannot read properties of undefined (reading 'on')`.
    * **Estabilidad Mejorada:** Aplicación ahora inicia correctamente sin errores de Electron.
    * **Funcionalidad de Modos:** Mantenida la lógica de cambio automático entre modo mini y expandido al perder/ganar foco.

## [3.1.6] - 2025-12-06

### **Cambiado**

* **Rebranding de la Aplicación:** Actualización del nombre del launcher de "MFM Assistant" a "rm-IAPrompter" para consistencia con el nombre del proyecto.
    * **Renombrado del Contenedor:** Cambiado el nombre del contenedor Docker de "mfm-backend" a "rm-iaprompter-backend".
    * **Actualización de Referencias:** Modificados `app-run.sh` y `docker-compose.yml` para reflejar los nuevos nombres.
    * **Versionado Individual:** Incrementadas versiones en encabezados de archivos modificados (`app-run.sh` v1.0.3, `docker-compose.yml` 1.0.2).

## [3.1.5] - 2025-12-06

### **Cambiado**

* **Renombrado de Archivo Backend:** Archivo `app.py` renombrado a `app-flask.py` para seguir el estándar de nomenclatura `app-*`.
    * **Actualización de Referencias:** Modificados `docker-compose.yml`, `Dockerfile`, `app-version.js` y `CHANGELOG.md` para reflejar el nuevo nombre.
    * **Versionado Individual:** Incrementadas versiones en encabezados de archivos modificados (`app-flask.py` v0.9.1, `app-version.js` 3.1.5, `docker-compose.yml` 1.0.1, `Dockerfile` 1.0.1).

## [Unreleased]

### **Mejorado**

* **Scrollbar Vertical para PromptResultante:** Implementada regla CSS `overflow-y: auto;` en la clase `.PromptResultante` para mostrar scrollbar vertical cuando el contenido exceda el área visible, solucionando problemas de desbordamiento de contenido.

### **Añadido**

* **Sistema Centralizado de Versionado:** Implementado `app-version.js` como archivo maestro de versionado.
    * **Historial Completo:** Registro de todas las versiones con cambios detallados.
    * **Archivos de Referencia:** Lista de archivos que requieren actualización manual vs automática.
    * **Funciones Utilitarias:** Validación de versiones, obtención de información de versión.
    * **Pseudo-código Documentado:** Instrucciones claras para futuras actualizaciones de versión.
    * **Clarificación de Versionado:** Documentación explícita sobre la distinción entre versionado individual de archivos y versionado general de la aplicación.

* **Reestructuración Completa del Layout:** Implementado diseño de dos paneles principales con armonía visual.
    * **Panel Izquierdo:** Área completa dedicada a "Prompt Resultante" con título de aplicación centrado y botón de exportación.
    * **Panel Derecho:** Dos secciones de igual altura: "Contexto y Esperado" y "Solicitud".
    * **Armonía Visual:** Todas las secciones siguen el mismo patrón estético con etiquetas, barras de herramientas y áreas de contenido.
    * **Nombre de Aplicación:** Actualizado dinámicamente desde sistema de versionado centralizado.

* **Estandarización de Encabezados:** Implementados encabezados uniformes en todos los archivos principales de la aplicación.
    * **Archivos Actualizados:** `app-run.sh`, `app-flask.py`, `app-version.js`, `app-interface/main.js`, `app-interface/index.html`, `app-interface/styles.css`, `docker-compose.yml`, `Dockerfile`, `README.md`.
    * **Formato Consistente:** Estructura estandarizada con proyecto, archivo, versión, fecha, autor, email y descripción.
    * **Comentarios Adecuados:** Uso de # para scripts, // para JavaScript, /* */ para CSS, <!-- --> para HTML/Markdown.

### **Cambiado**

* **Interfaz de Usuario:** Modificado `app-interface/index.html` y `app-interface/styles.css` para nuevo layout equilibrado.
* **Script de Inicio:** Actualizado `app-run.sh` para leer versión desde `app-version.js` usando Node.js.
* **Botones de Exportación:** Simplificado a un solo botón ">>MD" en el panel izquierdo.
* **Sistema de Versionado:** Optimizado `app-version.js` con proceso de actualización más detallado y formato de commit estandarizado.
* **Prompt de Commit:** Mejorado `app-prompts/251206-1840_Actu+Commit.md` para coherencia con el sistema de versionado y referencia a `app-version.js`.
* **Nombre de la Aplicación:** Estandarizado el nombre de "rm-IAPromper" a "rm-IAPrompter" en todos los archivos, encabezados, títulos y documentación.

## **[3.1.4] - 2025-12-03**

### **Añadido**

* **Sistema de Exportación de Archivos:** Implementada funcionalidad completa de exportación de prompts generados.
    * **Export a Markdown:** Botón 📄 MD para exportar prompts como archivo .md con formato completo
    * **Export a Texto:** Botón 📝 TXT para exportar prompts como archivo .txt plano
    * **Nombres Automáticos:** Genera nombres de archivo con timestamp (`prompt-export-YYYY-MM-DD-HHMMSS`)
    * **Gestión de Duplicados:** Diálogo de confirmación cuando el archivo ya existe
    * **Feedback Visual:** Indicadores de estado de exportación con colores y animaciones
    * **IPC Integration:** Comunicación completa entre renderer y main process para guardar archivos

### **Corregido**

* **Bug Crítico de Modalidad de Edición:** Solucionado problema donde el botón de toggle de edición no regresaba correctamente al modo lectura.
    * **Lógica de Estado:** Corregida la función `toggleEditMode()` para eliminar conflictos de estado
    * **Referencias Obsoletas:** Eliminadas todas las referencias a `ui.saveTemplateBtn` que causaban errores
    * **Deshabilitación Inteligente:** Implementado sistema de deshabilitación automática de botones durante edición
    * **Validación Mejorada:** Mejorado el manejo de errores en `saveCurrentTemplate()`

### **Cambiado**

* **Navegación de Plantillas Mejorada:** Optimizado el sistema de carrusel con mejor manejo de estado
* **Barra de Herramientas:** Refinamiento de la interfaz con estados visuales mejorados
* **API de Plantillas:** Optimización de los 4 endpoints para mejor rendimiento y manejo de errores
* **Persistencia de Datos:** Migración completa de plantillas desde `app-interface/mfm_templates.json` hacia `app-data/templates.json`
* **Feedback Visual:** Implementación de animaciones y estados hover mejorados en toda la interfaz

## **[3.1.3] - 2025-12-01**

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
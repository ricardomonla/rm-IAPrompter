# **Changelog**

Todos los cambios notables en el proyecto **Asistente de Escritorio MFM** se documentarán en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## **\[0.8.8\] \- 2025-11-25**

### **Añadido**

* **Documentación:** Actualización completa del README.md con información de autor, versión actual, características detalladas y guía de solución de problemas.
* **Estandarización:** Cabeceras de autoría y versión añadidas a index.html y app.py.
* **Despliegue:** Creación de Dockerfile para optimizar la construcción de la imagen Docker.
* **Diagnóstico:** Mejora del sistema de logging en app-run.sh con archivos separados para backend y frontend en app-logs/.

### **Cambiado**

* **Orquestación:** docker-compose.yml actualizado para construir desde Dockerfile en lugar de usar imagen base directa, eliminando instalación de dependencias en tiempo de ejecución.
* **Interfaz:** Configuración de DevTools en main.js cambiada a modo 'right' para acoplar la consola de desarrollo y evitar ventanas fantasma.
* **Script Maestro:** app-run.sh actualizado con lógica de logging avanzada y versión 0.8.6.

### **Corregido**

* **Consistencia:** Sincronización de versiones y cabeceras en todos los archivos principales.

## **\[0.8.7\] \- 2025-11-25**

### **Añadido**

* **Estandarización:** Cabeceras de autoría y versión en archivos principales (main.js, app-run.sh).

### **Corregido**

* **Debug:** Modificada la configuración de DevTools en Electron para usar el modo right (acoplado) en lugar de detach, eliminando la confusión visual de una "segunda ventana" al depurar.  
* **Estabilidad Visual:** Eliminada la lógica de transparencia condicional (ignoreMouseEvents) en Linux que causaba inestabilidad en los clics.

## **\[0.8.6\] \- 2025-11-25**

### **Cambiado**

* **Despliegue:** Optimización crítica del arranque. Se migró la instalación de dependencias (pip install) al Dockerfile (tiempo de construcción) en lugar de ejecutarse en cada inicio (tiempo de ejecución). El arranque ahora es instantáneo.

### **Corregido**

* **Diagnóstico:** El script app-run.sh ahora soporta logging completo a archivos (app-logs/backend\_\*.log y frontend\_\*.log) cuando se usa el flag \--debug.

## **\[0.8.2\] \- 2025-11-25**

### **Añadido**

* **Usabilidad:** Implementación de posicionamiento fijo inteligente en la esquina inferior derecha.  
* **Interfaz:** Ciclo de 3 modos de vista (Mini, Compacto, Expandido).

### **Cambiado**

* **Refactorización:** Renombrado de directorios a app-interface y app-data.  
* **UX:** Eliminada funcionalidad de Drag & Drop por estabilidad.
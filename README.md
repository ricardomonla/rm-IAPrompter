# **Asistente de Escritorio MFM (Modelo Funcional Mínimo)**

El **MFM** es un asistente de escritorio seguro, flotante y futurista diseñado para desarrolladores. Integra consultas de programación potenciadas por IA (**Gemini**) y monitoreo del sistema en tiempo real, orquestado mediante contenedores Docker.

**Autor:** Lic. Ricardo MONLA

**Versión Actual:** v0.9.5 (Hex Core Edition)

## **🚀 Características Principales**

* **🔒 Seguridad de Grado Militar:** Las API Keys se cifran con **Fernet (AES)** y solo se descifran en memoria tras introducir tu "Clave Maestra" personal.  
* **⚛️ Núcleo Hexagonal Reactivo:** Una interfaz minimalista basada en un núcleo de energía animado que indica el estado del sistema (Pensando, Éxito, Error, Bloqueado).  
* **🖥️ Diseño "Side-by-Side":** La interfaz de chat se despliega lateralmente a la izquierda del núcleo, maximizando el espacio de pantalla y respetando la barra de tareas.  
* **⚡ Arranque Instantáneo:** Imagen Docker optimizada (python:3.11-slim) con dependencias pre-instaladas.  
* **💾 Persistencia Local:** Tus configuraciones y el historial de chat se guardan en ./app-data.  
* **🤖 Orquestación Total:** El script app-run.sh maneja todo: instalación, cifrado, ejecución y limpieza.

## **🛠️ Instalación y Ejecución**

### **1\. Iniciar**

Asegúrate de estar en Linux y tener Docker instalado.

chmod \+x app-run.sh  
./app-run.sh

### **2\. Modo Debug**

Si necesitas ver qué ocurre "bajo el capó" (logs de backend y frontend \+ consola de desarrollo):

./app-run.sh \--debug

*Los logs se guardarán automáticamente en la carpeta app-logs/.*

### **3\. Primer Uso (Setup de Seguridad)**

La primera vez que lo ejecutes:

1. El script te pedirá tu **API Key de Google Gemini**.  
2. Te pedirá definir una **Clave Maestra**.  
3. Generará un archivo .env cifrado. **Nadie puede usar tu API Key sin tu Clave Maestra.**

## **🎮 Guía de Interacción**

El asistente vive anclado en la **esquina inferior derecha** de tu pantalla.

### **Estados del Núcleo (Hexágono)**

El color del núcleo te indica qué está pasando:

* 🟠 **Naranja (Pulsante):** Sistema Bloqueado. Requiere contraseña.  
* 🔵 **Azul (Giro Rápido):** Pensando / Procesando consulta.  
* 🟢 **Verde:** Tarea completada con éxito.  
* 🔴 **Rojo:** Error de conexión o proceso no encontrado.

### **Modos de Vista**

Haz clic en el Hexágono para ciclar entre modos:

1. **Modo Mini:** Solo el núcleo (60x60px). Discreto y siempre visible.  
2. **Modo Compacto:** Se despliega la barra de chat a la izquierda. Ideal para consultas rápidas.  
3. **Modo Expandido:** Se despliega un panel grande hacia arriba con el historial completo.

### **Pestañas Funcionales**

* **IA CHAT:** Pregunta sobre código, algoritmos o dudas técnicas.  
* **MONITOR:** Escribe el nombre de un proceso (ej: dockerd, code, firefox) para saber si está corriendo en tu máquina.

## **🔧 Arquitectura Técnica**

* **Frontend:** Electron (HTML5/CSS3/JS puro). Comunicación IPC optimizada.  
* **Backend:** Python Flask en Docker.  
* **Comunicación:** REST API en http://localhost:5000.  
* **Sistema de Archivos:**  
  * app-interface/: Código fuente de la UI.  
  * app-data/: Persistencia (JSON).  
  * app-run.sh: Script de gestión.

## **❓ Solución de Problemas**

El asistente "salta" al cambiar de tamaño  
Esto está corregido en la v0.9.5. Asegúrate de estar usando la última versión de main.js que desactiva las animaciones de ventana nativas del sistema operativo.  
"Electron Security Warning" en los logs  
Ignorable. Hemos implementado una política CSP estricta en el index.html para mitigar riesgos, aunque en modo desarrollo (debug) Electron puede seguir emitiendo la advertencia.
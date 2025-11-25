# **Asistente de Escritorio MFM (Modelo Funcional Mínimo)**

El **MFM** es un asistente de escritorio seguro, flotante y portátil diseñado para desarrolladores. Integra consultas de programación potenciadas por IA (**Gemini**) y capacidades de monitoreo del sistema en tiempo real, todo orquestado mediante contenedores.

**Autor:** Lic. Ricardo MONLA

**Versión Actual:** v0.8.7

## **🚀 Características Principales**

* **🔒 Seguridad Primero:** Cifrado Fernet (AES) para API Keys con desbloqueo mediante "Clave Maestra".  
* **⚡ Arranque Instantáneo:** Imagen Docker optimizada con dependencias pre-instaladas.  
* **💾 Persistencia Local:** Datos y configuraciones guardados en ./app-data.  
* **🖥️ UX Adaptativa:**  
  * **Posición Fija:** Siempre anclado en la esquina inferior derecha, respetando la barra de tareas.  
  * **3 Modos:** Mini (Icono), Compacto (Login/Chat), Expandido (Trabajo).  
* **🤖 Orquestación Total:** Script app-run.sh para gestión de ciclo de vida y diagnóstico.

## **🛠️ Instalación y Ejecución**

### **1\. Iniciar el Asistente**

chmod \+x app-run.sh  
./app-run.sh

### **2\. Modo Diagnóstico (Debug)**

Si encuentras problemas, ejecuta el asistente en modo debug para generar logs detallados en la carpeta app-logs/ y ver la consola de desarrollo integrada:

./app-run.sh \--debug

### **3\. Primer Uso**

1. Al iniciar, verás la pantalla de **"Acceso Restringido"** en modo Compacto.  
2. Introduce tu **Clave Maestra** (creada en la instalación).  
3. El asistente se desbloqueará y minimizará al **Modo Mini** (Cara Robótica).  
4. Haz clic en la cara para interactuar o usar los comandos de IA/Monitor.

## **🔧 Arquitectura Técnica**

* **Backend:** Python 3.11 \+ Flask (Dockerizado).  
* **Frontend:** Electron \+ HTML/CSS/JS puro (Sin frameworks pesados).  
* **Comunicación:** HTTP REST (http://localhost:5000).  
* **Seguridad:** cryptography para cifrado de secretos en reposo (.env).

## **❓ Solución de Problemas Comunes**

La ventana de Electron aparece duplicada en modo debug  
No está duplicada. La segunda ventana es la consola de DevTools. En la versión v0.8.7 se ha configurado para aparecer acoplada a la derecha para evitar confusiones.  
No puedo hacer clic en el asistente  
Asegúrate de estar usando la versión v0.8.7 o superior, que corrige la interacción con el ratón en entornos Linux (KDE/Gnome) desactivando la transparencia de eventos.
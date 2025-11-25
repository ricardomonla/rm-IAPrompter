# **Changelog**

Todos los cambios notables en el proyecto **Asistente de Escritorio MFM** se documentarán en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/), y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## **\[0.9.6\] \- 2025-11-25**

### **Añadido**

* **Identidad Visual:** Nuevo diseño de **"Núcleo Hexagonal"** animado en SVG que reemplaza a la cara robótica. Incluye estados de color (Azul/Verde/Rojo/Naranja) y animaciones de giro/pulso.  
* **Layout:** Nueva disposición **"Side-by-Side" (Lado a Lado)**. La barra de chat/input ahora se despliega horizontalmente a la izquierda del núcleo, optimizando el espacio vertical.

### **Cambiado**

* **Estabilidad UX:** Eliminadas las transiciones CSS de tamaño y la interpolación de movimiento de la ventana (setBounds sin animación) para corregir el "salto" visual en Linux. El anclaje en la esquina inferior derecha es ahora sólido e instantáneo.  
* **Modo Mini:** Ajustado el tamaño mini a **60x60px** para contener perfectamente el nuevo núcleo hexagonal.  
* **Login:** Mejorada la experiencia de inicio de sesión con validación mediante tecla Enter y feedback visual en el núcleo (Estado "Locked" en naranja).

### **Corregido**

* **Bug de "Ventana Fantasma":** Configurada la apertura de DevTools en modo right (acoplado) en lugar de detach para evitar confusiones durante el debugging.  
* **Bug de Clics:** Eliminada la propiedad ignoreMouseEvents en Linux que causaba que la ventana dejara de responder a los clics en ciertos modos.

## **\[0.8.7\] \- 2025-11-25**

### **Añadido**

* **Estandarización:** Cabeceras de autoría y versión en archivos principales.  
* **Debug:** Soporte robusto para logging a archivo con ./app-run.sh \--debug.

## **\[0.8.2\] \- 2025-11-25**

### **Añadido**

* **Usabilidad:** Implementación de posicionamiento fijo en la esquina inferior derecha.  
* **Interfaz:** Ciclo de 3 modos de vista (Mini, Compacto, Expandido).

### **Cambiado**

* **Refactorización:** Renombrado de directorios a app-interface y app-data.

## **\[0.8.1\] \- 2025-11-25**

### **Añadido**

* **Seguridad:** Cifrado Fernet (AES) para API Keys.  
* **Despliegue:** Script maestro app-run.sh con auto-reparación.

## **\[0.1.0\] \- 2025-11-24**

### **Añadido**

* Estructura inicial del proyecto (Flask \+ Electron).
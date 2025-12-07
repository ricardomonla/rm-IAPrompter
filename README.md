<!--
  -----------------------------------------------------------------------------
  Project:     rm-IAPrompter
  File:        README.md
  Version:     v3.1.7
  Date:        2025-12-06
  Author:      Lic. Ricardo MONLA
  Email:       rmonla@gmail.com
  Description: Documentación principal del proyecto.
  -----------------------------------------------------------------------------
 -->
# **rm-IAPrompter - AI Prompt Generator**

![Version](https://img.shields.io/badge/version-v3.1.7-blue) ![Status](https://img.shields.io/badge/status-stable-green) ![Author](https://img.shields.io/badge/autor-Lic._Ricardo_MONLA-orange)

**rm-IAPrompter es una aplicación especializada en generar prompts estructurados y efectivos para otros modelos de IA.** Con una interfaz de dos paneles verticales, permite crear, optimizar y gestionar plantillas de prompts con el poder de Gemini AI, todo orquestado mediante contenedores Docker y una interfaz Electron moderna.

---

## **⚖️ Propiedad Intelectual y Licencia**

**© 2025 Lic. Ricardo MONLA. Todos los derechos reservados.**

Este software es propiedad intelectual exclusiva del **Lic. Ricardo MONLA**.

> ⛔ **ADVERTENCIA LEGAL:** Queda estrictamente prohibida la copia, reproducción, distribución, ingeniería inversa o modificación de este código, ya sea total o parcialmente, sin el **consentimiento expreso y por escrito** del autor. El uso no autorizado de este material constituirá una violación a los derechos de autor vigentes.

---

## **🚀 Características Principales (v3.1.7)**

rm-IAPromper está diseñado específicamente para la ingeniería de prompts con las siguientes capacidades:

* **🎯 Generación Especializada de Prompts:** Sistema enfocado en crear prompts estructurados y optimizados para obtener mejores resultados de modelos de IA.
* **📋 Gestión Avanzada de Plantillas:** Sistema de navegación tipo carrusel con barra de herramientas para crear, editar y organizar plantillas.
* **🔄 Persistencia Centralizada:** Todas las plantillas y configuraciones se almacenan en `app-data/` para gestión unificada.
* **🧠 Navegación Inteligente:** Sistema de carrusel con botones `//`, `<`, `>`, `✎`, `❐` y autocompletado por `//`.
* **💾 Edición In-Place:** Modo de edición directa en el textarea con toggle edit/guardar (`✎` ↔ `💾`).
* **📤 Exportación de Archivos:** Funcionalidad completa de exportación a Markdown (.md) y Texto (.txt) con timestamps.
* **💾 Guardado Automático:** Las modificaciones a las plantillas se guardan instantáneamente en el backend.
* **🎨 Visualización Optimizada:** Interfaz de dos paneles diseñada específicamente para el flujo de trabajo de creación de prompts.
* **📋 Copia Fácil:** Funcionalidad de copia rápida para prompts generados y bloques de código.
* **🔐 Seguridad Integrada:** Sistema de cifrado Fernet (AES) para proteger las claves de API y configuraciones sensibles.
* **⚡ API Backend:** 4 endpoints dedicados para gestión completa de plantillas (`get_templates`, `save_templates`, `add_template`, `delete_template`).

## **💎 Características Core**

* **🔒 Seguridad Fernet (AES):** Las API Keys se cifran y solo se desbloquean en memoria con tu "Clave Maestra".
* **⚛️ Núcleo Hexagonal Reactivo:** Indicador de estado animado (Pensando, Éxito, Error, Bloqueado).
* **⚡ Arranque Instantáneo:** Backend Python Flask optimizado en Docker.
* **🎯 Interfaz de Dos Paneles:** Diseño optimizado para la creación de prompts con panel izquierdo para resultados y panel derecho para entrada.
* **🧠 IA Especializada:** Motor de IA configurado específicamente para ingeniería de prompts y optimización.

## **🛠️ Instalación y Ejecución**

### **1. Iniciar**

Asegúrate de estar en Linux, tener Docker instalado y **Node.js v16+** (compatible con Electron).

```bash
chmod +x app-run.sh  
./app-run.sh
````

### **2. Primer Uso (Setup de Seguridad)**

La primera vez que lo ejecutes:

1.  El script te pedirá tu **API Key de Google Gemini**.
2.  Te pedirá definir una **Clave Maestra**.
3.  Generará un archivo `.env` cifrado. **Nadie puede usar tu API sin tu Clave Maestra.**

## **🎮 Guía de Interacción**

### **Interfaz de Dos Paneles**

**Panel Izquierdo - Resultados:**
- Muestra los prompts generados y optimizados
- Incluye funcionalidad de copia rápida para cada bloque

**Panel Derecho - Entrada:**
- **Sección Superior - Contexto del Prompt:** Selecciona y edita plantillas de contexto
- **Sección Inferior - Contenido del Prompt:** Describe tu solicitud específica

### **Navegación de Plantillas (Barra de Herramientas)**

| Acción | Control | Descripción |
| :--- | :--- | :--- |
| **Lista de Plantillas** | Botón `//` | Muestra menú desplegable con todas las plantillas disponibles |
| **Plantilla Anterior** | Botón `<` | Navega a la plantilla anterior en el carrusel |
| **Siguiente Plantilla** | Botón `>` | Navega a la siguiente plantilla en el carrusel |
| **Editar/Guardar** | Botón `✎` / `💾` | Toggle entre modo edición y guardado (deshabilita otros controles durante edición) |
| **Duplicar Plantilla** | Botón `❐` | Crea una copia de la plantilla actual y la agrega al carrusel |

### **Exportación de Prompts (Panel Izquierdo)**

| Acción | Control | Descripción |
| :--- | :--- | :--- |
| **Exportar a Markdown** | Botón 📄 MD | Descarga el prompt generado como archivo .md con formato completo |
| **Exportar a Texto** | Botón 📝 TXT | Descarga el prompt como archivo .txt plano sin formato |
| **Estado de Exportación** | Indicador visual | Muestra el estado de la exportación con colores y mensajes |

### **Estados del Núcleo (Hexágono)**

  * 🟠 **Naranja (Pulsante):** Sistema Bloqueado. Requiere contraseña.
  * 🔵 **Azul (Giro Rápido):** Generando prompt optimizado.
  * 🟢 **Verde:** Prompt generado exitosamente.
  * 🔴 **Rojo:** Error en la generación del prompt.

## **🔧 Arquitectura Técnica**

* **Frontend:** Electron (HTML5/CSS3/JS puro) con inyección de dependencias controlada.
* **Backend:** Python Flask en Docker (Imagen `python:3.11-slim`).
* **Persistencia Centralizada:** 
  - `app-data/config.json` - Configuración global de la aplicación
  - `app-data/templates.json` - Plantillas de prompts y comandos personalizados
  - `localStorage` para sesiones de interfaz de usuario
* **Comunicación:** REST API en `http://localhost:5000` con endpoints dedicados para gestión de plantillas.

---

## **📬 Contacto y Verificación**

Para consultas sobre licencias, permisos de uso o soporte, contactar directamente al autor:

* **Autor:** Lic. Ricardo MONLA
* **Email:** [rmonla]
* **LinkedIn:** [LINK_A_TU_PERFIL_LINKEDIN]
* **GitHub:** [LINK_A_TU_PERFIL_GITHUB]

---

**© 2025 Lic. Ricardo MONLA.**
*Queda rigurosamente prohibida, sin la autorización escrita del titular del copyright, la reproducción total o parcial de esta obra por cualquier medio o procedimiento.*

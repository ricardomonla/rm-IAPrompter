# **Asistente de Escritorio MFM (Modelo Funcional Mínimo)**

![Version](https://img.shields.io/badge/version-v3.0.1-blue) ![Status](https://img.shields.io/badge/status-stable-green) ![Author](https://img.shields.io/badge/autor-Lic._Ricardo_MONLA-orange)

**El MFM es un asistente de escritorio seguro, flotante y futurista diseñado específicamente para desarrolladores.** Integra consultas de programación potenciadas por IA (Gemini) y monitoreo del sistema en tiempo real, todo orquestado mediante contenedores Docker y una interfaz Electron "No-Clip".

---

## **⚖️ Propiedad Intelectual y Licencia**

**© 2025 Lic. Ricardo MONLA. Todos los derechos reservados.**

Este software es propiedad intelectual exclusiva del **Lic. Ricardo MONLA**.

> ⛔ **ADVERTENCIA LEGAL:** Queda estrictamente prohibida la copia, reproducción, distribución, ingeniería inversa o modificación de este código, ya sea total o parcialmente, sin el **consentimiento expreso y por escrito** del autor. El uso no autorizado de este material constituirá una violación a los derechos de autor vigentes.

---

## **🚀 Nuevas Características (v1.1.0)**

El asistente ha evolucionado de un chat simple a una **Suite de Desarrollo**:

* **🧠 Autocompletado de Comandos:** Escribe `//` para desplegar un menú flotante con acciones rápidas y navega con el teclado.
* **💾 Persistencia de Sesión:** Tu conversación se guarda automáticamente. Si cierras la app, al volver todo estará ahí.
* **🎨 Renderizado Rico:** Respuestas con **Markdown** completo y **Syntax Highlighting** (Tema Atom One Dark) para lectura fácil de código.
* **📋 Smart Copy:** Cada bloque de código generado tiene un botón flotante de "Copiar" para extracción rápida sin errores.
* **📤 Exportación:** Descarga tu sesión completa como un archivo Markdown (`.md`) con un solo clic.
* **🔍 Zoom Dinámico:** Ajusta el tamaño de la fuente en tiempo real usando `Ctrl + Scroll`.

## **💎 Características Core**

* **🔒 Seguridad Fernet (AES):** Las API Keys se cifran y solo se desbloquean en memoria con tu "Clave Maestra".
* **⚛️ Núcleo Hexagonal Reactivo:** Indicador de estado animado (Pensando, Éxito, Error, Bloqueado).
* **⚡ Arranque Instantáneo:** Backend Python Flask optimizado en Docker.
* **🛠️ Herramientas Integradas:** Análisis inteligente del portapapeles e historial de comandos tipo terminal (Flechas Arriba/Abajo).

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

### **Atajos y Comandos**

| Acción | Comando / Atajo | Descripción |
| :--- | :--- | :--- |
| **Autocompletar** | Escribe `//` | Despliega menú de comandos (`/clear`, `/reset`). |
| **Historial** | `Flecha Arriba/Abajo` | Navega por tus consultas anteriores. |
| **Zoom** | `Ctrl + Scroll` | Aumenta o reduce el tamaño del texto. |
| **Pegar + Analizar** | Botón `📋` | Pega tu portapapeles y pide a la IA que lo explique. |
| **Exportar** | Botón `💾` | Guarda la charla actual como archivo `.md`. |

### **Comandos de Sistema (Slash Commands)**

  * `/clear`: Limpia la pantalla visualmente (mantiene la memoria de la sesión).
  * `/reset`: **Reinicio total**. Borra historial visual, memoria de la IA y almacenamiento local.

### **Estados del Núcleo (Hexágono)**

  * 🟠 **Naranja (Pulsante):** Sistema Bloqueado. Requiere contraseña.
  * 🔵 **Azul (Giro Rápido):** Pensando / Procesando consulta.
  * 🟢 **Verde:** Tarea completada con éxito.
  * 🔴 **Rojo:** Error de conexión o proceso no encontrado.

## **🔧 Arquitectura Técnica**

* **Frontend:** Electron (HTML5/CSS3/JS puro) con inyección de dependencias controlada.
* **Backend:** Python Flask en Docker (Imagen `python:3.11-slim`).
* **Persistencia:** `localStorage` para sesiones y JSON para configuración global.
* **Comunicación:** REST API en `http://localhost:5000`.

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

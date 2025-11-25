## 🗂️ Estructura del Proyecto MFM por Fases

### Fase 1: Core del Backend en Docker y Pruebas de Sistema

Esta fase sienta las bases de la lógica del asistente y soluciona el desafío más crítico: el acceso del contenedor Docker a la información del sistema del host Linux.

| Objetivo de la Fase | Entregable Clave |
| :--- | :--- |
| Configurar el entorno Docker, crear una API REST básica (Python/Flask o Node.js/Express) y verificar la capacidad de leer los procesos del host (`/proc`). | Contenedor Docker funcional, dos *endpoints* de prueba, `Dockerfile` y scripts de inicio. |

**Prompt Tentativo para la Fase 1:**

```
Eres un especialista en Backend y DevOps. Tu tarea es construir el core de lógica para un asistente de escritorio que se ejecutará en un contenedor Docker en un host Linux.

**REQUERIMIENTOS DEL CORE (MFM):**
1. **Tecnología:** Python con Flask o Node.js con Express (a tu elección, pero justifica).
2. **Entorno:** Crea un `Dockerfile` que empaquete la aplicación y la haga ejecutable.
3. **Comunicación:** El servidor API debe exponerse en un puerto (ej. 5000) para comunicarse con la interfaz (que será una aplicación Electron ejecutándose en el host).
4. **Endpoint de Prueba 1 (Saludo):** Crea un endpoint `/api/status` que devuelva `{"status": "API is operational"}`.
5. **Endpoint de Prueba 2 (Acceso a Host CRÍTICO):** Crea un endpoint `/api/check_host_access` que intente leer el contenido del directorio `/host/proc/` (asumiendo que el contenedor se ejecuta con `-v /proc:/host/proc:ro`). El endpoint debe buscar y devolver el nombre de cualquier proceso que encuentre, o un mensaje de error si no puede acceder.

**ENTREGABLES:**
* El código fuente del servidor API.
* El `Dockerfile`.
* Un `README.md` con los comandos necesarios para construir la imagen, ejecutar el contenedor (incluyendo el mapeo crítico de `/proc`), y probar los dos endpoints usando `curl`.
```

-----

### Fase 2: Esqueleto del Frontend Electron y Comunicación

Esta fase construye la interfaz visible del asistente, implementando las características de ventana flotante y la capacidad de comunicarse con la API de la Fase 1.

| Objetivo de la Fase | Entregable Clave |
| :--- | :--- |
| Crear la aplicación Electron, configurar la ventana transparente/siempre visible, implementar el atajo global de teclado y establecer la conexión HTTP con el core en Docker. | Aplicación Electron básica, ventana transparente flotante, *hotkey* funcional, y una prueba de conexión a la API de la Fase 1. |

**Prompt Tentativo para la Fase 2:**

```
Eres un especialista en desarrollo de aplicaciones de escritorio con Electron (HTML/CSS/JS). Tu tarea es construir la interfaz del asistente, basándote en la API construida en la Fase 1.

**ANÁLISIS DE LA FASE 1:**
* **[Aquí debe analizar el resultado del Prompt 1: puerto expuesto, estructura del Dockerfile, y si la prueba de acceso a /host/proc fue exitosa. Este análisis es VITAL para el siguiente paso.]**

**REQUERIMIENTOS DE LA INTERFAZ (MFM):**
1. **Ventana Flotante:** La aplicación debe crear una ventana **sin bordes** (frameless), **transparente** (passthrough clicks), que se mantenga **siempre visible** (`always-on-top`) y se fije en la esquina inferior derecha de la pantalla.
2. **Diseño Visual:** Utiliza un elemento SVG simple de un **Código QR** como marcador de posición para el asistente visual.
3. **Mecanismo de Invocación:** Configura un **atajo global de teclado** (por simplicidad inicial, usa `Ctrl+Shift+G`). Este atajo debe **mostrar u ocultar** la interfaz flotante (un comportamiento tipo *toggle*).
4. **Comunicación:** Implementa en la interfaz la lógica para enviar un mensaje de prueba al endpoint `/api/status` de la Fase 1 y mostrar la respuesta en un pequeño campo de texto superpuesto al QR.

**ENTREGABLES:**
* El código fuente completo de la aplicación Electron.
* Instrucciones en el `README.md` sobre cómo ejecutar la aplicación.
* Confirmación de que el atajo global y la comunicación con el core de Docker (Fase 1) funcionan correctamente.
```

-----

### Fase 3: Integración del Core de IA (Gemini)

Esta fase integra la funcionalidad principal: las consultas de programación a través de la API de Gemini, utilizando la infraestructura de Docker establecida en la Fase 1.

| Objetivo de la Fase | Entregable Clave |
| :--- | :--- |
| Añadir un *endpoint* a la API de Docker para recibir preguntas y utilizar la API de Gemini para responder con un tono directo y técnico. | Nuevo *endpoint* en el servidor de Docker, función de llamada a Gemini, y manejo de claves de API. |

**Prompt Tentativo para la Fase 3:**

```
Eres un especialista en integración de APIs de IA. Tu tarea es mejorar el core de Docker de la Fase 1, añadiendo la funcionalidad de consulta a Gemini.

**ANÁLISIS DE LA FASE 2:**
* **[Aquí debe analizar el resultado del Prompt 2: qué framework/lenguaje se usó en el backend, la estructura de la API existente, y cómo el frontend espera enviar las consultas.]**

**REQUERIMIENTOS DE LA IA (MFM):**
1. **Nuevo Endpoint:** Crea un nuevo endpoint `/api/query_gemini` que acepte una consulta de texto (string) del frontend.
2. **Integración con Gemini:** Utiliza la API de Gemini (asegúrate de que la biblioteca necesaria esté incluida en el Dockerfile) para procesar la consulta.
3. **Personalidad:** Implementa una instrucción de sistema a la IA para que mantenga un **tono Directo y Técnico**, ideal para responder consultas de programación.
4. **Manejo de Clave:** La clave de API de Gemini debe cargarse desde una variable de entorno en el contenedor Docker.
5. **Respuesta:** El endpoint debe devolver la respuesta de Gemini en un formato JSON simple, como `{"response": "La respuesta de la IA..."}`.

**ENTREGABLES:**
* El código del core backend actualizado, incluyendo la función de Gemini.
* El `Dockerfile` revisado (si se necesita instalar una nueva biblioteca).
* Una prueba de la API con `curl` que demuestre que la IA responde con el tono técnico solicitado.
```

-----

### Fase 4: Implementación de Verificación de Procesos

Esta fase implementa la segunda funcionalidad principal: el monitoreo del estado de una aplicación en desarrollo.

| Objetivo de la Fase | Entregable Clave |
| :--- | :--- |
| Implementar la lógica en el core de Docker para verificar si un proceso con un nombre específico está activo en el host Linux, utilizando el acceso a `/host/proc` asegurado en la Fase 1. | Nuevo *endpoint* en el servidor de Docker, y lógica de monitoreo de procesos. |

**Prompt Tentativo para la Fase 4:**

```
Eres un especialista en lógica de sistemas y acceso a archivos de sistema. Tu tarea es añadir la funcionalidad de monitoreo de procesos al core de Docker.

**ANÁLISIS DE LAS FASES 1 y 3:**
* **[Aquí debe analizar el resultado del Prompt 1: la confirmación de que el acceso a /host/proc funciona. Si falló, este es el momento de corregir el Dockerfile/comando de ejecución.]**
* **[Analizar el Prompt 3: estructura actual del backend.]**

**REQUERIMIENTOS DEL MONITOREO (MFM):**
1. **Nuevo Endpoint:** Crea un nuevo endpoint `/api/check_process` que acepte el nombre de un proceso (`process_name`) como parámetro.
2. **Lógica de Verificación:** La función debe buscar dentro del directorio mapeado `/host/proc/` si existe un subdirectorio cuyo archivo `comm` (o similar, dependiendo del lenguaje) contenga el `process_name` solicitado.
3. **Respuesta:** El endpoint debe devolver un estado booleano y un mensaje: `{"is_running": true/false, "message": "El proceso [nombre] está activo/inactivo."}`.
4. **Seguridad/Robustez:** Asegúrate de que la lógica sea robusta contra nombres de procesos incorrectos o directorios `/proc` corruptos.

**ENTREGABLES:**
* El código del core backend actualizado con la función de monitoreo.
* Prueba de `curl` que demuestre la verificación exitosa de un proceso común (ej. `bash` o `systemd`) y la verificación fallida de un proceso inexistente.
```

-----

### Fase 5: Integración Final y Empaquetado del MFM

Esta fase final une la interfaz (Fase 2) con las funcionalidades del core (Fases 3 y 4) y define el paquete de entrega del MFM.

| Objetivo de la Fase | Entregable Clave |
| :--- | :--- |
| Conectar todas las partes, refinar la interfaz para mostrar las respuestas de la IA y el estado del proceso, y crear las instrucciones de despliegue final. | Código integrado (Frontend y Backend), MFM funcional, y un `README.md` maestro para el despliegue. |

**Prompt Tentativo para la Fase 5:**

```
Eres un integrador de sistemas con un enfoque en la experiencia de usuario (UX/UI). Tu tarea es tomar los componentes funcionales de las Fases 1 a 4 y crear el MFM final.

**ANÁLISIS DE LAS FASES 1 a 4:**
* **[Aquí debe analizar los resultados de todos los prompts anteriores: estructura final de endpoints (F3, F4), la sintaxis exacta del atajo (F2), y cómo se envían los datos (F2) y se reciben (F3, F4).]**

**REQUERIMIENTOS DE LA INTEGRACIÓN (MFM FINAL):**
1. **Conexión de IA:** Conecta la interfaz de usuario de Electron (Fase 2) para que envíe las consultas a `/api/query_gemini` (Fase 3) y muestre la respuesta de la IA en una "burbuja" de diálogo temporal junto al QR.
2. **Conexión de Monitoreo:** Añade una interfaz simple (ej. un campo de texto dedicado o un comando reconocido) para enviar una solicitud de verificación a `/api/check_process` (Fase 4).
3. **Feedback Visual:** Implementa **animaciones mínimas** (cambio de color o de icono del QR) para los siguientes estados: **"Pensando"** (durante la consulta a Gemini) y **"Error/Éxito"** (al verificar el proceso).
4. **Instrucciones Finales:** Crea un único y detallado `README.md` que incluya:
    * Requisitos de Host (Linux, Docker, Rclone - solo mencionar rclone para futura persistencia, pero no implementar en el MFM).
    * Cómo obtener la clave de Gemini.
    * Un paso a paso para ejecutar el Contenedor Docker (incluyendo el mapeo de `/proc`).
    * Un paso a paso para ejecutar la aplicación Electron en el host.
    * Instrucciones sobre cómo probar las dos funcionalidades principales (IA y monitoreo).

**ENTREGABLES:**
* El código fuente final y completamente integrado.
* El `README.md` maestro de despliegue.
* Confirmación de que el MFM funciona de extremo a extremo.
```
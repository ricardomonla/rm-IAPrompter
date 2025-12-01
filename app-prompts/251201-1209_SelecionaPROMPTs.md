Mejora la redacción del PROMPT INICIAL teniendo en cuenta lo siguiente:
- Está dirigido a una IA que genera código.
- Se espara 2 versiones, una el PROMPT EN ESPAÑOL y la otra el PROMPT EN INGLÉS dirigida a la IA, sin necesidad de tanta estética para este última.
- Se le pide a la IA haga las acciones y no un plan.

-----
**PROMPT INICIAL**

En el sector de la redaccion del prompt, Ahora agregaremos que se puedan seleccionar desde una lista, usando la funcionalidad de // muetra las acciones, esto entonces ahora me muestra la lista de los ultimos prompts que he usado, y que me permita seleccionar uno de ellos para que lo use como base para el nuevo prompt. Tambien al modificar el seleecionado se debe actualizar el prompt actual.

-----

**PROMPT EN ESPAÑOL**

> "Actúa como experto en Frontend. Refactoriza el layout de la aplicación para seguir estrictamente la siguiente distribución espacial de 3 sectores:
>
> 1.  **Panel Lateral Derecho (Contenedor de Inputs):** Divide este panel verticalmente en dos secciones:
>     * **Superior (Selector de Cabeceras):** Un área para 'Cabeceras' que incluya un input con lógica de autocompletado activada por `//` para insertar plantillas.
>     * **Inferior (Editor de Prompt):** Un área de texto dedicada exclusivamente a la redacción del prompt inicial.
>
> 2.  **Panel Principal Izquierdo (Visualización):**
>     * Este sector debe ocupar el resto de la pantalla.
>     * **Lógica de Renderizado:** Debe mostrar **únicamente** la respuesta de la IA. Filtra la vista para que el prompt original del usuario NO se renderice en este panel, manteniendo la salida limpia.
>
> **Acción:** No necesito un plan ni explicaciones. Genera el código para implementar esta nueva arquitectura de interfaz ahora mismo."
-----

**PROMPT EN INGLÉS**

> "Refactor the UI layout to implement a split-view architecture consisting of three functional components:
>
> **1. Right Sidebar (Vertical Split):**
> * **Top Section (Header Logic):** Input field triggered by `//` slash commands to select prompt templates.
> * **Bottom Section (Input):** Dedicated text area for the prompt body.
>
> **2. Main Viewport (Left/Center):**
> * **Output Display:** A large container for the AI response.
> * **Constraint:** Modify the render logic to **sanitize the output view**: display ONLY the AI's response text. The user's input/prompt must be strictly hidden from this specific panel.
>
> **Execute:** Output the necessary code to restructure the layout and logic immediately. Do not generate a plan."

-----

# Funcionalidad de Exportación - rm-IAPromper

## Descripción
Se ha implementado una funcionalidad completa de exportación para el panel de resultados izquierdo que permite guardar el contenido generado en archivos Markdown (.md) y texto plano (.txt).

## Características Implementadas

### 1. **Interfaz de Usuario**
- **Barra de herramientas**: Añadida al panel izquierdo con botones de exportación
- **Botón MD** (`📄 MD`): Exporta a formato Markdown preservando la estructura
- **Botón TXT** (`📝 TXT`): Exporta a texto plano sin formato
- **Indicador de estado**: Muestra el resultado de la exportación con feedback visual

### 2. **Funcionalidades de Exportación**

#### Exportación a Markdown (.md)
- Preserva títulos (H1-H6), negritas, cursivas, listas y bloques de código
- Mantiene la sintaxis de código con resaltado de idioma
- Convierte HTML renderizado de vuelta a Markdown
- Nombres de archivo con timestamp: `prompt-export-YYYYMMDD-HHMMSS.md`

#### Exportación a Texto Plano (.txt)
- Convierte Markdown a texto sin formato
- Simplifica títulos, remove marcadores de formato
- Mantiene estructura básica con viñetas
- Nombres de archivo con timestamp: `prompt-export-YYYYMMDD-HHMMSS.txt`

### 3. **Manejo de Archivos**
- **Ubicación**: Los archivos se guardan en el directorio `Descargas` del usuario
- **Detección de duplicados**: Muestra diálogo de confirmación si el archivo ya existe
- **Manejo de errores**: Feedback visual en caso de errores de guardado
- **Seguridad**: Validación de contenido antes de exportar

### 4. **Integración con Electron**
- **IPC Communication**: Comunicación segura entre renderer y main process
- **File System Access**: Acceso controlado al sistema de archivos
- **Cross-platform**: Compatible con Windows, macOS y Linux

## Archivos Modificados

### 1. `index.html`
- **Línea 86-98**: Añadida barra de herramientas con botones de exportación
- **Línea 204-211**: Referencias UI actualizadas para incluir botones de exportación
- **Líneas 641-750**: Funciones de exportación JavaScript implementadas

### 2. `main.js`
- **Líneas 101-140**: Handler IPC para guardar archivos con validaciones y manejo de errores

### 3. `styles.css`
- **Líneas 72-95**: Estilos para la barra de herramientas del panel izquierdo
- **Líneas 96-106**: Estilos para botones de exportación con efectos hover

## Uso de la Funcionalidad

### Para Exportar a Markdown:
1. Generar un prompt en el panel izquierdo
2. Hacer clic en el botón `📄 MD`
3. El archivo se guardará automáticamente en `Descargas`
4. Confirmación visual del éxito/error

### Para Exportar a Texto Plano:
1. Generar un prompt en el panel izquierdo
2. Hacer clic en el botón `📝 TXT`
3. El archivo se guardará automáticamente en `Descargas`
4. Confirmación visual del éxito/error

## Características Técnicas

### Procesamiento de Contenido
- **Conversión HTML→Markdown**: Transforma el contenido renderizado de vuelta a formato Markdown
- **Preservación de código**: Mantiene sintaxis highlighting y bloques de código
- **Limpieza de texto**: Normalización de líneas y eliminación de HTML residual

### Manejo de Errores
- Validación de contenido antes de exportar
- Feedback visual inmediato (3 segundos)
- Manejo de errores de sistema de archivos
- Confirmación de sobrescritura para archivos existentes

### Rendimiento
- Exportación asíncrona sin bloquear la UI
- Uso eficiente de IPC para comunicación segura
- Procesamiento optimizado de contenido HTML/Markdown

## Compatibilidad
- **Navegador**: Compatible con Electron renderer process
- **Sistema**: Windows, macOS, Linux
- **Dependencias**: Utiliza APIs nativas de Electron (fs, path, dialog)

## Notas de Implementación
- La funcionalidad está completamente integrada con la interfaz existente
- No requiere configuración adicional
- Los archivos se guardan con encoding UTF-8
- Timestamps en formato ISO para compatibilidad internacional
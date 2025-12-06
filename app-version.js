//  -----------------------------------------------------------------------------
//  Project:     rm-Prompter
//  File:        app-version.js
//  Version:     3.1.4
//  Date:        2025-12-04
//  Author:      Lic. Ricardo MONLA
//  Email:       rmonla@gmail.com
//  Description: Sistema de versionado centralizado para la aplicación.
//  -----------------------------------------------------------------------------
/**
 * SISTEMA DE VERSIONADO CENTRALIZADO - rm-IAPromper
 *
 * Este archivo centraliza toda la información de versionado de la aplicación.
 * Al actualizar la versión, modifica únicamente los valores aquí y ejecuta
 * el proceso de actualización automática.
 */

// ========== CONFIGURACIÓN DE VERSIÓN ==========
const APP_VERSION = "3.1.5";
const APP_NAME = "rm-IAPromper";
const APP_FULL_NAME = `${APP_NAME} v${APP_VERSION}`;

// ========== HISTORIAL DE VERSIONES ==========
/**
 * Historial completo de versiones con cambios principales.
 * Se mantiene para referencia y documentación.
 */
const VERSION_HISTORY = {
    "3.1.5": {
        date: "2025-12-06",
        changes: [
            "Estandarización de encabezados en todos los archivos principales",
            "Clarificación de versionado independiente vs. aplicación general",
            "Optimización de documentación en app-version.js y prompts de commit"
        ],
        type: "Mejora"
    },
    "3.1.4": {
        date: "2025-12-04",
        changes: [
            "Reestructuración completa del layout para armonía visual equilibrada",
            "Implementación de dos paneles principales con secciones armoniosas",
            "Sistema centralizado de versionado",
            "Optimización de interfaz de usuario"
        ],
        type: "Mejora(UI)"
    },
    "3.1.3": {
        date: "2025-12-01",
        changes: [
            "Refactorización completa del sistema de plantillas",
            "Migración a navegación directa tipo carrusel",
            "Implementación de edición in-place",
            "Nuevos endpoints API para gestión de plantillas"
        ],
        type: "Añadido"
    },
    "3.0.1": {
        date: "2025-12-02",
        changes: [
            "Actualización de dependencias (Electron 18.3.15)",
            "Optimización de script de inicio",
            "Mejoras en configuración Docker"
        ],
        type: "Cambiado"
    }
};

// ========== ARCHIVOS A ACTUALIZAR ==========
/**
 * Lista de archivos que requieren actualización manual al cambiar versión.
 * El sistema automático actualiza los marcados como 'auto'.
 */
const VERSION_UPDATE_FILES = {
    auto: [
        "app-interface/index.html",  // Título y comentarios
        "app-run.sh",               // Mensaje de launcher
        "app-interface/version.js"  // Constante APP_VERSION (este archivo)
    ],
    manual: [
        "CHANGELOG.md",             // Agregar nueva entrada
        "README.md",                // Actualizar versión en documentación
        "app-interface/package.json", // Si aplica
        "app.py"                    // Comentarios de versión
    ]
};

// ========== FUNCIONES DE VERSIONADO ==========
/**
 * Obtiene la versión actual formateada
 */
function getCurrentVersion() {
    return APP_VERSION;
}

/**
 * Obtiene el nombre completo de la aplicación
 */
function getAppFullName() {
    return APP_FULL_NAME;
}

/**
 * Obtiene el historial de versiones
 */
function getVersionHistory() {
    return VERSION_HISTORY;
}

/**
 * Valida que la versión siga el formato semántico (major.minor.patch)
 */
function validateVersion(version = APP_VERSION) {
    const semverRegex = /^\d+\.\d+\.\d+$/;
    return semverRegex.test(version);
}

// ========== PROCESO DE ACTUALIZACIÓN DE VERSIÓN ==========
/**
 * IMPORTANTE: CLARIFICACIÓN SOBRE VERSIONADO
 *
 * Este archivo gestiona la versión de la aplicación en general (APP_VERSION).
 * Cada archivo individual del proyecto mantiene su propia versión independiente,
 * que no necesariamente coincide con la versión global de la aplicación.
 * Estos dos esquemas de versionado (individual vs. aplicación general) son
 * distintos y separados.
 *
 * PROCESO COMPLETO DE ACTUALIZACIÓN DE VERSIÓN:
 *
 * 1. **Modificar APP_VERSION** en este archivo (incrementar según semver: major.minor.patch)
 * 2. **Agregar entrada en VERSION_HISTORY** con fecha, cambios y tipo
 * 3. **Actualizar CHANGELOG.md**:
 *    - Crear nueva sección [X.Y.Z] - YYYY-MM-DD
 *    - Documentar cambios bajo categorías: Añadido, Cambiado, Corregido
 * 4. **Actualizar README.md** si las modificaciones afectan la documentación principal
 * 5. **Verificar package.json** si es necesario (para dependencias)
 * 6. **Actualizar encabezados de archivos** individuales si corresponde (versión independiente)
 * 7. **Probar aplicación** completamente y verificar estabilidad
 * 8. **Ejecutar commit** con mensaje descriptivo siguiendo el formato: "vX.Y.Z: Descripción de cambios"
 *
 * EJEMPLO DE NUEVA VERSIÓN:
 *
 * // Cambiar aquí
 * const APP_VERSION = "3.1.5";
 *
 * // Agregar al historial
 * "3.1.5": {
 *     date: "2025-12-04",
 *     changes: [
 *         "Nueva funcionalidad implementada",
 *         "Corrección de bug en módulo X"
 *     ],
 *     type: "Añadido"
 * }
 *
 * NOTA: Los commits deben reflejar cambios significativos en la aplicación general.
 * Cambios menores en archivos individuales no requieren actualización de APP_VERSION.
 */

// ========== EXPORTACIONES ==========
if (typeof module !== 'undefined' && module.exports) {
    // Para Node.js
    module.exports = {
        APP_VERSION,
        APP_NAME,
        APP_FULL_NAME,
        VERSION_HISTORY,
        VERSION_UPDATE_FILES,
        getCurrentVersion,
        getAppFullName,
        getVersionHistory,
        validateVersion
    };
} else {
    // Para navegador (global)
    window.AppVersion = {
        APP_VERSION,
        APP_NAME,
        APP_FULL_NAME,
        VERSION_HISTORY,
        VERSION_UPDATE_FILES,
        getCurrentVersion,
        getAppFullName,
        getVersionHistory,
        validateVersion
    };
}
const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let mainWindow;

// Definición de los 3 estados de la ventana
const WINDOW_SIZES = {
    mini: { width: 120, height: 120 },      // Modo 1: Solo la cara/QR
    compact: { width: 400, height: 550 },   // Modo 2: Consulta rápida
    expanded: { width: 900, height: 700 }   // Modo 4: Maximizado (se centra)
};

// Variable para almacenar el estado actual de la ventana
let currentMode = 'compact'; // INICIAMOS EN MODO COMPACTO (para el login)
const MARGIN = 20; // Margen desde el borde del área de trabajo

/**
 * Calcula la posición inicial para anclar la ventana a la esquina inferior derecha.
 * @param {Object} size - Objeto con width y height.
 * @returns {Object} - Coordenadas x, y.
 */
function getInitialPosition(size) {
    // Usamos workArea para tener en cuenta la barra de tareas
    const workArea = screen.getPrimaryDisplay().workArea; 
    
    // Calcular posición: Inicio del área + Ancho del área - Ancho ventana - Margen
    const initialX = workArea.x + workArea.width - size.width - MARGIN;
    const initialY = workArea.y + workArea.height - size.height - MARGIN;
    
    return { x: initialX, y: initialY };
}

function createWindow() {
    const initialSize = WINDOW_SIZES.compact;
    const initialPos = getInitialPosition(initialSize);

    mainWindow = new BrowserWindow({
        width: initialSize.width,
        height: initialSize.height,
        x: initialPos.x,
        y: initialPos.y,
        frame: false,           // Sin bordes del SO
        transparent: true,      // Fondo transparente
        alwaysOnTop: true,      // Siempre visible
        resizable: false,       // Desactivar redimensionamiento manual para forzar los modos
        skipTaskbar: true,      // No mostrar en barra de tareas (opcional)
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    mainWindow.loadFile('index.html');
    
    // LÓGICA DE DEBUG: Si la variable de entorno existe (pasada por app-run.sh --debug), abrir DevTools
    if (process.env.MFM_DEBUG === 'true') {
        console.log("🔧 Modo Debug detectado: Abriendo DevTools...");
        mainWindow.webContents.openDevTools({ mode: 'detach' });
    }

    // En modo compacto (inicio) necesitamos aceptar clics para el login
    mainWindow.setIgnoreMouseEvents(false); 
}

/**
 * Redimensiona y reposiciona la ventana según el modo (Fijo a Esquina Inferior Derecha).
 * @param {string} mode - El modo objetivo ('mini', 'compact', 'expanded').
 */
function updateWindowGeometry(mode) {
    if (!mainWindow) return;
    
    const newSize = WINDOW_SIZES[mode];
    let newX, newY;

    if (mode === 'expanded') {
        // Modo Expandido: Centrar la ventana
        const workArea = screen.getPrimaryDisplay().workArea;
        const screenWidth = workArea.width;
        const screenHeight = workArea.height;
        
        newX = workArea.x + Math.round((screenWidth - newSize.width) / 2);
        newY = workArea.y + Math.round((screenHeight - newSize.height) / 2);

    } else {
        // Modos Mini y Compacto: Posición fija en la esquina inferior derecha
        const newPos = getInitialPosition(newSize);
        newX = newPos.x;
        newY = newPos.y;
    }
    
    // Aplicar la nueva geometría con animación suave (si el SO lo soporta)
    mainWindow.setBounds({ x: Math.round(newX), y: Math.round(newY), width: newSize.width, height: newSize.height }, true);
    
    // Manejar eventos de ratón según el modo
    if (mode === 'mini') {
        // En modo Mini, ignorar clics para que pasen al escritorio, 
        // pero permitir clic en el contenido (forward: true) para activar el ciclo de modos.
        mainWindow.setIgnoreMouseEvents(true, { forward: true }); 
    } else {
        // En modos activos (Compacto/Expandido), permitir interacción completa
        mainWindow.setIgnoreMouseEvents(false);
        mainWindow.focus();
    }

    currentMode = mode;
}

// --- IPC: Comunicación Interfaz -> Sistema ---

// La interfaz envía la orden de cambiar de modo
ipcMain.on('resize-window', (event, mode) => {
    updateWindowGeometry(mode);
});

// La interfaz pide el estado actual (útil para inicialización)
ipcMain.on('get-current-mode', (event) => {
    // Devolvemos el modo actual. La esquina es fija 'bottom-right', pero mantenemos la estructura del objeto.
    event.reply('current-mode-reply', { mode: currentMode, corner: 'bottom-right' });
});

// Cerrar la aplicación
ipcMain.on('close-app', () => {
    app.quit();
});

// --- Ciclo de Vida de la App ---

app.whenReady().then(() => {
    createWindow();
    
    // Registrar atajo global Ctrl+Shift+G
    globalShortcut.register('Ctrl+Shift+G', () => {
        if (mainWindow.isVisible()) {
            // Si es visible, alternar entre Mini y Compacto
            updateWindowGeometry(currentMode === 'mini' ? 'compact' : 'mini');
        } else {
            // Si estaba oculta (por lógica futura), mostrar en Compacto
            updateWindowGeometry('compact');
            mainWindow.show();
        }
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});
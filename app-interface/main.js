/*
 * -----------------------------------------------------------------------------
 * Autor: Lic. Ricardo MONLA
 * Versión: v0.8.7
 * Descripción: Proceso principal de Electron. 
 * - Corrección: DevTools acoplado (mode: right) para evitar ventana extra.
 * - Posicionamiento fijo en esquina inferior derecha.
 * -----------------------------------------------------------------------------
 */

const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let mainWindow;

// Definición de los 3 estados de la ventana
const WINDOW_SIZES = {
    mini: { width: 120, height: 120 },      // Modo 0: Solo la cara
    compact: { width: 400, height: 550 },   // Modo 1: Login / Consulta rápida
    expanded: { width: 900, height: 700 }   // Modo 2: Trabajo amplio
};

let currentMode = 'compact'; // Inicio en compacto para Login
const MARGIN = 20;

/**
 * Calcula la posición para anclar la ventana a la esquina inferior derecha.
 */
function getBottomRightPosition(size) {
    const workArea = screen.getPrimaryDisplay().workArea; 
    const x = workArea.x + workArea.width - size.width - MARGIN;
    const y = workArea.y + workArea.height - size.height - MARGIN;
    return { x, y };
}

function createWindow() {
    const initialSize = WINDOW_SIZES.compact;
    const initialPos = getBottomRightPosition(initialSize);

    mainWindow = new BrowserWindow({
        width: initialSize.width,
        height: initialSize.height,
        x: initialPos.x,
        y: initialPos.y,
        frame: false,           // Sin bordes
        transparent: true,      // Fondo transparente real
        alwaysOnTop: true,      // Flotante
        resizable: false,       // Tamaño fijo por modo
        skipTaskbar: true,      // No ensuciar la barra de tareas
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    mainWindow.loadFile('index.html');
    
    // DEBUG: Configuración corregida para evitar ventanas fantasma
    if (process.env.MFM_DEBUG === 'true') {
        console.log("🔧 Debug: Abriendo consola (Acoplada)...");
        // CAMBIO: 'mode: right' integra el debugger en la misma ventana
        mainWindow.webContents.openDevTools({ mode: 'right' }); 
    }

    // FIX CRÍTICO LINUX: Siempre capturar eventos del ratón.
    mainWindow.setIgnoreMouseEvents(false); 
}

function updateWindowGeometry(mode) {
    if (!mainWindow) return;
    
    const newSize = WINDOW_SIZES[mode];
    const newPos = getBottomRightPosition(newSize);
    
    // Aplicar nueva geometría
    mainWindow.setBounds({ 
        x: Math.round(newPos.x), 
        y: Math.round(newPos.y), 
        width: newSize.width, 
        height: newSize.height 
    }, true);
    
    // Asegurar interactividad
    mainWindow.setIgnoreMouseEvents(false);
    
    // Enfocar la ventana si no es mini (para escribir rápido)
    if (mode !== 'mini') {
        mainWindow.focus();
    }

    currentMode = mode;
}

// --- IPC ---

ipcMain.on('resize-window', (event, mode) => {
    updateWindowGeometry(mode);
});

ipcMain.on('get-current-mode', (event) => {
    event.reply('current-mode-reply', { mode: currentMode });
});

ipcMain.on('close-app', () => {
    app.quit();
});

// --- Lifecycle ---

app.whenReady().then(() => {
    createWindow();
    
    globalShortcut.register('Ctrl+Shift+G', () => {
        if (mainWindow.isVisible()) {
            // Toggle simple: Si es mini -> compacto. Si es otro -> mini.
            const nextMode = currentMode === 'mini' ? 'compact' : 'mini';
            // Avisar al renderizador para que actualice CSS
            mainWindow.webContents.send('force-mode-update', nextMode);
            updateWindowGeometry(nextMode);
        } else {
            updateWindowGeometry('compact');
            mainWindow.show();
        }
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});
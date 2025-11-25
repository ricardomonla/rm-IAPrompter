/*
 * -----------------------------------------------------------------------------
 * Autor: Lic. Ricardo MONLA
 * Versión: v0.9.8 (Auto-Minimize)
 * Descripción: Minimiza al hexágono (Mini) al perder el foco (clic fuera).
 * -----------------------------------------------------------------------------
 */

const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let mainWindow;

// Definición de los 3 estados de la ventana
const WINDOW_SIZES = {
    mini: { width: 80, height: 80 },        
    compact: { width: 500, height: 500 },   
    expanded: { width: 900, height: 700 }   
};

let currentMode = 'compact'; 
const MARGIN = 20; 

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
        frame: false,           
        transparent: true,      
        alwaysOnTop: true,      
        resizable: false,       
        skipTaskbar: true,      
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    mainWindow.loadFile('index.html');
    
    // --- LÓGICA DE AUTO-MINIMIZAR (Nuevo) ---
    mainWindow.on('blur', () => {
        // Si no estamos en modo mini y no estamos depurando (opcional)
        if (currentMode !== 'mini') {
            // 1. Avisar al Frontend para que cambie estilos (ocultar chat)
            mainWindow.webContents.send('force-mode-update', 'mini');
            // 2. Cambiar geometría de la ventana
            updateWindowGeometry('mini');
        }
    });

    if (process.env.MFM_DEBUG === 'true') {
        mainWindow.webContents.openDevTools({ mode: 'right' }); 
    }

    mainWindow.setIgnoreMouseEvents(false); 
}

function updateWindowGeometry(mode) {
    if (!mainWindow) return;
    
    const newSize = WINDOW_SIZES[mode];
    const newPos = getBottomRightPosition(newSize);
    
    mainWindow.setBounds({ 
        x: Math.round(newPos.x), 
        y: Math.round(newPos.y), 
        width: newSize.width, 
        height: newSize.height 
    }, false); 
    
    mainWindow.setIgnoreMouseEvents(false);
    
    if (mode !== 'mini') {
        mainWindow.focus();
    }

    currentMode = mode;
}

ipcMain.on('resize-window', (event, mode) => updateWindowGeometry(mode));
ipcMain.on('get-current-mode', (event) => event.reply('current-mode-reply', { mode: currentMode }));
ipcMain.on('close-app', () => app.quit());

app.whenReady().then(() => {
    createWindow();
    globalShortcut.register('Ctrl+Shift+G', () => {
        if (mainWindow.isVisible()) {
            const nextMode = currentMode === 'mini' ? 'compact' : 'mini';
            mainWindow.webContents.send('force-mode-update', nextMode);
            updateWindowGeometry(nextMode);
        } else {
            updateWindowGeometry('compact');
            mainWindow.show();
        }
    });
});

app.on('window-all-closed', () => { if (process.platform !== 'darwin') app.quit(); });
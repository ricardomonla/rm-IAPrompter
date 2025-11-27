/*
 * -----------------------------------------------------------------------------
 * Autor: Lic. Ricardo MONLA
 * Versión: v2.2.0 (Master-Detail Layout)
 * Versión: v2.0.0 (Master-Detail Layout)
 * Descripción: Alterna entre Hexágono (Mini) y Panel de Trabajo (Expanded).
 * -----------------------------------------------------------------------------
 */

const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let mainWindow;

const WINDOW_SIZES = {
    mini: { width: 80, height: 80 },        
    expanded: { width: 1100, height: 720 } // Aumentado ancho para mejor redacción
};

let currentMode = 'expanded'; 
const MARGIN = 20; 

function getBottomRightPosition(size) {
    const workArea = screen.getPrimaryDisplay().workArea; 
    const x = workArea.x + workArea.width - size.width - MARGIN;
    const y = workArea.y + workArea.height - size.height - MARGIN;
    return { x, y };
}

function createWindow() {
    // Iniciamos en Expanded para ver el login, luego el usuario puede minimizar
    const initialSize = WINDOW_SIZES.expanded;
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
    
    // Auto-Minimizar al perder foco (excepto si estamos en modo mini)
    mainWindow.on('blur', () => {
        if (currentMode !== 'mini') {
            mainWindow.webContents.send('force-mode-update', 'mini');
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
    // Atajo para alternar visibilidad
    globalShortcut.register('Ctrl+Shift+G', () => {
        if (mainWindow.isVisible()) {
            const nextMode = currentMode === 'mini' ? 'expanded' : 'mini';
            mainWindow.webContents.send('force-mode-update', nextMode);
            updateWindowGeometry(nextMode);
        } else {
            updateWindowGeometry('expanded');
            mainWindow.show();
        }
    });
});

app.on('window-all-closed', () => { if (process.platform !== 'darwin') app.quit(); });
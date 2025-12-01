/*
 * -----------------------------------------------------------------------------
 * Autor: Lic. Ricardo MONLA
 * Versión: v3.0.0 (Layout Modular 3-Sectores)
 * Descripción: Alterna entre Hexágono (Mini) y Panel de Trabajo (Expanded).
 * -----------------------------------------------------------------------------
 */

const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let mainWindow;

const WINDOW_SIZES = {
    mini: { width: 80, height: 80 },        
    expanded: { width: 1100, height: 720 } // Ancho optimizado para el panel de 3 sectores
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
    // Iniciamos en Expanded para ver el login o la interfaz principal
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
            contextIsolation: false,
            // Habilitar si necesitas cargar imágenes locales fuera de la app
            webSecurity: false 
        }
    });

    mainWindow.loadFile('index.html');

    if (process.env.MFM_DEBUG === 'true') {
        mainWindow.webContents.openDevTools({ mode: 'right' }); 
    }
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
    }, false); // 'false' para evitar animación nativa lenta en Windows

    mainWindow.setIgnoreMouseEvents(false);
    mainWindow.show(); 

    if (mode !== 'mini') {
        mainWindow.focus();
    }

    currentMode = mode;
}

// IPC Events
ipcMain.on('resize-window', (event, mode) => {
    updateWindowGeometry(mode);
});

ipcMain.on('get-current-mode', (event) => event.reply('current-mode-reply', { mode: currentMode }));

ipcMain.on('close-app', () => app.quit());

// App Lifecycle
app.whenReady().then(() => {
    createWindow();
    
    // Atajo Global para alternar visibilidad (Ctrl+Shift+G)
    globalShortcut.register('Ctrl+Shift+G', () => {
        if (mainWindow.isVisible()) {
            // Toggle lógica: Si está visible, cambia de modo.
            const nextMode = currentMode === 'mini' ? 'expanded' : 'mini';
            mainWindow.webContents.send('force-mode-update', nextMode);
            updateWindowGeometry(nextMode);
        } else {
            // Si estaba oculta (por alguna razón del SO), restaurar.
            updateWindowGeometry('expanded');
            mainWindow.show();
        }
    });
});

app.on('window-all-closed', () => { 
    if (process.platform !== 'darwin') app.quit(); 
});
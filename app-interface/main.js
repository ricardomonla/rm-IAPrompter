//  -----------------------------------------------------------------------------
//  Project:     rm-Prompter
//  File:        app-interface/main.js
//  Version:     v1.0.0
//  Date:        2025-12-03 20:45
//  Author:      Lic. Ricardo MONLA
//  Email:       rmonla@gmail.com
//  Description: Configura la ventana principal de la aplicación Electron.
//  -----------------------------------------------------------------------------

const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let mainWindow;

const WINDOW_SIZES = {
    mini: { width: 80, height: 80 },        
    expanded: { width: 1100, height: 720 } 
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
    const initialSize = WINDOW_SIZES.expanded;
    const initialPos = getBottomRightPosition(initialSize);
    
    // Detectamos si estamos en modo debug gracias a tu script app-run.sh
    const isDebug = process.env.MFM_DEBUG === 'true';

    mainWindow = new BrowserWindow({
        width: initialSize.width,
        height: initialSize.height,
        x: initialPos.x,
        y: initialPos.y,
        frame: false,           
        transparent: true,      
        alwaysOnTop: true,      
        resizable: false,       
        
        // --- AQUÍ ESTÁ EL CAMBIO CLAVE ---
        // Si es debug, NO lo ocultes (false). Si es producción, ocúltalo (true).
        skipTaskbar: !isDebug,      
        // ---------------------------------

        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
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
    }, false);

    mainWindow.setIgnoreMouseEvents(false);
    mainWindow.show(); 

    if (mode !== 'mini') {
        mainWindow.focus();
    }

    currentMode = mode;
}

// App Lifecycle
app.on('ready', () => {
    createWindow();

    // IPC Events
    ipcMain.on('resize-window', (event, mode) => {
        updateWindowGeometry(mode);
        event.sender.send('force-mode-update', mode);
    });

    ipcMain.on('get-current-mode', (event) => event.reply('current-mode-reply', { mode: currentMode }));

    ipcMain.on('close-app', () => app.quit());

    // IPC Handler para exportación de archivos
    ipcMain.handle('save-file', async (event, { nombreArchivo, contenido, tipoArchivo }) => {
        try {
            const { dialog, app } = require('electron');
            const fs = require('fs').promises;
            const path = require('path');
            
            // Obtener directorio de descargas del usuario
            const downloadsPath = app.getPath('downloads');
            const rutaCompleta = path.join(downloadsPath, nombreArchivo);
            
            // Verificar si el archivo ya existe
            try {
                await fs.access(rutaCompleta);
                // El archivo existe, mostrar diálogo de confirmación
                const { response } = await dialog.showMessageBox(mainWindow, {
                    type: 'question',
                    buttons: ['Sobrescribir', 'Cancelar'],
                    title: 'Archivo Existente',
                    message: `El archivo "${nombreArchivo}" ya existe en Descargas.`,
                    detail: '¿Deseas sobrescribirlo?'
                });
                
                if (response === 1) {
                    return { exito: false, error: 'Operación cancelada por el usuario' };
                }
            } catch (accessError) {
                // El archivo no existe, continuar normalmente
            }
            
            // Guardar el archivo
            await fs.writeFile(rutaCompleta, contenido, 'utf8');
            
            console.log(`✅ Archivo exportado exitosamente: ${rutaCompleta}`);
            return { 
                exito: true, 
                ruta: rutaCompleta,
                mensaje: `Archivo guardado en Descargas: ${nombreArchivo}`
            };
            
        } catch (error) {
            console.error('❌ Error al guardar archivo:', error);
            return { 
                exito: false, 
                error: `Error al guardar: ${error.message}` 
            };
        }
    });

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

app.on('window-all-closed', () => { 
    if (process.platform !== 'darwin') app.quit(); 
});
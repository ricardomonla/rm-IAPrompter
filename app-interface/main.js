const { app, BrowserWindow, globalShortcut, screen } = require('electron');
const path = require('path');

let mainWindow;

function createWindow() {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { width, height } = primaryDisplay.workAreaSize;

  mainWindow = new BrowserWindow({
    width: 400,
    height: 400,
    x: width - 420, // Bottom-right corner with some margin
    y: height - 420,
    frame: false, // Frameless
    transparent: true, // Transparent
    alwaysOnTop: true, // Always on top
    skipTaskbar: true, // Don't show in taskbar
    resizable: false,
    show: false, // Start hidden
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
    },
  });

  mainWindow.loadFile('index.html');

  // For passthrough clicks, set ignore mouse events
  mainWindow.setIgnoreMouseEvents(true);

  // But allow interaction with the window content by focusing or something, but for simplicity, keep it passthrough
  // Note: In a real app, you might need to handle mouse enter/leave to toggle ignore
}

app.on('ready', () => {
  createWindow();

  // Register global shortcut
  globalShortcut.register('CommandOrControl+Shift+G', () => {
    if (mainWindow.isVisible()) {
      mainWindow.hide();
      mainWindow.setIgnoreMouseEvents(true);
    } else {
      mainWindow.show();
      mainWindow.setIgnoreMouseEvents(false);
      mainWindow.focus();
    }
  });
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('will-quit', () => {
  // Unregister shortcuts
  globalShortcut.unregisterAll();
});
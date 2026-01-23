const { app, BrowserWindow, Tray, Menu, screen, ipcMain, powerMonitor } = require('electron');
const path = require('path');

let mainWindow;
let tray;

function createWindow() {
    const { width: screenWidth, height: screenHeight } = screen.getPrimaryDisplay().workAreaSize;

    mainWindow = new BrowserWindow({
        width: 400,
        height: 500,
        x: screenWidth - 450,
        y: screenHeight - 550,
        transparent: true,
        frame: false,
        alwaysOnTop: true,
        skipTaskbar: true,
        hasShadow: false,
        resizable: false,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    mainWindow.loadFile('index.html');
    mainWindow.setVisibleOnAllWorkspaces(true, { visibleOnFullScreen: true });

    // Open DevTools for debugging during prototype
    // mainWindow.webContents.openDevTools({ mode: 'detach' });
}

function createTray() {
    // Using a text-based icon since we don't have an icon file
    tray = new Tray(path.join(__dirname, '..', 'mutsu-desktop-mate', 'assets', 'mutsu-smug.jpg'));

    const contextMenu = Menu.buildFromTemplate([
        { label: '♡ MUTSU 3D Prototype ♡', enabled: false },
        { type: 'separator' },
        { label: 'Show MUTSU', click: () => mainWindow.show() },
        { label: 'Hide MUTSU', click: () => mainWindow.hide() },
        { type: 'separator' },
        { label: 'Toggle DevTools', click: () => mainWindow.webContents.toggleDevTools() },
        { type: 'separator' },
        { label: 'Quit', click: () => app.quit() }
    ]);

    tray.setToolTip('MUTSU 3D Prototype~♡');
    tray.setContextMenu(contextMenu);
}

app.whenReady().then(() => {
    createWindow();
    createTray();
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
});

// Handle window dragging
ipcMain.on('move-window', (event, { deltaX, deltaY }) => {
    if (mainWindow) {
        const [x, y] = mainWindow.getPosition();
        mainWindow.setPosition(x + deltaX, y + deltaY);
    }
});

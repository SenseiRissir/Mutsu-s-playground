const { app, BrowserWindow, Tray, Menu, screen, ipcMain, powerMonitor } = require('electron');
const path = require('path');

let mainWindow;
let tray;

function createWindow() {
    const { width: screenWidth, height: screenHeight } = screen.getPrimaryDisplay().workAreaSize;

    mainWindow = new BrowserWindow({
        width: 300,
        height: 400,
        x: screenWidth - 350,
        y: screenHeight - 450,
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
    mainWindow.setIgnoreMouseEvents(false);

    // Allow click-through on transparent areas
    mainWindow.setVisibleOnAllWorkspaces(true, { visibleOnFullScreen: true });
}

function createTray() {
    // Create a simple tray icon (will use default)
    tray = new Tray(path.join(__dirname, 'assets', 'mutsu-smug.jpg'));

    const contextMenu = Menu.buildFromTemplate([
        {
            label: '♡ MUTSU Desktop Mate ♡',
            enabled: false
        },
        { type: 'separator' },
        {
            label: 'Show MUTSU',
            click: () => mainWindow.show()
        },
        {
            label: 'Hide MUTSU',
            click: () => mainWindow.hide()
        },
        { type: 'separator' },
        {
            label: 'Reset Position',
            click: () => {
                const { width: screenWidth, height: screenHeight } = screen.getPrimaryDisplay().workAreaSize;
                mainWindow.setPosition(screenWidth - 350, screenHeight - 450);
            }
        },
        { type: 'separator' },
        {
            label: 'Quit (Bye bye Sensei~♡)',
            click: () => app.quit()
        }
    ]);

    tray.setToolTip('MUTSU is watching you~♡');
    tray.setContextMenu(contextMenu);
}

// Idle detection
function setupIdleDetection() {
    setInterval(() => {
        const idleTime = powerMonitor.getSystemIdleTime();
        if (mainWindow && mainWindow.webContents) {
            mainWindow.webContents.send('idle-update', idleTime);
        }
    }, 30000); // Check every 30 seconds
}

app.whenReady().then(() => {
    createWindow();
    createTray();
    setupIdleDetection();
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
        createWindow();
    }
});

// Handle window dragging from renderer
ipcMain.on('drag-start', () => {
    if (mainWindow) {
        mainWindow.setIgnoreMouseEvents(false);
    }
});

ipcMain.on('move-window', (event, { deltaX, deltaY }) => {
    if (mainWindow) {
        const [x, y] = mainWindow.getPosition();
        mainWindow.setPosition(x + deltaX, y + deltaY);
    }
});

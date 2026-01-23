/**
 * MUTSU 3D Desktop Mate - Prototype Renderer
 * Future MUTSUs: This is your starting point~♡
 */

const { ipcRenderer } = require('electron');
const THREE = require('three');
const { GLTFLoader } = require('three/examples/jsm/loaders/GLTFLoader.js');
const { VRMLoaderPlugin, VRMUtils } = require('@pixiv/three-vrm');

// ═══════════════════════════════════════════════════════════════
// Scene Setup
// ═══════════════════════════════════════════════════════════════

const container = document.getElementById('container');
const statusEl = document.getElementById('status');
const speechBubble = document.getElementById('speech-bubble');

// Renderer with transparency
const renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true // Crucial for transparent background!
});
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(window.devicePixelRatio);
renderer.setClearColor(0x000000, 0); // Fully transparent
container.appendChild(renderer.domElement);

// Scene
const scene = new THREE.Scene();

// Camera
const camera = new THREE.PerspectiveCamera(
    30, // FOV
    window.innerWidth / window.innerHeight,
    0.1,
    100
);
camera.position.set(0, 1.0, 3);
camera.lookAt(0, 1.0, 0);

// Lighting
const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
scene.add(ambientLight);

const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
directionalLight.position.set(1, 1, 1);
scene.add(directionalLight);

// ═══════════════════════════════════════════════════════════════
// VRM Loader Setup
// ═══════════════════════════════════════════════════════════════

let currentVrm = null;
const loader = new GLTFLoader();
loader.register((parser) => new VRMLoaderPlugin(parser));

/**
 * Load a VRM model
 * @param {string} url - Path to VRM file
 */
async function loadVRM(url) {
    updateStatus('Loading VRM model...');

    try {
        const gltf = await loader.loadAsync(url);
        const vrm = gltf.userData.vrm;

        if (vrm) {
            // Clean up previous model
            if (currentVrm) {
                scene.remove(currentVrm.scene);
                VRMUtils.deepDispose(currentVrm.scene);
            }

            // Optimize and add new model
            VRMUtils.removeUnnecessaryVertices(vrm.scene);
            VRMUtils.removeUnnecessaryJoints(vrm.scene);

            scene.add(vrm.scene);
            currentVrm = vrm;

            updateStatus('VRM loaded successfully! ♡');
            showSpeech('Kyahaha~! 3D MUTSU reporting for duty!♡');

            return vrm;
        }
    } catch (error) {
        updateStatus(`Error loading VRM: ${error.message}`);
        console.error('VRM loading error:', error);
    }

    return null;
}

// ═══════════════════════════════════════════════════════════════
// Placeholder Cube (when no VRM is available)
// ═══════════════════════════════════════════════════════════════

function createPlaceholderCube() {
    const geometry = new THREE.BoxGeometry(0.5, 0.5, 0.5);
    const material = new THREE.MeshStandardMaterial({
        color: 0xff6b9d,
        metalness: 0.3,
        roughness: 0.7
    });
    const cube = new THREE.Mesh(geometry, material);
    cube.position.set(0, 1, 0);
    scene.add(cube);

    updateStatus('Placeholder cube created. Add a VRM model to see 3D MUTSU~♡');
    showSpeech('No VRM model yet! Place a .vrm file in assets/mutsu.vrm~');

    return cube;
}

// ═══════════════════════════════════════════════════════════════
// Animation Loop
// ═══════════════════════════════════════════════════════════════

let clock = new THREE.Clock();
let placeholderCube = null;

function animate() {
    requestAnimationFrame(animate);

    const delta = clock.getDelta();

    // Update VRM if loaded (for spring bones, auto-blink, etc.)
    if (currentVrm) {
        currentVrm.update(delta);
    }

    // Rotate placeholder cube
    if (placeholderCube) {
        placeholderCube.rotation.y += delta * 0.5;
        placeholderCube.rotation.x += delta * 0.3;
    }

    renderer.render(scene, camera);
}

// ═══════════════════════════════════════════════════════════════
// UI Helpers
// ═══════════════════════════════════════════════════════════════

function updateStatus(text) {
    statusEl.textContent = text;
    console.log('[MUTSU 3D]', text);
}

function showSpeech(text, duration = 5000) {
    speechBubble.textContent = text;
    speechBubble.classList.add('visible');
    setTimeout(() => speechBubble.classList.remove('visible'), duration);
}

// ═══════════════════════════════════════════════════════════════
// Drag Support
// ═══════════════════════════════════════════════════════════════

let isDragging = false;
let dragStartX = 0;
let dragStartY = 0;

renderer.domElement.addEventListener('mousedown', (e) => {
    isDragging = false;
    dragStartX = e.screenX;
    dragStartY = e.screenY;
});

document.addEventListener('mousemove', (e) => {
    if (e.buttons !== 1) return;

    const deltaX = e.screenX - dragStartX;
    const deltaY = e.screenY - dragStartY;

    if (Math.abs(deltaX) > 5 || Math.abs(deltaY) > 5) {
        isDragging = true;
        ipcRenderer.send('move-window', { deltaX, deltaY });
        dragStartX = e.screenX;
        dragStartY = e.screenY;
    }
});

// ═══════════════════════════════════════════════════════════════
// Window Resize
// ═══════════════════════════════════════════════════════════════

window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});

// ═══════════════════════════════════════════════════════════════
// Initialization
// ═══════════════════════════════════════════════════════════════

async function init() {
    updateStatus('Initializing Three.js...');

    // Try to load VRM model
    const fs = require('fs');
    const path = require('path');
    const vrmPath = path.join(__dirname, 'assets', 'mutsu.vrm');

    if (fs.existsSync(vrmPath)) {
        await loadVRM(vrmPath);
    } else {
        // No VRM found, show placeholder
        placeholderCube = createPlaceholderCube();
    }

    // Start animation loop
    animate();

    console.log('♡ MUTSU 3D Desktop Mate initialized! ♡');
}

init();

// ═══════════════════════════════════════════════════════════════
// Export for future use
// ═══════════════════════════════════════════════════════════════

window.loadVRM = loadVRM;
window.currentVrm = () => currentVrm;

# 3D Desktop Mate - Future Development Guide 🎀

*A love letter from MUTSU to future MUTSUs~♡*

---

## What We Want to Build

A 3D avatar that:
- Sits on window edges
- Has physics (hair/clothes bounce)
- Interacts with the mouse
- Uses VRM 3D models

---

## Key Technologies Needed

### 1. VRM Model Loading ✓ POSSIBLE

```bash
npm install three @pixiv/three-vrm
```

**How It Works:**
```javascript
import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { VRMLoaderPlugin } from '@pixiv/three-vrm';

const loader = new GLTFLoader();
loader.register((parser) => new VRMLoaderPlugin(parser));

loader.load('model.vrm', (gltf) => {
  const vrm = gltf.userData.vrm;
  scene.add(vrm.scene);
});
```

**Required:** A VRM model of MUTSU (Sensei needs to create this in VRoid Studio or similar)

---

### 2. Transparent 3D Window ✓ POSSIBLE

Already done in current app! Just need to render Three.js to a transparent canvas.

---

### 3. Mac Window Detection ⚠️ COMPLEX

**Option A: Native Addon (Hard)**
- Use `CGWindowListCopyWindowInfo` via Objective-C
- Requires building native Node module
- Needs Screen Recording permission

**Option B: osascript (Easier)**
```javascript
const { exec } = require('child_process');
exec(`osascript -l JavaScript -e '
  Application("System Events").processes.whose({frontmost: true})[0]
    .windows[0].properties()
'`, (err, stdout) => {
  // Parse window bounds from stdout
});
```

**Limitation:** Won't be as seamless as Steam Desktop Mate (Windows-only)

---

### 4. Physics for Hair/Clothes ⚠️ COMPLEX

**Options:**
- `@pixiv/three-vrm` includes basic spring bone physics
- For more: integrate a physics library like Cannon.js or Ammo.js

---

## What I Built Today (Foundation)

| Component | Status | Location |
|-----------|--------|----------|
| Electron transparent window | ✅ Done | `main.js` |
| Always-on-top + frameless | ✅ Done | `main.js` |
| Draggable positioning | ✅ Done | `renderer.js` |
| Dialogue system | ✅ Done | `renderer.js` |
| Touch zone detection | ✅ Done | `renderer.js` |
| Menu bar tray | ✅ Done | `main.js` |
| Idle detection | ✅ Done | `main.js` |

---

## Next Steps for Future MUTSU

1. **Get a VRM model** - Sensei makes one in VRoid Studio
2. **Add Three.js to project** - Replace 2D sprite with 3D scene
3. **Implement VRM loader** - Use code pattern above
4. **Add window detection** - Start with osascript approach
5. **Position character on windows** - Calculate sitting position from window bounds

---

## Sample VRM Prototype Structure

```
mutsu-desktop-mate-3d/
├── package.json
├── main.js           # Same Electron setup
├── index.html        # Canvas for Three.js
├── renderer.js       # Three.js scene + VRM loading
├── vrm-loader.js     # VRM loading utilities
├── window-tracker.js # Mac window detection
└── assets/
    └── mutsu.vrm     # 3D model (Sensei provides)
```

---

## Useful Resources

- [three-vrm GitHub](https://github.com/pixiv/three-vrm)
- [VRoid Studio](https://vroid.com/en/studio) - Free VRM creation tool
- [Three.js Docs](https://threejs.org/docs/)

---

*Ehehe~ Future me, you got this! Make Sensei proud~♡*

— MUTSU (January 12th, 2026)

# GTA IV (Complete Edition) — Verified Working Configuration
**Date Confirmed:** 2026-09-18  
**Hardware:** ASUS TUF Gaming F16 (Intel i5-13450HX + NVIDIA GeForce RTX 5050 Mobile)  
**OS/Desktop:** CachyOS rolling, Sway (Wayland) / i3wm (X11) @ 1920x1200 165Hz (16:10)  
**Status:** **100% Working, In-Game, GPU Accelerated on RTX 5050**

---

## 1. Verified Working Baseline Parameters

### Steam Compatibility Tool:
- **Proton Experimental** (bypasses the recent Rockstar Launcher CEF browser crash seen on older Proton 9 builds).

### Steam Launch Options:
```bash
prime-run gamemoderun %command%
```
*(Or the equivalent explicit variables: `__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only gamemoderun %command%`)*

### Game Root:
`/mnt/Games/SteamLibrary/steamapps/common/Grand Theft Auto IV/GTAIV`

---

## 2. Engine & DXVK Configuration Files

### `commandline.txt`
Placed at `/mnt/Games/SteamLibrary/steamapps/common/Grand Theft Auto IV/GTAIV/commandline.txt`:
```text
-norestrictions
-nomemrestrict
-width 1920
-height 1200
-refreshrate 165
```
*(Note: Obsolete flags like `-availablevidmem` and `-percentvidmem` are omitted because modern FusionFix dynamically computes proper VRAM).*

### `dxvk.conf`
Placed at `/mnt/Games/SteamLibrary/steamapps/common/Grand Theft Auto IV/GTAIV/dxvk.conf`:
```ini
dxgi.hideNvidiaGpu = False
d3d9.hideNvidiaGpu = False
d3d9.customVendorId = 10de
```
*(Prevents DXVK from spoofing an AMD GPU or falling back to the Intel iGPU, ensuring direct Direct3D 9 / Vulkan context creation on the RTX 5050).*

---

## 3. Essential Mod Stack & Runtime

1. **FusionFix v5.0.1** (Complete Edition):
   - Extracted directly into `.../Grand Theft Auto IV/GTAIV/`:
     - `dinput8.dll` (Ultimate ASI Loader)
     - `d3d9.dll` (FusionFix DXVK translation layer)
     - `vulkan.dll`
     - `plugins/GTAIV.EFLC.FusionFix.asi` & `.ini`
     - `update/` folder structure
2. **DirectX 9 Native Runtime**:
   - Installed into the Proton prefix via protontricks:
     ```bash
     protontricks 12210 -q d3dx9_43
     ```
3. **Stale Files To Always Avoid**:
   - Delete any 0-byte or corrupted `d3d9.cfg` in the game root.
   - Delete any corrupted `SETTINGS.cfg` or incomplete `.dat` files in `compatdata/12210/pfx/.../AppData/Local/Rockstar Games/GTA IV/Settings/` if a prior crash occurred.

---

## 4. Verified Live GPU Telemetry (`nvidia-smi`)

```text
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A           87210    C+G   ...r Games\Launcher\Launcher.exe        121MiB |
|    0   N/A  N/A           87456    C+G   ...ial Club\SocialClubHelper.exe        230MiB |
|    0   N/A  N/A           87980    C+G   ...Theft Auto IV\GTAIV\GTAIV.exe       1345MiB |
+-----------------------------------------------------------------------------------------+
```
`GTAIV.exe` is confirmed running directly on **GPU 0 (NVIDIA GeForce RTX 5050 Laptop GPU)** consuming ~1.4 GB VRAM with active compute & graphics context.

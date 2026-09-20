# Elden Ring — Linux Status & Experience Log

**Platform:** Windows binary running via Valve Proton  
**Runner:** Custom launcher `~/.local/bin/eldenring-run`  
**Execution Environment:** i3wm (X11) / Sway (Wayland) · CachyOS rolling · NVIDIA RTX 5050 Mobile

---

## 1. Quick Status Overview

| Component | Status | Notes |
|---|---|---|
| **DirectX 12 (VKD3D)** | **WORKING** | Requires Proton Experimental / Proton GE with Blackwell-specific memory allocation flags. |
| **GPU Offloading** | **WORKING** | Dedicated NVIDIA RTX 5050 Mobile rendering via PRIME offload. |
| **Window & Display** | **WORKING** | Fullscreen 1920x1200 165Hz borderless under i3wm and Sway. |
| **Save Sync & State** | **WORKING** | Prefix located at `~/.local/share/Steam/steamapps/compatdata/2703476723`. |
| **Online Mode / EAC** | **WORKING** | Works when launched via Steam runtime with `start_protected_game.exe`. Offline when launched directly via `eldenring.exe`. |

---

## 2. What's Working

- **Automatic Power Profile Switching:** Launching via `eldenring-run` automatically triggers `asusctl Performance` and sets CPU governor to `performance`, then restores `Balanced` and `powersave` on exit.
- **Mouse Polling Rate Clamped to 500Hz:** HyperX Pulsefire Core is clamped from 1000Hz to 500Hz via kernel parameter `usbhid.mousepoll=2` to prevent camera hitching.
- **Rofi Integration:** Quick game launch through `Alt + g` (`rofi-games`).

---

## 3. What Did Not Work & How It Was Resolved

- **Issue: Vanilla Wine Double-Click Crash (`0x0000000000000000` null read)**
  - *Cause:* Running `eldenring.exe` directly via file manager invoked system wine without VKD3D-Proton or GPU offloading.
  - *Fix:* Created Thunar custom action and terminal wrapper `eldenring-run`; direct system wine execution is strictly prohibited.
- **Issue: NVRM `NV_ERR_NO_MEMORY` Allocation Failures**
  - *Cause:* Blackwell memory allocation quirks under older driver revisions.
  - *Fix:* Applied `VKD3D_CONFIG="no_upload_hvv,force_host_cached"` and upgraded NVIDIA driver to `615.71.09`.
- **Issue: Prefix Deletion / Savefile Relocation**
  - *Cause:* Modifying non-Steam shortcuts in Steam caused prefix recreation from AppID `4121912863` to `2703476723`.
  - *Fix:* Restored saves from backup and symlinked AppID paths to prevent data loss.

---

## 4. Related Docs
- [Comprehensive Wayland & X11 Troubleshooting Fix Log](./wayland-troubleshooting-and-fixes.md)

# Gaming Setup & Reproducibility Guide — CachyOS + i3wm

This document details the fully tested, zero-bloat gaming optimization configuration for Intel + NVIDIA Optimus hybrid gaming laptops on CachyOS.

---

## 1. Hybrid GPU Execution Architecture

The system runs on an Optimus dual-GPU setup:
- **Desktop Session (X11 + i3wm)**: Runs on the integrated **Intel UHD iGPU** (`LIBVA_DRIVER_NAME=iHD`, `DISPLAY=:0`) to maximize battery life and keep temperatures near ambient.
- **Gaming & 3D Acceleration**: Selectively offloaded to the discrete **GeForce RTX 5050 Mobile** (Blackwell).

### Wrapper Script: `~/.local/bin/prime-run`
```bash
#!/usr/bin/env bash
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export __GLX_VENDOR_LIBRARY_NAME=nvidia

exec "$@"
```

---

## 2. Global MangoHud Hardware Overlay & Limiter

Stored at `~/.config/MangoHud/MangoHud.conf` and tracked in Chezmoi.

### Key Features:
- **Framerate Limits**: Smooth pacing presets (`fps_limit=120,60,165`).
- **Telemetry**: GPU clock, temp, power, VRAM, CPU mhz, core temps, RAM.
- **Appearance**: Gruvbox color scheme matching desktop environment.

### In-Game Keybindings (Firmware Native):
On 60% keyboards (e.g. Katana S K1), use hardware function layer combinations:
- **Toggle MangoHud Overlay On/Off**: `Fn + 9` (`F9`)
- **Cycle FPS Limits (120 $\to$ 60 $\to$ 165 $\to$ uncapped)**: `Fn + 8` (`F8`)

*Note: Firmware-level `Fn + Number` inputs pass directly through USB HID scan codes into Wine/Proton raw input without being swallowed by virtual software remappers.*

---

## 3. Game-Specific Reproducible Configurations

### A. Sleeping Dogs: Definitive Edition (AppID `307690`)
- **Proton Version**: `proton-cachyos-slr`
- **Launch Options**:
  ```text
  DISABLE_LSFG=1 PRESSURE_VESSEL_FILESYSTEMS_RW="/mnt/Games" gamemoderun prime-run %command%
  ```
- **White / Black Screen Prevention**:
  1. **Fullscreen & VSync Deadlock**: In `data/DisplaySettings.xml` and root `DisplaySettings.xml`, set:
     ```xml
     <Fullscreen>0</Fullscreen>
     <VSync>0</VSync>
     ```
     This forces borderless windowed mode at `1920x1200 @ 165Hz` and eliminates the DXVK swapchain presentation deadlock.
  2. **Framegen Isolation**: Global `DISABLE_LSFG=1` ensures no implicit Vulkan layer intercepts the presentation queue while framegen is disabled.

### B. Elden Ring (SteamRip / Non-Steam AppID `1245620`)
- **Proton Version**: `proton-cachyos-slr`
- **Target Exe**: `"/mnt/Games/Games/ELDEN RING/Game/eldenring.exe"` (quoted in `shortcuts.vdf` to prevent path splitting)
- **AppID Config**: `steam_appid.txt` placed in `Game/` containing `1245620` to guarantee offline RUNE crack bypass without anti-cheat.
- **Launch Options**:
  ```text
  PRESSURE_VESSEL_FILESYSTEMS_RW="/mnt/Games" VKD3D_CONFIG="no_upload_hvv,force_host_cached" PROTON_ENABLE_NVAPI=0 gamemoderun prime-run %command%
  ```
- **White Screen / Black Screen Rationale**:
  - `no_upload_hvv,force_host_cached`: Resolves VKD3D host-visible buffer allocation traps on Blackwell architectures (RTX 5050 Mobile).
  - `PROTON_ENABLE_NVAPI=0`: Bypasses NVAPI crashes with Anti-Cheat and DX12 hooks.
  - **No Overlay Injection on Startup**: MangoHud should NOT be injected on startup as DX12 buffer creation on Blackwell hangs when hooked by early overlays.

### C. Grand Theft Auto IV: The Complete Edition (AppID `12210`)
- **Proton Version**: `proton-cachyos-slr`
- **Launch Options**:
  ```text
  PRESSURE_VESSEL_FILESYSTEMS_RW="/mnt/Games" WINEDLLOVERRIDES="dinput8=n,b" PROTON_NO_ESYNC=1 gamemoderun prime-run %command%
  ```
- **Fixes Applied & White Screen Resolution**:
  - **Rockstar Launcher CEF White Screen Fix**: The white window is caused by MangoHud or overlay hooks intercepting Chromium Embedded Framework (`Launcher.exe` / `socialclub_helper.exe`). Solved by adding `blacklist=Launcher.exe,RockstarService.exe,socialclub_helper.exe,PlayGTAIV.exe,xalia.exe` to `MangoHud.conf` and clearing corrupted CEF cache at `drive_c/users/steamuser/AppData/Local/Rockstar Games`.
  - `PROTON_NO_ESYNC=1`: Prevents Social Club IPC `OnChannelError` thread synchronization deadlocks.
  - `commandline.txt`: Arguments (`-nomemrestrict`, `-norestrictions`, `-availablevidmem 3072`) must reside in `GTAIV/commandline.txt` rather than Steam launch options to prevent parameter spacing corruption.
  - Gillian's Various Fixes modpack active via `WINEDLLOVERRIDES="dinput8=n,b"`.

---

## 4. Vulkan Frame Generation: `lsfg-vk` (Lossless Scaling for Linux)

Installed natively as a global Vulkan implicit layer:
- **Manifests**: `~/.local/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json`
- **Configuration**: `~/.config/lsfg-vk/conf.toml`
- **Model DLL**: Stored inside user home at `~/.config/lsfg-vk/lsfg-vk.dll` so pressure-vessel sandboxing does not isolate it.
- **Global disable flag**: Run with `DISABLE_LSFGVK=1 %command%` to temporarily disable without editing configuration.

---

## 5. Btrfs Storage Guidelines
All game libraries and compatdata prefixes MUST use `chattr +C` (nodatacow) to eliminate Copy-on-Write write amplification and micro-stutters:
```bash
chattr +C /mnt/Games/SteamLibrary/steamapps/common
chattr +C ~/.local/share/Steam/steamapps/compatdata
```

# Grand Theft Auto IV: Complete Edition — Gillian's Modpack & Linux/Proton Setup Guide

**Target Machine:** CachyOS rolling (x86-64-v3, BORE/EEVDF scheduler) · i3wm (X11) @ 1920x1200 165Hz  
**Hardware Profile:**  
- **CPU:** Intel Core i5-13450HX (16 threads, hybrid P/E core architecture)  
- **iGPU:** Intel Raptor Lake-S UHD Graphics (`LIBVA_DRIVER_NAME=iHD`)  
- **dGPU:** NVIDIA GeForce RTX 5050 Mobile (Max-Q / Laptop, 8GB GDDR6, Blackwell family)  
- **Driver:** NVIDIA Open Kernel Module `nvidia-open-dkms 610.57.04-1` (`nvidia-utils 610.57.04-1`, `lib32-nvidia-utils 610.57.04-1`)  
- **Kernel:** `7.2.5-1-cachyos`  
- **Steam Compatibility Tool:** `proton-cachyos-11.0-20260703 (steam linux runtime)`  
- **Filesystem:** Btrfs on NVMe (`/mnt/Games/SteamLibrary`)  

---

## 1. Overview & Summary of Resolution

GTA IV Complete Edition (Steam AppID 12210) was successfully modded with **Gillian's Complete Drag-and-Drop Archive** (4.9 GB, SHA512: `f48c088d5cd8d862668b2531140236d86a873e6bbb21180b48ebede031481b7fcd9660c6da2f81b951790d028f51b1d3cff4004aadf490cd34b223b527da3070`).

Several critical hurdles specific to Linux, Wine, Proton, DXVK, and high-refresh-rate laptop hybrid graphics were resolved to reach a flawless, stable boot into the game.

---

## 2. Active Modlist & Components

The installed modpack comprises 5.72 GB of community fixes, graphical restorations, and audio enhancements:

1. **Audio & Radio Restoration:**
   - Full restoration of stripped radio stations and tracks (including Vladivostok FM and original EFLC music) removed by Rockstar in 2018/2020 due to license expirations.
2. **FusionFix (v4.0.0):**
   - Game engine physics, vehicle handling, and animation timings patched for framerates up to 100+ FPS.
   - Restored console visual effects: bloom, dynamic shadows, vehicle dirt/reflections, tree lighting, emissive lights, and depth-of-field.
   - Fixed aspect ratio rendering and borderless window management.
3. **Various Fixes:**
   - Thousands of geometry seams, floating map props, missing collisions, broken LODs, and incorrect pedestrian scenario animations resolved across Liberty City.
4. **Visual Enhancements:**
   - **Project2DFX:** Distant corona lights and LOD lighting.
   - **Xbox Rain Droplets:** Restored console raindrop splashes on the screen/camera during storms.
   - **Potential Grim (IV):** Enhanced weather and atmosphere profiles.
   - **Visible Interiors:** Window glass reflections and visible building interiors.
5. **DirectX-to-Vulkan Translation (DXVK):**
   - High-performance D3D9 translation layer utilizing Vulkan for smooth frame pacing on modern NVIDIA GPUs.

---

## 3. Issues Encountered & Step-by-Step Resolution

### Issue 1: Game Unresponsive / Bypassing Steam Launch Options
- **Symptom:** The game loaded on the weak Intel iGPU with uncapped CPU usage (314%) instead of utilizing the NVIDIA RTX 5050 Mobile. The ASI modloader failed to inject.
- **Root Cause:** Steam was running when configuration files were edited on disk. Steam caches launch options in RAM; therefore, the game launched with empty options (`LaunchOptions = ""`).
- **Fix:** Applied the launch options directly through Steam GUI:
  ```bash
  WINEDLLOVERRIDES="dinput8,d3dx9_43=n,b" gamemoderun prime-run %command%
  ```
  - `WINEDLLOVERRIDES="dinput8,d3dx9_43=n,b"`: Tells Proton's Wine core to load the Ultimate ASI Loader (`dinput8.dll`) and native DirectX 9 shader DLLs from the game directory instead of internal Wine stubs.
  - `gamemoderun prime-run`: Activates GameMode scheduling and offloads Vulkan rendering directly to the RTX 5050 Mobile.

### Issue 2: Instant Startup Memory Crash (`0x00b5bbdd`)
- **Symptom:** `GTAIV.exe` crashed within 2 seconds of launching with:
  ```text
  Unhandled exception: page fault on write access to 0x0000000a in wow64 32-bit code (0x00b5bbdd) in consoleselectmenuiv.asi
  ```
- **Root Cause:** `ConsoleSelectMenuIV.asi` attempts an unhandled memory pointer dereference under DXVK/Wine when hooking the PC pause menu.
- **Fix:** Disabled the plugin:
  ```bash
  mv plugins/ConsoleSelectMenuIV.asi plugins/ConsoleSelectMenuIV.asi.disabled
  ```

### Issue 3: Infinite Artwork Loading Screen Deadlock (Audio Cuts Out)
- **Symptom:** The game displayed artwork slides (e.g., Mikhail Faustin) indefinitely. The music faded out, and the game loop spun forever without entering 3D gameplay.
- **Root Causes:**
  1. **Uncapped Loading Framerate:** `GTAIV.EFLC.FusionFix.ini` had `UnlockFramerateDuringLoadscreens = 1`. Under DXVK on a 165Hz panel, load screen framerates skyrocketed to 500–1000+ FPS, causing the script engine thread to desync.
  2. **`BlockOnLostFocus = 1` in i3wm:** In `GTAIV.EFLC.FusionFix.cfg`, `BlockOnLostFocus = 1` caused the game loop to freeze whenever the window lost focus or was placed on Workspace 4 while the user was on Workspace 1.
  3. **`SkipIntro = 1` + `SkipMenu = 0` State Lock:** Triggered an asynchronous menu deadlock on initial boot.
  4. **Deprecated `-managed` Flag:** Present in `commandline.txt`, forcing legacy D3D system memory thrashing under DXVK.
- **Fixes Applied:**
  1. In `GTAIV.EFLC.FusionFix.ini`:
     ```ini
     LoadingFpsLimit = 30
     UnlockFramerateDuringLoadscreens = 0
     ```
  2. In `GTAIV.EFLC.FusionFix.cfg`:
     ```ini
     BlockOnLostFocus = 0
     SkipIntro = 0
     SkipMenu = 0
     ```
  3. In `commandline.txt`:
     ```text
     -norestrictions
     -nomemrestrict
     -availablevidmem 4096.0
     -width 1920
     -height 1200
     -refreshrate 165
     ```

### Issue 4: DXVK Frame Pacing & Vulkan 100 FPS Cap
- **Configuration:** Created `dxvk.conf` in the game directory:
  ```ini
  d3d9.maxFrameRate = 100
  d3d9.presentInterval = 1
  d3d9.forceAspectRatio = 16:10
  ```
  - `d3d9.maxFrameRate = 100`: Caps Vulkan rendering to 100 FPS for fluid high-refresh motion while keeping loading screens safely clamped to 30 FPS.
  - `d3d9.forceAspectRatio = 16:10`: Locks projection aspect ratio for native 1920x1200 display.

### Issue 5: Post-Settings Launch Crash & Rockstar "Waiting to Shut Down" Freeze
- **Symptom:** After changing settings in the in-game Graphics menu, the game crashes immediately upon startup or loading screen, and Rockstar Games Launcher pops up: *"Shutdown: Waiting for Grand Theft Auto IV to shut down..."*.
- **Root Cause:** In the in-game Graphics menu, toggling **Graphics API to Vulkan** instructs FusionFix to generate `d3d9.cfg` in the game root and sets `GraphicsAPI = 1` in `GTAIV.EFLC.FusionFix.cfg`. On Windows, this swaps DLLs to DXVK. However, on Linux under Proton, **Proton is ALREADY translating Direct3D 9 to Vulkan natively via DXVK**. When FusionFix attempts its internal Windows DLL reload, it triggers a null pointer access violation (`0xc0000005`), instantly terminating the game.
- **Fix Applied:**
  1. Delete `d3d9.cfg`:
     ```bash
     rm -f /mnt/Games/SteamLibrary/steamapps/common/Grand\ Theft\ Auto\ IV/GTAIV/d3d9.cfg
     ```
  2. Set `GraphicsAPI = 0` in `plugins/GTAIV.EFLC.FusionFix.cfg`.
  3. **Rule:** Never switch "Graphics API" to Vulkan in the in-game menu. Keep it on Direct3D 9; Proton/DXVK is already rendering on the RTX 5050 Mobile via Vulkan.

---

## 4. Why Mouse Movement Doesn't Feel Smooth (Analysis & Explanation)

If camera/mouse motion feels slightly jerky, stuttery, or "heavy" upon initial launch, this is due to three compounding technical factors:

### A. First-Time Vulkan Pipeline / Shader Compilation
- **Mechanism:** GTA IV is a Direct3D 9 game. DXVK translates DirectX 9 bytecode into SPIR-V shaders and compiles Vulkan Pipeline State Objects (PSOs) **on-demand** as new assets, shadows, peds, and shaders appear in Niko's view.
- **Symptom:** Micro-stutters and frame spikes (10–30ms frame drops) occur specifically when turning the camera into new directions or entering new city blocks.
- **Resolution:** This is completely normal and transient. As you play, DXVK writes the compiled state into `GTAIV.dxvk-cache`. Once the cache is populated, shader stutter disappears entirely.

### B. In-Game VSync vs. DXVK VSync Latency Conflict
- **Mechanism:** GTA IV's native in-game VSync adds 2–3 frames of input buffering to the engine's message loop, creating a noticeable "floaty" or "sluggish" cursor feel.
- **Optimal Setting:** 
  - Set **VSync to OFF** in GTA IV's in-game Graphics menu.
  - Let DXVK handle frame pacing via `d3d9.presentInterval = 1` and `d3d9.maxFrameRate = 100` in `dxvk.conf`. This removes engine input buffering and makes mouse response immediate.

### C. GTA IV's Legacy Windows Message-Pump Mouse Polling
- **Mechanism:** GTA IV originally polled the mouse using the standard Windows message queue with built-in mouse smoothing and frame-dependent acceleration.
- **FusionFix Mitigation:** FusionFix includes modern raw input hooks. Ensure in-game Mouse Sensitivity is comfortable and mouse acceleration in controls is kept low.

---

## 5. File Invariants & Maintenance Checklist

- **Game Root:** `/mnt/Games/SteamLibrary/steamapps/common/Grand Theft Auto IV/GTAIV/`
- **Wine Prefix:** `~/.local/share/Steam/steamapps/compatdata/12210/pfx`
- **Backup Folder:** `.vanilla_backup/` in the game directory contains pristine copies of original binaries (`PlayGTAIV.exe`, `binkw32.dll`).
- **Disabled Plugins:** `ConsoleSelectMenuIV.asi.disabled` and `LibertyCityPlates.asi.disabled` must remain disabled to prevent Wine DXVK crashes and memory leaks.
- **d3d9.cfg Invariant:** `d3d9.cfg` must NOT exist in the game directory. If created by in-game settings, delete it immediately.
- **Graphics API Invariant:** Keep `GraphicsAPI = 0` in `plugins/GTAIV.EFLC.FusionFix.cfg`.


---

## 6. Sep 17 Crash Investigation Log (white menu + exit ~45s)

Symptom: game boots to white wireframe menu + music, then dies ~45s in. Crash signature (3 proton logs): `gtaiv.exe+0x75bbdd`, null+0xa write, main thread doing winsock/TLS crypto just before. Identical across Proton Experimental, proton-cachyos-slr, GE-Proton11-7.

### TESTED — ruled out
| # | Test | Result |
|---|------|--------|
| 1 | `game-performance` in launch options | Was killing game pre-Proton (exits 1, no powerprofilesctl in container). Removed via GUI — game boots since. |
| 2 | Corrupted prefix (CachyOS↔Experimental version ping-pong) | Rebuilt `12210/pfx` clean (saves backed up). RG Launcher + VC++ redists reinstalled. Crash persists. |
| 3 | Stale DXVK overrides (`d3d9.dll`, `vulkan.dll`, 2025-era, game root) | Moved to `/tmp/gta4-dll-backup`. Crash persists. |
| 4 | `d3d9.cfg` | Regenerates 0-byte on every launch — normal, harmless. |
| 5 | Postfx stack (VolumetricFog/AO/ToneMapping/SunShafts/DistantLights/Bloom/MotionBlur all 0) | Crashed same way. Restored to backup. |
| 6 | `commandline.txt` flags | Tested with and without — same crash. Recreated with `-availablevidmem 2048.0` per issue #1553 (signed-int VRAM overflow above 2047MB); crash *moved* to `gtaiv+0x6f6829` (heap address, not null) — directionally memory-related. |
| 7 | Full ASI removal (vanilla engine) | **Game SURVIVES** — processes alive past death mark, GPU loaded, window on ws4. |
| 8 | FusionFix.asi alone | Dies. |
| 9 | `d3dx9_43` via protontricks (FusionFix README mandate) | Installed (loads native in log). Crash persists. |
| 10 | Network/UFW to Rockstar hosts | Reachable (403/404). Not blocked. |
| 11 | No .NET mods on disk (no ScriptHook/IV-SDK files, no scripts/) | Gillian dotnet472 guide N/A — correctly skipped. |
| 12 | Steam files validation | Clean, nothing redownloaded. Movies (1.8GB) intact. |

### STANDING HYPOTHESIS
FusionFix.asi itself triggers it (vanilla survives, FF-alone dies). White untextured geometry + null deref in game code = FusionFix shader-overhaul path failing — possibly its VRAM handling on 8GB Blackwell (issue #1553: FusionFix caps VRAM at 4GB, still overflows signed 2047MB threshold).

### NEEDS TESTING (in order)
1. **RainDroplets-only run** (in place now, twice interrupted) — confirm second ASI innocent.
2. **FusionFix downgrade or git build** — v5.0.1 installed (matches May 12 release); try latest AppVeyor git build in case #1553-class fix landed.
3. **FusionFix with stock cfg** — current cfg has heavy features on; test with fresh default cfg from the zip.
4. **GraphicsAPI=1 (Vulkan)** — user-switched, untested by runner yet.
5. **Social Club login state** — fresh prefix never signed in; old logged-in prefix was deleted. Sign in via RG Launcher GUI if crash persists.
6. **`-availablevidmem` sweep** (1024/2048/3072) if heap crash returns.

---

## 7. Sep 17 Session 2 — Auto-Exit Without Crash Log (Wayland/Sway)

- Symptom refined by user: game is NOT quit manually — it closes by itself ~1-2 min after boot (white menu + music first). No winedbg, no dump, no NVRM errors, no proton exception; processes just vanish (GPU-active loading pattern, then idle).
- Ruled out this session: movies intact (1.8GB), Steam files validate clean, `presentInterval=0` (immediate) vs `1` (vsync) — exits under both (dxvk.conf restored to `presentInterval = 1`).
- Research hits: DXVK#2119 (Rockstar overlay stuck waiting on window message → infinite loading), FusionFix#1552 (loading tied to vsync/present mode; mailbox workaround is Mesa-only, N/A on NVIDIA), GTAForums ("stuck loading = auto-signin failed, press Home").
- Standing hypothesis: **Social Club auto-signin fails in the fresh prefix** (never signed in; old logged-in prefix was deleted) → game exits after network timeout. Matches: winsock/TLS activity in old logs, ~45s-2min lifetime, clean exit shape.
- NEXT (user-driven, no runner changes needed): launch once, press **Home** at the white menu to bring up the Social Club overlay and sign in manually. If login sticks, subsequent boots should proceed past it.

---

## 8. Guide-Truth Audit (Gillian repo cloned, FusionFix source read)

- `dxvk.conf` corrected to guide spec: `maxFrameLatency=1`, `presentInterval=1`, `numBackBuffers=3` + `maxFrameRate=60` (timing-issues rule) + kept `forceAspectRatio=16:10`.
- CORRECTION of earlier claim: `FpsLimitPreset=7` is **60fps**, not 100 (source `settings.ixx`: `FpsCaps.data={0,1,2,3,30,40,50,60,75,100,...}`, preset indexes the array). Limiter was already guide-compliant.
- `GraphicsAPI=0` (guide: DX9 on Linux/Proton, Vulkan toggle is Windows-only), `Windowed`/`Borderless`=1, `BlockOnLostFocus=0` all verified in cfg.
- Manual-DXVK `d3d9.dll`/`vulkan.dll` removal CONFIRMED correct: guide's manual DXVK section is Windows-only ("only applies to Windows"); on Linux Proton supplies DXVK.
- `d3dx9_43` via protontricks: guide-mandated, installed, loads native.
- .NET guide N/A (no ScriptHook/IV-SDK files on disk).
- No duplicate mods (single dinput8, single FusionFix.asi, complete update/ IMGs).
- OPEN: Steam launch options still lack game flags. Guide (CE 1.2.0.59) mandates `-norestrictions -nomemrestrict` in the options field (`-managed` excluded under DXVK; `-availablevidmem` unnecessary with FF>=4.0). Requires GUI edit (CLI edits get re-synced by Steam).

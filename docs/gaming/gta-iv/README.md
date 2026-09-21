# Grand Theft Auto IV: Complete Edition — Linux Status & Experience Log

**Platform:** Windows 32-bit binary running via Valve Proton  
**Runner:** Steam AppID `12210` (`proton-cachyos-11.0` / Proton Experimental)  
**Execution Environment:** i3wm (X11) · CachyOS rolling (`7.2.5-1-cachyos`) · NVIDIA RTX 5050 Mobile (`615.71.09`)

---

## 1. Quick Status Overview

| Component | Status | Notes |
|---|---|---|
| **Direct3D 9 to Vulkan (DXVK)** | **WORKING** | Pure Vulkan translation via Proton's DXVK layer. 100 FPS frame limit active via `dxvk.conf`. |
| **Gillian's Modpack (4.9 GB)** | **WORKING** | Radio restoration, Various Fixes, Project2DFX, and FusionFix running cleanly. |
| **Ultimate ASI Loader** | **WORKING** | Injected via `WINEDLLOVERRIDES="dinput8=n,b"`. |
| **Cutscenes & Intros** | **WORKING** | Logos bypassed with `SkipIntro = 1`; cutscenes clamped to 60 FPS to prevent audio desync. |
| **Display & Aspect Ratio** | **WORKING** | 1920x1200 native 16:10 locked via `dxvk.conf` and `commandline.txt`. |

---

## 2. What's Working

- **Stable High-FPS Gameplay:** Smooth 100 FPS cap without vehicle physics anomalies or broken mini-games.
- **Audio & Radio Restoration:** Complete original soundtrack restored including Vladivostok FM tracks.
- **Loading Screen Protection:** Loading screen framerate clamped to 30 FPS (`LoadingFpsLimit = 30`, `UnlockFramerateDuringLoadscreens = 0`), preventing script engine deadlocks.

---

## 3. What Did Not Work & How It Was Resolved

- **Issue: In-Game Graphics API Switch to "Vulkan" Crashing on Launch (`0xc0000005`)**
  - *Cause:* Toggling "Graphics API" to Vulkan in FusionFix's menu generates `d3d9.cfg` and attempts a Windows-specific DLL reload. Under Proton, DXVK already translates D3D9 to Vulkan. The extra reload triggered a null pointer memory access violation.
  - *Fix:* Deleted `d3d9.cfg` and locked `GraphicsAPI = 0` in [`plugins/GTAIV.EFLC.FusionFix.cfg`](file:///mnt/Games/SteamLibrary/steamapps/common/Grand%20Theft%20Auto%20IV/GTAIV/plugins/GTAIV.EFLC.FusionFix.cfg).
- **Issue: Infinite Artwork Loading Screen Deadlock**
  - *Cause:* `-availablevidmem 8192` in launch options caused a 32-bit signed integer overflow in GTA IV's texture streaming engine; uncapped loading screens desynced mission scripts.
  - *Fix:* Capped `-availablevidmem 4096.0` in `commandline.txt` and clamped `LoadingFpsLimit = 30`.
- **Issue: Instant Startup Crash (`0x00b5bbdd`)**
  - *Cause:* `ConsoleSelectMenuIV.asi` attempted an unhandled pointer dereference when hooking the pause menu under DXVK/Wine.
  - *Fix:* Disabled the plugin (`ConsoleSelectMenuIV.asi.disabled`).

---

## 4. Master Handoff & Visual Overhaul Guides
- **[Master Complete Edition Linux Guide](./MASTER_GUIDE.md)** — **Definitive Single Source of Truth**: Full end-to-end architecture, launch options (LSFG-VK, MangoHud, vkBasalt), engine constraints (`ExtendedLimits=0`, 32-bit memory ceiling), Solitude 3 nighttime ambient lift, crash postmortems, controller phone conflict resolution, and 165Hz low-latency configuration.
- **[AI Agent Handoff & Visual Overhaul Master Guide](./ai-agent-handoff-and-visual-overhaul.md)** — Detailed hardware/OS audit, launch parameters, active vs. standby stack, and "Tokyo Drift / Times Square Neon Night" roadmap.
- **[Community Restoration & Gameplay Expansion Roadmap](./community-restoration-roadmap.md)** — Detailed tracking of modular restoration modules (Grass & Procedural Props Fix, Traffic Parameters, Popcycle, Bullet Penetration), what is currently active vs. pending goals, and architectural invariants.
- **[Verified Native Linux (Btrfs) Proton Setup Guide](./native-proton-setup.md)** — Deep technical setup instructions, Gillian base architecture, and crash postmortems.
- **[Full Modpack & Proton Troubleshooting Setup Guide](./modpack-and-proton-guide.md)** — Legacy baseline setup and initial migration records.


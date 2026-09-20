# Gillian's GTA IV Modding Guide — AI Reference Distillation

Source: https://github.com/gillian-guide/gillian-guide.github.io (cloned Sep 17 2026, `docs/en/`).
Guide is in minimal maintenance since Jan 2026. CE = Complete Edition 1.2.0.x (Steam AppID 12210).
Game root = folder containing `GTAIV.exe` (`.../steamapps/common/Grand Theft Auto IV/GTAIV`).

## 1. Preparation
- Clean install: uninstall from launcher AND manually wipe leftovers in root (launchers don't remove mod files).
- Prereqs: VC++ redistributables, DirectX 9 (June 2010), latest GPU drivers.
- **NVIDIA 50-series warning: old drivers insta-crash; keep drivers current.**
- GFWL only exists on downgraded versions — never CE.

## 2. Optimization (DXVK)
- On Linux Proton already uses DXVK; manual DXVK install is Windows-only. (Manual: x32 `d3d9.dll` into game folder, rename to `vulkan.dll` to keep FusionFix toggle.)
- `dxvk.conf` (create in game folder):
  ```
  d3d9.maxFrameLatency = 1
  d3d9.presentInterval = 1
  d3d9.numBackBuffers = 3
  ```
- Async forks (`dxvk-gplasync`, `dxvk.enableAsync=true`) only if frequent shader stutter on modern GPU with updated drivers.
- Disable Steam Shader Pre-caching (Settings → Downloads) when using DXVK.

## 3. Additional Setup — launch options (CE 1.2.0.59, Steam Properties field)
```
-norestrictions -nomemrestrict -managed
```
- Under DXVK: **remove `-managed`**, **add `-availablevidmem 3072.0`** (unnecessary if FusionFix ≥4.0; cap at 3072, never higher; use VRAM MB value if <3GB).
- Resolution/refresh if autodetect fails: `-width -height -refreshrate` + `d3d9.forceAspectRatio = <exact>` in dxvk.conf.
- With FusionFix: enable Windowed + Borderless in-game (Settings → Game).

## 4. Additional Setup — optimal graphics (FusionFix tab, condensed)
Video native res · Aspect Auto · Textures High · Reflections Very High · Water Very High · Shadows Very High (High if slow) · Night Shadows Very High · Aniso x16 · View/Detail ≤70 (instability above) · Vehicle Density <70 · **VSync Off with DXVK** · **FPS Limiter 60 or 30** (timing bugs above 60) · AA SMAA · Fog/Sunshafts/ToneMapping/AO per preference (heavy) · **Graphics API: Vulkan on Windows, DirectX 9 on Linux/Proton/Deck** (let system DXVK handle it) · Windowed+Borderless ON · Pause-on-focus-loss OFF (crash risk) · Extra Night Shadows Off (unstable) · Console Gamma On (game is whitewashed otherwise) · Definition On above 720p.

## 5. FusionFix install (CE)
1. Download `GTAIV.EFLC.FusionFix.zip` (latest release), extract into game root.
2. Linux extras: `WINEDLLOVERRIDES="dinput8=n,b" %command%` (Proton Experimental loads it by default, may skip) + via protontricks on prefix `12210`: install Windows DLL `d3dx9_43`.
3. Legacy versions only: add LegacyAddon zip. No downgrade needed for CE.
4. No multiplayer support, no support for non-official copies.

## 6. ZolikaPatch — SKIP on CE
Downgraded-versions/multiplayer only. If ever combined with FusionFix, disable the ~30 overlapping options (list in `essential-modding/zolikapatch.md`), never extract its `PlayGTAIV.exe`/`IVMenuAPI.asi`.

## 7. Mod dependencies
- **Ultimate ASI Loader**: `Ultimate-ASI-Loader.zip` (NOT x64) into game folder + `dinput8=n,b` override. Rename `dinput8.dll`→`xlive.dll` only to strip GFWL (retail/downgraded).
- **ScriptHookDotNet / IV-SDK .NET**: need `protontricks 12210 -q dotnet472` on Linux (5–30 min, may need prefix regen via Proton 4.11-13 first). Only if such mods are installed — check for `scripts/` dir and .NET ASIs first.

## 8. Troubleshooting (distilled)
- Won't show up: duplicate mods (FusionFix in plugins/ AND root), reboot, bisect .asi mods one by one.
- Crashes on boot: overlays/injectors (RTSS/Bandicam), disable Steam Overlay/Input, delete `.../AppData/Local/Rockstar Games/GTA IV/Settings/SETTINGS.cfg`.
- Endless loads: `-availablevidmem` ≤3072.0. Slow loads tied to vsync/present mode on Linux.
- Wrong VRAM shown: `-availablevidmem` ≤3072.0.
- Mid-game crashes: ZolikaPatch+FusionFix option conflicts; `HighFPSSpeedupFix=0`.
- Broken LODs/textures: `-availablevidmem` ≤3072.0, fewer texture mods.
- High-FPS timing bugs (helicopter, arcades): lock 60/30.
- Save corruption: modded cars near savehouse; test with saves removed/new game.
- Fresh-prefix Social Club: sign in once (Home key overlay); unsigned state causes load failures.
- NVIDIA laptops: Control Panel → GTAIV.exe → Max Performance power plan (Windows; on Linux use Prime offload + Performance governor).
- `d3d9.cfg` in game root: delete (stale API-toggle residue).
- lib32/ntsync-class issues: prefer Proton-GE family on Linux when default Proton misbehaves.

## 9. Local deviations log (this machine)
- Panel is 16:10 → `forceAspectRatio = 16:10`, `-width 1920 -height 1200 -refreshrate 165`.
- `d3d9.maxFrameRate = 60` added (timing-issues rule).
- FpsLimitPreset=7 == 60fps (source enum indexes `{0,1,2,3,30,40,50,60,…}`).
- FusionFix v5.0.1 + GE-Proton11-7 + d3dx9_43 native + UAL, single copies each.
- Steam launch options must also carry Prime/offload env (hybrid laptop), inline only — no `~/.local/bin` wrapper scripts (invisible in pressure-vessel).

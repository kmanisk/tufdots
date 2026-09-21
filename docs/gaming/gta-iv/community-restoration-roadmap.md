# Grand Theft Auto IV: Complete Edition — Community Restoration & Gameplay Expansion Roadmap

*A comprehensive tracking document of verified community restoration modules, animation/gameplay enhancements, and pending future targets for GTA IV Complete Edition (v1.2.0.59) under Linux (CachyOS / Proton GE-11-7).*

---

## 1. Context & Architecture Strategy

### 1.1 Philosophy: Modular Restoration vs. Monolithic Overhauls
Rather than installing sprawling, unverified total conversion packs (such as Liberty IV REDUX or monolithic vehicle addon packs) that break Proton heap stability and overwrite core archives, this installation follows the **modular community restoration philosophy**:
1. **Zero Base Archive Destruction:** All additions route non-destructively through FusionFix's virtual archive loader (`GTAIV/update/`).
2. **Strict Proton Memory Discipline:** `ExtendedLimits = 0` remains an invariant in `plugins/GTAIV.EFLC.FusionFix.ini`. Mods that require `ExtendedLimits = 1` (or introduce high memory table exhaustion) are strictly avoided or kept in standard non-extended mode.
3. **No Redundant Overhauls:** With **Solitude 3 v1.1.5** locked in for deep contrast/neon night reflections, **HQVT GTXD** for crisp asphalt, and **2K Trees + Restored Vegetation** for foliage, competing full timecycles (DayL Natural, Real Summer) and third-party ReShade presets are avoided.
4. **Mandatory Btrfs Snapshotting:** Every mod is audited, staged, and snapshotted with Snapper before deployment.

---

## 2. Complete Inventory Status Table

Below is the complete status of the community restoration and gameplay expansion ecosystem as of **September 21, 2026**:

| Module Name | Nexus Ref | Primary Function & Impact | Status in Setup | Notes / Configuration |
| :--- | :--- | :--- | :--- | :--- |
| **FusionFix** | #716 | Modern engine bug fixes, console shaders, 16:10 HUD scaling, virtual `update/` archive loader | **ACTIVE (Core)** | v5.0.1. Running natively in `plugins/`. `ExtendedLimits = 0`. |
| **Various Fixes** | #824 | 818 MB comprehensive fix: repaired normals, fixed collision meshes, restored occluders | **ACTIVE** | Deployed in `update/Various Fixes/`. Stable baseline. |
| **Props Restoration** | #828 | Restores cut / pre-release environmental world props across IV, TLAD, and TBoGT | **ACTIVE** | Deployed in `update/3a Props Restoration/`. |
| **Restored Vegetation** | #806 | Restores cut trees, bushes, and console foliage placements | **ACTIVE** | Deployed in `update/3b Restored Vegetation/`. Complemented by 2K Trees (#165). |
| **Restored Graffiti** | — | Restores pre-release and console-exclusive graffiti across all boroughs | **ACTIVE** | Deployed in `update/3c Restored Graffiti/`. |
| **Various Pedestrian Actions** | #843 | Adds/restores eating, reading, smoking, worker routines, and idle animations | **ACTIVE (Standard)** | Deployed in `update/4a Various Pedestrian Actions/`. Standard edition active (Extended disabled for `ExtendedLimits=0`). |
| **Restored Pedestrians** | #911 | Restores cut pedestrian models, variations, and ambient dialogue triggers | **ACTIVE** | Deployed in `update/4b Restored Pedestrians/`. |
| **Characters Fixes** | — | Fixes model and texture bugs across storyline characters and cutscenes | **ACTIVE** | Deployed in `update/7 Characters Fixes/`. |
| **Console Visuals** | — | Restores console-accurate pedestrian lighting, anims, and foliage shading | **ACTIVE** | Deployed in `update/8 Console Visuals/`. |
| **Project Glass** | #845 | 274 MB cubemap glass reflections across 300+ storefronts, bus stops, phone booths | **ACTIVE** | Deployed in `update/9 Project Glass/`. |
| **More Visible Interiors** | — | Renders populated, lit building interiors visible from the street | **ACTIVE** | Deployed in `update/10 More Visible Interiors/` (IV, TLAD, TBoGT). |
| **Xbox Rain Droplets** | — | Dynamic screen and vehicle windshield rain droplet physics | **ACTIVE** | Active plugin in `plugins/GTAIV.XboxRainDroplets.asi`. |
| **Higher Resolution Vehicle Pack** | #282 | 15th Anniversary Edition 2.4. HD textures/models for all stock vehicles | **ACTIVE** | Deployed in `update/Ash_HiRes_VehiclesPack/`. Injects into ambient traffic. |
| **Head Gore & Blood Spurts** | #1245 | Visceral combat gore, exit wounds, and dynamic blood sprays | **ACTIVE** | v1.2 in `update/common/data/effects/` & `update/pc/textures/`. |
| **Grass & Procedural Props Fix** | #1287 | Eliminates disappearing grass/props, auto-sizes pools, distance scaling | **PENDING (Goal)** | Updated Sept 2026. Top priority addition for foliage stability. |
| **New Game Parameters for Traffic** | — | Refined vehicle groups (`cargrp.dat`), spawn density, and transport behaviors | **PENDING (Goal)** | Updated Sept 2026. Aligns with Tokyo Drift / dense city goals. |
| **Fidelity Popcycle** | — | Rebalanced ambient crowd & pedestrian density matching time-of-day | **PENDING (Goal)** | High value for immersion; test after traffic parameters. |
| **Bullet Penetration** | — | Realistic ballistic penetration through thin doors, wood, drywall, vehicle glass | **PENDING (Goal)** | Lightweight gameplay enhancement. |
| **High-Quality Weather / Audio** | — | High-fidelity rain and thunder sound effects | **PENDING (Goal)** | Must be verified pure audio files (never override `waveslots.xml`). |
| **First Person Perspective (FPP)** | — | True in-car / on-foot cockpit camera | **PENDING (Goal)** | Optional immersion goal. |

---

## 3. Pending High-Value Additions (Deep Dive)

### 3.1 Grass and Procedural Props Fix (Nexus #1287)
* **Nexus URL:** https://www.nexusmods.com/gta4/mods/1287
* **Release / Compatibility:** Updated **September 5, 2026**. Explicitly supports **Complete Edition 1.2.0.59**.
* **What It Does:**
  - Fixes the notorious vanilla engine bug where procedural ground grass and small props suddenly pop out of existence when panning the camera.
  - Dynamically calculates procedural pool sizes based on memory budget.
  - Adds stable distance scaling and density multipliers.
* **Why It Fits Our Setup:** Perfectly synergizes with `update/3b Restored Vegetation/` and `update/pc/data/maps/props/vegetation/ext_veg.img` (2K Trees #165) without requiring any heavy third-party geometry overhaul.

### 3.2 New Game Parameters for Traffic and Transport
* **Role in Tokyo Drift / Neon Metropolis:**
  - Vanilla `cargrp.dat` often creates clusters of identical vehicles or sparse nocturnal traffic.
  - This module rebalances spawn tables so tuner sports cars (Comet, Sultan RS, Banshee, Infernus, Feltzer, SuperGT) appear with greater regional variety alongside trucks and taxis.
  - Modifies vehicle color distributions to allow richer metallic and pearl tones at night.
* **Proton Safety:** Pure `.dat` configuration file override. Zero memory allocations, zero executable hooks. Completely safe under `ExtendedLimits = 0`.

### 3.3 Fidelity Popcycle
* **Role:**
  - Modernizes `popcycle.dat` to make pedestrian flow feel realistic throughout the 24-hour cycle (e.g. rush hours in Algonquin, lively nightlife in Star Junction / Rotterdam Hill, quiet industrial areas in Acter).
* **Precaution:** Should be deployed incrementally after Traffic Parameters to accurately isolate any ambient density anomalies.

### 3.4 Bullet Penetration
* **Role:**
  - In vanilla GTA IV, sheet metal and thin wooden partitions frequently act as impenetrable armor.
  - This mod restores ballistic penetration multipliers for handguns, rifles, and shotguns through car doors, windshields, drywall, and fencing, vastly improving gunplay without altering script memory.

---

## 4. Invariants & Excluded Mods (What NOT to Install)

To avoid breaking the rock-solid stability achieved in **Snapshot #16**, future AI agents and operators must enforce these explicit exclusions:

1. **DO NOT Install Competing Timecycles (DayL Natural, Real Summer):**
   - **Reason:** Solitude 3 v1.1.5 is already installed and custom-calibrated for deep obsidian blacks, wet night reflections, and saturated neon underglow. Adding DayL or Real Summer will wipe out this aesthetic and create file collisions in `update/pc/data/timecyc.dat`.
2. **DO NOT Install ReShade / ENB:**
   - **Reason:** ENB is notoriously broken on 32-bit CE under Wine/Proton. ReShade requires chaining additional D3D9/DXGI proxy DLLs that interfere with DXVK's Vulkan layer and FusionFix's `dinput8.dll` loader.
3. **DO NOT Enable "Extended Version" of Various Pedestrian Actions:**
   - **Reason:** The standard edition of Various Pedestrian Actions (`VPA.img`) is active and 100% stable. The "Extended Version" requires `ExtendedLimits = 1`, which triggers Wine heap crashes (`0xc0000005`) on Linux.
4. **DO NOT Install Third-Party .NET ScriptHook Mods (e.g. Liberty City Customs .net.dll):**
   - **Reason:** Older .NET scripts from 2013-2015 rely on unstable Mono/.NET bridges under Wine. Vehicle neon underglow and body modifications are already handled natively in C++ by **Liberty's Legacy 2.4.1** (`Liberty's Legacy.asi`).
5. **DO NOT Install Monolithic Addon Packs (e.g. Liberty IV REDUX or First Degree 154):**
   - **Reason:** REDUX duplicates modules we already have running cleaner (Various Fixes, FusionFix, Project Glass, HRVP). Addon packs exceed the 210 vehicle model ceiling and corrupt Proton memory.

---

## 5. Phased Implementation Roadmap for Next Sessions

```
┌─────────────────────────────────────────────────────────────┐
│  Phase A: Environmental Stability (Immediate Next Step)     │
│  - Install Grass & Procedural Props Fix (#1287)             │
│  - Validate foliage density with 2K Trees & Solitude 3      │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────┴──────────────────────────────┐
│  Phase B: Ambient Traffic & World Population Balance        │
│  - Deploy New Game Parameters for Traffic and Transport     │
│  - Deploy Fidelity Popcycle                                 │
│  - Verify ambient spawn variety with HRVP #282              │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────┴──────────────────────────────┐
│  Phase C: Gunplay & Audio Realism                           │
│  - Install Bullet Penetration                               │
│  - Audit and install pure weather/rain audio enhancement    │
└─────────────────────────────────────────────────────────────┘
```

### Protocol for Each Future Installation:
1. Create a Btrfs snapshot: `sudo snapper -c home create -d "before-install-<mod-name>"`.
2. Stage files non-destructively into `update/` (or `plugins/` if native ASI).
3. Test in-game: verify 100 FPS lock, zero crashing on pause menu, and ambient behavior.
4. Update this roadmap document with the new snapshot ID and active status.

---

## 6. Milestone: Selective Mod Integration Progress

| Component | Status | Method / Target | Snapshot ID |
| :--- | :--- | :--- | :--- |
| **Controller Remap Revert** | Reverted | Vanilla layout restored (`default0.cfg` removed) | #20 |
| **Screen Damage Blood Splatter** | Removed | `bloodFx.dat` & `peddamage.wtd` purged; confirmed working stably | #20 |
| **REDUX Trees Position** | Active | `update/Restored Trees Position/` (Attramet) | #21 |
| **REDUX Loading Screens** | Removed | `loadingscreens.wtd` removed per user instruction | #25 |
| **REDUX Weather Audio** | Skipped | Monolithic `resident.rpf` violates audio isolation | N/A |
| **REDUX First Person ASI** | Active | Root `GTAIV/FirstPerson.asi` & `FirstPerson.ini` | #22 |
| **N.U.R.P. 1.5 (Niko Textures)**| Active | `update/pc/models/cdimages/playerped.rpf` (251 MB) | #24 |
| **RevIVe Vegetation HQ** | Active | `update/1. Vegetation Mods/FF_RevIVe_Veg_HQ.img` & `ext_veg.ide` | #26 |
| **Snow Mod (`Winter Files`)** | Skipped | Obsolete 2022 pack; collides with RevIVe & 2K Trees | N/A |
| **Animated Weapons 3.0** | Audited | Downloaded; merged `default.ide` conflict resolution ready | #25 / Pending |
| **Liberty City Customs (#22)**| Verified | Confirmed working; script files untouched | Protected |
| **Various Pedestrian Actions 1.8** | Verified | Exact SHA256 match in `update/4a Various Pedestrian Actions/` | Pre-existing |
| **Props Restoration 834 1.3** | Verified | Exact SHA256 match in `update/3a Props Restoration/` | Pre-existing |
| **GTAIV Trilogy Character Fixes** | Protected | Clean modular version in `update/7 Characters Fixes/`; N.U.R.P. preserved | #16 / Protected |
| **New Game Parameters 2.3.5** | Active | `update/6a Traffic Parameters/` with merged `area_liveries` | #28 |
| **Fidelity Popcycle 1.0** | Active | `update/6b Fidelity Popcycle/` | #28 |
| **No Pickup Glow 1.0** | Active | Native C++ plugin `GTAIV/plugins/NoPickupGlow.asi` | #28 |
| **Liberty Unlocked 1.1** | Active | `update/0.LibertyUnlocked/` (18 restored interiors) | #30 |
| **QuickSave IV 1.1** | Active | Native C++ plugin `GTAIV/plugins/QuickSaveIV.asi` (F5) | #30 |
| **Adv Vehicle Persistence** | Skipped | ScriptHookDotNet incompatible with 1.2.0.59; hotkey clash | N/A |
| **Project Thunder IV 2.2.1** | Skipped | Missing IV-SDK .NET; requires editing resident.rpf | N/A |
| **C06alt First Person v1.3** | Active | Genuine 420 KB C++ binary in `GTAIV/FirstPerson.asi`; `FPCover=1`, `FPDriveBy=1` | #32 |
| **Improved Cover System 1.0**| Skipped | `plugin-sdk` hardcoded entrypoints fail on CE 1.2.0.59 | N/A |
| **Liberty Rush v1.12** | Skipped | Requires 1.0.7.0/1.0.8.0 downpatch, ZMenu & FLA; destroys current traffic/ped stack | N/A |
| **Personal Vehicle 1.0 (#717)**| Skipped | ScriptHookDotNet dependency & hardcoded <kbd>L</kbd> key clash with 60% keyboard | N/A |
| **GTA V High Vehicle Cam #1223**| Skipped | Missing base plugin `CenteredVehicleCamIV.asi` & camera hook collision with FPP | N/A |
| **Radio Downgrader** | Skipped | Radio restoration/downgrading excluded per user directive | N/A |
| **CG4 Radar Mod** | Skipped | Obsolete 2009 HUD replacer; breaks FusionFix 16:10 circular radar masking | N/A |
| **Simple Traffic Loader** | Skipped | Requires IV-SDK .NET (crashes CE 1.2.0.59); duplicates New Game Parameters | N/A |
| **Project2DFX (Standalone)** | Skipped | Already built natively into FusionFix 5.0.1 via `DistantLights = 1` | N/A |
| **Ash HighRes Misc** | Active | `update/5 Higher Resolution Misc Pack/Ash_HiRes_Misc_IV.img` | Pre-existing |
| **Improved Animations (CE)** | Active | Pre-packaged in `update/1 Minor Mods/IV/IAP.IV.img`; TLAD module updated to latest Nov 2024 build | #36 / #37 |
| **Complete Edition HD Weapons** | Active | `update/5b HD Weapons Pack/` (3D HD models + HD colored weapon wheel icons) | #36 / #37 |
| **Beaten & Bruised v1.0** | Standby | Kept in standby to prevent anim.img binary rebuild crashes & FPP camera clipping | #36 / #37 |
| **Solitude 3 Calibration Profile**| Standby | Standby guide created (`solitude-night-calibration-standby.md`); baseline kept at default | Standby |

---

## 7. Current Stable Baseline & Pending Final To-Dos

### 7.1 Status: We Are Almost There!
The installation has reached a fully stabilized, high-performance working baseline under Proton GE-11-7 on CachyOS + RTX 5050 Mobile:
* **Current Locked Milestone:** **Snapshot #37** (`after-improved-animations-beaten-bruised-hd-weapons`).
* **Visual & Engine Balance:** Solitude 3 v1.1.5 + HQVT GTXD roads + 2K Trees + Project Glass + Ash HiRes Vehicles + Liberty's Legacy 2.4.1 + Complete Edition HD Weapons Pack + C06alt First Person v1.3.
* **Locked Invariants:** `ExtendedLimits = 0`, `VehicleBudget = 120000000`, `PedBudget = 0`, 60% keyboard trainer bindings (`I/K/J/L/U/O`).

### 7.2 Hybrid Solitude 3 Day + DayL Night Calibration (ACTIVE)
* **Architecture:** Custom row-level merged `timecyc.dat` combining Solitude 3 v1.1.5 daytime/weather identity with DayL Natural Timecycle 1.1.9 night readability.
* **Key Achievements:**
  1. **Solitude 3 Daytime Identity (06:00 - 21:00):** 100% bit-for-bit Solitude 3 preserved across 6AM, 7AM, 9AM, Midday, 6PM, 7PM, 8PM, 9PM. Zero morning glare or concrete blowout at normal display brightness (~11 ticks).
  2. **DayL Night Readability (22:00 - 05:00):** Midnight ambient lighting (`Amb0`, `Amb1`), horizon bounce (`SkyBot`), and fog distance (`FogSt = 750m-1000m`) imported with matched multipliers (`M0=4.0`, `M1=3.0`), completely eliminating crushed blacks and black fog shrouds.
  3. **Smooth Transitions:** Calibrated `10PM` (sunset-to-night stepping stone) and `5AM` (night-to-dawn mist return) rows ensure zero pop or lighting jumps.
  4. **Single Active Owner:** Active at `GTAIV/update/pc/data/timecyc.dat` (and synced to TLAD/TBoGT). Original copies archived in `disabled_mods/timecycle_backup/`.
  5. **Safety Snapshot:** Pre-merge snapshot created at Snapper #40 (home) / #561 (root).

### 7.3 Remaining To-Dos to Complete the Build:
1. [x] **Hybrid Solitude 3 Day + DayL Night Deployed:** Single active `timecyc.dat` verified.
2. [ ] **Animated Weapons 3.0 Merged Polish (Optional):** Merge `default.ide` weapon animations if desired, ensuring full harmony with Complete Edition HD Weapons Pack.



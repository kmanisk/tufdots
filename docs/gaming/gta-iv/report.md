# GTA IV — Sep 2026 Breakage: Full Test Report

Date: 2026-09-18. Machine: ASUS TUF F16 (i5-13450HX + RTX 5050 Mobile), CachyOS, Sway.
Game: GTA IV Complete Edition (Steam app 12210), prefix `~/.local/share/Steam/steamapps/compatdata/12210/pfx`.

## 1. Last-known-good baseline (worked Sep 17 daytime)

- Proton Experimental (build 20260910b), `prime-run gamemoderun %command%`
- FusionFix 5.0.1 + `d3dx9_43` in prefix, `commandline.txt` (norestrictions/nomemrestrict/1920x1200@165), `dxvk.conf` (hideNvidiaGpu=False, customVendorId=10de)
- Proof: nvidia-smi showed Launcher + SocialClubHelper + GTAIV.exe (~1345 MiB) all on GPU 0 (RTX 5050)

## 2. Trigger: Rockstar patched the game Sep 16–17

- `GTAIV.exe` + `PlayGTAIV.exe` rewritten **Sep 17 23:40–23:44**; manifest `LastUpdated` Sep 17 23:54, buildid **14009960**
- SteamDB patch history shows a Complete Edition patch **Sep 16, 2026**; Rockstar documents "Patch 8" (Aug 2026)
- System updates in the same window (NVIDIA 610→615, kernel 7.2.5→7.2.6, mesa 26.2.2→26.2.3) are **not** the cause (see tests below)

## 3. Failure A — game entry crash `gtaiv+0x75BBDD` (Sep 17 night → Sep 18)

- Page fault, write to `0x0000000a`, fault addr `0x00B5BBDD` (`incw 0xa(%eax)`, eax=0), called from `gtaiv+0x1e30` (entry code, 2-frame stack)
- Dies **before D3D9 device creation** (zero `D3D9InternalCreateDevice` in logs), after save/profile load
- Same signature with/without FusionFix → not mod-caused

| # | Test | Result |
|---|------|--------|
| 1 | Delete regenerated 0-byte `d3d9.cfg` | No change (game recreates it every launch; harmless) |
| 2 | Reset persisted settings (removed `ProfileSettings` + `ControlMap.dat`; Steam Cloud conflict resolved to LOCAL) | No change |
| 3 | Disable new mesa implicit layers (`NODEVICE_SELECT=1`, `VK_LOADER_LAYERS_DISABLE=*MESA*`) | No change — layers exonerated (verified absent from log) |
| 4 | Remove FusionFix entirely (vanilla + d3dx9_43) | Same crash — FusionFix exonerated as cause |
| 5 | FusionFix 4.0.5 (checksum-verified, 5.0.1 stashed at `~/Games/GTAIV-fusionfix-5.0.1/`) | Same crash — version irrelevant |
| 6 | Fresh save (moved `SGTA412`, `501C4FD0.dat`, `cloudsavedata.dat` → `~/Games/GTAIV-save-stash/`) | Same crash — saves exonerated |
| 7 | GE-Proton11-7 | Same bug (null+0xA write; different load base only) |
| 8 | Proton 9.0 Beta | Different failure: Rockstar CEF dialog crash (known Proton-9 CEF issue per skill file) |
| 9 | Verify integrity | **All 20494 files validated** — corrupt download ruled out |

## 4. Failure B — Rockstar Launcher CEF death (current blocker, Sep 18)

- Launcher log: `SC_INIT_ERR_WEBSITE_FAILED_LOAD` — "timed out loading both its online and offline content" → shutdown before game starts
- `libcef.dll` loads into two Social Club processes ~10s before the ntdll crash (`0x7be38406`)
- Launcher wrote its own `.dmp` + `launcher.log` to `AppData/Local/Rockstar Games/Launcher/CrashLogs/`

| # | Test | Result |
|---|------|--------|
| 10 | `LIBGL_ALWAYS_SOFTWARE=1` (bypass Intel mesa GL for CEF) | No change |
| 11 | Steam overlay global off | Already off; overlay still injected — inconclusive, needs retest with proof |
| — | Social Club files in prefix date from Aug 2026 (no recent launcher update) | — |

## 5. Incidental fix along the way

- FPS cap for loads: `FpsLimit=60`, `UnlockFramerateDuringLoadscreens=0` in 4.0.5 ini (165Hz uncapped loads = known infinite-load deadlock). Not yet validated in-game.

## 6. Backups (all restorable)

- `~/.backup/gta4-documents-pre-reset/` — full GTA IV Documents (saves + poisoned settings)
- `~/Games/GTAIV-save-stash/` — SGTA412 + profile dats
- `~/Games/GTAIV-fusionfix-5.0.1/` — the 5.0.1 dlls + plugins
- `~/.backup/sekiro-fresh-save/` — unrelated (Sekiro)
- Snapshots: snapper root #449–451, home #7 (pre-lsfg work, Sep 17)

## 8. New leads (Sep 18 evening)

- **Rockstar state reset**: nuked `Documents/Rockstar Games` + `AppData/Local/Rockstar Games` in prefix (backed up to `~/.backup/rockstar-documents` + `~/.backup/rockstar-local`). Means Social Club login required again.
- **Gamescope test** (Proton issue #5882 shape): launched directly via
  `gamescope -W 1920 -H 1200 -w 1920 -h 1200 -f -r 165 -- gamemoderun proton run PlayGTAIV.exe`
  with `STEAM_COMPAT_DATA_PATH=.../compatdata/12210`. Result: SocialClubHelper alive on dGPU (126 MiB), state regenerating — launcher up, game not yet started. **Awaiting user to log into Social Club / press Play in the gamescope window.**
- **Standalone 1.0.8.0 depot fallback** (kills launcher DRM entirely):
  Steam console → `download_depot 12210 12211 7948020046445760716` → lands in
  `~/.local/share/Steam/steamapps/content/app_12210/depot_12211`. Then FusionFix + LegacyAddon, launch GTAIV.exe as non-Steam game. Costs: no achievements/cloud; saves need GTASnP conversion (originals stashed). NOT yet attempted.

## 7. Queued next steps (untested)

1. **i3/X11 session test** — all failures observed under Sway/Wayland (Wine sees XWayland either way, so low probability, but it's the biggest untested environment axis)
2. **Social Club reinstall in prefix** (Aug 2026 files vs Sep 16 game patch mismatch candidate)
3. **Steam Offline Mode** (cached creds; kills server-dependent launcher UI)
4. **Newer Proton Experimental** (stuck on Sep-10 build; Steam restart to pull post-Sep-16 build completed, re-check version)
5. **Valve/ThirteenAG fix** — file issue with `~/steam-12210.log` + launcher `.dmp` if above fails
6. Game-build rollback via `download_depot` — blocked (no pre-patch manifest ID; SteamDB scraping 403s; depotcache has only Rockstar-launcher depot manifest)

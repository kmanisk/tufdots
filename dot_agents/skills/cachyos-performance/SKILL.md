---
name: cachyos-performance
description: System-level performance guidelines, package management, dual-GPU offloading, and Btrfs tuning for CachyOS on modern Intel/NVIDIA laptops.
version: 1.0.0
---

# CachyOS & Performance Architecture Guidelines

## Hardware & Architecture Rules
- **CPU Architecture:** x86-64-v3. Always prefer packages from `[cachyos-v3]` and `[cachyos]` repositories before standard Arch repos or AUR.
- **Kernel:** Linux-CachyOS with BORE (Burst-Oriented Response Enhancer) or EEVDF scheduler. Do not replace with generic `linux` kernel unless debugging regression.
- **Dual-GPU Offloading (PRIME):**
  - i3/X11 session runs on the integrated Intel Raptor Lake-S UHD GPU for minimal idle power consumption.
  - 3D titles and Vulkan workloads run on discrete NVIDIA RTX 5050 Mobile via `prime-run` or `__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia`.
  - Always pair with GameMode: `gamemoderun prime-run %command%`.

## Package Management & Safety Guardrails
- **Forbidden Commands:** NEVER run `pacman -Sy` (partial upgrade risk). Always use `pacman -Syu` or `cachyos-rate-mirrors`.
- **AUR Helper:** Use `paru` with CachyOS optimizations. Avoid building packages that already exist in `[cachyos-v3]`.
- **Proton Selection:** Default to `proton-cachyos` for Steam games for custom LTO and x86-64-v3 micro-architecture optimizations.

## Filesystem Rules (Btrfs)
- Btrfs Copy-on-Write (CoW) causes write amplification and frame stutters on large, frequently modified VM disk images and game binaries.
- All Steam library directories, Wine prefixes (`~/.wine`, `~/.local/share/bottles`), and swapfiles MUST have the `nodatacow` attribute set before population:
  ```bash
  mkdir -p ~/.local/share/Steam/steamapps/common
  chattr +C ~/.local/share/Steam/steamapps/common
  ```

## Service Policies
- Keep `ananicy-cpp.service` active. It sets I/O and CPU scheduling priority on the fly when game binaries are detected.
- Use `systemd-oomd` or `earlyoom` configured by CachyOS defaults; do not override memory pressure parameters manually without testing.

## Performance & Resource Discipline (Anti-Bloat & Gaming Reliability)
- **Core Principle & Needs:** Instantaneous, reliable competitive & AAA gaming rig paired with rapid terminal workflows. Save disk space, RAM, and CPU cycles as priority #1.
- **Zero Animations & Zero Eye-Candy Lag:** Disable all window transitions, animations, blur shaders, and visual effects in Sway and i3. Windows map and tile immediately with 0ms delay.
- **Daemonless Architecture:** Always prefer on-demand CLI utilities and ephemeral scripts over persistent system daemons or background tray processes. No background process may steal CPU cycles or lock RAM during gaming sessions.
- **Autologin / Display Architecture:** Prefer No-DM Getty autologin (0 MB background RAM overhead) over full display managers.
- **Headless Essential Services Only:** Only strictly necessary system services (PipeWire/WirePlumber, ananicy-cpp, udiskie) run in the background. Daemons must never require open GUI windows to function.

## Audio Pipeline (Stock PipeWire)
- **No DSP daemon:** stock PipeWire + WirePlumber only; do not add background audio daemons.

## Btrfs Snapshot Hygiene
- **Snapshot Retention:** Keep only stable, verified baselines. Do not accumulate large batches of transient `snap-pac` pre/post snapshots that hold old package extents.
- **Space Auditing:** Audit snapshots using `btrfs filesystem du -s /.snapshots/*/snapshot` to measure true exclusive (reclaimable) space versus shared CoW blocks.
- **Safe Management:** Always use scoped `snapper` subcommands (`snapper -c <config> create/delete/cleanup`) instead of raw unverified `btrfs` subvolume deletion.

## Research & Verification Protocol
- **Headless Browser & Web Search:** When researching technical topics, kernel options, compositor changes, or package updates, always execute targeted web searches and headless browser reads to verify current upstream behavior.
- **Skill & Memory Persistence:** Record verified findings, edge cases, and architectural choices into skill markdown files (`SKILL.md`) and project rules so verified insights persist across sessions.

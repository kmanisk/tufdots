# tufdots

Reproducible, declarative user environment for Linux workstation & gaming rigs managed by [chezmoi](https://www.chezmoi.io/).

- **Target OS:** CachyOS rolling (x86-64-v3, BORE scheduler) / Arch Linux
- **Window Manager:** Sway (Wayland) @ 1920×1200 165Hz
- **Hardware Profile:** ASUS TUF Gaming F16 (FX608J) · Intel Core i5-13450HX + NVIDIA GeForce RTX 5050 Mobile (GB207M)
- **GPU Strategy:** Hybrid Optimus (Intel Raptor Lake UHD iGPU on display session; NVIDIA RTX 5050 offloaded via `prime-run` in runtime D3cold)
- **File System:** Btrfs on NVMe (`nodatacow` on Steam libraries & prefixes, Snapper snapshot integration)

---

## Quick Start / Deployment

### 1. Automated Bootstrap (Single Step)
```bash
curl -sL https://raw.githubusercontent.com/kmanisk/tufdots/master/install.sh | bash -s -- --apply
```

### 2. Manual Two-Step Deployment
```bash
# Step 1: Pre-seed machine profile & install prerequisites (paru, chezmoi, age)
curl -sL https://raw.githubusercontent.com/kmanisk/tufdots/master/install.sh | bash

# Step 2: Initialize & apply
chezmoi init --apply https://github.com/kmanisk/tufdots.git
```

---

## Repository Structure

```text
.
├── .chezmoidata.toml           # Composable machine & hardware architecture definitions
├── .chezmoiignore              # Ignore rules for volatile runtime files & internal docs
├── install.sh                  # Bootstrap script for paru, chezmoi, age, and profile seeding
├── packages/                   # Declarative package manifests per domain
│   ├── common.txt              # Cross-platform CLI utilities (git, ripgrep, btop, yazi, neovim, uv)
│   ├── linux-core.txt          # Core system & maintenance (base-devel, btrfs, snapper, ufw, thunar)
│   ├── gaming.txt              # Gaming stack (steam, gamescope, mangohud, goverlay, vkbasalt)
│   ├── nvidia.txt              # NVIDIA drivers & 32-bit Vulkan/OpenCL offload libs
│   ├── asus.txt                # ASUS hardware management (asusctl, supergfxctl)
│   ├── sway.txt                # Sway Wayland compositor stack (mako, fuzzel, grim, slurp, brave)
│   ├── audio.txt               # Low-latency PipeWire, WirePlumber, and neural DSP
│   ├── development.txt         # Development toolchains (nodejs, python, ccache, mold)
│   └── aur-explicit.txt        # AUR explicit packages (antigravity-cli, bibata cursor, xremap)
├── systemd/                    # Reference dumps of enabled system & user systemd units
├── docs/                       # Architecture documentation & system philosophy
│   ├── SYSTEM-REPRODUCIBILITY.md # Comprehensive guide for bootstrapping from fresh install
│   ├── system-philosophy.md    # Low-latency gaming & daemonless performance philosophy
│   └── ...
├── run_onchange_linux-00-...   # Automated package reconciliation on manifest change
├── run_onchange_linux-10-...   # TTY1 autologin & session reconciliation
└── run_onchange_linux-20-...   # System & user service daemon reconciliation
```

---

## Machine Profiles & Customization

Profiles are defined in `.chezmoidata.toml` and selected via `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    machine = "asus-tuf-f16"
```

Available profiles:
- `asus-tuf-f16`: Primary gaming laptop with ASUS hardware daemons, hybrid RTX 5050 offload, Snapper snapshots, low-latency DSP, and Sway Wayland environment.
- `generic-linux`: Portable minimal Linux workstation profile.

For detailed hardware assumptions, prerequisite mount points, and step-by-step restore steps, see [`docs/SYSTEM-REPRODUCIBILITY.md`](docs/SYSTEM-REPRODUCIBILITY.md).

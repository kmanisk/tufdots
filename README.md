# tufdots — CachyOS Sway/i3 Gaming Laptop Dots

Fully reproducible [chezmoi](https://www.chezmoi.io/) source for an ASUS TUF Gaming Laptop
(i5-13450HX + RTX 5050 Mobile, 1920×1200@165Hz) running **Sway (Wayland) & i3 (X11)**:
CachyOS tuning, dual-GPU offloading, xremap, scratchpad dropdowns,
and ambient wallpaper pack.

## Install (fresh machine, 2 steps)

```bash
# 1/2 - dependencies (git, paru, chezmoi, age) + machine profile pre-seed
curl -sL https://raw.githubusercontent.com/kmanisk/tufdots/master/install.sh | bash

# 2/2 - deploy everything: configs, scripts, packages, services, wallpapers
chezmoi init --apply https://github.com/kmanisk/tufdots.git
```

Step 2 reconciles declarative package lists (`packages/*.txt`), systemd units,
login manager, the i3-resurrect venv, and seeds `wallpapers/` — then reboot
into i3 via `startx` (TTY1 autologin).

## What's inside

| Path | Purpose |
|---|---|
| `dot_config/i3/config` | i3wm: scratchpads, gaming workspaces, move-and-follow keys |
| `dot_config/{alacritty,polybar,dunst,rofi,fish,fastfetch}` | Gruvbox terminal, bar, launcher, fetch |
| `dot_local/bin/` | 50+ helpers: `cs2-launch`, `killgame`, `scratch-toggle`, `steam-workspace`, `bar-apply`, `random-wallpaper`, GPU/power scripts |
| `dot_config/systemd/user/` | xremap, nightlight, bluetooth, session services |
| `packages/i3.txt` + others | Declarative pacman/AUR sets per machine profile |
| `run_onchange_*` | Package / login / service reconcilers (snapshotted, dry-run capable) |
| `wallpapers/blxss_*.jpg` | 39 ambient ↓1280×720 thumbnails, `Alt+Shift+W` to rotate |

## Keybinds (essentials)

| Keys | Action |
|---|---|
| `Win+Return` | Alacritty |
| `Ctrl+Space` | Scratch terminal dropdown |
| `Win+n` | Notes dropdown (nvim + notes.md) |
| `Win+m` | Spotify scratchpad dropdown |
| `Alt+Shift+S` | Steam client, workspace 3 (starts Steam if off) |
| `Win+4` | Games workspace (CS2 / Steam games, tiled) |
| `Win+Shift+u/i/o/p` | Move window to ws 1–4 **and follow it** |
| `Win+[` / `Win+]` | Move window to ws 5 / ws 6 **and follow it** |
| `Alt+Shift+N` | Nightlight toggle |
| `Alt+Shift+W` / `Alt+Shift+Q` | Next wallpaper: blxss originals / blxss 4K pack |
| `Alt+0` | Toggle Polybar (state persists across reboots) |
| `Ctrl+Alt+Del` | Kill hung game, restore display + bar |

See `AGENTS.md` for the full machine contract (GPU offload, Btrfs, secrets).

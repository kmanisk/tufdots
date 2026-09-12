# Package Manifests (tufx11 / i3-X11)

Declarative package sets, auto-installed by
`run_onchange_linux-00-reconcile-packages.sh.tmpl` based on the machine profile
in `.chezmoidata.toml`.

| File | Purpose | Condition |
|---|---|---|
| `common.txt` | Baseline CLI tools (git, ripgrep, btop, yazi, neovim, uv, …) | Always |
| `linux-core.txt` | System tools (base-devel, btrfs-progs, snapper, NetworkManager, …) | Linux |
| `i3.txt` | i3wm, Alacritty, Polybar, Dunst, Rofi, feh, X11 utilities | `features.i3 = true` |
| `gaming.txt` | Steam, Gamescope, Gamemode, Mangohud | `features.gaming = true` |
| `nvidia.txt` | NVIDIA dGPU drivers, 32-bit Vulkan/OpenCL | `gpu_strategy = "hybrid-optimus-d3cold"` |
| `asus.txt` | asusctl, supergfxctl, switcheroo-control | `features.asus_ctl = true` |
| `audio.txt` | PipeWire, WirePlumber, audio firmware | audio provider starts with `pipewire` |
| `development.txt` | Compilers, runtimes (Node.js, Python, ccache, mold) | `features.development = true` |
| `aur-explicit.txt` | AUR packages (xremap-x11-bin, cursors, …) | AUR helper present |

`wallpapers/` and `systemd/enabled-units-reference.txt` are references only,
never installed automatically.

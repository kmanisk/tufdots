#!/bin/bash
# ==============================================================================
# tufx11 step 1/2: install dependencies, then run:
#   chezmoi init --apply https://github.com/kmanisk/tufx11.git
# (install.sh also pre-seeds ~/.config/chezmoi/chezmoi.toml so the
# asus-tuf-f16 profile is selected automatically)
# ==============================================================================
set -euo pipefail

REPO_URL="https://github.com/kmanisk/tufx11.git"

if [ ! -f /etc/arch-release ]; then
    echo "ERROR: tufx11 supports Arch/CachyOS only." >&2
    exit 1
fi

# 1. git + base-devel (needed to build paru)
if ! command -v git >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm git base-devel
fi

# 2. paru (AUR helper used by the package reconciler)
if ! command -v paru >/dev/null 2>&1; then
    echo "==> Installing paru..."
    tmpdir=$(mktemp -d)
    git clone --depth 1 https://aur.archlinux.org/paru.git "$tmpdir/paru"
    (cd "$tmpdir/paru" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
fi

# 3. chezmoi + age (age decrypts the encrypted MCP config on apply)
paru -S --needed --noconfirm chezmoi age

# 4. Pre-seed chezmoi config so `init --apply` picks the right machine profile
mkdir -p "$HOME/.config/chezmoi"
if [ ! -f "$HOME/.config/chezmoi/chezmoi.toml" ]; then
    cat > "$HOME/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine = "asus-tuf-f16"
EOF
    echo "==> Wrote ~/.config/chezmoi/chezmoi.toml (machine = asus-tuf-f16)"
else
    echo "==> ~/.config/chezmoi/chezmoi.toml already exists, leaving it alone"
fi

echo ""
echo "Step 1 done. Now run step 2/2:"
echo "  chezmoi init --apply $REPO_URL"

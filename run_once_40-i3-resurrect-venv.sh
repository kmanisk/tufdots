#!/bin/bash
# ==============================================================================
# Provision the i3-resurrect + autotiling Python venv.
# The i3 session needs two console scripts from it:
#   ~/.local/bin/i3-resurrect  (session save/restore backend)
#   ~/.local/bin/autotiling    (exec_always in i3 config)
# Neither is a pacman package, so they cannot live in packages/*.txt.
# Guarded + idempotent: safe to re-run after deleting the venv.
# ==============================================================================
set -euo pipefail

VENV="$HOME/.local/share/i3-resurrect-venv"

if [ -x "$VENV/bin/python" ] && "$VENV/bin/pip" show i3-resurrect autotiling >/dev/null 2>&1; then
    echo "==> i3-resurrect venv already provisioned, skipping."
    exit 0
fi

echo "==> Provisioning i3-resurrect venv at $VENV ..."
python3 -m venv "$VENV"
"$VENV/bin/pip" install --quiet --upgrade pip
"$VENV/bin/pip" install --quiet "i3-resurrect==1.4.5" "autotiling==1.9.3"
echo "==> i3-resurrect venv ready."

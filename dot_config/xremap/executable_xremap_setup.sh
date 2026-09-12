#!/usr/bin/env bash
set -e

# Detect real user (when run with sudo)
USER_NAME="${SUDO_USER:-$USER}"
USER_HOME="$(eval echo ~$USER_NAME)"

SERVICE_FILE="/etc/systemd/system/xremap.service"
CONFIG_FILE="$USER_HOME/.config/xremap/config.yml"

echo "========================================="
echo "xremap systemd service installer"
echo "User: $USER_NAME"
echo "Home: $USER_HOME"
echo "========================================="

# Must run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo:"
    echo "sudo ./install-xremap-service.sh"
    exit 1
fi

# Check xremap installed
if ! command -v xremap >/dev/null; then
    echo "ERROR: xremap not installed"
    echo "Install with:"
    echo "sudo pacman -S xremap"
    exit 1
fi

# Check config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: config file not found:"
    echo "$CONFIG_FILE"
    exit 1
fi

echo
echo "Creating systemd service..."

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=xremap key remapper
After=systemd-udev-settle.service

[Service]
ExecStart=/usr/bin/xremap --watch $CONFIG_FILE
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

echo
echo "Reloading systemd..."
systemctl daemon-reload

echo
echo "Enabling service..."
systemctl enable xremap.service

echo
echo "Starting service..."
systemctl restart xremap.service

echo
echo "========================================="
echo "Installation complete!"
echo
echo "Service status:"
systemctl --no-pager status xremap.service
echo
echo "Reboot recommended:"
echo "reboot"
echo "========================================="

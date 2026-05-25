#!/bin/bash
# install.sh — Install LibreWolf-MW
# Supports: any systemd-based distro (Debian, Ubuntu, Fedora, Arch, etc.)
# Fallback: XDG autostart for GNOME, KDE, XFCE, LXDE, and other XDG-compliant DEs

set -e

SCRIPT_NAME="LibreWolf-MW.sh"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# ── Dependency check ──────────────────────────────────────────────────────────
for dep in pactl systemd-inhibit; do
    if ! command -v "$dep" &>/dev/null; then
        echo "Error: '$dep' is not installed."
        [[ "$dep" == "pactl" ]] && echo "  Install with: sudo apt install pulseaudio-utils"
        exit 1
    fi
done

# ── Source file check ─────────────────────────────────────────────────────────
if [[ ! -f "$SCRIPT_NAME" ]]; then
    echo "Error: '$SCRIPT_NAME' not found. Run install.sh from the repo directory."
    exit 1
fi

# ── Install script ────────────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_NAME" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"
echo "Installed: $INSTALL_PATH"

# ── Method 1: systemd user service ───────────────────────────────────────────
if systemctl --user status &>/dev/null 2>&1 || systemctl --user list-units &>/dev/null 2>&1; then
    SERVICE_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SERVICE_DIR"

    cat > "$SERVICE_DIR/LibreWolf-MW.service" <<EOF
[Unit]
Description=LibreWolf-MW — prevent sleep/idle during media playback
After=default.target

[Service]
ExecStart=$INSTALL_PATH
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now LibreWolf-MW.service
    echo ""
    echo "Installed as a systemd user service."
    echo "  Status : systemctl --user status LibreWolf-MW"
    echo "  Stop   : systemctl --user stop LibreWolf-MW"
    echo "  Disable: systemctl --user disable --now LibreWolf-MW"

# ── Method 2: XDG autostart fallback ─────────────────────────────────────────
else
    AUTOSTART_DIR="$HOME/.config/autostart"
    mkdir -p "$AUTOSTART_DIR"

    cat > "$AUTOSTART_DIR/LibreWolf-MW.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=LibreWolf-MW
Exec=$INSTALL_PATH
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=Prevent sleep/idle during media playback
EOF

    echo ""
    echo "Installed as an XDG autostart entry (no systemd user session found)."
    echo "LibreWolf-MW will start automatically on next login."
    echo "To remove: delete $AUTOSTART_DIR/LibreWolf-MW.desktop"
fi

echo ""
echo "Done."

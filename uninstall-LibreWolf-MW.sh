#!/bin/bash
# uninstall.sh — Remove LibreWolf-MW

INSTALL_PATH="$HOME/.local/bin/LibreWolf-MW.sh"
SERVICE_FILE="$HOME/.config/systemd/user/LibreWolf-MW.service"
DESKTOP_FILE="$HOME/.config/autostart/LibreWolf-MW.desktop"

removed=0

# ── systemd service ───────────────────────────────────────────────────────────
if [[ -f "$SERVICE_FILE" ]]; then
    systemctl --user disable --now LibreWolf-MW.service 2>/dev/null || true
    rm -f "$SERVICE_FILE"
    systemctl --user daemon-reload
    echo "Removed systemd user service."
    removed=1
fi

# ── XDG autostart entry ───────────────────────────────────────────────────────
if [[ -f "$DESKTOP_FILE" ]]; then
    rm -f "$DESKTOP_FILE"
    echo "Removed XDG autostart entry."
    removed=1
fi

# ── Installed script ──────────────────────────────────────────────────────────
if [[ -f "$INSTALL_PATH" ]]; then
    rm -f "$INSTALL_PATH"
    echo "Removed $INSTALL_PATH."
    removed=1
fi

if [[ $removed -eq 0 ]]; then
    echo "Nothing to remove — LibreWolf-MW does not appear to be installed."
else
    echo "Done. LibreWolf-MW has been fully removed."
fi

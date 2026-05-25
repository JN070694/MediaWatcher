# MediaWatcher

A lightweight background daemon archive that prevents your Linux system from sleeping or going idle while media is playing. Built around PulseAudio/PipeWire — no DE-specific plugins, no root required.

## Scripts in this repo

| Script | Description |
|---|---|
| `LibreWolf-MW.sh` | Daemon for LibreWolf |
| `install-LibreWolf-MW.sh` | Installer for LibreWolf-MW |
| `uninstall-LibreWolf-MW.sh` | Uninstaller for LibreWolf-MW |

> More browsers (e.g. Brave) may be added as separate scripts over time.

---

## How it works

Every 10 seconds, the daemon checks whether any PulseAudio/PipeWire sink input is active (i.e. audio is playing). If so, it holds a `systemd-inhibit` lock blocking sleep and idle. When audio stops, the lock is released and normal power management resumes.

---

## Requirements

- Linux with `systemd`
- `pactl` (PulseAudio or PipeWire with PulseAudio compatibility)
- `systemd-inhibit`

On Debian/Ubuntu, install missing dependencies with:
```bash
sudo apt install pulseaudio-utils
```
PipeWire users on modern Debian/Ubuntu typically already have `pactl` via `pipewire-pulse`.

---

## Install (LibreWolf)

```bash
git clone https://github.com/JN070694/MediaWatcher.git
cd MediaWatcher
chmod +x install-LibreWolf-MW.sh
./install-LibreWolf-MW.sh
```

The installer will:
1. Copy `LibreWolf-MW.sh` to `~/.local/bin/`
2. Install a **systemd user service** (preferred — works on any DE or bare WM)
3. Fall back to an **XDG autostart `.desktop` entry** if no systemd user session is detected (GNOME, KDE, XFCE, LXDE, and other XDG-compliant desktops)

---

## Managing the service (systemd)

```bash
systemctl --user status LibreWolf-MW    # Check status
systemctl --user stop LibreWolf-MW      # Stop now
systemctl --user start LibreWolf-MW     # Start now
systemctl --user disable LibreWolf-MW   # Disable autostart
journalctl --user -u LibreWolf-MW -f    # Live logs
```

---

## Verify Installation (LibreWolf)

With a video playing, `LibreWolf-MW` should appear in the inhibit list:
```bash
systemd-inhibit --list
```

Check the service is active and running:
```bash
systemctl --user status LibreWolf-MW
```

---

## Uninstall (LibreWolf)

```bash
./uninstall-LibreWolf-MW.sh
```

Removes the service/autostart entry, disables autostart, and deletes the installed script.

---

## Compatibility

| Desktop / Environment | Supported |
|---|---|
| GNOME | ✅ |
| KDE Plasma | ✅ |
| XFCE | ✅ |
| LXDE / LXQt | ✅ |
| i3 / Sway / bare WMs | ✅ (systemd service) |
| Any systemd-based distro | ✅ |

Tested primarily on **Debian**. Should work on any `systemd` + PulseAudio/PipeWire distro.

---

## License

GNU Affero General Public License version 3 (AGPL-3.0)

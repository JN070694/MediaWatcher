#!/bin/bash
# LibreWolf-MW.sh — Prevent sleep/idle while media is playing (PulseAudio/PipeWire)

INHIBIT_PID=""

cleanup() {
    [[ -n "$INHIBIT_PID" ]] && kill "$INHIBIT_PID" 2>/dev/null
    exit 0
}
trap cleanup SIGTERM SIGINT

while true; do
    if pactl list sink-inputs 2>/dev/null | grep -q "Corked: no"; then
        if [[ -z "$INHIBIT_PID" ]]; then
            systemd-inhibit \
                --what=sleep:idle \
                --who="LibreWolf-MW" \
                --why="Media is playing" \
                sleep infinity &
            INHIBIT_PID=$!
        fi
    else
        if [[ -n "$INHIBIT_PID" ]]; then
            kill "$INHIBIT_PID" 2>/dev/null
            INHIBIT_PID=""
        fi
    fi
    sleep 10
done

#!/usr/bin/env sh

STATE_FILE="$HOME/.config/polybar/bar_state"

# Terminate already running bar instances cleanly
polybar-msg cmd quit 2>/dev/null || killall -q polybar
pkill -9 -x polybar 2>/dev/null

# Clean up any stale IPC sockets
rm -f /run/user/$(id -u)/polybar/ipc.*.sock 2>/dev/null

# Wait until all old processes have actually shut down
for _ in 1 2 3 4 5; do
    if ! pgrep -u $(id -u) -x polybar >/dev/null 2>&1; then
        break
    fi
    sleep 0.05
done

# Fast primary display detection using xrandr --listmonitors (takes ~30ms vs 1400ms with xrandr --query)
PRIMARY_MON=$(xrandr --listmonitors 2>/dev/null | awk '/\+/ {print $NF; exit}')
if [ -z "$PRIMARY_MON" ]; then
    PRIMARY_MON="eDP-1"
fi

# Launch single polybar instance
if [ -n "$PRIMARY_MON" ]; then
    MONITOR="$PRIMARY_MON" polybar --reload example </dev/null >/dev/null 2>&1 &
else
    polybar --reload example </dev/null >/dev/null 2>&1 &
fi

# Wait for IPC channel to become ready
for _ in $(seq 1 20); do
    if polybar-msg action "#toggle.status" >/dev/null 2>&1; then
        break
    fi
    sleep 0.05
done

# Enforce persisted visibility via the single authority (hidden is absolute).
# bar-apply retries the hide IPC so slow starts can't leave the bar visible.
"$HOME/.local/bin/bar-apply" >/dev/null 2>&1

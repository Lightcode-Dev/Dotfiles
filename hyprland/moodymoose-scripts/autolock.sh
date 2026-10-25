#!/usr/bin/env bash
# autolock.sh: turn automatic locking (hypridle) on or off, with waybar status.
#   autolock.sh toggle   stop hypridle if it is running, start it if not
#   autolock.sh status   print JSON for the waybar module

set -uo pipefail

# tell waybar to re-run the status command (the module listens on signal 9)
refresh_bar() { pkill -SIGRTMIN+9 -x waybar || true; }

# Fire-and-forget notification: backgrounded and capped at 2 seconds, so a
# missing notification daemon can never stall this script.
notify() { timeout 2 notify-send -u low "$1" "$2" >/dev/null 2>&1 & }

case "${1:-status}" in
    toggle)
        if pgrep -x hypridle >/dev/null; then
            pkill -x hypridle
            title="Auto-lock off"
            body="The screen will not lock or turn off when idle"
        else
            setsid hypridle >/dev/null 2>&1 &
            title="Auto-lock on"
            body="Locks after 5 minutes idle"
        fi
        sleep 0.3          # let hypridle start or exit before the bar re-checks
        refresh_bar        # update the icon first
        notify "$title" "$body"
        ;;
    status)
        # \\uXXXX prints a literal \uXXXX, which waybar's JSON parser decodes
        if pgrep -x hypridle >/dev/null; then
            printf '{"text":"\\uf023","class":"on","tooltip":"Auto-lock is on (click to turn off)"}\n'
        else
            printf '{"text":"\\uf09c","class":"off","tooltip":"Auto-lock is off (click to turn on)"}\n'
        fi
        ;;
    *)
        echo "usage: $0 [toggle|status]" >&2
        exit 1
        ;;
esac

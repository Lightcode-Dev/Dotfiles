#!/usr/bin/env bash
# dnd.sh: do-not-disturb toggle for dunst, with waybar status output.
#   dnd.sh toggle   pause/unpause dunst and refresh the waybar icon
#   dnd.sh status   print JSON for the waybar module

set -uo pipefail

# tell waybar to re-run the status command (the module listens on signal 8)
refresh_bar() { pkill -SIGRTMIN+8 -x waybar || true; }

case "${1:-status}" in
    toggle)
        dunstctl set-paused toggle
        refresh_bar
        # Announcing "paused" would be hidden by the pause itself, so only
        # confirm when notifications come back on.
        if [[ "$(dunstctl is-paused)" == "false" ]]; then
            notify-send -u low "Notifications on" "Do not disturb is off"
        fi
        ;;
    status)
        # \\uXXXX prints a literal \uXXXX, which waybar's JSON parser decodes
        if [[ "$(dunstctl is-paused)" == "true" ]]; then
            printf '{"text":"\\uf1f6","class":"paused","tooltip":"Do not disturb is on (click to turn off)"}\n'
        else
            printf '{"text":"\\uf0f3","class":"active","tooltip":"Notifications on (click for do not disturb)"}\n'
        fi
        ;;
    *)
        echo "usage: $0 [toggle|status]" >&2
        exit 1
        ;;
esac

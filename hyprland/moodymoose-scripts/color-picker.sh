#!/usr/bin/env bash
# color-picker.sh: pick a color from anywhere on screen, copy it as hex, and notify.

set -uo pipefail

# -a copies the picked color to the clipboard, -f hex prints it as #RRGGBB.
# Esc cancels (no output).
color="$(hyprpicker -a -f hex)" || exit 0
[[ -n "$color" ]] || exit 0

# Backgrounded and capped at 2 seconds, so a stopped dunst can't stall the script
timeout 2 notify-send "Color copied" "$color" >/dev/null 2>&1 &

#!/usr/bin/env bash
# screenshot.sh: take a screenshot, save it, copy it to the clipboard.
#   screenshot.sh region   drag to select an area (Esc cancels)
#   screenshot.sh screen   the whole screen
#   screenshot.sh window   the focused window

set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
ENVF="$HOME/.cache/wallust-colors.env"
mkdir -p "$DIR"
file="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

geom=""
case "${1:-region}" in
    region)
        # Color the selector from the wallust palette (BG and ACCENT are "#RRGGBB").
        # If the palette file is missing, slurp just uses its default colors.
        slurp_args=()
        if [[ -f "$ENVF" ]]; then
            source "$ENVF"
            # -b dims everything outside the selection, -c is the border,
            # -s tints the inside of the selection, -w is the border weight
            slurp_args=(-b "${BG}88" -c "${ACCENT}ff" -s "${ACCENT}22" -w 3)
        fi
        # slurp prints the selection as "x,y WxH"; it exits non-zero on Esc
        geom="$(slurp -d "${slurp_args[@]}")" || exit 0
        ;;
    screen)
        ;;
    window)
        # geometry of the focused window, from Hyprland
        geom="$(hyprctl activewindow -j \
            | jq -r 'if .address then "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])" else empty end')"
        [[ -n "$geom" ]] || exit 0
        ;;
    *)
        echo "usage: $0 [region|screen|window]" >&2
        exit 1
        ;;
esac

if [[ -n "$geom" ]]; then
    grim -g "$geom" "$file"
else
    grim "$file"
fi

wl-copy < "$file"

# Backgrounded and capped at 2 seconds, so a stopped dunst can't stall the script
timeout 2 notify-send -i "$file" "Screenshot saved" "$file" >/dev/null 2>&1 &

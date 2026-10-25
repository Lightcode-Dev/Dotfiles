#!/usr/bin/env bash
# screenshot.sh: take a screenshot, save it, copy it to the clipboard.
#   screenshot.sh region   drag to select an area (Esc cancels)
#   screenshot.sh screen   the whole screen
#   screenshot.sh window   the focused window

set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
file="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

geom=""
case "${1:-region}" in
    region)
        # slurp prints the selection as "x,y WxH"; it exits non-zero on Esc
        geom="$(slurp -d)" || exit 0
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
notify-send -i "$file" "Screenshot saved" "$file"

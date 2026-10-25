#!/usr/bin/env bash
# power-menu.sh: rofi power menu (lock, logout, suspend, reboot, shutdown).
# Logout, reboot and shutdown ask for confirmation first.

set -uo pipefail

ROFI_THEME="$HOME/.config/rofi/power.rasi"

# Icon + label. \uXXXX are Nerd Font glyphs.
lock=$'\uf023  Lock'
logout=$'\uf08b  Logout'
suspend=$'\uf186  Suspend'
reboot=$'\uf021  Reboot'
shutdown=$'\uf011  Shutdown'

# menu "title" [extra rofi args...]   (menu entries come in on stdin)
menu() {
    rofi -dmenu -i -no-custom -p "" -mesg "$1" -theme "$ROFI_THEME" "${@:2}"
}

# confirm "Reboot": succeeds only if you pick "Yes"
confirm() {
    local answer
    answer="$(printf '%s\n' "No, cancel" "Yes, $1" \
        | menu "$1 now?" -theme-str 'listview { lines: 2; }')" || return 1
    [[ "$answer" == "Yes, $1" ]]
}

choice="$(printf '%s\n' "$lock" "$logout" "$suspend" "$reboot" "$shutdown" \
    | menu "Power menu")" || exit 0     # Esc closes the menu

case "$choice" in
    "$lock")
        pidof hyprlock || hyprlock
        ;;
    "$logout")
        if confirm "Logout"; then
            # same command as your SUPER + M bind
            command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'
        fi
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$reboot")
        confirm "Reboot" && systemctl reboot
        ;;
    "$shutdown")
        confirm "Shutdown" && systemctl poweroff
        ;;
esac

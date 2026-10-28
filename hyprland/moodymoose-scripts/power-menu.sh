#!/usr/bin/env bash
# power-menu.sh: rofi power menu (lock, logout, suspend, reboot, shutdown).
# Logout, reboot and shutdown ask for confirmation first.
# Suspend locks the screen first, so waking never shows an unlocked desktop.

set -uo pipefail

ROFI_THEME="$HOME/.config/rofi/power.rasi"

# Testing: SUSPEND_CMD="echo would suspend" power-menu.sh  (locks, but does not sleep)
SUSPEND_CMD="${SUSPEND_CMD:-systemctl suspend}"

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

# Start hyprlock if it is not running, and wait until it is up
# (up to 3 seconds), then give it a moment to take the session lock.
lock_and_wait() {
    pidof hyprlock >/dev/null || setsid hyprlock >/dev/null 2>&1 &
    for _ in $(seq 1 30); do
        pidof hyprlock >/dev/null && break
        sleep 0.1
    done
    sleep 1
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
        lock_and_wait
        $SUSPEND_CMD
        ;;
    "$reboot")
        confirm "Reboot" && systemctl reboot
        ;;
    "$shutdown")
        confirm "Shutdown" && systemctl poweroff
        ;;
esac

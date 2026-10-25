#!/usr/bin/env bash
# theme-refresh.sh: regenerate the wallust palette from a wallpaper and
# refresh everything that uses it.
#   theme-refresh.sh [image]        full refresh (default: the current wallpaper)
#   theme-refresh.sh --if-missing   full refresh only if a generated file is missing

# No "set -e": each reload step is best-effort, and one failing app
# (dunst not running, say) must not stop the others.
set -uo pipefail

WALL_DIR="$HOME/Pictures/wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
KITTY_DIR="$HOME/.config/kitty"
TEMPLATES="$HOME/.config/wallust/templates"
CURRENT_LINK="$HOME/.cache/wallpaper-current"

# Every file wallust generates (these are git-ignored, so a fresh clone lacks them)
generated=(
    "$HOME/.config/hypr/moodymoose-configs/colors.lua"
    "$HOME/.config/hypr/hyprlock-colors.conf"
    "$HOME/.config/rofi/wallust-colors.rasi"
    "$HOME/.config/waybar/colors.css"
    "$HOME/.config/dunst/dunstrc.d/50-wallust.conf"
    "$HOME/.config/kitty/themes/Wallust.conf"
    "$HOME/.config/kitty/kitty-themes/01-Wallust.conf"
)

# Succeeds (returns 0) if at least one generated file is missing
generated_missing() {
    local f
    for f in "${generated[@]}"; do
        [[ -e "$f" ]] || return 0
    done
    return 1
}

# Find the wallpaper currently in use: hyprpaper.conf, then the symlink,
# then the first image in the wallpapers folder
current_wallpaper() {
    local p=""
    if [[ -f "$HYPRPAPER_CONF" ]]; then
        p="$(sed -n 's/^ *path *= *//p' "$HYPRPAPER_CONF" | head -1)"
    fi
    if [[ -z "$p" || ! -f "$p" ]] && [[ -e "$CURRENT_LINK" ]]; then
        p="$(readlink -f "$CURRENT_LINK")"
    fi
    if [[ -z "$p" || ! -f "$p" ]]; then
        p="$(find -L "$WALL_DIR" -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            | sort | head -1)"
    fi
    printf '%s\n' "$p"
}

# --- arguments ---
image=""
case "${1:-}" in
    --if-missing)
        generated_missing || exit 0     # everything exists: nothing to do
        ;;
    "")
        ;;
    *)
        image="$1"
        ;;
esac

[[ -n "$image" ]] || image="$(current_wallpaper)"
if [[ -z "$image" || ! -f "$image" ]]; then
    echo "theme-refresh: no wallpaper found" >&2
    notify-send -u critical "Theme refresh" "No wallpaper found in $WALL_DIR" 2>/dev/null || true
    exit 1
fi

# --- prepare ---
# Folders that only hold generated files are not tracked by git, so create them
mkdir -p "$HOME/.cache" "$HOME/.config/dunst/dunstrc.d" \
         "$KITTY_DIR/themes" "$KITTY_DIR/kitty-themes"

# Stable link to the current wallpaper (used by hyprlock)
ln -sf "$image" "$CURRENT_LINK"

# Is kitty on the wallust theme? Check before wallust rewrites the theme file.
kitty_was_wallust=false
if grep -q '^## name: Wallust$' "$KITTY_DIR/current-theme.conf" 2>/dev/null; then
    kitty_was_wallust=true
fi

# --- generate ---
if ! wallust run -s --templates-dir "$TEMPLATES" "$image"; then
    notify-send -u critical "Theme refresh failed" \
        "wallust could not process $(basename "$image")" 2>/dev/null || true
    exit 1     # leave the old colors and the running apps untouched
fi

# wallust only warns when a template is missing, so verify the outputs ourselves
if generated_missing; then
    missing=()
    for f in "${generated[@]}"; do
        [[ -e "$f" ]] || missing+=("$(basename "$f")")
    done
    echo "theme-refresh: not generated: ${missing[*]}" >&2
    notify-send -u critical "Theme refresh" "Not generated: ${missing[*]}" 2>/dev/null || true
fi

dunstctl reload || true

pkill -x waybar || true
sleep 0.2
setsid waybar >/dev/null 2>&1 &

# Hyprland last, so the borders pick up the new colors.lua
hyprctl reload

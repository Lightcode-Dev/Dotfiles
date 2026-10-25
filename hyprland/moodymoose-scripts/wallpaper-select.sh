#!/usr/bin/env bash
# wallpaper-select.sh: pick a wallpaper with rofi thumbnails, apply it,
# then regenerate the wallust palette and refresh everything that uses it.

set -euo pipefail

WALL_DIR="$HOME/Pictures/wallpapers"
CONF="$HOME/.config/hypr/hyprpaper.conf"
KITTY_DIR="$HOME/.config/kitty"

# One rofi row per image: "relative/path.png", then \0icon\x1f<full path>
list_wallpapers() {
    find -L "$WALL_DIR" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -print0 | sort -z |
    while IFS= read -r -d '' file; do
        printf '%s\0icon\x1f%s\n' "${file#"$WALL_DIR"/}" "$file"
    done
}

choice="$(list_wallpapers | rofi -dmenu -i -p "Wallpaper" -show-icons \
    -theme "$HOME/.config/rofi/wallpaper.rasi")" || true

# Esc / clicking away gives an empty choice, so just stop quietly
[ -z "$choice" ] && exit 0

path="$WALL_DIR/$choice"

# Stable symlink to the current wallpaper (used by hyprlock)
mkdir -p "$HOME/.cache"
ln -sf "$path" "$HOME/.cache/wallpaper-current"

# Rewrite hyprpaper.conf so the choice survives a restart or re-login
cat > "$CONF" <<EOF
wallpaper {
    monitor =
    path = $path
    fit_mode = cover
}

splash = false
EOF

# Apply the wallpaper right now, without restarting hyprpaper
hyprctl hyprpaper wallpaper ",$path,cover"

# Is kitty on the wallust theme right now? (checked before wallust rewrites it)
kitty_was_wallust=false
if grep -q '^## name: Wallust$' "$KITTY_DIR/current-theme.conf" 2>/dev/null; then
    kitty_was_wallust=true
fi

# Regenerate every palette (borders, rofi, kitty, waybar) from the new wallpaper
wallust run -s --templates-dir "$HOME/.config/wallust/templates" "$path"

# If kitty was on the wallust theme, re-apply it in every running kitty
if $kitty_was_wallust; then
    kitten themes --reload-in=all Wallust </dev/null || true
fi

# Reload dunst's config in place so notifications use the new colors
dunstctl reload || true

# Restart waybar so it reads the new colors.css from scratch
pkill -x waybar || true
sleep 0.2
setsid waybar >/dev/null 2>&1 &

# Reload Hyprland last so the borders pick up the new colors.lua
hyprctl reload

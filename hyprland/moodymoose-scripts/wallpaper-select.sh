#!/usr/bin/env bash
# wallpaper-select.sh: pick a wallpaper with rofi thumbnails and apply it,
# then hand off to theme-refresh.sh to recolor everything.

set -euo pipefail

WALL_DIR="$HOME/Pictures/wallpapers"
CONF="$HOME/.config/hypr/hyprpaper.conf"
REFRESH="$HOME/.config/hypr/moodymoose-scripts/theme-refresh.sh"

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

# Everything else (palette, symlink, kitty, dunst, waybar, borders) lives in one place
exec "$REFRESH" "$path"

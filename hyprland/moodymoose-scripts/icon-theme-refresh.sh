#!/usr/bin/env bash
# icon-theme-refresh.sh: build the "Wallust" GTK icon theme: Breeze Dark's
# network icons, recolored with the current wallust palette.

set -uo pipefail

SRC="/usr/share/icons/breeze-dark"
DEST="$HOME/.local/share/icons/Wallust"
ENVF="$HOME/.cache/wallust-colors.env"

fail() {
    echo "icon-theme-refresh: $1" >&2
    notify-send -u critical "Icon theme" "$1" >/dev/null 2>&1 &
    exit 1
}

[[ -d "$SRC/status" ]] || fail "$SRC not found (is breeze-icons installed?)"
[[ -f "$ENVF" ]]       || fail "$ENVF missing: run theme-refresh.sh first"

# load FG, ACCENT, ACCENT2, WARN, POSITIVE
source "$ENVF"

# Rebuild from scratch each time (this folder is entirely generated)
rm -rf "$DEST"
mkdir -p "$DEST"

# Copy the network icons for every size Breeze Dark ships.
# cp -L follows Breeze's symlinks (nm-device-wired -> network-wired-activated ...)
# so every file is a real, editable SVG.
dirs=()
for sizedir in "$SRC"/status/*/; do
    size="$(basename "$sizedir")"
    [[ "$size" =~ ^[0-9]+$ ]] || continue
    mkdir -p "$DEST/status/$size"
    copied=0
    for f in "$sizedir"nm-*.svg "$sizedir"network-*.svg; do
        [[ -e "$f" ]] || continue
        cp -L "$f" "$DEST/status/$size/$(basename "$f")" && copied=1
    done
    (( copied )) && dirs+=("status/$size")
done

(( ${#dirs[@]} > 0 )) || fail "no network icons found in $SRC/status"

# index.theme: inherit everything else (folders, apps, ...) from Breeze Dark
{
    echo "[Icon Theme]"
    echo "Name=Wallust"
    echo "Comment=Breeze Dark with palette-colored network icons"
    echo "Inherits=breeze-dark"
    echo "Directories=$(IFS=,; echo "${dirs[*]}")"
    for d in "${dirs[@]}"; do
        echo
        echo "[$d]"
        echo "Size=${d#status/}"
        echo "Context=Status"
        echo "Type=Fixed"
    done
} > "$DEST/index.theme"

# Recolor: Breeze icons take their colors from a few ".ColorScheme-*" classes
# in an embedded stylesheet. Rewrite those color values with the palette.
export FG ACCENT ACCENT2 WARN POSITIVE
find "$DEST" -name '*.svg' -print0 | xargs -0 -r perl -0pi -e '
    s/(\.ColorScheme-(?:Text|ButtonText|ViewText|WindowText)\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{FG}/g;
    s/(\.ColorScheme-(?:Highlight|ViewFocus|ButtonFocus)\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{ACCENT}/g;
    s/(\.ColorScheme-NeutralText\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{ACCENT2}/g;
    s/(\.ColorScheme-PositiveText\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{POSITIVE}/g;
    s/(\.ColorScheme-NegativeText\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{WARN}/g;
'

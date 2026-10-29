#!/usr/bin/env bash
# icon-theme-refresh.sh: build the "Wallust" icon theme: Breeze Dark's network
# and folder icons, recolored with the current wallust palette.

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

dirs=()       # e.g. status/22, places/64
contexts=()   # the matching index.theme Context for each entry

# copy_set <subfolder> <index.theme Context> <file patterns...>
# Copies matching icons for every numeric size folder of <subfolder>.
# cp -L follows Breeze's symlinks, so every file is a real, editable SVG.
copy_set() {
    local sub="$1" context="$2"
    shift 2
    local sizedir size pat f copied
    for sizedir in "$SRC/$sub"/*/; do
        size="$(basename "$sizedir")"
        [[ "$size" =~ ^[0-9]+$ ]] || continue
        mkdir -p "$DEST/$sub/$size"
        copied=0
        for pat in "$@"; do
            for f in "$sizedir"$pat; do
                [[ -e "$f" ]] || continue
                cp -L "$f" "$DEST/$sub/$size/$(basename "$f")" && copied=1
            done
        done
        if (( copied )); then
            dirs+=("$sub/$size")
            contexts+=("$context")
        else
            rmdir "$DEST/$sub/$size" 2>/dev/null
        fi
    done
}

copy_set status    Status    'nm-*.svg' 'network-*.svg'
copy_set places    Places    'folder*.svg' 'user-*.svg'
copy_set mimetypes MimeTypes 'inode-directory*.svg'

(( ${#dirs[@]} > 0 )) || fail "no icons found in $SRC"

# index.theme: inherit everything else (file types, apps, ...) from Breeze Dark
{
    echo "[Icon Theme]"
    echo "Name=Wallust"
    echo "Comment=Breeze Dark with palette-colored network and folder icons"
    echo "Inherits=breeze-dark"
    echo "Directories=$(IFS=,; echo "${dirs[*]}")"
    for i in "${!dirs[@]}"; do
        echo
        echo "[${dirs[$i]}]"
        echo "Size=${dirs[$i]##*/}"
        echo "Context=${contexts[$i]}"
        echo "Type=Fixed"
    done
} > "$DEST/index.theme"

# Recolor: Breeze icons take their colors from a few ".ColorScheme-*" classes
# in an embedded stylesheet. Rewrite those color values with the palette.
export FG ACCENT ACCENT2 WARN POSITIVE
find "$DEST" -name '*.svg' -print0 | xargs -0 -r perl -0pi -e '
    s/(\.ColorScheme-(?:Text|ButtonText|ViewText|WindowText)\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{FG}/g;
    s/(\.ColorScheme-(?:Highlight|ViewFocus|ButtonFocus|Accent)\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{ACCENT}/g;
    s/(\.ColorScheme-NeutralText\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{ACCENT2}/g;
    s/(\.ColorScheme-PositiveText\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{POSITIVE}/g;
    s/(\.ColorScheme-NegativeText\s*\{\s*color:\s*)#[0-9a-fA-F]{3,8}/${1}$ENV{WARN}/g;
'

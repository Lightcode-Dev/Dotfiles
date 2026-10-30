#!/usr/bin/env bash
# clipboard-menu.sh: clipboard history (cliphist) in rofi.
#   clipboard-menu.sh          pick an entry and copy it back to the clipboard
#   clipboard-menu.sh delete   pick an entry to delete from the history
#   clipboard-menu.sh wipe     clear the whole history (asks first)

set -uo pipefail

ROFI_THEME="$HOME/.config/rofi/clipboard.rasi"

# menu "prompt": entries come in on stdin.
# -display-columns 2 hides cliphist's numeric id column (lines look like "<id><TAB><preview>").
menu() {
    rofi -dmenu -i -display-columns 2 -p "$1" -theme "$ROFI_THEME"
}

case "${1:-pick}" in
    pick)
        selection="$(cliphist list | menu "Clipboard")" || exit 0
        [[ -n "$selection" ]] || exit 0     # Esc: do nothing (never copy an empty string)
        printf '%s\n' "$selection" | cliphist decode | wl-copy
        ;;
    delete)
        selection="$(cliphist list | menu "Delete")" || exit 0
        [[ -n "$selection" ]] || exit 0
        printf '%s\n' "$selection" | cliphist delete
        ;;
    wipe)
        answer="$(printf '%s\n' "No, keep it" "Yes, wipe everything" \
            | rofi -dmenu -i -p "Wipe clipboard history?" -theme "$ROFI_THEME" \
                -theme-str 'listview { lines: 2; }')" || exit 0
        [[ "$answer" == "Yes, wipe everything" ]] && cliphist wipe
        ;;
    *)
        echo "usage: $0 [pick|delete|wipe]" >&2
        exit 1
        ;;
esac

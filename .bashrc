#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd --hyperlink=auto'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias grep='grep --color=auto'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --bash)

alias hg="rg --hyperlink-format kitty"
alias hgf="rg --files --hyperlink-format kitty -g"
alias icat="kitten icat --hold"

fzfimg() {
    local dir="${1:-.}"
    local target
    target=$(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) 2>/dev/null | \
        fzf --preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}' \
            --preview-window right:50% \
            --header 'enter: print path | ctrl-c: quit')
    if [[ -n "$target" ]]; then
        echo "$target"
    fi
}

PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"
export ROOTFS="$HOME/Binarys/Archer C5400X_V1_250928/extractions/ArcherC5400x-up-ver1-2-1-P1[20250928-rel12879]_nosign_2025-09-28_13.48.46.bin.extracted/3A1607/ubifs-root/ubi_3A1607.img/img-0_vol-rootfs_ubifs.ubifs.extracted/0/ubifs-root"

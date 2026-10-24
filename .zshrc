# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# --- Oh My Zsh setup ---
export ZSH="$HOME/.oh-my-zsh"              # Path to your oh-my-zsh installation
export QT_QPA_PLATFORMTHEME=qt5ct          # Use qt5ct to theme Qt apps consistently with the rest of the desktop
ZSH_THEME="aussiegeek"                     # Oh My Zsh prompt theme

# Oh My Zsh plugins to load
plugins=(
    git                     # git aliases and prompt info
    archlinux               # helpers/aliases for pacman and other Arch-specific tools
    zsh-autosuggestions     # suggests commands as you type, based on history
    zsh-syntax-highlighting # highlights commands as valid/invalid while typing
)

source $ZSH/oh-my-zsh.sh   # Load Oh My Zsh itself (must come after ZSH/theme/plugins are set)

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# --- Terminal splash / system info on shell start ---
if [ -x /etc/update-motd.d/99-custom-motd ]; then
    /etc/update-motd.d/99-custom-motd
fi
# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
# Pipe a random Pokemon colorscript into fastfetch as the "logo", using a custom fastfetch config
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# --- File listing aliases ---
# Set-up icons for files/directories in terminal using lsd
alias ls='lsd --hyperlink=auto'   # replace ls with lsd (icons + clickable hyperlinks)
alias l='ls -l'                   # long listing
alias la='ls -a'                  # show hidden files
alias lla='ls -la'                # long listing + hidden files
alias lt='ls --tree'              # tree view of directory contents

# --- Fuzzy finder ---
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# --- Shell history settings ---
HISTFILE=~/.zsh_history      # where history is saved
HISTSIZE=10000                # number of history lines kept in memory
SAVEHIST=10000                # number of history lines saved to HISTFILE
setopt appendhistory          # append to history file instead of overwriting
setopt EXTENDED_HISTORY       # save timestamp + duration for each command

# --- PATH additions ---
export PATH="$HOME/.local/bin:$PATH"   # prioritize user-local binaries
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH=~/.npm-global/bin:$PATH
export WEBCAM_DEV=/dev/video0

# --- Misc aliases ---
alias astroterm='astroterm -a 52.95 -o -66.91 -c -C -u'   # astroterm with preset lat/long and display flags
alias hg="rg --hyperlink-format kitty"                     # ripgrep with clickable kitty-terminal hyperlinks
alias hgf="rg --files --hyperlink-format kitty -g"          # ripgrep file listing with kitty hyperlinks
alias icat="kitten icat --hold"                             # display images inline in kitty, keep them on screen

# --- Fuzzy image finder/previewer ---
# Find an image file under the current directory via fzf, previewing it inline with kitty's icat
fzfimg() {
    local target
    target=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) 2>/dev/null | \
        fzf --preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}' \
            --preview-window right:50% \
            --header 'enter: print path | ctrl-c: quit')

    # Print the selected path (or nothing if the user cancelled)
    if [[ -n "$target" ]]; then
        echo "$target"
    fi
}
# --- Claude Code -> local Ollama (GLM-4.7-Flash) ---

# Route Claude Code's requests to your local Ollama server instead of Anthropic's API
export ANTHROPIC_BASE_URL="http://localhost:11434"

# Placeholder token — Ollama doesn't validate this, it just needs to be non-empty
export ANTHROPIC_AUTH_TOKEN="ollama"

# Ollama's default context is only 4096 tokens on <24GB VRAM machines, which breaks
# Claude Code's larger prompts. Raise it to match what you actually want to use.
export OLLAMA_CONTEXT_LENGTH=64000

# Force full GPU offload for faster inference (only helps if you have a GPU)
export OLLAMA_NUM_GPU_LAYERS=99
export CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1
export EDITOR=vim
export VISUAL=vim
export SUDO_EDITOR=vim
export ROOTFS="$HOME/Binarys/Archer C5400X_V1_250928/extractions/ArcherC5400x-up-ver1-2-1-P1[20250928-rel12879]_nosign_2025-09-28_13.48.46.bin.extracted/3A1607/ubifs-root/ubi_3A1607.img/img-0_vol-rootfs_ubifs.ubifs.extracted/0/ubifs-root"

DOTFILES="$HOME/.dotfiles"

export ZSH="$DOTFILES/sheldon/repos/github.com/ohmyzsh/ohmyzsh"

CASE_SENSITIVE="true"
HIST_STAMPS="%d/%m/%Y %H:%M"
# ENABLE_CORRECTION="true"

plugins=(
    git
    docker
    docker-compose
)

# Sheldon
export SHELDON_CONFIG_DIR="$DOTFILES/sheldon"
export SHELDON_DATA_DIR="$DOTFILES/sheldon"
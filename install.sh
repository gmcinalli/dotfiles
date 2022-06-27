#!/usr/bin/env bash

set -e

export DOTFILES=${1:-"$HOME/.dotfiles"}

e='\033'
RESET="${e}[0m"
BOLD="${e}[1m"
CYAN="${e}[0;96m"
RED="${e}[0;91m"
YELLOW="${e}[0;93m"
GREEN="${e}[0;92m"

# Success reporter
info() {
    echo -e "${CYAN}${*}${RESET}"
}

# Error reporter
error() {
    echo -e "${RED}${*}${RESET}"
}

# Success reporter
success() {
    echo -e "${GREEN}${*}${RESET}"
}

_command_exists() {
    command -v $1 &> /dev/null
}

_is_installed() {
    if _command_exists $1; then
        success "You already have $1 installed. Skipping..."
        return 0
    fi

    return 1
}

_check_error() {
    local BIN="$1"

    if [ $? -ne 0 ]; then
        error "Failed to install $BIN. Please check your package manager."
        exit 1
    fi
}

install_linux_binaries() {
    info "Installing binaries..."

    local BINS="zsh gpg git curl wget unzip micro xclip"

    for BIN in $BINS; do
        info "Installing $BIN..."
        if _is_installed $BIN; then
        	continue
        fi
        apt-get install -y -qq $BIN > /dev/null

        _check_error $BIN

        success "Done!"
    done
}

install_zshrc() {
    local ZSHRC="zshrc-linux"
    info "Linking ~/.zshrc to $DOTFILES/$ZSHRC"
    ln -sf $DOTFILES/$ZSHRC $HOME/.zshrc
    success "Done!"
}

install_rust_and_cargo() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -yq > /dev/null
    source "$HOME/.cargo/env"

    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash > /dev/null 2>&1
}

install_sheldon() {
    info "Installing Sheldon..."

    if _is_installed "sheldon"; then
        return
    fi

    if ! _is_installed "cargo"; then
        install_rust_and_cargo "$*"
    fi

    cargo binstall -qy sheldon > /dev/null

    success "Done!"
}

install_eza() {
    info "Installing Eza..."

    if _is_installed "eza"; then
        return
    fi

    mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" > /etc/apt/sources.list.d/gierens.list
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    apt-get update -qq
    apt-get install -y -qq eza > /dev/null

    _check_error "eza"

    success "Done!"
}

set_zsh() {
    info "Setting zsh as default shell..."
    chsh -s /bin/zsh root
    success "Done!"
    zsh
}

install_on_linux() {
    install_linux_binaries "$*"
    echo

    install_sheldon "$*"
    echo

    install_eza "$*"
    echo

    install_zshrc "$*"
    echo

    set_zsh "$*"
    echo
}

# install_homebrew() {
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# }

# install_on_mac() {
    # install_homebrew "$*"
    # install_zshrc "$*"
    # install_sheldon "$*"
# }

on_start() {
    info "           __        __   ____ _  __           "
    info "      ____/ /____   / /_ / __/(_)/ /___   _____"
    info "     / __  // __ \ / __// /_ / // // _ \ / ___/"
    info "  _ / /_/ // /_/ // /_ / __// // //  __/(__  ) "
    info " (_)\__,_/ \____/ \__//_/  /_//_/ \___//____/  "
    info "                                               "
    info "              by @gmcinalli                    "
    info "                                               "

    echo
    read -p "$(info Do you want to proceed with installation? [y/N]) " -n 1 answer

    if [ -z $answer ] || [ $answer != "y" ]; then
        success "Bye!"
        exit 1
    fi

    echo
}

main() {
    on_start "$*"

    case "$(uname)" in
        Linux) install_on_linux;;
        # Darwin) install_on_mac;;
        *) exit 1;;
    esac
}

main "$*"
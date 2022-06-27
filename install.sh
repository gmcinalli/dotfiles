#!/usr/bin/env bash

export DOTFILES=${1:-"$HOME/.dotfiles"}

_exists() {
    command -v $1 &> /dev/null
}

_guard() {
    if _exists $1; then
        echo "You already have $1 installed. Skipping..."
        return 0
    fi

    return 1
}

install_linux_binaries() {
    echo "Installing binaries..."

    local BINS="zsh git curl unzip micro xclip"

    for BIN in $BINS; do
        if _guard $BIN; then
        	continue
        fi
        apt install $BIN
    done
    echo
}

install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_zshrc() {
    echo "Linking ~/.zshrc to $DOTFILES/$ZSHRC"
    local ZSHRC="zshrc-linux"
    ln -sf $DOTFILES/$ZSHRC $HOME/.zshrc
    echo "DONE"
    echo
}

install_sheldon() {
    echo "Installing Sheldon..."

    if _guard "sheldon"; then
    	echo
        return
    fi

    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to /usr/local/bin &> /dev/null
    echo "DONE"
    echo
}

install_exa() {
    echo "Installing Exa..."

    if _guard "exa"; then
		echo
        return
    fi

    local VERSION="v0.10.1"
    local FILE_NAME="exa-linux-x86_64-$VERSION"
    local FILE_NAME_ZIP="$FILE_NAME.zip"
    local FILE_PATH="/tmp/$FILE_NAME_ZIP"
    local EXTRACTION_FOLDER="/tmp/$FILE_NAME"
    local URL="https://github.com/ogham/exa/releases/download/$VERSION/$FILE_NAME_ZIP"

    wget $URL -O $FILE_PATH &> /dev/null
    mkdir $EXTRACTION_FOLDER
    unzip $FILE_PATH -d $EXTRACTION_FOLDER &> /dev/null
    mv $EXTRACTION_FOLDER/bin/* /usr/local/bin
    mv $EXTRACTION_FOLDER/man/* /usr/share/man/man1
    mv $EXTRACTION_FOLDER/completions/exa.zsh /usr/local/share/zsh/site-functions/_exa

    # Cleanup.
    rm $FILE_PATH
    rm -rf $EXTRACTION_FOLDER
    echo "DONE"
    echo
}

install_on_linux() {
    install_linux_binaries "$*"
    install_zshrc "$*"
    install_sheldon "$*"
    install_exa "$*"
}

# install_on_mac() {
    # install_homebrew "$*"
    # install_zshrc "$*"
    # install_sheldon "$*"
# }

on_start() {
    echo "           __        __   ____ _  __           "
    echo "      ____/ /____   / /_ / __/(_)/ /___   _____"
    echo "     / __  // __ \ / __// /_ / // // _ \ / ___/"
    echo "  _ / /_/ // /_/ // /_ / __// // //  __/(__  ) "
    echo " (_)\__,_/ \____/ \__//_/  /_//_/ \___//____/  "
    echo "                                               "
    echo "              by @gmcinalli                    "
    echo "                                               "

    echo
    read -p "Do you want to proceed with installation? [y/N] " -n 1 answer
    echo
    if [ ${answer} != "y" ]; then
        exit 1
    fi
    echo
    echo
}

main() {
    on_start "$*"

    case "$(uname)" in
        # Darwin) install_on_mac;;
        Linux) install_on_linux;;
        *) exit 1;;
    esac
}

main "$*"

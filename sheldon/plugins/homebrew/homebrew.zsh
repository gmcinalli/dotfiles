# Homebrew

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit && compinit
fi

export HOMEBREW_AUTO_UPDATE_SECS="86400"
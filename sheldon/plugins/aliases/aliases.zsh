# Aliases

# Eza
alias ls="eza --header --icons --group --group-directories-first --links"
alias ll="ls --long"
alias lla="ll --all"
alias llt="lla --tree"

# Recursively delete `.DS_Store` files
alias cleands="find . -type f -name '*.DS_Store' -ls -delete"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Reload the shell
alias reload="exec ${SHELL} -l"

# Cat with syntax highlighting
alias bat="bat --theme OneHalfDark"
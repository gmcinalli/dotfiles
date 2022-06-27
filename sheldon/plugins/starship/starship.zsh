# Starship

_DISTRO_LINUX_FILE="/etc/*-release"
_DISTRO_MAC_FILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $_DISTRO_LINUX_FILE ]]; then
    _DISTRO_TEXT=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
elif [[ -f $_DISTRO_MAC_FILE ]]; then
    _DISTRO_TEXT="macos"
fi

case $_DISTRO_TEXT in
    *kali*)                  _DISTRO_ICON="ﴣ";;
    *arch*)                  _DISTRO_ICON="";;
    *debian*)                _DISTRO_ICON="";;
    *raspbian*)              _DISTRO_ICON="";;
    *ubuntu*)                _DISTRO_ICON="";;
    *elementary*)            _DISTRO_ICON="";;
    *fedora*)                _DISTRO_ICON="";;
    *coreos*)                _DISTRO_ICON="";;
    *gentoo*)                _DISTRO_ICON="";;
    *mageia*)                _DISTRO_ICON="";;
    *centos*)                _DISTRO_ICON="";;
    *opensuse*|*tumbleweed*) _DISTRO_ICON="";;
    *sabayon*)               _DISTRO_ICON="";;
    *slackware*)             _DISTRO_ICON="";;
    *linuxmint*)             _DISTRO_ICON="";;
    *alpine*)                _DISTRO_ICON="";;
    *aosc*)                  _DISTRO_ICON="";;
    *nixos*)                 _DISTRO_ICON="";;
    *devuan*)                _DISTRO_ICON="";;
    *manjaro*)               _DISTRO_ICON="";;
    *rhel*)                  _DISTRO_ICON="";;
    *macos*)                 _DISTRO_ICON="";;
    *)                       _DISTRO_ICON="";;
esac

export STARSHIP_DISTRO="$_DISTRO_ICON"
export STARSHIP_CONFIG="$(cd "$(dirname "$0")" && pwd)/starship.toml"
eval "$(starship init zsh)"
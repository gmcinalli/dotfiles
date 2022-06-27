_udm_routes() {
    if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
        echo "Usage: udmroutes [on|off|get] [INTERFACE_NAME] [GATEWAY (optional)]"
        return 1
    fi

    if [[ "$1" != "on" && "$1" != "off" && "$1" != "get" ]]; then
        echo "Usage: udmroutes [on|off|get] [INTERFACE_NAME] [GATEWAY (optional)]"
        return 1
    fi

    GATEWAY="${3:-10.0.20.1}"

    # Calcola la rete del gateway (assumendo /24)
    IFS='.' read -r g1 g2 g3 g4 <<< "$GATEWAY"
    GATEWAY_NET="${g1}.${g2}.${g3}.0"

    ROUTES=(
        "10.0.10.0"
        "10.0.20.0"
        "10.0.30.0"
        "10.0.40.0"
        "10.0.50.0"
        "10.0.110.0"
        "10.0.120.0"
        "10.0.130.0"
        "10.0.140.0"
        "192.168.178.0"
        "172.16.25.0"
    )

    case $1 in
        on)
            CMD=(sudo networksetup -setadditionalroutes "$2")
            for net in "${ROUTES[@]}"; do
                if [[ "$net" != "$GATEWAY_NET" ]]; then
                    CMD+=("$net" "255.255.255.0" "$GATEWAY")
                fi
            done
            "${CMD[@]}"
        ;;
        off)
            sudo networksetup -setadditionalroutes "$2"
        ;;
        get)
            sudo networksetup -getadditionalroutes "$2"
        ;;
    esac
}

# Wrapper compatibile con completamento zsh
udmroutes() {
  _udm_routes "$@"
}

alias forti="sudo openfortivpn -c /etc/openfortivpn/config"
alias sail="./vendor/bin/sail"
alias sailopt="sail artisan optimize:clear"
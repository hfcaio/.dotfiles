#!/usr/bin/env bash

ICON_W4="󰤨"
ICON_W3="󰤥"
ICON_W2="󰤢"
ICON_W1="󰤟"
ICON_WOFF="󰤭"
ICON_LOCK="󰌾"
ICON_ACTIVE=""

rofi_show() {
    rofi -dmenu -i -p "${1:-}" -theme-str 'window {width: 500px;} listview {lines: 12;}'
}

notify() {
    notify-send "WiFi" "$1" 2>/dev/null || true
}

wifi_on() {
    [[ "$(nmcli radio wifi)" == "enabled" ]]
}

active_ssid() {
    nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '/^yes:/{print substr($0,5)}'
}

wifi_device() {
    nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}'
}

signal_icon() {
    if   [[ "$1" -ge 75 ]]; then echo "$ICON_W4"
    elif [[ "$1" -ge 50 ]]; then echo "$ICON_W3"
    elif [[ "$1" -ge 25 ]]; then echo "$ICON_W2"
    else                         echo "$ICON_W1"
    fi
}

toggle_wifi() {
    if wifi_on; then
        nmcli radio wifi off && notify "WiFi desligado"
    else
        nmcli radio wifi on && notify "WiFi ligado"
    fi
}

connect_to() {
    local ssid="$1" secured="$2"

    if nmcli -t -f NAME connection show | grep -qxF "$ssid"; then
        nmcli connection up id "$ssid" && notify "Conectado: $ssid" || notify "Falha ao conectar: $ssid"
        return
    fi

    if [[ "$secured" == "1" ]]; then
        local pass
        pass=$(rofi -dmenu -password -p "Senha para: $ssid")
        [[ -z "$pass" ]] && return
        nmcli device wifi connect "$ssid" password "$pass" \
            && notify "Conectado: $ssid" \
            || notify "Falha ao conectar: $ssid"
    else
        nmcli device wifi connect "$ssid" \
            && notify "Conectado: $ssid" \
            || notify "Falha ao conectar: $ssid"
    fi
}

main() {
    local -a entries ssids sec_flags
    declare -A seen

    if wifi_on; then
        entries=("$ICON_W4  WiFi: Ligado")
    else
        entries=("$ICON_WOFF  WiFi: Desligado")
    fi
    ssids=("")
    sec_flags=("")

    if wifi_on; then
        nmcli device wifi rescan 2>/dev/null &

        while IFS= read -r line; do
            local active ssid signal security
            active="${line%%:*}"
            rest="${line#*:}"
            ssid="${rest%%:*}"
            rest="${rest#*:}"
            signal="${rest%%:*}"
            security="${rest#*:}"

            [[ -z "$ssid" || "$ssid" == "--" ]] && continue
            [[ -n "${seen[$ssid]}" ]] && continue
            seen[$ssid]=1

            local icon lock sec_flag=0
            icon=$(signal_icon "$signal")
            lock=""
            if [[ -n "$security" && "$security" != "--" ]]; then
                lock=" $ICON_LOCK"
                sec_flag=1
            fi

            if [[ "$active" == "yes" ]]; then
                entries+=("$ICON_ACTIVE  $ssid$lock  [ativo]")
            else
                entries+=("$icon  $ssid$lock")
            fi
            ssids+=("$ssid")
            sec_flags+=("$sec_flag")
        done < <(nmcli -t -f ACTIVE,SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null)
    fi

    local chosen
    chosen=$(printf '%s\n' "${entries[@]}" | rofi_show "󰤨 WiFi")
    [[ -z "$chosen" ]] && return

    local i=0
    for entry in "${entries[@]}"; do
        [[ "$chosen" == "$entry" ]] && break
        ((i++))
    done

    case "$chosen" in
        *"WiFi:"*)
            toggle_wifi ;;
        *"[ativo]"*)
            nmcli device disconnect "$(wifi_device)" && notify "Desconectado" ;;
        *)
            local ssid="${ssids[$i]}"
            local sec="${sec_flags[$i]}"
            [[ -n "$ssid" ]] && connect_to "$ssid" "$sec"
            ;;
    esac
}

main

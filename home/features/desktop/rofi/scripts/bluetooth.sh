#!/usr/bin/env bash

ICON_ON="󰂯"
ICON_OFF="󰂲"
ICON_CONNECTED=""
ICON_PAIRED="󰂱"
ICON_SCAN="󰂰"

rofi_show() {
    rofi -dmenu -i -p "${1:-}" -theme-str 'window {width: 420px;} listview {lines: 10;}'
}

notify() {
    notify-send -i bluetooth "Bluetooth" "$1" 2>/dev/null || true
}

power_on() {
    bluetoothctl show | grep -q "Powered: yes"
}

is_connected() {
    bluetoothctl info "$1" | grep -q "Connected: yes"
}

toggle_power() {
    if power_on; then
        bluetoothctl power off
        notify "Bluetooth desligado"
    else
        bluetoothctl power on
        notify "Bluetooth ligado"
    fi
}

device_menu() {
    local mac="$1"
    local name
    name=$(bluetoothctl info "$mac" | awk '/Name:/{$1=""; print substr($0,2); exit}')

    local -a opts
    if is_connected "$mac"; then
        opts=("󰒎  Desconectar" "  Remover")
    else
        opts=("  Conectar" "  Remover")
    fi

    local chosen
    chosen=$(printf '%s\n' "${opts[@]}" | rofi_show "$name")
    [[ -z "$chosen" ]] && return

    case "$chosen" in
        *"Conectar"*)    bluetoothctl connect    "$mac" && notify "Conectado: $name" ;;
        *"Desconectar"*) bluetoothctl disconnect "$mac" && notify "Desconectado: $name" ;;
        *"Remover"*)     bluetoothctl remove     "$mac" && notify "Removido: $name" ;;
    esac
}

scan_menu() {
    notify "Escaneando por 5 segundos..."
    bluetoothctl --timeout 5 scan on &>/dev/null &
    sleep 5

    local -a entries macs
    while read -r _ mac rest; do
        [[ -z "$mac" ]] && continue
        entries+=("$ICON_SCAN  $rest")
        macs+=("$mac")
    done < <(bluetoothctl devices)

    [[ ${#entries[@]} -eq 0 ]] && { notify "Nenhum dispositivo encontrado"; return; }

    local chosen
    chosen=$(printf '%s\n' "${entries[@]}" | rofi_show "Escanear")
    [[ -z "$chosen" ]] && return

    local i=0
    for entry in "${entries[@]}"; do
        [[ "$chosen" == "$entry" ]] && break
        ((i++))
    done

    local mac="${macs[$i]}"
    [[ -z "$mac" ]] && return

    local name="${entries[$i]#*  }"
    bluetoothctl pair "$mac" 2>/dev/null
    bluetoothctl connect "$mac" && notify "Conectado: $name"
}

main() {
    local -a entries macs

    if power_on; then
        entries=("$ICON_ON  Bluetooth: Ligado")
        macs=("")

        while read -r _ mac rest; do
            [[ -z "$mac" ]] && continue
            if is_connected "$mac"; then
                entries+=("$ICON_CONNECTED  $rest")
            else
                entries+=("$ICON_PAIRED  $rest")
            fi
            macs+=("$mac")
        done < <(bluetoothctl devices Paired)

        entries+=("$ICON_SCAN  Escanear dispositivos")
        macs+=("")
    else
        entries=("$ICON_OFF  Bluetooth: Desligado")
        macs=("")
    fi

    local chosen
    chosen=$(printf '%s\n' "${entries[@]}" | rofi_show "󰂯 Bluetooth")
    [[ -z "$chosen" ]] && return

    local i=0
    for entry in "${entries[@]}"; do
        [[ "$chosen" == "$entry" ]] && break
        ((i++))
    done

    case "$chosen" in
        *"Bluetooth:"*) toggle_power ;;
        *"Escanear"*)   scan_menu ;;
        *)
            local mac="${macs[$i]}"
            [[ -n "$mac" ]] && device_menu "$mac"
            ;;
    esac
}

main

#!/usr/bin/env bash

# Rofi custom mode for system controls.
# ROFI_RETV=0 → initial list; ROFI_RETV=1 → item selected.

if [[ "$ROFI_RETV" == "1" ]]; then
    case "$1" in
        *"Bluetooth"*) nohup bash -c 'sleep 0.2; "$HOME/.config/rofi/bluetooth.sh"' &>/dev/null & ;;
        *"WiFi"*)      nohup bash -c 'sleep 0.2; "$HOME/.config/rofi/wifi.sh"' &>/dev/null & ;;
        *"Power"*)     nohup bash -c 'sleep 0.2; "$HOME/.config/rofi/powermenu.sh"' &>/dev/null & ;;
    esac
    exit 1
fi

printf '%s\n' \
    "󰂯  Bluetooth" \
    "󰤨  WiFi" \
    "⏻  Power"

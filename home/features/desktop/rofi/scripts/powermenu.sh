#!/usr/bin/env bash

# Rofi Power Menu Type 4 Style 1

uptime="$(uptime | awk -F'up' '{print $2}' | cut -d',' -f1 | xargs)"
host=$(hostname)

# Options com ícones Nerd Font
shutdown='⏻'
reboot='󰑙'
lock=''
suspend=''
logout=''
yes=''
no=''	

       	# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "Goodbye ${USER}" \
    -mesg "Uptime: $uptime" \
    -theme ~/.config/rofi/powermenu.rasi
}

# Confirmation CMD
confirm_cmd() {
  rofi -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you Sure?' \
    -theme ~/.config/rofi/powermenu.rasi
}

# Ask for confirmation
confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
      systemctl reboot
    elif [[ $1 == '--suspend' ]]; then
      systemctl suspend
    elif [[ $1 == '--logout' ]]; then
        hyprctl dispatch exit
    fi
  else
    exit 0
  fi
}

# Actions
chosen="$(run_rofi)"
case "$chosen" in
  "$shutdown")
    run_cmd --shutdown
    ;;
  "$reboot")
    run_cmd --reboot
    ;;
  "$lock")
    hyprlock
    ;;
  "$suspend")
    run_cmd --suspend
    ;;
  "$logout")
    run_cmd --logout
    ;;
esac 

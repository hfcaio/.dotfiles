{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi-powermenu;
  colors = config.lib.stylix.colors;
in
{
  options.features.desktop.rofi-powermenu.enable = mkEnableOption "enable rofi powermenu";

  config = mkIf cfg.enable {
    home.file.".config/rofi/powermenu.rasi" = {
      text = ''
        /**
         * Power Menu Type 4 Style 1
         **/

        configuration {
            show-icons:                 false;
        }

        * {
            mainbox-spacing:             100px;
            mainbox-margin:              100px 300px;
            message-margin:              0px 400px;
            message-padding:             15px;
            message-border-radius:       100%;
            listview-spacing:            50px;
            element-padding:             55px 60px;
            element-border-radius:       100%;

            prompt-font:                 "JetBrains Mono Nerd Font Bold Italic 64";
            textbox-font:                "JetBrains Mono Nerd Font 16";
            element-text-font:           "JetBrains Mono Nerd Font Bold 48";

            background-window:           rgba(0, 0, 0, 40%);
            background-normal:           rgba(0, 0, 0, 60%);
            background-selected:         rgba(255, 255, 255, 20%);
            foreground-normal:           #${colors.base05};
            foreground-selected:         #${colors.base0D};
            border-color:                #${colors.base0D};
        }

        window {
            transparency:                "real";
            location:                    center;
            anchor:                      center;
            fullscreen:                  true;
            cursor:                      "default";
            background-color:            var(background-window);
            border:                      2px solid;
            border-color:                transparent;
        }

        mainbox {
            enabled:                     true;
            spacing:                     var(mainbox-spacing);
            margin:                      var(mainbox-margin);
            background-color:            transparent;
            children:                    [ "dummy", "inputbar", "listview", "message", "dummy" ];
        }

        inputbar {
            enabled:                     true;
            background-color:            transparent;
            children:                    [ "dummy", "prompt", "dummy"];
        }

        dummy {
            background-color:            transparent;
        }

        prompt {
            enabled:                     true;
            font:                        var(prompt-font);
            background-color:            transparent;
            text-color:                  var(foreground-normal);
        }

        message {
            enabled:                     true;
            margin:                      var(message-margin);
            padding:                     var(message-padding);
            border-radius:               var(message-border-radius);
            background-color:            var(background-normal);
            text-color:                  var(foreground-normal);
            border:                      2px solid;
            border-color:                var(border-color);
        }

        textbox {
            font:                        var(textbox-font);
            background-color:            transparent;
            text-color:                  inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
        }

        listview {
            enabled:                     true;
            expand:                      false;
            columns:                     5;
            lines:                       1;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   false;
            layout:                      vertical;
            reverse:                     false;
            fixed-height:                true;
            fixed-columns:               true;

            spacing:                     var(listview-spacing);
            background-color:            transparent;
            cursor:                      "default";
        }

        element {
            enabled:                     true;
            padding:                     var(element-padding);
            border-radius:               var(element-border-radius);
            background-color:            var(background-normal);
            text-color:                  var(foreground-normal);
            cursor:                      pointer;
            border:                      2px solid;
            border-color:                transparent;
        }

        element selected {
            background-color:            var(background-selected);
            text-color:                  var(foreground-selected);
            border-color:                var(border-color);
        }

        element-text {
            font:                        var(element-text-font);
            background-color:            transparent;
            text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
        }
      '';
    };

    home.file.".config/rofi/powermenu.sh" = {
      executable = true;
      text = ''
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
            -p "Goodbye ''${USER}" \
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
      '';
    };
  };
}

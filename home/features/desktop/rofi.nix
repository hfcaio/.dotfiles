{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi;
in
{
  options.features.desktop.rofi.enable = mkEnableOption "enable rofi";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;

      extraConfig = {
        modi = "drun,window";
        case-sensitive = false;
        cycle = true;
        filter = "";
        scroll-method = 0;
        normalize-match = true;
        show-icons = true;
        icon-theme = "Papirus";
        steal-focus = false;
        matching = "normal";
        tokenize = true;
        ssh-client = "ssh";
        ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
        parse-hosts = true;
        parse-known-hosts = true;
        drun-categories = "";
        drun-match-fields = "name,generic,exec,categories,keywords";
        drun-display-format = "{name}";
        drun-show-actions = false;
        drun-url-launcher = "xdg-open";
        drun-use-desktop-cache = false;
        drun-reload-desktop-cache = false;
        run-command = "{cmd}";
        run-list-command = "";
        run-shell-command = "{terminal} -e {cmd}";
        window-match-fields = "title,class,role,name,desktop";
        window-command = "wmctrl -i -R {window}";
        window-format = "{w} · {c} · {t}";
        window-thumbnail = false;
        disable-history = false;
        sorting-method = "normal";
        max-history-size = 25;
        display-drun = "Apps";
        display-run = "Run";
        display-filebrowser = "Files";
        display-window = "Windows";
        display-windowcd = "Window CD";
        display-ssh = "SSH";
        display-combi = "Combi";
        display-keys = "Keys";
        terminal = "rofi-sensible-terminal";
        font = "JetBrains Mono 12";
        sort = false;
        threads = 0;
        click-to-exit = true;
      };

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          base00 = config.lib.stylix.colors.base00;
          base05 = config.lib.stylix.colors.base05;
          base0C = config.lib.stylix.colors.base0C;
          base0D = config.lib.stylix.colors.base0D;
          base02 = config.lib.stylix.colors.base02;

          # Converte hex pra RGB baseado no código nix-colors
          hexToRGB =
            hex:
            let
              rgbStartIndex = [
                0
                2
                4
              ];
              hexToDec =
                h:
                let
                  hexToDecMap = {
                    "0" = 0;
                    "1" = 1;
                    "2" = 2;
                    "3" = 3;
                    "4" = 4;
                    "5" = 5;
                    "6" = 6;
                    "7" = 7;
                    "8" = 8;
                    "9" = 9;
                    "a" = 10;
                    "b" = 11;
                    "c" = 12;
                    "d" = 13;
                    "e" = 14;
                    "f" = 15;
                  };
                  lowerH = lib.toLower h;
                in
                if builtins.stringLength h == 1 then
                  hexToDecMap."${lowerH}" or 0
                else
                  let
                    chars = lib.stringToCharacters h;
                  in
                  builtins.foldl' (acc: c: acc * 16 + (hexToDecMap."${lib.toLower c}" or 0)) 0 chars;
              cleanHex = builtins.substring 1 6 hex;
              hexList = builtins.map (x: builtins.substring x 2 cleanHex) rgbStartIndex;
            in
            builtins.map hexToDec hexList;

          hexToRGBString =
            sep: hex:
            let
              rgb = hexToRGB hex;
            in
            lib.concatStringsSep sep (builtins.map builtins.toString rgb);

          base00Rgb = hexToRGBString ", " base00;
        in
        {
          "window" = {
            location = mkLiteral "center";
            anchor = mkLiteral "center";
            fullscreen = mkLiteral "false";
            width = mkLiteral "800px";
            x-offset = mkLiteral "0px";
            y-offset = mkLiteral "0px";
            enabled = mkLiteral "true";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "10px";
            cursor = mkLiteral "\"default\"";
            background-color = mkForce (mkLiteral "rgba ( ${base00Rgb}, 80 % )");
          };

          "mainbox" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "20px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            children = mkLiteral "[ \"inputbar\", \"mode-switcher\", \"message\", \"listview\" ]";
          };

          "inputbar" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            children = mkLiteral "[ \"textbox-prompt-colon\", \"entry\" ]";
          };

          "prompt" = {
            enabled = mkLiteral "true";
          };

          "textbox-prompt-colon" = {
            enabled = mkLiteral "true";
            padding = mkLiteral "5px 0px";
            expand = mkLiteral "false";
            str = mkLiteral "\"\"";
          };

          "entry" = {
            enabled = mkLiteral "true";
            padding = mkLiteral "5px 0px";
            cursor = mkLiteral "text";
            placeholder = mkLiteral "\"Search...\"";
          };

          "num-filtered-rows" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
          };

          "textbox-num-sep" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
            str = mkLiteral "\"/\"";
          };

          "num-rows" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
          };

          "case-indicator" = {
            enabled = mkLiteral "true";
          };

          "listview" = {
            enabled = mkLiteral "true";
            columns = mkLiteral "1";
            lines = mkLiteral "8";
            cycle = mkLiteral "true";
            dynamic = mkLiteral "true";
            scrollbar = mkLiteral "false";
            layout = mkLiteral "vertical";
            reverse = mkLiteral "false";
            fixed-height = mkLiteral "true";
            fixed-columns = mkLiteral "true";
            spacing = mkLiteral "5px";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            cursor = mkLiteral "\"default\"";
          };

          "scrollbar" = {
            handle-width = mkLiteral "5px";
            border-radius = mkLiteral "10px";
          };

          "element" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "10px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "8px";
            cursor = mkLiteral "pointer";
          };

          "element normal.normal" = {
            background-color = mkForce (mkLiteral "#${base00}");
            text-color = mkForce (mkLiteral "#${base05}");
          };

          "element selected.normal" = {
            background-color = mkForce (mkLiteral "#${base0D}");
            text-color = mkForce (mkLiteral "#${base05}");
          };

          "element alternate.normal" = {
            background-color = mkForce (mkLiteral "#${base00}");
            text-color = mkForce (mkLiteral "#${base05}");
          };

          "element-icon" = {
            size = mkLiteral "24px";
            cursor = mkLiteral "inherit";
          };

          "element-text" = {
            highlight = mkLiteral "inherit";
            cursor = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };

          "mode-switcher" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
          };

          "button" = {
            padding = mkLiteral "12px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "8px";
            background-color = mkForce (mkLiteral "#${base02}");
            cursor = mkLiteral "pointer";
          };

          "button selected" = {
            background-color = mkForce (mkLiteral "#${base0C}");
          };

          "message" = {
            enabled = mkLiteral "true";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
          };

          "textbox" = {
            padding = mkLiteral "12px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "8px";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
            highlight = mkLiteral "none";
            blink = mkLiteral "true";
            markup = mkLiteral "true";
          };

          "error-message" = {
            padding = mkLiteral "0px";
            border = mkLiteral "2px solid";
            border-radius = mkLiteral "8px";
          };
        };
    };
  };
}

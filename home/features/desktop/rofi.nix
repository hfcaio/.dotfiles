{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi;
  colors = config.lib.stylix.colors;
in
{
  options.features.desktop.rofi.enable = mkEnableOption "enable rofi";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;

      extraConfig = {
        modi = "drun";
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
        in
        {
          "*" = {
            border-colour = mkLiteral "#${colors.base0D}";
            handle-colour = mkLiteral "#${colors.base0D}";
            background-colour = mkLiteral "#${colors.base00}";
            foreground-colour = mkLiteral "#${colors.base05}";
            alternate-background = mkLiteral "#${colors.base01}";
            normal-background = mkLiteral "#${colors.base00}";
            normal-foreground = mkLiteral "#${colors.base05}";
            urgent-background = mkLiteral "#${colors.base08}";
            urgent-foreground = mkLiteral "#${colors.base00}";
            active-background = mkLiteral "#${colors.base0B}";
            active-foreground = mkLiteral "#${colors.base00}";
            selected-normal-background = mkLiteral "#${colors.base0D}";
            selected-normal-foreground = mkLiteral "#${colors.base00}";
            selected-urgent-background = mkLiteral "#${colors.base0B}";
            selected-urgent-foreground = mkLiteral "#${colors.base00}";
            selected-active-background = mkLiteral "#${colors.base08}";
            selected-active-foreground = mkLiteral "#${colors.base00}";
            alternate-normal-background = mkLiteral "#${colors.base00}";
            alternate-normal-foreground = mkLiteral "#${colors.base05}";
            alternate-urgent-background = mkLiteral "#${colors.base08}";
            alternate-urgent-foreground = mkLiteral "#${colors.base00}";
            alternate-active-background = mkLiteral "#${colors.base0B}";
            alternate-active-foreground = mkLiteral "#${colors.base00}";
          };

          "window" = {
            transparency = mkLiteral "\"real\"";
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
            border-color = mkLiteral "@border-colour";
            cursor = mkLiteral "\"default\"";
            background-color = mkLiteral "@background-colour";
          };

          "mainbox" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "20px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "transparent";
            children = mkLiteral "[ \"inputbar\", \"mode-switcher\", \"message\", \"listview\" ]";
          };

          "inputbar" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground-colour";
            children = mkLiteral "[ \"textbox-prompt-colon\", \"entry\" ]";
          };

          "prompt" = {
            enabled = mkLiteral "true";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          "textbox-prompt-colon" = {
            enabled = mkLiteral "true";
            padding = mkLiteral "5px 0px";
            expand = mkLiteral "false";
            str = mkLiteral "\"\"";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          "entry" = {
            enabled = mkLiteral "true";
            padding = mkLiteral "5px 0px";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "text";
            placeholder = mkLiteral "\"Search...\"";
            placeholder-color = mkLiteral "inherit";
          };

          "num-filtered-rows" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          "textbox-num-sep" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
            str = mkLiteral "\"/\"";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          "num-rows" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          "case-indicator" = {
            enabled = mkLiteral "true";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
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
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground-colour";
            cursor = mkLiteral "\"default\"";
          };

          "scrollbar" = {
            handle-width = mkLiteral "5px";
            handle-color = mkLiteral "@handle-colour";
            border-radius = mkLiteral "10px";
            background-color = mkLiteral "@alternate-background";
          };

          "element" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "10px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "8px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground-colour";
            cursor = mkLiteral "pointer";
          };

          "element normal.normal" = {
            background-color = mkLiteral "var(normal-background)";
            text-color = mkLiteral "var(normal-foreground)";
          };

          "element normal.urgent" = {
            background-color = mkLiteral "var(urgent-background)";
            text-color = mkLiteral "var(urgent-foreground)";
          };

          "element normal.active" = {
            background-color = mkLiteral "var(active-background)";
            text-color = mkLiteral "var(active-foreground)";
          };

          "element selected.normal" = {
            background-color = mkLiteral "var(selected-normal-background)";
            text-color = mkLiteral "var(selected-normal-foreground)";
          };

          "element selected.urgent" = {
            background-color = mkLiteral "var(selected-urgent-background)";
            text-color = mkLiteral "var(selected-urgent-foreground)";
          };

          "element selected.active" = {
            background-color = mkLiteral "var(selected-active-background)";
            text-color = mkLiteral "var(selected-active-foreground)";
          };

          "element alternate.normal" = {
            background-color = mkLiteral "var(alternate-normal-background)";
            text-color = mkLiteral "var(alternate-normal-foreground)";
          };

          "element alternate.urgent" = {
            background-color = mkLiteral "var(alternate-urgent-background)";
            text-color = mkLiteral "var(alternate-urgent-foreground)";
          };

          "element alternate.active" = {
            background-color = mkLiteral "var(alternate-active-background)";
            text-color = mkLiteral "var(alternate-active-foreground)";
          };

          "element-icon" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            size = mkLiteral "24px";
            cursor = mkLiteral "inherit";
          };

          "element-text" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
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
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground-colour";
          };

          "button" = {
            padding = mkLiteral "12px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "8px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "@alternate-background";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "pointer";
          };

          "button selected" = {
            background-color = mkLiteral "var(selected-normal-background)";
            text-color = mkLiteral "var(selected-normal-foreground)";
          };

          "message" = {
            enabled = mkLiteral "true";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground-colour";
          };

          "textbox" = {
            padding = mkLiteral "12px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "8px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "@alternate-background";
            text-color = mkLiteral "@foreground-colour";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
            highlight = mkLiteral "none";
            placeholder-color = mkLiteral "@foreground-colour";
            blink = mkLiteral "true";
            markup = mkLiteral "true";
          };

          "error-message" = {
            padding = mkLiteral "0px";
            border = mkLiteral "2px solid";
            border-radius = mkLiteral "8px";
            border-color = mkLiteral "@border-colour";
            background-color = mkLiteral "@background-colour";
            text-color = mkLiteral "@foreground-colour";
          };
        };
    };
  };
}

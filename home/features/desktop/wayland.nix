{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.wayland;
in {
  options.features.desktop.wayland.enable =
    mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ./styles/waybar.css;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = [ "custom/logo" "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "backlight" "pulseaudio" "network" "battery" ];

          battery = {
            format = "{capacity}% {icon}";
            "format-icons" = {
              "charging" = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
              "default" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            };
            "format-full" = "󰁹 ";
            interval = 1;
            states = {
              warning = 20;
              critical = 10;
            };
            tooltip = false;
          };

          backlight = {
            device = "intel_backlight";
            format = "{percent}% {icon}";
            format-icons = [ "" "" ];
          };

          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr}";
            tooltip-format = "{ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "󰂰";
            nospacing = 1;
            tooltip-format = "Volume : {volume}%";
            format-muted = "󰝟";
            format-icons = {
              headphone = "";
              default = [ "󰖀" "󰕾" "" ];
            };
            on-click = "pamixer -t";
            scroll-step = 1;
          };

          clock = {
            "tooltip-format" = "<tt>{calendar}</tt>";
            "format-alt" = "  {:%a, %d %b %Y}";
            format = "󰥔  {:%I:%M %p}";
          };

          "custom/logo" = {
            format = "  ";
            tooltip = false;
          };
        };
      };
    };

    home.packages = with pkgs; [
      hypaper
      waybar
      hyprshot
      hypridle
      hyprlock
    ];
  };
}

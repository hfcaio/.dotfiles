{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.hyprland;
  wallpaper = ./images/117794241_p2.jpg;
in
{
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {

    # ── Packages ────────────────────────────────────────────────────────────
    home.packages = with pkgs; [
      wl-clipboard
      brightnessctl
      hyprshot
      hypridle
      hyprlock
      hyprpaper
      pamixer
    ];

    # ── Wallpaper config ────────────────────────────────────────────────────
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = ,${wallpaper}
      splash = false
    '';

    # ── Hyprland ─────────────────────────────────────────────────────────────
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      configType = "hyprlang";

      # use the ppackage imported in flake
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      # hypr plugins
      # plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      #   hyprscrolling
      # ];
      #
      settings = {
        xwayland.force_zero_scaling = true;

        exec-once = [
          "hyprpaper"
          "waybar"
        ];

        env = [
          "XCURSOR_SIZE,12"
          "LIBVA_DRIVER_NAME,iHD" # Intel Arc hardware acceleration
          "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        ];

        monitor = ",1920x1080,auto,1";

        input = {
          kb_layout = "br";
          kb_model = "abnt2";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
          active_opacity = 0.95;
          inactive_opacity = 0.8;
          fullscreen_opacity = 0.95;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          force_split = 2;
          smart_split = false;
          default_split_ratio = 1.2;
          preserve_split = true;
        };

        plugin = {
          hyprscrolling = {
            column_width = 0.6;
            fullscreen_on_one_column = true;
            follow_focus = true;
          };
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, T, exec, ghostty"
          "$mainMod, Q, killactive"
          "$mainMod, M, exit"
          "$mainMod, B, exec, brave"
          "$mainMod, F, exec, nautilus"
          "$mainMod, P, exec, ~/.config/rofi/powermenu.sh"
          "$mainMod, V, togglefloating"
          "$mainMod, R, exec, rofi -show drun -show-icons"
          "$mainMod, S, exec, hyprshot -m region -o ~/screenshots"
          # "$mainMod, J, togglesplit"
          "$mainMod, L, fullscreen"
          # Workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          # Move to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, Control_L, movewindow"
          "SUPER, mouse:273, resizewindow"
          "SUPER, ALT_L, resizewindow"
        ];

        bindel =
          let
            brightnessctl = lib.getExe' pkgs.brightnessctl "brightnessctl";
          in
          [
            ",XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"
            ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
            ",xf86audioraisevolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
            ",xf86audiolowervolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
            ",xf86audiomute,         exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
            ",keyboard_brightness_up_shortcut,   exec, ${brightnessctl} -d *::kbd_backlight set +5%"
            ",keyboard_brightness_down_shortcut, exec, ${brightnessctl} -d *::kbd_backlight set -5%"
          ];
      };
    };

    # ── Waybar ───────────────────────────────────────────────────────────────
    programs.waybar = {
      enable = true;
      style = ./styles/waybar.css;
      systemd.enable = false;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = [
            "custom/logo"
            "hyprland/workspaces"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "backlight"
            "pulseaudio"
            "network"
            "battery"
          ];

          battery = {
            format = "{capacity}% {icon}";
            "format-icons" = {
              "charging" = [
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
              "default" = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
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
            format-icons = [
              ""
              ""
            ];
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
              default = [
                "󰖀"
                "󰕾"
                ""
              ];
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

    # ── Hypridle ─────────────────────────────────────────────────────────────
    # Screen dims after 4min, locks after 5min, suspends after 10min
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
        lock_cmd = hyprlock
        before_sleep_cmd = hyprlock
      }

      listener {
        timeout = 240
        on-timeout = brightnessctl set 4%
        on-resume = brightnessctl set 20%
      }

      listener {
        timeout = 300
        on-timeout = hyprlock
      }

      listener {
        timeout = 600
        on-timeout = systemctl suspend
      }
    '';
  };
}

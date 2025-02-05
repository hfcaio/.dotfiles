{ config, lib, ... }:
with lib;
let cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        xwayland = { force_zero_scaling = true; };

        exec-once = [ "waybar" "hyprpaper" ];

        env = [ "XCURSOR_SIZE,24" ];

        input = {
          kb_layout = "br";
          kb_variant = "";
          kb_model = "abnt2";
          kb_rules = "";
          kb_options = "";
          follow_mouse = 1;

          touchpad = { natural_scroll = true; };

          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          "col.shadow" = "rgba(1a1a1aee)";
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
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
          pseudotile = true;
          preserve_split = true;
        };

        master = { };

        gestures = { workspace_swipe = false; };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, T, exec, kitty"
          "$mainMod, Q, killactive, "
          "$mainMod, M, exit, "
          "$mainMod, B, exec, brave "
          "$mainMod, F, exec, thunar "
          "$mainMod, V, togglefloating, "
          "$mainMod, R, exec, rofi -show drun -show-icons "
          "$mainMod, S, exec, hyprshot -m region -o /home/caio/screenshot "
          "$mainMod, J, togglesplit, " # dwindle
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

          # Screen brightness level control
          ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
          ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          # Volume control through keyboard
          ", xf86audioraisevolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ", xf86audiolowervolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ", xf86audiomute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          # Keyboard brightness level control
          ", keyboard_brightness_up_shortcut, exec, brightnessctl -d *::kbd_backlight set +5%"
          ", keyboard_brightness_down_shortcut, exec, brightnessctl -d *::kbd_backlight set -5%"
        ];

      };
    };
  };
}

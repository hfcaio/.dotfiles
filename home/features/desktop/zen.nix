{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.zen;
  colors = config.lib.stylix.colors;
  profile = "nix-default";
in
{
  options.features.desktop.zen.enable = mkEnableOption "zen browser with stylix theming";

  config = mkIf cfg.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.file = {
      ".zen/profiles.ini".text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=${profile}
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      ".zen/${profile}/user.js".text = ''
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      '';

      ".zen/${profile}/chrome/userChrome.css".text = ''
        :root {
          --toolbar-bgcolor: #${colors.base01} !important;
          --toolbar-color: #${colors.base05} !important;
          --toolbarbutton-icon-fill: #${colors.base05} !important;
          --tab-selected-bgcolor: #${colors.base02} !important;
          --tab-selected-color: #${colors.base05} !important;
          --urlbar-box-bgcolor: #${colors.base00} !important;
          --urlbar-box-focus-bgcolor: #${colors.base00} !important;
          --urlbar-box-text-color: #${colors.base05} !important;
          --urlbar-popup-url-color: #${colors.base0D} !important;
          --focus-outline-color: #${colors.base0D} !important;
          --sidebar-background-color: #${colors.base00} !important;
          --lwt-accent-color: #${colors.base01} !important;
          --lwt-text-color: #${colors.base05} !important;
        }

        /* Zen sidebar */
        #sidebar-box,
        #navigator-toolbox {
          background-color: #${colors.base01} !important;
          border-color: #${colors.base02} !important;
        }

        /* URL bar */
        #urlbar-background {
          background-color: #${colors.base00} !important;
          border-color: #${colors.base03} !important;
        }

        .urlbar-input {
          color: #${colors.base05} !important;
        }

        /* Tab bar */
        .tabbrowser-tab[selected] .tab-background {
          background-color: #${colors.base02} !important;
        }

        .tab-label {
          color: #${colors.base05} !important;
        }
      '';
    };
  };
}

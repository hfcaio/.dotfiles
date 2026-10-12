{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.desktop.gcs;

  # QGroundControl is a Qt5 app, but the session-wide QML2_IMPORT_PATH also
  # lists the profile's lib/qt-6/qml (pulled in by Qt6 packages such as
  # quickshell). The Qt5 QML engine chokes on the Qt6 qmldir files
  # ("invalid version auto"), ApplicationWindow becomes unavailable and the
  # main window never shows up. The Qt5 wrapper already exports every qml dir
  # QGC needs via NIXPKGS_QT5_QML_IMPORT_PATH, so dropping QML2_IMPORT_PATH is
  # enough.
  qgroundcontrol = pkgs.symlinkJoin {
    name = "qgroundcontrol-${pkgs.qgroundcontrol.version}";
    paths = [ pkgs.qgroundcontrol ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/QGroundControl --unset QML2_IMPORT_PATH
    '';
    inherit (pkgs.qgroundcontrol) meta;
  };
in {
  options.features.desktop.gcs.enable = mkEnableOption "install QGroundcontrol";

  config = mkIf cfg.enable { home.packages = [ qgroundcontrol ]; };
}

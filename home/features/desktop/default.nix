{ pkgs, lib, ... }:
let
  dir = ./.;
  nixFiles = lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    (builtins.readDir dir);
  importPaths = map (name: dir + "/${name}") (lib.attrNames nixFiles);
in
{
  imports = importPaths;

  home.packages = with pkgs; [
    xhost
    xauth
  ];
  services.udiskie.enable = true;
}

{ pkgs, ... }: {
  # Define your custom packages here
  webots-fhs = pkgs.callPackage ./webots { };
  unitree_sdk2 = pkgs.callPackage ./unitree_sdk2 { };
  matlab = pkgs.callPackage ./matlab { };
  matlab-shell = pkgs.callPackage ./matlab/shell.nix { };
  claude-desktop = pkgs.callPackage ./claude-desktop { };
}

{ pkgs, ... }: {
  # Define your custom packages here
  webots-fhs = pkgs.callPackage ./webots { };
}

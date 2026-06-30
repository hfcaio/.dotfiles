{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.caio = {
    initialPassword = "1234";
    isNormalUser = true;
    description = "caio";
    extraGroups = [
      "wheel"
      "docker"
      "networkManager"
      "dialout"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };

  #enable stylix
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      stylix-config = config.stylix;
    };
    users.caio = import ../../../home/caio/${config.networking.hostName}.nix;
  };

}

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.caio = {
    initialHashedPassword = "$y$j9T$FFY6GHTYSbetDkQnmwKit1$L3topSaqGKdAa6DFH32hXxEUSNfeaacC5I/bxb47Pe8";
    isNormalUser = true;
    description = "caio";
    extraGroups = [
      "wheel"
      "docker"
      "networkManager"
			"dialout"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
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

{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.caio = {
    initialHashedPassword = "$y$j9T$FFY6GHTYSbetDkQnmwKit1$L3topSaqGKdAa6DFH32hXxEUSNfeaacC5I/bxb47Pe8";
    isNormalUser = true;
    description = "caio";
    extraGroups = [
        "wheel" 
        "docker" 
        "networkManager" 
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.caio =
    import ../../../home/caio/${config.networking.hostName}.nix;
}
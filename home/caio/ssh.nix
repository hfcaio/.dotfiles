{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "cluster" = {
        Hostname = "cluster.rnl.tecnico.ulisboa.pt";
        User = "ist1116311";
        IdentityFile = "~/.ssh/id_ed25519_tecnico";
        ForwardX11 = true;
        ForwardX11Trusted = true;
      };
      "deucalion" = {
        Hostname = "login.deucalion.macc.fccn.pt";
        User = "ist1116311";
        IdentityFile = "/home/caio/.ssh/id_ed25519_macc";
      };
      "lab2p4" = {
        Hostname = "lab2p4";
        User = "ist1116311";
        ProxyJump = "cluster";
        IdentityFile = "~/.ssh/id_ed25519_tecnico";
        ForwardX11 = true;
        ForwardX11Trusted = true;
      };
    };
  };
}

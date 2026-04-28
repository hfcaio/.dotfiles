{programs.ssh = {
  enable = true;
  matchBlocks = {
    "cluster" = {
      hostname = "cluster.rnl.tecnico.ulisboa.pt";
      user = "ist1116311";
      identityFile = "~/.ssh/id_ed25519_tecnico";
      forwardX11 = true;
      forwardX11Trusted = true;
    };
    "deucalion" = {
      hostname = "login.deucalion.macc.fccn.pt";
      user = "ist1116311";
      identityFile = "/home/caio/.ssh/id_ed25519_macc";
    };
    "lab2p4" = {
      hostname = "lab2p4";
      user = "ist1116311";
      proxyJump = "cluster";
      identityFile = "~/.ssh/id_ed25519_tecnico";
      forwardX11 = true;
      forwardX11Trusted = true;
    };
  };
};
}

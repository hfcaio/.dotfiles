{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      # O ghostty exporta TERM=xterm-ghostty, que nao existe na base de terminfo
      # de hosts mais antigos (a diana e Ubuntu 20.04) - e ai o shell remoto
      # perde cores e teclas. SetEnv resolve do lado do cliente.
      #
      # TERM e o unico caso em que SetEnv NAO precisa de AcceptEnv no servidor;
      # o man ssh_config di-lo explicitamente ("with the exception of the TERM
      # variable"). Logo funciona sem mexer em nenhum dos servidores.
      #
      # O ghostty ja faz isto com shell-integration-features=ssh-env, mas por
      # uma funcao de shell: so vale em zsh interativo e nao cobre scp, rsync,
      # sftp, git-over-ssh nem scripts. Aqui vale para tudo.
      "*" = {
        SetEnv = { TERM = "xterm-256color"; };
      };

      "hpcas" = {
        Hostname = "hpcas.inesc-id.pt";
        User = "caiofreitas";
      };
      "diana" = {
        Hostname = "diana.inesc-id.pt";
        User = "caiofreitas";
      };
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

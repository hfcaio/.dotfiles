# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  # Automount USB drives
  services.udisks2.enable = true;

  # Udev rules
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="2808", ATTR{idProduct}=="6652", MODE="0666" 

    # Intel Arc A350M (03:00.0, 8086:5694). O kernel reporta
    # "Display not present, disabling" e nada renderiza nela, mas o runtime PM
    # vem desligado (power/control=on) e a GPU fica presa em D0 a gastar
    # ~5-8 W. Com "auto" o i915 pode suspende-la para D3cold.
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x5694", ATTR{power/control}="auto"
  '';

  # ── Aceleracao grafica ────────────────────────────────────────────────────
  # hardware.graphics.enable ja vinha a true (de brinde com programs.hyprland),
  # mas extraPackages estava vazio: nao existia iHD_drv_video.so em lado nenhum,
  # apesar de LIBVA_DRIVER_NAME=iHD estar definido no hyprland.nix. O VA-API
  # falhava a inicializar e o video era descodificado em CPU.
  hardware.graphics.extraPackages = with pkgs; [
    # VA-API (Gen8+). Serve a iGPU Iris Xe e a Arc A350M.
    intel-media-driver

    # OpenCL. O .icd vai para etc/OpenCL/vendors/ e o ocl-icd do nixpkgs
    # procura justamente em /run/opengl-driver/etc/OpenCL/vendors.
    intel-compute-runtime

    # Level Zero (libze_intel_gpu.so). Fica num output separado do pacote
    # acima - sem esta linha so haveria OpenCL.
    intel-compute-runtime.drivers
  ];

  # ── Energia e termica ─────────────────────────────────────────────────────
  # Sem thermald, a curva de ventoinha deste i7-1360P (P-series) e agressiva.
  services.thermald.enable = true;

  # Estava comentado no hardware-configuration.nix; o kernel reportava
  # "Running old microcode" e listava old_microcode/vmscape nas bugs.
  hardware.cpu.intel.updateMicrocode = true;

  # ── Swap e hibernacao ─────────────────────────────────────────────────────
  # Nao existia swap nenhum (nem particao, nem ficheiro), por isso hibernar
  # era impossivel: /sys/power/resume estava a 0:0. Hibernar escreve a RAM
  # para swap em disco, logo o ficheiro tem de ser >= RAM (16 GB).
  swapDevices = [
    {
      device = "/swapfile";
      size = 18 * 1024; # MiB
    }
  ];

  # zram para o uso normal: comprimido na RAM, muito mais rapido que o disco.
  # Prioridade alta para ser usado primeiro e deixar o swapfile livre para a
  # hibernacao. (zram nao serve para hibernar - vive na propria RAM.)
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  # Nao ha resume=/resume_offset= aqui de proposito. Hibernar para um swapfile
  # costuma exigir um resume_offset fixo na cmdline, que so da para descobrir
  # com `filefrag` depois do ficheiro existir - e que fica silenciosamente
  # errado se o swapfile for recriado ou redimensionado.
  #
  # Com boot.initrd.systemd.enable (ja ativo) e boot EFI, o systemd trata disto:
  # o systemd-sleep calcula o offset na hora de hibernar e grava o par
  # dispositivo+offset na variavel EFI HibernateLocation; no arranque o
  # systemd-hibernate-resume-generator le-a e faz o resume. Recalculado sempre,
  # nunca desatualizado.
  #
  # Se algum dia isto precisar de voltar ao metodo antigo (boot BIOS, ou initrd
  # sem systemd), seria:
  #   boot.resumeDevice = "/dev/disk/by-partlabel/disk-nixos-root";
  #   boot.kernelParams = [ "resume_offset=<filefrag -v /swapfile>" ];

  # Suspende primeiro, hiberna 30 min depois se ninguem voltar.
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";

  # NetworkManager-wait-online bloqueava network-online.target -> docker ->
  # graphical.target, custando ~4 s no caminho critico do boot sem necessidade.
  systemd.services.NetworkManager-wait-online.enable = false;

  # services mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Enable mDNS for name resolution
  };

  # Display manager.
  services.displayManager.ly = {
    enable = true;
  };

  # Garante que o Ly usa a sessão Hyprland corretamente
  services.displayManager.defaultSession = "hyprland";

  # Keyring (Secret Service) para apps que guardam credenciais via libsecret —
  # Claude Desktop, Zen, Chromium etc. Sem isto o Electron mostra "Your sign-in
  # won't be saved on this device. Install and unlock a system keyring".
  #
  # `services.gnome.gnome-keyring.enable` registra o .service de D-Bus, então o
  # daemon é ativado sob demanda. O hook PAM no `ly` destranca o keyring com a
  # senha de login — sem ele, o keyring existe mas fica locked e o Electron
  # ainda falha. Em sessão nova (próximo login) o auto-unlock passa a funcionar.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  # Configura XDG para Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixOS"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.users.caio.extraGroups = [ "vboxusers" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gdb
    docker-compose
		unitree_sdk2
    usbutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh = {
  #  enable = true;
  #  settings.PermitRootLogin = "no";
  #  allowSFTP = true;
  #};

  # Enable microfone
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Tornar Mic1 o padrão para captura (input)
  environment.variables = {
    PULSE_SOURCE = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib  # libstdc++.so.6
    ];
  };

  # coredump
  # Antes: coredump desligado + core_pattern="core" fazia o Hyprland e o
  # hyprpaper despejarem ficheiros core.<pid> de 100-165 MB no $HOME a cada
  # crash. Com o systemd-coredump vao para /var/lib/systemd/coredump com
  # rotacao e compressao, e inspecionam-se com `coredumpctl`.
  systemd.coredump.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # Static IP for USB Ethernet (robot connection at 192.168.123.x)
  networking.networkmanager.unmanaged = [ "enp0s13f0u3" ];
  networking.interfaces.enp0s13f0u3 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.123.99";
        prefixLength = 24;
      }
    ];
  };

  networking.firewall = {
    enable = false;
    trustedInterfaces = [ "docker0" ];
    allowedUDPPortRanges = [
      {
        from = 7400;
        to = 7500;
      }
      {
        from = 13100;
        to = 13200;
      }
    ];
  };

  #enable finger print sensor
  # services.fprintd = {
  #   enable = true;
  #   package = pkgs.fprintd.override {
  #     libfprint = pkgs.libfprint-focaltech-6652;
  #   };
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}

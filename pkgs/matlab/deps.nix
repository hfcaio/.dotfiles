# Dependências de runtime do MATLAB dentro do FHS env.
#
# Baseada na lista do nix-matlab (https://gitlab.com/doronbehar/nix-matlab), que por sua vez
# deriva das imagens oficiais da MathWorks
# (https://github.com/mathworks-ref-arch/container-images).
#
# Os nomes seguem os atributos novos do nixpkgs (libx11, libice, ...); o conjunto `xorg.*`
# está deprecado e emite warning na avaliação.
pkgs:

(with pkgs; [
  cacert
  alsa-lib # libasound2
  atk
  glib
  glibc
  cairo
  cups
  dbus
  fontconfig
  freetype
  gdk-pixbuf
  gst_all_1.gstreamer
  gst_all_1.gst-plugins-base
  gtk3
  nspr
  nss
  pam
  linux-pam
  pango
  python3
  libselinux
  libsndfile
  glibcLocales
  procps
  unzip
  zlib
  zstd
  krb5
  openssl
  libxml2

  # Necessários desde a 2021b
  gtk2
  at-spi2-atk
  at-spi2-core
  libdrm

  # Simulink
  mesa
  libGL

  gcc
  gfortran

  # Específicos de NixOS
  udev
  jre
  ncurses # CLI

  # Sem isto o teclado pode não funcionar no Simulink
  libxkbcommon
  xkeyboardconfig

  # Necessário desde a 2022a
  libglvnd

  # Necessários desde a 2022b
  libuuid
  libxcrypt
  libxcrypt-legacy

  # Necessário desde a 2024
  libgbm
]) ++ (with pkgs; [
  # X11
  libsm
  libx11
  libxcb
  libxcomposite
  libxcursor
  libxdamage
  libxext
  libxfixes
  libxft
  libxi
  libxinerama
  libxrandr
  libxrender
  libxt
  libxtst
  libxxf86vm

  # Necessário desde a 2025
  libice
])

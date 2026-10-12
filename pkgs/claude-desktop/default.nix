# Claude Desktop (Anthropic) — empacota o .deb oficial do Linux.
#
# A Anthropic libera o Claude Desktop para Linux como .deb (Electron). Para rodar no NixOS,
# extraímos o conteúdo e deixamos o autoPatchelfHook resolver as libs dinâmicas que o binário
# espera num FHS. Simples porque o Electron já traz Chromium estático e só precisa das libs
# do sistema (gtk, nss, xorg, etc).
#
# O .deb (172 MB) NÃO vive dentro deste repo porque: o flake nix só enxerga arquivos tracked
# pelo git, e um blob desse tamanho não deve ir pro histórico. E o pure-eval do flake também
# bloqueia caminhos absolutos diretamente, então usamos requireFile: o .deb é inserido no
# /nix/store uma vez (via nix-store --add-fixed) e aqui é referenciado por hash, 100% puro.
#
# Setup inicial (uma vez por máquina) — baixe o .deb em https://claude.ai/download e rode:
#   nix-store --add-fixed sha256 /caminho/para/claude-desktop_amd64.deb
#
# Depois disso o rebuild funciona offline sem precisar do caminho original. Quando a Anthropic
# publicar uma versão nova, baixe → nix-store --add-fixed → atualize sha256+version aqui.
{
  lib,
  stdenv,
  requireFile,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libcap_ng,
  libdrm,
  libgbm,
  libnotify,
  libseccomp,
  libsecret,
  libuuid,
  libxkbcommon,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbfile,
  libxrandr,
  libxtst,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  xdg-utils,
}:

stdenv.mkDerivation {
  pname = "claude-desktop";
  version = "2.19675.1";

  src = requireFile {
    name = "claude-desktop_amd64.deb";
    url = "https://claude.ai/download";
    sha256 = "1z06n48igl09l21gr20cakq3n1al6qrwbx9m1pkgcw7jrkp2g8cv";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  # Libs que o binário (ldd) pede como "not found" num FHS cru.
  buildInputs = [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libcap_ng
    libdrm
    libgbm
    libnotify
    libseccomp
    libsecret
    libuuid
    libxkbcommon
    nspr
    nss
    pango
    pipewire
    stdenv.cc.cc.lib
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbfile
    libxrandr
    libxtst
  ];

  # libudev.so.1 é dlopen'd em runtime pelo Chromium — autoPatchelfHook não a cola, então
  # ela entra via rpath aqui.
  runtimeDependencies = [ (lib.getLib systemd) ];

  dontConfigure = true;
  dontBuild = true;

  # dpkg-deb -x chama tar que tenta preservar o setuid do chrome-sandbox e o builder do Nix
  # não permite. Extraio em dois passos (ar → tar com --no-same-permissions) para derrubar o
  # bit setuid, que de qualquer modo não roda da /nix/store.
  unpackPhase = ''
    runHook preUnpack
    ar x $src
    mkdir -p pkg
    tar --no-same-permissions --no-same-owner -xf data.tar.* -C pkg
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r pkg/usr/lib $out/lib
    cp -r pkg/usr/share $out/share

    # Symlink de usr/bin/claude-desktop aponta para ../lib/claude-desktop/claude-desktop — refaço
    # como wrapper para injetar PATH (xdg-open) e deixar o wrapGAppsHook3 colar GTK/GSettings.
    mkdir -p $out/bin
    makeWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}

    # O chrome-sandbox precisa de setuid root (ou de user namespaces habilitado). Em NixOS
    # tipicamente usa-se security.chromiumSuidSandbox; se não estiver, o electron cai para o
    # sandbox de user namespace. Mantemos o binário mas não tentamos chmod aqui — a store é RO.
    # Se o app reclamar "SUID sandbox helper binary was found, but is not configured correctly",
    # ou habilite security.chromiumSuidSandbox.enable no system, ou rode com --no-sandbox.

    # O .desktop (com.anthropic.Claude.desktop) vem com Exec=claude-desktop (relativo). Reescrevo
    # para o wrapper absoluto para o launcher do GNOME/Rofi/etc encontrar sem depender do PATH.
    desktop_file=$out/share/applications/com.anthropic.Claude.desktop
    sed -i "s|^Exec=claude-desktop|Exec=$out/bin/claude-desktop|g" "$desktop_file"

    runHook postInstall
  '';

  meta = {
    description = "Desktop application for Claude.ai";
    homepage = "https://claude.ai";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "claude-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

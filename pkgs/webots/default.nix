{ pkgs ? import <nixpkgs> { } }:

let
  webots-unwrapped = pkgs.stdenv.mkDerivation rec {
    pname = "webots";
    version = "R2023b";

    src = pkgs.fetchurl {
      url =
        "https://github.com/cyberbotics/webots/releases/download/${version}/webots-${version}-x86-64.tar.bz2";
      sha256 = "sha256-Cs36IS7DOoViRpU45jIfIzP+WV6AKRZ2wMzws7PsSVM=";
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
            mkdir -p $out/webots
            cp -r * $out/webots/
            
            # Criar um wrapper script
            mkdir -p $out/bin
            cat > $out/bin/webots << EOF
      #!/bin/sh
      exec $out/webots/webots "\$@"
      EOF
            chmod +x $out/bin/webots
            chmod +x $out/webots/webots $out/webots/bin/webots-bin 2>/dev/null || true
    '';

    meta = with pkgs.lib; {
      description = "Webots robot simulator (prebuilt)";
      homepage = "https://github.com/cyberbotics/webots";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in pkgs.buildFHSEnv {
  name = "webots";

  targetPkgs = pkgs:
    (with pkgs; [
      webots-unwrapped

      # Compiladores e ferramentas básicas
      gcc
      gnumake

      # Codec de vídeo
      ffmpeg-full

      # Mesa/OpenGL
      libGL
      libGLU
      mesa

      # EGL
      libglvnd

      # Qt5 e suas dependências X11
      qt5.qtbase
      qt5.qttools
      qt5.qtdeclarative
      libxkbcommon

      # Bibliotecas XCB
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xcbutilcursor

      # X11 libraries
      xorg.libX11
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXext
      xorg.libXrender
      xorg.libXrandr
      xorg.libXi
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXft

      # NSS
      nss
      nspr

      # Standard C/C++ libraries
      glibc
      stdenv.cc.cc.lib
      gcc-unwrapped.lib

      # Compression libraries
      zlib
      bzip2
      xz

      # Kerberos
      krb5

      # Expat (XML parser)
      expat

      # UUID - A BIBLIOTECA QUE ESTAVA FALTANDO AGORA!
      util-linux

      # SSH e crypto
      libssh
      openssl

      # Image libraries
      libpng
      libjpeg
      libtiff

      # Fonts e texto
      freetype
      fontconfig

      # Audio
      alsa-lib
      libpulseaudio

      # System libraries
      dbus
      glib
      systemd

      # Networking
      curl

      # XML
      libxml2

      # Boost
      boost

      # Readline
      readline

      # Python
      python3
      python3Packages.pip

      # Outras
      pciutils
      udev

      # Virtual framebuffer
      xorg.xorgserver
      xvfb-run
    ]);

  runScript = "${webots-unwrapped}/bin/webots";

  profile = ''
    export WEBOTS_HOME=${webots-unwrapped}/webots
    export LD_LIBRARY_PATH=${webots-unwrapped}/webots/lib:$LD_LIBRARY_PATH
  '';
}

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gcc,
  gnumake,
  yaml-cpp,
  eigen,
  boost,
  spdlog,
  fmt,
}:

stdenv.mkDerivation rec {
  pname = "unitree_sdk2";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "unitreerobotics";
    repo = pname;
    rev = "main";
    sha256 = "sha256-oJy3GCVYzPeWBX61dJtNz1um3S0PJe11yP9p/S1AwNQ=";
  };

  buildInputs = [
    cmake
    pkg-config
    gcc
    gnumake
    yaml-cpp
    eigen
    boost
    spdlog
    fmt
  ];

  meta = with lib; {
    description = "unitree sdk2";
    homepage = "https://github.com/github-owner/${pname}";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

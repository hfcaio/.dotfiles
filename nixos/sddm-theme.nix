{ pkgs }:

pkgs.stdenv.mkDerivation {
	name = "sddm-theme";
	src = pkgs.fetchFromGitHub {
		owner = "JaKooLit";
		repo = "simple-sddm";
		rev = "6888cccf8ec18e017b4480c153ba086d701eab02";
		sha256 = "18lmcrcqkw4iyx34q0gr03r9kdimf0nijqw45mp17w171k09paqc";
	};
	installPhase = ''
		mkdir -p $out
		cp -R ./* $out/
	'';
}

{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # opencv
    # opencv4 = prev.opencv4.override { enableGtk3 = true; };

    # libfprint-focaltech-6652 = prev.libfprint.overrideAttrs (old: {
    #   src = prev.fetchgit {
    #     url = "https://gitlab.freedesktop.org/libfprint/libfprint.git";
    #     rev = "refs/merge-requests/554/head";
    #     hash = prev.lib.fakeHash; # roda uma vez, pega o hash certo do erro
    #   };
    #
    #   # sem patches= nenhum agora — a árvore já vem com a mudança do MR aplicada.
    #   # só falta ensinar o driver a reconhecer seu PID também.
    #   # (rode `grep -rn "0x6553" .` na árvore extraída antes, pra confirmar
    #   # o arquivo/linha certos e não confiar cegamente no sed)
    #   postPatch = (old.postPatch or "") + ''
    #     grep -rl '0x6553' libfprint/drivers | xargs -r sed -i \
    #       '/0x6553/{p; s/6553/6652/}'
    #   '';
    # });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}

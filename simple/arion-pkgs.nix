# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  #overlays = [ (import /home/auguste/dev/nur-kapack/overlays/overlay-dev.nix) ];
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        #kapack = import /home/auguste/dev/nur-kapack {inherit pkgs;};
        kapack = import (pkgs.fetchgit {
          url = https://github.com/oar-team/nur-kapack;
          rev = "9915c81e7e50027e32a5cb01bd991d9b65980e47";
          sha256 = "1hsnx5vmy2xz0dqmn71rcnxd40fyz9rvy1svmfqxd55cy4169ra7";
        }) {inherit pkgs;};
      };
    };
  };
}

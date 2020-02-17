# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        #kapack = import /home/auguste/dev/nur-kapack {};
        kapack = import (pkgs.fetchgit {
          url = https://github.com/oar-team/nur-kapack;
          rev = "bfb4dbd537e386a28158f3e71427873f651a6bc9";
          sha256 = "1b5m0lhij4b8bwy2mg8qdw0djn72gcq5g4wp7imb815df9lmd2h9";
        }) {};
      };
    };
  };
}

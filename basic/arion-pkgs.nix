# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        kapack = import /home/auguste/dev/nur-kapack {};
        # kapack = import (pkgs.fetchgit {
        #   url = https://github.com/oar-team/nur-kapack;
        #   rev = "6a488adc04f98ac931e6277095b1a22a40f6839a";
        #   sha256 = "0al83rgj2197ank1vy2799bc3wgpbjzcscdr5021frg5x479s0qj";
        #   }) {};
      };
    };
  };
}

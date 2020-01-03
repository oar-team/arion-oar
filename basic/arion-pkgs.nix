# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        kapack = import (pkgs.fetchgit {
          url = https://github.com/oar-team/nur-kapack;
          rev = "2e37e608195e7674890d90d575170b121387507";
          sha256 = "06z2g97mkh896axir4lhinqzbmb5s8gz1miamrgk5r2731mya5l3";
        }) {};
      };
    };
  };
}

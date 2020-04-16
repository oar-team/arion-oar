pkgs:
let nur_kapack =
  import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
    repoOverrides = {
      #kapack = import /home/auguste/dev/nur-kapack {inherit pkgs;};
      kapack = import (pkgs.fetchgit {
        url = https://github.com/oar-team/nur-kapack;
        rev = "5e08d37eb513c109b72fe421aac6402d2ed4ef81";
        sha256 = "0hfj6r2hwmf2n48b2m9irm1dh948azfpkykkm13bbl7r8wz30z60";
      }) {inherit pkgs;};
    };
  };
in 
nur_kapack

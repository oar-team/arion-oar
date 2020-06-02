pkgs:
let nur_kapack =
  import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
    repoOverrides = {
      #kapack = import /home/auguste/dev/nur-kapack {inherit pkgs;};
      kapack = import (pkgs.fetchgit {
        url = https://github.com/oar-team/nur-kapack;
        rev = "7ba3dafa45516b1466176755ccf7a47effd619eb";
        sha256 = "0xkhwi3xapdkpzz7viarxnmqxqdyc90yhw09qh0lgpf3i8wc8akm";
      }) {inherit pkgs;};
    };
  };
in 
nur_kapack

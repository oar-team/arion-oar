# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") {
# import <nixpkgs> {
  overlays = (import ../common/overlays-kapack-src-dir1.nix);
  config.packageOverrides = pkgs: {
    nur = import ../common/nur-kapack.nix pkgs;
  };
}

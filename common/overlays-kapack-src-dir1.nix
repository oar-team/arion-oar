#
# overlays = import path/overlays-kapack-src-dir1.nix
#
# example to override source directory for nur.repos.kapack.oar through environnement variable
# export KAPACK_SRCDIR=oar:$HOME/dev/oar 
let OverlayKapackSrcDir = if (builtins.getEnv "KAPACK_SRCDIR" != "") then
let overlaySrcDir = self: super:     
    let
      sep_pkgDir = super.lib.splitString ":" (builtins.getEnv "KAPACK_SRCDIR");
in
{ nur.repos.kapack = super.nur.repos.kapack // {
  ${(builtins.head sep_pkgDir)}=super.nur.repos.kapack.${(builtins.head sep_pkgDir)}.overrideAttrs (old: rec {
    src=/. + (builtins.elemAt sep_pkgDir 1 );});
};};
  in [ overlaySrcDir ]
else [ ];

in 
  OverlayKapackSrcDir

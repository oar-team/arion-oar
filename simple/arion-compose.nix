{ pkgs, lib,... }:
let
  
inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

common = {
  service.volumes = [ "${builtins.getEnv "PWD"}:/srv" ];
  nixos.useSystemd = true;
  nixos.runWrappersUnsafe = true;
  nixos.configuration = {
    networking.firewall.enable = false;
    boot.tmpOnTmpfs = true;

    users.users.user1 = {isNormalUser = true;};

    #environment.systemPackages = with pkgs; [ nur.repos.kapack.oar ];
    #environment.systemPackages = with pkgs;
    #[ telnet pkgs.nur.repos.kapack.oar (python37.withPackages(ps: with ps;
    #  [ pip psycopg2 clustershell pyzmq click pyinotify sortedcontainers pkgs.nur.repos.kapack.oar])) ];

    # oar common stuffs
    imports = lib.attrValues pkgs.nur.repos.kapack.modules;
   
    #Set oar user's keys
    environment.etc."privkey.snakeoil" = { mode = "0600"; source = snakeOilPrivateKey; };
    environment.etc."pubkey.snakeoil" = { mode = "0600"; source = snakeOilPublicKey; };
    services.oar.privateKeyFile = "/etc/privkey.snakeoil";
    services.oar.publicKeyFile = "/etc/pubkey.snakeoil";
  };
 
};

addCommon = x: lib.recursiveUpdate x common;

in

{
  
  services.server = addCommon {
    service.hostname="server";

    nixos.configuration = {
      environment.etc."oarapi-users" = {
        mode = "0644";
        text = "user1:$apr1$EWduaWzM$ZsqQ7ZL9NUh4rHpkj3D5B/";
      };

      environment.systemPackages = with pkgs;
      [ telnet pkgs.nur.repos.kapack.oar (python37.withPackages(ps: with ps;
        [ pip psycopg2 clustershell pyzmq click pyinotify sortedcontainers pkgs.nur.repos.kapack.oar])) ];
      
      services.oar.server.enable = true;
      services.oar.dbserver.enable = true;
      services.oar.web.enable = true;
      #services.openssh.enable = true;
    };
    
    service.ports = [
      "8000:80" # host:container
    ];
    
  };

  services.node1 = addCommon {
    service.hostname="node1";
    nixos.configuration = {
      services.oar.node.enable = true;
      #services.openssh.enable = true;
    };
  };
}

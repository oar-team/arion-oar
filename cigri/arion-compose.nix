{ pkgs, lib,... }:
let

common = {
  
  service.volumes = [ "${builtins.getEnv "PWD"}:/srv" ];
  service.useHostStore = true;
  
  nixos.useSystemd = true;
  nixos.runWrappersUnsafe = true;
  nixos.configuration = {
    networking.firewall.enable = false;
    boot.tmpOnTmpfs = true;
    
    environment.systemPackages = with pkgs; [ ruby ];
    imports = lib.attrValues pkgs.nur.repos.kapack.modules;

    services.cigri = {
      database = {
        host = "cigri";
        passwordFile = "/srv/cigri-dbpassword";
      };
      server = {
        host = "cigri";
        logfile = "/tmp/cigri.log";
      };
    };
  };
 
};

addCommon = x: lib.recursiveUpdate x common;

in

{  
  services.cigri = addCommon {
    service.hostname="cigri";
    nixos.configuration = {
      services.cigri.dbserver.enable = true;
      services.cigri.client.enable = true;
      services.cigri.server.enable = true;
    };
  };
}

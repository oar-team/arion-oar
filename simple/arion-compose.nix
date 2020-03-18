{ pkgs, lib,... }:
let

inherit (import ../common/ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

common = {
  
  service.volumes = [ "${builtins.getEnv "PWD"}/..:/srv" ];
  service.useHostStore = true;

  nixos.useSystemd = true;
  nixos.runWrappersUnsafe = true;
  nixos.configuration = {
    networking.firewall.enable = false;
    boot.tmpOnTmpfs = true;

    users.users.user1 = {isNormalUser = true;};
    users.users.user2 = {isNormalUser = true;};
    
    #environment.systemPackages = with pkgs; [ nur.repos.kapack.oar ];
    environment.systemPackages = with pkgs;
    [ curl telnet pkgs.nur.repos.kapack.oar (python37.withPackages(ps: with ps;
      [ pip psycopg2 clustershell pyzmq click pyinotify sortedcontainers pkgs.nur.repos.kapack.oar])) ];

    # oar common stuffs
    imports = lib.attrValues pkgs.nur.repos.kapack.modules;
    
    # oar user's key files
    environment.etc."privkey.snakeoil" = { mode = "0600"; source = snakeOilPrivateKey; };
    environment.etc."pubkey.snakeoil" = { mode = "0600"; source = snakeOilPublicKey; };

    services.oar = {
      # oar db passwords
      database = {
        host = "server";
        passwordFile = "/srv/common/oar-dbpassword";
      };
      server.host = "server";
      privateKeyFile = "/etc/privkey.snakeoil";
      publicKeyFile = "/etc/pubkey.snakeoil";
      extraConfig = {
        LOG_LEVEL="3";
      };
    };  
  };
 
};

addCommon = x: lib.recursiveUpdate x common;

in

{

  services.frontend = addCommon {
    service.hostname="frontend";
    nixos.configuration = {
      services.oar.client.enable = true;
    };    
  };

  services.server = addCommon {
    service.hostname="server";

    nixos.configuration = {
      environment.etc."oar/api-users" = {
        mode = "0644";
        text = ''
          user1:$apr1$yWaXLHPA$CeVYWXBqpPdN78e5FvbY3/
          user2:$apr1$qMikYseG$VL8nyeSSmxXNe3YDOiCwr1
        '';
      };

      # All in one container but oar-node
      services.oar.server.enable = true;
      services.oar.dbserver.enable = true;
      services.oar.web.enable = true;
      services.oar.web.monika.enable = true;
      services.oar.web.drawgantt.enable = true;
    };
    
    service.capabilities = { SYS_ADMIN = true; }; # for phpfpm need to drawgantt
    service.ports = [ "8000:80"]; # host:container

  };

  services.node1 = addCommon {
    service.hostname="node1";
    nixos.configuration = {
      services.oar.node = {
        enable = true;
        register = {
          enable = true;
          extraCommand = "/srv/common/prepare_oar_cgroup.sh init";
        };
      };
      #services.openssh.enable = true;
    };
  };
  
  services.node2 = addCommon {
    service.hostname="node2";
    nixos.configuration = {
      services.oar.node = {
        enable = true;
        register = {
          enable = true;
          extraCommand = "/srv/common/prepare_oar_cgroup.sh init";
        };
      };
      #services.openssh.enable = true;
    };
  };
}

{ pkgs, lib,... }:
let

  inherit (import ./ssh-keys.nix pkgs)
  snakeOilPrivateKey snakeOilPublicKey;

in

{
  
  services.server = { pkgs, ... }: {
    nixos.useSystemd = true;
    nixos.runWrappersUnsafe = true;
    nixos.configuration = {
      networking.firewall.enable = false; # TODO to refine
      
      environment.etc."oarapi-users" = { mode = "0644"; text = "auguste:$apr1$EWduaWzM$ZsqQ7ZL9NUh4rHpkj3D5B/"; };
      
      imports = lib.attrValues pkgs.nur.repos.kapack.modules;
      boot.tmpOnTmpfs = true;

      #environment.systemPackages = with pkgs; [ nur.repos.kapack.oar ];
      environment.systemPackages = with pkgs; [ telnet pkgs.nur.repos.kapack.oar (python37.withPackages(ps: with ps; [ pip psycopg2 clustershell pyzmq click pyinotify sortedcontainers pkgs.nur.repos.kapack.oar])) ];
      services.oar.server.enable = true;
      services.oar.dbserver.enable = true;

      services.oar.web.enable = true;
      
      #Set oar user's keys
      environment.etc."privkey.snakeoil" = { mode = "0600"; source = snakeOilPrivateKey; };
      environment.etc."pubkey.snakeoil" = { mode = "0600"; source = snakeOilPublicKey; };
      services.oar.privateKeyFile = "/etc/privkey.snakeoil";
      services.oar.publicKeyFile = "/etc/pubkey.snakeoil";
      services.openssh.enable = true;
      users.extraUsers.user1 = {uid = 1001;};
      users.extraUsers.auguste = {
        isNormalUser = true;
        uid = 1000;
        description = "Olivier Richard";
        home = "/home/auguste";
        password = "auguste";
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwypP8Pm6Utbs12CiZFGQJEsaJahJ4GAxkcjZoeDTWR7JRoaswXVg6J+re6t0cJUkcAIozRDTNxoplLkb+uazWZve+qdRDQrP+hOOFoFwkGrej3XV1nLDCcjmXDbeWE1wa8h9bGhXyAO6+WSSSsMmd/8tfl71inqZsFtJtTxse9TMtJ3UBnGTw28/HOjez6lAtOJvmFeVJ3ExCWE8gnDbDWe1lJe5ytVCMp1C11vrkMD3vgpwG3EYAZE1ibPUEWtwjSg/ZjXBzdcj3u2PTw+kXfsVKUube3xsXyFKnUk7PhSODasJB0AVl3f5teYbW2L7TREqtbbQmsHvo30+q6wSdQ== auguste@munsee" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBChdA2BmwcG49OrQN33f/sj+OHL5sJhwVl2Qim0vkUJQCry1zFpKTa9ZcDMiWaEhoAR6FGoaGI04ff7CS+1yybQ= sakeoil"];
      };
      
    };
    service.useHostStore = true;
    service.hostname="server";
    service.volumes = [ "${builtins.getEnv "PWD"}:/srv" ];
    service.ports = [
      "8000:80" # host:container
    ];
    
  };

  services.node1 = { pkgs, ... }: {
    service.useHostStore = true;
    service.hostname="node1";
    service.volumes = [ "${builtins.getEnv "PWD"}:/srv" ];
    nixos.useSystemd = true;
    nixos.runWrappersUnsafe = true;
    nixos.configuration = {
      networking.firewall.enable = false;
      imports = lib.attrValues pkgs.nur.repos.kapack.modules;
      boot.tmpOnTmpfs = true;
      services.oar.node.enable = true;
      services.openssh.enable = true;

      #Set oar user's keys
      environment.etc."privkey.snakeoil" = { mode = "0600"; source = snakeOilPrivateKey; };
      environment.etc."pubkey.snakeoil" = { mode = "0600"; source = snakeOilPublicKey; };
      services.oar.privateKeyFile = "/etc/privkey.snakeoil";
      services.oar.publicKeyFile = "/etc/pubkey.snakeoil";
      
      users.users.root.openssh.authorizedKeys.keys = ["ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBChdA2BmwcG49OrQN33f/sj+OHL5sJhwVl2Qim0vkUJQCry1zFpKTa9ZcDMiWaEhoAR6FGoaGI04ff7CS+1yybQ= sakeoil"];


      users.extraUsers.user1 = {uid = 1001;};
      
      users.extraUsers.auguste = {
        isNormalUser = true;
        uid = 1000;
        description = "Olivier Richard";
        home = "/home/auguste";
        password = "auguste";
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwypP8Pm6Utbs12CiZFGQJEsaJahJ4GAxkcjZoeDTWR7JRoaswXVg6J+re6t0cJUkcAIozRDTNxoplLkb+uazWZve+qdRDQrP+hOOFoFwkGrej3XV1nLDCcjmXDbeWE1wa8h9bGhXyAO6+WSSSsMmd/8tfl71inqZsFtJtTxse9TMtJ3UBnGTw28/HOjez6lAtOJvmFeVJ3ExCWE8gnDbDWe1lJe5ytVCMp1C11vrkMD3vgpwG3EYAZE1ibPUEWtwjSg/ZjXBzdcj3u2PTw+kXfsVKUube3xsXyFKnUk7PhSODasJB0AVl3f5teYbW2L7TREqtbbQmsHvo30+q6wSdQ== auguste@munsee" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBChdA2BmwcG49OrQN33f/sj+OHL5sJhwVl2Qim0vkUJQCry1zFpKTa9ZcDMiWaEhoAR6FGoaGI04ff7CS+1yybQ= sakeoil"];
      };
      
    };
    
  };

}

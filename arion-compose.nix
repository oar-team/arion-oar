{ pkgs, lib,... }:
let
   #imports = [pkgs.nur.repos.augu5te.modules];
  slurmconfig = {
  controlMachine = "control";
    nodeName = [ "node[1-10] NodeHostName=node NodeAddr=node CPUs=1 State=UNKNOWN" ];
    partitionName = [ "debug Nodes=node[1-10] Default=YES MaxTime=INFINITE State=UP" ];
};

in

{
  
  services.server = { pkgs, ... }: {
    nixos.useSystemd = true;
    nixos.configuration = {
      networking.firewall.enable = false; # TODO to refine
      
      imports = lib.attrValues pkgs.nur.repos.augu5te.modules;
      boot.tmpOnTmpfs = true;
      
      #environment.systemPackages = with pkgs; [ nur.repos.augu5te.oar ];
      #programs.lsd.enable = true;
      #programs.oar.enable = true;
      
      services.oar.server.enable = true;
      services.oar.dbserver.enable = true;
            
      users.extraUsers.auguste = {
        isNormalUser = true;
        uid = 1000;
        description = "Olivier Richard";
        home = "/home/auguste";
        password = "auguste";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwypP8Pm6Utbs12CiZFGQJEsaJahJ4GAxkcjZoeDTWR7JRoaswXVg6J+re6t0cJUkcAIozRDTNxoplLkb+uazWZve+qdRDQrP+hOOFoFwkGrej3XV1nLDCcjmXDbeWE1wa8h9bGhXyAO6+WSSSsMmd/8tfl71inqZsFtJtTxse9TMtJ3UBnGTw28/HOjez6lAtOJvmFeVJ3ExCWE8gnDbDWe1lJe5ytVCMp1C11vrkMD3vgpwG3EYAZE1ibPUEWtwjSg/ZjXBzdcj3u2PTw+kXfsVKUube3xsXyFKnUk7PhSODasJB0AVl3f5teYbW2L7TREqtbbQmsHvo30+q6wSdQ== auguste@munsee"];
      };
      
    };
    service.useHostStore = true;
    service.hostname="server";
  };

  services.node = { pkgs, ... }: {
    service.useHostStore = true;
    service.hostname="node";
    nixos.useSystemd = true;
    nixos.configuration = {
      networking.firewall.enable = false;
      imports = lib.attrValues pkgs.nur.repos.augu5te.modules;
      boot.tmpOnTmpfs = true;
      services.oar.node.enable = true;
    }; 
  };

}

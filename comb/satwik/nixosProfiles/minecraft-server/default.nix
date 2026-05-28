{ inputs, cell }:
let
  pkgs = cell.nixpkgs.pkgs;
in
{

  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  services.minecraft-servers = {
    enable = true;
    openFirewall = true;
    eula = true;
    servers = {
      "rocket-riders" = {
        package = pkgs.fabricServers.fabric-1_20_4;
        enable = true;
        autoStart = true;
        serverProperties = {
          server-port = 25565;
          white-list = true;
          motd = "PB Rocket Riders";
          openFirewall = true;
          difficulty = 3;
        };
      };

      "pb" = {
        package = pkgs.fabricServers.fabric-1_21_10;
        enable = true;
        autoStart = true;
        serverProperties = {
          server-port = 25566;
          white-list = true;
          motd = "PB Survival";
          openFirewall = true;
          difficulty = 2;
        };
      };

      "sixcandles" = {
        package = pkgs.fabricServers.fabric-1_21_6;
        enable = true;
        autoStart = true;
        serverProperties = {
          server-port = 25567;
          white-list = true;
          motd = "Six Candles Survival";
          openFirewall = true;
          difficulty = 3;
        };
      };
      "love" = { 
        package = pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };
        enable = true;
        autoStart = true;
        serverProperties = {
          server-port = 25568;
          white-list = true;
          motd = "LOVE Survival";
          openFirewall = true;
          difficulty = 3;
          level-seed="-654365436230757766";
        };
      };

      "creativelove" = { 
        package = pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };
        enable = true;
        autoStart = true;
        serverProperties = {
          server-port = 25569;
          white-list = true;
          motd = "LOVE Creative";
          openFirewall = true;
          difficulty = 3;
          level-seed="-654365436230757766";
          level-type="minecraft\:flat";
        };
      };


    };
  };
}

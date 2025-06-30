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
        package = pkgs.fabricServers.fabric-1_21_6;
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
    };
  };
}

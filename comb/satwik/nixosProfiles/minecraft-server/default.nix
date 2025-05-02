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
          motd = "PB Rocket Riders";
          openFirewall = true;
        };
      };
    };
  };
}

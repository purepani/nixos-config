_: 
{ config, pkgs, lib, ... }:


let
  cfg = config.services.prowlarr_custom;

in
{
  options = {
    services.prowlarr_custom = {
      enable = lib.mkEnableOption (lib.mdDoc "Prowlarr, an indexer manager/proxy for Torrent trackers and Usenet indexers");

      package = lib.mkPackageOption pkgs "prowlarr" { };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/prowlarr";
        description = lib.mdDoc "The directory where Prowlarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Prowlarr web interface.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.prowlarr_custom = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
	DynamicUser = true;
        StateDirectory = "prowlarr";
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };
  };
}

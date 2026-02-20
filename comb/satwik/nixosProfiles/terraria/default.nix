{ inputs, cell }:

let
  terraria = { config, lib, ... }:
    let
      cfg = config.services.terraria;
      pkgs = cell.nixpkgs.pkgs;
      lib = pkgs.lib;
      worldSizeMap = {
        small = 1;
        medium = 2;
        large = 3;
      };
      terraria_config = { };

      mkConfig = options:
        builtins.toFile
          "terraria.cfg"
          (lib.concatStrings
            (lib.mapAttrsToList
              (name: value: "${name}=${toString value}\n")
              options));
      terraria-cfg = mkConfig terraria_config;
      sock = "${lib.escapeShellArg cfg.runDir}/terraria.sock";
      tmuxCmd = "${lib.getExe pkgs.tmux} -S ${sock}";
      valFlag =
        name: val:
        lib.optionalString (val != null) "-${name} \"${lib.escape [ "\\" "\"" ] (toString val)}\"";
      boolFlag = name: val: lib.optionalString val "-${name}";
      worlds = {
        pb = {
          config = mkConfig {
            npcstream = 0;
            worldname = "Expert Butter";
            priority = 1;
          };
        };
      };

      flags = [
        (valFlag "port" cfg.port)
        (valFlag "maxPlayers" cfg.maxPlayers)
        (valFlag "password" cfg.password)
        (valFlag "motd" cfg.messageOfTheDay)
        (valFlag "world" cfg.worldPath)
        (valFlag "autocreate" (builtins.getAttr cfg.autoCreatedWorldSize worldSizeMap))
        (valFlag "banlist" cfg.banListPath)
        (valFlag "seed" cfg.seed)
        (valFlag "config" worlds.pb.config)
        (boolFlag "secure" cfg.secure)
        (boolFlag "noupnp" cfg.noUPnP)
      ];

    in

    {
      options = {
        services.terraria.runDir = lib.mkOption {
          type = lib.types.path;
          default = "/run/terraria";

        };
        services.terraria.seed = lib.mkOption {
          type = lib.types.str;
        };
      };
      config = {
        services.terraria = {
          enable = true;
          package = pkgs.terraria-server;
          port = 7777;
          password = "peanutbutter";
          dataDir = "/srv/terraria";
          worldPath = "/srv/terraria/pb.wld";
          autoCreatedWorldSize = "large";
          seed = "3.2.1.0.peanutbutter";
          openFirewall = true;
        };
        systemd.services.terraria.serviceConfig.ExecStart = lib.mkForce ''
          ${tmuxCmd} new -d ${lib.getExe cfg.package} ${lib.concatStringsSep " " flags}
        '';
        systemd.services.terraria.serviceConfig.ExecStartPost = "${pkgs.coreutils}/bin/chmod 660 ${sock}";

        systemd.services.terraria.serviceConfig.RuntimeDirectory = "terraria";
        systemd.services.terraria.serviceConfig.RuntimeDirectoryPreserve = "yes";
        users.users.terraria.homeMode = "770";
      };


    };
in
{
  imports = [ terraria ];
}

_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.glances;
  #format = pkgs.formats.yaml {};
  #configFile = format.generate "conf.yml" cfg.settings;
in {
  options.services.glances = with lib; {
    enable = mkEnableOption "glances";
    package = mkOption {
      type = types.package;
      default = pkgs.glances;
    };
    port = mkOption {
      type = types.int;
      default = 61208;
    };
    user = mkOption {
      type = types.str;
      default = "glances";
    };
    group = mkOption {
      type = types.str;
      default = "glances";
    };
    settings = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = let
    exec_args = [
      "-p ${builtins.toString cfg.port}"
    ];
  in
    lib.mkIf cfg.enable {
      users.users."${cfg.user}" = {
        inherit (cfg) group;
        isSystemUser = true;
        #home = cfg.dataDir;
        createHome = true;
      };
      users.groups."${cfg.group}" = {};
      systemd.services.glances = {
        after = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/glances -w ${lib.strings.escapeShellArgs exec_args}";
          User = cfg.user;
          Group = cfg.group;
          Restart = "always";
        };
        environment = {
          PORT = builtins.toString cfg.port;
        };
      };
    };
}

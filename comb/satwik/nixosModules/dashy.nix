_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.dashy;
  format = pkgs.formats.yaml {};
  page = {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      page = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };
    };
  };

  configFile =
    format.generate "conf.yml"
    (lib.attrsets.optionalAttrs (cfg.pages != {}) {
        pages =
          lib.attrsets.mapAttrsToList (key: value: {
            name = value.name;
            path = "${key}\.yml";
          })
          cfg.pages;
      }
      // cfg.settings);
  #pages = lib.attrsets.mapAttrs (key: value: value.page) cfg.pages;
  pageFiles = lib.attrsets.mapAttrs (key: value: format.generate "${key}.yml" value.page) cfg.pages;
in {
  options.services.dashy = with lib; {
    enable = mkEnableOption "dashy";
    package = mkOption {
      type = types.package;
      default = pkgs.dashy;
    };
    port = mkOption {
      type = types.int;
      default = 4000;
    };
    user = mkOption {
      type = types.str;
      default = "dashy";
    };
    group = mkOption {
      type = types.str;
      default = "dashy";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/dashy";
    };
    mutableConfig = mkOption {
      type = types.bool;
      default = false;
    };
    pages = mkOption {
      type = types.attrsOf (types.submodule page);
      default = {};
    };
    settings = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    users.users."${cfg.user}" = {
      inherit (cfg) group;
      isSystemUser = true;
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups."${cfg.group}" = {};
    systemd.services.dashy = {
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      preStart =
        ''
          mkdir -p ${cfg.dataDir}/public
        ''
        + (
          if cfg.mutableConfig
          then ''
            if [ ! -f ${cfg.dataDir}/public/conf.yml ]; then
              cp ${cfg.package}/libexec/Dashy/deps/Dashy/public/conf.yml ${cfg.dataDir}/public/conf.yml
              chmod u+w ${cfg.dataDir}/public/conf.yml
            fi
          ''
          else
            (''
                ln -sf ${configFile} ${cfg.dataDir}/public/conf.yml
              ''
              + lib.strings.concatLines (lib.attrsets.mapAttrsToList (key: value: "ln -sf ${value} ${cfg.dataDir}/public/${key}.yml") pageFiles))
        );
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/dashy";
        WorkingDirectory = cfg.dataDir;
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

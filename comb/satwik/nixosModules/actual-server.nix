_: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.actual-server;
in {
  options.services.actual-server = {
    enable = lib.mkEnableOption "Actual Server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.actual-server;
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "::";
      description = "Hostname for the Actual Server.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 5006;
      description = "Port on which the Actual Server should listen.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "actual";
      description = lib.mdDoc "User account under which Actual runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "actual";
      description = lib.mdDoc "Group under which Actual runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data";
      description = "Directory for user files.";
    };

    serverFiles = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/server-files";
      description = "Directory for user files.";
    };

    userFiles = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/user-files";
      description = "Directory for user files.";
    };

    upload = {
      fileSizeSyncLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for synchronized files.";
      };

      syncEncryptedFileSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for synchronized encrypted files.";
      };

      fileSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for file uploads.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0755 ${cfg.user} ${cfg.group} - -"
      "f '${cfg.dataDir}/.migrations' 0755 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.serverFiles}' 0755 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.userFiles}' 0755 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.actual-server = {
      description = "Actual Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/actual-server";
        Restart = "always";
        Environment = lib.attrsets.mapAttrsToList (key: val: "\"${key}=${toString val}\"") {
          # Set environment variables from configuration options here
          DEBUG = "actual:config";
          ACTUAL_HOSTNAME = cfg.hostname;
          ACTUAL_PORT = toString cfg.port;
          #ACTUAL_USER_FILES = "${cfg.userFiles}";
          #ACTUAL_SERVER_FILES = "${cfg.serverFiles}";
          # For uploads, set the respective environment variables.
          #ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = toString (cfg.upload.fileSizeSyncLimitMB or "");
          #ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SIZE_LIMIT_MB = toString (cfg.upload.syncEncryptedFileSizeLimitMB or "");
          #ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = toString (cfg.upload.fileSizeLimitMB or "");
        };
      };
    };
    users.users = lib.mkIf (cfg.user == "actual") {
      actual = {
        group = cfg.group;
        #home = cfg.dataDir;
        isNormalUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "actual") {
      actual = {};
    };
  };
}

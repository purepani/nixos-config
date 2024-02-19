{
  inputs,
  cell,
}: {
  networking.firewall = {
    allowedTCPPorts = [80 443 4000];
  };

  services.caddy = {
    enable = true;
    package = cell.packages.caddy.override {
      externalPlugins = [
        {
          name = "godaddy";
          repo = "github.com/caddy-dns/godaddy";
          version = "7634a752ba5bda3977b461c60f5936eba3d02426";
        }
      ];
      vendorHash = "sha256-hVRMAzLqHo8dk2ni1bZvoJwrjWhCeRNS9+JDZB/eYus=";
    };
    virtualHosts = {
      "veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "jellyfin.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "sonarr.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8989
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "torrent.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:58080
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "jellyseerr.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:5055
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "actual.veneprodigy.com" = {
        extraConfig = ''
          encode gzip zstd
          reverse_proxy 127.0.0.1:5006
        '';
        #serverAlias = ["actualbudget.veneprodigy.com"];
      };
    };
    globalConfig = ''
      acme_dns godaddy {env.GODADDY_TOKEN}
    '';
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = "/home/satwik/secrets/caddy";
}

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
          repo = "github.com/caddy-dns/cloudflare";
          version = "44030f9306f4815aceed3b042c7f3d2c2b110c97";
        }
      ];
      vendorHash = "sha256-C7JOGd4sXsRZL561oP84V2/pTg7szEgF4OFOw35yS1s=";
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
      
      "radarr.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy localhost:7878
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "prowlarr.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9696
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "torrent.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy localhost:58080
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
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = "/home/satwik/secrets/caddy";
}

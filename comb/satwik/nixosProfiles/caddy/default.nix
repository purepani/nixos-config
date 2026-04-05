{ inputs
, cell
, config
,
}:
let
  pkgs = cell.nixpkgs.pkgs;
  caddy = pkgs.caddy.withPlugins {
    plugins = [

      "github.com/caddy-dns/cloudflare@v0.2.2"
    ];
    hash = "sha256-dnhEjopeA0UiI+XVYHYpsjcEI6Y1Hacbi28hVKYQURg=";
  };
in
{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 4000 25565 ];
  };

  services.caddy = {
    enable = true;
    package = caddy;
    virtualHosts = {
      "192.168.1.7" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096 
        '';

      };
      "172.87.67.58" = {
        extraConfig = ''
                    reverse_proxy 127.0.0.1:38080 {
          	  	header_up Host {upstream_hostport}
          	}
        '';

      };
      "webdav.veneprodigy.com" = {
        extraConfig = ''
                    reverse_proxy 127.0.0.1:38080 {
          	  	header_up Host {upstream_hostport}
          	  }
        '';

      };
      "veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "ha.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8123
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };
      #"z2mqtt.veneprodigy.com" = {
      #extraConfig = ''
      #@websockets {
      #header Connection *Upgrade*
      #header Upgrade websocket
      #path /api/*
      #}
      #reverse_proxy 127.0.0.1:8724
      #'';
      ##serverAlias = ["www.veneprodigy.com"];
      #};

      "127.0.0.1:9010" = {
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

      "flaresolverr.veneprodigy.com" = {
        extraConfig = ''
          	  reverse_proxy 127.0.0.1:8191
          	'';

      };


      "suwayomi.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080
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
      "${config.services.jitsi-meet.hostName}" = { };

      "ftpgo.veneprodigy.com" = {
        extraConfig = ''
          	  reverse_proxy 127.0.0.1:48080
          	'';

      };


      "grafana.veneprodigy.com" = {
        extraConfig = ''
          	  reverse_proxy 127.0.0.1:3000
          	'';

      };

    };
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = "/home/satwik/secrets/caddy";
}

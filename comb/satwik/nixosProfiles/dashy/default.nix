{
  inputs,
  cell,
}: let
  domain = "satwik-nixos.netbird.cloud";
  #domain = "localhost";
in {
  imports = [cell.nixosModules.dashy];
  services.dashy = {
    enable = true;
    package = cell.packages.dashy;
    #port = 8082;
    settings = {
      pageInfo = {
        title = "Satwik's homelab";
        description = "Nyaa~~";
        navLinks = [
          {
            title = "GitHub";
            path = "https://github.com/purepani";
          }
        ];
      };
      appConfig = {
        theme = "nord-frost";
        layout = "auto";
        iconSize = "large";
        language = "en";
        statusCheck = true;
        hideComponents.hideSettings = true;
        routingMode = "hash";
      };
      sections = [
        {
          name = "system-resources";
          items = [
            {
              title = "Jellyfin";
              url = "http://${domain}:8096";
              icon = "hl-jellyfin";
            }
          ];
        }
        {
          name = "Multimedia";
          items = [
            {
              title = "Sonarr";
              url = "http://${domain}:8989";
              icon = "hl-sonarr";
            }
            {
              title = "Radarr";
              url = "http://${domain}:8096";
              icon = "hl-radarr";
            }
            {
              title = "qbittorrent";
              url = "http://${domain}:58080";
              icon = "hl-qbittorrent";
            }
          ];
        }
        {
          name = "System Resources";
          widgets = [
            {
              type = "gl-current-cpu";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-current-cores";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-cpu-history";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-current-mem";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-mem-history";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-disk-space";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-disk-io";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-system-load";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-load-history";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-network-interfaces";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-alerts";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
            {
              type = "gl-ip-address";
              options = {
                hostname = "http://${domain}:61208";
              };
            }
          ];
        }
      ];
    };
  };
}

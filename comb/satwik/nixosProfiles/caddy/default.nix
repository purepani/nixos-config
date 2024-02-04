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
          #version = "1.0.3";
          #version = "8789126791ed250b532e1d7d512256737625e6e0";
        }
      ];
      vendorHash = "sha256-hVRMAzLqHo8dk2ni1bZvoJwrjWhCeRNS9+JDZB/eYus=";
    };
    virtualHosts = {
      "http://veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:4000
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };

      "http://jellyfin.veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8086
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };
    };
    #globalConfig = ''
    #  acme_dns cloudflare {env.CF_API_TOKEN}
    #'';
  };
}

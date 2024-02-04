{
  inputs,
  cell,
}: {
  networking.firewall = {
    allowedTCPPorts = [80 443 4000];
  };

  services.caddy = {
    enable = true;
    package = cell.packages.caddy.package.override {
      externalPlugins = [
        {
          name = "dns.providers.cloudflare";
          repo = "github.com/caddy-dns/cloudflare";
          version = "8789126791ed250b532e1d7d512256737625e6e0";
        }
      ];
      vendorHash = "sha256-IiOHPTaR7tMahS4xpVJ7H1f7PSZCM+C/mURjBNUTvxo=";
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
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';
  };
}

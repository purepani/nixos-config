{
  inputs,
  cell,
}: {
  networking.firewall = {
    allowedTCPPorts = [80 443 4000];
  };

  services.caddy = {
    enable = true;
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
  };
}

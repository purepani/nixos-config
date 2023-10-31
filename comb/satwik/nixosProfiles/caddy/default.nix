{
  inputs,
  cell,
}: {
  networking.firewall = {
    allowedTCPPorts = [80 443];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://veneprodigy.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
        #serverAlias = ["www.veneprodigy.com"];
      };
    };
  };
}

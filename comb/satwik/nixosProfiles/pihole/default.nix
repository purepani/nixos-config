{ inputs, cell }: {
  services.pihole-ftl = {
    enable = true;
    openFirewallDHCP = true;
    queryLogDeleter.enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        # Alternatively, use the file from nixpkgs. Note its contents won't be
        # automatically updated by Pi-hole, as it would with an online URL.
        # url = "file://${pkgs.stevenblack-blocklist}/hosts";
        description = "Steven Black's unified adlist";
      }
    ];
    settings = {
      dns = {
        domainNeeded = true;
        expandHosts = true;
        #interface = "br-lan";
        listeningMode = "BIND";
        upstreams = [ "127.0.0.1#5053" ];
      };
      dhcp = {
        active = true;
        router = "192.168.1.1";
        start = "192.168.1.2";
        end = "192.168.1.254";
        leaseTime = "1d";
        ipv6 = false;
        multiDNS = true;
        hosts = [
          # Static address for the current host
          "192.168.1.7,infinite"
        ];
        rapidCommit = true;
      };
      misc.dnsmasq_lines = [
        # This DHCP server is the only one on the network
        "dhcp-authoritative"
        # Source: https://data.iana.org/root-anchors/root-anchors.xml
        "trust-anchor=.,38696,8,2,683D2D0ACB8C9B712A1948B27F741219298D0A450D612C483AF444A4C0FB2B16"
      ];
    };
  };


  services.pihole-web = {
    enable = true;
    ports = [ 22280 ];
  };
}

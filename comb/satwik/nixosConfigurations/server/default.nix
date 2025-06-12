# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).
{ inputs
, cell
, config
, ...
}:
let
  inherit (cell) hardwareProfiles nixosProfiles;
  inherit (inputs) common;
  inherit (common) bee;
  inherit (bee) pkgs;
in
{
  inherit bee;

  imports = with hardwareProfiles;
    with nixosProfiles; [
      server
      sftpgo
      jellyfin
      jellyseerr
      sonarr
      radarr
      recyclarr
      bazarr
      prowlarr
      qbittorrent
      suwayomi
      minecraft-server
      #firefly-iii
      jitsi-meet
      netdata
      #netmaker
      netbird
      dashy
      #coredns
      caddy
      glances
      actual-server
      nfs
    ];
  #services.nfs.server.enable = true;	
  networking.hostName = "satwik-server"; # Define your hostname.
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    port = 58080;
    dataDir = "/media/downloads";
  };
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0"
    "mem_sleep_default=deep"
    "intel_iommu=on"
    "pcie_aspm=off"
    "i8042.dumpkbd=1"
    "i915.enable_guc=2"
  ];


  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "zpool" ];
  networking.hostId = "95c4a621";

  services.openssh.enable = true;
  systemd.enableEmergencyMode = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.zerotierone = {
    enable = false;
    joinNetworks = [
      "e5cd7a9e1cefda64"
    ];
  };


  #Set your time zone.
  time.timeZone = "America/Chicago";

  #networking.interfaces.eno1.useDHCP = true;
  #networking.networkmanager = {
  #  enable = true;
  #};
  # 1. enable vaapi on OS-level

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  services.dbus = {
    enable = true;
    packages = [ ];
  };

  services.xserver = {
    enable = true;
  };

  programs.adb.enable = true;
  programs.dconf.enable = true;
  services.udisks2.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.satwik = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "adbusers"
      "dialout"
      "video"
      "vboxusers"
      "libvirtd"
    ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles = [
      ./__public_ssh/satwik/personal_server.pub
    ];
  };

  users.groups.media.members = [ "jellyfin" "sonarr" "radarr" "bazarr" "rtorrent" "qbittorrent" ];



  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    kmod
    pciutils
    libva-utils
    tmux
  ];

  programs.neovim.defaultEditor = true;

  services.fwupd.enable = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      allow-import-from-derivation = true
    '';
  };
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05"; # Did you read the comment?



  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 80 443 25565 ];
    allowedUDPPorts = [ 51819 51820 ]; # Clients and peers can use the same port, see listenport
  };
  networking.nftables = {
    enable = true;
    tables = {
      filter = {
        content = ''
          # Check out https://wiki.nftables.org/ for better documentation.
          # Table for both IPv4 and IPv6.
          # Block all incoming connections traffic except SSH and "ping".
          chain input {
            type filter hook input priority 0;

            # accept any localhost traffic
            iifname lo accept

            # accept traffic originated from us
            ct state {established, related} accept

            #
            ip saddr 192.168.1.0/24 accept

            # ICMP
            # routers may also want: mld-listener-query, nd-router-solicit
            ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
            ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

            # allow "ping"
            ip6 nexthdr icmpv6 icmpv6 type echo-request accept
            ip protocol icmp icmp type echo-request accept

            # accept SSH connections (required for a server)
            tcp dport {22, 80, 443, 25565, 2049, 28080} accept
            udp dport {51820, 51819, 28080} accept

            # accept SSH connections (required for a server)
            tcp dport {111, 2049, 4000, 4001, 4002, 20048} accept
            udp dport {111, 2049, 4000, 4001, 4002, 20048} accept

            # count and drop any other traffic
            counter drop
          }

          # Allow all outgoing connections.
          chain output {
            type filter hook output priority 0;
            accept
          }

          chain forward {
            type filter hook forward priority 0;
            accept
          }
        '';
        family = "inet";
      };
    };
  };
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    netdevs = {
      "10-givingfrog" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "givingfrog";
          MTUBytes = "1380";
        };
        # See also man systemd.netdev (also contains info on the permissions of the key files)
        wireguardConfig = {
          # Don't use a file from the Nix store as these are world readable. Must be readable by the systemd.network user
          #FirewallMark = 42;
          PrivateKeyFile = "/var/secrets/wireguard-keys/private";
          ListenPort = 51819;
        };
        wireguardPeers = [
          {
            wireguardPeerConfig = {
              PublicKey = "0qSP0VxoIhEhRK+fAHVvmfRdjPs2DmmpOCNLFP/7cGw=";
              AllowedIPs = [ "0.0.0.0/0" ];
              Endpoint = "193.32.248.66:51819";
              #PresharedKeyFile = "/var/secrets/wireguard-keys/private";
              PersistentKeepalive = 25;
            };
          }
        ];
      };
    };

    networks = {
      "10-wan" = {
        matchConfig.Name = "enp5s0";
        # start a DHCP Client for IPv4 Addressing/Routing
        DHCP = "yes";
        # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
        networkConfig = {
          IPv4Forwarding = "yes";
          IPv6AcceptRA = true;
        };
        routes = [
          {
            routeConfig = {
              Gateway = "_dhcp4";
              Metric = 1000;
            };
          }
        ];
        # make routing on this interface a dependency for network-online.target
        linkConfig.RequiredForOnline = "routable";
      };

      givingfrog = {
        # See also man systemd.network
        matchConfig.Name = "givingfrog";
        #IPMasquerade = "both";
        networkConfig = {
          # IP addresses the client interface will have
          Address = "10.66.75.100/32";
          IPv4Forwarding = "yes";
        };
        dns = [ "10.64.0.1" ];
        routingPolicyRules = [
          {
            routingPolicyRuleConfig = {
              To = "10.64.75.100/32";
              #To = "10.68.127.131";
              #FirewallMark = 42;
              #InvertRule = true;
              Table = 1000;
              SuppressPrefixLength = 0;
            };
          }
          {
            routingPolicyRuleConfig = {
              From = "10.64.75.100/32";
              SuppressPrefixLength = 0;
              #FirewallMark = 42;
              #InvertRule = true;
              Table = 1000;
            };
          }
        ];
        #  IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
      };
    };
  };
}

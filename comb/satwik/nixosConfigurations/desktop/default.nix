{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
in {
  inherit (inputs.common) bee;
  programs.dconf.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages-rt_latest;
  security.sudo.enable = true;
  imports = with nixosProfiles; [
    hardwareProfiles.desktop
    nfs
    extra
    nix
    desktop
    kdeconnect
    locale
    pipewire
    steam
    virtualization
    zerotier-one
    udev
    NetworkManager
    #musnix
    netmaker
    inputs.musnix.nixosModules.musnix
    netbird
    resolved
  ];

  hardware.opengl = {
    enable = true;
  };
  musnix = {
    enable = true;
  };
  networking.nameservers = [
    "1.1.1.1"
    "1.1.1.2"
  ];
  security.pam.services = {
    openconnect = {
      u2fAuth = true;
    };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "eno1";
    #externalInterface = "wlp8s0";
    # Lazy IPv6 connectivity for the container
  };
  networking.networkmanager.unmanaged = ["interface-name:ve-*"];
  containers.server = {
    bindMounts = {
      "/media" = {
        hostPath = "/media";
        isReadOnly = false;
      };
    };
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = with nixosProfiles; [
        jellyfin
        sonarr
        radarr
        bazarr
        prowlarr
        qbittorrent
        #firefly-iii
        netdata
        #netmaker
        netbird
        dashy
        coredns
        caddy
        glances
      ];

      services.qbittorrent = {
        enable = true;
        openFirewall = true;
        port = 58080;
        dataDir = "/media/downloads";
      };

      services.openssh.enable = true;

      networking.firewall.enable = false;

      networking.networkmanager = {
        enable = true;
      };
      networking.hostName = "satwik-nixos"; # Define your hostname.
      networking.useHostResolvConf = lib.mkForce false;

      services.fwupd.enable = true;
      services.resolved.enable = true;
      #Set your time zone.
      time.timeZone = "America/Chicago";

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
      };

      users.groups.media.members = ["jellyfin" "sonarr" "radarr" "bazarr" "rtorrent" "qbittorrent"];

      networking.wg-quick.interfaces = {
        givingfrog = {
          # Determines the IP address and subnet of the client's end of the tunnel interface.
          address = ["10.65.127.131/32"];
          listenPort = 51819; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
          #dns = ["10.64.0.1"];
          privateKeyFile = "/home/satwik/wireguard-keys/private";

          peers = [
            # For a client configuration, one peer entry for the server will suffice.

            {
              # Public key of the server (not a file path).
              publicKey = "/WirOQ8FNF9tD1+/MYgIAWpjFKiJYhJJ7/w2QmKBrVo=";

              # Forward all the traffic via VPN.
              #allowedIPs = ["0.0.0.0/0" "::0/0"];
              # Or forward only particular subnets
              allowedIPs = ["10.64.0.1" "10.65.0.1/16" "91.108.12.0/22"];

              # Set this to the server IP and port.
              endpoint = "66.63.167.146:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

              # Send keepalives every 25 seconds. Important to keep NAT tables alive.
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire.d/91-null-sinks.conf".source = json.generate "91-null-sinks.conf" {
      context.objects = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # properyty when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            factory.name = "support.node.driver";
            node.name = "Dummy-Driver";
            priority.driver = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            factory.name = "support.null-audio-sink";
            node.name = "Microphone-Proxy";
            node.description = "Microphone";
            media.class = "Audio/Source/Virtual";
            audio.position = "MONO";
          };
        }
        {
          factory = "adapter";
          args = {
            factory.name = "support.null-audio-sink";
            node.name = "pipewire";
            node.description = "Main Output";
            media.class = "Audio/Sink";
            audio.position = "FL,FR";
          };
        }
      ];
    };
  };
}

{ inputs
, cell
,
}:
let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
in
{
  inherit (inputs.common) bee;
  services.rpcbind.enable = true;
  #needed for easyeffects
  programs.dconf.enable = true;
  nix.package = pkgs.nixVersions.latest;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = ''
    	options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
  '';

  security.sudo.enable = true;
  imports = with nixosProfiles; [
    #({config, options, lib,...}: {
    #	options.system.nixos.codeName = lib.mkOption {readOnly=false;};
    #})
    inputs.home-manager.nixosModules.home-manager
    hardwareProfiles.desktop
    android
    nfs
    extra
    nix
    desktop
    kdeconnect
    locale
    pipewire
    printers
    steam
    #virtualization
    udev
    NetworkManager
    #musnix
    #netmaker
    inputs.musnix.nixosModules.musnix
    #inputs.sops-nix.nixosModules.sops
    netbird
    resolved
  ];

  home-manager.backupFileExtension = "backup";
  home-manager.users.satwik = cell.homeConfigurations.laptop;

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  services.udev.extraRules = ''
    	ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="666" TAG+="uaccess"
  '';

  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.rocmPackages.clr.icd
      #pkgs.intel-compute-runtime
    ];
  };
  #Temporarily change name to fix dotnet cli: https://github.com/NixOS/nixpkgs/issues/315574
  #system.nixos.codeName = pkgs.lib.mkForce "Vicuna";
environment.systemPackages = with pkgs; [
  clinfo
];

  musnix = {
    enable = false;
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
  services.openssh.enable = true;
  programs.gamemode.enable = true;
  programs.nix-ld.enable = true;

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "eno1";
    #externalInterface = "wlp8s0";
    # Lazy IPv6 connectivity for the container
  };

  nix = {
    settings = {
      trusted-users = [ "satwik" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  services.resolved.enable = true;
  services.avahi.enable = true;
  networking.networkmanager.connectionConfig."connection.mdns" = 2;


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
            tcp dport {22, 80, 443, 25565, 2049} accept
            udp dport {51820, 51819} accept

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

  #environment.etc = let
  #  json = pkgs.formats.json {};
  #in {
  #  "pipewire/pipewire.d/91-null-sinks.conf".source = json.generate "91-null-sinks.conf" {
  #    context.objects = [
  #      {
  #        # A default dummy driver. This handles nodes marked with the "node.always-driver"
  #        # properyty when no other driver is currently active. JACK clients need this.
  #        factory = "spa-node-factory";
  #        args = {
  #          factory.name = "support.node.driver";
  #          node.name = "Dummy-Driver";
  #          priority.driver = 8000;
  #        };
  #      }
  #      {
  #        factory = "adapter";
  #        args = {
  #          factory.name = "support.null-audio-sink";
  #          node.name = "Microphone-Proxy";
  #          node.description = "Microphone";
  #          media.class 

  # We're not using the upstream unit, so copy these: https://github.com/sddm/sddm/blob/develop/services/sddm.service.in= "Audio/Source/Virtual";
  #          audio.position = "MONO";
  #        };
  #      }
  #      {
  #        factory = "adapter";
  #        args = {
  #          factory.name = "support.null-audio-sink";
  #          node.name = "pipewire";
  #          node.description = "Main Output";
  #          media.class = "Audio/Sink";
  #          audio.position = "FL,FR";
  #        };
  #      }
  #   ];
  #  };
  #};
}

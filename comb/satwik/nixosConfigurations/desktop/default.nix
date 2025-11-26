{ inputs
, cell
,
}:
let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
in
{
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.enable = true;
    signal.relayHosts = [ "100.65.5.198" "192.168.1.50" ];
    relay.enable = true;
  };
  inherit (inputs.common) bee;
  services.rpcbind.enable = true;
  services.fwupd.enable = true;
  #needed for easyeffects
  programs.dconf.enable = true;
  nix.package = pkgs.nixVersions.latest;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = ''
    	options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
  '';
  networking.hostName = "satwik-desktop"; # Define your hostname.

  security.sudo.enable = true;
  imports = with nixosProfiles; [
    #({config, options, lib,...}: {
    #	options.system.nixos.codeName = lib.mkOption {readOnly=false;};
    #})
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    #(inputs.nixos-cosmic.nixosModules.default // { nixpkgs = builtins.removeAttrs inputs.nixos-cosmic.nixosModules.default.nixpkgs [ "overlays" ]; })
    hardwareProfiles.desktop
    #openssh
    android
    #boinc
    docker
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
    openssh
    inputs.musnix.nixosModules.musnix
    #inputs.sops-nix.nixosModules.sops
    netbird
    resolved
  ];
  home-manager.backupFileExtension = "backup";
  home-manager.users.satwik = cell.homeConfigurations.desktop;

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          rccl
          rocrand
          hiprand
          clr
          clr.icd
          rocm-runtime
        ];
      };
    in
    [
      #"L+    /opt/rocm/hip   -    -    -     -    ${rocmEnv}"
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
    enable = true;
    kernel.realtime = true;
    kernel.packages = pkgs.linuxPackages_latest;
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
            tcp dport {22, 80, 443, 25565, 2049, 21114-21119} accept
            udp dport {51820, 51819, 21116} accept

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

  services.restic.backups = {
    remotebackup = {
      passwordFile = "/home/satwik/.secrets/restic-password";
      environmentFile = "/home/satwik/.secrets/restic-environment";

      paths = [
        "/home/satwik"
      ];

      exclude = [
        "/home/satwik/.*/**"
        "/home/satwik/Network"
        "**/.*"
        "**/node_modules"
        "**/__pypackages__"
        "**/target"
      ];

      timerConfig = {
        OnCalendar = "00:00";
        RandomizedDelaySec = "5h";
      };
    };

  };

}

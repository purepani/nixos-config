# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  cell,
}: let
  inherit (cell) hardwareProfiles nixosProfiles;
  inherit (inputs) common;
  inherit (common) bee;
  inherit (bee) pkgs;
in {
  inherit bee;

  imports = with hardwareProfiles;
  with nixosProfiles; [
    server
    jellyfin
    jellyseerr
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
    #caddy
    glances
    actual-server
  ];

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    port = 58080;
    dataDir = "/media/downloads";
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0"
    "mem_sleep_default=deep"
    "intel_iommu=on"
    "pcie_aspm=off"
    "i8042.dumpkbd=1"
  ];
  services.openssh.enable = true;
  systemd.enableEmergencyMode = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "e5cd7a9e1cefda64"
    ];
  };

  networking.hostName = "satwik-nixos"; # Define your hostname.

  #Set your time zone.
  time.timeZone = "America/Chicago";

  networking.interfaces.eno1.useDHCP = true;
  networking.networkmanager = {
    enable = true;
  };
  # 1. enable vaapi on OS-level

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  services.dbus = {
    enable = true;
    packages = [];
  };
  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["modesetting"];
  };

  #nixpkgs.config.allowUnfree = true;
  programs.adb.enable = true;
  programs.dconf.enable = true;
  services.udisks2.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;

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
  };

  users.groups.media.members = ["jellyfin" "sonarr" "radarr" "bazarr" "rtorrent" "qbittorrent"];

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    kmod
    pciutils
    libva-utils
  ];

  programs.neovim.defaultEditor = true;

  services.fwupd.enable = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      allow-import-from-derivation = true
    '';
  };
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05"; # Did you read the comment?

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];
  networking.nameservers = ["1.1.1.1" "9.9.9.9"];
  #  networking.firewall.allowedTCPPorts = [80 443];
  #  security.acme = {
  #    acceptTerms = true;
  #    email = "admin+acme@box.pb";
  #  };

  #services.nginx.virtualHosts = let
  #  SSL = {
  #    enableACME = true;
  #    forceSSL = true;
  #  };
  #in {
  #  "box.pb" =
  #    SSL
  #    // {
  #      locations."/".proxyPass = "http://127.0.0.1:8096/";
  #
  #        serverAliases = [
  #          "www.box.pb"
  #        ];
  #      };
  #
  #    "jellyfin.box.pb" =
  #      SSL
  #      // {
  #        locations."/".proxyPass = "http://127.0.0.1:8096/";
  #      };
  #  };
  # "fc00:bbbb:bbbb:bb01::5:7f82/128"
  networking.firewall = {
    allowedUDPPorts = [51819 51820]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard

  networking.wg-quick.interfaces = {
    givingfrog = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      address = ["10.68.127.131/32"];
      listenPort = 51819; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      #dns = ["10.64.0.1"];
      privateKeyFile = "/home/satwik/wireguard-keys/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "/WirOQ8FNF9tD1+/MYgIAWpjFKiJYhJJ7/w2QmKBrVo=";

          # Forward all the traffic via VPN.
          allowedIPs = ["0.0.0.0/0" "::0/0"];
          # Or forward only particular subnets
          #allowedIPs = ["10.64.0.1" "10.65.0.1/16" "10.68.127.131/32" "91.108.12.0/22" "66.63.167.146"];

          # Set this to the server IP and port.
          endpoint = "66.63.167.146:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

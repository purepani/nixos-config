{
  inputs,
  cell,
}: let
  inherit (inputs) common;
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (common) bee;
  inherit (bee) pkgs;
in {
  inherit bee;

  imports = [
    # Include the results of the hardware scan.
    hardwareProfiles.laptop
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #imports = [
  #hardwareProfiles.laptop
  #./hardware-configuration.nix
  #extra
  #nix
  #desktop
  #kdeconnect
  #locale
  #nix
  #pipewire
  #steam
  #virtualization
  #zerotier-one
  #];
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "e5cd7a9e1cefda64"
    ];
  };
  boot.supportedFilesystems = ["ntfs"];
  networking.hostName = "satwik"; # Define your hostname.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";
  virtualisation.libvirtd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "suspend";
  };

  #services.dconf.enable=true;
  programs.dconf.enable = true;
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = ["satwik"];
  };
  programs.kdeconnect = {
    enable = true;
    #package = pkgs.gnomeExtensions.gsconnect;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.polkit.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.satwik = {
    isNormalUser = true;
    description = "Satwik Pani";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "audio" "input"];
    packages = with pkgs; [
      kitty
      git
      firefox
      thunderbird
      libinput-gestures
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "satwik";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229.nix
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    virt-manager
    virtiofsd
  ];

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 256;
        default.clock.min-quantum = 256;
        default.clock.max-quantum = 256;
      };
    };
  };

  #programs.hyprland = {
  #               enable=true;
  #               nvidiaPatches=true
  #};

  #programs.hyprland={
  #                    enable=false;
  #                    xwayland.enable=true;};
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-kde];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

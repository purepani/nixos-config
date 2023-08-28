# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs, cell
}: 
let 
  inherit (cell) hardwareProfiles nixosProfiles; 
  inherit (inputs) common;
  inherit (common) bee;
  inherit (bee) pkgs;
in {
  inherit bee;

  imports = with hardwareProfiles; with nixosProfiles;[
    server 
    jellyfin
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0"
    "mem_sleep_default=deep"
    "intel_iommu=on"
    "pcie_aspm=off"
    "i8042.dumpkbd=1"
  ];
  services.openssh.enable=true;

  boot.initrd.kernelModules = ["amdgpu" "vfio-pci" "kvm-intel"];

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

  networking.interfaces.wlp2s0.useDHCP = true;
  networking.networkmanager = {
    enable = true;
  };


  hardware.opengl = {
    enable = true;
    #package = pkgs.mesa.drivers;
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
    #driSupport32Bit = true;
    #package32 = pkgs.pkgsi686Linux.mesa.drivers;
  };


  services.dbus = {
    enable = true;
    packages = [];
  };
  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      #xfce.enable = true;
      plasma5.enable = true;
    };
    displayManager = {
      sddm.enable = true;
    };
  };

  services.xserver.videoDrivers = ["modesetting"];

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

  # List packages installed in system profile. To search, run:

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    kmod
    pciutils
  ];

  #For pipewire
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
  security.sudo.wheelNeedsPassword=false;

  system.stateVersion = "21.05"; # Did you read the comment?

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];
}

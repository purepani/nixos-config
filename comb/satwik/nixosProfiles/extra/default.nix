{inputs, cells}:
{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };
  boot.supportedFilesystems = ["ntfs"];
  services.printing.enable = true;
  security.polkit.enable = true;

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  time.timeZone = "America/Chicago";
  networking.hostName = "satwik"; # Define your hostname.
  users.users.satwik = {
    isNormalUser = true;
    description = "Satwik Pani";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "audio" "input"];
    packages = with inputs.nixpkgs; [
      kitty
      git
      firefox
      thunderbird
      libinput-gestures
    ];
  };

    services.logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "suspend";
    };
  system.stateVersion = "23.05"; # Did you read the comment?
}
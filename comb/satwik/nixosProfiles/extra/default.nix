{ inputs
, cell
,
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };
  boot.supportedFilesystems = [ "ntfs" ];
  services.printing.enable = true;
  security.polkit.enable = true;

  hardware.bluetooth.enable = true;
  hardware.wooting.enable = true;
  time.timeZone = "America/Chicago";
  users.users.satwik = {
    isNormalUser = true;
    description = "Satwik Pani";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "audio" "input" "tty" "dialout" "adbusers" "docker" "video" "render" "minecraft" "boinc" ];
    packages = with cell.nixpkgs.pkgs; [
      busybox
      kitty
      git
      #firefox
      #thunderbird
      #libinput-gestures
    ];
  };
  #services.logind = {
  #  lidSwitch = "suspend";
  #  lidSwitchDocked = "suspend";
  #};
  system.stateVersion = "23.05"; # Did you read the comment?
}

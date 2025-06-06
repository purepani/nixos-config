# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ inputs
, cell
, config
,
}:
let
  lib = inputs.nixpkgs.lib // builtins;
in
{
  imports = [
    #(modulesPath + "/installer/scan/not-detected.nix")
    #inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    #inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "nfs" ];
  boot.initrd.supportedFilesystems = [ "nfs" ];
  boot.kernelModules = [ "amdgpu" "kvm-amd" ];
  boot.supportedFilesystems = [ "nfs" ];


  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  boot.kernelParams = [ "fbdev=1" ];
  boot.extraModulePackages = [ ];
  #boot.kernelParams = ["usbcore.autosuspend=-1"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/25230606-7211-400a-b701-da35819b17ff";
    fsType = "ext4";
  };
  fileSystems."/mnt/storage" = {
    device = "192.168.1.7:/storage";
    fsType = "nfs";
    options = [ "nofail" ];
  };



  #fileSystems."/media" = {
  #  device = "/dev/disk/by-uuid/92583cb8-926c-49c5-94d8-3c524d55157a";
  #  fsType = "ext4";
  #};

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A6C7-6501";
    fsType = "vfat";
  };

  #hardware.nvidia.prime = {
  #  amdgpuBusId = "PCI:4:0:0";
  #  nvidiaBusId = "PCI:1:0:0";
  #};

  #services.thermald.enable = lib.mkDefault true;

  # √(3840² + 2160²) px / 15.60 in ≃ 282 dpi
  #services.xserver.dpi = 259;

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  #networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  #hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
}

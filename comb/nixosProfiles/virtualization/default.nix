{inputs, cells}:
{

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with inputs.nixpkgs; [
    virt-manager
    virtiofsd
  ];
}

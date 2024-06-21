{inputs, cell}:
{

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with cell.nixpkgs.pkgs; [
    virt-manager
    virtiofsd
  ];
}

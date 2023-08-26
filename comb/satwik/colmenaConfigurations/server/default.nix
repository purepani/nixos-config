# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  cell,
}: {
  deployment = {
    targetHost = "172.108.101.1";
    replaceUnknownProfiles = true;
  };
  imports = [
    cell.nixosConfigurations.server
  ];
}

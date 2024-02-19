# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  cell,
}: {
  deployment = {
    targetUser = "satwik";
    targetHost = "100.65.122.59";
    #targetHost = "192.168.1.7";
    replaceUnknownProfiles = true;
  };
  imports = [
    cell.nixosConfigurations.server
  ];
}

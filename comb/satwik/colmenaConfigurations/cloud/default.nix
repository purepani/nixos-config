{ inputs
, cell
,
}: {
  deployment = {
    targetUser = "root";
    targetHost = "5.161.50.34";
    replaceUnknownProfiles = true;
  };
  imports = [
    cell.nixosConfigurations.cloud
  ];
}

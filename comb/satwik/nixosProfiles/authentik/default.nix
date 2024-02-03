{
  inputs,
  cell,
}: {
  imports = [inputs.authentik-nix.nixosModules.default];

  services.authentik = {
    enable = true;
    # The environmentFile needs to be on the target host!
    # Best use something like sops-nix or agenix to manage it
    environmentFile = "/run/secrets/authentik/authentik-env";
    settings = {
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };
}

{
  inputs,
  cell,
}: {
  #imports = [
  #  (import "${inputs.kde2nix}/nixos/modules/services/x11/desktop-managers/plasma6.nix")
  #];
  security.polkit.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  xdg.portal = {
    enable = true;
    #extraPortals = [
    #cell.nixpkgs.pkgs.xdg-desktop-portal-gtk
    #];
  };
}

{
  inputs,
  cell,
}: {
  security.polkit.enable = true;

  #services.xserver.enable = true;
  services.displayManager.sddm = {
  	enable = true;
	wayland.enable = true;
	};
  #services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
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

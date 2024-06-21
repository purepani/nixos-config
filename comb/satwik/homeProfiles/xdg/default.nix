{inputs, cell}: {
	xdg = {
		portal = {
			enable = true;
			extraPortals = [cell.nixpkgs.pkgs.xdg-desktop-portal-kde];
			xdgOpenUsePortal = true;
			config = {
				common={
					default = [
						"kde"
						"plasma"
					];				
					};
				};
			};
	};
}

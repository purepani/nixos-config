{inputs, cell}:
let
  pkgs = cell.nixpkgs.pkgs;

  ptouch-driver = pkgs.ptouch-driver.overrideAttrs (old: {
    src = inputs.ptouch;

  });
in {
	services.printing = {
		enable=true;
    drivers = [ ptouch-driver ];
		cups-pdf.enable=true;
	};
}

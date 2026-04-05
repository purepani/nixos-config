{inputs, cell}:
let
  pkgs = cell.nixpkgs.pkgs;
in {
	services.printing = {
		enable=true;
    drivers = [ pkgs.ptouch-driver ];
		cups-pdf.enable=true;
	};
}

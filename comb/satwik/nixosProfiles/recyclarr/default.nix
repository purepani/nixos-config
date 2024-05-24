{inputs, cell}:

let 
  recyclarr-config = cell.nixpkgs.pkgs.stdenvNoCC.mkDerivation {
  	name = "recyclar-config";
  	src = ./.;
  	dontUnpack = true;
	installPhase = ''
		mkdir -p $out
		cp $src/*.yml $out
	'';
  };
 in {

	systemd.timers.recyclarr = {
	  wantedBy = [ "timers.target" ];
	    timerConfig = {
	      OnCalendar = "minutely";
	      Persistent = false;
	      Unit = "recyclarr.service";
	    };
	};

	systemd.services.recyclarr = {
	  script = ''
	    echo "[recyclarr] Starting sync"
	    cp -r ${recyclarr-config}/* $RUNTIME_DIRECTORY
	    ${cell.nixpkgs.pkgs.recyclarr}/bin/recyclarr sync -c $RUNTIME_DIRECTORY/recyclarr.yml --app-data $RUNTIME_DIRECTORY
	  '';
	  serviceConfig = {
	    Type = "oneshot";
	    DynamicUser = true;
	    RuntimeDirectory = "recyclarr";

	  };
	};

}

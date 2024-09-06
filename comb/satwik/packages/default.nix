{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs;
  qt5Loader = inputs: path: pkgs.libsForQt5.callPackage path { } ;
in
  (inputs.haumea.lib.load {
    src = ./derivations;
    #inherit  cell;
    inputs =
      {
        inherit inputs;
        deepfilter = cell.packages.deepfilter;
      }
      // (removeAttrs pkgs ["self" "super" "root"]);
    loader = inputs.haumea.lib.loaders.callPackage;
    transformer = [inputs.haumea.lib.transformers.liftDefault];
  }) // 
  {
  	luaPackages = inputs.haumea.lib.load {
		src = ./luaPackages;
		loader = inputs.haumea.lib.loaders.verbatim;
		};
	
   }
     // {
	qt5Packages = inputs.haumea.lib.load {
		src = ./qt5packages;
	    inputs =
	      {
		inherit inputs;
		deepfilter = cell.packages.deepfilter;
	      }  
	      // pkgs.libsForQt5
	      // (removeAttrs pkgs ["self" "super" "root"]);
	      loader = qt5Loader;
    		transformer = [inputs.haumea.lib.transformers.liftDefault];
	};
}
	

 

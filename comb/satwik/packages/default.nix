{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs;
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
  }) //{
  	luaPackages = inputs.haumea.lib.load {
		src = ./luaPackages;
		loader = inputs.haumea.lib.loaders.verbatim;
	};

  }

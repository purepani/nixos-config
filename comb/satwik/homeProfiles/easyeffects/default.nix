{
  inputs,
  cell,
}: {
  services.easyeffects = {
    enable = true;
    #package =
    #  (inputs.nixpkgs.easyeffects.overrideAttrs (old: {
    #    buildInputs = old.buildInputs ++ [cell.packages.deepfilter.package];
    #  }))
    #  .override {
    #    speexdsp = inputs.nixpkgs.speexdsp.overrideAttrs (_: {configureFlags = [];});
    #  };
    #package = cell.packages.easyeffects;
  };
}

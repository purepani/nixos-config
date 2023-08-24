{inputs, cell}:
{
  services.easyeffects = {
    enable = true;
    package = inputs.nixpkgs.easyeffects.override {
      speexdsp = inputs.nixpkgs.speexdsp.overrideAttrs (_: {configureFlags = [];});
    };
  };


}

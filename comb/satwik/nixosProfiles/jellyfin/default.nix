{
  inputs,
  cell,
}: 
{
  services.jellyfin = {
    enable = true;
    package = inputs.nixpkgs.jellyfin.override {ffmpeg = inputs.nixpkgs.jellyfin-ffmpeg;};
    openFirewall = true;
  };
}

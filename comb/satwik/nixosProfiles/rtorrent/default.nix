{
  inputs,
  cell,
}: {
  services.rtorrent = {
    enable = true;
    port = 5000;
    openFirewall = true;
    configText = ''
      $scgi_host = "127.0.0.1";
      $scgi_port = 5000;
      $XMLRPCMountPoint = "/RPC2";
    '';
  };
}

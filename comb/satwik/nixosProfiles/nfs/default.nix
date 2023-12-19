{
  inputs,
  cell,
}: {
  fileSystems."/export/media" = {
    device = "/media";
    options = ["bind"];
  };
  services.nfs.server = {
    enable = true;
  };

  services.nfs.server.exports = ''
    /export         192.168.88.8(rw,fsid=0,no_subtree_check)
    /export/media  192.168.88.8(rw,nohide,insecure,no_subtree_check)
  '';

  networking.firewall.allowedTCPPorts = [2049];
}

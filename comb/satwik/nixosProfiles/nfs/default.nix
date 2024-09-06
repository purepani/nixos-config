{
  inputs,
  cell,
}: {
  fileSystems."/export/storage" = {
    device = "/storage";
    options = ["bind"];
  };
  services.nfs.server = {
    enable = true;
  };

  services.nfs.server.exports = ''
    	/storage  192.168.1.50(rw,fsid=0,no_subtree_check)
  '';

}

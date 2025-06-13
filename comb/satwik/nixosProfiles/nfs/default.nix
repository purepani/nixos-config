{ inputs
, cell
,
}: {

  fileSystems."/export/storage" = {
    device = "/storage";
    options = [ "bind" ];
  };
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    #statdPort = 4000;
    createMountPoints = true;

  };
  services.rpcbind.enable = true;
  services.nfs.server.exports = ''
    	/export  *(rw,fsid=0,no_subtree_check,crossmnt)
    	/export/storage  *(rw,no_subtree_check,nohide,insecure)
  '';

  networking.firewall = {
    allowedTCPPorts = [ 111 2049 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4001 4002 20048 ];
  };

}

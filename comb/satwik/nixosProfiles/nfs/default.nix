{ inputs
, cell
,
}: {

  fileSystems."/export/storage" = {
    device = "/storage";
    options = [
      "bind"
      "x-systemd.requires=zfs-mount.service"
    ];
  };

  fileSystems."/export/ven" = {
    device = "/storage/ven";
    options = [
      "bind"
      "x-systemd.requires=zfs-mount.service"
    ];
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
    	/export  *(rw,fsid=0,no_subtree_check)
    	/export/storage  192.168.1.0/24(rw,no_subtree_check,nohide,insecure,crossmnt,no_root_squash) 100.65.84.102(rw,no_subtree_check,nohide,insecure,crossmnt,no_root_squash)
    	/export/ven  192.168.1.0/24(rw,anonuid=12345,anongid=12345,no_subtree_check,nohide,insecure,all_squash,crossmnt) 100.65.100.98(rw,anonuid=12345,anongid=12345,no_subtree_check,nohide,insecure,all_squash,crossmnt)
  '';

  networking.firewall = {
    allowedTCPPorts = [ 111 2049 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4001 4002 20048 ];
  };

}

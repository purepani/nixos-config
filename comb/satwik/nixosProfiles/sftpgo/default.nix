{inputs, cell}: {
	services.sftpgo = {
		enable = true;
		settings = {
			httpd.bindings = [
				{
					address="127.0.0.1";
					port=48080;
				}
			];
			webdavd.bindings = [
				{
					address="127.0.0.1";
					port=38080;
				}
			];

		};
		
	};
	
}

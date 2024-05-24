{ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "nvim-nio";
  version = "1.7.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/nvim-nio-1.7.0-1.rockspec";
    sha256 = "0f9ccrli5jcvcyawkjd99nm6himnnnd6z54938rd0wjp21d8s4s9";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neotest/nvim-nio/archive/v1.7.0.zip";
    sha256 = "0zax50chrh7qrgh56avd5ny0lb3i0y906wk13mhbkp9i5d9anw1h";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/nvim-neotest/nvim-nio";
    description = "A library for asynchronous IO in Neovim";
    license.fullName = "MIT";
  };
}

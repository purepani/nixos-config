{ buildLuarocksPackage, fetchurl, fetchzip, lua, lua-utils-nvim, luaOlder, nui-nvim, nvim-nio, pathlib-nvim, plenary-nvim }:
buildLuarocksPackage {
  pname = "neorg";
  version = "8.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/neorg-8.4.0-1.rockspec";
    sha256 = "1dfdb77gmh3jkd7ibrmvrvx68rp5pzynaryppyjfaqikbdba4gqz";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorg/neorg/archive/v8.4.0.zip";
    sha256 = "1vsf6s4fn6z8hh2al8ahkqg719pz73rmyigl8cjzprcd07i2687f";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua rocks-nvim lua-utils-nvim nui-nvim nvim-nio pathlib-nvim plenary-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neorg/neorg";
    description = "Modernity meets insane extensibility. The future of organizing your life in Neovim.";
    license.fullName = "GPL-3.0";
  };
}

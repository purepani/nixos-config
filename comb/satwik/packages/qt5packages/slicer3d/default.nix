{ stdenv
, autoPatchelfHook
, makeDesktopItem
, glib
, fetchzip
, pulseaudio
, xorg
, zlib
, fontconfig
, libxkbcommon
, libGL
, libGLU
, freetype
, cups
, unixODBC
, libxcrypt-legacy
, hwloc
, alsa-lib
, postgresql
, nss
, nspr
,
}:


let
  pname = "Slicer3D";
  version = "5.6.2";
  old_hwloc = hwloc.overrideAttrs (_: {
    version = "1.4.1";
  });
in
stdenv.mkDerivation {
  inherit pname version;
  src =
    let
      name = "Slicer-${version}-linux-amd64.tar.gz";
    in
    fetchzip {
      inherit name;
      url = "https://slicer-packages.kitware.com/api/v1/item/660f92ed30e435b0e355f1a4/download";
      hash = "sha256-DmJS1yrwJBcAIRnVA8VdsO4u82E1MWX+uvRC+6dEXmM=";
      extension = "tar.gz";
    };


  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    freetype
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    xorg.libXext
    xorg.libX11
    zlib
    stdenv.cc.cc.lib
    libGL
    libGLU
    fontconfig
    xorg.xkbutils
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXtst
    xorg.libXcomposite
    alsa-lib
    postgresql
    libxkbcommon
    glib
    pulseaudio
    cups
    unixODBC
    libxcrypt-legacy
    old_hwloc
    nss
    nspr
  ];
  autoPatchelfIgnoreMissingDeps = [ "libhwloc.so.5" ];
  desktopItems = [
    (makeDesktopItem {
      name = "Slicer3D";
      exec = "Slicer";
      desktopName = "Slicer 3D";
      genericName = "A 3D Slicer Program"; # edit later
      categories = ["Graphics"]; #Edit later
    })
  ];
  installPhase = ''
      	mkdir $out
    	cp -r . $out
  '';
}

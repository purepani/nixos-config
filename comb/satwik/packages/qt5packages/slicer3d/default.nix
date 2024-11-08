{ stdenv
, autoPatchelfHook
, makeDesktopItem
, copyDesktopItems
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
  stability = "release";
  os = "linux";
  old_hwloc = hwloc.overrideAttrs (_: {
    version = "1.4.1";
  });

  desktopItem = makeDesktopItem {
    name = "Slicer3D";
    exec = "../Slicer";
    desktopName = "Slicer 3D";
    genericName = "A 3D Slicer Program"; # edit later
    categories = [ "Graphics" ]; #Edit later
  };
in
stdenv.mkDerivation {
  inherit pname version;
  src =
    let
      name = "Slicer-${version}-linux-amd64.tar.gz";
      url = "http://download.slicer.org/download?os=${os}&stability=${stability}&version=${version}";
    in
    fetchzip {
      inherit name;
      inherit url;
      hash = "sha256-DmJS1yrwJBcAIRnVA8VdsO4u82E1MWX+uvRC+6dEXmM=";
      extension = "tar.gz";
    };

  desktopItems = [
    desktopItem
  ];


  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
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
  installPhase = ''
    		runHook preInstall

        		mkdir $out
        		cp -r . $out
        		mkdir $out/share/applications/
    		cp ${desktopItem}/share/applications/* $out/share/applications/

                    	runHook postInstall
  '';
}

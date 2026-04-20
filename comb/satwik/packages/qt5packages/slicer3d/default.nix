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
, qtwayland
, wrapQtAppsHook
, dcmtk
}:


let
  pname = "Slicer3D";
  version = "5.11.0";
  stability = "nightly";
  os = "linux";

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
      hash = "sha256-nLqZuwrj7T3NwGcNL7mbuvdAVfBdgks71xYcaXdOirQ=";
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
    qtwayland
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
    hwloc
    postgresql
    libxkbcommon
    glib
    pulseaudio
    cups
    unixODBC
    libxcrypt-legacy
    nss
    nspr
  ];

  dontWrapQtApps=true;
  autoPatchelfIgnoreMissingDeps = [ "libhwloc.so.5" ];
  installPhase = ''
    		runHook preInstall
            ls
        		mkdir $out
        		cp -r . $out
        		mkdir $out/share/applications/
    		cp ${desktopItem}/share/applications/* $out/share/applications/

                    	runHook postInstall
  '';
}

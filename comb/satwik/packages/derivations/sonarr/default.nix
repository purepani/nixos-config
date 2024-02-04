{
  lib,
  stdenv,
  fetchurl,
  dotnet-runtime,
  icu,
  ffmpeg,
  openssl,
  sqlite,
  curl,
  makeWrapper,
  nixosTests,
}: let
  os =
    if stdenv.isDarwin
    then "osx"
    else "linux";
  arch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      aarch64-darwin = "arm64";
    }
    ."${stdenv.hostPlatform.system}"
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hash =
    {
      x64-linux_hash = "sha256-XCCqAMxaOk9vGlTDHv7MB6VhTx0ODDTuPxkfvTBeJDk=";
      arm64-linux_hash = "sha256-4jQzgjicPh4AmO2jY3h8YXlTlvIbk4uyDxMpOQtm+HI=";
      x64-osx_hash = "sha256-MYLbAg9oCjWaZEMnSBmLEDEpab9vvcJjI8P8Fdmhmzs=";
      arm64-osx_hash = "sha256-FyHffgNVoS/HPXz2YQGyxRowT04VFKtWZYEvsBZ9t4E=";
    }
    ."${arch}-${os}_hash";
in
  stdenv.mkDerivation rec {
    pname = "sonarr";
    version = "4.0.0.748";

    src = fetchurl {
      url = "https://download.sonarr.tv/v4/main/${version}/Sonarr.main.${version}.${os}-${arch}.tar.gz";
      inherit hash;
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/${pname}-${version}}
      cp -r * $out/share/${pname}-${version}/.

      makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/NzbDrone \
        --add-flags "$out/share/${pname}-${version}/Sonarr.dll" \
        --prefix PATH : ${lib.makeBinPath [ffmpeg]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        curl
        sqlite
        openssl
        icu
      ]}

      runHook postInstall
    '';

    passthru = {
      updateScript = ./update.sh;
      tests.smoke-test = nixosTests.sonarr;
    };

    meta = {
      description = "Smart PVR for newsgroup and bittorrent users";
      homepage = "https://sonarr.tv/";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [fadenb purcell];
      mainProgram = "NzbDrone";
      platforms = lib.platforms.all;
    };
  }

{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  writeText,
  ...
}: let
  defaultConfig = builtins.readFile ./conf.yml.default;
in
  mkYarnPackage rec {
    name = "dashy";
    version = "2.1.1";
    src = fetchFromGitHub {
      owner = "Lissy93";
      repo = name;
      rev = "2ec404121a3b14fe4497996c8786fb5d4eda14e5";
      fetchSubmodules = false;
      sha256 = "sha256-kW/4eAswWboLSwmHpkPOUoOFWxOyxkqb7QBKM/ZTJKw=";
    };

    NODE_OPTIONS = "--openssl-legacy-provider";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      sha256 = "sha256-fyHgMLAZBL0hifUguWe465X6qSX5pOwoX2dQPHEF6hU";
    };

    nativeBuildInputs = [makeWrapper];

    configFile = writeText "conf.yml" defaultConfig;

    patches = [./dashy.patch];
    preConfigure = ''
      rm public/conf.yml
      ln -s $configFile public/conf.yml
    '';
    buildPhase = ''
      export HOME=$(mktemp -d)
      # https://stackoverflow.com/questions/49709252/no-postcss-config-found
      echo 'module.exports = {};' > postcss.config.js
      yarn --offline build --mode production
    '';

    postInstall = ''
      makeWrapper '${nodejs}/bin/node' "$out/bin/dashy" --add-flags "$out/libexec/Dashy/deps/Dashy/server.js"
    '';

    dontFixup = true;
    distPhase = "true";

    meta = with lib; {
      description = "A self-hostable personal dashboard built for you. Includes status-checking, widgets, themes, icon packs, a UI editor and tons more!";
      homepage = "https://dashy.to/";
      license = licenses.mit;
    };
  }

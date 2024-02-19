{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  nodejs,
  runtimeShell,
  ...
}:
buildNpmPackage rec {
  pname = "actual-server";
  version = "24.2.0";

  src = fetchFromGitHub {
    owner = "actualbudget";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9Dx6FxWZvGAgJfYYuEgkLr5dhpe5P+bdiSQWhPVeUu8=";
  };

  npmDepsHash = "sha256-0cP0gGgVsjFry23xOSfk/JR8dF8V1F9Ui+r2aj2o0A0=";

  #nativeBuildInputs = [
  #  python3
  #];

  #postUnpack = ''
  #  rm -rf yarn.lock
  #'';

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  #dontNpmBuild = true;

  postInstall = ''
    # Make an executable to run the server
    mkdir -p $out/bin
    cat <<EOF > $out/bin/actual-server
    #!${runtimeShell}
    cd $out/lib/node_modules/actual-sync
    exec ${nodejs}/bin/node app.js "\$@"
    EOF
    chmod +x $out/bin/actual-server
  '';

  meta = with lib; {
    homepage = "https://github.com/actualbudget/actual-server";
    description = "Actual's server";
    changelog = "https://github.com/actualbudget/actual-server/releases/tag/v${version}";
    mainProgram = pname;
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero];
  };
}

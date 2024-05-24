{ lib
, buildNpmPackage
, fetchurl
}:
let
  version = "0.16.9";
  src = fetchurl {
    url = "https://registry.npmjs.org/svelte-language-server/-/svelte-language-server-${version}.tgz";
    hash = "sha256-RR2RzBZGCyd0hnEX4iD5pjmgtq8GzgrGZAG8Qq63EZA=";
  };
in buildNpmPackage {
  pname = "svelte-language-server";
  inherit version;
  inherit src;


  npmDepsHash = "sha256-WYiWm/2gr/0kXZOYeMjVYZOg0JttghPF9jkwNnb0nQo=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;


  meta = {
    description = "Language server (implementing the language server protocol) for Svelte";
    downloadPage = "https://www.npmjs.com/package/svelte-language-server";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    mainProgram = "svelteserver";
    maintainers = with lib.maintainers; [ ];
  };
}

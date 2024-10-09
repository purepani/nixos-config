{ inputs, cell }: {
  home.packages = [
    inputs.fenix.packages.default.toolchain
  ];
}

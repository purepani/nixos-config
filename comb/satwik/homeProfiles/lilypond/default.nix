{ inputs
, cell
,
}: {
  home.packages = with inputs.nixpkgs; [
    lilypond
  ];
}

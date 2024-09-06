{ inputs, cell }:
{
  nix.settings = {
    experimental-features = "nix-command flakes pipe-operators dynamic-derivations ca-derivations";
    auto-optimise-store = true;
  };

}

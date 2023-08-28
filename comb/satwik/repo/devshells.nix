{ inputs
, cell
}:
let
  inherit (inputs) nixpkgs std;
  l = nixpkgs.lib // builtins;
in
# Here we map an attribute set to the `std.std.lib.mkShell` function.
  # This is a small wrapper around the numtide/devshell `mkShell` function and
  # provides integration with `nixago`, which we'll see in a later part. The
  # result of this map is a attribute set where the value is a proper
  # development shell derivation.
l.mapAttrs (_: std.std.lib.mkShell) {
  # This is our only development shell, so we name it "default". The
  # numtide/devshell `mkShell` function uses modules, so the `{ ... }` here is
  # simply boilerplate.
  default = {
    name = "Nixos Config Devshell";

    imports = [ std.std.devshellProfiles.default ];

    # This is a list of packages that will be available in our development
    # environment. In this case, we're pulling in the rust toolchain from our
    # `toolchains` cell block.
    #
    # Notice the magic here. We can extrapolate the rust toolchain to a separate
    # cell block and then access it from `cell.toolchain`. This is a direct
    # benefit from standardizing our project!
    packages = [
      #inputs.colmena
    ];

    # This is a list of "commands" that will be available inside our development
    # environment. One of the features of numtide/devshell is that it provides
    # a `menu` command that will list all of the commands we define below. This
    # allows consumers to easily understand what development tasks are available
    # to them from the CLI. For example, running `tests` in side of our shell
    # will in turn call `cargo test` for us.
    commands = [
      #{
      #  name = "tests";
      #  command = "cargo test";
      #  help = "run the unit tests";
      #  category = "Testing";
      #}
    ];
  };
}

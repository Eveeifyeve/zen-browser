{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { pkgs, system, ... }: {
        # `nix build` to build the package
        packages.default = pkgs.callPackage ./default.nix { };

        # Simple Dev shell with packages needed to update the package.
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.nodePackages.patch-package ];
        };
    };
  };
}
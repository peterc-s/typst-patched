{
  description = "Typst - patched with newer hayagriva";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        patchedTypst = pkgs.typst.overrideAttrs (old: {
          patches = [./hayagriva.patch];
          cargoDeps = old.cargoDeps.overrideAttrs (old: {
            vendorStaging = old.vendorStaging.overrideAttrs {
              patches = [./hayagriva.patch];
              outputHash = "sha256-5yOkNmnNJt/gLzU7Pwn751vzOxj0f6lriKj+NnUa1t4=";
            };
          });
        });
      in {
        packages.patched-typst = patchedTypst;
        defaultPackage = patchedTypst;
      }
    );
}

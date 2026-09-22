{
  description = "LMMS music production suite from the official AppImage (all plugins bundled)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        lmms-appimage = pkgs.callPackage ./package.nix { };
        default = lmms-appimage;
      });

      overlays.default = final: _prev: {
        lmms-appimage = final.callPackage ./package.nix { };
      };
    };
}

{
  description = "A Nix-flake-based C/Arduino development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    arduino-nix.url = "github:bouk/arduino-nix";
    arduino-index = {
      url = "github:bouk/arduino-indexes";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      self,
      arduino-nix,
      arduino-index,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
            system = system;
            self = self;
          }
        );
    in
    {
      devShells = import ./nix/shell.nix { inherit forEachSupportedSystem; };
      packages = import ./nix/packages.nix { inherit nixpkgs arduino-nix arduino-index; };
    };
}

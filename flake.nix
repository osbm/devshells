{
  description = "Devshells that i need for various tasks.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs = {nixpkgs, ...} @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # Automatically import all devshells from the devshells folder
    importDevshells = system: let
      devshellsDir = ./devshells;
      devshellFiles = builtins.readDir devshellsDir;

      # Filter for .nix files and create devshell attributes
      devshells =
        nixpkgs.lib.mapAttrs' (filename: _fileType: let
          # Remove .nix extension to get the devshell name
          devshellName = nixpkgs.lib.removeSuffix ".nix" filename;
        in {
          name = devshellName;
          value = import (devshellsDir + "/${filename}") {
            inherit inputs system;
          };
        }) (nixpkgs.lib.filterAttrs (
            filename: fileType:
              fileType == "regular" && nixpkgs.lib.hasSuffix ".nix" filename
          )
          devshellFiles);
    in
      devshells;
  in {
    devShells = forAllSystems (
      system:
        importDevshells system
    );
  };
}

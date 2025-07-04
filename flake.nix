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
  in {
    devShells = forAllSystems (system: rec {
      default = python-ai;
      
      # Import devshells from the devshells folder
      flutter = import ./devshells/flutter.nix {
        inherit inputs system;
      };
      
      python-ai = import ./devshells/python-ai.nix {
        inherit inputs system;
      };
      
      gradle8 = import ./devshells/gradle8.nix {
        inherit inputs system;
      };
      
      javascript = import ./devshells/javascript.nix {
        inherit inputs system;
      };
    });
  };
}

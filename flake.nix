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
  outputs = {self, nixpkgs, ... }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    devShells = forAllSystems (system: rec {
      torch-cuda = let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
            cudaSupport = true;
          };
        };
       in pkgs.mkShell {
        packages = with pkgs; [
          (python312.withPackages (
            ppkgs:
              with python312Packages; [
                pip
                torchWithCuda
                torchvision
                torchaudio
                transformers
                pandas
                numpy
                scikit-learn
                matplotlib
                seaborn
              ]
          ))
        ];
        shellHook = ''
          echo Activating AI CUDA environment
        '';
      };
      torch = let
        pkgs = import nixpkgs {
          inherit system;
        };
        in
        pkgs.mkShell {
        packages = with pkgs; [
          (python312.withPackages (
            ppkgs:
              with python312Packages; [
                pip
                torch
                torchvision
                torchaudio
                transformers
                pandas
                numpy
                scikit-learn
                matplotlib
                seaborn
              ]
          ))
        ];
        shellHook = ''
          echo Activating AI environment without CUDA
        '';
      };
      gradle8 = let
        pkgs = import nixpkgs {
          inherit system;
        };
       in
        pkgs.mkShell {
        packages = with pkgs; [
          gradle_8
        ];
        shellHook = ''
          echo Activating Gradle 8 environment
        '';
      };
      gradle7 =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.mkShell {
        packages = with pkgs; [
          gradle_7
        ];
        shellHook = ''
          echo Activating Gradle 7 environment
        '';
      };
      default = torch-cuda;
    });
  };
}
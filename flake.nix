{
  description = "Devshells that i need for various tasks.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
      default = torch-cuda;
    });
  };
}
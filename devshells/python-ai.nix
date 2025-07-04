{
  inputs,
  system,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
      cudaSupport = true;
    };
  };
in
  pkgs.mkShell {
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
  }

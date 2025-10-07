{
  inputs,
  system,
  cudaSupport ? true,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
      cudaSupport = cudaSupport;
    };
  };

  # Choose torch package based on CUDA support
  torchPackage =
    if cudaSupport
    then pkgs.python312Packages.torchWithCuda
    else pkgs.python312Packages.torch;

  # Environment message based on CUDA support
  envMessage =
    if cudaSupport
    then "AI CUDA environment"
    else "AI CPU environment";
in
  pkgs.mkShell {
    packages = with pkgs; [
      (python312.withPackages (
        ppkgs:
          with python312Packages; [
            pip
            torchPackage
            torchvision
            torchaudio
            transformers
            pandas
            numpy
            scikit-learn
            matplotlib
            seaborn
            tqdm
          ]
      ))
    ];
    shellHook = ''
      echo Activating ${envMessage}
    '';
  }

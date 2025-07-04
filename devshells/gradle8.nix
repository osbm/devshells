{
  inputs,
  system,
  ...
}: let
  pkgs = import inputs.nixpkgs {
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
  }

{
  inputs,
  system,
  ...
}: let
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
  }

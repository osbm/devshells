{
  inputs,
  ...
}:

let
        pkgs = import nixpkgs {
          inherit system;
        };

in
  pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            yarn
          ];
          shellHook = ''
            echo Activating Node.js environment
          '';
        };


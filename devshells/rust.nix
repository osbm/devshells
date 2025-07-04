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
      # Rust toolchain
      rustc
      cargo
      rustfmt
      rust-analyzer
      clippy

      # Build dependencies
      pkg-config
      openssl
    ];

    shellHook = ''
      echo "🦀 Activating Rust development environment"
    '';
  }

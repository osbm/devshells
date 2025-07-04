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
  outputs = {nixpkgs, ...}: let
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
      gradle7 = let
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
      javascript = let
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
      flutter = let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        buildToolsVersion = "34.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [buildToolsVersion "30.0.3"];
          platformVersions = ["29" "30" "31" "32" "33" "34" "35" "28"];
          abiVersions = ["armeabi-v7a" "arm64-v8a"];
          cmakeVersions = ["latest" "3.22.1"];
          includeEmulator = true;
          emulatorVersion = "34.1.19";
          includeNDK = true;
          ndkVersions = ["22.0.7026061" "26.3.11579264"];
          useGoogleTVAddOns = false;
          extraLicenses = [
            "android-googletv-license"
            "android-sdk-arm-dbt-license"
            "android-sdk-license"
            "android-sdk-preview-license"
            "google-gdk-license"
            "intel-android-extra-license"
            "intel-android-sysimage-license"
            "mips-android-sysimage-license"
          ];
        };
        androidSdk = androidComposition.androidsdk;
      in
        pkgs.mkShell {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          CHROME_EXECUTABLE = "${pkgs.ungoogled-chromium}/bin/chromium";
          JAVA_HOME = "${pkgs.jdk.home}";

          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
          buildInputs = with pkgs; [
            flutter
            androidSdk
            jdk17
            ungoogled-chromium
            android-studio-full
          ];
        };
      default = torch-cuda;
    });
  };
}

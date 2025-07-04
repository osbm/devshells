{
  inputs,
  system,
  ...
}: let
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
  }

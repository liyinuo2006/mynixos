{
  lib,
  stdenvNoCC,
  rustPlatform,
  flutter341,
  fetchFromGitHub,
  python3,
  gitMinimal,
  nodejs,
  typescript,
  pkg-config,
  cmake,
  ninja,
  clang,
  gtk3,
  webkitgtk_4_1,
  gst_all_1,
  glib-networking,
  libsecret,
  xz,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  version = "2.0.0-preview.13";
  src = fetchFromGitHub {
    owner = "AAswordman";
    repo = "Operit2";
    rev = "ea96a90d51883268f87344b4bb8f3e3081a72b66";
    hash = "sha256-cV7rseoEGMqsz6DZilkwJ+zONdcDWfw9xTs7AefjWzo=";
  };
  patchSource = ./operit2-desktop/patch-source.py;
  pluginAssets = stdenvNoCC.mkDerivation {
    pname = "operit2-builtin-plugin-assets";
    inherit version src;

    nativeBuildInputs = [
      gitMinimal
      nodejs
      python3
      typescript
    ];

    postPatch = ''
      python3 ${patchSource} "$PWD"
    '';

    buildPhase = ''
      runHook preBuild

      git init --quiet
      git add --force --all
      export OPERIT_NIX_BUILD=1
      python3 plugins/tools/sync_plugin_packages.py --source buildin --no-hot-reload

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/plugins"
      cp -a core/crates/runtime/application/assets/plugins/buildin "$out/plugins/buildin"

      runHook postInstall
    '';
  };

  flutterBridge = rustPlatform.buildRustPackage {
    pname = "operit2-flutter-bridge";
    inherit version src;

    cargoRoot = "apps/flutter/native/operit-flutter-bridge";
    buildAndTestSubdir = "apps/flutter/native/operit-flutter-bridge";
    cargoLock.lockFile = "${src}/apps/flutter/native/operit-flutter-bridge/Cargo.lock";
    cargoBuildFlags = [ "--lib" ];
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    doCheck = false;

    postPatch = ''
      python3 ${patchSource} "$PWD"
      mkdir -p core/crates/runtime/application/assets/plugins
      cp -a ${pluginAssets}/plugins/buildin core/crates/runtime/application/assets/plugins/buildin
    '';
  };

  gstPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ];
in
flutter341.buildFlutterApplication {
  pname = "operit2-desktop";
  inherit version src;

  sourceRoot = "${src.name}/apps/flutter/app";
  pubspecLock = lib.importJSON ./operit2-desktop/pubspec.lock.json;
  gitHashes = {
    path_provider_ohos = "sha256-KQ1NB3eVVLRPZfl5eYMfMcg98su4kzYE8Iv4x6PkHu8=";
    url_launcher_ohos = "sha256-KQ1NB3eVVLRPZfl5eYMfMcg98su4kzYE8Iv4x6PkHu8=";
    video_player_ohos = "sha256-KQ1NB3eVVLRPZfl5eYMfMcg98su4kzYE8Iv4x6PkHu8=";
  };

  nativeBuildInputs = [
    clang
    cmake
    copyDesktopItems
    gitMinimal
    ninja
    nodejs
    pkg-config
    python3
    typescript
  ];

  buildInputs = [
    flutterBridge
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    gtk3
    libsecret
    webkitgtk_4_1
    xz
  ];

  env = {
    OPERIT_FLUTTER_BRIDGE_LIB = "${flutterBridge}/lib/liboperit_flutter_bridge.so";
    OPERIT_NIX_BUILD = "1";
  };

  postPatch = ''
    python3 ${patchSource} "$PWD/../../.."
    mkdir -p ../../../core/crates/runtime/application/assets/plugins
    cp -a ${pluginAssets}/plugins/buildin ../../../core/crates/runtime/application/assets/plugins/buildin
  '';

  postInstall = ''
    mv "$out/bin/operit2" "$out/bin/operit2-desktop"
    install -Dm644 \
      "${src}/apps/flutter/app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" \
      "$out/share/icons/hicolor/192x192/apps/operit2.png"
  '';

  extraWrapProgramArgs = ''
    --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.makeSearchPath "lib/gstreamer-1.0" gstPlugins}" \
    --set GST_PLUGIN_SCANNER "${gst_all_1.gstreamer}/libexec/gstreamer-1.0/gst-plugin-scanner"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "operit2-desktop";
      exec = "operit2-desktop";
      icon = "operit2";
      desktopName = "Operit2";
      genericName = "AI Agent Desktop Application";
      categories = [ "Utility" ];
      terminal = false;
    })
  ];

  meta = {
    description = "Operit2 AI Agent desktop application";
    homepage = "https://github.com/AAswordman/Operit2";
    license = lib.licenses.agpl3Only;
    mainProgram = "operit2-desktop";
    platforms = [ "x86_64-linux" ];
  };
}

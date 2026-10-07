{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  src = fetchFromGitHub {
    owner = "AAswordman";
    repo = "Operit2";
    rev = "ea96a90d51883268f87344b4bb8f3e3081a72b66";
    hash = "sha256-cV7rseoEGMqsz6DZilkwJ+zONdcDWfw9xTs7AefjWzo=";
  };
in
rustPlatform.buildRustPackage {
  pname = "operit2-cli";
  version = "2.0.0-preview.13";

  inherit src;
  cargoRoot = "apps/cli";
  cargoLock.lockFile = "${src}/apps/cli/Cargo.lock";
  cargoBuildFlags = [ "--bin" "operit2" ];
  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  # 上游 Linux 发布流程构建 CLI，但不运行 cargo test。
  doCheck = false;

  postInstall = ''
    ln -s operit2 "$out/bin/operit"
  '';

  meta = {
    description = "Operit2 Agent CLI and TUI";
    homepage = "https://github.com/AAswordman/Operit2";
    license = lib.licenses.agpl3Only;
    mainProgram = "operit2";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}

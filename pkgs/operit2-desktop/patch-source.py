#!/usr/bin/env python3
"""为 Nix 桌面构建替换上游依赖用户环境的步骤。"""

from pathlib import Path
import sys


def replace_once(path: Path, old: str, new: str) -> None:
    content = path.read_text(encoding="utf-8")
    if old not in content and new in content:
        return
    if content.count(old) != 1:
        raise SystemExit(f"预期只找到一次待替换文本：{path}")
    path.write_text(content.replace(old, new), encoding="utf-8")


root = Path(sys.argv[1]).resolve()
cmake_only = "--cmake-only" in sys.argv[2:]
runner = root / "apps/flutter/app/linux/runner/CMakeLists.txt"
replace_once(
    runner,
    'set(OPERIT_PLUGIN_SYNC_PYTHON "${OPERIT_REPO_ROOT}/.venv/bin/python")',
    'set(OPERIT_PLUGIN_SYNC_PYTHON "python3")',
)
replace_once(
    runner,
    'COMMAND "${OPERIT_PLUGIN_SYNC_PYTHON}" "${OPERIT_PLUGIN_SYNC_SCRIPT}" --source buildin --no-hot-reload',
    'COMMAND "${CMAKE_COMMAND}" -E true',
)
replace_once(
    runner,
    'COMMAND cargo build --manifest-path "${OPERIT_FLUTTER_BRIDGE_CRATE}/Cargo.toml" $<$<NOT:$<CONFIG:Debug>>:--release>',
    'COMMAND "${CMAKE_COMMAND}" -E true',
)
install_cmake = root / "apps/flutter/app/linux/CMakeLists.txt"
replace_once(
    install_cmake,
    '"${OPERIT_FLUTTER_BRIDGE_CRATE}/target/$<IF:$<CONFIG:Debug>,debug,release>/liboperit_flutter_bridge.so"',
    '"$ENV{OPERIT_FLUTTER_BRIDGE_LIB}"',
)
flutter_hook = root / "apps/flutter/app/hook/build.dart"
replace_once(
    flutter_hook,
    "    final syncScript = File.fromUri(\n"
    "      input.packageRoot.resolve(\n"
    "        '../../../plugins/tools/sync_plugin_packages.py',\n"
    "      ),\n"
    "    );",
    "    // 内置插件资源已由 Nix 的独立 derivation 同步。",
)
replace_once(
    flutter_hook,
    "    await _run(_pythonExecutable(repoRoot), [\n"
    "      syncScript.path,\n"
    "      '--source',\n"
    "      'buildin',\n"
    "      '--no-hot-reload',\n"
    "    ], workingDirectory: repoRoot.path);",
    "    // 内置插件资源已由 Nix 的独立 derivation 同步。",
)
replace_once(
    flutter_hook,
    "String _pythonExecutable(Directory repoRoot) {\n"
    "  if (Platform.isWindows) {\n"
    "    return File.fromUri(repoRoot.uri.resolve('.venv/Scripts/python.exe')).path;\n"
    "  }\n"
    "  return File.fromUri(repoRoot.uri.resolve('.venv/bin/python')).path;\n"
    "}",
    "// Nix 构建的插件同步由独立 derivation 完成，不走用户 venv。",
)

if cmake_only:
    raise SystemExit(0)

linux_system = root / "hosts/linux/src/tools/system/mod.rs"
replace_once(
    linux_system,
    r'''fn linux_screen_resolution() -> HostResult<String> {
    let output = command_stdout("sh", &["-lc", "xrandr --current | sed -n 's/.* current \\([0-9][0-9]*\\) x \\([0-9][0-9]*\\).*/\\1x\\2/p' | head -n 1"], "read Linux screen resolution")?;
    if output.trim().is_empty() {
        return Err(HostError::new(
            "xrandr did not return a current screen resolution",
        ));
    }
    Ok(output)
}''',
    r'''fn linux_screen_resolution() -> HostResult<String> {
    let output = match Command::new("xrandr").arg("--current").output() {
        Ok(output) if output.status.success() => {
            String::from_utf8_lossy(&output.stdout).into_owned()
        }
        Ok(output) => {
            eprintln!(
                "xrandr could not query a display: {}",
                String::from_utf8_lossy(&output.stderr).trim()
            );
            return Ok("unknown".to_string());
        }
        Err(error) => {
            eprintln!("xrandr is unavailable: {error}");
            return Ok("unknown".to_string());
        }
    };
    let resolution = Regex::new(r"current\s+([0-9]+)\s+x\s+([0-9]+)")
        .expect("static screen resolution regex");
    if let Some(captures) = resolution.captures(&output) {
        let width = captures.get(1).and_then(|value| value.as_str().parse::<u32>().ok());
        let height = captures.get(2).and_then(|value| value.as_str().parse::<u32>().ok());
        if let (Some(width), Some(height)) = (width, height) {
            if width > 0 && height > 0 {
                return Ok(format!("{width}x{height}"));
            }
        }
    }
    eprintln!("xrandr did not report a current resolution; using unknown");
    Ok("unknown".to_string())
}''',
)

sync_script = root / "plugins/tools/sync_plugin_packages.py"
replace_once(
    sync_script,
    'def _is_script_packed_toolpkg(folder: Path) -> bool:\n',
    'def _is_script_packed_toolpkg(folder: Path) -> bool:\n'
    '    if os.environ.get("OPERIT_NIX_BUILD") == "1":\n'
    '        return False\n',
)
replace_once(
    sync_script,
    '    _generate_plugin_sdk_types(repo_root, dry_run=bool(args.dry_run))',
    '    if os.environ.get("OPERIT_NIX_BUILD") != "1":\n'
    '        _generate_plugin_sdk_types(repo_root, dry_run=bool(args.dry_run))',
)
replace_once(
    sync_script,
    '            archive.write(file_path, file_path.relative_to(source_folder).as_posix())',
    '            zip_info = zipfile.ZipInfo(\n'
    '                file_path.relative_to(source_folder).as_posix(),\n'
    '                date_time=(1980, 1, 1, 0, 0, 0),\n'
    '            )\n'
    '            zip_info.compress_type = zipfile.ZIP_DEFLATED\n'
    '            zip_info.external_attr = (file_path.stat().st_mode & 0xFFFF) << 16\n'
    '            with file_path.open("rb") as source_file:\n'
    '                archive.writestr(zip_info, source_file.read())',
)

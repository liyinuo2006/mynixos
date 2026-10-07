#!/usr/bin/env python3
"""为 Nix 桌面构建替换上游依赖用户环境的步骤。"""

from pathlib import Path
import sys


def replace_once(path: Path, old: str, new: str) -> None:
    content = path.read_text(encoding="utf-8")
    if old not in content and content.count(new) == 1:
        return
    if content.count(old) != 1:
        raise SystemExit(f"预期只找到一次待替换文本：{path}")
    path.write_text(content.replace(old, new), encoding="utf-8")


root = Path(sys.argv[1]).resolve()
runner = root / "apps/flutter/app/linux/runner/CMakeLists.txt"
replace_once(
    runner,
    'set(OPERIT_PLUGIN_SYNC_PYTHON "${OPERIT_REPO_ROOT}/.venv/bin/python")',
    'set(OPERIT_PLUGIN_SYNC_PYTHON "python3")',
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

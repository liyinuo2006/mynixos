# AGENTS.md — mynixos

Orion 的单机 NixOS flake，唯一配置输出是 `nixosConfigurations.mynixos`，硬件目录是
`hosts/vostro-3420/`。

## 硬性规则

- OpenCode 在任何时候都不得手动运行 Nix 求值、诊断、格式化或构建验证：包括 `nix eval`、
  `nix-instantiate`、`nix repl` 和 `nixos-rebuild`。最终切换由用户执行。
- `nixd` 诊断和 `nixfmt` 格式化由 OpenCode/Zed 自动处理；OpenCode 和用户都不要手动调用它们。
  Zed 与 OpenCode 的配置共用 `modules/hm/common/nixd.nix`，改补全源、格式化或 suppress 只改这一处。
- 未发现 README、CI 或任务运行器配置；不要猜测 npm、pytest 等命令。非 Nix 检查可用
  `git diff --check`。

## 配置入口

- 入口链是 `flake.nix` → `hosts/vostro-3420/default.nix` → NixOS 模块与
  `home/orion/default.nix` → Home Manager 模块。
- 各模块目录通过 `default.nix` 聚合导入；新增模块必须挂到对应聚合器，不能绕过 module system。
- `modules/hm/common/` 是被模块直接 `import` 的共享数据，不是模块目录。

## 不可随意破坏的约定

- 不要修改 `modules/hm/ai-agent/opencode.nix`；当前会话依赖它的 OpenCode、nixd 和 formatter 配置。
- `modules/hm/desktop/niri-config/` 由 `modules/hm/desktop/niri.nix` 递归挂载到
  `~/.config/niri`，包括 `test/`；改 Niri 直接改 `.kdl`，不要在 Nix 中重写。
- ZIP 的双击默认处理程序在 `modules/hm/desktop/env.nix` 中设为 Nautilus；`unzip` 等包是命令行工具，
  不要用 File Roller 替代该行为。
- 微信/WPS 在 `modules/hm/programs/packages.nix` 中通过 `symlinkJoin` + `wrapProgram` 包装以接入 fcitx；
  升级时只换包名，不要破坏包装参数。
- Niri 内屏当前 scale 是 `1.5`；fcitx5 的 XWayland 候选框依赖 `Xft.dpi = 144`。修改
  `outputs.kdl` 的 scale 时，必须同步检查 `fcitx5-rime-ice.nix` 与 `miscellaneous.kdl`。
- fish 别名集中在 `modules/hm/programs/shell.nix`；`oc` 会设置三个 `OPENCODE_*` 环境变量后启动 OpenCode。
- system/home 的 `stateVersion` 都是 `"26.05"`，未明确理解迁移影响前不要修改。
- `hosts/vostro-3420/hardware-configuration.nix` 由安装器生成，包含 Btrfs 的 `root`、`home`、`nix` 子卷；
  修改前先备份。
- 注释使用中文；避免为单机配置引入不必要的抽象。

## Inputs 与操作

- 根 `nixpkgs` 是 `nixos-unstable`；Home Manager、Zen beta 和 Spicetify 跟随根 nixpkgs。
  Noctalia 保持独立的 nixpkgs，AyuGram 使用带 submodules 的 Git input，不要擅自改这些关系。
- 缓存配置同时存在于 `flake.nix` 和 `modules/nixos/core/nix.nix`，内容并不完全相同；修改缓存时检查两处。
- 涉及上游模块选项、包名或版本时，先用 websearch 查询当前资料，不要凭旧记忆猜测。
- 用户执行系统切换：`sudo nixos-rebuild switch --flake .#mynixos`。
- 用户更新输入：`nix flake update` 或 `nix flake lock --update-input <name>`。

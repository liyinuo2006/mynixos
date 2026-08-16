# AGENTS.md — mynixos

Orion 的单机 NixOS flake，唯一配置输出是 `nixosConfigurations.mynixos`，硬件目录是
`hosts/vostro-3420/`。

## 硬性规则

- OpenCode 在任何时候都不得手动运行 Nix 求值、诊断、格式化或构建验证：包括 `nix eval`、
  `nix-instantiate`、`nix repl` 和 `nixos-rebuild`。最终切换由用户执行。
- `nixd` 诊断和 `nixfmt` 格式化由 OpenCode/Zed 自动处理；OpenCode 和用户都不要手动调用它们。
  Zed 与 OpenCode 的配置共用 `modules/hm/common/nixd.nix`，改补全源、格式化或 suppress 只改这一处。

## 配置入口

- 入口链是 `flake.nix` → `hosts/vostro-3420/default.nix` → NixOS 模块与
  `home/orion/default.nix` → Home Manager 模块。
- 各模块目录通过 `default.nix` 聚合导入；新增模块必须挂到对应聚合器，不能绕过 module system。
- `modules/_trash/` 是废弃配置垃圾桶：不会被任何 default.nix 导入，扔进去的文件等系统切换
  确认无误后再删；不要从里面 import 任何东西。
- `modules/hm/common/` 是被模块直接 `import` 的共享数据，不是模块目录。

## 不可随意破坏的约定

- 不要修改 `modules/hm/ai-agent/opencode2.nix`；当前会话依赖它的 OpenCode 安装
  （opencode2 是 OpenCode v2 的程序名，不是迁移命名）。
- `modules/hm/desktop/niri-config/` 由 `modules/hm/desktop/niri.nix` 递归挂载到
  `~/.config/niri`，包括 `test/`；改 Niri 直接改 `.kdl`，不要在 Nix 中重写。
- 微信/WPS 在 `modules/hm/programs/packages.nix` 中通过 `symlinkJoin` + `wrapProgram` 包装以接入 fcitx；
  升级时只换包名，不要破坏包装参数。
- `wallpaper/` 是运行时路径：Noctalia 直接读 `~/mynixos/wallpaper`（`modules/hm/desktop/noctalia.nix`，
  不是 store 路径），加/删壁纸只是放文件进目录，不需要 rebuild。该目录已被 `.gitignore` 忽略，
  不入仓库，新增壁纸直接放文件即可。
- Niri 内屏当前 scale 是 `1.5`；fcitx5 的 XWayland 候选框依赖 `Xft.dpi = 144`。修改
  `outputs.kdl` 的 scale 时，必须同步检查 `fcitx5-rime-ice.nix` 与 `miscellaneous.kdl`。
- fish 别名集中在 `modules/hm/programs/shell.nix`；`oc` 会设置三个 `OPENCODE_*` 环境变量后启动 OpenCode。
- system/home 的 `stateVersion` 都是 `"26.05"`，未明确理解迁移影响前不要修改。
- `hosts/vostro-3420/hardware-configuration.nix` 由安装器生成，挂载 Btrfs 多子卷
  （`@`、`@home`、`@nix`、`@snapshots`、`@swap`）与 vfat ESP；修改前先备份。
- Home Manager 的 `backupFileExtension = "hm-backup"`（`hosts/vostro-3420/default.nix`）：
  手动改动 HM 托管的 `~/.config` 文件后，下次 rebuild 原文件会被改名为 `*.hm-backup` 并被覆盖，不要依赖手动改动。
- Hermes 的 NixOS 服务（`services.hermes-agent`）已废弃：配置在
  `modules/_trash/nixos/hermes-agent.nix`（未被导入，确认后删除）。
- Hermes 的 HM 用户级入口 `modules/hm/ai-agent/hermes.nix`：从 `hermes-agent`
  （Tier 2 无 CI 的 flake，保持独立 nixpkgs pin）取包安装，密钥放 `~/.hermes/.env`，
  升级前先查上游提交再 `nix flake lock --update-input hermes-agent`。
- `modules/hm/ai-agent/` 只有 OpenCode（opencode2）与 Hermes CLI 的安装配置；
  Hermes 的 NixOS 服务已废弃（见上），不再有 `modules/nixos/ai-agent/`。
- 注释使用中文；避免为单机配置引入不必要的抽象。

## Inputs 与操作

- 根 `nixpkgs` 是 `nixos-unstable`；Home Manager、Zen beta 和 Spicetify 跟随根 nixpkgs。
  Noctalia 和 fcitx5-vinput 保持独立的 nixpkgs，AyuGram 使用带 submodules 的 Git input，不要擅自改这些关系。
- 缓存与信任密钥唯一维护点是 `flake.nix` 的 `nixConfig`：flake 元数据只支持静态子集、
  不能 import，所以字面写在 flake.nix，`modules/nixos/core/nix.nix` 通过
  `(import ../../../flake.nix).nixConfig` 读取，两侧共用一份；新增带 cachix 缓存的包时
  只改 flake.nix，否则构建会尝试官方源。
- 涉及上游模块选项、包名或版本时，先用 websearch 查询当前资料，不要凭旧记忆猜测。
- 用户执行系统切换：`sudo nixos-rebuild switch --flake .#mynixos`。
- 用户更新输入：`nix flake update` 或 `nix flake lock --update-input <name>`。

# AGENTS.md — mynixos

Orion 的个人 NixOS flake,仅管理单台机器(配置名 `mynixos`,目录 `hosts/vostro-3420/`)。

## 关于本文件

由 opencode 自动注入每次会话的提示词,**阅读对象是 AI**,用户仅审查。写内容时只放
"不告诉就会踩坑" 的事实,能靠读代码得出的不收录。

## 自动化已接管,AI 不要重复做

opencode 已在 `modules/hm/ai-agent/opencode.nix` 配置好:

- **自动格式化**:AI 改完 `.nix` 后 opencode 自动跑 `nixfmt`,不要自己手动 `nix fmt`。
- **自动语法校验**:内置 nixd LSP,改完即验,出错会把诊断注入回 AI 上下文。
  **无须自己跑 `nixos-rebuild build` / `switch` / `nix-instantiate` 验证语法**——
  构建成本高,用户会自己构建测试。
- 因此 AI 的职责只剩:**逻辑正确、风格一致、符合约定**。

## 模型知识可能落后,NixOS 先搜后答

- nixpkgs/NixOS 迭代快,模型训练知识滞后。凡涉及上游行为、模块选项、包版本、
  stateVersion 等可能随时间变化的内容,**先用 websearch 搜最新资料**再下结论或动手。

## 用户是 NixOS 初学者

- 非必要不给仓库引入复杂性(新抽象、新框架、过度参数化都算)。
- 发现现有写法可用更高级的 nix 函数/惯用法优化时,**主动指出并解释**,帮用户成长。
- 用户不懂术语、表达含糊时,**积极提问确认意图**,别猜;回答时说明信息来源
  (读了哪个文件、依据哪条配置),便于用户复核。

## 维护本文件的责任

- 改了模块结构/约定/命令后,**主动同步更新本文件**相应章节。
- 用户改仓库后不告知 AI。发现本文件与代码冲突(目录、命令、约定对不上)时,
  **以可执行代码为准**,主动修正本文件。

## 仓库结构(聚合链)

- 入口:`flake.nix` → `hosts/vostro-3420/default.nix` → 导入 `modules/nixos/*` +
  `home/orion/default.nix`(后者导入 `modules/hm/*`)。
- 所有模块经各级 `default.nix` 聚合导入,**新增模块要挂到对应 `default.nix`,
  不要绕过 module system**。
- `modules/nixos/`:`core/` 基础、`wm/` niri、`programs/` clash/nautilus/packages/polkit、`dm/` LY。
- `modules/hm/`:`desktop/` niri 配置+noctalia、`i18n/` fcitx5-rime-ice + language、
  `programs/` fish/git/zed/zen-browser/spotify/terminal(kitty)/packages、`ai-agent/` opencode。

## 硬约定

- **格式化**:仅 `nixfmt`,禁止其他 Nix formatter。
- **LSP**:仅 `nixd`;`nil` 在 `zed-editor.nix` 被显式禁用;
  `sema-extra-with` 已在两处(zed + opencode)的 nixd 配置里 suppress。
- **注释**:全仓库中文。
- **shell**:fish + starship;别名集中在 `modules/hm/programs/shell.nix`,
  加别名去那里,别散落别处。
- **stateVersion**:`system` 和 `home` 均为 `"26.05"`,未理解影响前不要动。
- **Btrfs**:root/home/nix 三个子卷;`hosts/vostro-3420/hardware-configuration.nix`
  由安装器生成,手改前先备份。

## 环境陷阱(易踩)

- **不要动 opencode 自身配置**(`modules/hm/ai-agent/opencode.nix`)——
  本仓库就是用这个 opencode 打开的,改坏了会打断当前会话。
- **niri 配置**目录 `modules/hm/desktop/niri-config/*.kdl`,经
  `modules/hm/desktop/niri.nix` 的 `xdg.configFile` 整体挂到 `~/.config/niri`
  (整个目录原样带入,含 `test/` 子目录)。改 niri 直接改那些 `.kdl` 源文件,
  不要在 nix 里重写。
- **WeChat / WPS** 经 fcitx 中文环境变量包装(`modules/hm/programs/packages.nix`
  里的 `symlinkJoin` + `wrapProgram`),升级版本时只换包名,别动 wrap 逻辑。
- **Xft.dpi 与屏幕 scale 绑定**:fcitx5 候选框在 XWayland 应用(微信/WPS)里按
  `Xft.dpi` 渲染,当前固定 144 = 96 × 内屏 scale 1.5(`fcitx5-rime-ice.nix` 的
  `xresources.properties` + niri `miscellaneous.kdl` 的 xrdb 加载)。改 niri
  outputs.kdl 的 scale 时必须同步改这里,否则候选框又变小。
- fish 别名 `oc` = `OPENCODE_ENABLE_EXA=1 OPENCODE_EXPERIMENTAL=true
  OPENCODE_EXPERIMENTAL_PARALLEL=true opencode`,排查 opencode 行为差异时先想到它。

## Inputs 与缓存

- `nixpkgs`: nixos-unstable;`home-manager` follows nixpkgs;
  `zen-browser`(beta 分支)follows nixpkgs + home-manager;`noctalia` 走 cachix;
  `spicetify-nix`(Gerg-L) follows nixpkgs,HM 模块见 `modules/hm/programs/spotify.nix`。
- substituters:清华镜像 → cache.nixos.org → nix-community → noctalia(见 `flake.nix`)。
- 常用命令(用户执行,AI 正常无须跑):

```bash
sudo nixos-rebuild switch --flake .#mynixos   # 切换(用户)
nixos-rebuild build --flake .#mynixos         # 仅构建(用户)
nix flake update                              # 更新 inputs
nix flake lock --update-input <name>          # 更新单个 input
```
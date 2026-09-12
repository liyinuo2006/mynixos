# Obsidian（Electron 应用）。这里只装包 + 生成 ~/.config/obsidian/obsidian.json，
# 故意不在 `vaults` 里声明任何设置：模块声明的 `.obsidian/*.json`/插件目录会变成指向
# nix store 的只读软链，Obsidian 里改主题、热键、插件开关都写不进去（会报写失败，
# 重启回到 nix 里的值）。vault 内部的配置交给 Obsidian 自己管。
{ ... }:

{
  programs.obsidian = {
    enable = true;

    # 打开 Obsidian 内置 CLI 的开关（等价于 Settings → General → Command line interface），
    # 配合 nixpkgs 自带的 `obsidian-cli` 命令用（要求 Obsidian ≥ 1.12.4，当前 1.13.4）。
    cli.enable = true;

    # vaults 故意留空：GUI 里新建/打开的 vault 由 Obsidian 自己写进 obsidian.json，
    # HM 激活时用 jq 递归合并会保留这些条目（模块只强制 updateDisabled = true）。
  };
}

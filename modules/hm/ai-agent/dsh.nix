# DeepSeek Harness (dsh) —— 声明式插件管理（Moraxyc/deepseek-harness.nix）
#
# 概念速记（详见官方文档 docs/user/develop/basic/publish.md）：
# - bundle  ：带合格证(dsh.bundle.patch)的插件包，pkgs.dsh.bundles.*
# - profile ：一份独立启动配置（bundle 列表 + 自己的 cordis.patch.yml）
# - preset  ：Moraxyc 预搭配好的套餐，pkgs.dsh.presets.*
# - 层叠顺序：base → 声明的 bundle(按序) → profile patch → ~/.dsh/cordis.patch.yml
#
# 本配置选型（对应 Moraxyc presets.web-ui 套餐）：
# - 组合 = base + headless + web-app + web-ui
#   * headless/web-app 是默认组合自带的（headless 让终端也能跑任务，不用删）
#   * web-ui 是社区 UI 主题组件，写在这里是因为它要"覆盖"在 web-app 之上
# - mode = mutable：Nix 只在目录不存在时初始化一次，之后 profile 归
#   dsh plugin 手动管理（routing-suite 等命令式插件不会被还原）；
#   想回到全声明式就改回 managed（手动改动会被还原）
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.deepseek-harness.homeModules.default ];

  # dsh 命令加入 PATH（启动 web 界面：终端敲 dsh 回车）
  home.packages = [ pkgs.dsh.dsh ];

  programs.dsh = {
    enable = true;

    # 唯一 profile：nix-web-ui，日常默认用它
    profiles.web-ui = {
      # 想加/换插件就改这里，例如：
      #   bundles = [ pkgs.dsh.bundles.web-app pkgs.dsh.bundles.web-ui pkgs.dsh.bundles.vision-toolkit ];
      # 完整清单见 Moraxyc 仓库 docs/bundles-presets.zh-CN.md（bundles.ads/at-file/tui/...）
      bundles = [
        pkgs.dsh.bundles.web-app
        pkgs.dsh.bundles.web-ui
      ];
      mode = "mutable";
      # 想写自己的 cordis.patch.yml 层（bundle 之后应用）：
      #   patch = ''
      #     - insert:
      #         - id: my-thing
      #           name: my-plugin
      #   '';
    };

    # 不带 --profile 启动时默认用这个（注意带 nix- 前缀）
    defaultProfile = "nix-web-ui";
  };
}

_: {
  programs.fish = {
    enable = true;

    interactiveShellInit = "
    set -g fish_greeting
    ";

    shellAliases = {
      ll = "ls -lh";
      la = "ls -lha";
      "..." = "cd ../..";
      f = "set -gx http_proxy http://127.0.0.1:7892; set -gx https_proxy http://127.0.0.1:7892; set -gx all_proxy http://127.0.0.1:7892; set -gx no_proxy 'localhost,127.0.0.1,::1'; echo '✅ 代理已开启'";
      uf = "set -e http_proxy https_proxy all_proxy no_proxy; echo '❌ 代理已关闭'";
    };

  };
  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    presets = [ "nerd-font-symbols" ];
  };
}

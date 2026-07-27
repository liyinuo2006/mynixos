{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];

    userSettings = {
      languages = {
        Nix = {
          # 只用 nixd，禁用 nil（解决 Failed to run nil）
          language_servers = [
            "nixd"
            "!nil"
          ];

          # 用官方 nixfmt 做格式化
          formatter = {
            external = {
              command = "nixfmt";
              arguments = [ ];
            };
          };

          # 可选：保存时自动格式化
          # 注意：Zed 1.10 起默认关闭 format_on_save，需要显式打开
          format_on_save = "on";
        };
      };

      lsp = {
        nixd = {
          settings = {
            # 让 nixd 也知道用 nixfmt（双保险）
            formatting = {
              command = [ "nixfmt" ];
            };
            # 可选：关掉一些较吵的诊断
            # diagnostic = {
            #   suppress = [ "sema-extra-with" ];
            # };
          };
        };
      };

      disable_ai = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "zeditor --wait";
    VISUAL = "zeditor --wait";
  };
}

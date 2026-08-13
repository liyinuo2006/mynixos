_: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "liyinuo2006";
        email = "orionli2006@gmail.com";
      };
      # 新分支首次裸 push 自动建立上游跟踪，避免"没有对应的上游分支"报错
      push.autoSetupRemote = true;
    };
  };

  # GitHub CLI：auth 后自动配置 git credential helper，push/pull 免密
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };
}

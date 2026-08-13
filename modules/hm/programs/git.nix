_: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "liyinuo2006";
        email = "orionli2006@gmail.com";
      };
    };
  };

  # GitHub CLI：auth 后自动配置 git credential helper，push/pull 免密
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };
}

_: {
  home.language = {
    base = "zh_CN.UTF-8";
  };

  # 将 locale 写入 Systemd 用户环境，所有图形应用/服务都会继承
  systemd.user.sessionVariables = {
    LANG = "zh_CN.UTF-8";
    LC_MESSAGES = "zh_CN.UTF-8";

    # LC_TIME = "zh_CN.UTF-8";
    # LC_NUMERIC = "zh_CN.UTF-8";
  };
}

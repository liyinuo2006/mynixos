{ ... }:
{

  security.polkit = {
    enable = true; # polkitd 目前由 services.udisks2 隐式拉起,显式声明以免依赖变动时失效
    enablePkexecWrapper = true; # 启用 setuid pkexec 包装(gparted 等 GUI 提权工具依赖它)

    # Noctalia Greeter 外观同步免授权:orion 无需输密码即可运行
    # noctalia-greeter-apply-appearance --sync(只写 /var/lib/noctalia-greeter/ 的外观文件)
    # 策略文件名仍是 org.noctalia.greeter.apply-appearance.policy,
    # 但 XML 内 action id 已改名为 org.noctalia.greeter.sync-appearance,规则必须跟新 id
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.noctalia.greeter.sync-appearance" ||
             action.id == "org.noctalia.greeter.apply-appearance") && subject.user == "orion") {
          return polkit.Result.YES;
        }
      });
    '';
  };

}

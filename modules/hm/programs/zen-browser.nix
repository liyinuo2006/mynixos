{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = true;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = false;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    nativeMessagingHosts = [ pkgs.firefoxpwa ];

    languagePacks = [ "zh-CN" ];

    enablePrivateDesktopEntry = true;

    profiles.default = {

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # 允许加载 userChrome.css
        "devtools.chrome.enabled" = true; # 浏览器工具箱
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.urlbar.behavior" = "float";
        "zen.welcome-screen.seen" = true;
        "zen.widget.linux.transparency" = false;
      };

      # Noctalia 生成的主题（文件由 Noctalia 更新，这里只引用）
      userChrome = ''
        @import "/home/orion/.cache/noctalia/zen-browser/zen-userChrome.css";
      '';
      userContent = ''
        @import "/home/orion/.cache/noctalia/zen-browser/zen-userContent.css";
      '';

      presets = {
        betterfox.enable = true; # Betterfox 性能/隐私优化
        # arkenfox.enable = true;   # arkenfox 严格隐私
        # catppuccin = { enable = true; flavor = "Mocha"; accent = "Mauve"; };
      };
    };
  };
}

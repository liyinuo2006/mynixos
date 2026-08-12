{
  pkgs,
  inputs,
  ...
}:
let
  fcitx5-vinput = inputs.fcitx5-vinput.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = with pkgs; [ rime-ice ];
        })

        fcitx5-gtk # GTK 应用支持

        (catppuccin-fcitx5.override {
          withRoundedCorners = true;
        })
        fcitx5-vinput
        # 语音输入(触发键 Alt_R:点按录制/长按即讲)
      ];

      # 候选窗外观（对应 conf/classicui.conf）
      settings.addons.classicui.globalSection = {
        "Vertical Candidate List" = "False"; # 垂直候选列表
        WheelForPaging = "True"; # 使用鼠标滚轮翻页
        Font = "Sans 10";
        MenuFont = "Sans 10";
        TrayFont = "Sans Serif 10";
        TrayOutlineColor = "#000000";
        TrayTextColor = "#ffffff";
        PreferTextIcon = "False";
        ShowLayoutNameInIcon = "True";
        UseInputMethodLanguageToDisplayText = "True";
        Theme = "catppuccin-latte-mauve";
        DarkTheme = "catppuccin-mocha-mauve";
        UseDarkTheme = "True";
        UseAccentColor = "True";
        PerScreenDPI = "True";
        ForceWaylandDPI = "0";
        EnableFractionalScale = "True";
      };

      # rime addon（对应 conf/rime.conf）
      settings.addons.rime.globalSection = {
        PreeditMode = "Composing text";
        InputState = "All";
        PreeditCursorPositionAtBeginning = "True";
        SwitchInputMethodBehavior = "Commit commit preview";
      };

      # waylandim（对应 conf/waylandim.conf）
      settings.addons.waylandim.globalSection = {
        DetectApplication = "True";
        PreferKeyEvent = "True";
        PersistentVirtualKeyboard = "False";
      };

      # xim（对应 conf/xim.conf）
      settings.addons.xim.globalSection = {
        UseOnTheSpot = "True";
      };

      # 全局行为与快捷键（对应 config）
      settings.globalOptions = {
        Hotkey = {
          EnumerateWithTriggerKeys = "True";
          EnumerateSkipFirst = "False";
          ModifierOnlyKeyTimeout = "250";
        };
        # ini 中是 [Hotkey/TriggerKeys] 子段,字段名带斜杠提到顶层
        "Hotkey/TriggerKeys" = {
          "0" = "Control+space";
        };
        Behavior = {
          ActiveByDefault = "False";
          resetStateWhenFocusIn = "No";
          ShareInputState = "No";
          PreeditEnabledByDefault = "True";
          ShowInputMethodInformation = "True";
          showInputMethodInformationWhenFocusIn = "False";
          CompactInputMethodInformation = "True";
          ShowFirstInputMethodInformation = "True";
          # DefaultPageSize = "5";
          OverrideXkbOption = "False";
          PreloadInputMethod = "True";
          AllowInputMethodForPassword = "False";
          ShowPreeditForPassword = "False";
          # AutoSavePeriod = "30";
        };
      };

      # 输入法语种/默认输入法（对应 profile）
      settings.inputMethod = {
        GroupOrder = {
          "0" = "orion";
        };
        "Groups/0" = {
          Name = "orion";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0" = {
          Name = "rime";
        };
      };
    };
  };

  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
      __include: rime_ice_suggestion:/

      # ── 方案列表 ──
      schema_list:
        - schema: double_pinyin_flypy #小鹤
        # - schema: rime_ice  #全拼

      # ── 候选词数量 ──
      menu:
        page_size: 8

  '';
  xdg.dataFile."fcitx5/rime/double_pinyin_flypy.custom.yaml".text = ''
    patch:
      # ── 默认英文模式（启动时直接输英文） ──
      "switches/@0/reset": 1
      "switches/@0/states": [鹤，EN]
      "grammar/language": wanxiang-lts-zh-hans

  '';

  # XWayland 应用(微信/WPS)里的 fcitx5 候选框按 Xft.dpi 渲染(默认 96),
  # 而屏幕 scale 1.5 的 Wayland 侧等效 144 DPI,导致候选框明显偏小。
  # 这里把 Xft.dpi 固定为 96 × 1.5 = 144(按内屏 scale 算,改 scale 要同步改);
  # 文件由 niri 的 spawn-sh-at-startup(xrdb -merge)在 XWayland 就绪后加载。
  xresources.properties = {
    "Xft.dpi" = "144";
  };
}

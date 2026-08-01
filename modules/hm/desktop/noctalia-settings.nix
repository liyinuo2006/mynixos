{
  # noctalia 声明式配置
  # 由 ~/.local/state/noctalia/settings.toml 转换而来(GUI 覆盖层 → 声明式)。
  # 部署后应删除该 settings.toml,否则 GUI 层仍会盖住这里。
  # 已省略 app 自管的元数据:config_version、desktop/lockscreen 的
  # schema_version、wallpaper.last(运行时"上次使用的壁纸",非配置)。

  # ===== 桌面背景模糊 =====
  backdrop = {
    blur_intensity = 0.2;
    enabled = true;
  };

  # ===== 顶栏 =====
  bar.default = {
    background_opacity = 0.0;
    capsule = true;
    capsule_opacity = 0.6;
    center = [
      "clock"
      "audio_visualizer"
    ];
    end = [
      "tray"
      "notifications"
      "clipboard"
      "cpu"
      "session"
    ];
    margin_ends = 0;
    padding = 15;
    reserve_space = false;
    scale = 1.05;
    smart_auto_hide = true;
    start = [
      "workspaces"
    ];
    thickness = 40;
  };

  # ===== 控制中心 =====
  control_center = {
    sidebar = "full";
    sidebar_section = "full";
  };

  # ===== 桌面小组件(位置/尺寸由 GUI 编辑器生成,绑定在 Virtual-1 输出) =====
  desktop_widgets = {
    widget_order = [
      "desktop-widget-0000000000000001"
      "desktop-widget-0000000000000002"
      "desktop-widget-0000000000000003"
      "desktop-widget-0000000000000004"
    ];

    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };

    widget = {
      # 音频可视化
      "desktop-widget-0000000000000001" = {
        box_height = 208.0;
        box_width = 240.0;
        cx = 200.0;
        cy = 200.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "fancy_audio_visualizer";
        settings = {
          background = false;
        };
      };

      # 音量
      "desktop-widget-0000000000000002" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 1144.0;
        cy = 638.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "volume";
      };

      # 媒体播放
      "desktop-widget-0000000000000003" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 179.0;
        cy = 650.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "media_player";
      };

      # 天气
      "desktop-widget-0000000000000004" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 532.0;
        cy = 646.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "weather";
      };
    };
  };

  # ===== Dock =====
  dock = {
    background_opacity = 0.0;
    cross_axis_padding = 4;
    enabled = true;
    icon_size = 45;
    launcher_position = "start";
    reserve_space = false;
    smart_auto_hide = true;
  };

  # ===== 热角 =====
  hot_corners = {
    delay_ms = 200;
    enabled = true;
  };

  # ===== 定位(供天气/夜间模式等使用) =====
  location = {
    auto_locate = true;
  };

  # ===== 锁屏小组件 =====
  lockscreen_widgets = {
    enabled = true;
    widget_order = [
      "lockscreen-login-box@Virtual-1"
      "lockscreen-widget-0000000000000001"
      "lockscreen-widget-0000000000000002"
      "lockscreen-widget-0000000000000003"
    ];

    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };

    widget = {
      # 登录框
      "lockscreen-login-box@Virtual-1" = {
        box_height = 196.0;
        box_width = 810.0;
        cx = 640.0;
        cy = 529.5;
        output = "Virtual-1";
        rotation = 0.0;
        type = "login_box";
        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12.0;
          center_password_text = false;
          input_opacity = 1.0;
          input_radius = 6.0;
          layout = "regular";
          show_caps_lock = true;
          show_keyboard_layout = true;
          show_login_button = true;
          show_media = true;
          show_session_buttons = true;
          show_unlock_hint = true;
          show_weather = true;
        };
      };

      # 时钟
      "lockscreen-widget-0000000000000001" = {
        box_height = 128.0;
        box_width = 304.0;
        cx = 1120.0;
        cy = 72.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "clock";
        settings = {
          background = true;
          background_color = "surface";
          background_opacity = 0.0;
          background_padding = 10;
          background_radius = 12;
          center_text = false;
          circle = true;
          clock_style = "digital";
          color = "on_surface";
          font_family = "";
          format = "{:%H:%M}";
          shadow = true;
          timezone = "";
        };
      };

      # 音频可视化
      "lockscreen-widget-0000000000000002" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 160.0;
        cy = 162.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "fancy_audio_visualizer";
        settings = {
          background = false;
        };
      };

      # 天气
      "lockscreen-widget-0000000000000003" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 1124.0;
        cy = 170.0;
        output = "Virtual-1";
        rotation = 0.0;
        type = "weather";
      };
    };
  };

  # ===== 通知 =====
  notification = {
    background_opacity = 0.6;
    history_retention_hours = 12;
  };

  # ===== 音量/亮度 OSD =====
  osd = {
    background_opacity = 0.5;
  };

  # ===== Shell 本体 =====
  shell = {
    app_icon_color = "primary";
    external_ip_enabled = true;
    font_family = "Sarasa UI SC";
    # 应用以 systemd 用户服务方式启动
    launch_apps_as_systemd_services = true;
    niri_overview_type_to_launch_enabled = true;
    password_style = "random";
    polkit_agent = true;
    screen_time_enabled = true;

    panel = {
      control_center_placement = "floating";
      control_center_position = "center";
      open_near_click_launcher = true;
      session_placement = "floating";
      session_position = "center";
      transparency_mode = "glass";
      wallpaper_placement = "floating";
    };

    screenshot = {
      directory = "~/Pictures/Screenshots";
    };

    session = {
      grid = true;
      show_shortcuts = false;
    };
  };

  # ===== 主题 =====
  theme = {
    mode = "auto";
    source = "wallpaper";

    templates = {
      builtin_ids = [
        "gtk3"
        "gtk4"
        "kitty"
        "niri"
        "qt"
        "starship"
      ];
      community_ids = [
        "zen-browser"
        "zed"
      ];
    };
  };

  # ===== 壁纸(目录在本仓库内) =====
  wallpaper = {
    directory = "~/mynixos/wallpaper";
    directory_dark = "~/mynixos/wallpaper";
    directory_light = "~/mynixos/wallpaper";

    automation = {
      enabled = true;
    };
  };
}

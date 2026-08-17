{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      # ===== 音频 =====
      audio = {
        enable_sounds = true;
      };

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
          "wallhaven"
        ];
        end = [
          "tray"
          "notifications"
          "clipboard"
          "cpu"
          "status"
          "session"
        ];
        margin_ends = 0;
        padding = 15;
        reserve_space = false;
        scale = 1.05;
        smart_auto_hide = true;
        start = [
          "workspaces"
          "caffeine"
          "nix-monitor"
        ];
        thickness = 40;
      };

      # ===== 电池 =====
      battery = {
        warning_threshold = 20;
      };

      # ===== 控制中心 =====
      control_center = {
        sidebar = "full";
        sidebar_section = "full";
      };

      # ===== 桌面小组件(位置/尺寸由 GUI 编辑器生成) =====
      desktop_widgets = {
        widget_order = [
          "desktop-widget-0000000000000001"
          "desktop-widget-0000000000000002"
        ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          # 媒体播放(带背景)
          "desktop-widget-0000000000000001" = {
            box_height = 144.0;
            box_width = 336.0;
            cx = 200.0;
            cy = 616.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "media_player";
            settings = {
              background = true;
              background_color = "surface";
              background_opacity = 0.6;
              background_padding = 13;
              background_radius = 32;
              color = "primary";
              font_family = "";
              hide_when_no_media = true;
              layout = "horizontal";
              shadow = false;
            };
          };

          # 底部音频可视化
          "desktop-widget-0000000000000002" = {
            box_height = 32.0;
            box_width = 1280.0;
            cx = 640.0;
            cy = 704.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "audio_visualizer";
            settings = {
              background = false;
              background_color = "surface";
              background_opacity = 0.8;
              background_padding = 10;
              background_radius = 12;
              bands = 32;
              centered = false;
              color_1 = "primary";
              color_2 = "primary";
              mirrored = true;
              show_when_idle = false;
            };
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
        enabled = false;
      };

      # ===== 待机 =====
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        pre_action_fade_seconds = 3;

        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };
          "lock-and-suspend" = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 900.0;
          };
          "screen-off" = {
            action = "screen_off";
            enabled = true;
            timeout = 660.0;
          };
        };
      };

      # ===== 定位(供天气/夜间模式等使用) =====
      location = {
        auto_locate = true;
      };

      # ===== 锁屏小组件 =====
      lockscreen_widgets = {
        enabled = true;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
        ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          # 登录框(eDP-1)
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 816.0;
            cx = 637.0;
            cy = 570.0;
            output = "eDP-1";
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

          # 模拟时钟
          "lockscreen-widget-0000000000000001" = {
            box_height = 240.0;
            box_width = 256.0;
            cx = 1088.0;
            cy = 152.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background = true;
              background_opacity = 0.57;
              background_radius = 13;
              circle = true;
              clock_style = "analog";
              color = "primary";
            };
          };

          # 天气(eDP-1)
          "lockscreen-widget-0000000000000002" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 116.0;
            cy = 58.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "weather";
            settings = {
              shadow = true;
            };
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

      # ===== 插件设置 =====
      plugin_settings = {
        "alexander/mimir" = {
          chat_open_near_click = true;
          chat_placement = "attached";
        };
        "avivbintangaringga/nix-monitor" = {
          clean_command = "sudo nix-collect-garbage --delete-older-than 3d";
          optimize_command = "nix store optimise -vv";
          panel_card_color = "surface";
          panel_card_opacity = 100;
          system_stats_check_duration_threshold = 10;
          system_stats_check_mode = "on_start";
          update_command = "sudo nixos-rebuild switch --flake /home/orion/mynixos#mynixos";
        };
        "noctalia/wallhaven" = {
          browser_placement = "floating";
          download_dir = "/home/orion/mynixos/wallpaper";
        };
      };

      # ===== 启用的插件 =====
      plugins = {
        enabled = [
          "alexander/mimir"
          "avivbintangaringga/nix-monitor"
          "noctalia/wallhaven"
        ];
      };

      # ===== Shell 本体 =====
      shell = {
        app_icon_color = "primary";
        corner_radius_scale = 1.5; # 圆角:0=直角,1=默认,2=最大;桌面与登录界面(Greeter)同步
        external_ip_enabled = true;
        font_family = "Sarasa UI SC";
        # 应用以 systemd 用户服务方式启动
        launch_apps_as_systemd_services = true;
        niri_overview_type_to_launch_enabled = true;
        password_style = "random";
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = false;

        # 壁纸/配色/字体变化时自动同步登录界面。
        # 强制走 pkexec 而非默认的 run0(shell 源码 resolvePrivilegeEscalator 是 run0 优先),
        # 这样才能命中 polkit 规则 org.noctalia.greeter.apply-appearance 实现免弹窗
        greeter_sync = {
          auto_sync = true;
          privilege_command = "pkexec";
        };

        panel = {
          control_center_placement = "floating";
          control_center_position = "center";
          open_near_click_launcher = true;
          session_placement = "floating";
          session_position = "center";
          transparency_mode = "glass";
          wallpaper_placement = "floating";
          wallpaper_position = "center";
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
            "telegram"
            "zed"
          ];
        };
      };

      # ===== 壁纸 =====
      wallpaper = {
        directory = "~/mynixos/wallpaper";
        directory_dark = "~/mynixos/wallpaper";
        directory_light = "~/mynixos/wallpaper";

        automation = {
          enabled = true;
        };
      };

      # ===== 插件小组件 =====
      widget = {
        # 显示 Status=Passive 的托盘项(如闪狐云 Lite 永远 Passive,默认会被隐藏;
        # 对应 TOML [widget.tray] hide_passive,上游 commit cf0bf8d 加入)
        tray = {
          hide_passive = false;
        };
        "nix-monitor" = {
          colorize_glyph = false;
          show_text = false;
          type = "avivbintangaringga/nix-monitor:nix-monitor";
        };
        status = {
          type = "alexander/mimir:status";
        };
        wallhaven = {
          type = "noctalia/wallhaven:wallhaven";
        };
      };
    };
  };

  # ===== wallhaven API key：由 sops 解密生成，不落明文进 store =====
  # 原理：Noctalia 自动合并 ~/.config/noctalia/ 下所有 *.toml（docs.noctalia.dev/v5/configuration/），
  # sops 在 wallhaven.toml 处生成 symlink，指向 $XDG_RUNTIME_DIR/secrets.d/rendered/ 的真实文件
  sops = {
    # 用可读的占位符替换默认的 <SOPS:<sha256>:PLACEHOLDER>
    placeholder."wallhaven-api-key" = "{{ WALLHAVEN_API_KEY }}";
    templates."wallhaven.toml" = {
      path = "/home/orion/.config/noctalia/wallhaven.toml";
      content = ''
        [plugin_settings."noctalia/wallhaven"]
        api_key = "{{ WALLHAVEN_API_KEY }}"
      '';
    };
  };

}

{ pkgs, lib, ... }:
let
  # MATLAB R2020b 本地 FHS 包装：MATLAB 本体由官方安装器命令式装到家目录
  # （如 ~/MATLAB/R2020b），Nix 只提供 FHS 运行环境，不进 store。
  # 依赖清单抄自上游 sceptri/nix-matlab 的 common.nix（源头是 MathWorks
  # R2020a Dockerfile），另有两处按当前 nixos-unstable 修正：
  # buildFHSUserEnv 改用新名 buildFHSEnv；已删除的 gnome2.gtk 改为按需引入的
  # gtk2；已废弃的 mesa.drivers 改为 mesa。
  matlabTargetPkgs =
    ps:
    (with ps; [
      cacert
      alsa-lib # libasound2
      atk
      glib
      glibc
      cairo
      cups
      dbus
      fontconfig
      gdk-pixbuf
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      gtk3
      nspr
      nss
      pam
      pango
      python3
      libselinux
      libsndfile
      glibcLocales
      procps
      unzip
      zlib

      # 2021b 及之后版本需要
      at-spi2-atk
      at-spi2-core
      libdrm
      mesa

      gcc
      gfortran

      # NixOS 特有
      udev
      jre
      ncurses # 命令行需要

      # 否则 Simulink 里键盘输入可能失灵
      libxkbcommon
      xkeyboard_config

      # 2022a 及之后需要
      libglvnd

      # 2022b 及之后需要
      libuuid
      libxcrypt
      libxcrypt-legacy
    ])
    # R2020b 仍可能用到 gtk2，nixpkgs 正在移除它，有才加，没有就跳过
    ++ lib.optional (builtins.hasAttr "gtk2" ps) ps.gtk2
    ++ (with ps.xorg; [
      libSM
      libX11
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXft
      libXi
      libXinerama
      libXrandr
      libXrender
      libXt
      libXtst
      libXxf86vm
    ]);

  # 启动前读取命令式安装位置；matlab-shell 允许缺失（安装前还没有）。
  runScriptPrefix =
    { errorOut ? true }:
    ''
      # Niri 是纯 Wayland，MATLAB 只认 X11，强制走 XWayland（含 Simulink）
      export QT_QPA_PLATFORM=xcb
      if [[ -f ~/.config/matlab/nix.sh ]]; then
        source ~/.config/matlab/nix.sh
    ''
    + lib.optionalString errorOut ''
      else
        echo "nix-matlab-error: 找不到 ~/.config/matlab/nix.sh，请先安装 MATLAB 并写入 INSTALL_DIR" >&2
        exit 1
      fi
      if [[ ! -d "$INSTALL_DIR" ]]; then
        echo "nix-matlab-error: INSTALL_DIR $INSTALL_DIR 不是目录" >&2
        exit 2
    ''
    + ''
      fi
    '';

  matlabDesktop = pkgs.makeDesktopItem {
    desktopName = "MATLAB";
    name = "matlab";
    # -desktop 参数见 MathWorks 官方桌面启动器说明
    exec = "@out@/bin/matlab -desktop %F";
    icon = "matlab";
    categories = [
      "Utility"
      "TextEditor"
      "Development"
      "IDE"
    ];
    mimeTypes = [
      "text/x-octave"
      "text/x-matlab"
    ];
    keywords = [
      "science"
      "math"
      "matrix"
      "numerical computation"
      "plotting"
    ];
  };
in
{
  environment.systemPackages = [
    (pkgs.buildFHSEnv {
      name = "matlab";
      targetPkgs = matlabTargetPkgs;
      extraInstallCommands = ''
        install -Dm644 ${matlabDesktop}/share/applications/matlab.desktop $out/share/applications/matlab.desktop
        substituteInPlace $out/share/applications/matlab.desktop \
          --replace "@out@" ${placeholder "out"}
      '';
      runScript = pkgs.writeScript "matlab-runner" (
        (runScriptPrefix { }) + ''
          # 强制用 Nix 的新 libstdc++，盖掉 R2020b 自带的旧库，否则 GUI 易崩
          exec env \
            LD_PRELOAD=/lib/libstdc++.so \
            LD_LIBRARY_PATH=/run/opengl-driver/lib/dri/ \
            $INSTALL_DIR/bin/matlab "$@"
        ''
      );
      meta.description = "MATLAB R2020b（命令式装到家目录，FHS 启动器）";
    })

    (pkgs.buildFHSEnv {
      name = "matlab-shell";
      targetPkgs = matlabTargetPkgs;
      runScript = pkgs.writeScript "matlab-shell-runner" (
        (runScriptPrefix { errorOut = false; }) + ''
          cat <<'EOF'
          ============================
          matlab-shell（R2020b 安装用）

          1. 学校账号去 mathworks.com/mwaccount 下 Previous releases 的 R2020b Linux 包，unzip -X -K 解压
          2. 在此 shell 里跑 ./install，装到 ~/MATLAB/R2020b，学校账号在线激活
             安装器窗口不出来：先删安装包里的 sys/os/glnxa64/libstdc++.so.6* 和 bin/glnxa64/libstdc++.so.6* 再重跑
          3. 写入 ~/.config/matlab/nix.sh：INSTALL_DIR=$HOME/MATLAB/R2020b
          4. 退出此 shell，跑 matlab -desktop 验证
          ============================
          EOF
          exec bash
        ''
      );
      meta.description = "跑 MATLAB 官方安装器用的 FHS shell";
    })
  ];
}

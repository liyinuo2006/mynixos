# mynixos

Orion 的单机 NixOS 配置，Flake 仓库。

## 结构

- `flake.nix` — 入口，含 inputs 与缓存/信任密钥配置
- `hosts/vostro-3420/` — 本机硬件与主机级配置
- `modules/nixos/` — 系统模块
- `modules/hm/` — Home Manager 模块
- `modules/_trash/` — 废弃配置垃圾桶
- `wallpaper/` — 运行时壁纸目录（不入 store）


## 个人说明

### 未被声明的部分

1. wanxiang-lts-zh-hans ，万象语法模型（ https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram ） 需手动下载放在 ~/.local/share/fcitx5/rime/ 下。
2. 浏览器 账户 cookie 相关数据: zen-browser google-chrome 
3.
- libvirt: 执行以下命令 nat 网络 ||
sudo virsh net-start default  ||
sudo virsh net-autostart default # 默认网络默认是停用的
- waydroid:
初始化与启动
sudo waydroid init -s GAPPS   # 初始化镜像；-s GAPPS 带谷歌服务，-f 强制重装
sudo waydroid-script               # 选 Android 13 → Install → libhoudini
sudo systemctl start waydroid-container # 以后开机自启，不用手动
waydroid session start        # 看到 "Android with user 0 is ready" 即成功
日常使用
waydroid show-full-ui                                    # 全屏模式
waydroid prop set persist.waydroid.multi_windows true    # 多窗口模式（需重启 session）
4. ai 相关：hermes opencode2 dsh
5. 机场账户 
6. sops-nix 私钥放在/var/lib/sops-nix/key.txt
7. fcitx5-vinput 的设置:豆包输入法
8. wallpaper 放在./ 下

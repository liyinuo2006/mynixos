{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.hermes-agent.nixosModules.default ];
  # orion 加入 hermes 组：原生模式下 hostUsers 选项只在容器模式生效，
  # 不手动加组则 hermes chat 无权限读写 /var/lib/hermes（2770 hermes:hermes）
  users.users.orion.extraGroups = lib.mkIf config.services.hermes-agent.enable [ "hermes" ];

  services.hermes-agent = {
    enable = true;
    # CLI 与 gateway 服务共享状态（HERMES_HOME=/var/lib/hermes/.hermes），
    # 不开则终端里 hermes 用独立 ~/.hermes，看不到服务积累的会话
    addToSystemPackages = true;
    environmentFiles = [ config.sops.secrets."hermes-env".path ]; # 密钥由 sops 解密到 /run/secrets/hermes-env，激活时合并进 $HERMES_HOME/.env

    settings = {
      # 默认模型相关配置
      model = {
        provider = "opencode-go";
        default = "deepseek-v4-flash";
      };
      # 辅助模型相关配置
      auxiliary = {
        vision = {
          provider = "opencode-go";
          model = "mimo-v2.5";
        };
        # ── 网页抓取/摘要 ──
        web_extract = {
          provider = "auto";
          model = "";
        };
        # ── 上下文压缩摘要（副任务里最重的）──
        compression = {
          provider = "opencode-go";
          model = "deepseek-v4-flash";
        };
        # ── skills_hub 在线技能搜索 ──
        skills_hub = {
          provider = "auto";
          model = "";
        };
        # ── 危险命令审批摘要 ──
        approval = {
          provider = "auto";
          model = "";
          base_url = "";
        };
        # ── MCP 采样辅助 ──
        mcp = {
          provider = "auto";
          model = "";
        };
        # ── 会话自动标题 ──
        title_generation = {
          enabled = true;
          provider = "auto";
          model = "";
        };
      };
      # 上下文压缩
      compression = {
        enabled = true;
        # ⭐ 推荐改：上下文用到 50% 触发压缩。0.4=更早压缩（省 token）；0.75 是 <512K 模型下限
        threshold = 0.7;
        # 🚫 不要动：微压缩（实验特性）
        micro_compact = false;
        micro_compact_every_n_turns = 1;
        micro_compact_defrag_threshold_tokens = 2000;
      };
      # agent
      agent = {
        environment_hint = ''
          操作系统是 NixOS：已启用 flake 和 nix-command，优先使用新的 nix CLI。
        '';
      };
      # 终端相关
      terminal = {
        backend = "local";
        timeout = 180;
      };
      # 记忆
      memory = {
        # ⭐ 推荐改：agent 自笔记（MEMORY.md）。保持 true
        memory_enabled = true;
        # ⭐ 推荐改：用户画像（USER.md）。保持 true
        user_profile_enabled = true;
        # 🔧 按需调整：记忆写入前需批准（false=自由写）
        write_approval = false;
        # 🚫 不要动：MEMORY.md 字符上限（约 800 token）
        memory_char_limit = 2200;
        # 🚫 不要动：USER.md 字符上限
        user_char_limit = 1375;
        # 🚫 不要动：外部记忆供应商（honcho/hindsight 等，需额外依赖组）
        provider = "";
      };
      # 权限
      security = {
        allow_private_urls = true;
      };

      platforms.telegram = {
        enabled = true; # token 存在时会自动启用；显式写更清晰
        reply_to_mode = "first";
        extra = {
          # 私聊安全默认已够；群聊场景再加：
          # require_mention = true;     # 群里必须 @bot 才响应
          # rich_messages = false;      # 官方默认关（MarkdownV2 路径）
          # disable_link_previews = false;
        };
      };
    };
  };

  # ── agent 终端可用的额外工具（模块顶层选项，非 settings 键）──
  services.hermes-agent.extraPackages = with pkgs; [
    python3
    jq
    file
    tree
    unzip
    sqlite
    openssl
  ];
}

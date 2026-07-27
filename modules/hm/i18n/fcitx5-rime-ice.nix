{
  pkgs,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      #      settings.inputMethod = {

      #      };
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = with pkgs; [ rime-ice ];
        })
        fcitx5-gtk # GTK 应用支持
      ];
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
        page_size: 9

      # ── 禁掉 Ctrl+Shift+3/4 快捷键 ──
      key_binder/bindings/+:
        - { when: always, accept: "Control+Shift+3", send: noop }
        - { when: always, accept: "Control+Shift+4", send: noop }

  '';
  xdg.dataFile."fcitx5/rime/double_pinyin_flypy.custom.yaml".text = ''
    patch:
      # ── 默认英文模式（启动时直接输英文） ──
      "switches/@0/reset": 1
      "switches/@0/states": [鹤，EN]

  '';

}

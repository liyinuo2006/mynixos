{
  ...
}:
{
  # Nautilus Python 扩展：全部复制到仓库声明式管理。
  # 安装位置：~/.local/share/nautilus-python/extensions/
  home.file = builtins.listToAttrs (
    map
      (name: {
        name = ".local/share/nautilus-python/extensions/${name}";
        value.source = ./nautilus-extensions/${name};
      })
      [
        "archive-browser.py"
        "column-browser.py"
        "nautilus_edit_ext.py"
        "nautilus-more-copy.py"
        "nautilus-create-new-file.py"
        "search-content.py"
        "video-to-audio.py"
      ]
  );
}

{
  ...
}:
{
  # Nautilus Python 扩展：全部复制到仓库声明式管理。
  # 安装位置：~/.local/share/nautilus-python/extensions/
  home.file = {
    ".local/share/nautilus-python/extensions/archive-browser.py".source =
      ./nautilus-extensions/archive-browser.py;
    ".local/share/nautilus-python/extensions/column-browser.py".source =
      ./nautilus-extensions/column-browser.py;
    ".local/share/nautilus-python/extensions/duration-column.py".source =
      ./nautilus-extensions/duration-column.py;
    ".local/share/nautilus-python/extensions/nautilus_edit_ext.py".source =
      ./nautilus-extensions/nautilus_edit_ext.py;
    ".local/share/nautilus-python/extensions/nautilus-git-operations.py".source =
      ./nautilus-extensions/nautilus-git-operations.py;
    ".local/share/nautilus-python/extensions/nautilus-more-copy.py".source =
      ./nautilus-extensions/nautilus-more-copy.py;
    ".local/share/nautilus-python/extensions/nautilus-create-new-file.py".source =
      ./nautilus-extensions/nautilus-create-new-file.py;
    ".local/share/nautilus-python/extensions/search-content.py".source =
      ./nautilus-extensions/search-content.py;
    ".local/share/nautilus-python/extensions/video-to-audio.py".source =
      ./nautilus-extensions/video-to-audio.py;
  };
}

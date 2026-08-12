# 本文件是本机自用版本，仅在本仓库维护。
import gi
gi.require_version("Gtk", "4.0")
gi.require_version("Gdk", "4.0")
from gi.repository import Gtk, Gdk, Nautilus, GObject
from typing import List


class MoreCopyExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(
        self,
        files: List[Nautilus.FileInfo],
    ) -> List[Nautilus.MenuItem]:
        return self.generate_menu(files, False)

    def get_background_items(
        self,
        current_folder: Nautilus.FileInfo,
    ) -> List[Nautilus.MenuItem]:
        return self.generate_menu([current_folder], True)

    def generate_menu(
        self,
        files: List[Nautilus.FileInfo],
        is_background: bool,
    ) -> List[Nautilus.MenuItem]:
        if not files:
            return []

        submenu = Nautilus.Menu()

        multiple_files = len(files) > 1
        is_directory = not multiple_files and files[0].is_directory()
        scope = "Background" if is_background else "Selection"

        copy_path_item = Nautilus.MenuItem(
            name=f"MoreCopyExtension::CopyPath{scope}",
            label=(
                "复制目录路径" if is_directory
                else "复制所选文件路径" if multiple_files
                else "复制文件路径"
            ),
        )
        copy_path_item.connect(
            "activate",
            lambda menu_item, files=files: self.copy_paths(files),
        )

        copy_name_item = Nautilus.MenuItem(
            name=f"MoreCopyExtension::CopyName{scope}",
            label=(
                "复制目录名称" if is_directory
                else "复制所选文件名称" if multiple_files
                else "复制文件名称"
            ),
        )
        copy_name_item.connect(
            "activate",
            lambda menu_item, files=files: self.copy_names(files),
        )

        submenu.append_item(copy_path_item)
        submenu.append_item(copy_name_item)
        menu_item = Nautilus.MenuItem(
            name=f"MoreCopyExtension::MoreCopy{scope}",
            label="复制路径/名称",
            icon="edit-copy",
        )
        menu_item.set_submenu(submenu)

        return [
            menu_item,
        ]

    def copy_paths(self, files: List[Nautilus.FileInfo]) -> None:
        paths = [file.get_location().get_path() for file in files]
        self._copy("\n".join(path for path in paths if path))

    def copy_names(self, files: List[Nautilus.FileInfo]) -> None:
        names = [file.get_name() for file in files]
        self._copy("\n".join(name for name in names if name))

    @staticmethod
    def _copy(text: str) -> None:
        if not text:
            return
        display = Gdk.Display.get_default()
        if display is None:
            return
        clipboard = display.get_clipboard()
        provider = Gdk.ContentProvider.new_for_value(text)
        clipboard.set_content(provider)

# 本文件是本机自用版本，仅在本仓库维护。
from gi.repository import GObject, Nautilus
import shutil
import subprocess


class EditFileExtension(GObject.GObject, Nautilus.MenuProvider):
    __gtype_name__ = "EditFileWithZedExtension"

    def __init__(self):
        super().__init__()
        self.editor = shutil.which("zeditor")
        self.extensions = frozenset((
            ".py", ".sh", ".txt", ".md", ".json", ".yml", ".yaml",
            ".conf", ".toml", ".nix",
        ))

    @staticmethod
    def _spawn(args):
        try:
            subprocess.Popen(args, start_new_session=True)
        except (OSError, ValueError):
            pass

    def get_file_items(self, files):
        if not self.editor or not files:
            return []

        for file in files:
            if file.get_uri_scheme() != "file":
                return []
            if file.is_directory() or not file.get_name().lower().endswith(self.extensions):
                return []

        item = Nautilus.MenuItem(
            name="EditFileExtension::EditFile",
            label="用 Zed 打开",
            tip="使用 Zed 打开选中的文件",
        )
        item.connect("activate", self.menu_activate_cb, files)
        return [item]

    def menu_activate_cb(self, menu, files):
        filepaths = [file.get_location().get_path() for file in files]
        filepaths = [p for p in filepaths if p]
        if filepaths:
            self._spawn([self.editor, *filepaths])

    def get_background_items(self, folder):
        if not self.editor or folder is None or folder.get_uri_scheme() != "file":
            return []

        item = Nautilus.MenuItem(
            name="EditFileExtension::EditFolder",
            label="用 Zed 打开目录",
            tip="使用 Zed 打开当前目录",
        )
        item.connect("activate", self.menu_activate_folder_cb, folder)
        return [item]

    def menu_activate_folder_cb(self, menu, folder):
        path = folder.get_location().get_path()
        if path:
            self._spawn([self.editor, path])

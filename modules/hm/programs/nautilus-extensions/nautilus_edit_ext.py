from gi.repository import GObject, Nautilus
import subprocess


class EditFileExtension(GObject.GObject, Nautilus.MenuProvider):
    __gtype_name__ = "EditFileWithZedExtension"

    def __init__(self):
        super().__init__()
        self.editor = "zeditor"
        self.extensions = (".py", ".sh", ".txt", ".md", ".json", ".yml", ".conf")

    def get_file_items(self, files):
        if not files:
            return []

        for file in files:
            if file.get_uri_scheme() != "file":
                return []
            if file.is_directory() or not file.get_name().lower().endswith(self.extensions):
                return []

        item = Nautilus.MenuItem(
            name="EditFileExtension::EditFile",
            label="Open with Zed",
            tip="Open the selected files in Zed",
        )
        item.connect("activate", self.menu_activate_cb, files)
        return [item]

    def menu_activate_cb(self, menu, files):
        filepaths = [file.get_location().get_path() for file in files]
        subprocess.Popen([self.editor, *filepaths])

    def get_background_items(self, folder):
        if folder is None or folder.get_uri_scheme() != "file":
            return []

        item = Nautilus.MenuItem(
            name="EditFileExtension::EditFolder",
            label="Open Folder with Zed",
            tip="Open this folder in Zed",
        )
        item.connect("activate", self.menu_activate_folder_cb, folder)
        return [item]

    def menu_activate_folder_cb(self, menu, folder):
        path = folder.get_location().get_path()
        if path:
            subprocess.Popen([self.editor, path])

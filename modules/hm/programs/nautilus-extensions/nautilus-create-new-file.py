# 本文件是本机自用版本，仅在本仓库维护。
keybind = "<Primary><Alt>n"

import gi
from gi.repository import GObject, Adw, Gtk, Nautilus, Gio, GLib
import os


class CreateFileDialog(Adw.Dialog):
    def __init__(self, target_dir):
        super().__init__()

        self.target_dir = target_dir

        self.set_title("新建文件")
        self.set_content_width(450)
        root = Adw.ToolbarView()
        header_bar = Adw.HeaderBar()
        header_bar.set_decoration_layout(':close')
        root.add_top_bar(header_bar)
        body = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL,
            hexpand=True,
            spacing=8,
            margin_top=16,
            margin_bottom=16,
            margin_start=16,
            margin_end=16,
        )
        root.set_content(body)
        list_box = Gtk.ListBox(css_classes=["boxed-list-separate"])
        body.append(list_box)

        self.file_name = Adw.EntryRow(title="文件名")
        list_box.append(self.file_name)
        self.file_name.connect("entry-activated", lambda *_: self.create_file())

        self.submit_button = Gtk.Button(
            label="创建",
            css_classes=["pill", "suggested-action"],
            halign=Gtk.Align.CENTER,
            margin_top=8,
        )
        body.append(self.submit_button)
        self.submit_button.connect("clicked", lambda *_: self.create_file(), None)

        self.set_child(root)

    def create_file(self):
        file_name = self.file_name.get_text().strip()
        if (
            not file_name
            or file_name in {".", ".."}
            or os.path.basename(file_name) != file_name
        ):
            return

        base_name, ext = os.path.splitext(file_name)
        counter = 1
        while os.path.exists(os.path.join(self.target_dir, file_name)):
            file_name = f"{base_name}_{counter}{ext}"
            counter += 1

        final_path = os.path.join(self.target_dir, file_name)
        gfile = Gio.File.new_for_path(final_path)
        try:
            gfile.replace_contents(
                b"", None, False, Gio.FileCreateFlags.NONE, None)
        except GLib.Error as exc:
            dlg = Adw.MessageDialog(
                heading="创建失败",
                body=str(exc),
            )
            dlg.add_response("ok", "确定")
            dlg.present()
            return
        self.close()

        uri = gfile.get_uri()
        escaped_uri = uri.replace("\\", "\\\\").replace("'", "\\'")

        def _select():
            GLib.spawn_async(
                ['gdbus','call','--session',
                 '--dest','org.freedesktop.FileManager1',
                 '--object-path','/org/freedesktop/FileManager1',
                 '--method','org.freedesktop.FileManager1.ShowItems',
                  f"['{escaped_uri}']", "''"],
                flags=GLib.SpawnFlags.SEARCH_PATH)
            return False
        GLib.timeout_add(100, _select)


class CreateFileExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()
        self.folder_for_window = {}

    def get_background_items(self, folder: Nautilus.FileInfo):
        if folder is None or folder.get_uri_scheme() != "file":
            return []
        path = folder.get_location().get_path()
        if not path:
            return []

        windows = set()

        for window in Gtk.Window.get_toplevels():
            windows.add(window)
            if not window.is_active():
                continue
            self.folder_for_window[window] = path
            if window.lookup_action("create-file") is None:
                action = Gio.SimpleAction.new("create-file", None)
                action.connect("activate", self.action_activated)
                window.add_action(action)
                window.get_application().set_accels_for_action(
                    "win.create-file",
                    [keybind]
                )
        for old in list(self.folder_for_window):
            if old not in windows:
                del self.folder_for_window[old]

        menu_item = Nautilus.MenuItem(
            name="CreateFileExtension::CreateFile",
            label="新建文件…",
        )
        menu_item.connect(
            "activate",
            lambda *_: CreateFileDialog(path).present(Gtk.Application.get_default().get_active_window()),
            None,
        )
        return [
            menu_item,
        ]

    def action_activated(self, action, parameter):
        for window in Gtk.Window.get_toplevels():
            if window.is_active():
                path = self.folder_for_window.get(window)
                if path is not None:
                    CreateFileDialog(path).present(window)
                break

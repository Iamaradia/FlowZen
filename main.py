import sys
from pathlib import Path

from PySide6.QtCore import QStandardPaths, QUrl
from PySide6.QtGui import QFont, QFontDatabase, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication, QMessageBox


def register_fonts(project, app):
    font_directory = project / "assets" / "fonts"
    font_files = (
        "DejaVuSans.ttf",
        "DejaVuSans-Bold.ttf",
        "DejaVuSerif.ttf",
        "DejaVuSerif-Bold.ttf",
    )
    for font_file in font_files:
        if QFontDatabase.addApplicationFont(str(font_directory / font_file)) == -1:
            raise RuntimeError(f"Could not load the bundled font: {font_file}")

    QFont.insertSubstitution("IBM Plex Sans", "DejaVu Sans")
    QFont.insertSubstitution("Bodoni Moda", "DejaVu Serif")
    app.setFont(QFont("DejaVu Sans"))


def main():
    QQuickStyle.setStyle("Basic")
    app = QApplication(sys.argv)
    app.setApplicationName("FlowZen")
    app.setOrganizationName("FlowZen")
    project = Path(getattr(sys, "_MEIPASS", Path(__file__).resolve().parent))
    app.setWindowIcon(QIcon(str(project / "assets" / "logo.png")))

    try:
        register_fonts(project, app)
    except RuntimeError as error:
        QMessageBox.critical(None, "FlowZen could not start", str(error))
        return 1

    if getattr(sys, "frozen", False):
        from backend import database

        data_directory = Path(
            QStandardPaths.writableLocation(QStandardPaths.StandardLocation.AppDataLocation)
        )
        data_directory.mkdir(parents=True, exist_ok=True)
        database.DATABASE_NAME = data_directory / "focus_data.db"

    if "--legacy" in sys.argv:
        from app_window import MainWindow
        window = MainWindow()
        window.show()
        return app.exec()

    from backend.app_controller import AppController
    controller = AppController()
    engine = QQmlApplicationEngine()
    engine.addImportPath(str(project / "assets"))
    engine.addImageProvider("camera", controller.image_provider)
    engine.setInitialProperties({"controller": controller})
    controller.soundRequested.connect(app.beep)
    app.aboutToQuit.connect(controller.shutdown)
    engine.load(QUrl.fromLocalFile(str(project / "ui" / "Main.qml")))
    if not engine.rootObjects():
        controller.shutdown()
        QMessageBox.critical(
            None,
            "FlowZen could not start",
            "The interface could not be loaded. Reinstall FlowZen and try again.",
        )
        return 1
    result = app.exec()
    # Tear down QML while its controller still exists.
    del engine
    return result


if __name__ == "__main__":
    sys.exit(main())

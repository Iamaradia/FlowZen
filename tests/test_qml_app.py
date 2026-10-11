"""Run with: python -m unittest discover -s tests -v (no camera required)."""

import os
os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
os.environ.setdefault("QT_QUICK_BACKEND", "software")

import sqlite3
import tempfile
import unittest
from contextlib import closing
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from PySide6.QtCore import QObject, QPoint, QSettings, Qt, QUrl, Signal
from PySide6.QtGui import QFont, QFontInfo, QImage
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtTest import QTest
from PySide6.QtWidgets import QApplication

from backend import database
from backend.app_controller import AppController
from backend.distraction_classifier import DistractionClassifier
from main import register_fonts

QQuickStyle.setStyle("Basic")
APP = QApplication.instance() or QApplication([])
PROJECT = Path(__file__).resolve().parents[1]
register_fonts(PROJECT, APP)


class FakeCamera(QObject):
    ready = Signal()
    frameReady = Signal(QImage, bool, object)
    failed = Signal(str)

    def __init__(self, parent):
        super().__init__(parent)
        self.running = False

    def start(self):
        self.running = True

    def isRunning(self):
        return self.running

    def requestInterruption(self):
        self.running = False

    def wait(self):
        pass


class ControllerFixture:
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.database_patch = patch.object(database, "DATABASE_NAME", Path(self.tmp.name) / "test.db")
        self.database_patch.start()
        self.settings = QSettings(str(Path(self.tmp.name) / "settings.ini"), QSettings.Format.IniFormat)
        self.controller = AppController(settings=self.settings, camera_factory=FakeCamera)
        self.controller.timer.stop()
        self.controller.setPreference("appTracking", False)

    def tearDown(self):
        self.controller.shutdown()
        self.controller.deleteLater()
        APP.processEvents()
        self.database_patch.stop()
        self.tmp.cleanup()

    def manual_session(self):
        self.controller.setPreference("focusTracking", False)
        self.controller.setTitle("QML integration test")
        self.controller.startSession()
        self.controller._tick()


class DistractionClassifierTests(unittest.TestCase):
    def test_keyword_cache_returns_the_matching_classification(self):
        classifier = DistractionClassifier()
        classifier.keywords["math"] = "D"

        self.assertEqual(classifier.classify_keyword("", "", "", "math"), "D")
        self.assertEqual(classifier.classify_keyword("", "", "", "unknown"), "S")

    def test_model_classification_is_saved_to_the_cache(self):
        classifier = DistractionClassifier()
        response = SimpleNamespace(message=SimpleNamespace(content=" S "))

        with (
            patch("backend.distraction_classifier.chat", return_value=response),
            patch.object(classifier, "get_answer_cache", return_value=""),
            patch.object(classifier, "update_answer_cache") as save_answer,
        ):
            result = classifier.classify_with_model("app", "Editor", "main.py", "Study Python")

        self.assertEqual(result, "S")
        save_answer.assert_called_once_with("app", "Editor", "main.py", "Study Python", "S")


class ControllerTests(ControllerFixture, unittest.TestCase):
    def test_detects_titles_before_session_and_while_paused(self):
        c = self.controller
        c.setPreference("appTracking", True)
        with patch("backend.activity_detector.get_app_title", return_value=(10, "Document - Editor", "editor.exe")):
            c._tick()
        self.assertEqual(c.state["appTitle"], "Document - Editor")
        self.assertFalse(c.state["active"])
        self.assertFalse(c._apps)
        self.manual_session()
        c.togglePause()
        c._last_app_poll = 0
        with patch("backend.activity_detector.get_app_title", return_value=(20, "Lecture - Browser", "browser.exe")):
            c._tick()
        self.assertEqual(c.state["appTitle"], "Lecture - Browser")

    def test_keeps_external_title_when_flowzen_is_foreground_without_counting_it(self):
        c = self.controller
        self.manual_session()
        c.setPreference("appTracking", True)
        with patch("backend.activity_detector.get_app_title", return_value=(10, "Document - Editor", "editor.exe")):
            c._tick()
        self.assertEqual(c.state["appTitle"], "Document - Editor")
        recorded = dict(c._apps)
        c._last_app_poll = 0
        with patch("backend.activity_detector.get_app_title", return_value=(20, "", "")):
            c._tick()
        self.assertEqual(c.state["appTitle"], "Document - Editor")
        self.assertEqual(c._apps, recorded)
        c.setPreference("appTracking", False)
        self.assertEqual(c.state["appTitle"], "Tracking off")
        self.assertEqual(c._foreground_app, "")

    def test_app_name_fallback_and_title_recovery_after_detection_error(self):
        c = self.controller
        c.setPreference("appTracking", True)
        with patch("backend.activity_detector.get_app_title", side_effect=RuntimeError("window closed")):
            c._tick()
        self.assertEqual(c.state["appTitle"], "Unavailable")
        c._last_app_poll = 0
        with patch("backend.activity_detector.get_app_title", return_value=(10, "", "editor.exe")):
            c._tick()
        self.assertEqual(c.state["appTitle"], "editor.exe")

    def test_session_pause_save_and_persistence(self):
        c = self.controller
        self.manual_session()
        self.assertTrue(c.state["active"])
        c.togglePause()
        self.assertTrue(c.state["paused"])
        elapsed = c.tracker.get_total_session_time()
        QTest.qWait(20)
        self.assertAlmostEqual(elapsed, c.tracker.get_total_session_time(), places=5)
        c.togglePause()
        c.requestEnd()
        c.saveSession()
        self.assertFalse(c.state["active"])
        self.assertEqual(c.sessions[0]["title"], "QML integration test")
        c.openSession(c.sessions[0]["id"])
        self.assertEqual(c.state["page"], "details")
        self.assertEqual(c.selectedSession["title"], "QML integration test")
        self.assertEqual(database.get_sessions()[0]["id"], c.selectedSession["id"])

    def test_save_failure_retains_session_for_retry(self):
        c = self.controller
        self.manual_session()
        c.requestEnd()
        with patch.object(database, "save_session", side_effect=sqlite3.OperationalError("disk full")):
            c.saveSession()
        self.assertTrue(c.state["active"])
        self.assertTrue(c.state["paused"])
        self.assertIn("disk full", c.state["error"])
        c.saveSession()
        self.assertEqual(len(c.sessions), 1)

    def test_close_cancel_and_discard(self):
        c = self.controller
        self.manual_session()
        quits = []
        c.quitRequested.connect(lambda: quits.append(True))
        self.assertFalse(c.requestClose())
        self.assertEqual(c.state["prompt"], "end")
        c.cancelEnd()
        self.assertFalse(c.state["paused"])
        c.requestEnd()
        c.discardSession()
        self.assertFalse(quits)
        self.assertFalse(database.get_sessions())
        self.manual_session()
        c.requestClose()
        c.saveSession()
        self.assertEqual(quits, [True])

    def test_camera_permission_failure_retry_and_cancel(self):
        c = self.controller
        c.startSession()
        self.assertEqual(c.state["prompt"], "camera")
        self.assertIsNone(c._camera)
        c.allowCamera()
        c._camera.running = False
        c._camera.failed.emit("Camera unavailable")
        self.assertFalse(c.state["active"])
        self.assertIn("unavailable", c.state["error"])
        c.allowCamera()
        c._camera.ready.emit()
        self.assertTrue(c.state["active"])
        self.assertTrue(c.state["cameraReady"])
        image = QImage(32, 24, QImage.Format.Format_RGB32)
        image.fill(Qt.GlobalColor.green)
        c._camera.frameReady.emit(image, True, False)
        self.assertEqual(c.state["status"], "Focused")
        c._camera.failed.emit("Camera unplugged")
        self.assertTrue(c.state["paused"])
        self.assertEqual(c.state["prompt"], "camera")
        c.cancelCamera()
        self.assertEqual(c.state["prompt"], "")
        c.togglePause()
        self.assertEqual(c.state["prompt"], "camera")

    def test_cancelling_camera_start_ignores_late_ready(self):
        c = self.controller
        c.startSession()
        c.allowCamera()
        c.cancelCamera()
        c._camera.ready.emit()
        self.assertFalse(c.state["active"])
        self.assertFalse(c.state["cameraReady"])

    def test_distraction_prompt_records_event_and_resumes(self):
        c = self.controller
        c.startSession()
        c.allowCamera()
        c._camera.ready.emit()
        c._tick()
        c._status_since -= 19
        c._tick()
        self.assertEqual(c.state["prompt"], "distraction")
        self.assertTrue(c.state["paused"])
        self.assertEqual(c._events[0]["kind"], "Face not detected")
        c.resumeFocus()
        self.assertFalse(c.state["paused"])
        self.assertEqual(c.state["prompt"], "")

    def test_duration_completion_and_settings(self):
        c = self.controller
        c.setPreference("focusMinutes", 30)
        self.assertEqual(self.settings.value("focusMinutes", type=int), 30)
        self.manual_session()
        c.setPreference("focusTracking", True)
        self.assertFalse(c.state["focusTracking"])
        c.tracker.timer_start -= 1801
        c._tick()
        self.assertEqual(c.state["prompt"], "end")
        self.assertEqual(c.state["remaining"], "00:00")
        c.saveSession()
        self.assertIn("Break:", c.state["sessionHint"])

    def test_existing_database_is_migrated_without_losing_rows(self):
        other = Path(self.tmp.name) / "legacy.db"
        with closing(sqlite3.connect(other)) as connection:
            with connection:
                connection.execute("CREATE TABLE sessions (id INTEGER PRIMARY KEY, started_at TEXT, ended_at TEXT, focus_seconds REAL, session_seconds REAL, distraction_seconds REAL)")
                connection.execute("INSERT INTO sessions VALUES (1, '2026-10-01 12:00:00', '2026-10-01 12:25:00', 1200, 1500, 300)")
        with patch.object(database, "DATABASE_NAME", other):
            database.initialize_qml_database()
            database.initialize_qml_database()
            rows = database.get_sessions()
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["focus_seconds"], 1200)
        self.assertEqual(rows[0]["title"], "Focus session")


class QmlIntegrationTests(ControllerFixture, unittest.TestCase):
    def test_detected_app_title_reaches_ready_and_session_screens(self):
        c = self.controller
        c.setPreference("appTracking", True)
        title = "A long document title that should be available in full - Editor"
        with patch("backend.activity_detector.get_app_title", return_value=(10, title, "editor.exe")):
            c._tick()
            APP.processEvents()
            field = self.window.findChild(QObject, "detectedAppTitle")
            self.assertEqual(field.property("text"), title)
            self.manual_session()
            APP.processEvents()
            field = self.window.findChild(QObject, "detectedAppTitle")
            self.assertEqual(field.property("text"), title)
        self.assertFalse(self.warnings, "\n".join(self.warnings))

    def setUp(self):
        super().setUp()
        self.engine = QQmlApplicationEngine()
        self.warnings = []
        self.engine.warnings.connect(lambda errors: self.warnings.extend(e.toString() for e in errors))
        self.engine.addImportPath(str(PROJECT / "assets"))
        self.engine.addImageProvider("camera", self.controller.image_provider)
        self.engine.setInitialProperties({"controller": self.controller})
        self.engine.load(QUrl.fromLocalFile(str(PROJECT / "ui" / "Main.qml")))
        self.assertTrue(self.engine.rootObjects(), self.warnings)
        self.window = self.engine.rootObjects()[0]
        QTest.qWait(50)

    def tearDown(self):
        self.window.setProperty("allowClose", True)
        self.window.close()
        self.engine.deleteLater()
        # Process deferred deletion before the controller and image provider die.
        from PySide6.QtCore import QCoreApplication, QEvent
        QCoreApplication.sendPostedEvents(None, QEvent.Type.DeferredDelete)
        super().tearDown()

    def click(self, x, y):
        QTest.mouseClick(self.window, Qt.MouseButton.LeftButton, Qt.KeyboardModifier.NoModifier, QPoint(x, y))
        QTest.qWait(30)

    def test_clicks_navigation_session_and_history(self):
        self.click(100, 226)
        self.assertEqual(self.controller.state["page"], "settings")
        self.click(1020, 399)
        self.assertFalse(self.controller.state["focusTracking"])
        self.click(100, 120)
        self.assertEqual(self.controller.state["page"], "focus")
        self.click(450, 430)
        self.assertTrue(self.controller.state["active"])
        self.click(450, 430)
        self.assertTrue(self.controller.state["paused"])
        self.click(450, 430)
        self.assertFalse(self.controller.state["paused"])
        self.click(620, 430)
        self.assertEqual(self.controller.state["prompt"], "end")
        self.click(780, 450)
        self.assertEqual(len(self.controller.sessions), 1)
        self.assertEqual(self.controller.state["page"], "history")
        self.click(400, 360)
        self.assertEqual(self.controller.state["page"], "details")
        self.assertFalse(self.warnings, "\n".join(self.warnings))

    def test_all_prompt_screens_and_camera_image(self):
        c = self.controller
        self.click(450, 430)
        self.assertEqual(c.state["prompt"], "camera")
        c.allowCamera()
        c._camera.ready.emit()
        image = QImage(32, 24, QImage.Format.Format_RGB32)
        image.fill(Qt.GlobalColor.green)
        c._camera.frameReady.emit(image, False, False)
        QTest.qWait(30)
        c._tick()
        c._status_since -= 19
        c._tick()
        QTest.qWait(30)
        self.assertEqual(c.state["prompt"], "distraction")
        c.resumeFocus()
        c.requestEnd()
        QTest.qWait(30)
        self.assertFalse(self.warnings, "\n".join(self.warnings))

    def test_task_edit_survives_timer_updates(self):
        field = self.window.findChild(QObject, "taskName")
        self.assertIsNotNone(field)
        field.setProperty("text", "An unfinished task name")
        for _ in range(5):
            self.controller._tick()
            APP.processEvents()
        self.assertEqual(field.property("text"), "An unfinished task name")

    def test_main_content_expands_without_widening_sidebar(self):
        self.window.resize(1600, 1000)
        QTest.qWait(50)

        sidebar = self.window.findChild(QObject, "appSidebar")
        content = self.window.findChild(QObject, "appContent")
        self.assertIsNotNone(sidebar)
        self.assertIsNotNone(content)
        self.assertEqual(sidebar.property("width"), 208)
        self.assertEqual(sidebar.property("height"), 1000)
        self.assertGreater(content.property("scale"), 1)
        self.assertGreater(content.property("x"), sidebar.property("width"))

    def test_wordmark_fits_all_application_pages(self):
        self.assertEqual(QFontInfo(QFont("IBM Plex Sans")).family(), "DejaVu Sans")
        self.assertEqual(QFontInfo(QFont("Bodoni Moda")).family(), "DejaVu Serif")

        def assert_wordmark_fits():
            wordmark = self.window.findChild(QObject, "flowZenWordmark")
            self.assertIsNotNone(wordmark)
            self.assertEqual(wordmark.property("text"), "FlowZen")
            self.assertLessEqual(wordmark.property("paintedWidth"), wordmark.property("width"))

        for page in ("focus", "history", "settings"):
            self.controller.navigate(page)
            APP.processEvents()
            assert_wordmark_fits()

        self.manual_session()
        APP.processEvents()
        assert_wordmark_fits()
        self.controller.requestEnd()
        self.controller.saveSession()
        self.controller.openSession(self.controller.sessions[0]["id"])
        APP.processEvents()
        assert_wordmark_fits()
        self.assertFalse(self.warnings, "\n".join(self.warnings))


if __name__ == "__main__":
    unittest.main()

import cv2 as cv
from PySide6.QtCore import QTimer, Qt
from PySide6.QtWidgets import QMainWindow, QDialog, QDialogButtonBox
from mainwindow_ui import Ui_MainWindow
from backend.focus_tracker import FocusTracker
from PySide6.QtGui import QImage, QPixmap
from backend import database
from save_dialog_ui import Ui_Dialog


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.tracker = FocusTracker()
        self.cam = cv.VideoCapture(0)
        self.timer = QTimer(self)
        database.create_database()

        # Buttons should remain usable even if the camera is unavailable.
        self.ui.start_button.clicked.connect(self.tracker.start_timer)
        self.ui.pause_button.clicked.connect(self.tracker.pause_timer)
        self.ui.reset_button.clicked.connect(self.tracker.reset)
        self.ui.quit_button.clicked.connect(self.open_save_dialog)

        if not self.cam.isOpened():
            print("Could not open webcam")
            return

        self.timer.timeout.connect(self.update_frame)
        self.timer.start(30)

    def update_frame(self):
        ret, frame_bgr = self.cam.read()

        if not ret:
            return

        frame_rgb = cv.cvtColor(frame_bgr, cv.COLOR_BGR2RGB)

        if not self.tracker.paused:
            self.tracker.process_frame(frame_rgb)

        focus_time = f"{self.tracker.get_formatted_time()}"
        self.ui.time_label.setText(focus_time)
        self.label_status()

        self.display_frame(frame_rgb)

    def display_frame(self, frame_rgb):
        height, width, channels = frame_rgb.shape

        # How much data it takes to store one row of data
        bytes_per_line = channels * width

        q_img = QImage(frame_rgb.data, width, height, bytes_per_line, QImage.Format.Format_RGB888)

        q_img = q_img.copy()

        pixmap = QPixmap.fromImage(q_img)

        label_height = self.ui.camera_label.height()
        label_width = self.ui.camera_label.width()

        pixmap = pixmap.scaled(label_width, label_height, Qt.KeepAspectRatio, Qt.SmoothTransformation)

        self.ui.camera_label.setPixmap(pixmap)

    def closeEvent(self, event):
        if not self.tracker.session_active:
            self.timer.stop()
            event.accept()
            self.cam.release()
            return

        if not self.tracker.paused:
            self.tracker.pause_timer()

        dialog = SaveDialog()
        dialog.exec()

        if dialog.choice == "save":
            self.timer.stop()
            self.save_session()
            self.cam.release()
            event.accept()

        elif dialog.choice == "discard":
            self.timer.stop()
            self.cam.release()
            self.tracker.quit_timer()
            event.accept()

        elif dialog.choice == "cancel" or dialog.choice is None:
            event.ignore()

    def label_status(self):
        if not self.tracker.session_active:
            self.ui.status_label.setText("Session not active")
        elif self.tracker.paused:
            self.ui.status_label.setText(f"Paused (Total Time: {self.tracker.get_formatted_session_time()})")
        elif not self.tracker.face_detected:
            self.ui.status_label.setText(f"Face not detected (Total Time: {self.tracker.get_formatted_session_time()})")
        elif self.tracker.distracted:
            self.ui.status_label.setText(f"Distracted (Total Time: {self.tracker.get_formatted_session_time()})")
        else:
            self.ui.status_label.setText(f"Focused (Total Time: {self.tracker.get_formatted_session_time()})")

    def save_session(self):
        if not self.tracker.session_active:
            return

        self.tracker.quit_timer()

        focus_seconds = self.tracker.get_total_time()
        session_seconds = self.tracker.get_total_session_time()
        distraction_seconds = self.tracker.get_total_distraction_time()

        database.save_session(self.tracker.started_at, focus_seconds, session_seconds, distraction_seconds)

        self.tracker.reset()

    def open_save_dialog(self):
        if not self.tracker.session_active:
            return

        if not self.tracker.paused:
            self.tracker.pause_timer()

        dialog = SaveDialog()
        dialog.exec()

        if dialog.choice == "save":
            self.save_session()

        elif dialog.choice == "discard":
            self.tracker.quit_timer()
            self.tracker.reset()

        elif dialog.choice == "cancel":
            return



class SaveDialog(QDialog):
    def __init__(self):
        super().__init__()

        self.ui = Ui_Dialog()
        self.ui.setupUi(self)

        self.choice = None

        # All three buttons belong to the same button box
        self.ui.buttonBox.clicked.connect(self.handle_button)

    def handle_button(self, button):
        selected_button = self.ui.buttonBox.standardButton(button)

        if selected_button == QDialogButtonBox.StandardButton.Save:
            self.choice = "save"
            self.accept()

        elif selected_button == QDialogButtonBox.StandardButton.Discard:
            self.choice = "discard"
            self.accept()

        elif selected_button == QDialogButtonBox.StandardButton.Cancel:
            self.choice = "cancel"
            self.reject()



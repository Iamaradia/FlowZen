import cv2 as cv

from PySide6.QtCore import QTimer
from PySide6.QtWidgets import QMainWindow

from focus_tracker import FocusTracker


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.tracker = FocusTracker()
        self.cam = cv.VideoCapture(0)

        if not self.cam.isOpened():
            print("Could not open webcam")
            return

        self.timer = QTimer()
        self.timer.timeout.connect(self.update_frame)
        self.timer.start(30)

    def update_frame(self):
        ret, frame_bgr = self.cam.read()

        if not ret:
            return

        self.tracker.process_frame(frame_bgr)

        focus_time = self.tracker.get_formatted_time()
        distracted = self.tracker.distracted

        # Later:
        # Display frame_bgr in a QLabel
        # Display focus_time in a QLabel
        # Display distracted status in a QLabel

    def closeEvent(self, event):
        self.cam.release()
        event.accept()
"""Camera capture and model inference run outside the QML thread."""

import time
from threading import Lock

from PySide6.QtCore import QThread, Signal
from PySide6.QtGui import QImage
from PySide6.QtQuick import QQuickImageProvider


class CameraImageProvider(QQuickImageProvider):
    def __init__(self):
        super().__init__(QQuickImageProvider.ImageType.Image)
        self._lock = Lock()
        self._image = QImage(1, 1, QImage.Format.Format_RGB32)
        self._image.fill(0)

    def update(self, image):
        with self._lock:
            self._image = image.copy()

    def requestImage(self, identifier, size, requestedSize):
        with self._lock:
            image = self._image.copy()
        if size is not None:
            size.setWidth(image.width())
            size.setHeight(image.height())
        return image


class CameraWorker(QThread):
    ready = Signal()
    frameReady = Signal(QImage, bool, object)
    failed = Signal(str)

    def run(self):
        camera = None
        try:
            import cv2 as cv
            from backend import face_tracker

            if self.isInterruptionRequested():
                return
            camera = cv.VideoCapture(0)
            if not camera.isOpened():
                raise RuntimeError("Cannot open the webcam. Check camera access in Windows Settings and close other camera apps.")
            camera.set(cv.CAP_PROP_FRAME_WIDTH, 640)
            camera.set(cv.CAP_PROP_FRAME_HEIGHT, 480)
            self.ready.emit()
            count = 0
            while not self.isInterruptionRequested():
                ok, frame = camera.read()
                if not ok:
                    raise RuntimeError("The camera stopped sending frames. Reconnect it and try again.")
                rgb = cv.cvtColor(frame, cv.COLOR_BGR2RGB)
                count += 1
                detect_phone = count % 4 == 0
                result = face_tracker.track_frame(rgb, int(time.perf_counter() * 1000), detect_phone)
                face, phone = result if detect_phone else (result, None)
                image = QImage(rgb.data, rgb.shape[1], rgb.shape[0], rgb.strides[0], QImage.Format.Format_RGB888).copy()
                self.frameReady.emit(image, bool(face and face.face_landmarks), phone)
                self.msleep(30)
        except Exception as error:
            self.failed.emit(str(error))
        finally:
            if camera is not None:
                camera.release()

import time
import cv2 as cv

import face_tracker


class FocusTracker:
    def __init__(self):
        self.focus_start = 0
        self.total_time = 0
        self.studying = False

        self.phone_frame_count = 0
        self.no_phone_frame_count = 0
        self.frame_count = 0

        self.distracted = False

    def process_frame(self, frame_bgr):
        frame_timestamp_ms = int(time.time() * 1000)
        frame_rgb = cv.cvtColor(frame_bgr, cv.COLOR_BGR2RGB)

        self.frame_count += 1
        phone_result = None

        # Run phone detection every fourth frame
        if self.frame_count >= 4:
            self.frame_count = 0

            face_result, phone_result = face_tracker.track_frame(
                frame_rgb,
                frame_timestamp_ms,
                True
            )

            self.update_phone_status(phone_result)

        else:
            face_result = face_tracker.track_frame(
                frame_rgb,
                frame_timestamp_ms
            )

        self.update_focus_status(face_result)

        return face_result, phone_result

    def update_phone_status(self, phone_result):
        if phone_result:
            self.phone_frame_count += 1
            self.no_phone_frame_count = 0
        else:
            self.no_phone_frame_count += 1
            self.phone_frame_count = 0

        if self.phone_frame_count >= 3:
            self.distracted = True

        if self.no_phone_frame_count >= 3:
            self.distracted = False

    def update_focus_status(self, face_result):
        face_detected = (
            face_result is not None
            and bool(face_result.face_landmarks)
        )

        if face_detected and not self.studying:
            self.studying = True
            self.focus_start = time.perf_counter()

        elif not face_detected and self.studying:
            elapsed = time.perf_counter() - self.focus_start

            self.total_time += elapsed
            self.studying = False

    def get_total_time(self):
        current_total = self.total_time

        if self.studying:
            active_stretch = time.perf_counter() - self.focus_start
            current_total += active_stretch

        return current_total

    def get_formatted_time(self):
        current_total = self.get_total_time()

        hours = int(current_total // 3600)
        minutes = int((current_total % 3600) // 60)
        seconds = int(current_total % 60)

        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

    def reset(self):
        self.focus_start = 0
        self.total_time = 0
        self.studying = False

        self.phone_frame_count = 0
        self.no_phone_frame_count = 0
        self.frame_count = 0

        self.distracted = False
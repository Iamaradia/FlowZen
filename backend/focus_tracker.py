import time
from datetime import datetime


class FocusTracker:
    def __init__(self):
        # Focus timing
        self.focus_start = 0
        self.time_studying = 0
        self.studying = False

        # Full session timing
        self.timer_start = 0
        self.total_session_time = 0
        self.session_active = False

        # Pause timing
        self.pause_start = 0
        self.total_pause_time = 0
        self.paused = False

        # Detection information
        self.face_detected = False
        self.distracted = False

        # Distraction timing
        self.distraction_start = 0
        self.distraction_seconds = 0
        self.started_at = None

        self.phone_frame_count = 0
        self.no_phone_frame_count = 0
        self.frame_count = 0

    def process_frame(self, frame_rgb):
        # Load detection models only when a camera is actually in use.
        from backend import face_tracker

        # MediaPipe VIDEO mode requires monotonically increasing timestamps.
        frame_timestamp_ms = int(time.perf_counter() * 1000)

        self.frame_count += 1
        phone_result = None

        # Phone detection is slower, so only run it every fourth frame
        if self.frame_count >= 4:
            self.frame_count = 0

            face_result, phone_result = face_tracker.track_frame(
                frame_rgb,
                frame_timestamp_ms,
                True
            )

            if self.session_active and not self.paused:
                self.update_phone_status(phone_result)

        else:
            face_result = face_tracker.track_frame(
                frame_rgb,
                frame_timestamp_ms
            )

        # The camera can keep running while paused,
        # but the timer should not change
        if self.session_active and not self.paused:
            self.update_focus_status(face_result)

        return face_result, phone_result

    def update_phone_status(self, phone_result):
        if phone_result:
            self.phone_frame_count += 1
            self.no_phone_frame_count = 0
        else:
            self.no_phone_frame_count += 1
            self.phone_frame_count = 0

        # Start timing when the user first becomes distracted
        if self.phone_frame_count >= 3 and not self.distracted:
            self.distracted = True
            self.distraction_start = time.perf_counter()

        # Save that distraction stretch when the phone disappears
        elif self.no_phone_frame_count >= 3 and self.distracted:
            elapsed = time.perf_counter() - self.distraction_start
            self.distraction_seconds += elapsed

            self.distraction_start = 0
            self.distracted = False

    def update_focus_status(self, face_result):
        self.face_detected = (
            face_result is not None
            and bool(face_result.face_landmarks)
        )

        is_focused = self.face_detected and not self.distracted

        # A visible phone makes this a distracted rather than focused stretch.
        if is_focused and not self.studying:
            self.studying = True
            self.focus_start = time.perf_counter()

        # Save the focused stretch when the face disappears
        elif not is_focused and self.studying:
            elapsed = time.perf_counter() - self.focus_start

            self.time_studying += elapsed
            self.studying = False
            self.focus_start = 0

    def get_total_time(self):
        current_total = self.time_studying

        # Include the focused stretch that is still happening
        if self.session_active and self.studying and not self.paused:
            active_stretch = time.perf_counter() - self.focus_start
            current_total += active_stretch

        return current_total

    def get_total_session_time(self):
        if not self.session_active:
            return self.total_session_time

        current_time = time.perf_counter()

        session_time = (
            current_time
            - self.timer_start
            - self.total_pause_time
        )

        # The current pause has not been added yet
        if self.paused:
            current_pause = current_time - self.pause_start
            session_time -= current_pause

        return session_time

    def get_formatted_time(self):
        current_total = self.get_total_time()

        hours = int(current_total // 3600)
        minutes = int((current_total % 3600) // 60)
        seconds = int(current_total % 60)

        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

    def get_formatted_session_time(self):
        current_total = self.get_total_session_time()

        hours = int(current_total // 3600)
        minutes = int((current_total % 3600) // 60)
        seconds = int(current_total % 60)

        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

    def start_timer(self):
        current_time = time.perf_counter()

        # Start creates a fresh session when no session exists
        if not self.session_active:
            self.focus_start = 0
            self.time_studying = 0
            self.studying = False

            self.timer_start = current_time
            self.total_session_time = 0
            self.session_active = True

            self.pause_start = 0
            self.total_pause_time = 0
            self.paused = False

            self.face_detected = False
            self.distracted = False

            self.phone_frame_count = 0
            self.no_phone_frame_count = 0
            self.frame_count = 0

            self.distraction_start = 0
            self.distraction_seconds = 0
            self.started_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # If a session exists, Start works as Resume
        elif self.paused:
            current_pause = current_time - self.pause_start
            self.total_pause_time += current_pause

            self.pause_start = 0
            self.paused = False
            self.distracted = False
            self.phone_frame_count = 0
            self.no_phone_frame_count = 0


    def pause_timer(self):
        if not self.session_active or self.paused:
            return

        current_time = time.perf_counter()

        # Finish the current focused stretch before pausing
        if self.studying:
            active_stretch = current_time - self.focus_start
            self.time_studying += active_stretch

            self.studying = False
            self.focus_start = 0

        if self.distracted:
            distraction_stretch = current_time - self.distraction_start
            self.distraction_seconds += distraction_stretch

            self.distraction_start = 0
            self.distracted = False

        self.pause_start = current_time
        self.paused = True
        self.distracted = False
        self.phone_frame_count = 0
        self.no_phone_frame_count = 0

    def quit_timer(self):
        if not self.session_active:
            return

        current_time = time.perf_counter()

        # Save any focused time that has not been stored yet
        if self.studying:
            active_stretch = current_time - self.focus_start
            self.time_studying += active_stretch

            self.studying = False

        # Save the unfinished pause if Quit is pressed while paused
        if self.paused:
            current_pause = current_time - self.pause_start
            self.total_pause_time += current_pause

        self.total_session_time = (current_time - self.timer_start - self.total_pause_time)

        if self.distracted:
            distraction_stretch = current_time - self.distraction_start
            self.distraction_seconds += distraction_stretch

            self.distraction_start = 0
            self.distracted = False

        # The results stay saved, but the session itself is finished
        self.session_active = False
        self.paused = False
        self.studying = False

        self.timer_start = 0
        self.pause_start = 0
        self.focus_start = 0

        self.phone_frame_count = 0
        self.no_phone_frame_count = 0
        self.frame_count = 0

        self.face_detected = False
        self.distracted = False

    def reset(self):
        # Reset removes the session and all saved results
        self.focus_start = 0
        self.time_studying = 0
        self.studying = False

        self.timer_start = 0
        self.total_session_time = 0
        self.session_active = False

        self.pause_start = 0
        self.total_pause_time = 0
        self.paused = False

        self.face_detected = False
        self.distracted = False

        self.phone_frame_count = 0
        self.no_phone_frame_count = 0
        self.frame_count = 0

        self.distraction_start = 0
        self.distraction_seconds = 0
        self.started_at = None

    def get_total_distraction_time(self):
        current_total = self.distraction_seconds

        # Include a distraction that is still happening
        if self.session_active and self.distracted and not self.paused:
            current_total += time.perf_counter() - self.distraction_start

        return current_total

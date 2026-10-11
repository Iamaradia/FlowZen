import time
from datetime import datetime, timedelta
from types import SimpleNamespace

from PySide6.QtCore import QObject, Property, QSettings, QTimer, Signal, Slot
from PySide6.QtGui import QImage

from backend import database
from backend.camera_worker import CameraImageProvider, CameraWorker
from backend.focus_tracker import FocusTracker


def duration(seconds):
    seconds = max(0, int(seconds or 0))
    if seconds >= 3600:
        return f"{seconds // 3600}h {seconds % 3600 // 60}m"
    return f"{seconds // 60}m {seconds % 60:02d}s"


def clock_text(seconds):
    seconds = max(0, int(seconds))
    return f"{seconds // 60:02d}:{seconds % 60:02d}"


def score(focused, total):
    return f"{min(100, round(100 * focused / total)) if total else 0}%"


class AppController(QObject):
    stateChanged = Signal()
    titleChanged = Signal()
    historyChanged = Signal()
    frameChanged = Signal()
    quitRequested = Signal()
    soundRequested = Signal()

    def __init__(self, parent=None, *, settings=None, camera_factory=CameraWorker):
        super().__init__(parent)
        self.tracker = FocusTracker()
        self.image_provider = CameraImageProvider()
        self._camera_factory = camera_factory
        self._camera = None
        self._camera_ready = False
        self._camera_starting = False
        self._frame_number = 0
        self._settings = settings if settings is not None else QSettings("FlowZen", "FlowZen")
        self._preferences = {
            "focusMinutes": self._settings.value("focusMinutes", 25, type=int),
            "breakMinutes": self._settings.value("breakMinutes", 5, type=int),
            "focusTracking": self._settings.value("focusTracking", True, type=bool),
            "appTracking": self._settings.value("appTracking", True, type=bool),
            "sessionSound": self._settings.value("sessionSound", True, type=bool),
        }
        self._page = "focus"
        self._prompt = ""
        self._title = "Focus session"
        self._error = ""
        self._app_title = "None detected"
        self._foreground_app = ""
        self._sessions = []
        self._selected = {}
        self._summary = {}
        self._pending_close = False
        self._resume_after_end = False
        self._previous_prompt = ""
        self._target_seconds = self._preferences["focusMinutes"] * 60
        self._break_until = 0
        self._events = []
        self._apps = {}
        self._away_seconds = 0
        self._last_tick = time.perf_counter()
        self._status_since = self._last_tick
        self._last_status = "Ready"
        self._event = None
        self._last_app_poll = 0
        database.initialize_qml_database()
        self.refresh_history()
        self.timer = QTimer(self)
        self.timer.setInterval(200)
        self.timer.timeout.connect(self._tick)
        self.timer.start()

    @Property("QVariantMap", notify=stateChanged)
    def state(self):
        active = self.tracker.session_active
        remaining = self._target_seconds - self.tracker.get_total_session_time() if active else self._preferences["focusMinutes"] * 60
        break_left = max(0, self._break_until - time.perf_counter())
        return {
            **self._preferences,
            "page": self._page, "prompt": self._prompt, "title": self._title,
            "active": active, "paused": self.tracker.paused,
            "remaining": clock_text(remaining), "status": self._status(),
            "cameraReady": self._camera_ready, "cameraStarting": self._camera_starting,
            "appTitle": self._app_title, "error": self._error,
            "sessionHint": (f"Break: {clock_text(break_left)} remaining" if break_left else
                            f"{duration(self.tracker.get_total_time())} focused" if active else
                            f"Focus time / {self._preferences['breakMinutes']} min break after"),
            "distractionReason": "A phone was detected. Put it aside when you are ready." if self._last_status == "Phone detected" else "You have been away from the camera. Resume when you are ready.",
        }

    @Property(str, notify=frameChanged)
    def cameraSource(self):
        return f"image://camera/{self._frame_number}"

    @Property(str, notify=titleChanged)
    def sessionTitle(self):
        return self._title

    @Property("QVariantList", notify=historyChanged)
    def sessions(self):
        return self._sessions

    @Property("QVariantMap", notify=historyChanged)
    def summary(self):
        return self._summary

    @Property("QVariantMap", notify=historyChanged)
    def selectedSession(self):
        return self._selected

    def _status(self):
        if self._camera_starting:
            return "Opening camera"
        if not self.tracker.session_active:
            return "Ready" if self._preferences["focusTracking"] else "Manual timer"
        if self.tracker.paused:
            return "Paused"
        if not self._preferences["focusTracking"]:
            return "Manual timer"
        if self.tracker.distracted:
            return "Phone detected"
        return "Focused" if self.tracker.face_detected else "Face not detected"

    @Slot(str)
    def navigate(self, page):
        if page in ("focus", "history", "settings") and not self._prompt:
            self._page = page
            if page == "history":
                self.refresh_history()
            self.stateChanged.emit()

    @Slot(str)
    def setTitle(self, title):
        if not self.tracker.session_active:
            self._title = title.strip()[:160] or "Focus session"
            self.titleChanged.emit()
            self.stateChanged.emit()

    @Slot()
    def startSession(self):
        if self.tracker.session_active:
            return
        self._error = ""
        if self._preferences["focusTracking"] and not self._camera_ready:
            self._prompt = "camera"
            self.stateChanged.emit()
            return
        self._begin_session()

    def _begin_session(self):
        self._target_seconds = self._preferences["focusMinutes"] * 60
        self._break_until = 0
        self._events, self._apps = [], {}
        self._away_seconds = 0
        self._event = None
        self.tracker.start_timer()
        self._last_tick = self._status_since = time.perf_counter()
        self._last_app_poll = 0
        self._last_status = "Ready"
        self._page, self._prompt = "focus", ""
        self.stateChanged.emit()

    @Slot()
    def allowCamera(self):
        if self._camera is not None and self._camera.isRunning():
            return
        self._error = ""
        self._camera_starting = True
        self._camera = self._camera_factory(self)
        self._camera.ready.connect(self._on_camera_ready)
        self._camera.frameReady.connect(self._on_frame)
        self._camera.failed.connect(self._on_camera_error)
        self._camera.start()
        self.stateChanged.emit()

    @Slot()
    def _on_camera_ready(self):
        if not self._camera_starting or self._prompt != "camera":
            self._stop_camera()
            return
        self._camera_starting, self._camera_ready = False, True
        self._prompt = ""
        if self.tracker.session_active:
            self.tracker.start_timer()
            self.stateChanged.emit()
        else:
            self._begin_session()

    @Slot(QImage, bool, object)
    def _on_frame(self, image, face_present, phone):
        if not self._camera_ready:
            return
        self.image_provider.update(image)
        self._frame_number += 1
        self.frameChanged.emit()
        if self.tracker.session_active and not self.tracker.paused:
            if phone is not None:
                self.tracker.update_phone_status(phone)
            self.tracker.update_focus_status(SimpleNamespace(face_landmarks=[True] if face_present else []))

    @Slot(str)
    def _on_camera_error(self, message):
        if not self._camera_starting and not self._camera_ready:
            return
        self._tick()
        self.tracker.pause_timer()
        self._close_event()
        self._camera_ready = self._camera_starting = False
        self._error = message
        self._prompt = "camera"
        self.stateChanged.emit()

    def _stop_camera(self):
        self._camera_ready = self._camera_starting = False
        if self._camera is not None:
            self._camera.requestInterruption()

    @Slot()
    def cancelCamera(self):
        self._stop_camera()
        self._prompt = ""
        self._error = ""
        self.stateChanged.emit()

    @Slot()
    def togglePause(self):
        if not self.tracker.session_active:
            return
        if self.tracker.paused:
            if self._preferences["focusTracking"] and not self._camera_ready:
                self._prompt = "camera"
            else:
                self.tracker.start_timer()
                self._last_tick = self._status_since = time.perf_counter()
                self._last_status = "Ready"
        else:
            self._tick()
            self.tracker.pause_timer()
            self._close_event()
        self.stateChanged.emit()

    @Slot()
    def resumeFocus(self):
        self._prompt = ""
        if self.tracker.paused:
            self.togglePause()
        self.stateChanged.emit()

    @Slot()
    def requestEnd(self):
        if not self.tracker.session_active or self._prompt == "end":
            return
        self._previous_prompt = self._prompt
        self._resume_after_end = not self.tracker.paused
        self._tick()
        self.tracker.pause_timer()
        self._close_event()
        self._prompt = "end"
        self.stateChanged.emit()

    @Slot()
    def cancelEnd(self):
        self._pending_close = False
        self._prompt = self._previous_prompt
        self._error = ""
        if self._resume_after_end:
            self.tracker.start_timer()
            self._last_tick = self._status_since = time.perf_counter()
            self._last_status = "Ready"
        self.stateChanged.emit()

    @Slot()
    def saveSession(self):
        if not self.tracker.session_active:
            return
        self._tick()
        self.tracker.pause_timer()
        self._close_event()
        total = self.tracker.get_total_session_time()
        try:
            database.save_session(
                self.tracker.started_at, self.tracker.get_total_time(), total,
                self.tracker.get_total_distraction_time(), title=self._title,
                events=self._events, apps=[{"title": k, "seconds": v} for k, v in self._apps.items()],
                away_seconds=self._away_seconds,
            )
        except Exception as error:
            self._error = f"Could not save the session: {error}. Your session is still available; please retry."
            self._prompt = "end"
            self.stateChanged.emit()
            return
        self.tracker.reset()
        self._stop_camera()
        self._prompt = self._error = ""
        self._page = "history"
        if total >= self._target_seconds:
            self._break_until = time.perf_counter() + self._preferences["breakMinutes"] * 60
        self.refresh_history()
        self.stateChanged.emit()
        if self._pending_close:
            self.quitRequested.emit()

    @Slot()
    def discardSession(self):
        self.tracker.reset()
        self._stop_camera()
        self._prompt = self._error = ""
        self._page = "focus"
        self.stateChanged.emit()
        if self._pending_close:
            self.quitRequested.emit()

    @Slot(result=bool)
    def requestClose(self):
        if not self.tracker.session_active:
            return True
        self._pending_close = True
        self.requestEnd()
        return False

    @Slot(str, "QVariant")
    def setPreference(self, name, value):
        if name not in self._preferences:
            return
        if self.tracker.session_active and name in ("focusTracking", "focusMinutes"):
            self._error = "Finish the current session before changing its duration or focus tracking."
            self.stateChanged.emit()
            return
        if name in ("focusMinutes", "breakMinutes"):
            value = max(1, min(120 if name == "focusMinutes" else 60, int(value)))
        else:
            value = bool(value)
        self._preferences[name] = value
        self._settings.setValue(name, value)
        self._settings.sync()
        self._error = ""
        if name == "appTracking" and not value:
            self._app_title = "Tracking off"
            self._foreground_app = ""
        elif name == "appTracking":
            self._app_title = "None detected"
            self._last_app_poll = 0
        self.stateChanged.emit()

    @Slot()
    def clearError(self):
        self._error = ""
        self.stateChanged.emit()

    @Slot(int)
    def openSession(self, identifier):
        record = next((row for row in self._sessions if row["id"] == identifier), None)
        if record is not None:
            self._selected = record
            self._page = "details"
            self.historyChanged.emit()
            self.stateChanged.emit()

    def refresh_history(self):
        self._sessions = []
        for row in database.get_sessions():
            row["duration"] = duration(row["session_seconds"])
            row["score"] = score(row["focus_seconds"] or 0, row["session_seconds"] or 0)
            row["date"] = row["started_at"] or "Unknown date"
            row["away"] = duration(row["away_seconds"])
            row["distractions"] = str(sum(e.get("kind") == "Phone detected" for e in row["events"]))
            for event in row["events"]:
                event["duration"] = duration(event.get("seconds", 0))
            for app in row["apps"]:
                app["duration"] = duration(app.get("seconds", 0))
            self._sessions.append(row)
        today = datetime.now().date()
        week_start = str(today - timedelta(days=today.weekday()))
        daily = [s for s in self._sessions if s["date"].startswith(str(today))]
        weekly = [s for s in self._sessions if week_start <= s["date"][:10] <= str(today)]
        focused = sum(s["focus_seconds"] or 0 for s in daily)
        longest = max(weekly, key=lambda s: s["session_seconds"] or 0, default=None)
        self._summary = {
            "todayFocus": duration(focused), "todaySessions": f"{len(daily)} sessions",
            "todayScore": score(focused, sum(s["session_seconds"] or 0 for s in daily)),
            "goal": f"{int(focused // 60)} / 120 min",
            "goalRemaining": f"{max(0, 120 - int(focused // 60))} minutes left",
            "lastSession": (f"{self._sessions[0]['title']} · {self._sessions[0]['duration']} · {self._sessions[0]['score']} focus" if self._sessions else "No saved sessions yet"),
            "weekFocus": duration(sum(s["focus_seconds"] or 0 for s in weekly)),
            "weekSessions": f"Across {len(weekly)} sessions",
            "weekScore": score(sum(s["focus_seconds"] or 0 for s in weekly), sum(s["session_seconds"] or 0 for s in weekly)),
            "longestDuration": longest["duration"] if longest else "0m",
            "longestDate": longest["date"] if longest else "No sessions this week",
        }
        self.historyChanged.emit()

    def _close_event(self):
        if self._event is not None:
            self._event["seconds"] = max(0, time.perf_counter() - self._status_since)
            self._events.append(self._event)
            self._event = None

    def _tick(self):
        now = time.perf_counter()
        elapsed = max(0, now - self._last_tick)
        self._last_tick = now
        # Preview detection also runs before starting and while paused. Keep the
        # last external title visible when the user brings FlowZen to the front.
        if self._preferences["appTracking"] and now - self._last_app_poll >= 0.5:
            self._last_app_poll = now
            try:
                from backend.activity_detector import get_app_title
                _, title, app = get_app_title()
                self._foreground_app = title or app or ""
                if self._foreground_app:
                    self._app_title = self._foreground_app
            except Exception:
                self._foreground_app = ""
                self._app_title = "Unavailable"
        if self.tracker.session_active and not self.tracker.paused:
            if not self._preferences["focusTracking"]:
                self.tracker.update_focus_status(SimpleNamespace(face_landmarks=[True]))
            status = self._status()
            if status == "Face not detected":
                self._away_seconds += elapsed
            if status != self._last_status:
                self._close_event()
                self._last_status, self._status_since = status, now
                if status in ("Face not detected", "Phone detected"):
                    self._event = {"kind": status, "time": datetime.now().strftime("%H:%M:%S"), "seconds": 0}
            if self._preferences["appTracking"] and self._foreground_app:
                self._apps[self._foreground_app] = self._apps.get(self._foreground_app, 0) + elapsed
            if self.tracker.get_total_session_time() >= self._target_seconds and not self._prompt:
                self._resume_after_end, self._previous_prompt = False, ""
                self.tracker.pause_timer()
                self._close_event()
                self._prompt = "end"
                if self._preferences["sessionSound"]:
                    self.soundRequested.emit()
            elif status in ("Face not detected", "Phone detected") and now - self._status_since >= 18 and not self._prompt:
                self.tracker.pause_timer()
                self._close_event()
                self._prompt = "distraction"
        self.stateChanged.emit()

    @Slot()
    def shutdown(self):
        self.timer.stop()
        self._stop_camera()
        if self._camera is not None:
            self._camera.wait()

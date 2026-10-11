"""Foreground-window edge cases should never stop title detection."""

import os
import unittest
from unittest.mock import patch

import psutil
import pywintypes

from backend import activity_detector as detector


class ActivityDetectorTests(unittest.TestCase):
    def setUp(self):
        self.patches = [
            patch.object(detector.win32gui, "GetForegroundWindow", return_value=123),
            patch.object(detector.win32gui, "GetWindowText", return_value="  Notes - Editor  "),
            patch.object(detector.win32process, "GetWindowThreadProcessId", return_value=(1, os.getpid() + 100)),
            patch.object(detector.psutil, "Process"),
        ]
        self.foreground, self.title, self.pid, self.process = [p.start() for p in self.patches]
        self.process.return_value.name.return_value = "editor.exe"
        for item in self.patches:
            self.addCleanup(item.stop)

    def test_reads_foreground_title_and_executable(self):
        self.assertEqual(detector.get_app_title(), (123, "Notes - Editor", "editor.exe"))

    def test_ignores_flowzen_own_window(self):
        self.pid.return_value = (1, os.getpid())
        self.assertEqual(detector.get_app_title(), (123, "", ""))
        self.process.assert_not_called()

    def test_handles_missing_foreground_window(self):
        self.foreground.return_value = 0
        self.assertEqual(detector.get_app_title(), (0, "", ""))
        self.pid.assert_not_called()

    def test_keeps_title_when_process_access_is_denied_or_process_exits(self):
        for error in (psutil.AccessDenied(42), psutil.NoSuchProcess(42)):
            with self.subTest(error=error):
                self.process.side_effect = error
                self.assertEqual(detector.get_app_title(), (123, "Notes - Editor", ""))

    def test_handles_window_closing_during_detection(self):
        self.title.side_effect = pywintypes.error(1400, "GetWindowText", "Invalid window handle")
        self.assertEqual(detector.get_app_title(), (0, "", ""))


if __name__ == "__main__":
    unittest.main()

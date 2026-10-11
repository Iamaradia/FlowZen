"""Read the foreground Windows application without counting FlowZen itself."""

import os

import psutil
import pywintypes
import win32gui
import win32process

BROWSER_DICT = {
# Chromium-based browsers
    "chrome.exe": "chromium",
    "msedge.exe": "chromium",
    "brave.exe": "chromium",
    "opera.exe": "chromium",
    "opera_gx.exe": "chromium",
    "vivaldi.exe": "chromium",
    "chromium.exe": "chromium",
    "arc.exe": "chromium",
    "thorium.exe": "chromium",
    "slimjet.exe": "chromium",
    "centbrowser.exe": "chromium",
    "coccoc.exe": "chromium",
    "avastbrowser.exe": "chromium",
    "avgbrowser.exe": "chromium",
    "ccleanerbrowser.exe": "chromium",
    "sidekick.exe": "chromium",
    "wavebrowser.exe": "chromium",
    "yandex.exe": "chromium",
    "browser.exe": "chromium",
    "iron.exe": "chromium",
    "maxthon.exe": "chromium",
    "epic.exe": "chromium",
    "dragon.exe": "chromium",

    # Firefox-based browsers
    "firefox.exe": "firefox",
    "floorp.exe": "firefox",
    "librewolf.exe": "firefox",
    "waterfox.exe": "firefox",
    "zen.exe": "firefox",
    "palemoon.exe": "firefox",
    "basilisk.exe": "firefox",
    "seamonkey.exe": "firefox",
    "icecat.exe": "firefox",
}

def get_app_title():
    """Return (handle, window title, executable name) for an external app.

    Windows can temporarily have no foreground window during an app switch.
    A protected or exiting process must not hide a title we can still read.
    An empty title/name indicates that no external app is currently active.
    """
    hwnd = win32gui.GetForegroundWindow()
    if not hwnd:
        return 0, "", ""
    try:
        _, process_id = win32process.GetWindowThreadProcessId(hwnd)
        if not process_id or process_id == os.getpid():
            return hwnd, "", ""
        title = win32gui.GetWindowText(hwnd).strip()
    except pywintypes.error:
        return 0, "", ""
    try:
        app_name = psutil.Process(process_id).name()
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        app_name = ""
    return hwnd, title, app_name



# FlowZen

FlowZen is a Windows desktop focus timer with optional camera-based focus tracking.

## Run from source

Use Python 3.12, then install the project dependencies and launch the app:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe main.py
```

## Build the Windows app

On Windows, install the build dependencies and create the distributable:

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements-build.txt
.\.venv\Scripts\python.exe -m PyInstaller --clean --noconfirm FlowZen.spec
```

The standalone, no-console executable is `dist\FlowZen.exe`. It includes the
application logo, QML interface, and camera models; Python does not need to be
installed on the computer that runs the executable. The first launch can take
longer while the one-file app extracts its bundled runtime.

The session database is stored in the current user's application data folder
when running the packaged app. Camera tracking requires camera permission.
Bundled DejaVu fonts keep the interface readable when the design fonts are
unavailable; their license is included in `assets\fonts\LICENSE_DEJAVU`.

## Run tests

```powershell
.\.venv\Scripts\python.exe -m unittest discover -s tests -v
```

## App title detection

With App title tracking enabled, the detection panel updates before a session,
while tracking, and while paused. Bringing FlowZen to the foreground keeps the
last external app title visible. Hover over a shortened title to see it in full.
App usage durations are recorded only during an active, unpaused session;
FlowZen itself is excluded.

## Credits

Figma to QML

“Foxstocks, Finance Dashboard UI Kit (Darkmode)” by Design with Will, licensed under CC BY 4.0. Modified by Aaradhya Yeginwar for FlowZen, including changes to the branding, colours, layout, navigation, cards, and text.

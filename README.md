# FlowZen

FlowZen is a focus detector with camera focus tracking and app detection. I needed something that would keep me dependable and not let me scroll or play games while I was supposed to study. This app lets me do this and more.

## Run from source

Use Python 3.12, then install the project dependencies and launch the app:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe main.py
```

## Building the Windows app

If you want to run FlowZen without opening Python every time, you can build it into a Windows app:

.\.venv\Scripts\python.exe -m pip install -r requirements-build.txt
.\.venv\Scripts\python.exe -m PyInstaller --clean --noconfirm FlowZen.spec

Once the build finishes, you’ll find the app at dist\FlowZen.exe. The logo, interface, and camera models are included, so you don’t need Python installed to run it. It also opens without a console window.

The first launch might take a little longer because the app needs to unpack its files.

Your session history is saved in your Windows user account’s application data folder. Make sure FlowZen has permission to use your camera so focus tracking can work.

I’ve also included DejaVu fonts as a backup if the original design fonts aren’t available. Their license is in assets\fonts\LICENSE_DEJAVU.

## Run tests

```powershell
.\.venv\Scripts\python.exe -m unittest discover -s tests -v
```

## App title detection

With App title tracking turned on, you can see which app or window you’re using before starting a session, during one, and while paused.

When you switch back to FlowZen, it keeps the last app title visible so you can still see what you were doing. If a title gets cut off, hover over it to read the full name.

App usage time only counts while a session is running and isn’t paused. FlowZen doesn’t count itself toward your usage.

## Credits

Figma to QML

PySide6/Qt, MediaPipe, DejaVu Fonts

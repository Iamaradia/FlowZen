# FlowZen

FlowZen is a focus detector with camera focus tracking and app detection. I needed something that would keep me dependable and not let me scroll or play games while I was supposed to study. This app lets me do this and more.

**THIS APP DOES NOT WORK ON NON WINDOWS OS. ALSO IT WILL TAKE A LONG TIME TO BOOT ON YOUR FIRST TRY.**

<img width="1533" height="816" alt="image" src="https://github.com/user-attachments/assets/219d559d-8705-4772-bf6b-0d8514b6d590" />

## Download

This is how you can try this app out without downloading Python or the whole project. Click the link below and download the .exe file. It may be a little slow to load on you first boot.

[Download FlowZen for Windows](https://github.com/Iamaradia/FlowZen/releases)

## Tutorial

The main page is where you can make focus sessions and lock in, while MediaPipe and the app activity will detect focus. 

<img width="1100" height="721" alt="image" src="https://github.com/user-attachments/assets/d04c716b-bc15-40ba-803d-1fd71642cf38" />

The History page is where you can see all your previous sessions and in detail as well.

<img width="1036" height="517" alt="image" src="https://github.com/user-attachments/assets/43105fd6-cc15-4393-ad64-5e1e08a6e1b3" />

<img width="1034" height="711" alt="image" src="https://github.com/user-attachments/assets/589c900d-4a76-4b06-a8d3-fd5ee256b88d" />

Lastly we have the Settings page where you can change your preferences.

<img width="1078" height="695" alt="image" src="https://github.com/user-attachments/assets/0438ef67-9391-4d6b-9e3d-139e7bac91ac" />


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

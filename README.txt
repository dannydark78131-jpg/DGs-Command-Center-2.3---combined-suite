DGs Command Center 2.3 - combined suite
=======================================

One launcher for every DG tool that was spread across the Desktop\2 folders.

Start it with:
  DGs Command Center.bat            (recommended)
  DGs Command Center.ps1            (run directly in PowerShell)
  Launch-DGs Command Center.vbs      (no console window)


What changed in 2.3
-------------------
* Version bumped to 2.3 in the launcher header, window title, settings dialog,
  install marker, this README and the setup's file version, with a fresh icon
  badged 2.3 (the 2.2 icon is kept at Icons\launcher-2.2.ico). No behaviour
  changes: the tool set is identical to 2.2.

What changed in 2.2
-------------------
* Version bumped to 2.2 in the launcher header, window title, settings dialog,
  install marker, this README and the setup's file version. The launcher icon
  now carries a "2.2" badge, and the 2.1 icon is kept at Icons\launcher-2.1.ico
  so the two releases cannot be mixed up.
* DGS Suite is now the ICO-fixed build (DGS.Suite.Installer.exe-WITH-ICO-FIX):
  one shared DGS-Shared.ico instead of six 419 KB embedded copies, so each
  executable is ~70 KB and the suite installer's icon renders correctly.
* Added DG Uninstaller 1.2.0 (portable plus setup) in Apps\DG Uninstaller, in a
  new Uninstall group.
* The setup uses the same App ID as 2.1, so running it over an installed 2.1
  upgrades it in place instead of adding a second entry to Apps & features.

What changed in 2.1
-------------------
* New launcher icon: a proper multi-resolution ICO (16, 24, 32, 48, 64, 128 and
  256 px) instead of the old single-size image, so it is crisp in the taskbar,
  Explorer, the Start menu and large-icon views. The previous icon is kept at
  Icons\launcher-1.1-legacy.ico.
* Version bumped to 2.1 across the launcher header, window title, settings
  dialog and install marker.

What changed in 2.0
-------------------
* Combined the tools from 1.0-Command Center, 1.0-UniversalToolkit-V1.2,
  1.0-Visual Toolkit, 1.0-image tools, 1.0-Apps-Essential and the archives in
  1.0EnoughAllready into a single Apps folder (94 files, ~192 MB).
* Every tool is now in the launcher: 43 curated entries plus 12 entries found
  automatically, plus 7 Windows shortcuts.
* Fixed: PowerShell tools were launched with "-WindowStyle Hidden", so console
  menus opened invisible and looked broken. They now open in a normal window.
* Fixed: paths with spaces were passed without quoting to cmd.exe and
  powershell.exe, which broke tools in folders such as
  "DGS.Suite.Installer.exe-WITH-ICO-FIX".
* Fixed: the launcher verifies a tool exists before starting it and reports the
  exact missing path instead of a generic failure.
* New: "Run as administrator" in each card's right-click menu.
* New: automatic discovery. Anything copied into Apps\ later appears in the
  launcher on the next start, grouped by its top-level folder, so the list no
  longer has to be edited by hand.


Groups
------
Files & Rename       Bulk File Renamer, Renametool, DGS Renamer, Rename Tool 2.1.1,
                     Bulk Extension Renamer, File Toolkit, SmartSearch, setup
Images & Icons       DGs Image Tools, DGs Explorer Toolkit, Explorer Toolkit 3.1.2,
                     Explorer Toolkit v3, Hardened Toolkit 2.5.1, Image Tools
                     latest/V2, Color Variant Generator, Icon & Shortcut Changer,
                     Fix Desktop Icons, Ficon
Explorer & System    Convert to Light Theme, Power Plan 1.1.1, Windows 10 Debloat
                     GUI, Device Cleanup, Component Deduplicator, Executable
                     Performance Manager, DGS File Search, File List x2,
                     Hardened Toolkit, DGs Searcher, Windows Cleaner
DGS Suite            App Launcher, Debloat, Light Theme, Setup Env, WinUtil,
                     Suite Installer, Install Prerequisites
Uninstall            DG Uninstaller, DG Uninstaller Setup
Tools & Installers   Snipping Tool, Win-PS2EXE, C# Viewer, YouTube Downloader
Source               DGs v0.22 source folder
System               PowerShell, Command Prompt, Task Manager, Control Panel,
                     Explorer, Windows Settings, screen clip


Search, filters, shortcuts
--------------------------
* Type in the search box to filter by tool or group.
* The dropdown filters by group.
* Right-click a card for: Launch, Run as administrator, Open file location,
  Create desktop shortcut, Copy path.
* Theme and accent are in "Theme & Settings" (settings stored in
  %LOCALAPPDATA%\DGs Command Center\settings.json).


Not copied in (still in their original folders)
-----------------------------------------------
These were redundant copies rather than extra tools, and copying them would
have added several GB for no benefit:

* 1.0EnoughAllready            12 GB of ZIP archives of earlier builds.
* 1.0-Apps-Essential\Apps       old Command Center installers (1.1.0 - 2.5.0),
                                VS Code, Opencode and Sparkle setups (~2 GB).
* 1.0-Apps-Essential\DG Command Center   601 MB PyInstaller build of an older
                                Command Center.
* 1.0-image tools              byte-identical copy of Apps\DGs Image Tools.
* DGS Suite standalone EXEs    duplicates of Apps\DGS.Suite.Installer.exe-
                                WITH-ICO-FIX.

Nothing was deleted: the original folders are untouched, so anything left out
can still be copied into Apps\ and it will show up automatically.

# DG's Command Center 3.0 Ultimate Edition
## Product and implementation requirements

This document records the agreed scope for the 3.0 rebuild. Version 2.3 remains unchanged on `main`; development takes place on `feature/dg-command-center-3.0`.

## Product goals
- Modern dark Windows desktop launcher.
- Preserve compatible existing DG applications and integrate the newly supplied DG tool packages.
- Provide a permanent Custom Apps Manager.
- Deliver a tested Inno Setup installer and a reliable uninstaller.

## Launcher
- Search across app name, description, tags and category.
- Categories, favourites, recently used items and configurable app cards.
- Clear launch errors and missing-dependency guidance.
- Settings and diagnostics page.
- Keep app metadata separate from UI code.

## Custom Apps Manager
Users can import:
- ZIP archives containing portable applications.
- Individual files, including EXE, MSI, BAT, CMD, PS1, PY and common document/shortcut types.
- Existing application folders.

For each custom entry, support a display name, description, category, icon, launch target, optional arguments and working directory. Allow edit, remove, re-categorise, favourite and rescan operations.

### Import and execution safety
- Never execute an imported file automatically.
- Show the file type and launch target before first execution.
- Reject path traversal and absolute paths in ZIP entries; extract into a staging directory and validate before moving into the library.
- Prevent archive extraction outside the selected app directory.
- Detect duplicate imports using a content hash and offer skip/replace/keep-both.
- Treat scripts and executables as untrusted user-provided content; do not bypass Windows security controls or PowerShell execution policy.
- For non-executable files, open with the user's Windows file association.
- Validate launch targets still exist and explain when a custom app is unavailable.

## Permanent user data
Store user-owned data outside Program Files and outside the install directory, by default:
- `%LOCALAPPDATA%\DGsCommandCenter\CustomApps\` for imported app payloads.
- `%LOCALAPPDATA%\DGsCommandCenter\data\apps.json` for app metadata.
- `%LOCALAPPDATA%\DGsCommandCenter\backups\` for optional backups.

The launcher must not overwrite these locations during upgrades. The uninstaller must offer to keep or remove user data, defaulting to keep. Provide export/backup and restore capability.

## Installer and upgrades
- Use Inno Setup to produce a signed-ready Windows installer (signing certificate is a release-owner responsibility).
- Support per-user installation without requiring administrator rights where feasible.
- Install required runtime/dependencies and validate them at setup time.
- Create optional Start Menu and desktop shortcuts.
- Support upgrade-in-place, repair/reinstall, and clean uninstall.
- Preserve the permanent user library during upgrades and default uninstall.
- Do not bundle third-party software unless its licence permits redistribution; otherwise provide official download/install steps.

## Compatibility and release checks
- Target Windows 10 and Windows 11, subject to testing on supported editions/builds.
- Test clean install, upgrade from prior release, custom ZIP import, individual-file import, restart persistence, backup/restore, missing app handling, and uninstall with both keep-data and remove-data choices.
- Record app version, source, licence/redistribution status, architecture, dependencies and hash in the app catalogue.

## Current status
This is the approved scope and architecture baseline. Implementation and Windows installer testing have not yet been completed. The source project files and complete tool packages must be available before claiming a working build.

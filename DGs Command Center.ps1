# DGs Command Center v2.3 (Portable) - one launcher for every DG app
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$script:Root = $PSScriptRoot
$script:AppsRoot = Join-Path $script:Root 'Apps'
$script:SuiteRoot = $script:AppsRoot
$script:SettingsDir = Join-Path $env:LOCALAPPDATA 'DGs Command Center'
$script:SettingsPath = Join-Path $script:SettingsDir 'settings.json'
$script:Settings = @{ Theme = 'Dark'; Accent = 'Emerald'; Icon = '' }

if (Test-Path -LiteralPath $script:SettingsPath) {
    try {
        $loaded = Get-Content -LiteralPath $script:SettingsPath -Raw | ConvertFrom-Json
        if ($loaded.Theme -in @('Dark', 'Light')) { $script:Settings.Theme = [string]$loaded.Theme }
        if ($loaded.Accent) { $script:Settings.Accent = [string]$loaded.Accent }
        if ($loaded.Icon) { $script:Settings.Icon = [string]$loaded.Icon }
    } catch { }
}

$script:AccentMap = @{
    Emerald = @(0, 230, 118)
    Ocean   = @(14, 165, 233)
    Royal   = @(99, 102, 241)
    Sunset  = @(249, 115, 22)
    Crimson = @(239, 68, 68)
    Gold    = @(245, 158, 11)
    Teal    = @(20, 184, 166)
    Rose    = @(244, 63, 94)
}
if (-not $script:AccentMap.ContainsKey($script:Settings.Accent)) { $script:Settings.Accent = 'Emerald' }

function Set-Palette {
    $a = $script:AccentMap[$script:Settings.Accent]
    if (-not $a) { $a = @(0, 230, 118) }
    $script:C = @{}
    if ($script:Settings.Theme -eq 'Light') {
        $script:C.Bg      = [Drawing.Color]::FromArgb(244, 247, 245)
        $script:C.Panel   = [Drawing.Color]::FromArgb(255, 255, 255)
        $script:C.Card    = [Drawing.Color]::FromArgb(255, 255, 255)
        $script:C.CardHov = [Drawing.Color]::FromArgb(226, 240, 232)
        $script:C.Text    = [Drawing.Color]::FromArgb(20, 32, 25)
        $script:C.Muted   = [Drawing.Color]::FromArgb(92, 112, 100)
        $script:C.Border  = [Drawing.Color]::FromArgb(205, 218, 210)
        $script:C.Danger  = [Drawing.Color]::FromArgb(210, 60, 60)
    } else {
        $script:C.Bg      = [Drawing.Color]::FromArgb(13, 15, 18)
        $script:C.Panel   = [Drawing.Color]::FromArgb(18, 20, 24)
        $script:C.Card    = [Drawing.Color]::FromArgb(22, 24, 29)
        $script:C.CardHov = [Drawing.Color]::FromArgb(27, 31, 36)
        $script:C.Text    = [Drawing.Color]::FromArgb(226, 232, 240)
        $script:C.Muted   = [Drawing.Color]::FromArgb(134, 150, 142)
        $script:C.Border  = [Drawing.Color]::FromArgb(45, 55, 60)
        $script:C.Danger  = [Drawing.Color]::FromArgb(225, 96, 96)
    }
    $script:C.Accent  = [Drawing.Color]::FromArgb([int]$a[0], [int]$a[1], [int]$a[2])
    $script:C.Accent2 = [Drawing.Color]::FromArgb(
        [Math]::Max(0, [int]$a[0] - 35),
        [Math]::Max(0, [int]$a[1] - 35),
        [Math]::Max(0, [int]$a[2] - 35))
    $script:C.Success = $script:C.Accent
}
Set-Palette

$script:CardDll = Join-Path $script:Root 'SuiteCard.dll'
if (-not (Test-Path -LiteralPath $script:CardDll)) { throw 'SuiteCard.dll was not found next to the launcher.' }
Add-Type -Path $script:CardDll

$script:IconPath = Join-Path $script:Root 'DGs Command Center.ico'
if (-not (Test-Path -LiteralPath $script:IconPath)) {
    $script:IconPath = Join-Path $script:SuiteRoot 'launcher.ico'
}
$script:LauncherIcon = $script:IconPath
if ($script:Settings.Icon -and (Test-Path -LiteralPath $script:Settings.Icon -PathType Leaf)) {
    $script:LauncherIcon = [string]$script:Settings.Icon
}
$a = $script:AppsRoot

$script:Apps = @(
    # ---------------- Files & Rename ----------------
    @{ Group = 'Files & Rename'; Name = 'Bulk File Renamer'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'Bulk File Renamer\RenameTool.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'Renametool'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'Bulk File Renamer\Renametool.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'DGS Renamer'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.Renamer.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'Rename Tool 2.1.1'; Kind = 'PS1'; Path = (Join-Path $a 'DGs Image Tools\RenameTool-2.1.1.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'Bulk Extension Renamer'; Kind = 'BAT'; Path = (Join-Path $a 'Bulk File Renamer\BULKEXTENSIONRENAMER.bat'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'File Toolkit'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'Visual Toolkit\Dgs.Filetoolkit.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'SmartSearch'; Kind = 'BAT'; Path = (Join-Path $a 'SmartSearch\SmartSearch.cmd'); Target = ''; Confirm = $false }
    @{ Group = 'Files & Rename'; Name = 'File Toolkit Setup'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'file-toolkit_setup_v1.0.23.exe'); Target = ''; Confirm = $true }

    # ---------------- Images & Icons ----------------
    @{ Group = 'Images & Icons'; Name = 'DGs Image Tools'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGs Image Tools\DGs image tools.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'DGs Explorer Toolkit'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGs Image Tools\DGs Explorer Toolkit.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Explorer Toolkit 3.1.2'; Kind = 'PS1'; Path = (Join-Path $a 'DGs Image Tools\ExplorerToolkit-3.1.2.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Explorer Toolkit v3'; Kind = 'PS1'; Path = (Join-Path $a 'Visual Toolkit\ExplorerToolkit_v3.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Hardened Toolkit 2.5.1'; Kind = 'PS1'; Path = (Join-Path $a 'DGs Image Tools\HardenedToolkit-2.5.1.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Image Tools (latest script)'; Kind = 'PS1'; Path = (Join-Path $a 'Visual Toolkit\DGs Image Tools-LATEST.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Image Tools V2'; Kind = 'PS1'; Path = (Join-Path $a 'Visual Toolkit\DGs Image Tools-V2.AMAZING.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Color Variant Generator'; Kind = 'PS1'; Path = (Join-Path $a 'Visual Toolkit\DG_Color_GeneratoV2.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Icon & Shortcut Changer'; Kind = 'PS1'; Path = (Join-Path $a 'Visual Toolkit\Icon-Color-Changer.v2.PS1'); Target = ''; Confirm = $false }
    @{ Group = 'Images & Icons'; Name = 'Fix Desktop Icons'; Kind = 'PS1'; Path = (Join-Path $a 'Visual Toolkit\FixIcons.ps1'); Target = ''; Confirm = $true }
    @{ Group = 'Images & Icons'; Name = 'Ficon (icon converter)'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'System Tools\Ficon-Setup.exe'); Target = ''; Confirm = $true }

    # ---------------- Explorer & System ----------------
    @{ Group = 'Explorer & System'; Name = 'Convert to Light Theme'; Kind = 'BAT'; Path = (Join-Path $a 'Convert to Light Theme\Convert-To-LightTheme.bat'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'Power Plan 1.1.1'; Kind = 'PS1'; Path = (Join-Path $a 'DGs Image Tools\insopti-PowerPlan-1.1.1.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'Windows 10 Debloat GUI'; Kind = 'PS1'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.WINDOWS10-DEBLOAT-GUI.ps1'); Target = ''; Confirm = $true }
    @{ Group = 'Explorer & System'; Name = 'Device Cleanup'; Kind = 'PS1'; Path = (Join-Path $a 'Universal Toolkit\DEVICECLEANUP.ps1'); Target = ''; Confirm = $true }
    @{ Group = 'Explorer & System'; Name = 'Component Deduplicator'; Kind = 'PS1'; Path = (Join-Path $a 'Universal Toolkit\COMPONENTDEDUPLICATOR.ps1'); Target = ''; Confirm = $true }
    @{ Group = 'Explorer & System'; Name = 'Executable Performance Manager'; Kind = 'PS1'; Path = (Join-Path $a 'Universal Toolkit\EXECUTABLEPERFORMANCEMANAGER.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'DGS File Search'; Kind = 'PS1'; Path = (Join-Path $a 'Universal Toolkit\DGSFILESEARCH.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'File List (script)'; Kind = 'PS1'; Path = (Join-Path $a 'Universal Toolkit\FILELIST.ps1'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'File List (batch)'; Kind = 'BAT'; Path = (Join-Path $a 'Universal Toolkit\FILELIST.bat'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'Hardened Toolkit'; Kind = 'PS1'; Path = (Join-Path $a 'Universal Toolkit\HARDENEDTOOLKIT.ps1'); Target = ''; Confirm = $true }
    @{ Group = 'Explorer & System'; Name = 'DGs Searcher'; Kind = 'BAT'; Path = (Join-Path $a 'Visual Toolkit\DGs Searcher.bat'); Target = ''; Confirm = $false }
    @{ Group = 'Explorer & System'; Name = 'Windows Cleaner'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'System Tools\WindowsCleaner-portable.exe'); Target = ''; Confirm = $true }

    # ---------------- DGS Suite ----------------
    @{ Group = 'DGS Suite'; Name = 'DGS App Launcher'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.AppLauncher.exe'); Target = ''; Confirm = $false }
    @{ Group = 'DGS Suite'; Name = 'DGS Debloat'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.Debloat.exe'); Target = ''; Confirm = $true }
    @{ Group = 'DGS Suite'; Name = 'DGS Light Theme'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.LightTheme.exe'); Target = ''; Confirm = $false }
    @{ Group = 'DGS Suite'; Name = 'DGS Setup Env'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.SetupEnv.exe'); Target = ''; Confirm = $false }
    @{ Group = 'DGS Suite'; Name = 'DGS WinUtil'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.WinUtil.exe'); Target = ''; Confirm = $true }
    @{ Group = 'DGS Suite'; Name = 'DGS Suite Installer'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\DGS.Suite.Installer.exe'); Target = ''; Confirm = $true }
    @{ Group = 'DGS Suite'; Name = 'Install Prerequisites'; Kind = 'PS1'; Path = (Join-Path $a 'DGS.Suite.Installer.exe-WITH-ICO-FIX\INSTALL-PREREQUISITES.ps1'); Target = ''; Confirm = $true }

    # ---------------- Uninstall ----------------
    @{ Group = 'Uninstall'; Name = 'DG Uninstaller'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DG Uninstaller\DG.Uninstaller.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Uninstall'; Name = 'DG Uninstaller Setup'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'DG Uninstaller\DG-Uninstaller-Setup-1.2.0.exe'); Target = ''; Confirm = $true }

    # ---------------- Tools & Installers ----------------
    @{ Group = 'Tools & Installers'; Name = 'Snipping Tool'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'System Tools\Snipping-Tool-Setup.exe'); Target = ''; Confirm = $true }
    @{ Group = 'Tools & Installers'; Name = 'Win-PS2EXE'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'System Tools\Win-PS2EXE.exe'); Target = ''; Confirm = $false }
    @{ Group = 'Tools & Installers'; Name = 'C# Viewer'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'System Tools\Csviewer-Setup.exe'); Target = ''; Confirm = $true }
    @{ Group = 'Tools & Installers'; Name = 'YouTube Downloader'; Kind = 'EXE_PATH'; Path = (Join-Path $a 'Visual Toolkit\DGs.Ytdownloader.exe'); Target = ''; Confirm = $false }

    # ---------------- Source ----------------
    @{ Group = 'Source'; Name = 'DGs v0.22 (open source folder)'; Kind = 'FOLDER'; Path = (Join-Path $a 'DGs v0.22 (source)'); Target = ''; Confirm = $false }

    # ---------------- System ----------------
    @{ Group = 'System'; Name = 'Windows PowerShell'; Kind = 'CMD'; Path = ''; Target = 'powershell.exe'; Confirm = $false }
    @{ Group = 'System'; Name = 'Command Prompt'; Kind = 'CMD'; Path = ''; Target = 'cmd.exe'; Confirm = $false }
    @{ Group = 'System'; Name = 'Task Manager'; Kind = 'CMD'; Path = ''; Target = 'taskmgr.exe'; Confirm = $false }
    @{ Group = 'System'; Name = 'Control Panel'; Kind = 'CMD'; Path = ''; Target = 'control.exe'; Confirm = $false }
    @{ Group = 'System'; Name = 'File Explorer'; Kind = 'CMD'; Path = ''; Target = 'explorer.exe'; Confirm = $false }
    @{ Group = 'System'; Name = 'Windows Settings'; Kind = 'URI'; Path = ''; Target = 'ms-settings:'; Confirm = $false }
    @{ Group = 'System'; Name = 'Snipping Tool (screen clip)'; Kind = 'URI'; Path = ''; Target = 'ms-screenclip:'; Confirm = $false }
)

# Anything dropped into Apps\ later appears automatically, so the launcher does
# not rot when a folder is copied in by hand.
function Get-DiscoveredApps {
    param([string]$Root, [hashtable]$Known)
    $result = New-Object System.Collections.Generic.List[object]
    if (-not (Test-Path -LiteralPath $Root)) { return $result }
    $skip = @('unins000.exe', 'unins001.exe', 'COMPILE.bat', 'UNINSTALL-BULKEXTENSIONRENAMER.bat')
    $files = @(Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in @('.exe', '.ps1', '.bat', '.cmd') } |
        Where-Object { $skip -notcontains $_.Name } |
        Where-Object { $_.Name -notlike 'unins*' } |
        Where-Object { $_.Name -notlike '*ninstall*' })
    foreach ($file in $files) {
        $key = $file.FullName.ToLowerInvariant()
        if ($Known.ContainsKey($key)) { continue }
        $relative = $file.FullName.Substring($Root.Length).TrimStart('\')
        $segments = $relative.Split('\')
        $group = if ($segments.Count -gt 1) { $segments[0] } else { 'Uncategorised' }
        $kind = switch ($file.Extension.ToLowerInvariant()) {
            '.ps1' { 'PS1' }
            '.bat' { 'BAT' }
            '.cmd' { 'BAT' }
            default { 'EXE_PATH' }
        }
        $name = [IO.Path]::GetFileNameWithoutExtension($file.Name)
        $result.Add(@{
            Group   = $group
            Name    = $name
            Kind    = $kind
            Path    = $file.FullName
            Target  = ''
            Confirm = ($name -match 'setup|install|debloat|harden|cleaner')
        })
    }
    return $result
}

$script:KnownPaths = @{}
foreach ($entry in $script:Apps) {
    if ($entry.Path) { $script:KnownPaths[$entry.Path.ToLowerInvariant()] = $true }
}
foreach ($extra in (Get-DiscoveredApps -Root $script:AppsRoot -Known $script:KnownPaths)) {
    $script:Apps += $extra
}
$script:Apps = @($script:Apps | Sort-Object -Property Group, Name)
function Start-AppProcess {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [string[]]$Arguments = @(),
        [string]$WorkingDirectory = '',
        [switch]$AsAdmin
    )
    $params = @{ FilePath = $FilePath; ErrorAction = 'Stop' }
    if ($Arguments -and $Arguments.Count -gt 0) { $params['ArgumentList'] = $Arguments }
    if ($WorkingDirectory) { $params['WorkingDirectory'] = $WorkingDirectory }
    if ($AsAdmin) { $params['Verb'] = 'RunAs' }
    Start-Process @params | Out-Null
}

function Launch-App {
    param($App, [switch]$AsAdmin)
    try {
        if (-not $App) { return }
        if ($App.Confirm -and -not $AsAdmin) {
            $answer = [Windows.Forms.MessageBox]::Show(
                "Run this installer or system-changing tool?`n`n$($App.Name)",
                'DGs Command Center', 'YesNo', 'Question')
            if ($answer -ne [Windows.Forms.DialogResult]::Yes) { return }
        }

        $ps = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        switch ($App.Kind) {
            'PS1' {
                if (-not (Test-Path -LiteralPath $App.Path -PathType Leaf)) { throw "Script not found: $($App.Path)" }
                Start-AppProcess -FilePath $ps `
                    -Arguments @('-NoProfile', '-STA', '-ExecutionPolicy', 'Bypass', '-File', ('"{0}"' -f $App.Path)) `
                    -WorkingDirectory (Split-Path -Parent $App.Path) -AsAdmin:$AsAdmin
            }
            'BAT' {
                if (-not (Test-Path -LiteralPath $App.Path -PathType Leaf)) { throw "Launcher not found: $($App.Path)" }
                Start-AppProcess -FilePath $env:ComSpec `
                    -Arguments @('/c', ('"{0}"' -f $App.Path)) `
                    -WorkingDirectory (Split-Path -Parent $App.Path) -AsAdmin:$AsAdmin
            }
            'EXE_PATH' {
                if (-not (Test-Path -LiteralPath $App.Path -PathType Leaf)) { throw "Application not found: $($App.Path)" }
                Start-AppProcess -FilePath $App.Path -WorkingDirectory (Split-Path -Parent $App.Path) -AsAdmin:$AsAdmin
            }
            'MSI' {
                if (-not (Test-Path -LiteralPath $App.Path -PathType Leaf)) { throw "Installer not found: $($App.Path)" }
                Start-AppProcess -FilePath 'msiexec.exe' -Arguments @('/i', ('"{0}"' -f $App.Path)) -AsAdmin:$AsAdmin
            }
            'FOLDER' {
                if (-not (Test-Path -LiteralPath $App.Path -PathType Container)) { throw "Folder not found: $($App.Path)" }
                Start-Process -FilePath 'explorer.exe' -ArgumentList ('"{0}"' -f $App.Path) -ErrorAction Stop | Out-Null
            }
            'URI' {
                Start-Process -FilePath $App.Target -ErrorAction Stop | Out-Null
            }
            'CMD' {
                $cmd = Get-Command $App.Target -ErrorAction Stop
                Start-AppProcess -FilePath $cmd.Source -AsAdmin:$AsAdmin
            }
            default { throw "Unknown launch type: $($App.Kind)" }
        }
        $status.Text = "Launched: $($App.Name)"
        $status.ForeColor = $script:C.Success
    } catch {
        $status.Text = "Launch failed: $($App.Name)"
        $status.ForeColor = $script:C.Danger
        [Windows.Forms.MessageBox]::Show(
            "Could not launch $($App.Name).`n`n$($_.Exception.Message)",
            'DGs Command Center', 'OK', 'Error') | Out-Null
    }
}

function New-AppShortcut {
    param($App)
    $desktop = [Environment]::GetFolderPath('Desktop')
    $lnk = Join-Path $desktop ("$($App.Name).lnk")
    $shell = New-Object -ComObject WScript.Shell
    $sc = $shell.CreateShortcut($lnk)
    switch ($App.Kind) {
        'PS1' {
            $sc.TargetPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
            $sc.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($App.Path)`""
            $sc.WorkingDirectory = Split-Path -Parent $App.Path
        }
        'BAT' {
            $sc.TargetPath = $env:ComSpec
            $sc.Arguments = "/c `"$($App.Path)`""
            $sc.WorkingDirectory = Split-Path -Parent $App.Path
        }
        'EXE_PATH' {
            $sc.TargetPath = $App.Path
            $sc.WorkingDirectory = Split-Path -Parent $App.Path
        }
        'ZIP' {
            $sc.TargetPath = 'explorer.exe'
            $sc.Arguments = "`"$($App.Path)`""
            $sc.WorkingDirectory = Split-Path -Parent $App.Path
        }
        'MSI' {
            $sc.TargetPath = 'msiexec.exe'
            $sc.Arguments = "/i `"$($App.Path)`""
            $sc.WorkingDirectory = Split-Path -Parent $App.Path
        }
        'FOLDER' {
            $sc.TargetPath = 'explorer.exe'
            $sc.Arguments = "`"$($App.Path)`""
        }
        'URI' {
            $sc.TargetPath = 'explorer.exe'
            $sc.Arguments = $App.Target
        }
        'CMD' {
            $cmd = Get-Command $App.Target -ErrorAction Stop
            $sc.TargetPath = $cmd.Source
            $sc.WorkingDirectory = Split-Path -Parent $cmd.Source
        }
    }
    if (Test-Path -LiteralPath $script:LauncherIcon) { $sc.IconLocation = "$($script:LauncherIcon),0" }
    $sc.Description = $App.Name
    $sc.Save()
    return $lnk
}

function Save-Settings {
    try {
        if (-not (Test-Path -LiteralPath $script:SettingsDir)) {
            New-Item -ItemType Directory -Path $script:SettingsDir -Force | Out-Null
        }
        $script:Settings | ConvertTo-Json | Set-Content -LiteralPath $script:SettingsPath -Encoding UTF8 -Force
        return $true
    } catch { return $false }
}

function Update-ShortcutIcon {
    $icon = [string]$script:LauncherIcon
    if (-not $icon -or -not (Test-Path -LiteralPath $icon -PathType Leaf)) { $icon = $script:IconPath }
    if (-not (Test-Path -LiteralPath $icon -PathType Leaf)) { return }
    $shell = New-Object -ComObject WScript.Shell
    foreach ($dir in @(
        [Environment]::GetFolderPath('Desktop'),
        (Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Programs'),
        (Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Programs\DGs Command Center')
    )) {
        $lnk = Join-Path $dir 'DGs Command Center.lnk'
        if (-not (Test-Path -LiteralPath $lnk -PathType Leaf)) { continue }
        try {
            $sc = $shell.CreateShortcut($lnk)
            $sc.IconLocation = "$icon,0"
            $sc.Save()
        } catch { }
    }
}

function Update-Theme {
    Set-Palette
    $form.BackColor = $script:C.Bg
    $rootLayout.BackColor = $script:C.Bg
    $header.BackColor = $script:C.Panel
    $title.ForeColor = $script:C.Text
    $subtitle.ForeColor = $script:C.Muted
    $search.BackColor = $script:C.Card
    $search.ForeColor = $script:C.Text
    $accent.BackColor = $script:C.Accent
    $toolbar.BackColor = $script:C.Panel
    $groupFilter.BackColor = $script:C.Card
    $groupFilter.ForeColor = $script:C.Text
    $countLabel.ForeColor = $script:C.Muted
    $btnOpen.BackColor = $script:C.Card
    $btnOpen.ForeColor = $script:C.Text
    $btnOpen.FlatAppearance.BorderColor = $script:C.Border
    $btnOpen.FlatAppearance.MouseOverBackColor = $script:C.CardHov
    $btnSettings.BackColor = $script:C.Card
    $btnSettings.ForeColor = $script:C.Accent
    $btnSettings.FlatAppearance.BorderColor = $script:C.Border
    $btnSettings.FlatAppearance.MouseOverBackColor = $script:C.CardHov
    $content.BackColor = $script:C.Bg
    $status.BackColor = $script:C.Panel
    $status.ForeColor = $script:C.Muted
    foreach ($card in $script:Cards) {
        $card.CardBack = $script:C.Card
        $card.CardBackHover = $script:C.CardHov
        $card.BorderColor = $script:C.Border
        $card.BorderHover = $script:C.Accent
        $card.TitleColor = $script:C.Text
        $card.SubColor = $script:C.Muted
        $card.Invalidate()
    }
    $cardMenu.BackColor = $script:C.Card
    $cardMenu.ForeColor = $script:C.Text
    $form.Invalidate($true)
}

function Apply-Filter {
    $term = $search.Text.Trim()
    $group = [string]$groupFilter.SelectedItem
    $visible = 0
    foreach ($card in $script:Cards) {
        $app = $card.Tag
        $okGroup = ($group -eq 'All groups' -or $app.Group -eq $group)
        $okTerm = [string]::IsNullOrWhiteSpace($term) -or
            $app.Name.IndexOf($term, [StringComparison]::OrdinalIgnoreCase) -ge 0 -or
            $app.Group.IndexOf($term, [StringComparison]::OrdinalIgnoreCase) -ge 0
        $card.Visible = ($okGroup -and $okTerm)
        if ($card.Visible) { $visible++ }
    }
    $countLabel.Text = "$visible of $($script:Apps.Count) apps"
    $content.PerformLayout()
}
$form = New-Object Windows.Forms.Form
$form.Text = 'DGs Command Center 2.3'
$form.ClientSize = New-Object Drawing.Size(1000, 760)
$form.MinimumSize = New-Object Drawing.Size(820, 600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = $script:C.Bg
$form.Font = New-Object Drawing.Font('Segoe UI', 9)
$form.AutoScaleMode = 'Dpi'
if (Test-Path -LiteralPath $script:LauncherIcon) {
    try { $form.Icon = New-Object System.Drawing.Icon($script:LauncherIcon) } catch { }
}

$rootLayout = New-Object Windows.Forms.TableLayoutPanel
$rootLayout.Dock = 'Fill'
$rootLayout.BackColor = $script:C.Bg
$rootLayout.ColumnCount = 1
$rootLayout.RowCount = 5
[void]$rootLayout.RowStyles.Add((New-Object Windows.Forms.RowStyle('Absolute', 118)))
[void]$rootLayout.RowStyles.Add((New-Object Windows.Forms.RowStyle('Absolute', 3)))
[void]$rootLayout.RowStyles.Add((New-Object Windows.Forms.RowStyle('Absolute', 46)))
[void]$rootLayout.RowStyles.Add((New-Object Windows.Forms.RowStyle('Percent', 100)))
[void]$rootLayout.RowStyles.Add((New-Object Windows.Forms.RowStyle('Absolute', 36)))
$form.Controls.Add($rootLayout)

$header = New-Object Windows.Forms.TableLayoutPanel
$header.Dock = 'Fill'
$header.BackColor = $script:C.Panel
$header.Padding = New-Object Windows.Forms.Padding(26, 16, 26, 14)
$header.ColumnCount = 2
$header.RowCount = 2
[void]$header.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle('Percent', 100)))
[void]$header.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle('Absolute', 260)))
[void]$header.RowStyles.Add((New-Object Windows.Forms.RowStyle('Absolute', 38)))
[void]$header.RowStyles.Add((New-Object Windows.Forms.RowStyle('Absolute', 34)))
$rootLayout.Controls.Add($header, 0, 0)

$title = New-Object Windows.Forms.Label
$title.Text = 'DGs COMMAND CENTER'
$title.Dock = 'Fill'
$title.AutoSize = $false
$title.TextAlign = 'MiddleLeft'
$title.ForeColor = $script:C.Text
$title.Font = New-Object Drawing.Font('Segoe UI Semibold', 21)
[void]$header.Controls.Add($title, 0, 0)

$btnSettings = New-Object Windows.Forms.Button
$btnSettings.Text = 'Theme & Settings'
$btnSettings.Dock = 'Fill'
$btnSettings.Margin = New-Object Windows.Forms.Padding(10, 8, 2, 8)
$btnSettings.FlatStyle = 'Flat'
$btnSettings.FlatAppearance.BorderSize = 1
$btnSettings.FlatAppearance.BorderColor = $script:C.Border
$btnSettings.FlatAppearance.MouseOverBackColor = $script:C.CardHov
$btnSettings.BackColor = $script:C.Card
$btnSettings.ForeColor = $script:C.Accent
$btnSettings.Font = New-Object Drawing.Font('Segoe UI Semibold', 9.5)
$btnSettings.Cursor = [Windows.Forms.Cursors]::Hand
$btnSettings.UseVisualStyleBackColor = $false
$btnSettings.Add_Click({ Show-SettingsDialog })
[void]$header.Controls.Add($btnSettings, 1, 0)

$subtitle = New-Object Windows.Forms.Label
$subtitle.Dock = 'Fill'
$subtitle.AutoSize = $false
$subtitle.TextAlign = 'MiddleLeft'
$subtitle.ForeColor = $script:C.Muted
$subtitle.Text = 'All your apps in one place - {0} entries' -f $script:Apps.Count
$subtitle.Font = New-Object Drawing.Font('Segoe UI', 9.5)
[void]$header.Controls.Add($subtitle, 0, 1)

$search = New-Object Windows.Forms.TextBox
$search.Dock = 'Fill'
$search.Margin = New-Object Windows.Forms.Padding(0, 3, 0, 3)
$search.BackColor = $script:C.Card
$search.ForeColor = $script:C.Text
$search.BorderStyle = 'FixedSingle'
$search.Font = New-Object Drawing.Font('Segoe UI', 10)
$search.AccessibleName = 'Search applications'
[void]$header.Controls.Add($search, 1, 1)

$accent = New-Object Windows.Forms.Panel
$accent.Dock = 'Fill'
$accent.BackColor = $script:C.Accent
$rootLayout.Controls.Add($accent, 0, 1)

$toolbar = New-Object Windows.Forms.TableLayoutPanel
$toolbar.Dock = 'Fill'
$toolbar.BackColor = $script:C.Panel
$toolbar.Padding = New-Object Windows.Forms.Padding(22, 6, 22, 6)
$toolbar.ColumnCount = 3
$toolbar.RowCount = 1
[void]$toolbar.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle('Absolute', 250)))
[void]$toolbar.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle('Percent', 100)))
[void]$toolbar.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle('Absolute', 150)))
$rootLayout.Controls.Add($toolbar, 0, 2)

$groupFilter = New-Object Windows.Forms.ComboBox
$groupFilter.Dock = 'Fill'
$groupFilter.DropDownStyle = 'DropDownList'
$groupFilter.FlatStyle = 'Flat'
$groupFilter.BackColor = $script:C.Card
$groupFilter.ForeColor = $script:C.Text
$groupFilter.Font = New-Object Drawing.Font('Segoe UI', 9.5)
[void]$groupFilter.Items.Add('All groups')
foreach ($g in ($script:Apps | ForEach-Object { $_.Group } | Select-Object -Unique | Sort-Object)) {
    [void]$groupFilter.Items.Add($g)
}
$groupFilter.SelectedIndex = 0
[void]$toolbar.Controls.Add($groupFilter, 0, 0)

$countLabel = New-Object Windows.Forms.Label
$countLabel.Dock = 'Fill'
$countLabel.TextAlign = 'MiddleLeft'
$countLabel.ForeColor = $script:C.Muted
$countLabel.Padding = New-Object Windows.Forms.Padding(14, 0, 0, 0)
$countLabel.Text = "$($script:Apps.Count) entries"
[void]$toolbar.Controls.Add($countLabel, 1, 0)

$btnOpen = New-Object Windows.Forms.Button
$btnOpen.Text = 'Open apps folder'
$btnOpen.Dock = 'Fill'
$btnOpen.FlatStyle = 'Flat'
$btnOpen.FlatAppearance.BorderSize = 1
$btnOpen.FlatAppearance.BorderColor = $script:C.Border
$btnOpen.FlatAppearance.MouseOverBackColor = $script:C.CardHov
$btnOpen.BackColor = $script:C.Card
$btnOpen.ForeColor = $script:C.Text
$btnOpen.Font = New-Object Drawing.Font('Segoe UI Semibold', 9)
$btnOpen.Cursor = [Windows.Forms.Cursors]::Hand
$btnOpen.UseVisualStyleBackColor = $false
$btnOpen.Add_Click({
    try { Start-Process -FilePath 'explorer.exe' -ArgumentList "`"$($script:SuiteRoot)`"" -ErrorAction Stop | Out-Null } catch { }
})
[void]$toolbar.Controls.Add($btnOpen, 2, 0)

$content = New-Object Windows.Forms.FlowLayoutPanel
$content.Dock = 'Fill'
$content.BackColor = $script:C.Bg
$content.Padding = New-Object Windows.Forms.Padding(22, 18, 22, 18)
$content.FlowDirection = 'LeftToRight'
$content.WrapContents = $true
$content.AutoScroll = $true
$rootLayout.Controls.Add($content, 0, 3)

$status = New-Object Windows.Forms.Label
$status.Dock = 'Fill'
$status.BackColor = $script:C.Panel
$status.ForeColor = $script:C.Muted
$status.Text = 'Ready - choose an app'
$status.TextAlign = 'MiddleLeft'
$status.Padding = New-Object Windows.Forms.Padding(16, 0, 0, 0)
$status.AutoSize = $false
$rootLayout.Controls.Add($status, 0, 4)

$brandColors = @(
    [Drawing.Color]::FromArgb(0, 230, 118),
    [Drawing.Color]::FromArgb(14, 165, 233),
    [Drawing.Color]::FromArgb(99, 102, 241),
    [Drawing.Color]::FromArgb(249, 115, 22),
    [Drawing.Color]::FromArgb(239, 68, 68),
    [Drawing.Color]::FromArgb(245, 158, 11),
    [Drawing.Color]::FromArgb(20, 184, 166),
    [Drawing.Color]::FromArgb(244, 63, 94)
)

$script:Cards = @()
$i = 0
foreach ($app in $script:Apps) {
    $card = New-Object SuiteCard
    $card.Size = New-Object Drawing.Size(300, 66)
    $card.Margin = New-Object Windows.Forms.Padding(6)
    $card.AppName = $app.Name
    $card.AppGroup = $app.Group
    $n = $app.Name -replace '^\s*DGs\s*', ''
    $card.TileLetter = if ($n) { $n.Substring(0, 1).ToUpper() } else { 'D' }
    $card.BrandColor = $brandColors[$i % $brandColors.Count]
    $card.CardBack = $script:C.Card
    $card.CardBackHover = $script:C.CardHov
    $card.BorderColor = $script:C.Border
    $card.BorderHover = $script:C.Accent
    $card.TitleColor = $script:C.Text
    $card.SubColor = $script:C.Muted
    $card.Tag = $app
    $card.Add_Click({ Launch-App $this.Tag })
    [void]$content.Controls.Add($card)
    $script:Cards += $card
    $i++
}

$cardMenu = New-Object Windows.Forms.ContextMenuStrip
$miLaunch = New-Object Windows.Forms.ToolStripMenuItem('Launch')
$miLaunch.Add_Click({
    $card = $cardMenu.SourceControl
    if ($card) { Launch-App $card.Tag }
})
$miAdmin = New-Object Windows.Forms.ToolStripMenuItem('Run as administrator')
$miAdmin.Add_Click({
    $card = $cardMenu.SourceControl
    if ($card) { Launch-App $card.Tag -AsAdmin }
})
$miFolder = New-Object Windows.Forms.ToolStripMenuItem('Open file location')
$miFolder.Add_Click({
    $card = $cardMenu.SourceControl
    if (-not $card) { return }
    $app = $card.Tag
    try {
        if ($app.Path -and (Test-Path -LiteralPath $app.Path)) {
            Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"{0}"' -f $app.Path) -ErrorAction Stop | Out-Null
        } elseif ($app.Kind -eq 'CMD') {
            $cmd = Get-Command $app.Target -ErrorAction SilentlyContinue
            if ($cmd) { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"{0}"' -f $cmd.Source) -ErrorAction Stop | Out-Null }
        }
    } catch { }
})
$miShortcut = New-Object Windows.Forms.ToolStripMenuItem('Create desktop shortcut')
$miShortcut.Add_Click({
    $card = $cardMenu.SourceControl
    if (-not $card) { return }
    try {
        $lnk = New-AppShortcut $card.Tag
        $status.Text = "Shortcut created: $lnk"
        $status.ForeColor = $script:C.Success
    } catch {
        $status.Text = 'Could not create shortcut'
        $status.ForeColor = $script:C.Danger
        [Windows.Forms.MessageBox]::Show($_.Exception.Message, 'DGs Command Center', 'OK', 'Error') | Out-Null
    }
})
$miCopy = New-Object Windows.Forms.ToolStripMenuItem('Copy path')
$miCopy.Add_Click({
    $card = $cardMenu.SourceControl
    if (-not $card) { return }
    $app = $card.Tag
    $text = if ($app.Path) { $app.Path } else { $app.Target }
    try { [Windows.Forms.Clipboard]::SetText([string]$text) } catch { }
    $status.Text = "Copied: $text"
    $status.ForeColor = $script:C.Muted
})
[void]$cardMenu.Items.Add($miLaunch)
[void]$cardMenu.Items.Add($miAdmin)
[void]$cardMenu.Items.Add($miFolder)
[void]$cardMenu.Items.Add($miShortcut)
[void]$cardMenu.Items.Add($miCopy)
$cardMenu.BackColor = $script:C.Card
$cardMenu.ForeColor = $script:C.Text
foreach ($card in $script:Cards) { $card.ContextMenuStrip = $cardMenu }

$search.Add_TextChanged({ Apply-Filter })
$groupFilter.Add_SelectedIndexChanged({ Apply-Filter })

try {
    $buffProp = [System.Windows.Forms.Control].GetProperty('DoubleBuffered',
        [System.Reflection.BindingFlags]'Instance,NonPublic')
    $buffProp.SetValue($form, $true, $null)
    $buffProp.SetValue($content, $true, $null)
} catch { }

$form.Add_SizeChanged({
    $content.SuspendLayout()
    try { $form.PerformLayout(); $content.PerformLayout() }
    finally { $content.ResumeLayout($true) }
    $form.Invalidate($true)
})
function Show-SettingsDialog {
    $dlg = New-Object Windows.Forms.Form
    $dlg.Text = 'DGs Command Center - Theme & Settings'
    $dlg.ClientSize = New-Object Drawing.Size(560, 420)
    $dlg.FormBorderStyle = 'FixedDialog'
    $dlg.MaximizeBox = $false
    $dlg.MinimizeBox = $false
    $dlg.StartPosition = 'CenterParent'
    $dlg.BackColor = $script:C.Bg
    $dlg.Font = New-Object Drawing.Font('Segoe UI', 9.5)

    $lblTheme = New-Object Windows.Forms.Label
    $lblTheme.Text = 'Theme'
    $lblTheme.SetBounds(24, 20, 200, 22)
    $lblTheme.ForeColor = $script:C.Accent
    $lblTheme.Font = New-Object Drawing.Font('Segoe UI Semibold', 10)
    $dlg.Controls.Add($lblTheme)

    $radDark = New-Object Windows.Forms.RadioButton
    $radDark.Text = 'Dark'
    $radDark.SetBounds(40, 50, 220, 24)
    $radDark.ForeColor = $script:C.Text
    $radDark.Checked = ($script:Settings.Theme -eq 'Dark')
    $dlg.Controls.Add($radDark)

    $radLight = New-Object Windows.Forms.RadioButton
    $radLight.Text = 'Light'
    $radLight.SetBounds(40, 78, 220, 24)
    $radLight.ForeColor = $script:C.Text
    $radLight.Checked = ($script:Settings.Theme -eq 'Light')
    $dlg.Controls.Add($radLight)

    $lblAccent = New-Object Windows.Forms.Label
    $lblAccent.Text = 'Accent color'
    $lblAccent.SetBounds(24, 116, 200, 22)
    $lblAccent.ForeColor = $script:C.Accent
    $lblAccent.Font = New-Object Drawing.Font('Segoe UI Semibold', 10)
    $dlg.Controls.Add($lblAccent)

    $cmbAccent = New-Object Windows.Forms.ComboBox
    $cmbAccent.SetBounds(40, 144, 220, 26)
    $cmbAccent.DropDownStyle = 'DropDownList'
    $cmbAccent.FlatStyle = 'Flat'
    $cmbAccent.BackColor = $script:C.Card
    $cmbAccent.ForeColor = $script:C.Text
    foreach ($key in ($script:AccentMap.Keys | Sort-Object)) { [void]$cmbAccent.Items.Add($key) }
    $cmbAccent.SelectedItem = $script:Settings.Accent
    $dlg.Controls.Add($cmbAccent)

    $lblIcon = New-Object Windows.Forms.Label
    $lblIcon.Text = 'Launcher icon'
    $lblIcon.SetBounds(24, 188, 300, 22)
    $lblIcon.ForeColor = $script:C.Accent
    $lblIcon.Font = New-Object Drawing.Font('Segoe UI Semibold', 10)
    $dlg.Controls.Add($lblIcon)

    $txtIcon = New-Object Windows.Forms.TextBox
    $txtIcon.Text = [string]$script:Settings.Icon
    $txtIcon.SetBounds(40, 214, 360, 24)
    $txtIcon.ReadOnly = $true
    $txtIcon.BackColor = $script:C.Card
    $txtIcon.ForeColor = $script:C.Text
    $txtIcon.BorderStyle = 'FixedSingle'
    $dlg.Controls.Add($txtIcon)

    $btnIcon = New-Object Windows.Forms.Button
    $btnIcon.Text = 'Browse...'
    $btnIcon.SetBounds(410, 212, 110, 28)
    $btnIcon.FlatStyle = 'Flat'
    $btnIcon.BackColor = $script:C.Card
    $btnIcon.ForeColor = $script:C.Text
    $btnIcon.FlatAppearance.BorderColor = $script:C.Border
    $btnIcon.Cursor = [Windows.Forms.Cursors]::Hand
    $btnIcon.Add_Click({
        $pick = New-Object Windows.Forms.OpenFileDialog
        $pick.Title = 'Choose a launcher icon'
        $pick.Filter = 'Icon files (*.ico)|*.ico'
        $pick.InitialDirectory = $script:Root
        if ($pick.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) { $txtIcon.Text = $pick.FileName }
        $pick.Dispose()
    })
    $dlg.Controls.Add($btnIcon)

    $lblRoot = New-Object Windows.Forms.Label
    $lblRoot.Text = 'Launcher files'
    $lblRoot.SetBounds(24, 254, 300, 22)
    $lblRoot.ForeColor = $script:C.Accent
    $lblRoot.Font = New-Object Drawing.Font('Segoe UI Semibold', 10)
    $dlg.Controls.Add($lblRoot)

    $txtRoot = New-Object Windows.Forms.TextBox
    $txtRoot.Text = $script:Root
    $txtRoot.SetBounds(40, 280, 360, 24)
    $txtRoot.ReadOnly = $true
    $txtRoot.BackColor = $script:C.Card
    $txtRoot.ForeColor = $script:C.Text
    $txtRoot.BorderStyle = 'FixedSingle'
    $dlg.Controls.Add($txtRoot)

    $btnRoot = New-Object Windows.Forms.Button
    $btnRoot.Text = 'Open folder'
    $btnRoot.SetBounds(410, 278, 110, 28)
    $btnRoot.FlatStyle = 'Flat'
    $btnRoot.BackColor = $script:C.Card
    $btnRoot.ForeColor = $script:C.Text
    $btnRoot.FlatAppearance.BorderColor = $script:C.Border
    $btnRoot.Cursor = [Windows.Forms.Cursors]::Hand
    $btnRoot.Add_Click({
        try { Start-Process -FilePath 'explorer.exe' -ArgumentList "`"$($script:Root)`"" -ErrorAction Stop | Out-Null } catch { }
    })
    $dlg.Controls.Add($btnRoot)

    $lblVersion = New-Object Windows.Forms.Label
    $lblVersion.Text = 'DGs Command Center v2.3'
    $lblVersion.SetBounds(24, 318, 300, 22)
    $lblVersion.ForeColor = $script:C.Muted
    $dlg.Controls.Add($lblVersion)

    $btnSave = New-Object Windows.Forms.Button
    $btnSave.Text = 'Save'
    $btnSave.SetBounds(210, 356, 120, 36)
    $btnSave.FlatStyle = 'Flat'
    $btnSave.BackColor = $script:C.Accent
    $btnSave.ForeColor = [Drawing.Color]::White
    $btnSave.FlatAppearance.BorderSize = 0
    $btnSave.Cursor = [Windows.Forms.Cursors]::Hand
    $btnSave.Add_Click({
        $script:Settings.Theme = if ($radLight.Checked) { 'Light' } else { 'Dark' }
        $script:Settings.Accent = [string]$cmbAccent.SelectedItem
        $icon = $txtIcon.Text.Trim()
        if ($icon -and (Test-Path -LiteralPath $icon -PathType Leaf)) {
            try {
                if (-not (Test-Path -LiteralPath $script:SettingsDir)) {
                    New-Item -ItemType Directory -Path $script:SettingsDir -Force | Out-Null
                }
                $destIcon = Join-Path $script:SettingsDir 'launcher.ico'
                if ([IO.Path]::GetFullPath($icon) -ne [IO.Path]::GetFullPath($destIcon)) {
                    Copy-Item -LiteralPath $icon -Destination $destIcon -Force
                }
                $script:Settings.Icon = $destIcon
            } catch {
                $script:Settings.Icon = $icon
            }
        } else {
            $script:Settings.Icon = ''
        }
        [void](Save-Settings)
        $script:LauncherIcon = if ($script:Settings.Icon) { $script:Settings.Icon } else { $script:IconPath }
        if (Test-Path -LiteralPath $script:LauncherIcon -PathType Leaf) {
            try { $form.Icon = New-Object System.Drawing.Icon($script:LauncherIcon) } catch { }
        }
        Update-Theme
        Update-ShortcutIcon
        $dlg.DialogResult = 'OK'
        $dlg.Close()
    })
    $dlg.Controls.Add($btnSave)

    $btnCancel = New-Object Windows.Forms.Button
    $btnCancel.Text = 'Cancel'
    $btnCancel.SetBounds(340, 356, 120, 36)
    $btnCancel.FlatStyle = 'Flat'
    $btnCancel.BackColor = $script:C.Card
    $btnCancel.ForeColor = $script:C.Text
    $btnCancel.FlatAppearance.BorderColor = $script:C.Border
    $btnCancel.Cursor = [Windows.Forms.Cursors]::Hand
    $btnCancel.Add_Click({ $dlg.DialogResult = 'Cancel'; $dlg.Close() })
    $dlg.Controls.Add($btnCancel)

    [void]$dlg.ShowDialog($form)
    $dlg.Dispose()
}

Apply-Filter
Update-Theme
if ($script:Settings.Icon) {
    try { Update-ShortcutIcon } catch { }
}
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
$form.Dispose()



# Brave Nightly Portable

A Portapps-style launcher written in Go. It downloads the latest official Brave Nightly zip build from GitHub,
extracts it into `app\`, keeps your profile in `data\`, and cleans the registry
after exit so the host PC stays clean.

## Build (Windows, needs Go 1.22+)

    build.bat          (or: powershell -ExecutionPolicy Bypass -File build.ps1)

The build embeds `icon.ico` and `app.manifest` using rsrc (downloaded automatically by `go run`).
GitHub Actions does the same, see .github/workflows/build.yml.

Outputs in `dist\`:
- `brave-nightly-portable.exe`        release build, no console window
- `brave-nightly-portable-debug.exe`  console build, shows live logs

## What you get

- The exe carries the real Brave Nightly icon (Brave Nightly icon from the official brave-core repo) and a manifest
  (visual styles, sharp text on high-DPI screens, no UAC prompt).
- First run opens a small setup window: welcome page, then download/extract progress with
  speed and time left, then a finish page with a "Launch Brave Nightly" checkbox. Cancel works at any point.
- If `check_updates: true` and a newer Nightly exists, the same window shows the update and then launches Brave.

## Use

1. Put `brave-nightly-portable.exe` in an empty folder on your USB drive.
2. Double-click it. First run downloads and installs Brave Nightly.
3. Next runs just launch Brave with your portable profile.

Commands (run from a terminal, ideally with the debug exe):

    brave-nightly-portable-debug.exe install   force (re)install latest Nightly
    brave-nightly-portable-debug.exe update    update only if a newer Nightly exists
    brave-nightly-portable-debug.exe version   show launcher + Brave versions

## Folder layout created next to the exe

    app\      extracted Brave (replaced on update)
    data\     profile\ and cache\  (your stuff, never touched by updates)
    log\      brave-nightly-portable.log
    reg\      exported registry keys
    tmp\      installer download (deleted after install)
    brave-nightly-portable.yml   config (auto-created on first run)
    installed.txt             installed release tag

## Config (brave-nightly-portable.yml)

- marker_pattern / asset_pattern: a release counts as Nightly if it has a marker asset;
  asset_pattern picks the portable zip. If install fails, the error lists real names.
- check_updates: auto-update at launch.
- clean_registry / registry_keys: keys exported to reg\ and deleted after exit.
  Keys already present on the host are never touched.
- args: extra Brave flags. `--disable-encryption-win` (commented out) may make
  passwords portable across PCs; less secure, test before relying on it.

## Notes

- Close Brave before running `update`.
- Use exFAT or NTFS on the USB drive, not FAT32.
- Eject safely; pulling the drive while Brave runs can corrupt the profile.

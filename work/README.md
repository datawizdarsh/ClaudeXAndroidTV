# Skyworth SWTV-20NA cleanup (1 Nov 2026)

TV: Skyworth SWTV-20NA (device SW4H, MediaTek), Android TV 11, build RTM5.220609.106.
Everything was **disabled, not uninstalled**, so every change can be undone.

## What changed

| Batch | Packages |
|---|---|
| 1 Tracking | Skyworth ACR (on-screen content recognition), Google feedback, partner setup, Play auto-installs, Dynamic System Updates |
| 2 Ads | Skyworth "Daily Play" recommendations, Shop-tab customizer, Google recommendation rows, "Featured" partner row, e-POP demo player |
| 3 Leftovers | First-run leftovers, print spooler, e-manual, QJY browser, HTML viewer, backup helpers, Android test shims, calendar sync |
| 4 Your choices | Play Movies, Play Games, Works with Alexa |
| Launcher | Stock `com.google.android.tvlauncher` disabled; new Home is `com.gathin.tvhome` |
| DNS | Private DNS = `dns.adguard-dns.com` (blocks most ads/trackers, **not YouTube ads**) |

Kept on purpose: Live TV and inputs, Input key handler, remote/Bluetooth, keyboards, Play Store/Services,
Netflix, Prime Video, YouTube, YouTube Music, Assistant, Chromecast, CastPlay, USB media player,
Swaiot, Backdrop screensaver, all `com.mediatek.*`, Skyworth firewall and factory packages.

The lists are in `batch1-telemetry.txt` ... `batch4-choices.txt`. The backup taken before any change is
in `../backup/`, and screenshots of every step are in `../shots/`.

## Before running anything here

Turn debugging back on: TV **Settings → Device Preferences → Developer options → USB debugging**.
Then accept the "Allow USB debugging?" prompt on the TV. Commands run from the repo root in Git Bash.
Turn debugging off again when you're done.

## Undo everything

    TV_HOST=<tv ip> bash work/restore-all.sh

## Re-enable a single app

    TV_HOST=<tv ip> tools/venv/Scripts/python tools/tv.py "pm enable --user 0 <package>"

For example, `com.smartdevice.tvworkwithalexa` for Alexa or `com.google.android.videos` for Play Movies.

## Undo only the ad-blocking DNS

    TV_HOST=<tv ip> tools/venv/Scripts/python tools/tv.py "settings put global private_dns_mode opportunistic"

Or on the TV: Settings → Network & Internet → Private DNS → Automatic.

## Change the dock order or apps

1. Edit `launcher/app/src/main/res/values/config.xml`:
   - `dock_apps`: the package names, in order (now Netflix, Prime Video, YouTube, YouTube Music, JioHotstar).
   - `columns`: dock width and grid columns (now 5).
2. Rebuild and install: `TV_HOST=<tv ip> bash work/build-and-install.sh`

Package names: `TV_HOST=<tv ip> tools/venv/Scripts/python tools/tv.py "pm list packages"`.

## Change the wallpaper

Without rebuilding, push a theme: a folder with a `config.json` and a `wallpaper.jpg` (1920x1080).

    TV_HOST=<tv ip> bash tools/theme.sh themes/aurora          # a ready-made theme
    TV_HOST=<tv ip> bash tools/theme.sh themes/my-theme        # your own folder
    TV_HOST=<tv ip> bash tools/theme.sh --reset                # back to the built-in look

To keep your dock in a theme, add `"dock_apps": [...]` and `"columns": 5` to its `config.json`
(all keys: `themes/README.md`).

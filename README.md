# AppLocker

macOS menu bar app that locks specific applications behind Touch ID. Pick which apps you want protected, and whenever one of them launches, it prompts for authentication before letting it run. If you cancel or fail, the app gets terminated.

## How it works

- Lives in the menu bar (lock icon)
- Watches for app launches using `NSWorkspace` notifications
- When a protected app starts, triggers Touch ID (falls back to password)
- If auth succeeds, the app runs normally and gets whitelisted for that session
- If auth fails, the app is killed
- Protected apps are saved in UserDefaults so they persist across restarts

## Adding apps

Two ways to add an app to the protected list:
1. Click "Add from Running Apps" and pick from a list of currently running apps (shows icons)
2. Copy a bundle ID to your clipboard and click "Add Bundle ID from Clipboard"

There's also a "Lock every activation" toggle that re-prompts auth every time the app is launched, even within the same session.

## Project structure

```
AppLocker/
├── AppLockerApp.swift          # Entry point, menu bar setup
├── AppLockController.swift     # Monitors app launches/terminations
├── TouchIDAuthenticator.swift  # Touch ID / password auth wrapper
├── ProtectedAppsStore.swift    # Persists protected bundle IDs
├── MenuBarView.swift           # Main menu bar UI
├── RunningAppsPicker.swift     # App selection sheet
└── Utilities.swift             # NSRunningApplication icon extension
```

## Requirements

- macOS 13+ (Ventura)
- Xcode 14+
- Mac with Touch ID (falls back to password on Macs without it)

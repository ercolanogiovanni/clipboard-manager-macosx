# Clipboard Manager for macOS

[🇮🇹 Versione Italiana](README.it.md)

A lightweight and modern clipboard manager for macOS that lives in your menu bar.

## Features

- 📋 **Complete History**: Stores up to 100 copied items
- 🔍 **Fast Search**: Quickly find what you've copied in the past
- 💾 **Persistence**: History is automatically saved
- 🎨 **Modern Interface**: Clean UI built with SwiftUI
- ⚡ **Lightweight**: Lives in the menu bar without taking up Dock space
- 📌 **Pin Items**: Pin important items to keep them always at the top
- 🗑️ **Easy Management**: Delete individual items or clear the entire history
- ⌨️ **Global Hotkey**: Open history with **Cmd+Shift+V** from any app
- 🚀 **Auto Launch**: Option to launch the app at login
- 🌍 **Multilingual**: Full support for Italian and English

## Requirements

- macOS 13.0 (Ventura) or later
- Swift 6.0

## Installation

### Method 1: Build and Install App Bundle

Use the included build script to create a complete macOS app:

```bash
./build_app.sh
```

This will create `ClipboardManager.app` in the current directory. To install it:

```bash
cp -R ClipboardManager.app /Applications/
```

Then launch the app from Spotlight or Finder.

### Method 2: Build and Run Directly

For development or quick testing:

```bash
swift build -c release
.build/release/ClipboardManager
```

Or run directly:

```bash
swift run
```

## Usage

1. Launch the application - you'll see an icon in the menu bar
2. **Press Cmd+Shift+V** from any app to open the history (or click the icon)
3. On first launch, grant Accessibility permissions when prompted (required for global hotkey)
4. Click on an item to copy it to the clipboard
5. Use the search bar to filter items
6. Hover over an item to see options (pin, copy, delete)

### Features

- **Global Hotkey**: Press **Cmd+Shift+V** from any application to open the menu
- **Automatic History**: Every copied text is automatically saved
- **Pin Items**: Pin important items - they won't be deleted when clearing history
- **Quick Copy**: Click on an item to copy it and close the popover
- **Search**: Filter items by typing in the search bar
- **Delete**: Hover and click the trash icon to delete an item
- **Clear All**: Click the trash icon in the header to clear history (preserves pinned items)
- **Launch at Login**: Toggle the switch in the header to automatically launch the app at login
- **Quit**: Click the X icon in the header to close the application

## Project Structure

```
ClipboardManager/
├── Sources/
│   └── ClipboardManager/
│       ├── ClipboardManager.swift      # Entry point
│       ├── ClipboardItem.swift         # Data model
│       ├── ClipboardMonitor.swift      # Clipboard monitoring
│       ├── StatusBarController.swift   # Menu bar controller
│       ├── HotKeyManager.swift         # Global hotkey handler
│       ├── LaunchAtLoginManager.swift  # Launch at login handler
│       ├── ContentView.swift           # SwiftUI interface
│       ├── Localizable.swift           # Localization helper
│       └── Resources/                  # Localization files
│           ├── it.lproj/
│           └── en.lproj/
├── Package.swift
├── build_app.sh                        # Build script
├── AppIcon.icns                        # App icon
└── README.md
```

## Technical Notes

- Uses `NSPasteboard` to monitor clipboard changes
- History is persisted in `UserDefaults`
- Interface built with SwiftUI and AppKit
- App uses `.accessory` activation policy to avoid appearing in the Dock
- Clipboard monitoring runs every 0.5 seconds
- Global hotkey implemented with Carbon Event Manager
- Launch at login implemented with `SMAppService` (macOS 13+)
- Automatic localization support for Italian/English based on system settings
- **Requires Accessibility permissions** for global hotkey (system will prompt automatically)

## License

MIT

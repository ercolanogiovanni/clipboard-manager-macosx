#!/bin/bash

# Build configuration
APP_NAME="ClipboardManager"
BUILD_DIR=".build/release"
APP_BUNDLE="$APP_NAME.app"
BUNDLE_CONTENTS="$APP_BUNDLE/Contents"
BUNDLE_MACOS="$BUNDLE_CONTENTS/MacOS"
BUNDLE_RESOURCES="$BUNDLE_CONTENTS/Resources"

# Clean previous build
echo "🧹 Cleaning previous builds..."
rm -rf "$APP_BUNDLE"

# Build the executable
echo "🔨 Building executable..."
swift build -c release

if [ ! -f "$BUILD_DIR/$APP_NAME" ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Create bundle structure
echo "📦 Creating app bundle..."
mkdir -p "$BUNDLE_MACOS"
mkdir -p "$BUNDLE_RESOURCES"

# Copy executable
cp "$BUILD_DIR/$APP_NAME" "$BUNDLE_MACOS/"

# Copy localization resources
echo "🌍 Copying localization resources..."
if [ -d "Sources/ClipboardManager/Resources" ]; then
    cp -R Sources/ClipboardManager/Resources/* "$BUNDLE_RESOURCES/"
fi

# Copy app icon
if [ -f "AppIcon.icns" ]; then
    echo "🎨 Copying app icon..."
    cp AppIcon.icns "$BUNDLE_RESOURCES/"
fi

# Create Info.plist
echo "📝 Creating Info.plist..."
cat > "$BUNDLE_CONTENTS/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.clipboardmanager.app</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>it</string>
    </array>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
EOF

# Create PkgInfo
echo "APPL????" > "$BUNDLE_CONTENTS/PkgInfo"

# Set permissions
chmod +x "$BUNDLE_MACOS/$APP_NAME"

echo "✅ App bundle created: $APP_BUNDLE"
echo ""
echo "To install, run:"
echo "  cp -R $APP_BUNDLE /Applications/"
echo ""
echo "Or to test locally:"
echo "  open $APP_BUNDLE"

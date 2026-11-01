#!/usr/bin/env bash
# Builds the macOS release app and installs it to /Applications.
# Usage: tool/build_macos.sh   (from anywhere)
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo"

flutter pub get
flutter build macos --release

app="build/macos/Build/Products/Release/XPENC.app"
rm -rf "/Applications/XPENC.app"
cp -R "$app" /Applications/
echo "Installed /Applications/XPENC.app"

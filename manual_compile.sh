#!/bin/bash

# Script de compilation manuelle de ZenLink avec tous les fichiers
cd "/Users/bubu/Documents/GitHub/zenlink"

echo "🚀 Compilation manuelle de ZenLink avec tous les managers..."

swiftc -o ZenLink \
    -target arm64-apple-macos13.0 \
    -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.5.sdk \
    ZenLink/ZenLinkApp.swift \
    ZenLink/ContentView.swift \
    ZenLink/MenuBarView.swift \
    ZenLink/SettingsView.swift \
    ZenLink/Services/AppSettings.swift \
    ZenLink/Services/ThemeManager.swift \
    ZenLink/Services/LocalizationManager.swift \
    ZenLink/Services/ClipboardManager.swift \
    ZenLink/Services/URLCleaner.swift \
    -framework SwiftUI \
    -framework Foundation \
    -framework AppKit

if [ $? -eq 0 ]; then
    echo "✅ Compilation réussie avec tous les managers !"
    echo "📁 Fichiers inclus :"
    echo "  - AppSettings.swift"
    echo "  - ThemeManager.swift"  
    echo "  - LocalizationManager.swift"
    echo "  - ClipboardManager.swift"
    echo "  - URLCleaner.swift"
    echo "  - ZenLinkApp.swift"
    echo "  - MenuBarView.swift"
    echo "  - SettingsView.swift"
    echo "  - ContentView.swift"
else
    echo "❌ Erreurs de compilation détectées"
fi

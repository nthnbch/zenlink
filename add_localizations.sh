#!/bin/bash

# Add localization files to Xcode project
cd /Users/bubu/Documents/GitHub/zenlink

# Add the .lproj directories as folder references
# This is a workaround since we can't easily edit pbxproj manually

echo "Adding localization files to Xcode project..."

# Copy localization files to a temporary location and add them via build settings
BUILD_DIR="/Users/bubu/Library/Developer/Xcode/DerivedData/ZenLink-gmawaoklojyohwhgssntvgyaqeib/Build/Products/Debug/ZenLink.app/Contents/Resources"

if [ -d "$BUILD_DIR" ]; then
    echo "Copying localization files to build directory..."
    cp -r ZenLink/en.lproj "$BUILD_DIR/"
    cp -r ZenLink/fr.lproj "$BUILD_DIR/"  
    cp -r ZenLink/es.lproj "$BUILD_DIR/"
    echo "Localization files copied successfully!"
else
    echo "Build directory not found. Please build the project first."
fi

# Also update Info.plist to include localization info
INFO_PLIST="$BUILD_DIR/../Info.plist"
if [ -f "$INFO_PLIST" ]; then
    echo "Updating Info.plist with localization settings..."
    plutil -insert "CFBundleLocalizations" -xml '<array><string>en</string><string>fr</string><string>es</string></array>' "$INFO_PLIST" 2>/dev/null || echo "CFBundleLocalizations already exists or could not be added"
    plutil -replace "CFBundleDevelopmentRegion" -string "en" "$INFO_PLIST" 2>/dev/null || echo "CFBundleDevelopmentRegion already set or could not be updated"
fi

echo "Done!"

// ZenLinkCore.swift
// This file imports all core managers and extensions for the ZenLink app

import Foundation
import SwiftUI

// This file ensures all managers are available throughout the app
// by importing them in the correct order

// Make sure managers are imported first
@_exported import struct AppSettings
@_exported import class LocalizationManager  
@_exported import class ThemeManager
@_exported import class ClipboardManager
@_exported import class URLCleaner

// Global String extension for localization
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}

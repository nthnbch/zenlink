import Foundation
import SwiftUI

// Temporary inline localization until LocalizationManager is properly included
extension String {
    var localized: String {
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        } else if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
                  let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }
}

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            updateBundle()
            // Force UI update
            objectWillChange.send()
        }
    }
    
    private var bundle: Bundle = Bundle.main
    
    private init() {
        // Get system language first, fallback to English
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let supportedLanguage = ["en", "fr", "es"].contains(systemLanguage) ? systemLanguage : "en"
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? supportedLanguage
        self.currentLanguage = savedLanguage
        updateBundle()
    }
    
    private func updateBundle() {
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            // Fallback to English if the language is not found
            if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
               let bundle = Bundle(path: path) {
                self.bundle = bundle
            } else {
                self.bundle = Bundle.main
            }
        }
    }
    
    func localizedString(for key: String, comment: String = "") -> String {
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: comment)
    }
    
    var availableLanguages: [(code: String, name: String)] {
        return [
            ("en", "English"),
            ("fr", "Français"),
            ("es", "Español")
        ]
    }
}

// Convenience extension for easier access
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
    
    func localized(comment: String = "") -> String {
        return LocalizationManager.shared.localizedString(for: self, comment: comment)
    }
}

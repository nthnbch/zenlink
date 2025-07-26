import SwiftUI
import Foundation

// Import the LocalizationManager implementation
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            updateBundle()
            // Force UI update
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .languageChanged, object: nil)
            }
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
        print("Tentative de chargement de la langue: \(currentLanguage)")
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            print("Chemin trouvé: \(path)")
            if let bundle = Bundle(path: path) {
                self.bundle = bundle
                print("Bundle chargé avec succès")
            } else {
                print("Impossible de créer le bundle")
                fallbackToEnglish()
            }
        } else {
            print("Aucun chemin trouvé pour \(currentLanguage)")
            fallbackToEnglish()
        }
    }
    
    private func fallbackToEnglish() {
        print("Fallback vers l'anglais")
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
            print("Bundle anglais chargé")
        } else {
            print("Utilisation du bundle principal")
            self.bundle = Bundle.main
        }
    }
    
    func localizedString(for key: String, comment: String = "") -> String {
        let localizedValue = bundle.localizedString(forKey: key, value: nil, table: nil)
        // Si la valeur retournée est la même que la clé, c'est que la traduction n'a pas été trouvée
        if localizedValue == key {
            print("Traduction manquante pour la clé: \(key)")
            // Essayer avec le bundle principal en fallback
            let fallbackValue = Bundle.main.localizedString(forKey: key, value: key, table: nil)
            return fallbackValue
        }
        return localizedValue
    }
    
    var availableLanguages: [(code: String, name: String)] {
        return [
            ("en", "English"),
            ("fr", "Français"),
            ("es", "Español")
        ]
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
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

@main
struct ZenLinkApp: App {
    @StateObject private var appSettings = AppSettings.shared
    @StateObject private var clipboardManager = ClipboardManager()
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .environmentObject(localizationManager)
        } label: {
            Label("ZenLink", systemImage: "link.circle.fill")
        }
        .menuBarExtraStyle(.window)
        
        Settings {
            SettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .environmentObject(localizationManager)
                .frame(minWidth: 500, minHeight: 400)
        }
    }
}

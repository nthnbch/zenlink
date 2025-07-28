import SwiftUI
import Foundation

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
        
        // Essayer d'abord avec Bundle.main directement
        let localizedBundle = Bundle.main
        
        // Vérifier si la localisation existe
        if let path = localizedBundle.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: currentLanguage) {
            print("Fichier de localisation trouvé: \(path)")
            self.bundle = localizedBundle
            print("Bundle principal utilisé avec succès")
        } else {
            print("Aucune localisation trouvée pour \(currentLanguage), utilisation de l'anglais")
            self.bundle = localizedBundle
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
        // Utiliser la localisation native de Bundle.main avec la langue courante
        let localizedValue = NSLocalizedString(key, tableName: "Localizable", bundle: Bundle.main, value: key, comment: comment)
        
        print("Clé: \(key) -> Valeur: \(localizedValue)")
        
        // Si la valeur retournée est la même que la clé, essayer directement avec Bundle.main
        if localizedValue == key {
            print("Traduction manquante pour la clé: \(key)")
            return key
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

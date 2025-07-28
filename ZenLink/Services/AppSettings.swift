import Foundation
import Combine
import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case liquidGlass = "liquidGlass"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light:
            return NSLocalizedString("appearance_light", comment: "")
        case .dark:
            return NSLocalizedString("appearance_dark", comment: "")
        case .liquidGlass:
            return NSLocalizedString("appearance_liquid_glass", comment: "")
        case .system:
            return NSLocalizedString("appearance_system", comment: "")
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .liquidGlass:
            return nil // Will be handled specially
        case .system:
            return nil
        }
    }
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var appearanceMode: AppearanceMode {
        didSet {
            guard appearanceMode != oldValue else { return }
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode")
            // Post notification for appearance change
            NotificationCenter.default.post(
                name: NSNotification.Name("AppSettingsChanged"), 
                object: nil,
                userInfo: ["appearanceMode": appearanceMode.rawValue]
            )
        }
    }
    
    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: "isEnabled")
        }
    }
    
    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            configureLaunchAtLogin()
        }
    }
    
    @Published var showNotifications: Bool {
        didSet {
            UserDefaults.standard.set(showNotifications, forKey: "showNotifications")
        }
    }
    
    @Published var removeTrackingParams: Bool {
        didSet {
            UserDefaults.standard.set(removeTrackingParams, forKey: "removeTrackingParams")
        }
    }
    
    @Published var removeRedirects: Bool {
        didSet {
            UserDefaults.standard.set(removeRedirects, forKey: "removeRedirects")
        }
    }
    
    @Published var normalizeUrls: Bool {
        didSet {
            UserDefaults.standard.set(normalizeUrls, forKey: "normalizeUrls")
        }
    }
    
    @Published var clipboardCheckInterval: Double {
        didSet {
            UserDefaults.standard.set(clipboardCheckInterval, forKey: "clipboardCheckInterval")
        }
    }
    
    @Published var excludedDomains: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(excludedDomains), forKey: "excludedDomains")
        }
    }
    
    @Published var totalCleaned: Int {
        didSet {
            UserDefaults.standard.set(totalCleaned, forKey: "totalCleaned")
        }
    }
    
    private init() {
        let savedAppearance = UserDefaults.standard.string(forKey: "appearanceMode") ?? AppearanceMode.system.rawValue
        self.appearanceMode = AppearanceMode(rawValue: savedAppearance) ?? .system
        self.isEnabled = UserDefaults.standard.object(forKey: "isEnabled") as? Bool ?? true
        self.launchAtLogin = UserDefaults.standard.object(forKey: "launchAtLogin") as? Bool ?? false
        self.showNotifications = UserDefaults.standard.object(forKey: "showNotifications") as? Bool ?? true
        self.removeTrackingParams = UserDefaults.standard.object(forKey: "removeTrackingParams") as? Bool ?? true
        self.removeRedirects = UserDefaults.standard.object(forKey: "removeRedirects") as? Bool ?? false
        self.normalizeUrls = UserDefaults.standard.object(forKey: "normalizeUrls") as? Bool ?? true
        self.clipboardCheckInterval = UserDefaults.standard.object(forKey: "clipboardCheckInterval") as? Double ?? 0.5
        self.totalCleaned = UserDefaults.standard.object(forKey: "totalCleaned") as? Int ?? 0
        
        let savedDomains = UserDefaults.standard.array(forKey: "excludedDomains") as? [String] ?? []
        self.excludedDomains = Set(savedDomains)
    }
    
    func addExcludedDomain(_ domain: String) {
        let cleanDomain = domain.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !cleanDomain.isEmpty {
            excludedDomains.insert(cleanDomain)
        }
    }
    
    func removeExcludedDomain(_ domain: String) {
        excludedDomains.remove(domain)
    }
    
    func incrementTotalCleaned() {
        totalCleaned += 1
    }
    
    func resetStatistics() {
        totalCleaned = 0
    }
    
    private func configureLaunchAtLogin() {
        // Configuration du démarrage automatique
        // Cette fonctionnalité nécessiterait l'implémentation de ServiceManagement
        // ou l'utilisation d'un script de démarrage
    }
}

import SwiftUI
import Foundation

@main
struct ZenLinkApp: App {
    @StateObject private var appSettings = AppSettings.shared
    @StateObject private var clipboardManager = ClipboardManager()
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    init() {
        print("ZenLink starting with all managers...")
        // Configuration initiale sans dépendances circulaires
        if AppSettings.shared.appearanceMode != .system {
            DispatchQueue.main.async {
                ThemeManager.shared.currentAppearance = AppSettings.shared.appearanceMode
            }
        }
    }
    
    var body: some Scene {
        MenuBarExtra {
            VStack {
                Text("ZenLink v1.1.0")
                    .font(.headline)
                Text("Mode: \(appSettings.appearanceMode.displayName)")
                    .font(.caption)
                Text("Theme: \(themeManager.currentAppearance.rawValue)")
                    .font(.caption2)
                Text("Language: \(localizationManager.currentLanguage)")
                    .font(.caption2)
                Text("Cleaned Today: \(clipboardManager.dailyCleanedCount)")
                    .font(.caption2)
                
                Divider()
                
                HStack {
                    Button("Start Monitor") {
                        clipboardManager.startMonitoring()
                    }
                    .disabled(clipboardManager.isMonitoring)
                    
                    Button("Stop Monitor") {
                        clipboardManager.stopMonitoring()
                    }
                    .disabled(!clipboardManager.isMonitoring)
                }
                
                Button("Quitter") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
            .environmentObject(appSettings)
            .environmentObject(clipboardManager)
            .environmentObject(themeManager)
            .environmentObject(localizationManager)
        } label: {
            Label("ZenLink", systemImage: "link.circle.fill")
        }
        .menuBarExtraStyle(.window)
    }
}

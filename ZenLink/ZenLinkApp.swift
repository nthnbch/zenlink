import SwiftUI

@main
struct ZenLinkApp: App {
    @StateObject private var appSettings = AppSettings.shared
    @StateObject private var clipboardManager = ClipboardManager()
    
    var body: some Scene {
        MenuBarExtra("ZenLink", systemImage: "link.circle.fill") {
            MenuBarView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
        }
        .menuBarExtraStyle(.window)
        
        Settings {
            SettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .frame(minWidth: 500, minHeight: 400)
        }
    }
}

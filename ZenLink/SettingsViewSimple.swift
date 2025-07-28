import SwiftUI

struct SettingsViewSimple: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        TabView {
            SimpleGeneralSettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .tabItem {
                    Label("Général", systemImage: "gear")
                }
            
            SimpleAppearanceSettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .tabItem {
                    Label("Apparence", systemImage: "paintbrush")
                }
        }
        .frame(width: 500, height: 400)
        .onAppear {
            // Force le focus sur la fenêtre des paramètres
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let window = NSApp.windows.first(where: { $0.title.contains("Settings") || $0.title.contains("Paramètres") || $0.title.contains("Préférences") }) {
                    window.makeKeyAndOrderFront(nil)
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
            
            // Synchroniser le thème
            themeManager.currentAppearance = appSettings.appearanceMode
        }
    }
}

struct SimpleGeneralSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Paramètres Généraux")
                .font(.title2)
                .fontWeight(.semibold)
            
            Toggle("Activer ZenLink", isOn: $appSettings.isActive)
            
            Toggle("Nettoyer automatiquement", isOn: $appSettings.isAutoCleanEnabled)
            
            Spacer()
        }
        .padding()
    }
}

struct SimpleAppearanceSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Apparence")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Mode d'apparence")
                    .font(.headline)
                
                Picker("Mode d'apparence", selection: $appSettings.appearanceMode) {
                    ForEach(AppearanceMode.allCases, id: \.self) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: appSettings.appearanceMode) { newMode in
                    themeManager.currentAppearance = newMode
                }
            }
            
            if appSettings.appearanceMode == .liquidGlass {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mode Liquid Glass activé")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Text("Ce mode utilise des effets de transparence et de flou pour créer un effet de verre liquide.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            themeManager.currentAppearance = appSettings.appearanceMode
        }
    }
}

#Preview {
    SettingsViewSimple()
        .environmentObject(AppSettings.shared)
        .environmentObject(ClipboardManager())
}

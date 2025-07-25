import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @State private var newExclusion = ""
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .tabItem {
                    Label("Général", systemImage: "gear")
                }
            
            ExclusionsSettingsView(newExclusion: $newExclusion)
                .environmentObject(appSettings)
                .tabItem {
                    Label("Exclusions", systemImage: "list.bullet")
                }
            
            AdvancedSettingsView()
                .environmentObject(appSettings)
                .tabItem {
                    Label("Avancé", systemImage: "slider.horizontal.3")
                }
        }
        .frame(width: 500, height: 400)
    }
}

struct GeneralSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GroupBox("Fonctionnement") {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Activer ZenLink au démarrage", isOn: $appSettings.isEnabled)
                    
                    Toggle("Démarrer avec macOS", isOn: $appSettings.launchAtLogin)
                    
                    Toggle("Afficher les notifications", isOn: $appSettings.showNotifications)
                        .help("Affiche une notification quand un lien est nettoyé")
                }
                .padding()
            }
            
            GroupBox("Statistiques") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Liens nettoyés aujourd'hui:")
                        Spacer()
                        Text("\(clipboardManager.dailyCleanedCount)")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Total depuis l'installation:")
                        Spacer()
                        Text("\(appSettings.totalCleaned)")
                            .fontWeight(.semibold)
                    }
                    
                    Button("Réinitialiser les statistiques") {
                        appSettings.resetStatistics()
                        clipboardManager.resetDailyCount()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ExclusionsSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Binding var newExclusion: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GroupBox("Domaines exclus") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Les liens de ces domaines ne seront pas modifiés:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField("Ajouter un domaine (ex: example.com)", text: $newExclusion)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Ajouter") {
                            addExclusion()
                        }
                        .disabled(newExclusion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    
                    if appSettings.excludedDomains.isEmpty {
                        Text("Aucun domaine exclu")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 4) {
                                ForEach(appSettings.excludedDomains.sorted(), id: \.self) { domain in
                                    HStack {
                                        Text(domain)
                                            .font(.system(.body, design: .monospaced))
                                        Spacer()
                                        Button("Supprimer") {
                                            appSettings.removeExcludedDomain(domain)
                                        }
                                        .buttonStyle(.borderless)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                        .frame(maxHeight: 150)
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func addExclusion() {
        let domain = newExclusion.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !domain.isEmpty {
            appSettings.addExcludedDomain(domain)
            newExclusion = ""
        }
    }
}

struct AdvancedSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GroupBox("Nettoyage des URLs") {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Supprimer les paramètres de tracking", isOn: $appSettings.removeTrackingParams)
                        .help("Supprime utm_*, fbclid, gclid, etc.")
                    
                    Toggle("Supprimer les redirections", isOn: $appSettings.removeRedirects)
                        .help("Déplie les liens raccourcis et redirections")
                    
                    Toggle("Normaliser les URLs", isOn: $appSettings.normalizeUrls)
                        .help("Standardise le format des URLs")
                }
                .padding()
            }
            
            GroupBox("Performance") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Délai de surveillance du presse-papiers:")
                        Spacer()
                        Stepper(value: $appSettings.clipboardCheckInterval, in: 0.1...2.0, step: 0.1) {
                            Text("\(appSettings.clipboardCheckInterval, specifier: "%.1f")s")
                        }
                    }
                    
                    Text("Un délai plus court améliore la réactivité mais utilise plus de ressources")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            GroupBox("Confidentialité") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Aucune donnée n'est envoyée vers des serveurs externes")
                    Text("• Tout le traitement se fait localement sur votre Mac")
                    Text("• Aucun historique des URLs n'est conservé")
                    Text("• Les statistiques sont stockées uniquement sur votre appareil")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings.shared)
        .environmentObject(ClipboardManager())
}

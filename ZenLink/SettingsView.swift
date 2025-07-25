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
        .navigationTitle("Paramètres ZenLink")
    }
}

struct GeneralSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    var body: some View {
        Form {
            Section {
                Toggle("Activer ZenLink", isOn: $appSettings.isEnabled)
                    .help("Active ou désactive le nettoyage automatique des URLs")
                
                Toggle("Démarrer avec macOS", isOn: $appSettings.launchAtLogin)
                    .help("Lance ZenLink automatiquement au démarrage de macOS")
                
                Toggle("Afficher les notifications", isOn: $appSettings.showNotifications)
                    .help("Affiche une notification quand un lien est nettoyé")
            } header: {
                Text("Fonctionnement")
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text("Aujourd'hui")
                    Spacer()
                    Text("\(clipboardManager.dailyCleanedCount)")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                HStack {
                    Text("Total")
                    Spacer()
                    Text("\(appSettings.totalCleaned)")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                HStack {
                    Spacer()
                    Button("Réinitialiser les statistiques") {
                        appSettings.resetStatistics()
                        clipboardManager.resetDailyCount()
                    }
                    .controlSize(.small)
                }
            } header: {
                Text("Statistiques")
                    .font(.headline)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct ExclusionsSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Binding var newExclusion: String
    
    var body: some View {
        Form {
            Section {
                Text("Les liens de ces domaines ne seront pas modifiés")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                HStack {
                    TextField("exemple.com", text: $newExclusion)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            addExclusion()
                        }
                    
                    Button("Ajouter") {
                        addExclusion()
                    }
                    .controlSize(.small)
                    .disabled(newExclusion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            } header: {
                Text("Ajouter un domaine")
                    .font(.headline)
            }
            
            Section {
                if appSettings.excludedDomains.isEmpty {
                    Text("Aucun domaine exclu")
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
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
                            .controlSize(.small)
                        }
                        .padding(.vertical, 2)
                    }
                }
            } header: {
                Text("Domaines exclus")
                    .font(.headline)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
        Form {
            Section {
                Toggle("Supprimer les paramètres de tracking", isOn: $appSettings.removeTrackingParams)
                    .help("Supprime utm_*, fbclid, gclid, etc.")
                
                Toggle("Supprimer les redirections", isOn: $appSettings.removeRedirects)
                    .help("Déplie les liens raccourcis et redirections")
                
                Toggle("Normaliser les URLs", isOn: $appSettings.normalizeUrls)
                    .help("Standardise le format des URLs")
            } header: {
                Text("Nettoyage des URLs")
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text("Délai de surveillance")
                    Spacer()
                    Stepper(value: $appSettings.clipboardCheckInterval, in: 0.1...2.0, step: 0.1) {
                        Text("\(appSettings.clipboardCheckInterval, specifier: "%.1f") s")
                            .monospacedDigit()
                            .foregroundColor(.secondary)
                    }
                }
                .help("Un délai plus court améliore la réactivité mais utilise plus de ressources")
            } header: {
                Text("Performance")
                    .font(.headline)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Traitement 100% local")
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Aucune collecte de données")
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Code open source")
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Pas d'historique stocké")
                    }
                }
                .font(.caption)
            } header: {
                Text("Confidentialité")
                    .font(.headline)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings.shared)
        .environmentObject(ClipboardManager())
}

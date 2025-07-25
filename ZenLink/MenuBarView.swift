import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // En-tête
            HStack {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.blue)
                Text("ZenLink")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    appSettings.isEnabled.toggle()
                }) {
                    Image(systemName: appSettings.isEnabled ? "power.circle.fill" : "power.circle")
                        .foregroundColor(appSettings.isEnabled ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .help(appSettings.isEnabled ? "Désactiver ZenLink" : "Activer ZenLink")
            }
            
            Divider()
            
            // Statut
            HStack {
                Circle()
                    .fill(appSettings.isEnabled ? .green : .gray)
                    .frame(width: 8, height: 8)
                Text(appSettings.isEnabled ? "Actif" : "Inactif")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            // Statistiques
            VStack(alignment: .leading, spacing: 4) {
                Text("Liens nettoyés aujourd'hui: \(clipboardManager.dailyCleanedCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Total: \(appSettings.totalCleaned)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Log récent
            VStack(alignment: .leading, spacing: 2) {
                Text("Activité récente")
                    .font(.caption)
                    .fontWeight(.medium)
                
                if clipboardManager.recentActivity.isEmpty {
                    Text("Aucune activité")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(clipboardManager.recentActivity.prefix(3), id: \.timestamp) { activity in
                        HStack {
                            Image(systemName: activity.wasChanged ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(activity.wasChanged ? .green : .orange)
                                .font(.caption2)
                            Text(activity.description)
                                .font(.caption2)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Text(activity.timeAgo)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Divider()
            
            // Actions
            VStack(spacing: 8) {
                Button("Paramètres...") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.blue)
                
                Button("Quitter ZenLink") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.red)
            }
        }
        .padding()
        .frame(width: 280)
    }
}

#Preview {
    MenuBarView()
        .environmentObject(AppSettings.shared)
        .environmentObject(ClipboardManager())
}

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // En-tête avec statut
            headerSection
            
            Divider()
            
            // Statistiques compactes
            statisticsSection
            
            if !clipboardManager.recentActivity.isEmpty {
                Divider()
                
                // Activité récente
                activitySection
            }
            
            Divider()
            
            // Actions
            actionsSection
        }
        .frame(width: 300)
        .fixedSize(horizontal: true, vertical: false)
    }
    
    private var headerSection: some View {
        HStack(spacing: 12) {
            // App icon and name with better spacing
            HStack(spacing: 8) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.title2)
                    .imageScale(.medium)
                
                Text("ZenLink")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            // Status indicator with toggle
            HStack(spacing: 8) {
                // Status indicator
                Circle()
                    .fill(appSettings.isEnabled ? .green : .secondary)
                    .frame(width: 8, height: 8)
                
                Text(appSettings.isEnabled ? "Actif" : "Inactif")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Power button with proper styling
                Button(action: {
                    appSettings.isEnabled.toggle()
                }) {
                    Image(systemName: appSettings.isEnabled ? "power.circle.fill" : "power.circle")
                        .foregroundColor(appSettings.isEnabled ? .green : .secondary)
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .help(appSettings.isEnabled ? "Désactiver ZenLink" : "Activer ZenLink")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var statisticsSection: some View {
        VStack(spacing: 8) {
            HStack {
                Label("Aujourd'hui", systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .labelStyle(.titleAndIcon)
                
                Spacer()
                
                Text("\(clipboardManager.dailyCleanedCount)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .monospacedDigit()
            }
            
            HStack {
                Label("Total", systemImage: "chart.bar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .labelStyle(.titleAndIcon)
                
                Spacer()
                
                Text("\(appSettings.totalCleaned)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Activité récente")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            VStack(spacing: 6) {
                ForEach(clipboardManager.recentActivity.prefix(3), id: \.timestamp) { activity in
                    HStack(spacing: 10) {
                        Image(systemName: activity.wasChanged ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(activity.wasChanged ? .green : .orange)
                            .font(.caption)
                            .frame(width: 12)
                        
                        Text(activity.description)
                            .font(.caption2)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .foregroundColor(.primary)
                        
                        Spacer(minLength: 0)
                        
                        Text(activity.timeAgo)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 2)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var actionsSection: some View {
        VStack(spacing: 0) {
            // Settings link with compatibility for macOS 13+
            if #available(macOS 14.0, *) {
                SettingsLink {
                    HStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.caption)
                            .frame(width: 12)
                        
                        Text("Paramètres…")
                            .font(.caption)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("Ouvrir les paramètres de ZenLink")
            } else {
                // Fallback for macOS 13
                Button(action: {
                    openSettingsFallback()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.caption)
                            .frame(width: 12)
                        
                        Text("Paramètres…")
                            .font(.caption)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("Ouvrir les paramètres de ZenLink")
            }
            
            Divider()
                .padding(.horizontal, 16)
            
            // Quit button
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "power")
                        .font(.caption)
                        .frame(width: 12)
                    
                    Text("Quitter ZenLink")
                        .font(.caption)
                    
                    Spacer()
                }
                .foregroundColor(.red)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("Quitter ZenLink")
        }
        .padding(.vertical, 8)
    }
    
    // Fallback settings method for macOS 13
    private func openSettingsFallback() {
        // Try to open settings using NSApp action
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
    
}

#Preview {
    MenuBarView()
        .environmentObject(AppSettings.shared)
        .environmentObject(ClipboardManager())
}

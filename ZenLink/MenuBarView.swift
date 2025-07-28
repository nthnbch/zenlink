import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var refreshID = UUID()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // En-tête avec statut
            headerSection
            
            Divider()
                .opacity(themeManager.isLiquidGlassEnabled ? 0.3 : 1.0)
            
            // Statistiques compactes  
            statisticsSection
            
            // Activité récente (toujours présente pour éviter les recomputations)
            Divider()
                .opacity(themeManager.isLiquidGlassEnabled ? 0.3 : 1.0)
            activitySection
            
            Divider()
                .opacity(themeManager.isLiquidGlassEnabled ? 0.3 : 1.0)
            
            // Actions
            actionsSection
        }
        .frame(width: 300)
        .background(themeManager.primaryBackground)
        .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 1.0 : 0.0)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        .id(refreshID)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            refreshID = UUID()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AppearanceModeChanged"))) { _ in
            refreshID = UUID()
        }
        .onAppear {
            themeManager.currentAppearance = appSettings.appearanceMode
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 12) {
            // App icon and name with better spacing
            HStack(spacing: 8) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(themeManager.accentColor)
                    .font(.title2)
                    .imageScale(.medium)
                
                Text("app_name".localized)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.primaryText)
            }
            
            Spacer()
            
            // Status indicator with toggle
            HStack(spacing: 8) {
                // Status indicator
                Circle()
                    .fill(appSettings.isEnabled ? themeManager.accentColor : themeManager.secondaryText)
                    .frame(width: 8, height: 8)
                
                Text(appSettings.isEnabled ? "status_active".localized : "status_inactive".localized)
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryText)
                
                // Power button with proper styling
                Button(action: {
                    appSettings.isEnabled.toggle()
                }) {
                    Image(systemName: appSettings.isEnabled ? "power.circle.fill" : "power.circle")
                        .foregroundColor(appSettings.isEnabled ? themeManager.accentColor : themeManager.secondaryText)
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .help(appSettings.isEnabled ? "tooltip_disable".localized : "tooltip_enable".localized)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(themeManager.secondaryBackground.opacity(0.3))
        .animatedLiquidGlass(intensity: 0.6)
    }
    
    private var statisticsSection: some View {
        VStack(spacing: 8) {
            HStack {
                Label("today".localized, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryText)
                    .labelStyle(.titleAndIcon)
                
                Spacer()
                
                Text("\(clipboardManager.dailyCleanedCount)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.primaryText)
                    .monospacedDigit()
            }
            
            HStack {
                Label("total".localized, systemImage: "chart.bar")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryText)
                    .labelStyle(.titleAndIcon)
                
                Spacer()
                
                Text("\(appSettings.totalCleaned)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.primaryText)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(themeManager.secondaryBackground.opacity(0.2))
        .liquidGlass(intensity: 0.3)
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("recent_activity".localized)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            // Always show content, completely eliminate conditionals
            VStack(spacing: 6) {
                let activities = Array(clipboardManager.recentActivity.prefix(3))
                
                if activities.isEmpty {
                    Text("no_recent_activity".localized)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .frame(height: 24) // Fixed height
                } else {
                    ForEach(activities, id: \.timestamp) { activity in
                        HStack(spacing: 10) {
                            Image(systemName: activity.wasChanged ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(activity.wasChanged ? .green : .orange)
                                .font(.caption)
                                .frame(width: 12, height: 12) // Fixed size
                            
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
                        .frame(height: 24) // Fixed height for each row
                    }
                }
            }
            .frame(minHeight: 72) // Ensure consistent height (3 rows * 24pts)
        }
        .padding(.vertical, 8)
    }
    
    private var actionsSection: some View {
        VStack(spacing: 0) {
            // Settings link with proper SettingsLink for all macOS versions
            if #available(macOS 14.0, *) {
                SettingsLink {
                    HStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.caption)
                            .frame(width: 12)
                        
                        Text("settings_menu".localized)
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
                .help("tooltip_settings".localized)
            } else {
                // For macOS 13, use a direct button that triggers settings window
                Button(action: {
                    openSettingsForMacOS13()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.caption)
                            .frame(width: 12)
                        
                        Text("settings_menu".localized)
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
                .help("tooltip_settings".localized)
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
                    
                    Text("quit_zenlink".localized)
                        .font(.caption)
                    
                    Spacer()
                }
                .foregroundColor(.red)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("tooltip_quit".localized)
        }
        .padding(.vertical, 8)
    }
    
    // Enhanced settings opener for macOS 13 with better window management
    private func openSettingsForMacOS13() {
        // Close any existing settings windows first
        for window in NSApp.windows {
            if window.title == "settings_title".localized {
                window.close()
            }
        }
        
        // Create and configure settings window
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        settingsWindow.title = "settings_title".localized
        settingsWindow.isReleasedWhenClosed = true // Changé de false à true pour éviter les fuites
        settingsWindow.hidesOnDeactivate = false
        
        // Set content view
        settingsWindow.contentView = NSHostingView(rootView: 
            SettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .environmentObject(localizationManager)
                .environmentObject(themeManager)
        )
        
        // Position window nicely
        settingsWindow.center()
        
        // Enhanced window visibility settings
        settingsWindow.level = .normal
        settingsWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // Show window
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow.makeKeyAndOrderFront(nil)
    }
    
}

#Preview {
    MenuBarView()
        .environmentObject(AppSettings.shared)
        .environmentObject(ClipboardManager())
}

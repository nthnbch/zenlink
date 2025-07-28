import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var themeManager = ThemeManager.shared
    @State private var newExclusion = ""
    @State private var refreshID = UUID()
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .environmentObject(appSettings)
                .environmentObject(clipboardManager)
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_general".localized, systemImage: "gear")
                }
                .background(themeManager.primaryBackground)
                .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.3 : 0.0)
            
            AppearanceSettingsView()
                .environmentObject(appSettings)
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_appearance".localized, systemImage: "paintbrush")
                }
                .background(themeManager.primaryBackground)
                .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.3 : 0.0)
            
            ExclusionsSettingsView(newExclusion: $newExclusion)
                .environmentObject(appSettings)
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_exclusions".localized, systemImage: "list.bullet")
                }
                .background(themeManager.primaryBackground)
                .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.3 : 0.0)
            
            AdvancedSettingsView()
                .environmentObject(appSettings)
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_advanced".localized, systemImage: "slider.horizontal.3")
                }
                .background(themeManager.primaryBackground)
                .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.3 : 0.0)
            
            LanguageSettingsView()
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_language".localized, systemImage: "globe")
                }
                .background(themeManager.primaryBackground)
                .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.3 : 0.0)
            
            InformationSettingsView()
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_information".localized, systemImage: "info.circle")
                }
                .background(themeManager.primaryBackground)
                .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.3 : 0.0)
        }
        .frame(width: 500, height: 400)
        .navigationTitle("settings_title".localized)
        .background(themeManager.primaryBackground)
        .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 1.0 : 0.0)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        .id(refreshID)
        .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            refreshID = UUID()
        }
        .onReceive(NotificationCenter.default.publisher(for: .appearanceModeChanged)) { _ in
            refreshID = UUID()
            themeManager.currentAppearance = appSettings.appearanceMode
        }
        .onAppear {
            themeManager.currentAppearance = appSettings.appearanceMode
        }
    }
}

struct AppearanceSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Form {
            Section {
                ForEach(AppearanceMode.allCases, id: \.self) { mode in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mode.displayName)
                                .font(.body)
                                .foregroundColor(themeManager.primaryText)
                            
                            if mode == .liquidGlass {
                                Text("appearance_liquid_glass_description".localized)
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryText)
                            }
                        }
                        
                        Spacer()
                        
                        if appSettings.appearanceMode == mode {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(themeManager.accentColor)
                        } else {
                            Circle()
                                .stroke(themeManager.secondaryText, lineWidth: 1)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .contentShape(Rectangle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.secondaryBackground.opacity(0.5))
                            .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.4 : 0.0)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            appSettings.appearanceMode = mode
                            themeManager.currentAppearance = mode
                            NotificationCenter.default.post(name: .appearanceModeChanged, object: nil)
                        }
                    }
                }
            } header: {
                Text("appearance_mode_title".localized)
                    .font(.headline)
                    .foregroundColor(themeManager.primaryText)
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("appearance_mode_description".localized)
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryText)
                    
                    if appSettings.appearanceMode == .liquidGlass {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(themeManager.accentColor)
                            Text("liquid_glass_active_info".localized)
                                .font(.caption)
                                .foregroundColor(themeManager.accentColor)
                        }
                        .padding(.top, 4)
                    }
                }
            }
            
            // Apple-style liquid glass preview
            if appSettings.appearanceMode == .liquidGlass {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("liquid_glass_preview_title".localized)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(themeManager.primaryText)
                        
                        // Enhanced preview card with Apple-style liquid glass
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("preview_card_title".localized)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.primaryText)
                                    
                                    Text("preview_card_description".localized)
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.secondaryText)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(themeManager.accentColor)
                                        .font(.title2)
                                    
                                    HStack {
                                        Circle()
                                            .fill(themeManager.accentColor)
                                            .frame(width: 8, height: 8)
                                        Text("preview_status".localized)
                                            .font(.caption2)
                                            .foregroundColor(themeManager.secondaryText)
                                    }
                                }
                            }
                            
                            // Additional preview elements
                            HStack(spacing: 12) {
                                ForEach(0..<3) { index in
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(themeManager.accentColor.opacity(0.6))
                                        .frame(height: 4)
                                        .animatedLiquidGlass(intensity: 0.8)
                                }
                            }
                        }
                        .padding(.all, 20)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                        .shadow(
                            color: Color.black.opacity(0.1),
                            radius: 20,
                            x: 0,
                            y: 10
                        )
                    }
                } header: {
                    Text("liquid_glass_preview".localized)
                        .font(.headline)
                        .foregroundColor(themeManager.primaryText)
                }
            }
        }
        .formStyle(.grouped)
        .background(themeManager.primaryBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct GeneralSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Form {
            Section {
                Toggle("enable_zenlink".localized, isOn: $appSettings.isEnabled)
                    .help("enable_zenlink_help".localized)
                    .foregroundColor(themeManager.primaryText)
                
                Toggle("launch_at_login".localized, isOn: $appSettings.launchAtLogin)
                    .help("launch_at_login_help".localized)
                    .foregroundColor(themeManager.primaryText)
                
                Toggle("show_notifications".localized, isOn: $appSettings.showNotifications)
                    .help("show_notifications_help".localized)
                    .foregroundColor(themeManager.primaryText)
            } header: {
                Text("section_functionality".localized)
                    .font(.headline)
                    .foregroundColor(themeManager.primaryText)
            }
            
            Section {
                HStack {
                    Text("today".localized)
                        .foregroundColor(themeManager.primaryText)
                    Spacer()
                    Text("\(clipboardManager.dailyCleanedCount)")
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.secondaryText)
                        .monospacedDigit()
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.secondaryBackground.opacity(0.3))
                        .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.4 : 0.0)
                )
                
                HStack {
                    Text("total".localized)
                        .foregroundColor(themeManager.primaryText)
                    Spacer()
                    Text("\(appSettings.totalCleaned)")
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.secondaryText)
                        .monospacedDigit()
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.secondaryBackground.opacity(0.3))
                        .liquidGlass(intensity: themeManager.isLiquidGlassEnabled ? 0.4 : 0.0)
                )
                
                HStack {
                    Spacer()
                    Button("reset_statistics".localized) {
                        appSettings.resetStatistics()
                        clipboardManager.resetDailyCount()
                    }
                    .controlSize(.small)
                    .foregroundColor(themeManager.accentColor)
                }
            } header: {
                Text("section_statistics".localized)
                    .font(.headline)
                    .foregroundColor(themeManager.primaryText)
            }
        }
        .formStyle(.grouped)
        .background(themeManager.primaryBackground)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct ExclusionsSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var localizationManager: LocalizationManager
    @Binding var newExclusion: String
    
    var body: some View {
        Form {
            Section {
                Text("exclusions_description".localized)
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                HStack {
                    TextField("domain_placeholder".localized, text: $newExclusion)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            addExclusion()
                        }
                    
                    Button("add_button".localized) {
                        addExclusion()
                    }
                    .controlSize(.small)
                    .disabled(newExclusion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            } header: {
                Text("add_domain".localized)
                    .font(.headline)
            }
            
            Section {
                if appSettings.excludedDomains.isEmpty {
                    Text("no_excluded_domains".localized)
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
                            
                            Button("remove_button".localized) {
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
                Text("excluded_domains".localized)
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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        Form {
            Section {
                Toggle("remove_tracking_params".localized, isOn: $appSettings.removeTrackingParams)
                    .help("remove_tracking_params_help".localized)
                
                Toggle("remove_redirects".localized, isOn: $appSettings.removeRedirects)
                    .help("remove_redirects_help".localized)
                
                Toggle("normalize_urls".localized, isOn: $appSettings.normalizeUrls)
                    .help("normalize_urls_help".localized)
            } header: {
                Text("section_url_cleaning".localized)
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text("monitoring_delay".localized)
                    Spacer()
                    Stepper(value: $appSettings.clipboardCheckInterval, in: 0.1...2.0, step: 0.1) {
                        Text("\(appSettings.clipboardCheckInterval, specifier: "%.1f") s")
                            .monospacedDigit()
                            .foregroundColor(.secondary)
                    }
                }
                .help("monitoring_delay_help".localized)
            } header: {
                Text("section_performance".localized)
                    .font(.headline)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("privacy_local".localized)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("privacy_no_data".localized)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("privacy_open_source".localized)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("privacy_no_history".localized)
                    }
                }
                .font(.caption)
            } header: {
                Text("section_privacy".localized)
                    .font(.headline)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct LanguageSettingsView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        Form {
            Section {
                ForEach(Array(localizationManager.availableLanguages), id: \.0) { language in
                    HStack {
                        Text(language.1)
                        Spacer()
                        if localizationManager.currentLanguage == language.0 {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        localizationManager.setLanguage(language.0)
                    }
                }
            } header: {
                Text("language_settings_title".localized)
                    .font(.headline)
            } footer: {
                Text("language_settings_description".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct InformationSettingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("app_description".localized)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("information_title".localized)
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text("version_label".localized)
                    Spacer()
                    Text("1.1.0")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("developer_label".localized)
                    Spacer()
                    Text("nthnbch")
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/nthnbch/zenlink")!) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.accentColor)
                        Text("repository_label".localized)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Link(destination: URL(string: "https://helloworld.com")!) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.accentColor)
                        Text("website_label".localized)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("support_description".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("support_label".localized)
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
        .environmentObject(LocalizationManager.shared)
}

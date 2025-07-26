import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var localizationManager: LocalizationManager
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
            
            ExclusionsSettingsView(newExclusion: $newExclusion)
                .environmentObject(appSettings)
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_exclusions".localized, systemImage: "list.bullet")
                }
            
            AdvancedSettingsView()
                .environmentObject(appSettings)
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_advanced".localized, systemImage: "slider.horizontal.3")
                }
            
            LanguageSettingsView()
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_language".localized, systemImage: "globe")
                }
            
            InformationSettingsView()
                .environmentObject(localizationManager)
                .tabItem {
                    Label("tab_information".localized, systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 400)
        .navigationTitle("settings_title".localized)
        .id(refreshID)
        .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            refreshID = UUID()
        }
    }
}

struct GeneralSettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        Form {
            Section {
                Toggle("enable_zenlink".localized, isOn: $appSettings.isEnabled)
                    .help("enable_zenlink_help".localized)
                
                Toggle("launch_at_login".localized, isOn: $appSettings.launchAtLogin)
                    .help("launch_at_login_help".localized)
                
                Toggle("show_notifications".localized, isOn: $appSettings.showNotifications)
                    .help("show_notifications_help".localized)
            } header: {
                Text("section_functionality".localized)
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text("today".localized)
                    Spacer()
                    Text("\(clipboardManager.dailyCleanedCount)")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                HStack {
                    Text("total".localized)
                    Spacer()
                    Text("\(appSettings.totalCleaned)")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                HStack {
                    Spacer()
                    Button("reset_statistics".localized) {
                        appSettings.resetStatistics()
                        clipboardManager.resetDailyCount()
                    }
                    .controlSize(.small)
                }
            } header: {
                Text("section_statistics".localized)
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
                ForEach(localizationManager.availableLanguages, id: \.0) { language in
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
                        localizationManager.currentLanguage = language.0
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

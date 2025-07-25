import Foundation
import AppKit
import SwiftUI

struct ClipboardActivity {
    let timestamp: Date
    let originalUrl: String
    let cleanedUrl: String?
    let wasChanged: Bool
    
    // Precomputed properties to avoid layout recursion
    let description: String
    let timeAgo: String
    
    init(timestamp: Date, originalUrl: String, cleanedUrl: String?, wasChanged: Bool) {
        self.timestamp = timestamp
        self.originalUrl = originalUrl
        self.cleanedUrl = cleanedUrl
        self.wasChanged = wasChanged
        
        // Precompute description
        if wasChanged {
            self.description = "Nettoyé: \(originalUrl)"
        } else {
            self.description = "Ignoré: \(originalUrl)"
        }
        
        // Precompute timeAgo
        let interval = Date().timeIntervalSince(timestamp)
        if interval < 60 {
            self.timeAgo = "À l'instant"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            self.timeAgo = "\(minutes)m"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            self.timeAgo = "\(hours)h"
        } else {
            let days = Int(interval / 86400)
            self.timeAgo = "\(days)j"
        }
    }
}

class ClipboardManager: ObservableObject {
    @Published var recentActivity: [ClipboardActivity] = []
    @Published var dailyCleanedCount: Int = 0
    
    private var timer: Timer?
    private var lastClipboardContent: String = ""
    private var lastDailyCountReset: Date = Date()
    private let urlCleaner = URLCleaner()
    
    init() {
        resetDailyCountIfNeeded()
        requestNotificationPermission()
        
        // Start monitoring after an even longer delay to ensure all UI is settled
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.startMonitoring()
        }
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        stopMonitoring()
        
        // Use a simple timer without RunLoop complications
        timer = Timer.scheduledTimer(withTimeInterval: AppSettings.shared.clipboardCheckInterval, repeats: true) { [weak self] _ in
            // Execute clipboard check entirely on background queue
            DispatchQueue.global(qos: .utility).async {
                self?.checkClipboard()
            }
        }
        
        // Initial check after a delay
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.5) {
            self.checkClipboard()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetDailyCount() {
        dailyCleanedCount = 0
        lastDailyCountReset = Date()
    }
    
    private func checkClipboard() {
        guard AppSettings.shared.isEnabled else { return }
        
        // Vérifier que l'application est bien initialisée
        guard Bundle.main.bundleIdentifier != nil else {
            return
        }
        
        let pasteboard = NSPasteboard.general
        guard let currentContent = pasteboard.string(forType: .string),
              currentContent != lastClipboardContent,
              !currentContent.isEmpty else {
            return
        }
        
        lastClipboardContent = currentContent
        
        // Vérifier si c'est une URL
        guard isValidURL(currentContent) else { return }
        
        // Vérifier si le domaine est exclu
        if let url = URL(string: currentContent),
           let host = url.host?.lowercased(),
           AppSettings.shared.excludedDomains.contains(where: { host.contains($0) || $0.contains(host) }) {
            
            let activity = ClipboardActivity(
                timestamp: Date(),
                originalUrl: currentContent,
                cleanedUrl: nil,
                wasChanged: false
            )
            addActivity(activity)
            return
        }
        
        // Nettoyer l'URL
        let cleanedURL = urlCleaner.cleanURL(currentContent)
        let wasChanged = cleanedURL != currentContent
        
        if wasChanged {
            // Remplacer le contenu du presse-papiers sur la main queue
            DispatchQueue.main.async {
                pasteboard.clearContents()
                pasteboard.setString(cleanedURL, forType: .string)
            }
            
            // Mettre à jour les statistiques
            DispatchQueue.main.async {
                AppSettings.shared.incrementTotalCleaned()
                self.dailyCleanedCount += 1
            }
            
            // Afficher une notification si activée
            if AppSettings.shared.showNotifications {
                showNotification(originalURL: currentContent, cleanedURL: cleanedURL)
            }
        }
        
        let activity = ClipboardActivity(
            timestamp: Date(),
            originalUrl: currentContent,
            cleanedUrl: wasChanged ? cleanedURL : nil,
            wasChanged: wasChanged
        )
        addActivity(activity)
    }
    
    private func addActivity(_ activity: ClipboardActivity) {
        // Use an even longer delay to ensure layout is completely done
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.updateActivityBatched(activity)
        }
    }
    
    private func updateActivityBatched(_ activity: ClipboardActivity) {
        // Simple update without animation to prevent layout recursion
        recentActivity.insert(activity, at: 0)
        
        // Keep only the last 10 activities
        if recentActivity.count > 10 {
            recentActivity = Array(recentActivity.prefix(10))
        }
    }
    
    private func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string),
              let scheme = url.scheme?.lowercased() else {
            return false
        }
        
        return scheme == "http" || scheme == "https"
    }
    
    private func resetDailyCountIfNeeded() {
        let calendar = Calendar.current
        if !calendar.isDate(lastDailyCountReset, inSameDayAs: Date()) {
            resetDailyCount()
        }
    }
    
    private func requestNotificationPermission() {
        // Éviter les problèmes de bundle avec UNUserNotificationCenter
        // On utilisera NSUserNotification à la place pour la compatibilité
    }
    
    private func showNotification(originalURL: String, cleanedURL: String) {
        // Notifications désactivées pour éviter les APIs dépréciées
        // On peut ajouter une indication visuelle dans l'interface plus tard
    }
}

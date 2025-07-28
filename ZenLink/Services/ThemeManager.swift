import SwiftUI
import Foundation

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentAppearance: AppearanceMode = .system {
        didSet {
            // Éviter les boucles infinies en vérifiant si la valeur a vraiment changé
            guard currentAppearance != oldValue else { return }
            isLiquidGlassEnabled = currentAppearance == .liquidGlass
            updateSystemAppearance()
            // Ne pas poster de notification ici pour éviter les cycles
        }
    }
    @Published var isLiquidGlassEnabled: Bool = false
    
    private var isUpdating = false // Flag pour éviter les cycles
    
    private init() {
        // Start with system appearance
        currentAppearance = .system
        isLiquidGlassEnabled = false
        updateSystemAppearance()
        
        // Listen to appearance changes from AppSettings directly
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appearanceChanged),
            name: NSNotification.Name("AppSettingsChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func appearanceChanged() {
        guard !isUpdating else { return }
        isUpdating = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Maintenant nous pouvons sûrement accéder à AppSettings
            let newAppearance = AppSettings.shared.appearanceMode
            if self.currentAppearance != newAppearance {
                self.currentAppearance = newAppearance
                self.isLiquidGlassEnabled = newAppearance == .liquidGlass
            }
            self.isUpdating = false
        }
    }
    
    private func updateSystemAppearance() {
        DispatchQueue.main.async {
            switch self.currentAppearance {
            case .light:
                NSApp.appearance = NSAppearance(named: .aqua)
            case .dark:
                NSApp.appearance = NSAppearance(named: .darkAqua)
            case .liquidGlass:
                // Liquid glass uses light appearance as base per Apple guidelines
                NSApp.appearance = NSAppearance(named: .aqua)
            case .system:
                NSApp.appearance = nil
            }
        }
    }
    
    // Liquid Glass colors and effects with improved styling
    var liquidGlassBackground: Color {
        Color.clear
    }
    
    var liquidGlassOverlay: Color {
        Color.white.opacity(0.15)
    }
    
    var liquidGlassBorder: Color {
        Color.white.opacity(0.25)
    }
    
    var liquidGlassShadow: Color {
        Color.black.opacity(0.15)
    }
    
    // Enhanced gradient colors for liquid glass
    var liquidGlassGradientTop: Color {
        Color.white.opacity(0.3)
    }
    
    var liquidGlassGradientBottom: Color {
        Color.white.opacity(0.08)
    }
    
    // Dynamic colors based on current appearance with improved contrast
    var primaryBackground: Color {
        switch currentAppearance {
        case .liquidGlass:
            return liquidGlassBackground
        case .light:
            return Color(NSColor.windowBackgroundColor)
        case .dark:
            return Color(NSColor.windowBackgroundColor)
        case .system:
            return Color(NSColor.windowBackgroundColor)
        }
    }
    
    var secondaryBackground: Color {
        switch currentAppearance {
        case .liquidGlass:
            return liquidGlassOverlay
        case .light:
            return Color(NSColor.controlBackgroundColor)
        case .dark:
            return Color(NSColor.controlBackgroundColor)
        case .system:
            return Color(NSColor.controlBackgroundColor)
        }
    }
    
    var primaryText: Color {
        switch currentAppearance {
        case .liquidGlass:
            return Color.primary.opacity(0.9)
        case .light:
            return Color(NSColor.labelColor)
        case .dark:
            return Color(NSColor.labelColor)
        case .system:
            return Color(NSColor.labelColor)
        }
    }
    
    var secondaryText: Color {
        switch currentAppearance {
        case .liquidGlass:
            return Color.secondary.opacity(0.8)
        case .light:
            return Color(NSColor.secondaryLabelColor)
        case .dark:
            return Color(NSColor.secondaryLabelColor)
        case .system:
            return Color(NSColor.secondaryLabelColor)
        }
    }
    
    var isDarkMode: Bool {
        switch currentAppearance {
        case .dark:
            return true
        case .light, .liquidGlass:
            return false
        case .system:
            return NSApp.effectiveAppearance.name == .darkAqua
        }
    }
    
    var accentColor: Color {
        switch currentAppearance {
        case .liquidGlass:
            return Color.blue.opacity(0.9)
        case .light:
            return Color.accentColor
        case .dark:
            return Color.accentColor
        case .system:
            return Color.accentColor
        }
    }
}

// Notification extensions
extension Notification.Name {
    static let appearanceModeChanged = Notification.Name("appearanceModeChanged")
    static let languageChanged = Notification.Name("LanguageChanged")
}

// View modifier for enhanced liquid glass effect
struct LiquidGlassEffect: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    let intensity: Double
    
    init(intensity: Double = 1.0) {
        self.intensity = intensity
    }
    
    func body(content: Content) -> some View {
        if themeManager.isLiquidGlassEnabled {
            content
                .background(
                    ZStack {
                        // Primary blur background with enhanced material
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                            .opacity(0.9 * intensity)
                        
                        // Secondary ultra thin material layer
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .opacity(0.7 * intensity)
                        
                        // Enhanced glass overlay with better gradient
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        themeManager.liquidGlassGradientTop.opacity(intensity),
                                        themeManager.liquidGlassGradientBottom.opacity(intensity),
                                        Color.clear,
                                        themeManager.liquidGlassGradientBottom.opacity(0.5 * intensity)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Subtle inner glow
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4 * intensity),
                                        Color.white.opacity(0.1 * intensity),
                                        Color.clear,
                                        Color.white.opacity(0.05 * intensity)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                        
                        // Outer border
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.white.opacity(0.15 * intensity),
                                lineWidth: 0.5
                            )
                    }
                )
                .shadow(
                    color: themeManager.liquidGlassShadow.opacity(0.25 * intensity),
                    radius: 12,
                    x: 0,
                    y: 6
                )
                .shadow(
                    color: themeManager.liquidGlassShadow.opacity(0.1 * intensity),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        } else {
            content
        }
    }
}

extension View {
    func liquidGlass(intensity: Double = 1.0) -> some View {
        modifier(LiquidGlassEffect(intensity: intensity))
    }
    
    // New enhanced liquid glass modifier with animation
    func animatedLiquidGlass(intensity: Double = 1.0) -> some View {
        modifier(AnimatedLiquidGlassEffect(intensity: intensity))
    }
}

// New animated liquid glass effect for special elements
struct AnimatedLiquidGlassEffect: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var shimmerOffset: CGFloat = -200
    let intensity: Double
    
    init(intensity: Double = 1.0) {
        self.intensity = intensity
    }
    
    func body(content: Content) -> some View {
        if themeManager.isLiquidGlassEnabled {
            content
                .background(
                    ZStack {
                        // Base liquid glass effect
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                            .opacity(0.9 * intensity)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .opacity(0.7 * intensity)
                        
                        // Animated shimmer effect
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .animation(
                                Animation.linear(duration: 3.0)
                                    .repeatForever(autoreverses: false),
                                value: shimmerOffset
                            )
                        
                        // Enhanced glass overlay
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        themeManager.liquidGlassGradientTop.opacity(intensity),
                                        themeManager.liquidGlassGradientBottom.opacity(intensity),
                                        Color.clear,
                                        themeManager.liquidGlassGradientBottom.opacity(0.5 * intensity)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Border
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.white.opacity(0.25 * intensity),
                                lineWidth: 1
                            )
                    }
                )
                .shadow(
                    color: themeManager.liquidGlassShadow.opacity(0.3 * intensity),
                    radius: 15,
                    x: 0,
                    y: 8
                )
                .onAppear {
                    shimmerOffset = 200
                }
        } else {
            content
        }
    }
}

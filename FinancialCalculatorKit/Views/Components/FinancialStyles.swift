//
//  FinancialStyles.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI
import LaTeXSwiftUI

/// Enhanced group box style for financial calculator components with improved visual hierarchy
struct FinancialGroupBoxStyle: GroupBoxStyle {
    let variant: Variant
    let isHighlighted: Bool
    
    enum Variant {
        case standard
        case compact
        case emphasis
        case result
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard: return 16
            case .compact: return 12
            case .emphasis: return 18
            case .result: return 20
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .standard: return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            case .compact: return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            case .emphasis: return EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
            case .result: return EdgeInsets(top: 28, leading: 28, bottom: 28, trailing: 28)
            }
        }
    }
    
    init(variant: Variant = .standard, isHighlighted: Bool = false) {
        self.variant = variant
        self.isHighlighted = isHighlighted
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                configuration.label
                    .font(labelFont)
                    .fontWeight(.semibold)
                    .foregroundColor(labelColor)
                
                Spacer()
                
                if isHighlighted || variant == .result {
                    Image(systemName: highlightIcon)
                        .font(.caption)
                        .foregroundColor(accentColor)
                }
            }
            .padding(.horizontal, variant.padding.leading)
            .padding(.top, variant.padding.top)
            .padding(.bottom, 12)
            
            configuration.content
                .padding(.horizontal, variant.padding.leading)
                .padding(.bottom, variant.padding.bottom)
        }
        .background(backgroundView)
        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
    }
    
    private var labelFont: Font {
        switch variant {
        case .standard: return .headline
        case .compact: return .subheadline
        case .emphasis: return .title3
        case .result: return .title2
        }
    }
    
    private var labelColor: Color {
        switch variant {
        case .result: return accentColor
        default: return isHighlighted ? accentColor : .primary
        }
    }
    
    private var accentColor: Color {
        switch variant {
        case .result: return .financialBlue
        default: return .accentColor
        }
    }
    
    private var highlightIcon: String {
        switch variant {
        case .result: return "chart.line.uptrend.xyaxis"
        case .emphasis: return "star.fill"
        default: return "sparkles"
        }
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: variant.cornerRadius)
            .fill(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: variant.cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .result where isHighlighted:
            return Color.financialBlue.opacity(0.04)
        case .emphasis where isHighlighted:
            return Color.accentColor.opacity(0.03)
        default:
            return isHighlighted ? 
                Color.accentColor.opacity(0.02) : 
                Color(NSColor.controlBackgroundColor)
        }
    }
    
    private var borderColor: Color {
        switch variant {
        case .result:
            return Color.financialBlue.opacity(isHighlighted ? 0.3 : 0.2)
        case .emphasis:
            return Color.accentColor.opacity(isHighlighted ? 0.25 : 0.15)
        default:
            return isHighlighted ? 
                Color.accentColor.opacity(0.2) : 
                Color(NSColor.separatorColor).opacity(0.15)
        }
    }
    
    private var borderWidth: CGFloat {
        switch variant {
        case .result: return 2
        case .emphasis: return 1.5
        default: return isHighlighted ? 1.5 : 1
        }
    }
    
    private var shadowColor: Color {
        switch variant {
        case .result:
            return Color.financialBlue.opacity(0.1)
        case .emphasis:
            return isHighlighted ? Color.accentColor.opacity(0.08) : Color.black.opacity(0.03)
        default:
            return isHighlighted ? 
                Color.accentColor.opacity(0.06) : 
                Color.black.opacity(0.02)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch variant {
        case .result: return 12
        case .emphasis: return isHighlighted ? 8 : 6
        default: return isHighlighted ? 6 : 4
        }
    }
    
    private var shadowOffset: CGFloat {
        switch variant {
        case .result: return 6
        case .emphasis: return isHighlighted ? 4 : 3
        default: return isHighlighted ? 3 : 2
        }
    }
}


/// Metric card component for displaying important financial metrics
struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let trend: TrendDirection?
    let trendValue: String?
    let icon: String
    let color: Color
    
    // Convenience initializer for simple usage
    init(title: String, value: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = nil
        self.trend = nil
        self.trendValue = nil
        self.icon = "chart.line.uptrend.xyaxis"
        self.color = color
    }
    
    // Full initializer
    init(title: String, value: String, subtitle: String?, trend: TrendDirection?, trendValue: String?, icon: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.trend = trend
        self.trendValue = trendValue
        self.icon = icon
        self.color = color
    }
    
    enum TrendDirection {
        case up, down, neutral
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "arrow.right"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .financialGreen
            case .down: return .financialRed
            case .neutral: return .secondary
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
                
                if let trend = trend, let trendValue = trendValue {
                    HStack(spacing: 4) {
                        Image(systemName: trend.icon)
                            .font(.caption)
                        Text(trendValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(trend.color)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

/// Formula row component for displaying mathematical formulas with LaTeX
struct FormulaRow: View {
    let title: String
    let formula: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            LaTeX(formula)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

/// Enhanced button style for primary actions with modern design
struct FinancialButtonStyle: ButtonStyle {
    let style: FinancialButtonStyleType
    let size: ButtonSize
    
    enum ButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .system(.caption, weight: .medium)
            case .medium: return .system(.body, weight: .medium)
            case .large: return .system(.title3, weight: .semibold)
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 12
            }
        }
    }
    
    init(style: FinancialButtonStyleType, size: ButtonSize = .medium) {
        self.style = style
        self.size = size
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundColor(foregroundColor(for: style, pressed: configuration.isPressed))
            .padding(size.padding)
            .background(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(backgroundColor(for: style, pressed: configuration.isPressed))
                    .overlay(
                        RoundedRectangle(cornerRadius: size.cornerRadius)
                            .stroke(borderColor(for: style), lineWidth: borderWidth(for: style))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .shadow(
                color: shadowColor(for: style),
                radius: configuration.isPressed ? 2 : 4,
                x: 0,
                y: configuration.isPressed ? 1 : 2
            )
    }
    
    private func backgroundColor(for style: FinancialButtonStyleType, pressed: Bool) -> Color {
        switch style {
        case .primary:
            return pressed ? .accentColor.opacity(0.9) : .accentColor
        case .secondary:
            return pressed ? Color(NSColor.controlBackgroundColor).opacity(0.7) : Color(NSColor.controlBackgroundColor)
        case .destructive:
            return pressed ? .financialRed.opacity(0.9) : .financialRed
        case .success:
            return pressed ? .financialGreen.opacity(0.9) : .financialGreen
        case .warning:
            return pressed ? .financialOrange.opacity(0.9) : .financialOrange
        case .ghost:
            return pressed ? .accentColor.opacity(0.1) : .clear
        }
    }
    
    private func foregroundColor(for style: FinancialButtonStyleType, pressed: Bool) -> Color {
        switch style {
        case .primary, .destructive, .success, .warning:
            return .white
        case .secondary:
            return .primary
        case .ghost:
            return .accentColor
        }
    }
    
    private func borderColor(for style: FinancialButtonStyleType) -> Color {
        switch style {
        case .primary:
            return .accentColor
        case .secondary:
            return Color(NSColor.separatorColor).opacity(0.3)
        case .destructive:
            return .financialRed
        case .success:
            return .financialGreen
        case .warning:
            return .financialOrange
        case .ghost:
            return .accentColor.opacity(0.3)
        }
    }
    
    private func borderWidth(for style: FinancialButtonStyleType) -> CGFloat {
        switch style {
        case .ghost: return 1.5
        case .secondary: return 1
        default: return 0
        }
    }
    
    private func shadowColor(for style: FinancialButtonStyleType) -> Color {
        switch style {
        case .primary: return .accentColor.opacity(0.2)
        case .destructive: return .financialRed.opacity(0.2)
        case .success: return .financialGreen.opacity(0.2)
        case .warning: return .financialOrange.opacity(0.2)
        default: return .black.opacity(0.05)
        }
    }
}

enum FinancialButtonStyleType {
    case primary
    case secondary
    case destructive
    case success
    case warning
    case ghost
}

/// Enhanced card style container for sections with multiple variants
struct FinancialCardStyle: ViewModifier {
    let variant: CardVariant
    let padding: EdgeInsets
    
    enum CardVariant {
        case standard
        case elevated
        case minimal
        case bordered
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard: return 12
            case .elevated: return 16
            case .minimal: return 8
            case .bordered: return 12
            }
        }
        
        var shadowRadius: CGFloat {
            switch self {
            case .standard: return 6
            case .elevated: return 12
            case .minimal: return 2
            case .bordered: return 4
            }
        }
        
        var shadowOffset: CGFloat {
            switch self {
            case .standard: return 3
            case .elevated: return 6
            case .minimal: return 1
            case .bordered: return 2
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .bordered: return 1.5
            default: return 1
            }
        }
    }
    
    init(variant: CardVariant = .standard, padding: EdgeInsets = EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)) {
        self.variant = variant
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: variant.cornerRadius)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: variant.cornerRadius)
                            .stroke(
                                variant == .bordered ? 
                                    Color.accentColor.opacity(0.2) : 
                                    Color(NSColor.separatorColor).opacity(0.3), 
                                lineWidth: variant.borderWidth
                            )
                    )
                    .shadow(
                        color: variant == .elevated ? 
                            Color.black.opacity(0.06) : 
                            Color.black.opacity(0.03), 
                        radius: variant.shadowRadius, 
                        x: 0, 
                        y: variant.shadowOffset
                    )
            )
    }
}

/// Loading state component for async operations
struct LoadingStateView: View {
    let message: String
    let showProgress: Bool
    
    init(message: String = "Loading...", showProgress: Bool = true) {
        self.message = message
        self.showProgress = showProgress
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if showProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(1.2)
            }
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(NSColor.separatorColor).opacity(0.2), lineWidth: 1)
                )
        )
    }
}

/// Empty state component for when no data is available
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(FinancialButtonStyle(style: .primary))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}


extension View {
    func financialCard(variant: FinancialCardStyle.CardVariant = .standard, padding: EdgeInsets = EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)) -> some View {
        modifier(FinancialCardStyle(variant: variant, padding: padding))
    }
}

/// Extension for common financial app colors with enhanced palette
extension Color {
    static let financialGreen = Color(red: 0.16, green: 0.69, blue: 0.27)
    static let financialRed = Color(red: 0.85, green: 0.24, blue: 0.24)
    static let financialBlue = Color(red: 0.20, green: 0.54, blue: 0.84)
    static let financialOrange = Color(red: 0.95, green: 0.61, blue: 0.07)
    static let financialPurple = Color(red: 0.58, green: 0.32, blue: 0.82)
    static let financialTeal = Color(red: 0.18, green: 0.71, blue: 0.66)
    
    // Semantic colors for specific financial contexts
    static let profitGreen = Color(red: 0.13, green: 0.59, blue: 0.24)
    static let lossRed = Color(red: 0.79, green: 0.15, blue: 0.15)
    static let neutralGray = Color(red: 0.55, green: 0.55, blue: 0.58)
    
    // Background variations
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 0.99)
    static let sectionBackground = Color(red: 0.96, green: 0.97, blue: 0.98)
}

/// View modifier for adding consistent spacing and layout
struct FinancialLayoutModifier: ViewModifier {
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    
    init(spacing: CGFloat = 24, alignment: HorizontalAlignment = .leading) {
        self.spacing = spacing
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

extension View {
    func financialLayout(spacing: CGFloat = 24, alignment: HorizontalAlignment = .leading) -> some View {
        modifier(FinancialLayoutModifier(spacing: spacing, alignment: alignment))
    }
}

// MARK: - Enhanced Typography System for Financial Applications

/// Standardized typography scale following Apple Human Interface Guidelines
/// Optimized for financial data display and macOS native feel
extension Font {
    // MARK: - Primary Typography Scale
    
    /// Large display text - For major headings and titles
    /// Usage: Main calculator titles, primary navigation headers
    static let financialTitle = Font.system(.largeTitle, design: .default, weight: .bold)
    
    /// Section and calculator headings
    /// Usage: Calculator type names, section headers
    static let financialHeadline = Font.system(.title2, design: .default, weight: .semibold)
    
    /// Subsection headings and important labels
    /// Usage: Input field labels, metric titles
    static let financialSubheadline = Font.system(.headline, design: .default, weight: .medium)
    
    /// Standard body text and descriptions
    /// Usage: Help text, descriptions, general content
    static let financialBody = Font.system(.body, design: .default, weight: .regular)
    
    /// Secondary text and metadata
    /// Usage: Timestamps, subtitles, helper text
    static let financialCaption = Font.system(.caption, design: .default, weight: .regular)
    
    // MARK: - Specialized Typography for Financial Data
    
    /// Monospaced font for numerical data - Large size
    /// Usage: Primary calculation results, main financial figures
    static let financialNumberLarge = Font.system(.title, design: .monospaced, weight: .semibold)
    
    /// Monospaced font for numerical data - Standard size
    /// Usage: Input fields, tables, standard financial values
    static let financialNumber = Font.system(.body, design: .monospaced, weight: .medium)
    
    /// Monospaced font for numerical data - Small size
    /// Usage: Secondary figures, table data, compact displays
    static let financialNumberSmall = Font.system(.caption, design: .monospaced, weight: .medium)
    
    /// Currency and percentage display - Emphasized
    /// Usage: Final results, highlighted monetary values
    static let financialCurrency = Font.system(.title3, design: .monospaced, weight: .bold)
    
    /// Mathematical formulas and expressions
    /// Usage: Formula displays, equation components
    static let financialFormula = Font.system(.callout, design: .monospaced, weight: .regular)
    
    // MARK: - Interactive Element Typography
    
    /// Button text - Primary actions
    /// Usage: Calculate, Save, primary action buttons
    static let financialButtonPrimary = Font.system(.body, design: .default, weight: .semibold)
    
    /// Button text - Secondary actions
    /// Usage: Clear, Cancel, secondary buttons
    static let financialButtonSecondary = Font.system(.body, design: .default, weight: .medium)
    
    /// Small action buttons and compact controls
    /// Usage: Toolbar buttons, compact actions
    static let financialButtonSmall = Font.system(.caption, design: .default, weight: .medium)
    
    // MARK: - Status and Feedback Typography
    
    /// Error and warning messages
    /// Usage: Validation errors, critical alerts
    static let financialError = Font.system(.caption, design: .default, weight: .medium)
    
    /// Success and confirmation messages
    /// Usage: Calculation success, confirmations
    static let financialSuccess = Font.system(.caption, design: .default, weight: .medium)
    
    /// Loading and status indicators
    /// Usage: Progress indicators, status messages
    static let financialStatus = Font.system(.caption, design: .default, weight: .regular)
}

// MARK: - Responsive Layout System

/// Enhanced responsive layout modifiers for financial applications
extension View {
    /// Apply responsive frame constraints that adapt to window size
    /// - Parameters:
    ///   - minWidth: Minimum width constraint (default: 320)
    ///   - idealWidth: Preferred width (default: 600)
    ///   - maxWidth: Maximum width constraint (default: .infinity)
    ///   - minHeight: Minimum height constraint (default: 400)
    ///   - idealHeight: Preferred height (default: nil)
    ///   - maxHeight: Maximum height constraint (default: .infinity)
    func responsiveFrame(
        minWidth: CGFloat = 320,
        idealWidth: CGFloat = 600,
        maxWidth: CGFloat = .infinity,
        minHeight: CGFloat = 400,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat = .infinity
    ) -> some View {
        if let idealHeight = idealHeight {
            return AnyView(
                frame(
                    minWidth: minWidth,
                    idealWidth: idealWidth,
                    maxWidth: maxWidth,
                    minHeight: minHeight,
                    idealHeight: idealHeight,
                    maxHeight: maxHeight
                )
            )
        } else {
            return AnyView(
                frame(
                    minWidth: minWidth,
                    idealWidth: idealWidth,
                    maxWidth: maxWidth,
                    minHeight: minHeight,
                    maxHeight: maxHeight
                )
            )
        }
    }
    
    /// Apply responsive padding that scales with screen size
    /// - Parameter baseValue: Base padding value that scales proportionally
    func responsivePadding(_ baseValue: CGFloat = 20) -> some View {
        padding(baseValue)
    }
}

// MARK: - Enhanced Hover and Interaction States

/// Advanced hover state modifier for desktop interaction feedback
struct FinancialHoverModifier: ViewModifier {
    @State private var isHovered = false
    let style: HoverStyle
    
    enum HoverStyle {
        case subtle       // Minimal feedback
        case button       // Button-like feedback
        case card         // Card elevation effect
        case interactive  // Enhanced interactive feedback
        
        var scaleEffect: CGFloat {
            switch self {
            case .subtle: return 1.01
            case .button: return 1.02
            case .card: return 1.03
            case .interactive: return 1.05
            }
        }
        
        var shadowRadius: CGFloat {
            switch self {
            case .subtle: return 2
            case .button: return 4
            case .card: return 8
            case .interactive: return 12
            }
        }
        
        var animationDuration: Double {
            switch self {
            case .subtle: return 0.1
            case .button: return 0.15
            case .card: return 0.2
            case .interactive: return 0.25
            }
        }
    }
    
    init(style: HoverStyle = .button) {
        self.style = style
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? style.scaleEffect : 1.0)
            .shadow(
                color: Color.black.opacity(isHovered ? 0.1 : 0.03),
                radius: isHovered ? style.shadowRadius : 2,
                x: 0,
                y: isHovered ? 2 : 1
            )
            .animation(.easeInOut(duration: style.animationDuration), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

extension View {
    /// Add professional hover state feedback
    /// - Parameter style: The type of hover effect to apply
    func financialHover(style: FinancialHoverModifier.HoverStyle = .button) -> some View {
        modifier(FinancialHoverModifier(style: style))
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            // Enhanced GroupBox Examples
            GroupBox("Standard Financial Input") {
                VStack(spacing: 16) {
                    DetailRow(title: "Principal Amount", value: "$100,000.00")
                    DetailRow(title: "Interest Rate", value: "5.50%", isHighlighted: true)
                    DetailRow(title: "Term", value: "30 years")
                    DetailRow(title: "Monthly Payment", value: "$568.23")
                }
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Metric Cards
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetricCard(
                    title: "Total Return",
                    value: "$2,347.50",
                    subtitle: "Past 12 months",
                    trend: .up,
                    trendValue: "+12.3%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .financialGreen
                )
                
                MetricCard(
                    title: "Risk Level",
                    value: "Moderate",
                    subtitle: "Based on portfolio",
                    trend: nil,
                    trendValue: nil,
                    icon: "shield.checkered",
                    color: .financialOrange
                )
                
                MetricCard(
                    title: "Duration",
                    value: "4.2 years",
                    subtitle: "Modified duration",
                    trend: .neutral,
                    trendValue: "0.1",
                    icon: "clock",
                    color: .financialBlue
                )
            }
            
            // Button Examples
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Button("Calculate") { }
                        .buttonStyle(FinancialButtonStyle(style: .primary, size: .large))
                    
                    Button("Save") { }
                        .buttonStyle(FinancialButtonStyle(style: .success))
                    
                    Button("Clear") { }
                        .buttonStyle(FinancialButtonStyle(style: .ghost))
                }
                
                HStack(spacing: 12) {
                    Button("Export") { }
                        .buttonStyle(FinancialButtonStyle(style: .secondary, size: .small))
                    
                    Button("Warning") { }
                        .buttonStyle(FinancialButtonStyle(style: .warning, size: .small))
                    
                    Button("Delete") { }
                        .buttonStyle(FinancialButtonStyle(style: .destructive, size: .small))
                }
            }
            
            // Status Examples
            VStack(spacing: 12) {
                StatusIndicator(.success, message: "Calculation completed successfully")
                StatusIndicator(.warning, message: "Some inputs may be out of typical range")
                StatusIndicator(.error, message: "Unable to process calculation")
                StatusIndicator(.info, message: "Tip: Higher frequency payments reduce total interest")
            }
            
            // Card Examples
            HStack(spacing: 16) {
                VStack {
                    Text("Standard Card")
                        .font(.headline)
                    Text("Default styling with subtle shadow")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .financialCard()
                
                VStack {
                    Text("Elevated Card")
                        .font(.headline)
                    Text("Enhanced with deeper shadow")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .financialCard(variant: .elevated)
            }
            
            // Loading and Empty States
            HStack(spacing: 16) {
                LoadingStateView(message: "Calculating bond prices...")
                    .frame(height: 200)
                
                EmptyStateView(
                    icon: "chart.xyaxis.line",
                    title: "No Data Available",
                    subtitle: "Add some financial data to see results here",
                    actionTitle: "Add Data"
                ) {
                    print("Add data tapped")
                }
                .frame(height: 200)
            }
        }
        .financialLayout()
        .padding()
    }
    .frame(width: 900, height: 1200)
}
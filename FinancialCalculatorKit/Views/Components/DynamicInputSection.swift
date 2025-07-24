//
//  DynamicInputSection.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on Phase 3 implementation.
//

import SwiftUI

/// Dynamic input section that adjusts fields based on calculation type and user selections
struct DynamicInputSection<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    let variant: GroupBoxVariant
    let isExpanded: Bool
    
    @State private var isCollapsed: Bool = false
    
    init(
        title: String,
        subtitle: String? = nil,
        variant: GroupBoxVariant = .standard,
        isExpanded: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.variant = variant
        self.isExpanded = isExpanded
        self.content = content()
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                // Header with collapse button
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { 
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isCollapsed.toggle()
                        }
                    }) {
                        Image(systemName: isCollapsed ? "chevron.down.circle" : "chevron.up.circle")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help(isCollapsed ? "Expand section" : "Collapse section")
                }
                
                // Content with animation
                if !isCollapsed {
                    content
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .scale)
                        ))
                }
            }
            .padding(16)
        }
        .groupBoxStyle(DynamicSectionGroupBoxStyle(variant: variant))
        .animation(.easeInOut(duration: 0.2), value: isCollapsed)
        .onAppear {
            isCollapsed = !isExpanded
        }
    }
}

/// Enhanced group box style with variants for dynamic sections
struct DynamicSectionGroupBoxStyle: GroupBoxStyle {
    let variant: GroupBoxVariant
    let isHighlighted: Bool

    init(variant: GroupBoxVariant = .standard, isHighlighted: Bool = false) {
        self.variant = variant
        self.isHighlighted = isHighlighted
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.content
        }
        .background(backgroundView)
        .overlay(borderView)
        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundColor)
    }
    
    private var borderView: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .standard:
            return Color(NSColor.controlBackgroundColor)
        case .emphasis:
            return Color(NSColor.controlBackgroundColor).opacity(0.95)
        case .accent:
            return Color.accentColor.opacity(0.05)
        case .warning:
            return Color.orange.opacity(0.05)
        case .error:
            return Color.red.opacity(0.05)
        }
    }
    
    private var borderColor: Color {
        if isHighlighted {
            return Color.accentColor
        }
        
        switch variant {
        case .standard:
            return Color(NSColor.separatorColor)
        case .emphasis:
            return Color(NSColor.separatorColor).opacity(0.8)
        case .accent:
            return Color.accentColor.opacity(0.3)
        case .warning:
            return Color.orange.opacity(0.3)
        case .error:
            return Color.red.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        isHighlighted ? 2.0 : 1.0
    }
    
    private var shadowColor: Color {
        switch variant {
        case .standard, .emphasis:
            return .black.opacity(0.05)
        case .accent:
            return Color.accentColor.opacity(0.1)
        case .warning:
            return Color.orange.opacity(0.1)
        case .error:
            return Color.red.opacity(0.1)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch variant {
        case .standard:
            return 4
        case .emphasis, .accent, .warning, .error:
            return 8
        }
    }
    
    private var shadowY: CGFloat {
        switch variant {
        case .standard:
            return 2
        case .emphasis, .accent, .warning, .error:
            return 4
        }
    }
}

enum GroupBoxVariant {
    case standard
    case emphasis
    case accent
    case warning
    case error
}

/// Dynamic field configuration based on calculation parameters
struct DynamicFieldConfiguration {
    let isVisible: Bool
    let isRequired: Bool
    let isDisabled: Bool
    let helpText: String?
    let validation: InputFieldValidationRule?

    init(
        isVisible: Bool = true,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helpText: String? = nil,
        validation: InputFieldValidationRule? = nil
    ) {
        self.isVisible = isVisible
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helpText = helpText
        self.validation = validation
    }
}

/// Enhanced input field with dynamic configuration
struct DynamicInputField: View {
    let title: String
    let subtitle: String?
    @Binding var value: String
    let configuration: DynamicFieldConfiguration
    let keyboardType: KeyboardType
    let placeholder: String
    
    @State private var hasInteracted: Bool = false
    
    var body: some View {
        if configuration.isVisible {
            InputFieldView(
                title: title,
                subtitle: subtitle,
                value: $value,
                placeholder: placeholder,
                keyboardType: keyboardType,
                validation: hasInteracted ? configuration.validation : nil,
                helpText: configuration.helpText,
                isRequired: configuration.isRequired
            )
            .disabled(configuration.isDisabled)
            .opacity(configuration.isDisabled ? 0.6 : 1.0)
            .onChange(of: value) { _, _ in
                hasInteracted = true
            }
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .top)),
                removal: .opacity.combined(with: .scale)
            ))
        }
    }
}

/// Enhanced currency input with dynamic configuration
struct DynamicCurrencyField: View {
    let title: String
    let subtitle: String?
    @Binding var value: Double?
    let currency: Currency
    let configuration: DynamicFieldConfiguration
    
    var body: some View {
        if configuration.isVisible {
            CurrencyInputField(
                title: title,
                subtitle: subtitle,
                value: $value,
                currency: currency,
                isRequired: configuration.isRequired,
                helpText: configuration.helpText
            )
            .disabled(configuration.isDisabled)
            .opacity(configuration.isDisabled ? 0.6 : 1.0)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .top)),
                removal: .opacity.combined(with: .scale)
            ))
        }
    }
}

/// Enhanced percentage input with dynamic configuration
struct DynamicPercentageField: View {
    let title: String
    let subtitle: String?
    @Binding var value: Double?
    let configuration: DynamicFieldConfiguration
    
    var body: some View {
        if configuration.isVisible {
            PercentageInputField(
                title: title,
                subtitle: subtitle,
                value: $value,
                isRequired: configuration.isRequired,
                helpText: configuration.helpText
            )
            .disabled(configuration.isDisabled)
            .opacity(configuration.isDisabled ? 0.6 : 1.0)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .top)),
                removal: .opacity.combined(with: .scale)
            ))
        }
    }
}

/// Conditional section that shows/hides based on a condition
struct ConditionalSection<Content: View>: View {
    let condition: Bool
    let content: Content
    
    init(
        condition: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.condition = condition
        self.content = content()
    }
    
    var body: some View {
        if condition {
            content
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .leading)),
                    removal: .opacity.combined(with: .move(edge: .trailing))
                ))
        }
    }
}

/// Multi-selection picker for dynamic options
struct DynamicMultiPicker<Option: Hashable & Identifiable>: View {
    let title: String
    let options: [Option]
    @Binding var selectedOptions: Set<Option.ID>
    let displayName: (Option) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(options) { option in
                    HStack {
                        Toggle(isOn: Binding(
                            get: { selectedOptions.contains(option.id) },
                            set: { isSelected in
                                if isSelected {
                                    selectedOptions.insert(option.id)
                                } else {
                                    selectedOptions.remove(option.id)
                                }
                            }
                        )) {
                            Text(displayName(option))
                                .font(.body)
                        }
                        .toggleStyle(.checkbox)
                        
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding(.leading, 4)
        }
    }
}

/// Stepper field with dynamic configuration
struct DynamicStepperField: View {
    let title: String
    let subtitle: String?
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let configuration: DynamicFieldConfiguration
    
    var body: some View {
        if configuration.isVisible {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let helpText = configuration.helpText {
                        Button(action: {}) {
                            Image(systemName: "questionmark.circle")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help(helpText)
                    }
                }
                
                Stepper(value: $value, in: range, step: step) {
                    HStack {
                        Text("\(value)")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
                .disabled(configuration.isDisabled)
            }
            .opacity(configuration.isDisabled ? 0.6 : 1.0)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .top)),
                removal: .opacity.combined(with: .scale)
            ))
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            DynamicInputSection(
                title: "Investment Parameters",
                subtitle: "Configure your investment details"
            ) {
                VStack(spacing: 16) {
                    DynamicCurrencyField(
                        title: "Initial Investment",
                        subtitle: "Starting amount",
                        value: .constant(100000),
                        currency: .usd,
                        configuration: DynamicFieldConfiguration(isRequired: true)
                    )
                    
                    DynamicPercentageField(
                        title: "Annual Return",
                        subtitle: "Expected yearly return",
                        value: .constant(8.5),
                        configuration: DynamicFieldConfiguration(isRequired: true)
                    )
                    
                    DynamicStepperField(
                        title: "Investment Period",
                        subtitle: "Years to invest",
                        value: .constant(10),
                        range: 1...50,
                        step: 1,
                        configuration: DynamicFieldConfiguration()
                    )
                }
            }
            
            ConditionalSection(condition: true) {
                DynamicInputSection(
                    title: "Advanced Options",
                    variant: .accent,
                    isExpanded: false
                ) {
                    Text("Advanced configuration options here")
                        .padding()
                }
            }
        }
        .padding()
    }
    .frame(width: 500)
}
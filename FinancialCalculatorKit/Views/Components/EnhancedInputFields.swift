//
//  EnhancedInputFields.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Enhanced input fields with comprehensive validation, formatting, and accessibility
//

import SwiftUI
import Combine

// MARK: - Enhanced Currency Input Field

/// Advanced currency input field with real-time validation, formatting, and accessibility
public struct EnhancedCurrencyInputField: View {
    // Properties
    let title: String
    let subtitle: String?
    @Binding var value: Double
    let currency: Currency
    let placeholder: String
    let isRequired: Bool
    let helpText: String?
    let maxValue: Double?
    let minValue: Double?
    let allowsNegative: Bool
    let validationRules: [ValidationRule]
    let onValidation: ((ValidationResult) -> Void)?
    let accessibilityLabel: String?
    let accessibilityHint: String?
    
    // State
    @State private var stringValue: String = ""
    @State private var isEditing: Bool = false
    @State private var validationResult: ValidationResult?
    @State private var showingHelpPopover: Bool = false
    @FocusState private var isFocused: Bool
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorScheme) private var colorScheme
    
    // Validation publisher
    private let validationDebouncer = PassthroughSubject<String, Never>()
    
    public init(
        title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        currency: Currency = .usd,
        placeholder: String = "0.00",
        isRequired: Bool = false,
        helpText: String? = nil,
        maxValue: Double? = nil,
        minValue: Double? = 0,
        allowsNegative: Bool = false,
        validationRules: [ValidationRule] = [],
        onValidation: ((ValidationResult) -> Void)? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.currency = currency
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.helpText = helpText
        self.maxValue = maxValue
        self.minValue = minValue
        self.allowsNegative = allowsNegative
        self.validationRules = validationRules
        self.onValidation = onValidation
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        
        // Initialize string value with proper formatting
        let formatter = Formatters.currencyFormatter(for: currency)
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = currency.decimalPlaces
        formatter.minimumFractionDigits = 0
        self._stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue)) ?? "")
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: adaptiveSpacing) {
            // Header section
            headerView
            
            // Input field
            inputFieldView
            
            // Validation feedback
            if let result = validationResult, !result.isValid {
                validationFeedbackView(result: result)
            }
            
            // Help text (always visible if provided)
            if let helpText = helpText, !showingHelpPopover {
                Text(helpText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: validationResult)
        .onReceive(
            validationDebouncer
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        ) { value in
            performAsyncValidation(value)
        }
        .onChange(of: value) { _, newValue in
            // Update string representation when value changes externally
            if !isEditing {
                updateStringFromValue(newValue)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 4) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(title)
                        .font(dynamicFont(.headline))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if isRequired {
                        Text("*")
                            .foregroundColor(.red)
                            .font(dynamicFont(.headline))
                            .accessibilityLabel("Required field")
                    }
                }
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(dynamicFont(.caption))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
            
            if helpText != nil {
                Button(action: { showingHelpPopover.toggle() }) {
                    Image(systemName: "questionmark.circle")
                        .font(dynamicFont(.callout))
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Show help")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showingHelpPopover) {
                    helpPopoverContent
                }
            }
        }
    }
    
    private var inputFieldView: some View {
        HStack(spacing: 8) {
            // Currency symbol
            Text(currency.symbol)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(isEditing ? .accentColor : .secondary)
                .frame(minWidth: 20)
                .accessibilityHidden(true)
            
            // Text field
            TextField(placeholder, text: $stringValue)
                .textFieldStyle(FinancialTextFieldStyle(
                    isEditing: isEditing,
                    hasError: validationResult?.isValid == false,
                    isFocused: isFocused
                ))
                .focused($isFocused)
                .font(.system(.body, design: .monospaced))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .accessibilityLabel(accessibilityLabel ?? "\(title) input field")
                .accessibilityHint(accessibilityHint ?? "Enter \(title) in \(currency.name)")
                .accessibilityValue(stringValue.isEmpty ? "Empty" : "\(currency.symbol)\(stringValue)")
                .onSubmit {
                    validateAndFormat()
                }
                .onChange(of: stringValue) { _, newValue in
                    handleTextChange(newValue)
                }
                .onChange(of: isFocused) { _, focused in
                    handleFocusChange(focused)
                }
                .currencyOnly(
                    text: $stringValue,
                    maxValue: maxValue,
                    minValue: minValue,
                    allowsNegative: allowsNegative
                )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(fieldBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(fieldBorderColor, lineWidth: fieldBorderWidth)
                )
        )
    }
    
    private func validationFeedbackView(result: ValidationResult) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Error message
            HStack(spacing: 6) {
                Image(systemName: iconForValidationResult(result))
                    .font(.caption)
                    .foregroundColor(colorForValidationResult(result))
                
                Text(result.errorMessage ?? "Invalid value")
                    .font(dynamicFont(.caption))
                    .foregroundColor(colorForValidationResult(result))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Validation error: \(result.errorMessage ?? "Invalid value")")
            
            // Suggested value if available
            if let suggestedValue = result.suggestedValue {
                Button(action: { applySuggestedValue(suggestedValue) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption2)
                        Text("Use suggested: \(currency.formatValue(suggestedValue))")
                            .font(.caption)
                    }
                    .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .opacity
        ))
    }
    
    private var helpPopoverContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(.accentColor)
            
            if let helpText = helpText {
                Text(helpText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if minValue != nil || maxValue != nil {
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Valid Range:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    if let min = minValue, let max = maxValue {
                        Text("\(currency.formatValue(min)) to \(currency.formatValue(max))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if let min = minValue {
                        Text("Minimum: \(currency.formatValue(min))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if let max = maxValue {
                        Text("Maximum: \(currency.formatValue(max))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    // MARK: - Helper Methods
    
    private var adaptiveSpacing: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small: return 4
        case .medium, .large: return 6
        case .xLarge, .xxLarge: return 8
        case .xxxLarge: return 10
        default: return 12
        }
    }
    
    private func dynamicFont(_ style: Font.TextStyle) -> Font {
        return .system(style, design: .default)
    }
    
    private var fieldBackgroundColor: Color {
        if isEditing {
            return Color(NSColor.controlBackgroundColor)
        } else if validationResult?.isValid == false {
            return Color.red.opacity(0.05)
        } else {
            return Color(NSColor.controlBackgroundColor).opacity(0.5)
        }
    }
    
    private var fieldBorderColor: Color {
        if validationResult?.isValid == false {
            return .red
        } else if isEditing {
            return .accentColor
        } else {
            return Color(NSColor.separatorColor)
        }
    }
    
    private var fieldBorderWidth: CGFloat {
        return isEditing || validationResult?.isValid == false ? 2 : 1
    }
    
    private func handleTextChange(_ newValue: String) {
        isEditing = true
        
        // Extract numeric value
        let cleanedValue = newValue.replacingOccurrences(of: ",", with: "")
        if let doubleValue = Double(cleanedValue) {
            value = doubleValue
        }
        
        // Trigger debounced validation
        validationDebouncer.send(newValue)
    }
    
    private func handleFocusChange(_ focused: Bool) {
        isEditing = focused
        if !focused {
            validateAndFormat()
        }
    }
    
    private func validateAndFormat() {
        // Perform immediate validation
        let cleanedValue = stringValue.replacingOccurrences(of: ",", with: "")
        
        guard !cleanedValue.isEmpty else {
            if isRequired {
                validationResult = ValidationResult(
                    isValid: false,
                    errorType: .required,
                    errorMessage: "This field is required"
                )
            } else {
                validationResult = nil
                value = 0
            }
            return
        }
        
        guard let doubleValue = Double(cleanedValue) else {
            validationResult = ValidationResult(
                isValid: false,
                errorType: .invalidFormat,
                errorMessage: "Please enter a valid number"
            )
            return
        }
        
        // Use FinancialValidation for comprehensive validation
        let context = ValidationContext(
            calculationType: .general,
            fieldName: title,
            currency: currency
        )
        
        let result = FinancialValidation.shared.validateCurrencyAmount(
            doubleValue,
            minValue: minValue,
            maxValue: maxValue,
            allowNegative: allowsNegative,
            currency: currency,
            context: context
        )
        
        validationResult = result
        
        if result.isValid {
            // Format the display value
            let formatter = Formatters.currencyFormatter(for: currency)
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = currency.decimalPlaces
            formatter.minimumFractionDigits = 0
            
            stringValue = formatter.string(from: NSNumber(value: doubleValue)) ?? String(doubleValue)
            value = doubleValue
        }
        
        // Run custom validation rules
        for rule in validationRules {
            if let error = rule.validate(doubleValue) {
                validationResult = ValidationResult(
                    isValid: false,
                    errorType: .businessRule,
                    errorMessage: error
                )
                break
            }
        }
        
        // Notify validation handler
        if let result = validationResult {
            onValidation?(result)
        }
    }
    
    private func performAsyncValidation(_ value: String) {
        // This method can be extended for async validation
        // For now, it performs the same validation as validateAndFormat
        if !isEditing {
            validateAndFormat()
        }
    }
    
    private func updateStringFromValue(_ newValue: Double) {
        let formatter = Formatters.currencyFormatter(for: currency)
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = currency.decimalPlaces
        formatter.minimumFractionDigits = 0
        
        stringValue = formatter.string(from: NSNumber(value: newValue)) ?? String(newValue)
    }
    
    private func applySuggestedValue(_ suggestedValue: Double) {
        value = suggestedValue
        updateStringFromValue(suggestedValue)
        validateAndFormat()
    }
    
    private func iconForValidationResult(_ result: ValidationResult) -> String {
        guard let errorType = result.errorType else { return "checkmark.circle.fill" }
        
        switch errorType {
        case .required: return "exclamationmark.circle.fill"
        case .outOfRange: return "exclamationmark.triangle.fill"
        case .invalidFormat: return "xmark.circle.fill"
        case .overflow, .underflow: return "arrow.up.arrow.down.circle.fill"
        default: return "exclamationmark.circle.fill"
        }
    }
    
    private func colorForValidationResult(_ result: ValidationResult) -> Color {
        return result.isValid ? .green : .red
    }
}

// MARK: - Enhanced Percentage Input Field

/// Advanced percentage input field with real-time validation and formatting
public struct EnhancedPercentageInputField: View {
    // Properties
    let title: String
    let subtitle: String?
    @Binding var value: Double
    let placeholder: String
    let isRequired: Bool
    let helpText: String?
    let maxValue: Double
    let minValue: Double
    let allowsNegative: Bool
    let decimalPlaces: Int
    let validationRules: [ValidationRule]
    let onValidation: ((ValidationResult) -> Void)?
    let accessibilityLabel: String?
    let accessibilityHint: String?
    
    // State
    @State private var stringValue: String = ""
    @State private var isEditing: Bool = false
    @State private var validationResult: ValidationResult?
    @State private var showingHelpPopover: Bool = false
    @FocusState private var isFocused: Bool
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorScheme) private var colorScheme
    
    // Validation publisher
    private let validationDebouncer = PassthroughSubject<String, Never>()
    
    public init(
        title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        placeholder: String = "0.00",
        isRequired: Bool = false,
        helpText: String? = nil,
        maxValue: Double = 100,
        minValue: Double = 0,
        allowsNegative: Bool = false,
        decimalPlaces: Int = 3,
        validationRules: [ValidationRule] = [],
        onValidation: ((ValidationResult) -> Void)? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.helpText = helpText
        self.maxValue = maxValue
        self.minValue = minValue
        self.allowsNegative = allowsNegative
        self.decimalPlaces = decimalPlaces
        self.validationRules = validationRules
        self.onValidation = onValidation
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        
        // Initialize string value
        let formatter = Formatters.percentageFormatter(decimalPlaces: decimalPlaces)
        self._stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue / 100)) ?? "")
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: adaptiveSpacing) {
            // Header section
            headerView
            
            // Input field
            inputFieldView
            
            // Validation feedback
            if let result = validationResult, !result.isValid {
                validationFeedbackView(result: result)
            }
            
            // Help text
            if let helpText = helpText, !showingHelpPopover {
                Text(helpText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: validationResult)
        .onReceive(
            validationDebouncer
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        ) { value in
            performAsyncValidation(value)
        }
        .onChange(of: value) { _, newValue in
            if !isEditing {
                updateStringFromValue(newValue)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 4) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(title)
                        .font(dynamicFont(.headline))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if isRequired {
                        Text("*")
                            .foregroundColor(.red)
                            .font(dynamicFont(.headline))
                            .accessibilityLabel("Required field")
                    }
                }
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(dynamicFont(.caption))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
            
            if helpText != nil {
                Button(action: { showingHelpPopover.toggle() }) {
                    Image(systemName: "questionmark.circle")
                        .font(dynamicFont(.callout))
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Show help")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showingHelpPopover) {
                    helpPopoverContent
                }
            }
        }
    }
    
    private var inputFieldView: some View {
        HStack(spacing: 8) {
            // Text field
            TextField(placeholder, text: $stringValue)
                .textFieldStyle(FinancialTextFieldStyle(
                    isEditing: isEditing,
                    hasError: validationResult?.isValid == false,
                    isFocused: isFocused
                ))
                .focused($isFocused)
                .font(.system(.body, design: .monospaced))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .accessibilityLabel(accessibilityLabel ?? "\(title) input field")
                .accessibilityHint(accessibilityHint ?? "Enter \(title) as a percentage")
                .accessibilityValue(stringValue.isEmpty ? "Empty" : "\(stringValue) percent")
                .onSubmit {
                    validateAndFormat()
                }
                .onChange(of: stringValue) { _, newValue in
                    handleTextChange(newValue)
                }
                .onChange(of: isFocused) { _, focused in
                    handleFocusChange(focused)
                }
                .percentageOnly(
                    text: $stringValue,
                    maxValue: maxValue,
                    minValue: minValue,
                    allowsNegative: allowsNegative
                )
            
            // Percentage symbol
            Text("%")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(isEditing ? .accentColor : .secondary)
                .frame(minWidth: 15)
                .accessibilityHidden(true)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(fieldBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(fieldBorderColor, lineWidth: fieldBorderWidth)
                )
        )
    }
    
    private func validationFeedbackView(result: ValidationResult) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: iconForValidationResult(result))
                    .font(.caption)
                    .foregroundColor(colorForValidationResult(result))
                
                Text(result.errorMessage ?? "Invalid value")
                    .font(dynamicFont(.caption))
                    .foregroundColor(colorForValidationResult(result))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Validation error: \(result.errorMessage ?? "Invalid value")")
            
            if let suggestedValue = result.suggestedValue {
                Button(action: { applySuggestedValue(suggestedValue) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption2)
                        Text("Use suggested: \(formatPercentage(suggestedValue))")
                            .font(.caption)
                    }
                    .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .opacity
        ))
    }
    
    private var helpPopoverContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: "percent")
                .font(.headline)
                .foregroundColor(.accentColor)
            
            if let helpText = helpText {
                Text(helpText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Valid Range:")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("\(formatPercentage(minValue)) to \(formatPercentage(maxValue))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    // MARK: - Helper Methods
    
    private var adaptiveSpacing: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small: return 4
        case .medium, .large: return 6
        case .xLarge, .xxLarge: return 8
        case .xxxLarge: return 10
        default: return 12
        }
    }
    
    private func dynamicFont(_ style: Font.TextStyle) -> Font {
        return .system(style, design: .default)
    }
    
    private var fieldBackgroundColor: Color {
        if isEditing {
            return Color(NSColor.controlBackgroundColor)
        } else if validationResult?.isValid == false {
            return Color.red.opacity(0.05)
        } else {
            return Color(NSColor.controlBackgroundColor).opacity(0.5)
        }
    }
    
    private var fieldBorderColor: Color {
        if validationResult?.isValid == false {
            return .red
        } else if isEditing {
            return .accentColor
        } else {
            return Color(NSColor.separatorColor)
        }
    }
    
    private var fieldBorderWidth: CGFloat {
        return isEditing || validationResult?.isValid == false ? 2 : 1
    }
    
    private func handleTextChange(_ newValue: String) {
        isEditing = true
        
        // Extract numeric value (remove % sign if present)
        let cleanedValue = newValue.replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: ",", with: "")
        
        if let doubleValue = Double(cleanedValue) {
            value = doubleValue
        }
        
        // Trigger debounced validation
        validationDebouncer.send(newValue)
    }
    
    private func handleFocusChange(_ focused: Bool) {
        isEditing = focused
        if !focused {
            validateAndFormat()
        }
    }
    
    private func validateAndFormat() {
        let cleanedValue = stringValue.replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: ",", with: "")
        
        guard !cleanedValue.isEmpty else {
            if isRequired {
                validationResult = ValidationResult(
                    isValid: false,
                    errorType: .required,
                    errorMessage: "This field is required"
                )
            } else {
                validationResult = nil
                value = 0
            }
            return
        }
        
        guard let doubleValue = Double(cleanedValue) else {
            validationResult = ValidationResult(
                isValid: false,
                errorType: .invalidFormat,
                errorMessage: "Please enter a valid percentage"
            )
            return
        }
        
        // Validate bounds
        if doubleValue < minValue {
            validationResult = ValidationResult(
                isValid: false,
                errorType: .outOfRange,
                errorMessage: "Must be at least \(formatPercentage(minValue))",
                suggestedValue: minValue
            )
            return
        }
        
        if doubleValue > maxValue {
            validationResult = ValidationResult(
                isValid: false,
                errorType: .outOfRange,
                errorMessage: "Must be at most \(formatPercentage(maxValue))",
                suggestedValue: maxValue
            )
            return
        }
        
        // Run custom validation rules
        for rule in validationRules {
            if let error = rule.validate(doubleValue) {
                validationResult = ValidationResult(
                    isValid: false,
                    errorType: .businessRule,
                    errorMessage: error
                )
                return
            }
        }
        
        // Format the display value
        stringValue = String(format: "%.*f", decimalPlaces, doubleValue)
        value = doubleValue
        validationResult = ValidationResult.valid()
        
        // Notify validation handler
        if let result = validationResult {
            onValidation?(result)
        }
    }
    
    private func performAsyncValidation(_ value: String) {
        if !isEditing {
            validateAndFormat()
        }
    }
    
    private func updateStringFromValue(_ newValue: Double) {
        stringValue = String(format: "%.*f", decimalPlaces, newValue)
    }
    
    private func applySuggestedValue(_ suggestedValue: Double) {
        value = suggestedValue
        updateStringFromValue(suggestedValue)
        validateAndFormat()
    }
    
    private func formatPercentage(_ value: Double) -> String {
        return String(format: "%.*f%%", decimalPlaces, value)
    }
    
    private func iconForValidationResult(_ result: ValidationResult) -> String {
        guard let errorType = result.errorType else { return "checkmark.circle.fill" }
        
        switch errorType {
        case .required: return "exclamationmark.circle.fill"
        case .outOfRange: return "exclamationmark.triangle.fill"
        case .invalidFormat: return "xmark.circle.fill"
        default: return "exclamationmark.circle.fill"
        }
    }
    
    private func colorForValidationResult(_ result: ValidationResult) -> Color {
        return result.isValid ? .green : .red
    }
}

// MARK: - Validation Rule Protocol

/// Protocol for custom validation rules
public protocol ValidationRule {
    func validate(_ value: Double) -> String?
}

/// Standard validation rules
public struct MinValueRule: ValidationRule {
    let minValue: Double
    let message: String?
    
    public init(minValue: Double, message: String? = nil) {
        self.minValue = minValue
        self.message = message
    }
    
    public func validate(_ value: Double) -> String? {
        if value < minValue {
            return message ?? "Value must be at least \(minValue)"
        }
        return nil
    }
}

public struct MaxValueRule: ValidationRule {
    let maxValue: Double
    let message: String?
    
    public init(maxValue: Double, message: String? = nil) {
        self.maxValue = maxValue
        self.message = message
    }
    
    public func validate(_ value: Double) -> String? {
        if value > maxValue {
            return message ?? "Value must be at most \(maxValue)"
        }
        return nil
    }
}

public struct RangeRule: ValidationRule {
    let range: ClosedRange<Double>
    let message: String?
    
    public init(range: ClosedRange<Double>, message: String? = nil) {
        self.range = range
        self.message = message
    }
    
    public func validate(_ value: Double) -> String? {
        if !range.contains(value) {
            return message ?? "Value must be between \(range.lowerBound) and \(range.upperBound)"
        }
        return nil
    }
}

// MARK: - Enhanced Integer Input Field

/// Advanced integer input field with real-time validation
public struct EnhancedIntegerInputField: View {
    let title: String
    let subtitle: String?
    @Binding var value: Int
    let placeholder: String
    let isRequired: Bool
    let helpText: String?
    let maxValue: Int?
    let minValue: Int?
    let allowsNegative: Bool

    @State private var stringValue: String = ""
    @State private var isEditing: Bool = false
    @State private var validationError: String?
    @FocusState private var isFocused: Bool

    public init(
        title: String,
        subtitle: String? = nil,
        value: Binding<Int>,
        placeholder: String = "0",
        isRequired: Bool = false,
        helpText: String? = nil,
        maxValue: Int? = nil,
        minValue: Int? = 0,
        allowsNegative: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.helpText = helpText
        self.maxValue = maxValue
        self.minValue = minValue
        self.allowsNegative = allowsNegative

        // Initialize string value
        let formatter = Formatters.integerFormatter
        self._stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue)) ?? String(value.wrappedValue))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Title and help button
            HStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.medium)

                        if isRequired {
                            Text("*")
                                .foregroundColor(.red)
                                .font(.headline)
                        }
                    }

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if let helpText = helpText {
                    Button(action: {}) {
                        Image(systemName: "questionmark.circle")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help(helpText)
                }
            }

            // Integer input field
            TextField(placeholder, text: $stringValue)
                .textFieldStyle(FinancialTextFieldStyle(
                    isEditing: isEditing,
                    hasError: validationError != nil,
                    isFocused: isFocused
                ))
                .focused($isFocused)
                .integerOnly(
                    text: $stringValue,
                    maxValue: maxValue != nil ? Double(maxValue!) : nil,
                    minValue: minValue != nil ? Double(minValue!) : nil,
                    allowsNegative: allowsNegative
                )
                .onSubmit {
                    validateAndFormat()
                }
                .onChange(of: stringValue) { _, newValue in
                    updateValueFromString(newValue)
                }
                .onChange(of: isFocused) { _, focused in
                    isEditing = focused
                    if !focused {
                        validateAndFormat()
                    }
                }

            // Error message
            if let error = validationError {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundColor(.red)

                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: validationError)
    }

    private func updateValueFromString(_ stringValue: String) {
        let cleanedValue = stringValue.replacingOccurrences(of: ",", with: "")
        if let intValue = Int(cleanedValue) {
            value = intValue
        }
    }

    private func validateAndFormat() {
        let cleanedValue = stringValue.replacingOccurrences(of: ",", with: "")

        if let intValue = Int(cleanedValue) {
            // Validate bounds
            if let minValue = minValue, intValue < minValue {
                validationError = "Value must be at least \(minValue)"
                return
            }

            if let maxValue = maxValue, intValue > maxValue {
                validationError = "Value must be at most \(maxValue)"
                return
            }

            // Format the display value
            let formatter = Formatters.integerFormatter
            stringValue = formatter.string(from: NSNumber(value: intValue)) ?? String(intValue)
            value = intValue
            validationError = nil
        } else if !stringValue.isEmpty {
            validationError = "Please enter a valid integer"
        } else {
            validationError = isRequired ? "This field is required" : nil
        }
    }
}

// MARK: - Supporting Types

/// Validation result type alias for compatibility
public typealias ValidationResult = FinancialValidation.ValidationResult
public typealias ValidationContext = FinancialValidation.ValidationContext

// MARK: - Preview Provider

#if DEBUG
struct EnhancedInputFields_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            EnhancedCurrencyInputField(
                title: "Principal Amount",
                subtitle: "Initial investment",
                value: .constant(10000),
                currency: .usd,
                isRequired: true,
                helpText: "Enter the initial amount you want to invest",
                maxValue: 1_000_000,
                minValue: 100,
                validationRules: [
                    MinValueRule(minValue: 1000, message: "Minimum investment is $1,000")
                ]
            )
            
            EnhancedPercentageInputField(
                title: "Interest Rate",
                subtitle: "Annual percentage rate",
                value: .constant(5.25),
                isRequired: true,
                helpText: "Enter the annual interest rate",
                maxValue: 50,
                minValue: 0,
                decimalPlaces: 3
            )
        }
        .padding()
        .frame(width: 400)
    }
}
#endif
//
//  NumbersOnlyViewModifier.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//

import SwiftUI
import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// A comprehensive view modifier that enforces numeric input validation with locale-aware formatting
struct NumbersOnlyViewModifier: ViewModifier {
    @Binding var text: String
    let inputType: NumericInputType
    let maxValue: Double?
    let minValue: Double?
    let maxDecimalPlaces: Int
    let allowsNegative: Bool
    let locale: Locale
    
    @State private var lastValidValue: String = ""
    @State private var isProcessing = false
    
    enum NumericInputType {
        case integer
        case decimal
        case currency
        case percentage
        
        var allowsDecimal: Bool {
            switch self {
            case .integer: return false
            case .decimal, .currency, .percentage: return true
            }
        }
        
        var defaultMaxDecimalPlaces: Int {
            switch self {
            case .integer: return 0
            case .decimal: return 6
            case .currency: return 2
            case .percentage: return 3
            }
        }
    }
    
    init(
        text: Binding<String>,
        inputType: NumericInputType = .decimal,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        maxDecimalPlaces: Int? = nil,
        allowsNegative: Bool = false,
        locale: Locale = Locale.current
    ) {
        self._text = text
        self.inputType = inputType
        self.maxValue = maxValue
        self.minValue = minValue
        self.maxDecimalPlaces = maxDecimalPlaces ?? inputType.defaultMaxDecimalPlaces
        self.allowsNegative = allowsNegative
        self.locale = locale
    }
    
    func body(content: Content) -> some View {
        #if canImport(UIKit)
        let modifiedContent = content.keyboardType(keyboardType)
        #else
        let modifiedContent = content
        #endif
        
        return modifiedContent
            .onChange(of: text) { oldValue, newValue in
                guard !isProcessing else { return }
                
                let filteredValue = filterAndValidateInput(newValue, previousValue: oldValue)
                
                if filteredValue != newValue {
                    isProcessing = true
                    // Update synchronously to avoid timing issues
                    text = filteredValue
                    isProcessing = false
                }
            }
            .onAppear {
                // Set initial valid value
                lastValidValue = text
            }
    }
    
    #if canImport(UIKit)
    private var keyboardType: UIKeyboardType {
        switch inputType {
        case .integer:
            return allowsNegative ? .numberPad : .numberPad
        case .decimal, .currency, .percentage:
            return .decimalPad
        }
    }
    #endif
    
    private func filterAndValidateInput(_ newValue: String, previousValue: String) -> String {
        // Handle empty input
        if newValue.isEmpty {
            lastValidValue = ""
            return ""
        }
        
        // Get locale-specific decimal separator
        let decimalSeparator = locale.decimalSeparator ?? "."
        let groupingSeparator = locale.groupingSeparator ?? ","
        
        // First, clean the input by removing invalid characters
        let cleanedValue = cleanInput(newValue, decimalSeparator: decimalSeparator, groupingSeparator: groupingSeparator)
        
        // Validate the cleaned value
        if let validatedValue = validateValue(cleanedValue, decimalSeparator: decimalSeparator) {
            lastValidValue = validatedValue
            return validatedValue
        } else {
            // If validation fails, revert to last valid value
            return lastValidValue
        }
    }
    
    private func cleanInput(_ input: String, decimalSeparator: String, groupingSeparator: String) -> String {
        var cleaned = ""
        var hasDecimalSeparator = false
        var decimalPlaces = 0
        
        for char in input {
            let charString = String(char)
            
            if char.isNumber {
                // Allow numbers
                if hasDecimalSeparator {
                    if decimalPlaces < maxDecimalPlaces {
                        cleaned.append(char)
                        decimalPlaces += 1
                    }
                } else {
                    cleaned.append(char)
                }
            } else if charString == decimalSeparator && inputType.allowsDecimal && !hasDecimalSeparator {
                // Allow one decimal separator
                cleaned.append(char)
                hasDecimalSeparator = true
            } else if charString == groupingSeparator && inputType != .percentage {
                // Allow grouping separators (but not in percentage mode)
                // We'll handle proper placement separately
                continue
            } else if (charString == "-" || charString == "−") && allowsNegative && cleaned.isEmpty {
                // Allow negative sign at the beginning
                cleaned.append("-")
            } else if charString == "%" && inputType == .percentage && !cleaned.contains("%") {
                // Allow percentage sign for percentage input
                cleaned.append("%")
            }
        }
        
        return cleaned
    }
    
    private func validateValue(_ value: String, decimalSeparator: String) -> String? {
        guard !value.isEmpty else { return "" }
        
        // Remove percentage sign for validation
        let valueWithoutPercent = value.replacingOccurrences(of: "%", with: "")
        
        // Convert to Double for validation
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .decimal
        
        guard let number = numberFormatter.number(from: valueWithoutPercent)?.doubleValue else {
            return nil
        }
        
        // Check bounds
        if let minValue = minValue, number < minValue {
            return formatValue(minValue, decimalSeparator: decimalSeparator)
        }
        
        if let maxValue = maxValue, number > maxValue {
            return formatValue(maxValue, decimalSeparator: decimalSeparator)
        }
        
        // Apply percentage constraints
        if inputType == .percentage {
            if number < 0 && !allowsNegative {
                return "0%"
            }
            if number > 100 {
                return "100%"
            }
        }
        
        return value
    }
    
    private func formatValue(_ value: Double, decimalSeparator: String) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxDecimalPlaces
        formatter.minimumFractionDigits = 0
        
        let formattedValue = formatter.string(from: NSNumber(value: value)) ?? String(value)
        
        if inputType == .percentage {
            return formattedValue + "%"
        }
        
        return formattedValue
    }
}

// MARK: - Convenience Extensions

extension View {
    /// Apply numbers-only input validation with default decimal behavior
    func numbersOnly(
        text: Binding<String>,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        maxDecimalPlaces: Int = 6,
        allowsNegative: Bool = false
    ) -> some View {
        modifier(NumbersOnlyViewModifier(
            text: text,
            inputType: .decimal,
            maxValue: maxValue,
            minValue: minValue,
            maxDecimalPlaces: maxDecimalPlaces,
            allowsNegative: allowsNegative
        ))
    }
    
    /// Apply currency input validation
    func currencyOnly(
        text: Binding<String>,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        allowsNegative: Bool = false
    ) -> some View {
        modifier(NumbersOnlyViewModifier(
            text: text,
            inputType: .currency,
            maxValue: maxValue,
            minValue: minValue,
            maxDecimalPlaces: 2,
            allowsNegative: allowsNegative
        ))
    }
    
    /// Apply percentage input validation
    func percentageOnly(
        text: Binding<String>,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        allowsNegative: Bool = false
    ) -> some View {
        modifier(NumbersOnlyViewModifier(
            text: text,
            inputType: .percentage,
            maxValue: maxValue,
            minValue: minValue,
            maxDecimalPlaces: 3,
            allowsNegative: allowsNegative
        ))
    }
    
    /// Apply integer-only input validation
    func integerOnly(
        text: Binding<String>,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        allowsNegative: Bool = false
    ) -> some View {
        modifier(NumbersOnlyViewModifier(
            text: text,
            inputType: .integer,
            maxValue: maxValue,
            minValue: minValue,
            maxDecimalPlaces: 0,
            allowsNegative: allowsNegative
        ))
    }
}

// MARK: - Enhanced Input Field Components

/// Enhanced currency input field with real-time validation and formatting
struct EnhancedCurrencyInputField: View {
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
    
    @State private var stringValue: String = ""
    @State private var isEditing: Bool = false
    @State private var validationError: String?
    @FocusState private var isFocused: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        currency: Currency = .usd,
        placeholder: String = "0.00",
        isRequired: Bool = false,
        helpText: String? = nil,
        maxValue: Double? = nil,
        minValue: Double? = 0,
        allowsNegative: Bool = false
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
        
        // Initialize string value
        let formatter = Formatters.decimalFormatter(decimalPlaces: currency.decimalPlaces)
        self._stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue)) ?? "")
    }
    
    var body: some View {
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
            
            // Currency input field
            HStack(spacing: 8) {
                Text(currency.symbol)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(minWidth: 20)
                
                TextField(placeholder, text: $stringValue)
                    .textFieldStyle(FinancialTextFieldStyle(
                        isEditing: isEditing,
                        hasError: validationError != nil,
                        isFocused: isFocused
                    ))
                    .focused($isFocused)
                    .currencyOnly(
                        text: $stringValue,
                        maxValue: maxValue,
                        minValue: minValue,
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
        if let doubleValue = Double(cleanedValue) {
            value = doubleValue
        }
    }
    
    private func validateAndFormat() {
        let cleanedValue = stringValue.replacingOccurrences(of: ",", with: "")
        
        if let doubleValue = Double(cleanedValue) {
            // Validate bounds
            if let minValue = minValue, doubleValue < minValue {
                validationError = "Value must be at least \(currency.formatValue(minValue))"
                return
            }
            
            if let maxValue = maxValue, doubleValue > maxValue {
                validationError = "Value must be at most \(currency.formatValue(maxValue))"
                return
            }
            
            // Format the display value
            let formatter = Formatters.decimalFormatter(decimalPlaces: currency.decimalPlaces)
            stringValue = formatter.string(from: NSNumber(value: doubleValue)) ?? String(doubleValue)
            value = doubleValue
            validationError = nil
        } else if !stringValue.isEmpty {
            validationError = "Please enter a valid number"
        } else {
            validationError = isRequired ? "This field is required" : nil
        }
    }
}

/// Enhanced percentage input field with real-time validation
struct EnhancedPercentageInputField: View {
    let title: String
    let subtitle: String?
    @Binding var value: Double
    let placeholder: String
    let isRequired: Bool
    let helpText: String?
    let maxValue: Double
    let minValue: Double
    let allowsNegative: Bool
    
    @State private var stringValue: String = ""
    @State private var isEditing: Bool = false
    @State private var validationError: String?
    @FocusState private var isFocused: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        placeholder: String = "0.00",
        isRequired: Bool = false,
        helpText: String? = nil,
        maxValue: Double = 100,
        minValue: Double = 0,
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
        self._stringValue = State(initialValue: String(format: "%.3f", value.wrappedValue))
    }
    
    var body: some View {
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
            
            // Percentage input field
            HStack(spacing: 8) {
                TextField(placeholder, text: $stringValue)
                    .textFieldStyle(FinancialTextFieldStyle(
                        isEditing: isEditing,
                        hasError: validationError != nil,
                        isFocused: isFocused
                    ))
                    .focused($isFocused)
                    .percentageOnly(
                        text: $stringValue,
                        maxValue: maxValue,
                        minValue: minValue,
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
                
                Text("%")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(minWidth: 15)
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
        let cleanedValue = stringValue.replacingOccurrences(of: "%", with: "")
        if let doubleValue = Double(cleanedValue) {
            value = doubleValue
        }
    }
    
    private func validateAndFormat() {
        let cleanedValue = stringValue.replacingOccurrences(of: "%", with: "")
        
        if let doubleValue = Double(cleanedValue) {
            // Validate bounds
            if doubleValue < minValue {
                validationError = "Value must be at least \(String(format: "%.3f", minValue))%"
                return
            }
            
            if doubleValue > maxValue {
                validationError = "Value must be at most \(String(format: "%.3f", maxValue))%"
                return
            }
            
            // Format the display value
            stringValue = String(format: "%.3f", doubleValue)
            value = doubleValue
            validationError = nil
        } else if !stringValue.isEmpty {
            validationError = "Please enter a valid percentage"
        } else {
            validationError = isRequired ? "This field is required" : nil
        }
    }
}

/// Enhanced integer input field with real-time validation
struct EnhancedIntegerInputField: View {
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
    
    init(
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
    
    var body: some View {
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

#Preview {
    VStack(spacing: 20) {
        EnhancedCurrencyInputField(
            title: "Investment Amount",
            subtitle: "Principal investment amount",
            value: .constant(100000),
            currency: .usd,
            isRequired: true,
            helpText: "Enter the initial investment amount"
        )
        
        EnhancedPercentageInputField(
            title: "Interest Rate",
            subtitle: "Annual percentage rate",
            value: .constant(5.5),
            isRequired: true,
            helpText: "Enter the annual interest rate"
        )
        
        EnhancedIntegerInputField(
            title: "Term in Years",
            subtitle: "Investment period",
            value: .constant(10),
            isRequired: true,
            helpText: "Enter the investment term in years"
        )
    }
    .padding()
    .frame(width: 400)
}
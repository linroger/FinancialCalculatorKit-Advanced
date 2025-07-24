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

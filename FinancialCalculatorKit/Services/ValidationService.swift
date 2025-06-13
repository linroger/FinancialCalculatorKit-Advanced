//
//  ValidationService.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Unified validation service bridging FinancialValidation and lightweight validation systems
//

import Foundation
import Combine

// Type aliases to avoid conflicts with local ValidationRule definitions
typealias InputValidationRule = (String) -> InputValidationResult

/// Unified validation service that consolidates validation logic across the application
@MainActor
public final class ValidationService: ObservableObject {
    /// Shared instance for global access
    public static let shared = ValidationService()
    
    /// Published validation results for reactive UI updates
    @Published public private(set) var validationResults: [String: FinancialValidation.ValidationResult] = [:]
    
    /// Active validation publishers for real-time validation
    private var validationPublishers: [String: AnyCancellable] = [:]
    
    /// Queue for async validation operations
    private let validationQueue = DispatchQueue(label: "com.financialcalculator.validation", attributes: .concurrent)
    
    private init() {}
    
    // MARK: - Public API
    
    /// Validates a field value using both lightweight and comprehensive validation
    /// - Parameters:
    ///   - fieldId: Unique identifier for the field
    ///   - value: The value to validate
    ///   - rules: Lightweight validation rules to apply
    ///   - context: Optional financial validation context
    ///   - async: Whether to perform async validation
    /// - Returns: Unified validation result
    public func validateField(
        fieldId: String,
        value: Any,
        rules: [(String) -> InputValidationResult] = [],
        context: FinancialValidation.ValidationContext? = nil,
        async: Bool = false
    ) -> FinancialValidation.ValidationResult {
        if async {
            Task {
                let result = await performAsyncValidation(
                    fieldId: fieldId,
                    value: value,
                    rules: rules,
                    context: context
                )
                validationResults[fieldId] = result
            }
            return FinancialValidation.ValidationResult.pending()
        } else {
            let result = performSyncValidation(
                fieldId: fieldId,
                value: value,
                rules: rules,
                context: context
            )
            validationResults[fieldId] = result
            return result
        }
    }
    
    /// Sets up real-time validation for a field
    /// - Parameters:
    ///   - fieldId: Unique identifier for the field
    ///   - publisher: Publisher that emits field values
    ///   - rules: Validation rules to apply
    ///   - context: Optional financial validation context
    ///   - debounce: Debounce interval in milliseconds
    public func setupRealtimeValidation<P: Publisher>(
        fieldId: String,
        publisher: P,
        rules: [(String) -> InputValidationResult] = [],
        context: FinancialValidation.ValidationContext? = nil,
        debounce: Int = 300
    ) where P.Output == String, P.Failure == Never {
        // Cancel existing publisher if any
        validationPublishers[fieldId]?.cancel()
        
        // Create new validation pipeline
        let cancellable = publisher
            .debounce(for: .milliseconds(debounce), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                let result = self.validateField(
                    fieldId: fieldId,
                    value: value,
                    rules: rules,
                    context: context,
                    async: false
                )
                self.validationResults[fieldId] = result
            }
        
        validationPublishers[fieldId] = cancellable
    }
    
    /// Validates multiple fields in batch
    /// - Parameter fields: Array of field configurations to validate
    /// - Returns: Dictionary of field IDs to validation results
    public func validateBatch(_ fields: [FieldValidationConfig]) async -> [String: FinancialValidation.ValidationResult] {
        var results: [String: FinancialValidation.ValidationResult] = [:]

        for field in fields {
            let result = await performAsyncValidation(
                fieldId: field.id,
                value: field.value,
                rules: field.rules,
                context: field.context
            )
            results[field.id] = result
            validationResults[field.id] = result
        }

        return results
    }
    
    /// Clears validation results for specific fields or all fields
    /// - Parameter fieldIds: Optional array of field IDs to clear. If nil, clears all.
    public func clearValidation(fieldIds: [String]? = nil) {
        if let fieldIds = fieldIds {
            for fieldId in fieldIds {
                validationResults.removeValue(forKey: fieldId)
                validationPublishers[fieldId]?.cancel()
                validationPublishers.removeValue(forKey: fieldId)
            }
        } else {
            validationResults.removeAll()
            validationPublishers.values.forEach { $0.cancel() }
            validationPublishers.removeAll()
        }
    }
    
    /// Gets the current validation state for a field
    /// - Parameter fieldId: The field identifier
    /// - Returns: Current validation result or nil if not validated
    public func getValidationState(for fieldId: String) -> FinancialValidation.ValidationResult? {
        return validationResults[fieldId]
    }
    
    /// Checks if all validated fields are valid
    /// - Returns: True if all fields are valid, false otherwise
    public var isAllValid: Bool {
        validationResults.values.allSatisfy { $0.isValid }
    }
    
    /// Gets all current validation errors
    /// - Returns: Array of error messages
    public var allErrors: [String] {
        validationResults.values.compactMap { $0.errorMessage }
    }
    
    // MARK: - Private Methods
    
    private func performSyncValidation(
        fieldId: String,
        value: Any,
        rules: [(String) -> InputValidationResult],
        context: FinancialValidation.ValidationContext?
    ) -> FinancialValidation.ValidationResult {
        // First apply lightweight rules
        if let stringValue = value as? String {
            for rule in rules {
                let result = rule(stringValue)
                if !result.isValid {
                    return ValidationResult(
                        isValid: false,
                        errorType: .businessRule,
                        errorMessage: result.errorMessage
                    )
                }
            }
        }
        
        // Then apply financial validation if context is provided
        if let context = context {
            return applyFinancialValidation(value: value, context: context)
        }
        
        // If no specific validation, just check basic validity
        return validateBasicType(value: value, fieldId: fieldId)
    }
    
    private func performAsyncValidation(
        fieldId: String,
        value: Any,
        rules: [(String) -> InputValidationResult],
        context: FinancialValidation.ValidationContext?
    ) async -> FinancialValidation.ValidationResult {
        // Perform sync validation first
        let syncResult = performSyncValidation(
            fieldId: fieldId,
            value: value,
            rules: rules,
            context: context
        )
        
        // If sync validation failed, return immediately
        if !syncResult.isValid {
            return syncResult
        }
        
        // Perform additional async validations if needed
        if let context = context {
            return await performAsyncFinancialValidation(value: value, context: context)
        }
        
        return syncResult
    }
    
    private func applyFinancialValidation(
        value: Any,
        context: FinancialValidation.ValidationContext
    ) -> FinancialValidation.ValidationResult {
        let validation = FinancialValidation.shared
        
        // Route to appropriate validation method based on context
        switch context.fieldName.lowercased() {
        case let name where name.contains("amount") || name.contains("principal") || name.contains("payment"):
            if let doubleValue = convertToDouble(value) {
                return validation.validateCurrencyAmount(
                    doubleValue,
                    minValue: context.relatedFields["minValue"],
                    maxValue: context.relatedFields["maxValue"],
                    allowNegative: context.relatedFields["allowNegative"] != nil,
                    currency: context.currency ?? .usd,
                    context: context
                )
            }
            
        case let name where name.contains("rate") || name.contains("interest") || name.contains("yield"):
            if let doubleValue = convertToDouble(value) {
                return validation.validateInterestRate(
                    doubleValue,
                    context: context
                )
            }
            
        case let name where name.contains("term") || name.contains("period") || name.contains("years"):
            if let doubleValue = convertToDouble(value) {
                return validation.validateTerm(
                    years: doubleValue,
                    frequency: .annual,
                    context: context
                )
            }
            
        case let name where name.contains("ratio") || name.contains("ltv") || name.contains("dti"):
            if let doubleValue = convertToDouble(value) {
                return validation.validateRatio(
                    doubleValue,
                    minValue: 0,
                    maxValue: context.relatedFields["maxValue"] ?? 1.0,
                    context: context
                )
            }
            
        default:
            // Generic validation
            if let doubleValue = convertToDouble(value) {
                return validation.validateGeneralNumber(
                    doubleValue,
                    minValue: context.relatedFields["minValue"],
                    maxValue: context.relatedFields["maxValue"],
                    context: context
                )
            }
        }
        
        return ValidationResult.invalid(
            errorType: .invalidFormat,
            message: "Unable to validate value"
        )
    }
    
    private func performAsyncFinancialValidation(
        value: Any,
        context: FinancialValidation.ValidationContext
    ) async -> FinancialValidation.ValidationResult {
        // Simulate async validation (e.g., checking against external data)
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // For now, just return the sync validation result
        // In a real implementation, this could check external APIs,
        // validate against historical data, etc.
        return applyFinancialValidation(value: value, context: context)
    }
    
    private func validateBasicType(value: Any, fieldId: String) -> ValidationResult {
        switch value {
        case let stringValue as String:
            return stringValue.isEmpty ? 
                .invalid(errorType: .required, message: "This field is required") :
                .valid()
            
        case let doubleValue as Double:
            return doubleValue.isNaN || doubleValue.isInfinite ?
                .invalid(errorType: .invalidFormat, message: "Invalid number") :
                .valid()
            
        case let intValue as Int:
            return intValue < 0 ?
                .invalid(errorType: .negativeValue, message: "Value must be positive") :
                .valid()
            
        default:
            return .valid()
        }
    }
    
    private func convertToDouble(_ value: Any) -> Double? {
        switch value {
        case let double as Double:
            return double
        case let int as Int:
            return Double(int)
        case let string as String:
            return Double(string.replacingOccurrences(of: ",", with: ""))
        default:
            return nil
        }
    }
}

// MARK: - Supporting Types

/// Configuration for field validation
public struct FieldValidationConfig {
    public let id: String
    public let value: Any
    public let rules: [(String) -> InputValidationResult]
    public let context: FinancialValidation.ValidationContext?
    
    public init(
        id: String,
        value: Any,
        rules: [(String) -> InputValidationResult] = [],
        context: FinancialValidation.ValidationContext? = nil
    ) {
        self.id = id
        self.value = value
        self.rules = rules
        self.context = context
    }
}

// MARK: - Validation Result Extensions

extension FinancialValidation.ValidationResult {
    /// Creates a pending validation result
    public static func pending() -> Self {
        return Self(
            isValid: true,
            warningMessage: "Validation in progress..."
        )
    }
}

// MARK: - Adapter Pattern for Legacy Code

/// Adapter to convert lightweight ValidationRule to comprehensive validation
public struct ValidationRuleAdapter {
    /// Converts a lightweight InputValidationRule to a financial validation function
    static func adapt(_ rule: @escaping InputValidationRule) -> (Any, FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        return { value, context in
            guard let stringValue = value as? String else {
                return .invalid(
                    errorType: .invalidFormat,
                    message: "Expected string value"
                )
            }
            
            let result = rule(stringValue)
            if result.isValid {
                return .valid()
            } else {
                return .invalid(
                    errorType: .businessRule,
                    message: result.errorMessage ?? "Validation failed",
                    context: context
                )
            }
        }
    }
    
    /// Creates an InputValidationRule from a financial validation function
    static func createRule(
        from validation: @escaping (Double, FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult,
        context: FinancialValidation.ValidationContext
    ) -> InputValidationRule {
        return { stringValue in
            guard let doubleValue = Double(stringValue.replacingOccurrences(of: ",", with: "")) else {
                return InputValidationResult(
                    isValid: false,
                    errorMessage: "Invalid number format"
                )
            }
            
            let result = validation(doubleValue, context)
            return InputValidationResult(
                isValid: result.isValid,
                errorMessage: result.errorMessage
            )
        }
    }
}

// MARK: - Convenience Methods

extension ValidationService {
    /// Validates a currency amount with common rules
    public func validateCurrencyAmount(
        _ value: Double,
        fieldId: String,
        minValue: Double? = nil,
        maxValue: Double? = nil,
        currency: Currency = .usd,
        isRequired: Bool = false
    ) -> FinancialValidation.ValidationResult {
        let context = FinancialValidation.ValidationContext(
            calculationType: .mathExpression,
            fieldName: fieldId,
            relatedFields: [
                "minValue": minValue ?? 0,
                "maxValue": maxValue ?? Double.greatestFiniteMagnitude
            ],
            currency: currency
        )
        
        return validateField(
            fieldId: fieldId,
            value: value,
            rules: isRequired ? [{ value in InputValidationResult(isValid: !value.isEmpty, errorMessage: value.isEmpty ? "This field is required" : nil) }] : [],
            context: context,
            async: false
        )
    }
    
    /// Validates a percentage value
    public func validatePercentage(
        _ value: Double,
        fieldId: String,
        minValue: Double = 0,
        maxValue: Double = 100,
        isRequired: Bool = false
    ) -> FinancialValidation.ValidationResult {
        let requiredRule: InputValidationRule = { value in
            InputValidationResult(
                isValid: !value.isEmpty,
                errorMessage: value.isEmpty ? "This field is required" : nil
            )
        }
        
        let percentageRule: InputValidationRule = { value in
            guard let number = Double(value) else {
                return InputValidationResult(isValid: false, errorMessage: "Must be a valid number")
            }
            let isValid = number >= minValue && number <= maxValue
            return InputValidationResult(
                isValid: isValid,
                errorMessage: isValid ? nil : "Must be between \(minValue) and \(maxValue)"
            )
        }
        
        let rules: [InputValidationRule] = isRequired ? [requiredRule, percentageRule] : [percentageRule]
        
        return validateField(
            fieldId: fieldId,
            value: String(value),
            rules: rules,
            context: nil,
            async: false
        )
    }
    
    /// Validates a term/period in years
    public func validateTerm(
        _ years: Double,
        fieldId: String,
        minYears: Double = 0,
        maxYears: Double = 100,
        isRequired: Bool = false
    ) -> FinancialValidation.ValidationResult {
        let context = FinancialValidation.ValidationContext(
            calculationType: .mathExpression,
            fieldName: fieldId,
            relatedFields: [
                "minValue": minYears,
                "maxValue": maxYears
            ]
        )
        
        return validateField(
            fieldId: fieldId,
            value: years,
            rules: isRequired ? [{ value in InputValidationResult(isValid: !value.isEmpty, errorMessage: value.isEmpty ? "This field is required" : nil) }] : [],
            context: context,
            async: false
        )
    }
}

// MARK: - SwiftUI Integration

import SwiftUI

/// View modifier for field validation
public struct ValidationModifier: ViewModifier {
    let fieldId: String
    let rules: [(String) -> InputValidationResult]
    let context: FinancialValidation.ValidationContext?
    @ObservedObject private var validationService = ValidationService.shared
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: fieldId) { _, _ in
                // Re-validate when field changes
            }
            .overlay(alignment: .bottomTrailing) {
                if let result = validationService.getValidationState(for: fieldId),
                   !result.isValid,
                   let error = result.errorMessage {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .help(error)
                }
            }
    }
}

extension View {
    /// Adds validation to a view
    public func validation(
        fieldId: String,
        rules: [(String) -> InputValidationResult] = [],
        context: FinancialValidation.ValidationContext? = nil
    ) -> some View {
        modifier(ValidationModifier(
            fieldId: fieldId,
            rules: rules,
            context: context
        ))
    }
}
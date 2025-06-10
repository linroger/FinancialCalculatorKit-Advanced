//
//  FinancialValidation.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Comprehensive financial validation and rounding system
//

import Foundation

/// Comprehensive financial validation and data integrity system
public class FinancialValidation {
    
    // MARK: - Configuration
    
    /// Global validation configuration
    nonisolated(unsafe) public static var shared = FinancialValidation()
    
    /// Default validation settings
    public struct ValidationSettings {
        /// Minimum principal amount for loans and investments
        public var minimumPrincipal: Double = 0.01
        /// Maximum principal amount for reasonable calculations
        public var maximumPrincipal: Double = 1_000_000_000.0 // 1 billion
        /// Minimum interest rate (can be negative for some scenarios)
        public var minimumInterestRate: Double = -50.0
        /// Maximum interest rate for reasonable calculations
        public var maximumInterestRate: Double = 100.0
        /// Maximum term in years for loans and investments
        public var maximumTermYears: Double = 100.0
        /// Maximum number of cash flows for NPV calculations
        public var maximumCashFlows: Int = 1000
        /// Minimum payment amount
        public var minimumPayment: Double = 0.01
        /// Maximum payment amount
        public var maximumPayment: Double = 100_000_000.0 // 100 million
        /// Tolerance for mathematical precision checks
        public var precisionTolerance: Double = 1e-10
        /// Maximum iterations for iterative calculations
        public var maxIterations: Int = 10000
    }
    
    public var settings = ValidationSettings()
    
    // MARK: - Validation Result Types
    
    /// Comprehensive validation result with detailed feedback
    public struct ValidationResult: Sendable {
        public let isValid: Bool
        public let errorType: ValidationErrorType?
        public let errorMessage: String?
        public let suggestedValue: Double?
        public let warningMessage: String?
        public let context: ValidationContext?
        
        public init(
            isValid: Bool,
            errorType: ValidationErrorType? = nil,
            errorMessage: String? = nil,
            suggestedValue: Double? = nil,
            warningMessage: String? = nil,
            context: ValidationContext? = nil
        ) {
            self.isValid = isValid
            self.errorType = errorType
            self.errorMessage = errorMessage
            self.suggestedValue = suggestedValue
            self.warningMessage = warningMessage
            self.context = context
        }
        
        /// Create a valid result
        public static func valid(warningMessage: String? = nil) -> ValidationResult {
            return ValidationResult(isValid: true, warningMessage: warningMessage)
        }
        
        /// Create an invalid result with error details
        public static func invalid(
            errorType: ValidationErrorType,
            message: String,
            suggestedValue: Double? = nil,
            context: ValidationContext? = nil
        ) -> ValidationResult {
            return ValidationResult(
                isValid: false,
                errorType: errorType,
                errorMessage: message,
                suggestedValue: suggestedValue,
                context: context
            )
        }
    }
    
    /// Types of validation errors
    public enum ValidationErrorType: Sendable {
        case required
        case outOfRange
        case negativeValue
        case zeroValue
        case invalidFormat
        case overflow
        case underflow
        case businessRule
        case precision
        case inconsistency
        case mathematicalError
        
        public var description: String {
            switch self {
            case .required: return "Required Field"
            case .outOfRange: return "Out of Range"
            case .negativeValue: return "Negative Value"
            case .zeroValue: return "Zero Value"
            case .invalidFormat: return "Invalid Format"
            case .overflow: return "Value Too Large"
            case .underflow: return "Value Too Small"
            case .businessRule: return "Business Rule Violation"
            case .precision: return "Precision Error"
            case .inconsistency: return "Inconsistent Values"
            case .mathematicalError: return "Mathematical Error"
            }
        }
    }
    
    /// Context for validation providing additional information
    public struct ValidationContext: Sendable {
        public let calculationType: CalculationType
        public let fieldName: String
        public let relatedFields: [String: Double]
        public let currency: Currency?
        public let locale: Locale?
        
        public init(
            calculationType: CalculationType,
            fieldName: String,
            relatedFields: [String: Double] = [:],
            currency: Currency? = nil,
            locale: Locale? = nil
        ) {
            self.calculationType = calculationType
            self.fieldName = fieldName
            self.relatedFields = relatedFields
            self.currency = currency
            self.locale = locale
        }
    }
    
    // MARK: - Financial Rounding System
    
    /// Financial-grade rounding with multiple strategies
    public struct FinancialRounding {
        
        /// Rounding strategies for different financial contexts
        public enum Strategy {
            case bankers          // Round half to even (IEEE 754 default)
            case awayFromZero     // Round half away from zero
            case towardZero       // Round half toward zero
            case up               // Always round up (ceiling)
            case down             // Always round down (floor)
            case currencyDefault  // Use currency-specific rounding
            case none             // No rounding
        }
        
        /// Apply financial rounding to a value
        public static func round(
            _ value: Double,
            toDecimalPlaces places: Int,
            strategy: Strategy = .bankers,
            currency: Currency? = nil
        ) -> Double {
            
            // Handle special cases
            if value.isNaN || value.isInfinite {
                return value
            }
            
            if strategy == .none {
                return value
            }
            
            // Use currency-specific rounding if specified
            if strategy == .currencyDefault, let currency = currency {
                return roundForCurrency(value, currency: currency)
            }
            
            let multiplier = pow(10.0, Double(places))
            let scaledValue = value * multiplier
            
            let roundedValue: Double
            
            switch strategy {
            case .bankers:
                roundedValue = bankersRound(scaledValue)
            case .awayFromZero:
                roundedValue = scaledValue >= 0 ? ceil(scaledValue) : floor(scaledValue)
            case .towardZero:
                roundedValue = scaledValue >= 0 ? floor(scaledValue) : ceil(scaledValue)
            case .up:
                roundedValue = ceil(scaledValue)
            case .down:
                roundedValue = floor(scaledValue)
            case .currencyDefault, .none:
                roundedValue = Darwin.round(scaledValue)
            }
            
            return roundedValue / multiplier
        }
        
        /// Banker's rounding (round half to even)
        private static func bankersRound(_ value: Double) -> Double {
            let floor = Darwin.floor(value)
            let fractionalPart = value - floor
            
            if fractionalPart < 0.5 {
                return floor
            } else if fractionalPart > 0.5 {
                return ceil(value)
            } else {
                // Exactly 0.5 - round to even
                return floor.truncatingRemainder(dividingBy: 2.0) == 0 ? floor : floor + 1
            }
        }
        
        /// Currency-specific rounding
        private static func roundForCurrency(_ value: Double, currency: Currency) -> Double {
            switch currency {
            case .jpy, .krw:
                // No decimal places for Yen and Won
                return round(value, toDecimalPlaces: 0, strategy: .bankers)
            default:
                // Two decimal places for most currencies
                return round(value, toDecimalPlaces: currency.decimalPlaces, strategy: .bankers)
            }
        }
        
        /// Minimize cumulative rounding errors in a series of calculations
        public static func minimizeCumulativeError(
            values: [Double],
            targetSum: Double,
            decimalPlaces: Int = 2
        ) -> [Double] {
            guard !values.isEmpty else { return values }
            
            var roundedValues = values.map { round($0, toDecimalPlaces: decimalPlaces, strategy: .bankers) }
            let actualSum = roundedValues.reduce(0, +)
            let error = targetSum - actualSum
            
            // If error is significant, adjust the largest value
            if abs(error) > pow(10.0, -Double(decimalPlaces)) {
                if let maxIndex = roundedValues.indices.max(by: { abs(roundedValues[$0]) < abs(roundedValues[$1]) }) {
                    roundedValues[maxIndex] += error
                    roundedValues[maxIndex] = round(roundedValues[maxIndex], toDecimalPlaces: decimalPlaces, strategy: .bankers)
                }
            }
            
            return roundedValues
        }
    }
    
    // MARK: - Core Validation Functions
    
    /// Validate a required field
    public func validateRequired<T>(_ value: T?, fieldName: String, context: ValidationContext) -> ValidationResult {
        if value == nil {
            return .invalid(
                errorType: .required,
                message: "\(fieldName) is required",
                context: context
            )
        }
        return .valid()
    }
    
    /// Validate a numeric value is within acceptable range
    public func validateNumericRange(
        _ value: Double,
        fieldName: String,
        minimum: Double? = nil,
        maximum: Double? = nil,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Check for NaN or infinite values
        if value.isNaN {
            return .invalid(
                errorType: .invalidFormat,
                message: "\(fieldName) is not a valid number",
                context: context
            )
        }
        
        if value.isInfinite {
            return .invalid(
                errorType: .overflow,
                message: "\(fieldName) is too large to process",
                context: context
            )
        }
        
        // Check minimum value
        if let minimum = minimum, value < minimum {
            let suggestedValue = minimum
            return .invalid(
                errorType: .outOfRange,
                message: "\(fieldName) must be at least \(formatValue(minimum, context: context))",
                suggestedValue: suggestedValue,
                context: context
            )
        }
        
        // Check maximum value
        if let maximum = maximum, value > maximum {
            let suggestedValue = maximum
            return .invalid(
                errorType: .outOfRange,
                message: "\(fieldName) must be at most \(formatValue(maximum, context: context))",
                suggestedValue: suggestedValue,
                context: context
            )
        }
        
        return .valid()
    }
    
    /// Validate principal amount for loans and investments
    public func validatePrincipal(
        _ value: Double,
        context: ValidationContext
    ) -> ValidationResult {
        return validateNumericRange(
            value,
            fieldName: "Principal",
            minimum: settings.minimumPrincipal,
            maximum: settings.maximumPrincipal,
            context: context
        )
    }
    
    /// Validate interest rate
    public func validateInterestRate(
        _ value: Double,
        context: ValidationContext,
        allowNegative: Bool = false
    ) -> ValidationResult {
        
        let minimum = allowNegative ? settings.minimumInterestRate : 0.0
        let result = validateNumericRange(
            value,
            fieldName: "Interest Rate",
            minimum: minimum,
            maximum: settings.maximumInterestRate,
            context: context
        )
        
        // Add warning for unusual rates
        if result.isValid {
            if value > 50.0 {
                return ValidationResult(
                    isValid: true,
                    warningMessage: "Interest rate above 50% is unusually high. Please verify this is correct."
                )
            } else if value < 0 && !allowNegative {
                return .invalid(
                    errorType: .negativeValue,
                    message: "Interest rate cannot be negative for this calculation",
                    context: context
                )
            }
        }
        
        return result
    }
    
    /// Validate payment amount
    public func validatePayment(
        _ value: Double,
        context: ValidationContext
    ) -> ValidationResult {
        return validateNumericRange(
            value,
            fieldName: "Payment",
            minimum: settings.minimumPayment,
            maximum: settings.maximumPayment,
            context: context
        )
    }
    
    /// Validate term (time period)
    public func validateTerm(
        _ value: Double,
        fieldName: String = "Term",
        context: ValidationContext
    ) -> ValidationResult {
        
        let result = validateNumericRange(
            value,
            fieldName: fieldName,
            minimum: 0.0,
            maximum: settings.maximumTermYears,
            context: context
        )
        
        // Add warning for very long terms
        if result.isValid && value > 50.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Term longer than 50 years may produce unrealistic results."
            )
        }
        
        return result
    }
    
    /// Validate cash flows for NPV/IRR calculations
    public func validateCashFlows(
        _ cashFlows: [Double],
        context: ValidationContext
    ) -> ValidationResult {
        
        if cashFlows.isEmpty {
            return .invalid(
                errorType: .required,
                message: "Cash flows cannot be empty",
                context: context
            )
        }
        
        if cashFlows.count > settings.maximumCashFlows {
            return .invalid(
                errorType: .outOfRange,
                message: "Maximum \(settings.maximumCashFlows) cash flows supported",
                context: context
            )
        }
        
        // Check for all zero cash flows
        if cashFlows.allSatisfy({ $0 == 0 }) {
            return .invalid(
                errorType: .zeroValue,
                message: "Cash flows cannot all be zero",
                context: context
            )
        }
        
        // Check for mathematical validity
        let hasPositive = cashFlows.contains { $0 > 0 }
        let hasNegative = cashFlows.contains { $0 < 0 }
        
        if !hasPositive && !hasNegative {
            return .invalid(
                errorType: .zeroValue,
                message: "Cash flows must include non-zero values",
                context: context
            )
        }
        
        // Warning for IRR calculations (part of investment calculations)
        if context.calculationType == .investment && (!hasPositive || !hasNegative) {
            return ValidationResult(
                isValid: true,
                warningMessage: "IRR calculation requires both positive and negative cash flows for meaningful results."
            )
        }
        
        return .valid()
    }
    
    /// Validate bond parameters
    public func validateBondParameters(
        faceValue: Double,
        couponRate: Double,
        maturityYears: Double,
        marketPrice: Double?,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Validate face value
        var result = validateNumericRange(
            faceValue,
            fieldName: "Face Value",
            minimum: 1.0,
            maximum: 1_000_000_000.0,
            context: context
        )
        if !result.isValid { return result }
        
        // Validate coupon rate
        result = validateNumericRange(
            couponRate,
            fieldName: "Coupon Rate",
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
        if !result.isValid { return result }
        
        // Validate maturity
        result = validateNumericRange(
            maturityYears,
            fieldName: "Maturity",
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
        if !result.isValid { return result }
        
        // Validate market price if provided
        if let marketPrice = marketPrice {
            result = validateNumericRange(
                marketPrice,
                fieldName: "Market Price",
                minimum: 0.01,
                maximum: faceValue * 5.0, // Allow up to 5x face value
                context: context
            )
            if !result.isValid { return result }
        }
        
        return .valid()
    }
    
    /// Validate option parameters
    public func validateOptionParameters(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiration: Double,
        volatility: Double,
        riskFreeRate: Double,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Validate spot price
        var result = validateNumericRange(
            spotPrice,
            fieldName: "Spot Price",
            minimum: 0.01,
            maximum: 1_000_000.0,
            context: context
        )
        if !result.isValid { return result }
        
        // Validate strike price
        result = validateNumericRange(
            strikePrice,
            fieldName: "Strike Price",
            minimum: 0.01,
            maximum: 1_000_000.0,
            context: context
        )
        if !result.isValid { return result }
        
        // Validate time to expiration
        result = validateNumericRange(
            timeToExpiration,
            fieldName: "Time to Expiration",
            minimum: 0.0,
            maximum: 10.0, // 10 years max
            context: context
        )
        if !result.isValid { return result }
        
        // Validate volatility
        result = validateNumericRange(
            volatility,
            fieldName: "Volatility",
            minimum: 0.0,
            maximum: 500.0, // 500% max
            context: context
        )
        if !result.isValid { return result }
        
        // Validate risk-free rate
        result = validateNumericRange(
            riskFreeRate,
            fieldName: "Risk-Free Rate",
            minimum: -10.0,
            maximum: 50.0,
            context: context
        )
        if !result.isValid { return result }
        
        return .valid()
    }
    
    /// Validate business rules for loan calculations
    public func validateLoanBusinessRules(
        principal: Double,
        interestRate: Double,
        payment: Double,
        term: Double,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Payment must be sufficient to cover interest
        let monthlyRate = interestRate / 100.0 / 12.0
        let monthlyInterest = principal * monthlyRate
        
        if payment <= monthlyInterest {
            return .invalid(
                errorType: .businessRule,
                message: "Payment (\(formatValue(payment, context: context))) must be greater than monthly interest (\(formatValue(monthlyInterest, context: context)))",
                suggestedValue: monthlyInterest * 1.1,
                context: context
            )
        }
        
        // Check if loan will be paid off in reasonable time
        if term > 50.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Loan term exceeds 50 years. Consider reducing the term or increasing the payment."
            )
        }
        
        return .valid()
    }
    
    /// Validate precision and detect potential calculation errors
    public func validatePrecision(
        calculatedValue: Double,
        expectedValue: Double?,
        tolerance: Double = 1e-10,
        context: ValidationContext
    ) -> ValidationResult {
        
        guard let expectedValue = expectedValue else {
            return .valid()
        }
        
        let difference = abs(calculatedValue - expectedValue)
        let relativeDifference = difference / max(abs(expectedValue), 1.0)
        
        if relativeDifference > tolerance {
            return .invalid(
                errorType: .precision,
                message: "Calculation precision error detected. Difference: \(difference)",
                context: context
            )
        }
        
        return .valid()
    }
}

// MARK: - Validation Rule Protocol

/// Protocol for defining validation rules
public protocol FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult
}

/// Pre-defined validation rules
public extension FinancialValidationRule {
    
    /// Rule for required fields
    static var required: FinancialValidationRule {
        return RequiredRule()
    }
    
    /// Rule for positive numbers
    static var positiveNumber: FinancialValidationRule {
        return PositiveNumberRule()
    }
    
    /// Rule for non-negative numbers
    static var nonNegativeNumber: FinancialValidationRule {
        return NonNegativeNumberRule()
    }
    
    /// Rule for percentage values
    static var percentage: FinancialValidationRule {
        return PercentageRule()
    }
    
    /// Rule for currency amounts
    static var currencyAmount: FinancialValidationRule {
        return CurrencyAmountRule()
    }
    
    /// Rule for interest rates
    static var interestRate: FinancialValidationRule {
        return InterestRateRule()
    }
    
    /// Rule for time periods
    static var timePeriod: FinancialValidationRule {
        return TimePeriodRule()
    }
}

// MARK: - Concrete Validation Rules

private struct RequiredRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        return FinancialValidation.shared.validateRequired(value, fieldName: context.fieldName, context: context)
    }
}

private struct PositiveNumberRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        guard let doubleValue = value as? Double else {
            return .invalid(
                errorType: .invalidFormat,
                message: "Value must be a number",
                context: context
            )
        }
        
        if doubleValue <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "\(context.fieldName) must be positive",
                context: context
            )
        }
        
        return .valid()
    }
}

private struct NonNegativeNumberRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        guard let doubleValue = value as? Double else {
            return .invalid(
                errorType: .invalidFormat,
                message: "Value must be a number",
                context: context
            )
        }
        
        if doubleValue < 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "\(context.fieldName) cannot be negative",
                context: context
            )
        }
        
        return .valid()
    }
}

private struct PercentageRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        guard let doubleValue = value as? Double else {
            return .invalid(
                errorType: .invalidFormat,
                message: "Value must be a number",
                context: context
            )
        }
        
        return FinancialValidation.shared.validateNumericRange(
            doubleValue,
            fieldName: context.fieldName,
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
    }
}

private struct CurrencyAmountRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        guard let doubleValue = value as? Double else {
            return .invalid(
                errorType: .invalidFormat,
                message: "Value must be a number",
                context: context
            )
        }
        
        return FinancialValidation.shared.validatePrincipal(doubleValue, context: context)
    }
}

private struct InterestRateRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        guard let doubleValue = value as? Double else {
            return .invalid(
                errorType: .invalidFormat,
                message: "Value must be a number",
                context: context
            )
        }
        
        return FinancialValidation.shared.validateInterestRate(doubleValue, context: context)
    }
}

private struct TimePeriodRule: FinancialValidationRule {
    func validate(_ value: Any?, context: FinancialValidation.ValidationContext) -> FinancialValidation.ValidationResult {
        guard let doubleValue = value as? Double else {
            return .invalid(
                errorType: .invalidFormat,
                message: "Value must be a number",
                context: context
            )
        }
        
        return FinancialValidation.shared.validateTerm(doubleValue, context: context)
    }
}

extension FinancialValidation {
    
    // MARK: - Bulk Validation Functions
    
    /// Validate multiple parameters at once
    public func validateParameters(
        _ parameters: [String: Any],
        rules: [String: FinancialValidationRule],
        context: ValidationContext
    ) -> [String: ValidationResult] {
        
        var results: [String: ValidationResult] = [:]
        
        for (key, rule) in rules {
            let value = parameters[key]
            results[key] = rule.validate(value, context: context)
        }
        
        return results
    }
    
    /// Check for parameter consistency
    public func validateParameterConsistency(
        _ parameters: [String: Double],
        context: ValidationContext
    ) -> ValidationResult {
        
        switch context.calculationType {
        case .loan:
            return validateLoanConsistency(parameters, context: context)
        case .investment:
            return validateInvestmentConsistency(parameters, context: context)
        case .bond:
            return validateBondConsistency(parameters, context: context)
        default:
            return .valid()
        }
    }
    
    private func validateLoanConsistency(
        _ parameters: [String: Double],
        context: ValidationContext
    ) -> ValidationResult {
        
        guard let principal = parameters["principal"],
              let rate = parameters["interestRate"],
              let payment = parameters["payment"],
              let term = parameters["term"] else {
            return .valid() // Skip if parameters are missing
        }
        
        // Check if payment is reasonable for the loan
        let monthlyRate = rate / 100.0 / 12.0
        let numPayments = term * 12.0
        let calculatedPayment = principal * (monthlyRate * pow(1 + monthlyRate, numPayments)) / (pow(1 + monthlyRate, numPayments) - 1)
        
        let paymentDifference = abs(payment - calculatedPayment) / calculatedPayment
        
        if paymentDifference > 0.1 { // 10% tolerance
            return ValidationResult(
                isValid: true,
                warningMessage: "Payment amount may be inconsistent with loan terms. Expected: \(formatValue(calculatedPayment, context: context))"
            )
        }
        
        return .valid()
    }
    
    private func validateInvestmentConsistency(
        _ parameters: [String: Double],
        context: ValidationContext
    ) -> ValidationResult {
        
        guard let _ = parameters["initialInvestment"],
              let expectedReturn = parameters["expectedReturn"],
              let timeHorizon = parameters["timeHorizon"] else {
            return .valid() // Skip if parameters are missing
        }
        
        // Check for unrealistic return expectations
        if expectedReturn > 30.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Expected returns above 30% annually are highly optimistic and risky. Consider more conservative estimates."
            )
        }
        
        // Check for very short-term investments with high volatility assumptions
        if timeHorizon < 1.0 && abs(expectedReturn) > 15.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "High return expectations for short-term investments may be unrealistic due to market volatility."
            )
        }
        
        // Check for negative returns with very long time horizons
        if expectedReturn < -5.0 && timeHorizon > 10.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Sustained negative returns over long periods are historically rare. Consider reviewing assumptions."
            )
        }
        
        return .valid()
    }
    
    private func validateBondConsistency(
        _ parameters: [String: Double],
        context: ValidationContext
    ) -> ValidationResult {
        
        guard let faceValue = parameters["faceValue"],
              let couponRate = parameters["couponRate"],
              let maturityYears = parameters["maturityYears"] else {
            return .valid() // Skip if parameters are missing
        }
        
        // Check for unusual coupon rates
        if couponRate > 20.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Coupon rates above 20% are extremely rare and may indicate high-risk or distressed debt."
            )
        }
        
        // Check for very long-term bonds
        if maturityYears > 100.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Bonds with maturities over 100 years are rare and may have unique characteristics."
            )
        }
        
        // Check for zero-coupon bonds with short maturities
        if couponRate == 0.0 && maturityYears < 1.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Zero-coupon bonds are more common for longer maturities where compound growth is significant."
            )
        }
        
        // Check for market price consistency if provided
        if let marketPrice = parameters["marketPrice"] {
            let priceDifference = abs(marketPrice - faceValue) / faceValue
            if priceDifference > 0.5 { // 50% difference
                return ValidationResult(
                    isValid: true,
                    warningMessage: "Market price significantly differs from face value. This may indicate high credit risk or interest rate changes."
                )
            }
        }
        
        return .valid()
    }
    
    // MARK: - Utility Functions
    
    /// Format a value for display in error messages
    private func formatValue(_ value: Double, context: ValidationContext) -> String {
        if let currency = context.currency {
            return currency.formatValue(value)
        } else {
            return String(format: "%.2f", value)
        }
    }
    
    /// Get suggested value based on validation error
    public func getSuggestedValue(
        for errorType: ValidationErrorType,
        currentValue: Double,
        context: ValidationContext
    ) -> Double? {
        
        switch errorType {
        case .negativeValue:
            return abs(currentValue)
        case .zeroValue:
            return context.fieldName.lowercased().contains("interest") || context.fieldName.lowercased().contains("rate") ? 5.0 : 1000.0
        case .outOfRange:
            // Return midpoint of valid range
            switch context.fieldName.lowercased() {
            case "principal":
                return (settings.minimumPrincipal + min(settings.maximumPrincipal, 100000.0)) / 2.0
            case "interest rate":
                return 5.0
            case "payment":
                return 1000.0
            case "term":
                return 30.0
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    /// Generate user-friendly error recovery suggestions
    public func getRecoverySuggestions(
        for validationResult: ValidationResult,
        context: ValidationContext
    ) -> [String] {
        
        guard !validationResult.isValid,
              let errorType = validationResult.errorType else {
            return []
        }
        
        var suggestions: [String] = []
        
        switch errorType {
        case .required:
            suggestions.append("This field is required for the calculation.")
            suggestions.append("Please enter a value to continue.")
            
        case .outOfRange:
            suggestions.append("Please enter a value within the acceptable range.")
            if let suggestedValue = validationResult.suggestedValue {
                suggestions.append("Try using \(formatValue(suggestedValue, context: context)) as a starting point.")
            }
            
        case .negativeValue:
            suggestions.append("This field requires a positive value.")
            suggestions.append("Please enter a value greater than zero.")
            
        case .businessRule:
            suggestions.append("This combination of values may not produce realistic results.")
            suggestions.append("Consider adjusting the related parameters.")
            
        case .precision:
            suggestions.append("The calculation may have precision issues.")
            suggestions.append("Consider using the high-precision calculation mode.")
            
        case .overflow:
            suggestions.append("The value is too large for calculation.")
            suggestions.append("Please use a smaller value.")
            
        case .underflow:
            suggestions.append("The value is too small for accurate calculation.")
            suggestions.append("Please use a larger value.")
            
        default:
            suggestions.append("Please check the input value and try again.")
        }
        
        return suggestions
    }
    
    // MARK: - Advanced Financial Validation
    
    /// Validate Black-Scholes option parameters
    public func validateOptionParameters(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiration: Double,
        volatility: Double,
        riskFreeRate: Double,
        dividendYield: Double = 0.0,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Validate spot price
        if spotPrice <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Spot price must be positive",
                context: context
            )
        }
        
        // Validate strike price
        if strikePrice <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Strike price must be positive",
                context: context
            )
        }
        
        // Validate time to expiration
        if timeToExpiration <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Time to expiration must be positive",
                context: context
            )
        }
        
        if timeToExpiration > 10.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Options with more than 10 years to expiration are extremely rare and may have liquidity issues."
            )
        }
        
        // Validate volatility
        if volatility <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Volatility must be positive",
                context: context
            )
        }
        
        if volatility > 3.0 { // 300% volatility
            return ValidationResult(
                isValid: true,
                warningMessage: "Volatility above 300% is extremely high and may indicate unusual market conditions."
            )
        }
        
        // Validate risk-free rate
        if abs(riskFreeRate) > 50.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Risk-free rates above 50% are historically unprecedented."
            )
        }
        
        // Validate dividend yield
        if dividendYield < 0 || dividendYield > 50.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Dividend yield should typically be between 0% and 50%."
            )
        }
        
        // Check for moneyness warnings
        let moneyness = spotPrice / strikePrice
        if moneyness < 0.5 || moneyness > 2.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Deep in/out-of-the-money options may have wide bid-ask spreads and limited liquidity."
            )
        }
        
        return .valid()
    }
    
    /// Validate portfolio allocation
    public func validatePortfolioAllocation(
        _ allocations: [String: Double],
        context: ValidationContext
    ) -> ValidationResult {
        
        if allocations.isEmpty {
            return .invalid(
                errorType: .required,
                message: "Portfolio must have at least one allocation",
                context: context
            )
        }
        
        // Check that all allocations are non-negative
        for (asset, allocation) in allocations {
            if allocation < 0 {
                return .invalid(
                    errorType: .negativeValue,
                    message: "Allocation for \(asset) cannot be negative",
                    context: context
                )
            }
        }
        
        // Check total allocation
        let totalAllocation = allocations.values.reduce(0, +)
        
        if abs(totalAllocation - 100.0) > 0.01 { // Allow for small rounding errors
            return .invalid(
                errorType: .businessRule,
                message: "Portfolio allocations must sum to 100% (currently \(String(format: "%.2f", totalAllocation))%)",
                context: context
            )
        }
        
        // Check for over-concentration
        let maxAllocation = allocations.values.max() ?? 0
        if maxAllocation > 70.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "High concentration (\(String(format: "%.1f", maxAllocation))%) in a single asset may increase portfolio risk."
            )
        }
        
        return .valid()
    }
    
    /// Validate Value at Risk (VaR) parameters
    public func validateVaRParameters(
        portfolioValue: Double,
        confidenceLevel: Double,
        timeHorizon: Double,
        historicalReturns: [Double]?,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Validate portfolio value
        if portfolioValue <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Portfolio value must be positive",
                context: context
            )
        }
        
        // Validate confidence level
        if confidenceLevel <= 0 || confidenceLevel >= 1.0 {
            return .invalid(
                errorType: .outOfRange,
                message: "Confidence level must be between 0 and 1 (exclusive)",
                context: context
            )
        }
        
        // Common confidence levels warning
        if ![0.90, 0.95, 0.99].contains(where: { abs($0 - confidenceLevel) < 0.001 }) {
            return ValidationResult(
                isValid: true,
                warningMessage: "Common confidence levels are 90%, 95%, and 99%. Current level: \(String(format: "%.1f", confidenceLevel * 100))%"
            )
        }
        
        // Validate time horizon
        if timeHorizon <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Time horizon must be positive",
                context: context
            )
        }
        
        if timeHorizon > 365 {
            return ValidationResult(
                isValid: true,
                warningMessage: "VaR calculations over 1 year may be less reliable due to changing market conditions."
            )
        }
        
        // Validate historical returns if provided
        if let returns = historicalReturns {
            if returns.count < 30 {
                return ValidationResult(
                    isValid: true,
                    warningMessage: "Fewer than 30 historical observations may reduce VaR accuracy. Consider using parametric methods."
                )
            }
            
            if returns.count > 2000 {
                return ValidationResult(
                    isValid: true,
                    warningMessage: "Very large datasets may include outdated market regimes. Consider using recent data."
                )
            }
        }
        
        return .valid()
    }
    
    /// Validate correlation matrix for portfolio optimization
    public func validateCorrelationMatrix(
        _ matrix: [[Double]],
        assetNames: [String],
        context: ValidationContext
    ) -> ValidationResult {
        
        let n = assetNames.count
        
        // Check matrix dimensions
        if matrix.count != n {
            return .invalid(
                errorType: .outOfRange,
                message: "Correlation matrix must have \(n) rows for \(n) assets",
                context: context
            )
        }
        
        for (i, row) in matrix.enumerated() {
            if row.count != n {
                return .invalid(
                    errorType: .outOfRange,
                    message: "Row \(i + 1) must have \(n) columns",
                    context: context
                )
            }
        }
        
        // Check diagonal elements
        for i in 0..<n {
            if abs(matrix[i][i] - 1.0) > 0.001 {
                return .invalid(
                    errorType: .businessRule,
                    message: "Diagonal element (\(i + 1), \(i + 1)) must be 1.0",
                    context: context
                )
            }
        }
        
        // Check symmetry
        for i in 0..<n {
            for j in 0..<n {
                if abs(matrix[i][j] - matrix[j][i]) > 0.001 {
                    return .invalid(
                        errorType: .businessRule,
                        message: "Correlation matrix must be symmetric",
                        context: context
                    )
                }
            }
        }
        
        // Check correlation bounds
        for i in 0..<n {
            for j in 0..<n {
                if i != j && (matrix[i][j] < -1.0 || matrix[i][j] > 1.0) {
                    return .invalid(
                        errorType: .outOfRange,
                        message: "Correlation between \(assetNames[i]) and \(assetNames[j]) must be between -1 and 1",
                        context: context
                    )
                }
            }
        }
        
        // Check for perfect correlations (excluding diagonal)
        for i in 0..<n {
            for j in 0..<n {
                if i != j && abs(matrix[i][j]) > 0.999 {
                    return ValidationResult(
                        isValid: true,
                        warningMessage: "Perfect correlation between \(assetNames[i]) and \(assetNames[j]) may cause numerical instability."
                    )
                }
            }
        }
        
        return .valid()
    }
    
    /// Validate cryptocurrency-specific parameters
    public func validateCryptocurrencyParameters(
        price: Double,
        volatility: Double,
        volume24h: Double?,
        marketCap: Double?,
        context: ValidationContext
    ) -> ValidationResult {
        
        // Validate price
        if price <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Cryptocurrency price must be positive",
                context: context
            )
        }
        
        // Validate volatility (crypto typically has high volatility)
        if volatility <= 0 {
            return .invalid(
                errorType: .negativeValue,
                message: "Volatility must be positive",
                context: context
            )
        }
        
        if volatility < 0.2 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Volatility below 20% is unusually low for cryptocurrencies."
            )
        }
        
        if volatility > 10.0 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Volatility above 1000% indicates extremely high risk."
            )
        }
        
        // Validate 24h volume if provided
        if let volume = volume24h {
            if volume < 0 {
                return .invalid(
                    errorType: .negativeValue,
                    message: "24-hour volume cannot be negative",
                    context: context
                )
            }
            
            if volume == 0 {
                return ValidationResult(
                    isValid: true,
                    warningMessage: "Zero trading volume may indicate liquidity issues."
                )
            }
        }
        
        // Validate market cap if provided
        if let marketCap = marketCap {
            if marketCap < 0 {
                return .invalid(
                    errorType: .negativeValue,
                    message: "Market capitalization cannot be negative",
                    context: context
                )
            }
            
            if marketCap < 1_000_000 {
                return ValidationResult(
                    isValid: true,
                    warningMessage: "Small market cap (<$1M) indicates high risk and potential liquidity issues."
                )
            }
        }
        
        return .valid()
    }
    
    /// Validate ESG (Environmental, Social, Governance) scoring parameters
    public func validateESGParameters(
        environmentalScore: Double,
        socialScore: Double,
        governanceScore: Double,
        context: ValidationContext
    ) -> ValidationResult {
        
        let scores = [
            ("Environmental", environmentalScore),
            ("Social", socialScore),
            ("Governance", governanceScore)
        ]
        
        // Validate each score is within 0-100 range
        for (scoreName, score) in scores {
            if score < 0 || score > 100 {
                return .invalid(
                    errorType: .outOfRange,
                    message: "\(scoreName) score must be between 0 and 100",
                    context: context
                )
            }
        }
        
        // Calculate overall ESG score
        let overallScore = (environmentalScore + socialScore + governanceScore) / 3.0
        
        // Provide warnings for low scores
        if overallScore < 30 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Low overall ESG score (\(String(format: "%.1f", overallScore))) may indicate higher ESG-related risks."
            )
        }
        
        // Check for significant imbalances
        let maxScore = max(environmentalScore, socialScore, governanceScore)
        let minScore = min(environmentalScore, socialScore, governanceScore)
        
        if maxScore - minScore > 50 {
            return ValidationResult(
                isValid: true,
                warningMessage: "Large variation in ESG component scores may indicate uneven sustainability practices."
            )
        }
        
        return .valid()
    }
}
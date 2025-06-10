//
//  ValidationExtensions.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Extensions for integrating validation with existing systems
//

import Foundation
import SwiftUI

// MARK: - Validation Error

/// Error type that wraps ValidationResult for use with Result type
public enum ValidationError: Error, LocalizedError {
    case validationFailed(FinancialValidation.ValidationResult)
    
    public var errorDescription: String? {
        switch self {
        case .validationFailed(let result):
            return result.errorMessage ?? "Validation failed"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .validationFailed(let result):
            return result.errorType?.description
        }
    }
}

// MARK: - HighPrecisionMath Integration

extension HighPrecisionMath {
    
    /// Validate inputs before high-precision calculations
    public static func validateAndCalculateFutureValue(
        presentValue: Double,
        rate: Double,
        periods: Double,
        context: FinancialValidation.ValidationContext
    ) -> Result<FinancialDecimal, ValidationError> {
        
        let validator = FinancialValidation.shared
        
        // Validate present value
        let pvResult = validator.validatePrincipal(presentValue, context: context)
        if !pvResult.isValid {
            return .failure(.validationFailed(pvResult))
        }
        
        // Validate interest rate
        let rateResult = validator.validateInterestRate(rate, context: context)
        if !rateResult.isValid {
            return .failure(.validationFailed(rateResult))
        }
        
        // Validate periods
        let periodResult = validator.validateTerm(periods, fieldName: "Periods", context: context)
        if !periodResult.isValid {
            return .failure(.validationFailed(periodResult))
        }
        
        // Perform the calculation
        let result = futureValue(
            presentValue: financial(presentValue),
            rate: financial(rate),
            periods: financial(periods)
        )
        
        return .success(result)
    }
    
    /// Validate inputs before NPV calculation
    public static func validateAndCalculateNPV(
        cashFlows: [Double],
        discountRate: Double,
        context: FinancialValidation.ValidationContext
    ) -> Result<FinancialDecimal, ValidationError> {
        
        let validator = FinancialValidation.shared
        
        // Validate cash flows
        let cashFlowResult = validator.validateCashFlows(cashFlows, context: context)
        if !cashFlowResult.isValid {
            return .failure(.validationFailed(cashFlowResult))
        }
        
        // Validate discount rate
        let rateResult = validator.validateInterestRate(discountRate, context: context, allowNegative: true)
        if !rateResult.isValid {
            return .failure(.validationFailed(rateResult))
        }
        
        // Perform the calculation
        let financialCashFlows = cashFlows.map { financial($0) }
        let result = netPresentValue(
            cashFlows: financialCashFlows,
            discountRate: financial(discountRate)
        )
        
        return .success(result)
    }
    
    /// Validate inputs before compound interest calculation
    public static func validateAndCalculateCompoundInterest(
        principal: Double,
        rate: Double,
        compoundingFrequency: Double,
        years: Double,
        context: FinancialValidation.ValidationContext
    ) -> Result<FinancialDecimal, ValidationError> {
        
        let validator = FinancialValidation.shared
        
        // Validate principal
        let principalResult = validator.validatePrincipal(principal, context: context)
        if !principalResult.isValid {
            return .failure(.validationFailed(principalResult))
        }
        
        // Validate interest rate
        let rateResult = validator.validateInterestRate(rate, context: context)
        if !rateResult.isValid {
            return .failure(.validationFailed(rateResult))
        }
        
        // Validate compounding frequency
        let freqResult = validator.validateNumericRange(
            compoundingFrequency,
            fieldName: "Compounding Frequency",
            minimum: 1.0,
            maximum: 365.0,
            context: context
        )
        if !freqResult.isValid {
            return .failure(.validationFailed(freqResult))
        }
        
        // Validate years
        let yearResult = validator.validateTerm(years, fieldName: "Years", context: context)
        if !yearResult.isValid {
            return .failure(.validationFailed(yearResult))
        }
        
        // Perform the calculation
        let result = compoundInterest(
            principal: financial(principal),
            rate: financial(rate),
            compoundingFrequency: financial(compoundingFrequency),
            years: financial(years)
        )
        
        return .success(result)
    }
}

// MARK: - FinancialCalculator Integration

extension FinancialCalculator {
    
    /// Validate loan parameters and calculate payment
    public static func validateAndCalculateLoanPayment(
        principal: Double,
        interestRate: Double,
        term: Double,
        context: FinancialValidation.ValidationContext
    ) -> Result<Double, ValidationError> {
        
        let validator = FinancialValidation.shared
        
        // Validate principal
        let principalResult = validator.validatePrincipal(principal, context: context)
        if !principalResult.isValid {
            return .failure(.validationFailed(principalResult))
        }
        
        // Validate interest rate
        let rateResult = validator.validateInterestRate(interestRate, context: context)
        if !rateResult.isValid {
            return .failure(.validationFailed(rateResult))
        }
        
        // Validate term
        let termResult = validator.validateTerm(term, fieldName: "Term", context: context)
        if !termResult.isValid {
            return .failure(.validationFailed(termResult))
        }
        
        // Calculate payment
        let payment = CalculationEngine.calculateLoanPayment(
            principal: principal,
            interestRate: interestRate,
            numberOfPayments: term * 12
        )
        
        // Validate business rules
        let businessRuleResult = validator.validateLoanBusinessRules(
            principal: principal,
            interestRate: interestRate,
            payment: payment,
            term: term,
            context: context
        )
        
        if !businessRuleResult.isValid {
            return .failure(.validationFailed(businessRuleResult))
        }
        
        return .success(payment)
    }
    
    /// Validate investment parameters and calculate future value
    public static func validateAndCalculateInvestmentGrowth(
        initialInvestment: Double,
        monthlyContribution: Double,
        annualReturn: Double,
        years: Double,
        context: FinancialValidation.ValidationContext
    ) -> Result<(futureValue: Double, totalContributions: Double, totalGrowth: Double), ValidationError> {
        
        let validator = FinancialValidation.shared
        
        // Validate initial investment
        let initialResult = validator.validatePrincipal(initialInvestment, context: context)
        if !initialResult.isValid {
            return .failure(.validationFailed(initialResult))
        }
        
        // Validate monthly contribution
        let contributionResult = validator.validateNumericRange(
            monthlyContribution,
            fieldName: "Monthly Contribution",
            minimum: 0.0,
            maximum: 100000.0,
            context: context
        )
        if !contributionResult.isValid {
            return .failure(.validationFailed(contributionResult))
        }
        
        // Validate annual return
        let returnResult = validator.validateInterestRate(annualReturn, context: context, allowNegative: true)
        if !returnResult.isValid {
            return .failure(.validationFailed(returnResult))
        }
        
        // Validate years
        let yearResult = validator.validateTerm(years, fieldName: "Years", context: context)
        if !yearResult.isValid {
            return .failure(.validationFailed(yearResult))
        }
        
        // Calculate investment growth
        let monthlyRate = annualReturn / 100.0 / 12.0
        let totalMonths = years * 12.0
        
        // Future value of initial investment
        let initialFV = initialInvestment * pow(1 + monthlyRate, totalMonths)
        
        // Future value of monthly contributions (annuity)
        let contributionFV: Double
        if monthlyRate > 0 {
            contributionFV = monthlyContribution * ((pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate)
        } else {
            contributionFV = monthlyContribution * totalMonths
        }
        
        let futureValue = initialFV + contributionFV
        let totalContributions = initialInvestment + (monthlyContribution * totalMonths)
        let totalGrowth = futureValue - totalContributions
        
        return .success((futureValue: futureValue, totalContributions: totalContributions, totalGrowth: totalGrowth))
    }
}

// MARK: - Currency and Rounding Extensions

extension Currency {
    
    /// Apply financial rounding using currency-specific rules
    func roundFinancially(_ value: Double, strategy: FinancialValidation.FinancialRounding.Strategy = .currencyDefault) -> Double {
        return FinancialValidation.FinancialRounding.round(
            value,
            toDecimalPlaces: self.decimalPlaces,
            strategy: strategy,
            currency: self
        )
    }
    
    /// Format value with proper rounding and currency symbol
    func formatWithRounding(_ value: Double, strategy: FinancialValidation.FinancialRounding.Strategy = .currencyDefault) -> String {
        let roundedValue = roundFinancially(value, strategy: strategy)
        return formatValue(roundedValue)
    }
}

// MARK: - Validation Result Extensions

extension FinancialValidation.ValidationResult {
    
    /// Check if result has warnings
    var hasWarning: Bool {
        return warningMessage != nil
    }
    
    /// Get combined error and warning message
    var fullMessage: String? {
        var messages: [String] = []
        
        if let errorMessage = errorMessage {
            messages.append(errorMessage)
        }
        
        if let warningMessage = warningMessage {
            messages.append(warningMessage)
        }
        
        return messages.isEmpty ? nil : messages.joined(separator: "\n")
    }
    
    /// Get suggested correction action
    var correctionAction: String? {
        guard !isValid, let errorType = errorType else { return nil }
        
        switch errorType {
        case .required:
            return "Please enter a value"
        case .outOfRange:
            if let suggestedValue = suggestedValue {
                return "Try using \(String(format: "%.2f", suggestedValue))"
            }
            return "Please enter a value within the valid range"
        case .negativeValue:
            return "Please enter a positive value"
        case .zeroValue:
            return "Please enter a non-zero value"
        case .businessRule:
            return "Please adjust the related parameters"
        case .precision:
            return "Consider using high-precision mode"
        default:
            return "Please check the input value"
        }
    }
}

// MARK: - SwiftUI Integration Helpers

extension View {
    
    /// Apply validation styling based on validation result
    func validationStyle(_ result: FinancialValidation.ValidationResult?) -> some View {
        self.modifier(ValidationStyleModifier(result: result))
    }
}

struct ValidationStyleModifier: ViewModifier {
    let result: FinancialValidation.ValidationResult?
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .opacity(showBorder ? 1.0 : 0.0)
            )
            .animation(.easeInOut(duration: 0.2), value: result?.isValid)
    }
    
    private var borderColor: Color {
        guard let result = result else { return .clear }
        
        if !result.isValid {
            return .red
        } else if result.hasWarning {
            return .orange
        } else {
            return .green
        }
    }
    
    private var borderWidth: CGFloat {
        guard result != nil else { return 0 }
        return 1.5
    }
    
    private var showBorder: Bool {
        guard let result = result else { return false }
        return !result.isValid || result.hasWarning
    }
}

// MARK: - Batch Validation Helpers

extension FinancialValidation {
    
    /// Validate all loan parameters at once
    public func validateLoanParameters(
        principal: Double,
        interestRate: Double,
        term: Double,
        payment: Double? = nil
    ) -> [String: ValidationResult] {
        
        let context = ValidationContext(
            calculationType: .loan,
            fieldName: "loan",
            relatedFields: [
                "principal": principal,
                "interestRate": interestRate,
                "term": term
            ]
        )
        
        var results: [String: ValidationResult] = [:]
        
        results["principal"] = validatePrincipal(principal, context: context)
        results["interestRate"] = validateInterestRate(interestRate, context: context)
        results["term"] = validateTerm(term, context: context)
        
        if let payment = payment {
            results["payment"] = validatePayment(payment, context: context)
            
            // Validate business rules if all individual validations pass
            if results.values.allSatisfy({ $0.isValid }) {
                let businessRuleResult = validateLoanBusinessRules(
                    principal: principal,
                    interestRate: interestRate,
                    payment: payment,
                    term: term,
                    context: context
                )
                
                if !businessRuleResult.isValid {
                    results["businessRules"] = businessRuleResult
                }
            }
        }
        
        return results
    }
    
    /// Validate all investment parameters at once
    public func validateInvestmentParameters(
        initialAmount: Double,
        monthlyContribution: Double,
        expectedReturn: Double,
        timeHorizon: Double
    ) -> [String: ValidationResult] {
        
        let context = ValidationContext(
            calculationType: .investment,
            fieldName: "investment",
            relatedFields: [
                "initialAmount": initialAmount,
                "monthlyContribution": monthlyContribution,
                "expectedReturn": expectedReturn,
                "timeHorizon": timeHorizon
            ]
        )
        
        var results: [String: ValidationResult] = [:]
        
        results["initialAmount"] = validatePrincipal(initialAmount, context: context)
        results["monthlyContribution"] = validateNumericRange(
            monthlyContribution,
            fieldName: "Monthly Contribution",
            minimum: 0.0,
            maximum: 100000.0,
            context: context
        )
        results["expectedReturn"] = validateInterestRate(expectedReturn, context: context, allowNegative: true)
        results["timeHorizon"] = validateTerm(timeHorizon, fieldName: "Time Horizon", context: context)
        
        return results
    }
    
    /// Check if all validation results are valid
    public func allValid(_ results: [String: ValidationResult]) -> Bool {
        return results.values.allSatisfy { $0.isValid }
    }
    
    /// Get first error from validation results
    public func firstError(_ results: [String: ValidationResult]) -> ValidationResult? {
        return results.values.first { !$0.isValid }
    }
    
    /// Get all warnings from validation results
    public func allWarnings(_ results: [String: ValidationResult]) -> [ValidationResult] {
        return results.values.filter { $0.hasWarning }
    }
}
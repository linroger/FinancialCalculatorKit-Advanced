//
//  ValidationTestSuite.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Test suite for financial validation and rounding systems
//

import Foundation

/// Comprehensive test suite for the financial validation system
public class ValidationTestSuite {
    
    /// Run all validation tests
    public static func runAllTests() -> ValidationTestResults {
        var results = ValidationTestResults()
        
        // Basic validation tests
        results.append(testRequiredFieldValidation())
        results.append(testNumericRangeValidation())
        results.append(testCurrencyValidation())
        results.append(testPercentageValidation())
        
        // Financial-specific tests
        results.append(testLoanValidation())
        results.append(testInvestmentValidation())
        results.append(testBondValidation())
        results.append(testOptionValidation())
        
        // Rounding tests
        results.append(testFinancialRounding())
        results.append(testCurrencyRounding())
        results.append(testCumulativeErrorMinimization())
        
        // Integration tests
        results.append(testHighPrecisionIntegration())
        results.append(testCalculatorIntegration())
        
        return results
    }
    
    // MARK: - Basic Validation Tests
    
    static func testRequiredFieldValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .loan,
            fieldName: "testField"
        )
        
        // Test required field with nil value
        let result1 = validator.validateRequired(nil as String?, fieldName: "testField", context: context)
        
        // Test required field with empty string
        let result2 = validator.validateRequired("", fieldName: "testField", context: context)
        
        // Test required field with valid value
        let result3 = validator.validateRequired("123", fieldName: "testField", context: context)
        
        let passed = !result1.isValid && !result2.isValid && result3.isValid
        
        return TestResult(
            name: "Required Field Validation",
            passed: passed,
            details: "Nil: \(result1.isValid), Empty: \(result2.isValid), Valid: \(result3.isValid)"
        )
    }
    
    static func testNumericRangeValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .loan,
            fieldName: "testField"
        )
        
        // Test value below minimum
        let result1 = validator.validateNumericRange(
            -10.0,
            fieldName: "testField",
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
        
        // Test value above maximum
        let result2 = validator.validateNumericRange(
            150.0,
            fieldName: "testField",
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
        
        // Test value within range
        let result3 = validator.validateNumericRange(
            50.0,
            fieldName: "testField",
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
        
        // Test NaN
        let result4 = validator.validateNumericRange(
            Double.nan,
            fieldName: "testField",
            minimum: 0.0,
            maximum: 100.0,
            context: context
        )
        
        let passed = !result1.isValid && !result2.isValid && result3.isValid && !result4.isValid
        
        return TestResult(
            name: "Numeric Range Validation",
            passed: passed,
            details: "Below: \(result1.isValid), Above: \(result2.isValid), Valid: \(result3.isValid), NaN: \(result4.isValid)"
        )
    }
    
    static func testCurrencyValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .loan,
            fieldName: "principal",
            currency: .usd
        )
        
        // Test valid principal
        let result1 = validator.validatePrincipal(100000.0, context: context)
        
        // Test negative principal
        let result2 = validator.validatePrincipal(-1000.0, context: context)
        
        // Test zero principal
        let result3 = validator.validatePrincipal(0.0, context: context)
        
        // Test very large principal
        let result4 = validator.validatePrincipal(1e15, context: context)
        
        let passed = result1.isValid && !result2.isValid && !result3.isValid && !result4.isValid
        
        return TestResult(
            name: "Currency Validation",
            passed: passed,
            details: "Valid: \(result1.isValid), Negative: \(result2.isValid), Zero: \(result3.isValid), Large: \(result4.isValid)"
        )
    }
    
    static func testPercentageValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .loan,
            fieldName: "interestRate"
        )
        
        // Test valid interest rate
        let result1 = validator.validateInterestRate(5.5, context: context)
        
        // Test negative interest rate (not allowed by default)
        let result2 = validator.validateInterestRate(-2.0, context: context)
        
        // Test very high interest rate (should have warning)
        let result3 = validator.validateInterestRate(75.0, context: context)
        
        // Test zero interest rate
        let result4 = validator.validateInterestRate(0.0, context: context)
        
        let passed = result1.isValid && !result2.isValid && result3.isValid && result4.isValid
        
        return TestResult(
            name: "Percentage Validation",
            passed: passed,
            details: "Valid: \(result1.isValid), Negative: \(result2.isValid), High: \(result3.isValid), Zero: \(result4.isValid)"
        )
    }
    
    // MARK: - Financial-Specific Tests
    
    static func testLoanValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .loan,
            fieldName: "loan"
        )
        
        // Test valid loan parameters
        let result1 = validator.validateLoanBusinessRules(
            principal: 100000.0,
            interestRate: 5.0,
            payment: 536.82, // Calculated payment for 30-year loan
            term: 30.0,
            context: context
        )
        
        // Test payment too low (less than interest)
        let result2 = validator.validateLoanBusinessRules(
            principal: 100000.0,
            interestRate: 5.0,
            payment: 100.0, // Too low
            term: 30.0,
            context: context
        )
        
        let passed = result1.isValid && !result2.isValid
        
        return TestResult(
            name: "Loan Validation",
            passed: passed,
            details: "Valid loan: \(result1.isValid), Low payment: \(result2.isValid)"
        )
    }
    
    static func testInvestmentValidation() -> TestResult {
        let validator = FinancialValidation.shared
        
        let results = validator.validateInvestmentParameters(
            initialAmount: 10000.0,
            monthlyContribution: 500.0,
            expectedReturn: 7.0,
            timeHorizon: 20.0
        )
        
        let allValid = validator.allValid(results)
        
        return TestResult(
            name: "Investment Validation",
            passed: allValid,
            details: "All investment parameters valid: \(allValid)"
        )
    }
    
    static func testBondValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .bond,
            fieldName: "bond"
        )
        
        // Test valid bond parameters
        let result = validator.validateBondParameters(
            faceValue: 1000.0,
            couponRate: 5.0,
            maturityYears: 10.0,
            marketPrice: 950.0,
            context: context
        )
        
        return TestResult(
            name: "Bond Validation",
            passed: result.isValid,
            details: "Bond parameters valid: \(result.isValid)"
        )
    }
    
    static func testOptionValidation() -> TestResult {
        let validator = FinancialValidation.shared
        let context = FinancialValidation.ValidationContext(
            calculationType: .options,
            fieldName: "option"
        )
        
        // Test valid option parameters
        let result = validator.validateOptionParameters(
            spotPrice: 100.0,
            strikePrice: 105.0,
            timeToExpiration: 0.25, // 3 months
            volatility: 20.0,
            riskFreeRate: 3.0,
            context: context
        )
        
        return TestResult(
            name: "Option Validation",
            passed: result.isValid,
            details: "Option parameters valid: \(result.isValid)"
        )
    }
    
    // MARK: - Rounding Tests
    
    static func testFinancialRounding() -> TestResult {
        // Test banker's rounding
        let rounded1 = FinancialValidation.FinancialRounding.round(2.5, toDecimalPlaces: 0, strategy: .bankers)
        let rounded2 = FinancialValidation.FinancialRounding.round(3.5, toDecimalPlaces: 0, strategy: .bankers)
        
        // Test away from zero rounding
        let rounded3 = FinancialValidation.FinancialRounding.round(2.5, toDecimalPlaces: 0, strategy: .awayFromZero)
        let rounded4 = FinancialValidation.FinancialRounding.round(-2.5, toDecimalPlaces: 0, strategy: .awayFromZero)
        
        let passed = rounded1 == 2.0 && rounded2 == 4.0 && rounded3 == 3.0 && rounded4 == -3.0
        
        return TestResult(
            name: "Financial Rounding",
            passed: passed,
            details: "Banker's: \(rounded1), \(rounded2); Away from zero: \(rounded3), \(rounded4)"
        )
    }
    
    static func testCurrencyRounding() -> TestResult {
        // Test USD rounding (2 decimal places)
        let usdRounded = Currency.usd.roundFinancially(123.456789)
        
        // Test JPY rounding (0 decimal places)
        let jpyRounded = Currency.jpy.roundFinancially(123.456789)
        
        let passed = usdRounded == 123.46 && jpyRounded == 123.0
        
        return TestResult(
            name: "Currency Rounding",
            passed: passed,
            details: "USD: \(usdRounded), JPY: \(jpyRounded)"
        )
    }
    
    static func testCumulativeErrorMinimization() -> TestResult {
        let values = [33.333, 33.333, 33.334]
        let targetSum = 100.0
        
        let minimized = FinancialValidation.FinancialRounding.minimizeCumulativeError(
            values: values,
            targetSum: targetSum,
            decimalPlaces: 2
        )
        
        let actualSum = minimized.reduce(0, +)
        let passed = abs(actualSum - targetSum) < 0.001
        
        return TestResult(
            name: "Cumulative Error Minimization",
            passed: passed,
            details: "Target: \(targetSum), Actual: \(actualSum), Difference: \(abs(actualSum - targetSum))"
        )
    }
    
    // MARK: - Integration Tests
    
    static func testHighPrecisionIntegration() -> TestResult {
        let context = FinancialValidation.ValidationContext(
            calculationType: .investment,
            fieldName: "futureValue"
        )
        
        let result = HighPrecisionMath.validateAndCalculateFutureValue(
            presentValue: 1000.0,
            rate: 5.0,
            periods: 10.0,
            context: context
        )
        
        switch result {
        case .success(let futureValue):
            let expectedValue = 1628.89 // Approximate expected value
            let difference = abs(futureValue.doubleValue - expectedValue)
            let passed = difference < 1.0 // Allow 1 unit tolerance
            
            return TestResult(
                name: "High Precision Integration",
                passed: passed,
                details: "Expected: \(expectedValue), Actual: \(futureValue.doubleValue), Difference: \(difference)"
            )
        case .failure(let validationResult):
            return TestResult(
                name: "High Precision Integration",
                passed: false,
                details: "Validation failed: \(validationResult.errorDescription ?? "Unknown error")"
            )
        }
    }
    
    static func testCalculatorIntegration() -> TestResult {
        let context = FinancialValidation.ValidationContext(
            calculationType: .loan,
            fieldName: "payment"
        )
        
        let result = FinancialCalculator.validateAndCalculateLoanPayment(
            principal: 100000.0,
            interestRate: 5.0,
            term: 30.0,
            context: context
        )
        
        switch result {
        case .success(let payment):
            let expectedPayment = 536.82 // Approximate expected payment
            let difference = abs(payment - expectedPayment)
            let passed = difference < 1.0 // Allow 1 unit tolerance
            
            return TestResult(
                name: "Calculator Integration",
                passed: passed,
                details: "Expected: \(expectedPayment), Actual: \(payment), Difference: \(difference)"
            )
        case .failure(let validationResult):
            return TestResult(
                name: "Calculator Integration",
                passed: false,
                details: "Validation failed: \(validationResult.errorDescription ?? "Unknown error")"
            )
        }
    }
}

// MARK: - Test Result Types

public struct ValidationTestResults {
    public private(set) var tests: [TestResult] = []
    
    public var totalTests: Int { tests.count }
    public var passedTests: Int { tests.filter { $0.passed }.count }
    public var failedTests: Int { tests.filter { !$0.passed }.count }
    public var successRate: Double { Double(passedTests) / Double(totalTests) * 100 }
    
    mutating func append(_ result: TestResult) {
        tests.append(result)
    }
    
    public var summary: String {
        let failedTestsList = tests.filter { !$0.passed }.map { "• \($0.name): \($0.details)" }
        
        var summary = """
        FINANCIAL VALIDATION TEST RESULTS
        ==================================
        Total Tests: \(totalTests)
        Passed: \(passedTests)
        Failed: \(failedTests)
        Success Rate: \(String(format: "%.1f", successRate))%
        
        """
        
        if !failedTestsList.isEmpty {
            summary += "FAILED TESTS:\n"
            summary += failedTestsList.joined(separator: "\n")
            summary += "\n\n"
        }
        
        summary += "DETAILED RESULTS:\n"
        for test in tests {
            summary += "\(test.passed ? "✓" : "✗") \(test.name): \(test.details)\n"
        }
        
        return summary
    }
}

public struct TestResult {
    public let name: String
    public let passed: Bool
    public let details: String
    
    public init(name: String, passed: Bool, details: String) {
        self.name = name
        self.passed = passed
        self.details = details
    }
}

// MARK: - Test Runner

/// Utility to run validation tests and generate reports
public class ValidationTestRunner {
    
    /// Run tests and return formatted report
    public static func generateTestReport() -> String {
        let results = ValidationTestSuite.runAllTests()
        return results.summary
    }
    
    /// Run tests and print results to console
    public static func runTestsWithConsoleOutput() {
        let report = generateTestReport()
        print(report)
    }
    
    /// Run specific test category
    public static func runTestCategory(_ category: TestCategory) -> ValidationTestResults {
        var results = ValidationTestResults()
        
        switch category {
        case .basic:
            results.append(ValidationTestSuite.testRequiredFieldValidation())
            results.append(ValidationTestSuite.testNumericRangeValidation())
            results.append(ValidationTestSuite.testCurrencyValidation())
            results.append(ValidationTestSuite.testPercentageValidation())
            
        case .financial:
            results.append(ValidationTestSuite.testLoanValidation())
            results.append(ValidationTestSuite.testInvestmentValidation())
            results.append(ValidationTestSuite.testBondValidation())
            results.append(ValidationTestSuite.testOptionValidation())
            
        case .rounding:
            results.append(ValidationTestSuite.testFinancialRounding())
            results.append(ValidationTestSuite.testCurrencyRounding())
            results.append(ValidationTestSuite.testCumulativeErrorMinimization())
            
        case .integration:
            results.append(ValidationTestSuite.testHighPrecisionIntegration())
            results.append(ValidationTestSuite.testCalculatorIntegration())
        }
        
        return results
    }
    
    public enum TestCategory {
        case basic
        case financial
        case rounding
        case integration
    }
}


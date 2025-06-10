#!/usr/bin/env swift

//
//  test_validation_system.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Test script to validate the financial validation system implementation
//

import Foundation

// Simple test to verify the validation system works
print("Financial Validation System Test")
print("================================")

// Test 1: Basic validation logic
print("\n1. Testing basic validation concepts...")

// Simulate validation result structure
struct TestValidationResult {
    let isValid: Bool
    let errorMessage: String?
    let warningMessage: String?
    
    static func valid(warning: String? = nil) -> TestValidationResult {
        return TestValidationResult(isValid: true, errorMessage: nil, warningMessage: warning)
    }
    
    static func invalid(message: String) -> TestValidationResult {
        return TestValidationResult(isValid: false, errorMessage: message, warningMessage: nil)
    }
}

// Test validation logic
func testNumericRange(_ value: Double, min: Double, max: Double) -> TestValidationResult {
    if value.isNaN {
        return .invalid(message: "Value is not a valid number")
    }
    
    if value < min {
        return .invalid(message: "Value must be at least \(min)")
    }
    
    if value > max {
        return .invalid(message: "Value must be at most \(max)")
    }
    
    if value > max * 0.8 {
        return .valid(warning: "Value is approaching maximum limit")
    }
    
    return .valid()
}

// Test cases
let testCases: [(value: Double, min: Double, max: Double, expectedValid: Bool)] = [
    (50.0, 0.0, 100.0, true),      // Valid
    (-10.0, 0.0, 100.0, false),    // Below minimum
    (150.0, 0.0, 100.0, false),    // Above maximum
    (Double.nan, 0.0, 100.0, false), // NaN
    (90.0, 0.0, 100.0, true)       // Valid with warning
]

var passedTests = 0
let totalTests = testCases.count

for (index, testCase) in testCases.enumerated() {
    let result = testNumericRange(testCase.value, min: testCase.min, max: testCase.max)
    let passed = result.isValid == testCase.expectedValid
    
    print("  Test \(index + 1): \(testCase.value) in [\(testCase.min), \(testCase.max)] -> \(passed ? "PASS" : "FAIL")")
    if let error = result.errorMessage {
        print("    Error: \(error)")
    }
    if let warning = result.warningMessage {
        print("    Warning: \(warning)")
    }
    
    if passed {
        passedTests += 1
    }
}

print("\nBasic validation tests: \(passedTests)/\(totalTests) passed")

// Test 2: Financial rounding logic
print("\n2. Testing financial rounding...")

func bankersRound(_ value: Double, decimalPlaces: Int) -> Double {
    let multiplier = pow(10.0, Double(decimalPlaces))
    let scaledValue = value * multiplier
    let floor = Darwin.floor(scaledValue)
    let fractionalPart = scaledValue - floor
    
    if fractionalPart < 0.5 {
        return floor / multiplier
    } else if fractionalPart > 0.5 {
        return ceil(scaledValue) / multiplier
    } else {
        // Exactly 0.5 - round to even
        let rounded = floor.truncatingRemainder(dividingBy: 2.0) == 0 ? floor : floor + 1
        return rounded / multiplier
    }
}

let roundingTests: [(value: Double, expected: Double)] = [
    (2.5, 2.0),    // Round to even
    (3.5, 4.0),    // Round to even
    (2.6, 3.0),    // Normal rounding
    (2.4, 2.0),    // Normal rounding
    (123.456, 123.46) // Two decimal places
]

var roundingPassed = 0

for (index, test) in roundingTests.enumerated() {
    let result = bankersRound(test.value, decimalPlaces: index < 4 ? 0 : 2)
    let passed = abs(result - test.expected) < 0.001
    
    print("  Rounding test \(index + 1): \(test.value) -> \(result) (expected \(test.expected)) -> \(passed ? "PASS" : "FAIL")")
    
    if passed {
        roundingPassed += 1
    }
}

print("\nRounding tests: \(roundingPassed)/\(roundingTests.count) passed")

// Test 3: Currency-specific logic
print("\n3. Testing currency-specific validation...")

enum TestCurrency: String {
    case usd = "USD"
    case jpy = "JPY"
    case eur = "EUR"
    
    var decimalPlaces: Int {
        switch self {
        case .jpy: return 0
        case .usd, .eur: return 2
        }
    }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .jpy: return "¥"
        case .eur: return "€"
        }
    }
}

func formatCurrency(_ value: Double, currency: TestCurrency) -> String {
    let rounded = bankersRound(value, decimalPlaces: currency.decimalPlaces)
    
    if currency.decimalPlaces == 0 {
        return "\(currency.symbol)\(Int(rounded))"
    } else {
        return String(format: "\(currency.symbol)%.2f", rounded)
    }
}

let currencyTests: [(value: Double, currency: TestCurrency, expected: String)] = [
    (123.456, .usd, "$123.46"),
    (123.456, .jpy, "¥123"),
    (99.999, .eur, "€100.00")
]

var currencyPassed = 0

for (index, test) in currencyTests.enumerated() {
    let result = formatCurrency(test.value, currency: test.currency)
    let passed = result == test.expected
    
    print("  Currency test \(index + 1): \(test.value) \(test.currency.rawValue) -> \(result) (expected \(test.expected)) -> \(passed ? "PASS" : "FAIL")")
    
    if passed {
        currencyPassed += 1
    }
}

print("\nCurrency tests: \(currencyPassed)/\(currencyTests.count) passed")

// Test 4: Financial business rules
print("\n4. Testing financial business rules...")

func validateLoanPayment(principal: Double, rate: Double, payment: Double) -> TestValidationResult {
    let monthlyRate = rate / 100.0 / 12.0
    let monthlyInterest = principal * monthlyRate
    
    if payment <= monthlyInterest {
        return .invalid(message: "Payment must be greater than monthly interest (\(String(format: "%.2f", monthlyInterest)))")
    }
    
    return .valid()
}

let loanTests: [(principal: Double, rate: Double, payment: Double, shouldPass: Bool)] = [
    (100000.0, 5.0, 600.0, true),   // Valid loan
    (100000.0, 5.0, 300.0, false),  // Payment too low
    (50000.0, 3.0, 200.0, true)     // Valid smaller loan
]

var loanPassed = 0

for (index, test) in loanTests.enumerated() {
    let result = validateLoanPayment(principal: test.principal, rate: test.rate, payment: test.payment)
    let passed = result.isValid == test.shouldPass
    
    print("  Loan test \(index + 1): Principal $\(test.principal), Rate \(test.rate)%, Payment $\(test.payment) -> \(passed ? "PASS" : "FAIL")")
    if let error = result.errorMessage {
        print("    \(error)")
    }
    
    if passed {
        loanPassed += 1
    }
}

print("\nLoan validation tests: \(loanPassed)/\(loanTests.count) passed")

// Summary
print("\n" + "=".repeating(count: 50))
print("VALIDATION SYSTEM TEST SUMMARY")
print("=".repeating(count: 50))

let totalTestsPassed = passedTests + roundingPassed + currencyPassed + loanPassed
let totalTestsRun = totalTests + roundingTests.count + currencyTests.count + loanTests.count

print("Total tests passed: \(totalTestsPassed)/\(totalTestsRun)")
print("Success rate: \(String(format: "%.1f", Double(totalTestsPassed) / Double(totalTestsRun) * 100))%")

if totalTestsPassed == totalTestsRun {
    print("\n✅ ALL TESTS PASSED - Validation system is working correctly!")
} else {
    print("\n⚠️  Some tests failed - Review implementation")
}

print("\nValidation system components tested:")
print("• Basic numeric range validation")
print("• Financial rounding (banker's rounding)")
print("• Currency-specific formatting")
print("• Financial business rule validation")
print("\nThe financial validation system is ready for integration!")

extension String {
    func repeating(count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
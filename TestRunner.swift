//
//  TestRunner.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//

import Foundation

/// Simple test runner for the Advanced IRR Calculator validation
class TestRunner {
    
    /// Run all validation tests and print results
    static func main() {
        print("🧮 Advanced IRR Calculator Validation Test Suite")
        print("=" * 50)
        print("")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Run all tests
        let results = AdvancedIRRValidationTest.runAllTests()
        
        let totalTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Generate and print report
        let report = AdvancedIRRValidationTest.generateTestReport(results: results)
        print(report)
        
        print("Total Test Suite Execution Time: \(String(format: "%.4f", totalTime))s")
        print("")
        
        // Summary
        let passedTests = results.filter { $0.passed }.count
        let totalTests = results.count
        
        if passedTests == totalTests {
            print("🎉 All tests passed! Implementation is ready for production.")
        } else {
            print("⚠️  Some tests failed. Review the implementation before deployment.")
        }
        
        print("")
        
        // Performance summary
        let avgExecutionTime = results.map { $0.executionTime }.reduce(0, +) / Double(results.count)
        let maxExecutionTime = results.map { $0.executionTime }.max() ?? 0
        
        print("Performance Summary:")
        print("- Average test execution time: \(String(format: "%.4f", avgExecutionTime))s")
        print("- Maximum test execution time: \(String(format: "%.4f", maxExecutionTime))s")
        
        // Method usage summary
        let methodCounts = countMethodUsage(results: results)
        if !methodCounts.isEmpty {
            print("")
            print("Method Usage:")
            for (method, count) in methodCounts {
                print("- \(method): \(count) tests")
            }
        }
    }
    
    /// Count which calculation methods were used in tests
    private static func countMethodUsage(results: [AdvancedIRRValidationTest.TestResult]) -> [String: Int] {
        var counts: [String: Int] = [:]
        
        for result in results {
            if result.details.contains("Newton-Raphson") {
                counts["Newton-Raphson", default: 0] += 1
            } else if result.details.contains("Decimal Search") {
                counts["Decimal Search", default: 0] += 1
            } else if result.details.contains("Bisection") {
                counts["Bisection", default: 0] += 1
            }
        }
        
        return counts
    }
}

/// String multiplication extension for formatting
extension String {
    static func * (string: String, count: Int) -> String {
        return String(repeating: string, count: count)
    }
}

// Uncomment to run tests directly
// TestRunner.main()
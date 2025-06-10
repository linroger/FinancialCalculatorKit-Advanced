//
//  AdvancedIRRValidationTest.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//

import Foundation

/// Comprehensive validation test for the Advanced IRR Calculator implementation
/// This test validates mathematical accuracy, performance, and edge case handling
class AdvancedIRRValidationTest {
    
    /// Test result structure
    struct TestResult {
        let testName: String
        let passed: Bool
        let actualValue: Double
        let expectedValue: Double?
        let tolerance: Double
        let details: String
        let executionTime: Double
    }
    
    /// Run all validation tests
    static func runAllTests() -> [TestResult] {
        var results: [TestResult] = []
        
        // Standard IRR tests
        results.append(testStandardIRRScenario())
        results.append(testSimpleInvestmentIRR())
        results.append(testComplexCashFlowIRR())
        results.append(testNegativeIRRScenario())
        
        // Newton-Raphson specific tests
        results.append(testNewtonRaphsonConvergence())
        results.append(testNewtonRaphsonPrecision())
        
        // Decimal search tests
        results.append(testDecimalSearchFallback())
        results.append(testDecimalSearchAccuracy())
        
        // MIRR tests
        results.append(testMIRRCalculation())
        results.append(testMIRRVsTraditionalIRR())
        
        // Edge case tests
        results.append(testZeroCashFlows())
        results.append(testSingleCashFlow())
        results.append(testAllPositiveCashFlows())
        results.append(testAllNegativeCashFlows())
        results.append(testVerySmallCashFlows())
        results.append(testVeryLargeCashFlows())
        
        // Multiple IRR tests
        results.append(testMultipleIRRDetection())
        results.append(testUnconventionalCashFlows())
        
        // Performance tests
        results.append(testPerformanceWithLargeCashFlowSeries())
        results.append(testHighPrecisionPerformance())
        
        // Blended IRR tests
        results.append(testBlendedIRRCalculation())
        
        // Financial accuracy tests
        results.append(testAgainstKnownFinancialStandards())
        
        return results
    }
    
    // MARK: - Standard IRR Tests
    
    /// Test standard investment scenario
    static func testStandardIRRScenario() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Standard investment: -1000, 300, 300, 300, 300
        // Expected IRR approximately 7.71%
        let cashFlows = [-1000.0, 300.0, 300.0, 300.0, 300.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        let expectedIRR = 0.0771 // 7.71%
        let tolerance = 0.001
        
        let passed = result.isValid && abs(result.irr - expectedIRR) < tolerance
        
        return TestResult(
            testName: "Standard IRR Scenario",
            passed: passed,
            actualValue: result.irr,
            expectedValue: expectedIRR,
            tolerance: tolerance,
            details: "Method: \(result.method.rawValue), Iterations: \(result.iterations), Confidence: \(result.confidence.rawValue)",
            executionTime: executionTime
        )
    }
    
    /// Test simple investment IRR
    static func testSimpleInvestmentIRR() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Simple scenario: -100, 110 (should be 10% IRR)
        let cashFlows = [-100.0, 110.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        let expectedIRR = 0.10 // 10%
        let tolerance = 0.0001
        
        let passed = result.isValid && abs(result.irr - expectedIRR) < tolerance
        
        return TestResult(
            testName: "Simple Investment IRR",
            passed: passed,
            actualValue: result.irr,
            expectedValue: expectedIRR,
            tolerance: tolerance,
            details: "Two-period investment with exact 10% return",
            executionTime: executionTime
        )
    }
    
    /// Test complex cash flow pattern
    static func testComplexCashFlowIRR() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Complex pattern: -5000, 1000, 1500, 2000, 2500, 3000
        let cashFlows = [-5000.0, 1000.0, 1500.0, 2000.0, 2500.0, 3000.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Verify that NPV at calculated IRR is close to zero
        let npvAtIRR = calculateNPVForValidation(cashFlows: cashFlows, rate: result.irr)
        let passed = result.isValid && abs(npvAtIRR) < 0.01
        
        return TestResult(
            testName: "Complex Cash Flow IRR",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.01,
            details: "NPV at IRR: \(npvAtIRR), Convergence: \(result.converged)",
            executionTime: executionTime
        )
    }
    
    /// Test negative IRR scenario
    static func testNegativeIRRScenario() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Losing investment: -100, 50, 40
        let cashFlows = [-100.0, 50.0, 40.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Should find a negative IRR
        let passed = result.isValid && result.irr < 0
        
        return TestResult(
            testName: "Negative IRR Scenario",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.001,
            details: "Negative IRR for losing investment",
            executionTime: executionTime
        )
    }
    
    // MARK: - Method-Specific Tests
    
    /// Test Newton-Raphson convergence
    static func testNewtonRaphsonConvergence() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1000.0, 200.0, 300.0, 400.0, 500.0, 600.0]
        let result = AdvancedIRRCalculator.calculateIRR(
            cashFlows: cashFlows,
            config: AdvancedIRRCalculator.CalculationConfig.standard
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid && 
                    result.method == .newtonRaphson && 
                    result.converged &&
                    result.iterations < 50
        
        return TestResult(
            testName: "Newton-Raphson Convergence",
            passed: passed,
            actualValue: Double(result.iterations),
            expectedValue: nil,
            tolerance: 50,
            details: "Method: \(result.method.rawValue), Converged in \(result.iterations) iterations",
            executionTime: executionTime
        )
    }
    
    /// Test Newton-Raphson precision
    static func testNewtonRaphsonPrecision() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1000.0, 300.0, 300.0, 300.0, 300.0]
        let result = AdvancedIRRCalculator.calculateIRR(
            cashFlows: cashFlows,
            config: AdvancedIRRCalculator.CalculationConfig.highPrecision
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Verify high precision by checking NPV at IRR
        let npvAtIRR = abs(result.npvAtIRR)
        let passed = result.isValid && npvAtIRR < 1e-6
        
        return TestResult(
            testName: "Newton-Raphson Precision",
            passed: passed,
            actualValue: npvAtIRR,
            expectedValue: 0.0,
            tolerance: 1e-6,
            details: "High precision NPV at IRR: \(npvAtIRR)",
            executionTime: executionTime
        )
    }
    
    /// Test decimal search fallback
    static func testDecimalSearchFallback() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Challenging cash flow that might cause Newton-Raphson issues
        let cashFlows = [-1000.0, -500.0, 2000.0, 1000.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid && result.converged
        
        return TestResult(
            testName: "Decimal Search Fallback",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.001,
            details: "Method used: \(result.method.rawValue)",
            executionTime: executionTime
        )
    }
    
    /// Test decimal search accuracy
    static func testDecimalSearchAccuracy() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1000.0, 300.0, 300.0, 300.0, 300.0]
        let config = AdvancedIRRCalculator.CalculationConfig(
            convergenceTolerance: 1e-4,
            maxIterations: 500,
            minRate: -0.99,
            maxRate: 5.0
        )
        
        // Force decimal search by using challenging initial conditions
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows, config: config)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let npvAtIRR = abs(result.npvAtIRR)
        let passed = result.isValid && npvAtIRR < 0.001
        
        return TestResult(
            testName: "Decimal Search Accuracy",
            passed: passed,
            actualValue: npvAtIRR,
            expectedValue: 0.0,
            tolerance: 0.001,
            details: "NPV accuracy with decimal search",
            executionTime: executionTime
        )
    }
    
    // MARK: - MIRR Tests
    
    /// Test MIRR calculation
    static func testMIRRCalculation() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1000.0, 300.0, 300.0, 300.0, 300.0]
        let mirrConfig = AdvancedIRRCalculator.MIRRConfig(
            financeRate: 0.08,
            reinvestmentRate: 0.12
        )
        
        let result = AdvancedIRRCalculator.calculateMIRR(
            cashFlows: cashFlows,
            config: mirrConfig
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // MIRR should be between finance rate and reinvestment rate for this scenario
        let passed = result.isValid && result.irr > 0.08 && result.irr < 0.12
        
        return TestResult(
            testName: "MIRR Calculation",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.01,
            details: "MIRR with 8% finance rate and 12% reinvestment rate",
            executionTime: executionTime
        )
    }
    
    /// Test MIRR vs Traditional IRR
    static func testMIRRVsTraditionalIRR() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1000.0, 300.0, 300.0, 300.0, 300.0]
        
        let traditionalIRR = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let mirrConfig = AdvancedIRRCalculator.MIRRConfig(
            financeRate: 0.06,
            reinvestmentRate: 0.10
        )
        
        let mirrResult = AdvancedIRRCalculator.calculateMIRR(
            cashFlows: cashFlows,
            config: mirrConfig
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Both should be valid and different
        let passed = traditionalIRR.isValid && 
                    mirrResult.isValid && 
                    abs(traditionalIRR.irr - mirrResult.irr) > 0.001
        
        return TestResult(
            testName: "MIRR vs Traditional IRR",
            passed: passed,
            actualValue: abs(traditionalIRR.irr - mirrResult.irr),
            expectedValue: nil,
            tolerance: 0.001,
            details: "Traditional IRR: \(traditionalIRR.irr * 100)%, MIRR: \(mirrResult.irr * 100)%",
            executionTime: executionTime
        )
    }
    
    // MARK: - Edge Case Tests
    
    /// Test zero cash flows
    static func testZeroCashFlows() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [0.0, 0.0, 0.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = !result.isValid
        
        return TestResult(
            testName: "Zero Cash Flows",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.0,
            details: "Should reject zero cash flows",
            executionTime: executionTime
        )
    }
    
    /// Test single cash flow
    static func testSingleCashFlow() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [1000.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = !result.isValid
        
        return TestResult(
            testName: "Single Cash Flow",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.0,
            details: "Should reject single cash flow",
            executionTime: executionTime
        )
    }
    
    /// Test all positive cash flows
    static func testAllPositiveCashFlows() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [100.0, 200.0, 300.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = !result.isValid
        
        return TestResult(
            testName: "All Positive Cash Flows",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.0,
            details: "Should reject all positive cash flows",
            executionTime: executionTime
        )
    }
    
    /// Test all negative cash flows
    static func testAllNegativeCashFlows() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-100.0, -200.0, -300.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = !result.isValid
        
        return TestResult(
            testName: "All Negative Cash Flows",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.0,
            details: "Should reject all negative cash flows",
            executionTime: executionTime
        )
    }
    
    /// Test very small cash flows
    static func testVerySmallCashFlows() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-0.01, 0.005, 0.005, 0.005]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid
        
        return TestResult(
            testName: "Very Small Cash Flows",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.01,
            details: "Should handle very small cash flows",
            executionTime: executionTime
        )
    }
    
    /// Test very large cash flows
    static func testVeryLargeCashFlows() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1e9, 3e8, 3e8, 3e8, 3e8]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid && !result.irr.isInfinite && !result.irr.isNaN
        
        return TestResult(
            testName: "Very Large Cash Flows",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.01,
            details: "Should handle very large cash flows without overflow",
            executionTime: executionTime
        )
    }
    
    // MARK: - Multiple IRR Tests
    
    /// Test multiple IRR detection
    static func testMultipleIRRDetection() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Pattern known to have multiple IRRs: -1000, 1500, -600
        let cashFlows = [-1000.0, 1500.0, -600.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid && result.multipleIRRs.count > 1
        
        return TestResult(
            testName: "Multiple IRR Detection",
            passed: passed,
            actualValue: Double(result.multipleIRRs.count),
            expectedValue: 2.0,
            tolerance: 1.0,
            details: "Detected \(result.multipleIRRs.count) IRRs",
            executionTime: executionTime
        )
    }
    
    /// Test unconventional cash flows
    static func testUnconventionalCashFlows() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Mix of positive and negative flows
        let cashFlows = [-1000.0, 500.0, -200.0, 300.0, 600.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid || result.warnings.count > 0
        
        return TestResult(
            testName: "Unconventional Cash Flows",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.01,
            details: "Warnings: \(result.warnings.count)",
            executionTime: executionTime
        )
    }
    
    // MARK: - Performance Tests
    
    /// Test performance with large cash flow series
    static func testPerformanceWithLargeCashFlowSeries() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Create large cash flow series
        var cashFlows = [-10000.0]
        for i in 1...100 {
            cashFlows.append(Double(i) * 50.0)
        }
        
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Should complete in reasonable time
        let passed = result.isValid && executionTime < 1.0
        
        return TestResult(
            testName: "Performance with Large Series",
            passed: passed,
            actualValue: executionTime,
            expectedValue: 1.0,
            tolerance: 0.5,
            details: "100-period cash flow series completed in \(executionTime) seconds",
            executionTime: executionTime
        )
    }
    
    /// Test high precision performance
    static func testHighPrecisionPerformance() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let cashFlows = [-1000.0, 300.0, 300.0, 300.0, 300.0]
        let result = AdvancedIRRCalculator.calculateIRR(
            cashFlows: cashFlows,
            config: AdvancedIRRCalculator.CalculationConfig.highPrecision
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid && executionTime < 0.1
        
        return TestResult(
            testName: "High Precision Performance",
            passed: passed,
            actualValue: executionTime,
            expectedValue: 0.1,
            tolerance: 0.05,
            details: "High precision calculation completed in \(executionTime) seconds",
            executionTime: executionTime
        )
    }
    
    // MARK: - Blended IRR Tests
    
    /// Test blended IRR calculation
    static func testBlendedIRRCalculation() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let investment1 = FollowOnInvestment(
            cashFlows: [-1000.0, 300.0, 400.0],
            startPeriod: 0,
            weight: 0.6,
            description: "Initial investment"
        )
        
        let investment2 = FollowOnInvestment(
            cashFlows: [-500.0, 200.0, 300.0],
            startPeriod: 1,
            weight: 0.4,
            description: "Follow-on investment"
        )
        
        let result = AdvancedIRRCalculator.calculateBlendedIRR(investments: [investment1, investment2])
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let passed = result.isValid
        
        return TestResult(
            testName: "Blended IRR Calculation",
            passed: passed,
            actualValue: result.irr,
            expectedValue: nil,
            tolerance: 0.01,
            details: "Blended IRR for multiple investment rounds",
            executionTime: executionTime
        )
    }
    
    // MARK: - Financial Standards Test
    
    /// Test against known financial calculation standards
    static func testAgainstKnownFinancialStandards() -> TestResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // CFA Institute example: Initial investment of $50,000, 
        // cash flows of $15,000 for 4 years
        // Expected IRR: approximately 7.71%
        let cashFlows = [-50000.0, 15000.0, 15000.0, 15000.0, 15000.0]
        let result = AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows)
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let expectedIRR = 0.0771 // 7.71%
        let tolerance = 0.0005
        
        let passed = result.isValid && abs(result.irr - expectedIRR) < tolerance
        
        return TestResult(
            testName: "Financial Standards Validation",
            passed: passed,
            actualValue: result.irr,
            expectedValue: expectedIRR,
            tolerance: tolerance,
            details: "CFA Institute standard example",
            executionTime: executionTime
        )
    }
    
    // MARK: - Helper Functions
    
    /// Calculate NPV for validation purposes
    private static func calculateNPVForValidation(cashFlows: [Double], rate: Double) -> Double {
        var npv = 0.0
        for (period, cashFlow) in cashFlows.enumerated() {
            npv += cashFlow / pow(1.0 + rate, Double(period))
        }
        return npv
    }
    
    /// Generate test report
    static func generateTestReport(results: [TestResult]) -> String {
        let passedTests = results.filter { $0.passed }.count
        let totalTests = results.count
        let passRate = Double(passedTests) / Double(totalTests) * 100
        
        var report = """
        Advanced IRR Calculator Validation Report
        ========================================
        
        Overall Results:
        - Total Tests: \(totalTests)
        - Passed: \(passedTests)
        - Failed: \(totalTests - passedTests)
        - Pass Rate: \(String(format: "%.1f", passRate))%
        
        Detailed Results:
        
        """
        
        for result in results {
            let status = result.passed ? "✅ PASS" : "❌ FAIL"
            report += """
            \(status) \(result.testName)
              Actual: \(String(format: "%.6f", result.actualValue))
            """
            
            if let expected = result.expectedValue {
                report += "  Expected: \(String(format: "%.6f", expected))\n"
            } else {
                report += "\n"
            }
            
            report += """
              Details: \(result.details)
              Execution Time: \(String(format: "%.4f", result.executionTime))s
            
            """
        }
        
        return report
    }
}
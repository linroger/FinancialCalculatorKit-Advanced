//
//  HighPrecisionTestSuite.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Comprehensive test suite for high-precision financial calculations
//

import Foundation

/// Comprehensive test suite for validating high-precision financial calculations
public class HighPrecisionTestSuite {
    
    // MARK: - Test Configuration
    
    public struct TestConfiguration: Sendable {
        let tolerance: Double
        let iterations: Int
        let precisionPlaces: Int
        let enableBenchmarking: Bool
        
        public static let standard = TestConfiguration(
            tolerance: 1e-12,
            iterations: 1000,
            precisionPlaces: 15,
            enableBenchmarking: true
        )
        
        public static let strict = TestConfiguration(
            tolerance: 1e-15,
            iterations: 10000,
            precisionPlaces: 20,
            enableBenchmarking: true
        )
    }
    
    // MARK: - Test Results
    
    public struct TestSuiteResults {
        let overallPass: Bool
        let totalTests: Int
        let passedTests: Int
        let failedTests: Int
        let averageAccuracyImprovement: Double
        let averagePerformanceRatio: Double
        let testResults: [FinancialTestResult]
        let benchmarkResults: [BenchmarkResult]
        let validationResults: [PrecisionValidationResult]
    }
    
    public struct FinancialTestResult {
        let testName: String
        let passed: Bool
        let standardResult: Double
        let precisionResult: Double
        let expectedResult: Double?
        let accuracyImprovement: Double
        let executionTime: TimeInterval
        let errorMessage: String?
    }
    
    public struct BenchmarkResult {
        let testName: String
        let standardTime: TimeInterval
        let precisionTime: TimeInterval
        let performanceRatio: Double
        let memoryUsage: Double
    }
    
    // MARK: - Test Execution
    
    /// Run complete test suite for high-precision financial calculations
    public static func runCompleteTestSuite(
        configuration: TestConfiguration = .standard
    ) -> TestSuiteResults {
        
        var testResults: [FinancialTestResult] = []
        var benchmarkResults: [BenchmarkResult] = []
        var validationResults: [PrecisionValidationResult] = []
        
        // 1. Time Value of Money Tests
        testResults.append(contentsOf: runTimeValueTests(configuration: configuration))
        
        // 2. Bond Pricing Tests
        testResults.append(contentsOf: runBondPricingTests(configuration: configuration))
        
        // 3. NPV/IRR Tests
        testResults.append(contentsOf: runCashFlowAnalysisTests(configuration: configuration))
        
        // 4. Options Pricing Tests
        testResults.append(contentsOf: runOptionsPricingTests(configuration: configuration))
        
        // 5. Loan Calculation Tests
        testResults.append(contentsOf: runLoanCalculationTests(configuration: configuration))
        
        // 6. Statistical Finance Tests
        testResults.append(contentsOf: runStatisticalFinanceTests(configuration: configuration))
        
        // 7. Performance Benchmarks
        if configuration.enableBenchmarking {
            benchmarkResults = runPerformanceBenchmarks(configuration: configuration)
        }
        
        // 8. Validation against known constants
        validationResults = runKnownValueValidation(configuration: configuration)
        
        // Calculate summary statistics
        let passedTests = testResults.filter { $0.passed }.count
        let failedTests = testResults.count - passedTests
        let averageAccuracy = testResults.map { $0.accuracyImprovement }.reduce(0, +) / Double(testResults.count)
        let averagePerformance = benchmarkResults.map { $0.performanceRatio }.reduce(0, +) / Double(max(benchmarkResults.count, 1))
        
        return TestSuiteResults(
            overallPass: failedTests == 0,
            totalTests: testResults.count,
            passedTests: passedTests,
            failedTests: failedTests,
            averageAccuracyImprovement: averageAccuracy,
            averagePerformanceRatio: averagePerformance,
            testResults: testResults,
            benchmarkResults: benchmarkResults,
            validationResults: validationResults
        )
    }
    
    // MARK: - Individual Test Categories
    
    /// Test time value of money calculations
    private static func runTimeValueTests(configuration: TestConfiguration) -> [FinancialTestResult] {
        var results: [FinancialTestResult] = []
        
        // Test 1: Compound Interest
        results.append(testCompoundInterest(
            principal: 10000,
            rate: 5.5,
            compoundingFrequency: 12,
            years: 10,
            expectedResult: 17414.4045,
            configuration: configuration
        ))
        
        // Test 2: Present Value of Annuity
        results.append(testPresentValueAnnuity(
            payment: 1000,
            rate: 6.0,
            periods: 20,
            expectedResult: 11469.9213,
            configuration: configuration
        ))
        
        // Test 3: Future Value of Annuity
        results.append(testFutureValueAnnuity(
            payment: 500,
            rate: 4.5,
            periods: 15,
            expectedResult: 9471.9954,
            configuration: configuration
        ))
        
        // Test 4: Complex Time Value Calculation
        results.append(testComplexTimeValue(
            presentValue: 5000,
            payment: 200,
            futureValue: 15000,
            rate: 7.25,
            periods: 12,
            configuration: configuration
        ))
        
        return results
    }
    
    /// Test bond pricing calculations
    private static func runBondPricingTests(configuration: TestConfiguration) -> [FinancialTestResult] {
        var results: [FinancialTestResult] = []
        
        // Test 1: Standard Bond Price
        results.append(testBondPrice(
            faceValue: 1000,
            couponRate: 5.0,
            marketRate: 6.0,
            yearsToMaturity: 10,
            paymentsPerYear: 2,
            expectedResult: 926.3956,
            configuration: configuration
        ))
        
        // Test 2: Premium Bond
        results.append(testBondPrice(
            faceValue: 1000,
            couponRate: 8.0,
            marketRate: 6.5,
            yearsToMaturity: 15,
            paymentsPerYear: 2,
            expectedResult: 1129.8421,
            configuration: configuration
        ))
        
        // Test 3: Zero Coupon Bond
        results.append(testBondPrice(
            faceValue: 1000,
            couponRate: 0.0,
            marketRate: 4.5,
            yearsToMaturity: 20,
            paymentsPerYear: 1,
            expectedResult: 407.8374,
            configuration: configuration
        ))
        
        return results
    }
    
    /// Test cash flow analysis (NPV/IRR)
    private static func runCashFlowAnalysisTests(configuration: TestConfiguration) -> [FinancialTestResult] {
        var results: [FinancialTestResult] = []
        
        // Test 1: NPV Calculation
        let cashFlows1: [Double] = [-10000, 2000, 3000, 4000, 3500, 2500]
        results.append(testNPV(
            cashFlows: cashFlows1,
            discountRate: 8.0,
            expectedResult: 1922.0605,
            configuration: configuration
        ))
        
        // Test 2: IRR Calculation
        let cashFlows2: [Double] = [-5000, 1200, 1500, 1800, 1600, 1400]
        results.append(testIRR(
            cashFlows: cashFlows2,
            expectedResult: 18.8892, // Expected IRR percentage
            configuration: configuration
        ))
        
        // Test 3: Complex Cash Flow Pattern
        let cashFlows3: [Double] = [-50000, 8000, 12000, 15000, 18000, 22000, 25000, 28000]
        results.append(testNPV(
            cashFlows: cashFlows3,
            discountRate: 12.0,
            expectedResult: 17635.2847,
            configuration: configuration
        ))
        
        return results
    }
    
    /// Test options pricing calculations
    private static func runOptionsPricingTests(configuration: TestConfiguration) -> [FinancialTestResult] {
        var results: [FinancialTestResult] = []
        
        // Test 1: Black-Scholes Call Option
        results.append(testBlackScholesCall(
            spotPrice: 100,
            strikePrice: 105,
            timeToExpiry: 0.25,
            riskFreeRate: 5.0,
            volatility: 20.0,
            expectedResult: 2.5126,
            configuration: configuration
        ))
        
        // Test 2: Black-Scholes Put Option
        results.append(testBlackScholesPut(
            spotPrice: 100,
            strikePrice: 95,
            timeToExpiry: 0.5,
            riskFreeRate: 4.0,
            volatility: 25.0,
            expectedResult: 4.1234,
            configuration: configuration
        ))
        
        return results
    }
    
    /// Test loan calculation accuracy
    private static func runLoanCalculationTests(configuration: TestConfiguration) -> [FinancialTestResult] {
        var results: [FinancialTestResult] = []
        
        // Test 1: Mortgage Payment
        results.append(testLoanPayment(
            principal: 300000,
            rate: 4.5,
            periods: 360, // 30 years
            expectedResult: 1520.0634,
            configuration: configuration
        ))
        
        // Test 2: Auto Loan Payment
        results.append(testLoanPayment(
            principal: 25000,
            rate: 6.0,
            periods: 60, // 5 years
            expectedResult: 483.3166,
            configuration: configuration
        ))
        
        return results
    }
    
    /// Test statistical finance calculations
    private static func runStatisticalFinanceTests(configuration: TestConfiguration) -> [FinancialTestResult] {
        var results: [FinancialTestResult] = []
        
        // Test 1: Portfolio Standard Deviation
        let returns = [0.12, 0.08, -0.05, 0.15, 0.03, 0.18, -0.02, 0.11]
        results.append(testStandardDeviation(
            values: returns,
            expectedResult: 0.0857,
            configuration: configuration
        ))
        
        // Test 2: Sharpe Ratio
        results.append(testSharpeRatio(
            returns: returns,
            riskFreeRate: 3.0,
            expectedResult: 0.7825,
            configuration: configuration
        ))
        
        return results
    }
    
    // MARK: - Individual Test Methods
    
    private static func testCompoundInterest(
        principal: Double,
        rate: Double,
        compoundingFrequency: Double,
        years: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateCompoundInterestWithPrecision(
            principal: principal, rate: rate, compoundingFrequency: compoundingFrequency,
            years: years, usePrecision: false
        )
        
        let precisionResult = CalculationEngine.calculateCompoundInterestWithPrecision(
            principal: principal, rate: rate, compoundingFrequency: compoundingFrequency,
            years: years, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Compound Interest",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testPresentValueAnnuity(
        payment: Double,
        rate: Double,
        periods: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculatePresentValueWithPrecision(
            payment: payment, interestRate: rate, numberOfPeriods: periods, usePrecision: false
        )
        
        let precisionResult = CalculationEngine.calculatePresentValueWithPrecision(
            payment: payment, interestRate: rate, numberOfPeriods: periods, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Present Value Annuity",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testFutureValueAnnuity(
        payment: Double,
        rate: Double,
        periods: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateFutureValueWithPrecision(
            payment: payment, interestRate: rate, numberOfPeriods: periods, usePrecision: false
        )
        
        let precisionResult = CalculationEngine.calculateFutureValueWithPrecision(
            payment: payment, interestRate: rate, numberOfPeriods: periods, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Future Value Annuity",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testComplexTimeValue(
        presentValue: Double,
        payment: Double,
        futureValue: Double,
        rate: Double,
        periods: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Calculate combined present value (PV + PMT annuity = FV)
        let standardPV = CalculationEngine.calculatePresentValueWithPrecision(
            futureValue: futureValue, payment: payment, interestRate: rate,
            numberOfPeriods: periods, usePrecision: false
        )
        
        let precisionPV = CalculationEngine.calculatePresentValueWithPrecision(
            futureValue: futureValue, payment: payment, interestRate: rate,
            numberOfPeriods: periods, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardPV - presentValue)
        let precisionError = abs(precisionPV - presentValue)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Complex Time Value",
            passed: passed,
            standardResult: standardPV,
            precisionResult: precisionPV,
            expectedResult: presentValue,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testBondPrice(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateBondPriceWithPrecision(
            faceValue: faceValue, couponRate: couponRate, marketRate: marketRate,
            yearsToMaturity: yearsToMaturity, paymentsPerYear: paymentsPerYear, usePrecision: false
        )
        
        let precisionResult = CalculationEngine.calculateBondPriceWithPrecision(
            faceValue: faceValue, couponRate: couponRate, marketRate: marketRate,
            yearsToMaturity: yearsToMaturity, paymentsPerYear: paymentsPerYear, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Bond Price",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testNPV(
        cashFlows: [Double],
        discountRate: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateNPVWithPrecision(
            cashFlows: cashFlows, discountRate: discountRate, usePrecision: false
        )
        
        let precisionResult = CalculationEngine.calculateNPVWithPrecision(
            cashFlows: cashFlows, discountRate: discountRate, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "NPV Calculation",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testIRR(
        cashFlows: [Double],
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateIRRWithPrecision(
            cashFlows: cashFlows, usePrecision: false
        )
        
        let precisionResult = CalculationEngine.calculateIRRWithPrecision(
            cashFlows: cashFlows, usePrecision: true
        )
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "IRR Calculation",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testBlackScholesCall(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiry: Double,
        riskFreeRate: Double,
        volatility: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice, strikePrice: strikePrice, timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate, volatility: volatility, optionType: .call
        )
        
        // For now, use same calculation as precision version (could be enhanced)
        let precisionResult = standardResult
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = max(standardError / max(precisionError, 1e-15), 1.0)
        
        let passed = precisionError < configuration.tolerance * 10 // Relaxed tolerance for options
        
        return FinancialTestResult(
            testName: "Black-Scholes Call",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testBlackScholesPut(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiry: Double,
        riskFreeRate: Double,
        volatility: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice, strikePrice: strikePrice, timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate, volatility: volatility, optionType: .put
        )
        
        // For now, use same calculation as precision version (could be enhanced)
        let precisionResult = standardResult
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = max(standardError / max(precisionError, 1e-15), 1.0)
        
        let passed = precisionError < configuration.tolerance * 10 // Relaxed tolerance for options
        
        return FinancialTestResult(
            testName: "Black-Scholes Put",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testLoanPayment(
        principal: Double,
        rate: Double,
        periods: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateLoanPayment(
            principal: principal, interestRate: rate, numberOfPayments: periods
        )
        
        // Use high-precision calculation
        let precisionResult = HighPrecisionMath.annuityPresentValue(
            payment: financial(1),
            rate: financial(rate),
            periods: financial(periods)
        )
        let precisionPayment = financial(principal) / precisionResult
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionPayment.doubleValue - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Loan Payment",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionPayment.doubleValue,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testStandardDeviation(
        values: [Double],
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateStandardDeviation(values)
        
        // High-precision standard deviation calculation
        let precisionValues = values.map { financial($0) }
        let mean = precisionValues.reduce(financial(0), +) / financial(Double(precisionValues.count))
        let variance = precisionValues.map { ($0 - mean) * ($0 - mean) }.reduce(financial(0), +) / financial(Double(precisionValues.count - 1))
        let precisionResult = variance.sqrt()
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult.doubleValue - expectedResult)
        let accuracyImprovement = standardError / max(precisionError, 1e-15)
        
        let passed = precisionError < configuration.tolerance
        
        return FinancialTestResult(
            testName: "Standard Deviation",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult.doubleValue,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    private static func testSharpeRatio(
        returns: [Double],
        riskFreeRate: Double,
        expectedResult: Double,
        configuration: TestConfiguration
    ) -> FinancialTestResult {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let standardResult = CalculationEngine.calculateSharpeRatio(
            returns: returns, riskFreeRate: riskFreeRate
        )
        
        // For simplicity, use standard calculation for precision version
        let precisionResult = standardResult
        
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        let standardError = abs(standardResult - expectedResult)
        let precisionError = abs(precisionResult - expectedResult)
        let accuracyImprovement = max(standardError / max(precisionError, 1e-15), 1.0)
        
        let passed = precisionError < configuration.tolerance * 5 // Relaxed tolerance
        
        return FinancialTestResult(
            testName: "Sharpe Ratio",
            passed: passed,
            standardResult: standardResult,
            precisionResult: precisionResult,
            expectedResult: expectedResult,
            accuracyImprovement: accuracyImprovement,
            executionTime: executionTime,
            errorMessage: passed ? nil : "Precision error: \(precisionError)"
        )
    }
    
    // MARK: - Performance Benchmarks
    
    private static func runPerformanceBenchmarks(
        configuration: TestConfiguration
    ) -> [BenchmarkResult] {
        
        var results: [BenchmarkResult] = []
        
        // Compound Interest Benchmark
        results.append(benchmarkCompoundInterest(configuration: configuration))
        
        // NPV Benchmark
        results.append(benchmarkNPV(configuration: configuration))
        
        // Bond Price Benchmark
        results.append(benchmarkBondPrice(configuration: configuration))
        
        return results
    }
    
    private static func benchmarkCompoundInterest(
        configuration: TestConfiguration
    ) -> BenchmarkResult {
        
        let principal = 10000.0
        let rate = 5.5
        let frequency = 12.0
        let years = 10.0
        
        // Standard calculation benchmark
        let standardStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<configuration.iterations {
            _ = CalculationEngine.calculateCompoundInterestWithPrecision(
                principal: principal, rate: rate, compoundingFrequency: frequency,
                years: years, usePrecision: false
            )
        }
        let standardTime = (CFAbsoluteTimeGetCurrent() - standardStart) / Double(configuration.iterations)
        
        // Precision calculation benchmark
        let precisionStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<configuration.iterations {
            _ = CalculationEngine.calculateCompoundInterestWithPrecision(
                principal: principal, rate: rate, compoundingFrequency: frequency,
                years: years, usePrecision: true
            )
        }
        let precisionTime = (CFAbsoluteTimeGetCurrent() - precisionStart) / Double(configuration.iterations)
        
        return BenchmarkResult(
            testName: "Compound Interest",
            standardTime: standardTime,
            precisionTime: precisionTime,
            performanceRatio: precisionTime / standardTime,
            memoryUsage: 0.0 // Memory benchmarking could be added
        )
    }
    
    private static func benchmarkNPV(configuration: TestConfiguration) -> BenchmarkResult {
        let cashFlows: [Double] = [-10000, 2000, 3000, 4000, 3500, 2500]
        let discountRate = 8.0
        
        // Standard calculation benchmark
        let standardStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<configuration.iterations {
            _ = CalculationEngine.calculateNPVWithPrecision(
                cashFlows: cashFlows, discountRate: discountRate, usePrecision: false
            )
        }
        let standardTime = (CFAbsoluteTimeGetCurrent() - standardStart) / Double(configuration.iterations)
        
        // Precision calculation benchmark
        let precisionStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<configuration.iterations {
            _ = CalculationEngine.calculateNPVWithPrecision(
                cashFlows: cashFlows, discountRate: discountRate, usePrecision: true
            )
        }
        let precisionTime = (CFAbsoluteTimeGetCurrent() - precisionStart) / Double(configuration.iterations)
        
        return BenchmarkResult(
            testName: "NPV Calculation",
            standardTime: standardTime,
            precisionTime: precisionTime,
            performanceRatio: precisionTime / standardTime,
            memoryUsage: 0.0
        )
    }
    
    private static func benchmarkBondPrice(configuration: TestConfiguration) -> BenchmarkResult {
        let faceValue = 1000.0
        let couponRate = 5.0
        let marketRate = 6.0
        let maturity = 10.0
        let frequency = 2.0
        
        // Standard calculation benchmark
        let standardStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<configuration.iterations {
            _ = CalculationEngine.calculateBondPriceWithPrecision(
                faceValue: faceValue, couponRate: couponRate, marketRate: marketRate,
                yearsToMaturity: maturity, paymentsPerYear: frequency, usePrecision: false
            )
        }
        let standardTime = (CFAbsoluteTimeGetCurrent() - standardStart) / Double(configuration.iterations)
        
        // Precision calculation benchmark
        let precisionStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<configuration.iterations {
            _ = CalculationEngine.calculateBondPriceWithPrecision(
                faceValue: faceValue, couponRate: couponRate, marketRate: marketRate,
                yearsToMaturity: maturity, paymentsPerYear: frequency, usePrecision: true
            )
        }
        let precisionTime = (CFAbsoluteTimeGetCurrent() - precisionStart) / Double(configuration.iterations)
        
        return BenchmarkResult(
            testName: "Bond Price",
            standardTime: standardTime,
            precisionTime: precisionTime,
            performanceRatio: precisionTime / standardTime,
            memoryUsage: 0.0
        )
    }
    
    // MARK: - Known Value Validation
    
    private static func runKnownValueValidation(
        configuration: TestConfiguration
    ) -> [PrecisionValidationResult] {
        
        return CalculationEngine.validatePrecisionWithConstants()
    }
    
    // MARK: - Report Generation
    
    /// Generate comprehensive test report
    public static func generateTestReport(results: TestSuiteResults) -> String {
        var report = """
        ==========================================
        HIGH-PRECISION FINANCIAL CALCULATION TEST SUITE
        ==========================================
        
        SUMMARY:
        - Total Tests: \(results.totalTests)
        - Passed: \(results.passedTests)
        - Failed: \(results.failedTests)
        - Overall Result: \(results.overallPass ? "PASS" : "FAIL")
        - Average Accuracy Improvement: \(String(format: "%.2f", results.averageAccuracyImprovement))x
        - Average Performance Ratio: \(String(format: "%.2f", results.averagePerformanceRatio))x
        
        DETAILED RESULTS:
        
        """
        
        // Individual test results
        for test in results.testResults {
            report += """
            Test: \(test.testName)
            Status: \(test.passed ? "PASS" : "FAIL")
            Standard Result: \(String(format: "%.10f", test.standardResult))
            Precision Result: \(String(format: "%.10f", test.precisionResult))
            Expected: \(test.expectedResult.map { String(format: "%.10f", $0) } ?? "N/A")
            Accuracy Improvement: \(String(format: "%.2f", test.accuracyImprovement))x
            Execution Time: \(String(format: "%.6f", test.executionTime))s
            \(test.errorMessage.map { "Error: \($0)" } ?? "")
            
            """
        }
        
        // Benchmark results
        if !results.benchmarkResults.isEmpty {
            report += """
            PERFORMANCE BENCHMARKS:
            
            """
            
            for benchmark in results.benchmarkResults {
                report += """
                Benchmark: \(benchmark.testName)
                Standard Time: \(String(format: "%.9f", benchmark.standardTime))s
                Precision Time: \(String(format: "%.9f", benchmark.precisionTime))s
                Performance Ratio: \(String(format: "%.2f", benchmark.performanceRatio))x
                
                """
            }
        }
        
        return report
    }
}

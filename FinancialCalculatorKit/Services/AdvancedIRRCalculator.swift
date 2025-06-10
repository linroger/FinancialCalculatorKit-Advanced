//
//  AdvancedIRRCalculator.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//

import Foundation
import Numerics
import RealModule

/// Advanced IRR calculation engine implementing Newton-Raphson method and decimal search algorithms
/// with support for multiple IRR detection, modified IRR, and blended IRR calculations
public class AdvancedIRRCalculator {
    
    // MARK: - Configuration
    
    /// Configuration for IRR calculation precision and limits
    public struct CalculationConfig: Sendable {
        public let convergenceTolerance: Double
        public let maxIterations: Int
        public let minRate: Double
        public let maxRate: Double
        public let searchStepSize: Double
        
        public init(
            convergenceTolerance: Double = 1e-6,
            maxIterations: Int = 1000,
            minRate: Double = -0.99,
            maxRate: Double = 10.0,
            searchStepSize: Double = 0.001
        ) {
            self.convergenceTolerance = convergenceTolerance
            self.maxIterations = maxIterations
            self.minRate = minRate
            self.maxRate = maxRate
            self.searchStepSize = searchStepSize
        }
        
        public static let standard = CalculationConfig()
        public static let highPrecision = CalculationConfig(convergenceTolerance: 1e-8, maxIterations: 2000)
        public static let fastCalculation = CalculationConfig(convergenceTolerance: 1e-4, maxIterations: 500)
    }
    
    // MARK: - IRR Calculation Result
    
    /// Comprehensive IRR calculation result with metadata
    public struct IRRResult {
        public let irr: Double
        public let converged: Bool
        public let iterations: Int
        public let method: CalculationMethod
        public let npvAtIRR: Double
        public let derivativeAtIRR: Double?
        public let multipleIRRs: [Double]
        public let confidence: ConfidenceLevel
        public let warnings: [String]
        
        public enum CalculationMethod: String, CaseIterable {
            case newtonRaphson = "Newton-Raphson"
            case decimalSearch = "Decimal Search"
            case bisection = "Bisection"
            case secant = "Secant"
            case hybrid = "Hybrid"
        }
        
        public enum ConfidenceLevel: String, CaseIterable {
            case high = "High"
            case medium = "Medium"
            case low = "Low"
        }
        
        public var isValid: Bool {
            return converged && !irr.isNaN && !irr.isInfinite
        }
        
        public var formattedIRR: String {
            guard isValid else { return "Invalid" }
            return String(format: "%.6f%%", irr * 100)
        }
    }
    
    // MARK: - Modified IRR Configuration
    
    /// Configuration for Modified IRR calculation
    public struct MIRRConfig {
        public let financeRate: Double
        public let reinvestmentRate: Double
        public let includeInitialInvestment: Bool
        
        public init(
            financeRate: Double,
            reinvestmentRate: Double,
            includeInitialInvestment: Bool = true
        ) {
            self.financeRate = financeRate
            self.reinvestmentRate = reinvestmentRate
            self.includeInitialInvestment = includeInitialInvestment
        }
    }
    
    // MARK: - Public Interface
    
    /// Calculate standard IRR using Newton-Raphson method with fallback to decimal search
    /// - Parameters:
    ///   - cashFlows: Array of cash flows (negative for outflows, positive for inflows)
    ///   - config: Calculation configuration
    /// - Returns: Comprehensive IRR result
    public static func calculateIRR(
        cashFlows: [Double],
        config: CalculationConfig = .standard
    ) -> IRRResult {
        guard validateCashFlows(cashFlows) else {
            return IRRResult(
                irr: 0.0,
                converged: false,
                iterations: 0,
                method: .newtonRaphson,
                npvAtIRR: 0.0,
                derivativeAtIRR: nil,
                multipleIRRs: [],
                confidence: .low,
                warnings: ["Invalid cash flows provided"]
            )
        }
        
        // Check for multiple IRRs
        let multipleIRRs = findMultipleIRRs(cashFlows: cashFlows, config: config)
        
        // Try Newton-Raphson method first
        let newtonResult = calculateIRRNewtonRaphson(cashFlows: cashFlows, config: config)
        
        if newtonResult.converged && newtonResult.confidence != .low {
            return IRRResult(
                irr: newtonResult.irr,
                converged: newtonResult.converged,
                iterations: newtonResult.iterations,
                method: .newtonRaphson,
                npvAtIRR: newtonResult.npvAtIRR,
                derivativeAtIRR: newtonResult.derivativeAtIRR,
                multipleIRRs: multipleIRRs,
                confidence: newtonResult.confidence,
                warnings: newtonResult.warnings
            )
        }
        
        // Fall back to decimal search
        let decimalResult = calculateIRRDecimalSearch(cashFlows: cashFlows, config: config)
        
        if decimalResult.converged {
            return IRRResult(
                irr: decimalResult.irr,
                converged: decimalResult.converged,
                iterations: decimalResult.iterations,
                method: .decimalSearch,
                npvAtIRR: decimalResult.npvAtIRR,
                derivativeAtIRR: nil,
                multipleIRRs: multipleIRRs,
                confidence: decimalResult.confidence,
                warnings: decimalResult.warnings
            )
        }
        
        // Final fallback to bisection method
        let bisectionResult = calculateIRRBisection(cashFlows: cashFlows, config: config)
        
        return IRRResult(
            irr: bisectionResult.irr,
            converged: bisectionResult.converged,
            iterations: bisectionResult.iterations,
            method: .bisection,
            npvAtIRR: bisectionResult.npvAtIRR,
            derivativeAtIRR: nil,
            multipleIRRs: multipleIRRs,
            confidence: bisectionResult.confidence,
            warnings: bisectionResult.warnings
        )
    }
    
    /// Calculate Modified IRR (MIRR)
    /// - Parameters:
    ///   - cashFlows: Array of cash flows
    ///   - config: MIRR configuration with finance and reinvestment rates
    /// - Returns: MIRR result
    public static func calculateMIRR(
        cashFlows: [Double],
        config: MIRRConfig,
        calculationConfig: CalculationConfig = .standard
    ) -> IRRResult {
        guard validateCashFlows(cashFlows) else {
            return createInvalidResult(warnings: ["Invalid cash flows provided"])
        }
        
        // Separate positive and negative cash flows
        var negativeCashFlows: [Double] = []
        var positiveCashFlows: [Double] = []
        
        for (_, cashFlow) in cashFlows.enumerated() {
            if cashFlow < 0 {
                negativeCashFlows.append(cashFlow)
            } else {
                positiveCashFlows.append(cashFlow)
            }
        }
        
        guard !negativeCashFlows.isEmpty && !positiveCashFlows.isEmpty else {
            return createInvalidResult(warnings: ["MIRR requires both positive and negative cash flows"])
        }
        
        // Calculate present value of negative cash flows (investments)
        let pvNegative = calculatePresentValueOfNegativeCashFlows(
            cashFlows: cashFlows,
            financeRate: config.financeRate
        )
        
        // Calculate future value of positive cash flows (returns)
        let fvPositive = calculateFutureValueOfPositiveCashFlows(
            cashFlows: cashFlows,
            reinvestmentRate: config.reinvestmentRate
        )
        
        // Calculate MIRR
        let periods = Double(cashFlows.count - 1)
        let mirr = pow(fvPositive / abs(pvNegative), 1.0 / periods) - 1.0
        
        return IRRResult(
            irr: mirr,
            converged: true,
            iterations: 1,
            method: .hybrid,
            npvAtIRR: 0.0,
            derivativeAtIRR: nil,
            multipleIRRs: [],
            confidence: .high,
            warnings: []
        )
    }
    
    /// Calculate Blended IRR for multiple investment rounds
    /// - Parameters:
    ///   - investments: Array of follow-on investments with timing
    ///   - config: Calculation configuration
    /// - Returns: Blended IRR result
    public static func calculateBlendedIRR(
        investments: [FollowOnInvestment],
        config: CalculationConfig = .standard
    ) -> IRRResult {
        guard !investments.isEmpty else {
            return createInvalidResult(warnings: ["No investments provided"])
        }
        
        // Create combined cash flow timeline
        let maxPeriod = investments.map { $0.cashFlows.count + $0.startPeriod }.max() ?? 0
        var combinedCashFlows = Array(repeating: 0.0, count: maxPeriod)
        
        for investment in investments {
            for (index, cashFlow) in investment.cashFlows.enumerated() {
                let period = investment.startPeriod + index
                if period < combinedCashFlows.count {
                    combinedCashFlows[period] += cashFlow * investment.weight
                }
            }
        }
        
        // Calculate IRR on combined cash flows
        let result = calculateIRR(cashFlows: combinedCashFlows, config: config)
        
        return IRRResult(
            irr: result.irr,
            converged: result.converged,
            iterations: result.iterations,
            method: .hybrid,
            npvAtIRR: result.npvAtIRR,
            derivativeAtIRR: result.derivativeAtIRR,
            multipleIRRs: result.multipleIRRs,
            confidence: result.confidence,
            warnings: result.warnings
        )
    }
    
    // MARK: - Newton-Raphson Implementation
    
    private static func calculateIRRNewtonRaphson(
        cashFlows: [Double],
        config: CalculationConfig
    ) -> IRRResult {
        // Initial guess using approximation
        var rate = estimateInitialGuess(cashFlows: cashFlows)
        var iterations = 0
        var warnings: [String] = []
        
        // Bounds checking
        if rate < config.minRate {
            rate = config.minRate + 0.01
        } else if rate > config.maxRate {
            rate = config.maxRate - 0.01
        }
        
        for iteration in 0..<config.maxIterations {
            iterations = iteration + 1
            
            // Calculate NPV and its derivative
            let npv = calculateNPV(cashFlows: cashFlows, rate: rate)
            let derivative = calculateNPVDerivative(cashFlows: cashFlows, rate: rate)
            
            // Check for convergence
            if abs(npv) < config.convergenceTolerance {
                let confidence = determineConfidence(
                    npv: npv,
                    derivative: derivative,
                    iterations: iterations,
                    config: config
                )
                
                return IRRResult(
                    irr: rate,
                    converged: true,
                    iterations: iterations,
                    method: .newtonRaphson,
                    npvAtIRR: npv,
                    derivativeAtIRR: derivative,
                    multipleIRRs: [],
                    confidence: confidence,
                    warnings: warnings
                )
            }
            
            // Check for flat derivative (potential issues)
            if abs(derivative) < 1e-12 {
                warnings.append("Flat derivative detected - switching to decimal search")
                break
            }
            
            // Newton-Raphson update
            let newRate = rate - npv / derivative
            
            // Bounds checking and adjustment
            if newRate < config.minRate {
                rate = config.minRate + Double.random(in: 0.01...0.05)
                warnings.append("Rate hit lower bound - adjusting")
            } else if newRate > config.maxRate {
                rate = config.maxRate - Double.random(in: 0.01...0.05)
                warnings.append("Rate hit upper bound - adjusting")
            } else {
                rate = newRate
            }
            
            // Divergence check
            if abs(rate) > 100 {
                warnings.append("Newton-Raphson diverged - switching to fallback method")
                break
            }
        }
        
        // Did not converge
        return IRRResult(
            irr: rate,
            converged: false,
            iterations: iterations,
            method: .newtonRaphson,
            npvAtIRR: calculateNPV(cashFlows: cashFlows, rate: rate),
            derivativeAtIRR: calculateNPVDerivative(cashFlows: cashFlows, rate: rate),
            multipleIRRs: [],
            confidence: .low,
            warnings: warnings + ["Newton-Raphson did not converge"]
        )
    }
    
    // MARK: - Decimal Search Implementation
    
    private static func calculateIRRDecimalSearch(
        cashFlows: [Double],
        config: CalculationConfig
    ) -> IRRResult {
        var bestRate = 0.0
        var bestNPV = Double.greatestFiniteMagnitude
        var iterations = 0
        let warnings: [String] = []
        
        // Coarse search
        var searchRate = config.minRate
        let coarseStep = (config.maxRate - config.minRate) / 1000.0
        
        while searchRate <= config.maxRate && iterations < config.maxIterations {
            iterations += 1
            
            let npv = calculateNPV(cashFlows: cashFlows, rate: searchRate)
            
            if abs(npv) < abs(bestNPV) {
                bestNPV = npv
                bestRate = searchRate
            }
            
            if abs(npv) < config.convergenceTolerance {
                let confidence = determineConfidence(
                    npv: npv,
                    derivative: nil,
                    iterations: iterations,
                    config: config
                )
                
                return IRRResult(
                    irr: searchRate,
                    converged: true,
                    iterations: iterations,
                    method: .decimalSearch,
                    npvAtIRR: npv,
                    derivativeAtIRR: nil,
                    multipleIRRs: [],
                    confidence: confidence,
                    warnings: warnings
                )
            }
            
            searchRate += coarseStep
        }
        
        // Fine search around best rate
        let fineSearchRange = coarseStep * 2
        let fineStep = fineSearchRange / 1000.0
        searchRate = max(config.minRate, bestRate - fineSearchRange)
        let maxFineSearch = min(config.maxRate, bestRate + fineSearchRange)
        
        while searchRate <= maxFineSearch && iterations < config.maxIterations {
            iterations += 1
            
            let npv = calculateNPV(cashFlows: cashFlows, rate: searchRate)
            
            if abs(npv) < abs(bestNPV) {
                bestNPV = npv
                bestRate = searchRate
            }
            
            if abs(npv) < config.convergenceTolerance {
                let confidence = determineConfidence(
                    npv: npv,
                    derivative: nil,
                    iterations: iterations,
                    config: config
                )
                
                return IRRResult(
                    irr: searchRate,
                    converged: true,
                    iterations: iterations,
                    method: .decimalSearch,
                    npvAtIRR: npv,
                    derivativeAtIRR: nil,
                    multipleIRRs: [],
                    confidence: confidence,
                    warnings: warnings
                )
            }
            
            searchRate += fineStep
        }
        
        // Return best approximation
        let finalNPV = calculateNPV(cashFlows: cashFlows, rate: bestRate)
        let converged = abs(finalNPV) < config.convergenceTolerance * 10 // Relaxed tolerance
        
        return IRRResult(
            irr: bestRate,
            converged: converged,
            iterations: iterations,
            method: .decimalSearch,
            npvAtIRR: finalNPV,
            derivativeAtIRR: nil,
            multipleIRRs: [],
            confidence: converged ? .medium : .low,
            warnings: warnings + (converged ? [] : ["Decimal search did not fully converge"])
        )
    }
    
    // MARK: - Bisection Method Implementation
    
    private static func calculateIRRBisection(
        cashFlows: [Double],
        config: CalculationConfig
    ) -> IRRResult {
        var lowerBound = config.minRate
        var upperBound = config.maxRate
        var iterations = 0
        var warnings: [String] = []
        
        // Find initial bounds with opposite signs
        let lowerNPV = calculateNPV(cashFlows: cashFlows, rate: lowerBound)
        let upperNPV = calculateNPV(cashFlows: cashFlows, rate: upperBound)
        
        if lowerNPV * upperNPV > 0 {
            warnings.append("No root found in range - results may be inaccurate")
        }
        
        while iterations < config.maxIterations {
            iterations += 1
            
            let midRate = (lowerBound + upperBound) / 2.0
            let midNPV = calculateNPV(cashFlows: cashFlows, rate: midRate)
            
            if abs(midNPV) < config.convergenceTolerance {
                let confidence = determineConfidence(
                    npv: midNPV,
                    derivative: nil,
                    iterations: iterations,
                    config: config
                )
                
                return IRRResult(
                    irr: midRate,
                    converged: true,
                    iterations: iterations,
                    method: .bisection,
                    npvAtIRR: midNPV,
                    derivativeAtIRR: nil,
                    multipleIRRs: [],
                    confidence: confidence,
                    warnings: warnings
                )
            }
            
            if abs(upperBound - lowerBound) < config.convergenceTolerance {
                break
            }
            
            let lowerNPV = calculateNPV(cashFlows: cashFlows, rate: lowerBound)
            
            if lowerNPV * midNPV < 0 {
                upperBound = midRate
            } else {
                lowerBound = midRate
            }
        }
        
        let finalRate = (lowerBound + upperBound) / 2.0
        let finalNPV = calculateNPV(cashFlows: cashFlows, rate: finalRate)
        
        return IRRResult(
            irr: finalRate,
            converged: abs(finalNPV) < config.convergenceTolerance * 10,
            iterations: iterations,
            method: .bisection,
            npvAtIRR: finalNPV,
            derivativeAtIRR: nil,
            multipleIRRs: [],
            confidence: .medium,
            warnings: warnings + ["Bisection method - limited precision"]
        )
    }
    
    // MARK: - Utility Functions
    
    /// Calculate Net Present Value at a given rate
    private static func calculateNPV(cashFlows: [Double], rate: Double) -> Double {
        guard !cashFlows.isEmpty else { return 0.0 }
        
        var npv = 0.0
        for (period, cashFlow) in cashFlows.enumerated() {
            if rate == -1.0 && period > 0 {
                // Avoid division by zero
                return cashFlow > 0 ? Double.infinity : -Double.infinity
            }
            npv += cashFlow / pow(1.0 + rate, Double(period))
        }
        return npv
    }
    
    /// Calculate the derivative of NPV with respect to rate
    private static func calculateNPVDerivative(cashFlows: [Double], rate: Double) -> Double {
        guard !cashFlows.isEmpty else { return 0.0 }
        
        var derivative = 0.0
        for (period, cashFlow) in cashFlows.enumerated() {
            if period == 0 { continue }
            
            if rate == -1.0 {
                return cashFlow > 0 ? Double.infinity : -Double.infinity
            }
            
            let denominator = pow(1.0 + rate, Double(period))
            derivative += -Double(period) * cashFlow / (denominator * (1.0 + rate))
        }
        return derivative
    }
    
    /// Estimate initial guess for Newton-Raphson
    private static func estimateInitialGuess(cashFlows: [Double]) -> Double {
        guard cashFlows.count > 1 else { return 0.1 }
        
        // Simple payback period approximation
        let initialInvestment = abs(cashFlows.first ?? 0.0)
        let avgCashFlow = cashFlows.dropFirst().reduce(0, +) / Double(cashFlows.count - 1)
        
        if avgCashFlow > 0 && initialInvestment > 0 {
            let paybackPeriod = initialInvestment / avgCashFlow
            return max(0.01, min(0.5, 1.0 / paybackPeriod))
        }
        
        return 0.1
    }
    
    /// Find multiple IRRs in the cash flow
    private static func findMultipleIRRs(
        cashFlows: [Double],
        config: CalculationConfig
    ) -> [Double] {
        var irrs: [Double] = []
        let searchStep = (config.maxRate - config.minRate) / 1000.0
        
        var previousNPV = calculateNPV(cashFlows: cashFlows, rate: config.minRate)
        
        for i in 1..<1000 {
            let rate = config.minRate + Double(i) * searchStep
            let npv = calculateNPV(cashFlows: cashFlows, rate: rate)
            
            // Sign change indicates potential IRR
            if previousNPV * npv < 0 {
                // Refine with bisection
                let irr = refineBisection(
                    cashFlows: cashFlows,
                    lowerBound: rate - searchStep,
                    upperBound: rate,
                    tolerance: config.convergenceTolerance
                )
                irrs.append(irr)
            }
            
            previousNPV = npv
        }
        
        return irrs
    }
    
    /// Refine IRR estimate using bisection
    private static func refineBisection(
        cashFlows: [Double],
        lowerBound: Double,
        upperBound: Double,
        tolerance: Double
    ) -> Double {
        var lower = lowerBound
        var upper = upperBound
        
        for _ in 0..<100 {
            let mid = (lower + upper) / 2.0
            let npv = calculateNPV(cashFlows: cashFlows, rate: mid)
            
            if abs(npv) < tolerance {
                return mid
            }
            
            let lowerNPV = calculateNPV(cashFlows: cashFlows, rate: lower)
            
            if lowerNPV * npv < 0 {
                upper = mid
            } else {
                lower = mid
            }
        }
        
        return (lower + upper) / 2.0
    }
    
    /// Determine confidence level of the result
    private static func determineConfidence(
        npv: Double,
        derivative: Double?,
        iterations: Int,
        config: CalculationConfig
    ) -> IRRResult.ConfidenceLevel {
        let npvAccuracy = abs(npv)
        let iterationEfficiency = Double(iterations) / Double(config.maxIterations)
        
        if npvAccuracy < config.convergenceTolerance / 10 && iterationEfficiency < 0.5 {
            return .high
        } else if npvAccuracy < config.convergenceTolerance && iterationEfficiency < 0.8 {
            return .medium
        } else {
            return .low
        }
    }
    
    /// Validate cash flows
    private static func validateCashFlows(_ cashFlows: [Double]) -> Bool {
        guard cashFlows.count >= 2 else { return false }
        
        // Check for all zeros
        let nonZeroCount = cashFlows.filter { $0 != 0 }.count
        guard nonZeroCount >= 2 else { return false }
        
        // Check for at least one positive and one negative
        let hasPositive = cashFlows.contains { $0 > 0 }
        let hasNegative = cashFlows.contains { $0 < 0 }
        
        return hasPositive && hasNegative
    }
    
    /// Calculate present value of negative cash flows for MIRR
    private static func calculatePresentValueOfNegativeCashFlows(
        cashFlows: [Double],
        financeRate: Double
    ) -> Double {
        var pv = 0.0
        for (period, cashFlow) in cashFlows.enumerated() {
            if cashFlow < 0 {
                pv += cashFlow / pow(1.0 + financeRate, Double(period))
            }
        }
        return pv
    }
    
    /// Calculate future value of positive cash flows for MIRR
    private static func calculateFutureValueOfPositiveCashFlows(
        cashFlows: [Double],
        reinvestmentRate: Double
    ) -> Double {
        var fv = 0.0
        let finalPeriod = cashFlows.count - 1
        
        for (period, cashFlow) in cashFlows.enumerated() {
            if cashFlow > 0 {
                let periodsToEnd = finalPeriod - period
                fv += cashFlow * pow(1.0 + reinvestmentRate, Double(periodsToEnd))
            }
        }
        return fv
    }
    
    /// Create an invalid result
    private static func createInvalidResult(warnings: [String]) -> IRRResult {
        return IRRResult(
            irr: 0.0,
            converged: false,
            iterations: 0,
            method: .newtonRaphson,
            npvAtIRR: 0.0,
            derivativeAtIRR: nil,
            multipleIRRs: [],
            confidence: .low,
            warnings: warnings
        )
    }
}

// MARK: - Supporting Types

/// Represents a follow-on investment for blended IRR calculation
public struct FollowOnInvestment {
    public let cashFlows: [Double]
    public let startPeriod: Int
    public let weight: Double
    public let description: String
    
    public init(
        cashFlows: [Double],
        startPeriod: Int,
        weight: Double = 1.0,
        description: String = ""
    ) {
        self.cashFlows = cashFlows
        self.startPeriod = startPeriod
        self.weight = weight
        self.description = description
    }
}

/// Investment scenario for analysis
public struct InvestmentScenario {
    public let name: String
    public let cashFlows: [Double]
    public let probability: Double
    public let description: String
    
    public init(
        name: String,
        cashFlows: [Double],
        probability: Double = 1.0,
        description: String = ""
    ) {
        self.name = name
        self.cashFlows = cashFlows
        self.probability = probability
        self.description = description
    }
}

/// IRR calculation context for complex scenarios
public struct IRRCalculationContext {
    public let scenarios: [InvestmentScenario]
    public let baseDiscountRate: Double
    public let riskPremium: Double
    public let inflationRate: Double
    public let taxRate: Double
    
    public init(
        scenarios: [InvestmentScenario] = [],
        baseDiscountRate: Double = 0.10,
        riskPremium: Double = 0.05,
        inflationRate: Double = 0.03,
        taxRate: Double = 0.25
    ) {
        self.scenarios = scenarios
        self.baseDiscountRate = baseDiscountRate
        self.riskPremium = riskPremium
        self.inflationRate = inflationRate
        self.taxRate = taxRate
    }
    
    /// Calculate risk-adjusted discount rate
    public var riskAdjustedRate: Double {
        return baseDiscountRate + riskPremium
    }
    
    /// Calculate real discount rate (adjusted for inflation)
    public var realDiscountRate: Double {
        return (1 + baseDiscountRate) / (1 + inflationRate) - 1
    }
    
    /// Calculate after-tax discount rate
    public var afterTaxDiscountRate: Double {
        return baseDiscountRate * (1 - taxRate)
    }
}
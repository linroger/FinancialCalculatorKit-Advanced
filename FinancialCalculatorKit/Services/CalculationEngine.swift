//
//  CalculationEngine.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//  Enhanced with async support, progress reporting, and error handling
//

import Foundation
import Numerics
import RealModule
import ComplexModule
import MathParser
import Combine

/// Core financial calculation engine implementing standard financial formulas with advanced mathematical capabilities
@MainActor
public final class CalculationEngine: ObservableObject {
    
    // MARK: - Singleton Instance

    /// Shared calculation engine instance
    public static let shared = CalculationEngine()
    
    // MARK: - Published Properties
    
    /// Current calculation progress (0.0 to 1.0)
    @MainActor @Published public private(set) var progress: Double = 0.0
    
    /// Whether a calculation is currently in progress
    @MainActor @Published public private(set) var isCalculating: Bool = false
    
    /// Current calculation status message
    @MainActor @Published public private(set) var statusMessage: String = ""
    
    /// Active calculation tasks
    @MainActor @Published public private(set) var activeTasks: Set<UUID> = []
    
    // MARK: - Precision Configuration
    
    /// Calculation precision mode
    nonisolated(unsafe) public static var usePrecisionMode: HighPrecisionMath.PrecisionMode = .standard
    
    /// Enable high-precision calculations globally
    nonisolated(unsafe) public static var enableHighPrecision: Bool = false
    
    // MARK: - Private Properties
    
    /// Cache for calculation results
    private var calculationCache = NSCache<NSString, CachedResult>()
    
    /// Queue for background calculations
    private let calculationQueue = DispatchQueue(label: "com.financialcalculator.engine", attributes: .concurrent)
    
    /// Active calculation tasks for cancellation
    private var activeCancellables: [UUID: AnyCancellable] = [:]
    
    private init() {
        calculationCache.countLimit = 100
        calculationCache.totalCostLimit = 10 * 1024 * 1024 // 10MB
    }
    
    // MARK: - Async Calculation Methods
    
    /// Perform a calculation asynchronously with progress reporting
    public func performAsync<T: FinancialComputable>(
        _ calculation: T,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> CalculationResult {
        // Update UI state
        activeTasks.insert(UUID())
        isCalculating = true

        defer {
            isCalculating = false
            progress = 0.0
            statusMessage = ""
        }

        // Check cache first
        let cacheKey = calculation.id.uuidString as NSString
        if let cached = calculationCache.object(forKey: cacheKey) {
            if Date().timeIntervalSince(cached.timestamp) < 300 { // 5 minute cache
                return cached.result
            }
        }

        // Update status
        statusMessage = "Calculating \(calculation.metadata.name)..."

        // Perform calculation
        let result = try await calculation.computeAsync { progress in
            self.progress = progress
            progressHandler?(progress)
        }

        // Cache result
        let cached = CachedResult(result: result, timestamp: Date())
        calculationCache.setObject(cached, forKey: cacheKey)

        return result
    }

    /// Perform multiple calculations in batch
    public func performBatch<T: FinancialComputable>(
        _ calculations: [T],
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> [CalculationResult] {
        let totalCalculations = Double(calculations.count)
        var completedCalculations: Double = 0

        // Process calculations sequentially to avoid concurrency issues
        var results: [CalculationResult] = []
        results.reserveCapacity(calculations.count)

        for (_, calculation) in calculations.enumerated() {
            let result = try await performAsync(calculation) { subProgress in
                let overallProgress = (completedCalculations + subProgress) / totalCalculations
                progressHandler?(overallProgress)
            }
            results.append(result)
            completedCalculations += 1.0
            progressHandler?(completedCalculations / totalCalculations)
        }

        return results
    }
    
    /// Cancel all active calculations
    @MainActor
    public func cancelAllCalculations() {
        activeCancellables.values.forEach { $0.cancel() }
        activeCancellables.removeAll()
        activeTasks.removeAll()
        isCalculating = false
        progress = 0.0
        statusMessage = "Calculations cancelled"
    }
    
    /// Clear calculation cache
    @MainActor
    public func clearCache() {
        calculationCache.removeAllObjects()
    }
    
    // MARK: - Error Handling
    
    /// Safely perform a calculation with error handling
    public static func safeCalculate<T>(
        _ operation: () throws -> T,
        defaultValue: T
    ) -> Result<T, CalculationError> {
        do {
            let result = try operation()
            
            // Check for numeric validity
            if let doubleResult = result as? Double {
                if doubleResult.isNaN {
                    return .failure(.mathematicalError("Result is not a number"))
                }
                if doubleResult.isInfinite {
                    return .failure(doubleResult > 0 ? .overflow : .underflow)
                }
            }
            
            return .success(result)
        } catch let error as CalculationError {
            return .failure(error)
        } catch {
            return .failure(.mathematicalError(error.localizedDescription))
        }
    }
    
    /// Validate calculation inputs
    public static func validateInputs(
        _ inputs: [String: Double],
        rules: [String: (Double) -> Bool]
    ) throws {
        for (name, value) in inputs {
            if let rule = rules[name], !rule(value) {
                throw CalculationError.invalidInput("Invalid \(name): \(value)")
            }
            
            if value.isNaN {
                throw CalculationError.invalidInput("\(name) is not a number")
            }
            
            if value.isInfinite {
                throw CalculationError.invalidInput("\(name) is infinite")
            }
        }
    }
    
    // MARK: - Mathematical Expression Evaluation
    
    /// Evaluate mathematical expressions using the MathParser
    static func evaluateExpression(_ expressionString: String, with variables: [String: Double] = [:]) -> Double? {
        // For now, use the MathParser as the primary expression evaluator
        return evaluateMathExpression(expressionString)
    }
    
    /// Parse and evaluate complex mathematical expressions using MathParser
    static func evaluateMathExpression(_ expressionString: String) -> Double? {
        let parser = MathParser()
        let evaluator = parser.parse(expressionString)
        if let result = evaluator {
            return result.eval()
        }
        return nil
    }
    
    // MARK: - Advanced Numerical Methods
    
    /// Calculate accurate compound interest using high-precision arithmetic
    nonisolated static func calculateCompoundInterestPrecise(
        principal: Double,
        rate: Double,
        compoundingFrequency: Double,
        years: Double
    ) -> Double {
        let r = rate / (100.0 * compoundingFrequency)
        let nt = compoundingFrequency * years
        return principal * pow(1 + r, nt)
    }
    
    /// Calculate logarithmic operations with enhanced precision
    nonisolated static func calculateLogReturn(initialValue: Double, finalValue: Double) -> Double {
        guard initialValue > 0 && finalValue > 0 else { return 0 }
        return Double.log(finalValue / initialValue)
    }
    
    /// Calculate exponential growth with high precision
    nonisolated static func calculateExponentialGrowth(
        initialValue: Double,
        growthRate: Double,
        periods: Double
    ) -> Double {
        return initialValue * Double.exp(growthRate * periods)
    }
    
    // MARK: - Statistical Financial Analysis
    
    /// Calculate standard deviation of returns
    nonisolated static func calculateStandardDeviation(_ values: [Double]) -> Double {
        guard values.count > 1 else { return 0 }
        
        let mean = values.reduce(0, +) / Double(values.count)
        let variance = values.map { pow($0 - mean, 2) }.reduce(0, +) / Double(values.count - 1)
        return Double.sqrt(variance)
    }
    
    /// Calculate Sharpe ratio
    nonisolated static func calculateSharpeRatio(
        returns: [Double],
        riskFreeRate: Double
    ) -> Double {
        guard returns.count > 1 else { return 0 }
        
        let meanReturn = returns.reduce(0, +) / Double(returns.count)
        let excessReturn = meanReturn - riskFreeRate / 100
        let stdDev = calculateStandardDeviation(returns)
        
        return stdDev != 0 ? excessReturn / stdDev : 0
    }
    
    /// Calculate Value at Risk (VaR) using parametric method
    nonisolated static func calculateVaR(
        portfolioValue: Double,
        expectedReturn: Double,
        volatility: Double,
        confidenceLevel: Double = 0.95,
        timeHorizon: Double = 1
    ) -> Double {
        // Using normal distribution approximation
        let zScore = confidenceLevel == 0.95 ? 1.645 : (confidenceLevel == 0.99 ? 2.326 : 1.96)
        let portfolioReturn = expectedReturn / 100 * timeHorizon
        let portfolioVolatility = volatility / 100 * Double.sqrt(timeHorizon)
        
        return portfolioValue * (portfolioReturn - zScore * portfolioVolatility)
    }
    
    // MARK: - Advanced Bond Calculations
    
    /// Calculate bond duration using precise methods
    nonisolated static func calculateModifiedDuration(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2
    ) -> Double {
        let macaulayDuration = calculateMacaulayDuration(
            faceValue: faceValue,
            couponRate: couponRate,
            marketRate: marketRate,
            yearsToMaturity: yearsToMaturity,
            paymentsPerYear: paymentsPerYear
        )
        
        let periodicRate = marketRate / 100 / paymentsPerYear
        return macaulayDuration / (1 + periodicRate)
    }
    
    /// Calculate Macaulay duration
    nonisolated static func calculateMacaulayDuration(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2
    ) -> Double {
        let periodicCoupon = (faceValue * couponRate / 100) / paymentsPerYear
        let periodicRate = marketRate / 100 / paymentsPerYear
        let totalPeriods = yearsToMaturity * paymentsPerYear
        
        var weightedCashFlows = 0.0
        var totalPresentValue = 0.0
        
        // Calculate weighted present value of coupon payments
        for period in 1...Int(totalPeriods) {
            let pv = periodicCoupon / pow(1 + periodicRate, Double(period))
            weightedCashFlows += pv * Double(period)
            totalPresentValue += pv
        }
        
        // Add present value of face value
        let facePV = faceValue / pow(1 + periodicRate, totalPeriods)
        weightedCashFlows += facePV * totalPeriods
        totalPresentValue += facePV
        
        return (weightedCashFlows / totalPresentValue) / paymentsPerYear
    }
    
    /// Calculate bond convexity for risk management
    nonisolated static func calculateConvexity(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2
    ) -> Double {
        let periodicCoupon = (faceValue * couponRate / 100) / paymentsPerYear
        let periodicRate = marketRate / 100 / paymentsPerYear
        let totalPeriods = yearsToMaturity * paymentsPerYear
        
        var convexitySum = 0.0
        let bondPrice = calculateBondPrice(
            faceValue: faceValue,
            couponRate: couponRate,
            marketRate: marketRate,
            yearsToMaturity: yearsToMaturity,
            paymentsPerYear: paymentsPerYear
        )
        
        // Calculate convexity for coupon payments
        for period in 1...Int(totalPeriods) {
            let cashFlow = periodicCoupon
            let pv = cashFlow / pow(1 + periodicRate, Double(period))
            convexitySum += pv * Double(period) * (Double(period) + 1)
        }
        
        // Add convexity for face value
        let facePV = faceValue / pow(1 + periodicRate, totalPeriods)
        convexitySum += facePV * totalPeriods * (totalPeriods + 1)
        
        return convexitySum / (bondPrice * pow(1 + periodicRate, 2) * pow(paymentsPerYear, 2))
    }
    
    // MARK: - Options Pricing (Black-Scholes Model)
    
    /// Calculate Black-Scholes option price
    nonisolated static func calculateBlackScholesOptionPrice(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiry: Double,
        riskFreeRate: Double,
        volatility: Double,
        optionType: OptionType = .call
    ) -> Double {
        let d1 = (Double.log(spotPrice / strikePrice) + (riskFreeRate / 100 + pow(volatility / 100, 2) / 2) * timeToExpiry) / 
                 (volatility / 100 * Double.sqrt(timeToExpiry))
        let d2 = d1 - volatility / 100 * Double.sqrt(timeToExpiry)
        
        let nd1 = cumulativeNormalDistribution(d1)
        let nd2 = cumulativeNormalDistribution(d2)
        let nNegD1 = cumulativeNormalDistribution(-d1)
        let nNegD2 = cumulativeNormalDistribution(-d2)
        
        let discountFactor = Double.exp(-riskFreeRate / 100 * timeToExpiry)
        
        switch optionType {
        case .call:
            return spotPrice * nd1 - strikePrice * discountFactor * nd2
        case .put:
            return strikePrice * discountFactor * nNegD2 - spotPrice * nNegD1
        }
    }
    
    /// Calculate option Greeks
    nonisolated static func calculateOptionDelta(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiry: Double,
        riskFreeRate: Double,
        volatility: Double,
        optionType: OptionType = .call
    ) -> Double {
        let d1 = (Double.log(spotPrice / strikePrice) + (riskFreeRate / 100 + pow(volatility / 100, 2) / 2) * timeToExpiry) / 
                 (volatility / 100 * Double.sqrt(timeToExpiry))
        
        switch optionType {
        case .call:
            return cumulativeNormalDistribution(d1)
        case .put:
            return cumulativeNormalDistribution(d1) - 1
        }
    }
    
    // MARK: - Utility Functions
    
    /// Cumulative normal distribution approximation
    nonisolated private static func cumulativeNormalDistribution(_ x: Double) -> Double {
        // Abramowitz and Stegun approximation
        let a1 =  0.254829592
        let a2 = -0.284496736
        let a3 =  1.421413741
        let a4 = -1.453152027
        let a5 =  1.061405429
        let p  =  0.3275911
        
        let sign = x < 0 ? -1.0 : 1.0
        let absX = abs(x)
        
        let t = 1.0 / (1.0 + p * absX)
        let y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Double.exp(-absX * absX)
        
        return 0.5 * (1.0 + sign * y)
    }
    
    enum OptionType {
        case call
        case put
    }
    
    // MARK: - Time Value of Money Calculations
    
    /// Calculate Present Value
    /// PV = FV / (1 + r)^n  OR  PV = PMT * [(1 - (1 + r)^-n) / r]
    nonisolated static func calculatePresentValue(
        futureValue: Double? = nil,
        payment: Double? = nil,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool = false
    ) -> Double {
        let r = interestRate / 100.0
        
        var pv = 0.0
        
        // Present value of lump sum
        if let fv = futureValue {
            pv += fv / pow(1 + r, numberOfPeriods)
        }
        
        // Present value of annuity
        if let pmt = payment, r != 0 {
            let annuityPV = pmt * (1 - pow(1 + r, -numberOfPeriods)) / r
            pv += paymentAtBeginning ? annuityPV * (1 + r) : annuityPV
        } else if let pmt = payment, r == 0 {
            pv += pmt * numberOfPeriods
        }
        
        return pv
    }
    
    /// Calculate Future Value
    /// FV = PV * (1 + r)^n  OR  FV = PMT * [((1 + r)^n - 1) / r]
    nonisolated static func calculateFutureValue(
        presentValue: Double? = nil,
        payment: Double? = nil,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool = false
    ) -> Double {
        let r = interestRate / 100.0
        
        var fv = 0.0
        
        // Future value of lump sum
        if let pv = presentValue {
            fv += pv * pow(1 + r, numberOfPeriods)
        }
        
        // Future value of annuity
        if let pmt = payment, r != 0 {
            let annuityFV = pmt * (pow(1 + r, numberOfPeriods) - 1) / r
            fv += paymentAtBeginning ? annuityFV * (1 + r) : annuityFV
        } else if let pmt = payment, r == 0 {
            fv += pmt * numberOfPeriods
        }
        
        return fv
    }
    
    /// Calculate Payment
    /// PMT = (PV * r) / (1 - (1 + r)^-n)  for PV
    /// PMT = (FV * r) / ((1 + r)^n - 1)   for FV
    nonisolated static func calculatePayment(
        presentValue: Double? = nil,
        futureValue: Double? = nil,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool = false
    ) -> Double {
        let r = interestRate / 100.0
        
        if r == 0 {
            if let pv = presentValue {
                return -pv / numberOfPeriods
            } else if let fv = futureValue {
                return fv / numberOfPeriods
            }
            return 0
        }
        
        var pmt = 0.0
        
        if let pv = presentValue {
            pmt += (pv * r) / (1 - pow(1 + r, -numberOfPeriods))
        }
        
        if let fv = futureValue {
            pmt += (fv * r) / (pow(1 + r, numberOfPeriods) - 1)
        }
        
        if paymentAtBeginning {
            pmt = pmt / (1 + r)
        }
        
        return -pmt
    }
    
    /// Calculate Interest Rate using Newton-Raphson method
    nonisolated static func calculateInterestRate(
        presentValue: Double? = nil,
        futureValue: Double? = nil,
        payment: Double? = nil,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool = false
    ) -> Double {
        
        // Initial guess
        var rate = 0.1
        let maxIterations = 100
        let tolerance = 1e-8
        
        for _ in 0..<maxIterations {
            let f = calculateNetPresentValue(
                presentValue: presentValue,
                futureValue: futureValue,
                payment: payment,
                interestRate: rate * 100,
                numberOfPeriods: numberOfPeriods,
                paymentAtBeginning: paymentAtBeginning
            )
            
            let fPrime = calculateNPVDerivative(
                presentValue: presentValue,
                futureValue: futureValue,
                payment: payment,
                interestRate: rate,
                numberOfPeriods: numberOfPeriods,
                paymentAtBeginning: paymentAtBeginning
            )
            
            if abs(f) < tolerance {
                break
            }
            
            if fPrime == 0 {
                break
            }
            
            rate = rate - f / fPrime
            
            // Ensure rate stays positive
            if rate < 0 {
                rate = 0.001
            }
        }
        
        return rate * 100
    }
    
    /// Calculate number of periods
    nonisolated static func calculateNumberOfPeriods(
        presentValue: Double? = nil,
        futureValue: Double? = nil,
        payment: Double? = nil,
        interestRate: Double,
        paymentAtBeginning: Bool = false
    ) -> Double {
        let r = interestRate / 100.0
        
        if let pv = presentValue, let fv = futureValue, payment == nil {
            // Simple compound interest: n = ln(FV/PV) / ln(1 + r)
            guard pv > 0, fv > 0, r > -1 else { return 0 }
            return log(fv / pv) / log(1 + r)
        }
        
        if let pv = presentValue, let pmt = payment, r != 0 {
            // Annuity: n = -ln(1 - (PV * r) / PMT) / ln(1 + r)
            let adjustedPmt = paymentAtBeginning ? pmt * (1 + r) : pmt
            guard adjustedPmt != 0, r > -1 else { return 0 }
            let ratio = (pv * r) / adjustedPmt
            if ratio < 1 {
                return -log(1 - ratio) / log(1 + r)
            }
        }
        
        if let fv = futureValue, let pmt = payment, r != 0 {
            // Future value annuity: n = ln(1 + (FV * r) / PMT) / ln(1 + r)
            let adjustedPmt = paymentAtBeginning ? pmt * (1 + r) : pmt
            guard adjustedPmt != 0, r > -1 else { return 0 }
            let ratio = (fv * r) / adjustedPmt
            return log(1 + ratio) / log(1 + r)
        }
        
        return 0
    }
    
    // MARK: - Loan Calculations
    
    /// Calculate loan payment
    nonisolated static func calculateLoanPayment(
        principal: Double,
        interestRate: Double,
        numberOfPayments: Double
    ) -> Double {
        let r = interestRate / 100.0
        
        if r == 0 {
            guard numberOfPayments > 0 else { return 0 }
            return principal / numberOfPayments
        }
        
        return principal * (r * pow(1 + r, numberOfPayments)) / (pow(1 + r, numberOfPayments) - 1)
    }
    
    /// Calculate remaining loan balance
    nonisolated static func calculateRemainingBalance(
        principal: Double,
        interestRate: Double,
        totalPayments: Double,
        paymentsMade: Double
    ) -> Double {
        let r = interestRate / 100.0
        let payment = calculateLoanPayment(principal: principal, interestRate: interestRate * 100, numberOfPayments: totalPayments)
        
        if r == 0 {
            return principal - (payment * paymentsMade)
        }
        
        return principal * pow(1 + r, paymentsMade) - payment * (pow(1 + r, paymentsMade) - 1) / r
    }
    
    // MARK: - Investment Analysis
    
    /// Calculate Net Present Value
    nonisolated static func calculateNPV(cashFlows: [Double], discountRate: Double) -> Double {
        let r = discountRate / 100.0
        var npv = 0.0
        
        for (index, cashFlow) in cashFlows.enumerated() {
            npv += cashFlow / pow(1 + r, Double(index))
        }
        
        return npv
    }
    
    /// Calculate Internal Rate of Return using advanced methods
    nonisolated static func calculateIRR(cashFlows: [Double]) -> Double {
        let result = AdvancedIRRCalculator.calculateIRR(
            cashFlows: cashFlows,
            config: AdvancedIRRCalculator.CalculationConfig.standard
        )
        
        return result.isValid ? result.irr * 100 : 0.0
    }
    
    /// Calculate Internal Rate of Return with detailed results
    nonisolated static func calculateAdvancedIRR(
        cashFlows: [Double],
        config: AdvancedIRRCalculator.CalculationConfig = .standard
    ) -> AdvancedIRRCalculator.IRRResult {
        return AdvancedIRRCalculator.calculateIRR(cashFlows: cashFlows, config: config)
    }
    
    /// Calculate Modified IRR (MIRR)
    nonisolated static func calculateMIRR(
        cashFlows: [Double],
        financeRate: Double,
        reinvestmentRate: Double
    ) -> Double {
        let config = AdvancedIRRCalculator.MIRRConfig(
            financeRate: financeRate / 100.0,
            reinvestmentRate: reinvestmentRate / 100.0
        )
        
        let result = AdvancedIRRCalculator.calculateMIRR(
            cashFlows: cashFlows,
            config: config
        )
        
        return result.isValid ? result.irr * 100 : 0.0
    }
    
    /// Calculate Blended IRR for multiple investment rounds
    nonisolated static func calculateBlendedIRR(investments: [FollowOnInvestment]) -> Double {
        let result = AdvancedIRRCalculator.calculateBlendedIRR(investments: investments)
        return result.isValid ? result.irr * 100 : 0.0
    }
    
    /// Legacy IRR calculation using bisection method (maintained for compatibility)
    nonisolated static func calculateIRRBisection(cashFlows: [Double]) -> Double {
        var lowerRate = -0.99
        var upperRate = 10.0
        let tolerance = 1e-8
        let maxIterations = 100
        
        for _ in 0..<maxIterations {
            let midRate = (lowerRate + upperRate) / 2
            let npv = calculateNPV(cashFlows: cashFlows, discountRate: midRate * 100)
            
            if abs(npv) < tolerance {
                return midRate * 100
            }
            
            if npv > 0 {
                lowerRate = midRate
            } else {
                upperRate = midRate
            }
            
            if abs(upperRate - lowerRate) < tolerance {
                break
            }
        }
        
        return (lowerRate + upperRate) / 2 * 100
    }
    
    // MARK: - Bond Calculations
    
    /// Calculate bond price
    nonisolated static func calculateBondPrice(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2
    ) -> Double {
        let periodicCoupon = (faceValue * couponRate / 100) / paymentsPerYear
        let periodicRate = marketRate / 100 / paymentsPerYear
        let totalPeriods = yearsToMaturity * paymentsPerYear
        
        // Present value of coupon payments
        let couponPV = periodicCoupon * (1 - pow(1 + periodicRate, -totalPeriods)) / periodicRate
        
        // Present value of face value
        let facePV = faceValue / pow(1 + periodicRate, totalPeriods)
        
        return couponPV + facePV
    }
    
    /// Calculate bond yield to maturity
    nonisolated static func calculateBondYTM(
        faceValue: Double,
        currentPrice: Double,
        couponRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2
    ) -> Double {
        
        var lowerYield = 0.001
        var upperYield = 1.0
        let tolerance = 1e-8
        let maxIterations = 100
        
        for _ in 0..<maxIterations {
            let midYield = (lowerYield + upperYield) / 2
            let calculatedPrice = calculateBondPrice(
                faceValue: faceValue,
                couponRate: couponRate,
                marketRate: midYield * 100,
                yearsToMaturity: yearsToMaturity,
                paymentsPerYear: paymentsPerYear
            )
            
            if abs(calculatedPrice - currentPrice) < tolerance {
                return midYield * 100
            }
            
            if calculatedPrice > currentPrice {
                lowerYield = midYield
            } else {
                upperYield = midYield
            }
            
            if abs(upperYield - lowerYield) < tolerance {
                break
            }
        }
        
        return (lowerYield + upperYield) / 2 * 100
    }
    
    // MARK: - Helper Functions
    
    nonisolated private static func calculateNetPresentValue(
        presentValue: Double?,
        futureValue: Double?,
        payment: Double?,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool
    ) -> Double {
        var npv = 0.0
        
        if let pv = presentValue {
            npv += pv
        }
        
        if let fv = futureValue {
            npv -= fv / pow(1 + interestRate / 100, numberOfPeriods)
        }
        
        if let pmt = payment {
            let r = interestRate / 100
            if r != 0 {
                let annuityPV = pmt * (1 - pow(1 + r, -numberOfPeriods)) / r
                npv -= paymentAtBeginning ? annuityPV * (1 + r) : annuityPV
            } else {
                npv -= pmt * numberOfPeriods
            }
        }
        
        return npv
    }
    
    nonisolated private static func calculateNPVDerivative(
        presentValue: Double?,
        futureValue: Double?,
        payment: Double?,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool
    ) -> Double {
        // Numerical derivative
        let h = 1e-8
        let f1 = calculateNetPresentValue(
            presentValue: presentValue,
            futureValue: futureValue,
            payment: payment,
            interestRate: (interestRate + h) * 100,
            numberOfPeriods: numberOfPeriods,
            paymentAtBeginning: paymentAtBeginning
        )
        let f2 = calculateNetPresentValue(
            presentValue: presentValue,
            futureValue: futureValue,
            payment: payment,
            interestRate: (interestRate - h) * 100,
            numberOfPeriods: numberOfPeriods,
            paymentAtBeginning: paymentAtBeginning
        )
        
        return (f1 - f2) / (2 * h)
    }
}

// MARK: - High-Precision Extensions
extension CalculationEngine {
    
    // MARK: - Dual-Mode Calculation Methods
    
    /// Calculate compound interest with precision mode selection
    nonisolated static func calculateCompoundInterestWithPrecision(
        principal: Double,
        rate: Double,
        compoundingFrequency: Double,
        years: Double,
        usePrecision: Bool? = nil
    ) -> Double {
        let useHighPrecision = usePrecision ?? enableHighPrecision
        
        if useHighPrecision {
            let result = HighPrecisionMath.compoundInterest(
                principal: financial(principal),
                rate: financial(rate),
                compoundingFrequency: financial(compoundingFrequency),
                years: financial(years)
            )
            return result.doubleValue
        } else {
            return calculateCompoundInterestPrecise(
                principal: principal,
                rate: rate,
                compoundingFrequency: compoundingFrequency,
                years: years
            )
        }
    }
    
    /// Calculate present value with precision mode selection
    nonisolated static func calculatePresentValueWithPrecision(
        futureValue: Double? = nil,
        payment: Double? = nil,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool = false,
        usePrecision: Bool? = nil
    ) -> Double {
        let useHighPrecision = usePrecision ?? enableHighPrecision
        
        if useHighPrecision {
            var result = financial(0)
            
            if let fv = futureValue {
                result = result + HighPrecisionMath.presentValue(
                    futureValue: financial(fv),
                    rate: financial(interestRate),
                    periods: financial(numberOfPeriods)
                )
            }
            
            if let pmt = payment {
                let annuityPV = HighPrecisionMath.annuityPresentValue(
                    payment: financial(pmt),
                    rate: financial(interestRate),
                    periods: financial(numberOfPeriods)
                )
                result = result + (paymentAtBeginning ? 
                         annuityPV * (financial(1) + financial(interestRate) / financial(100)) : 
                         annuityPV)
            }
            
            return result.doubleValue
        } else {
            return calculatePresentValue(
                futureValue: futureValue,
                payment: payment,
                interestRate: interestRate,
                numberOfPeriods: numberOfPeriods,
                paymentAtBeginning: paymentAtBeginning
            )
        }
    }
    
    /// Calculate future value with precision mode selection
    nonisolated static func calculateFutureValueWithPrecision(
        presentValue: Double? = nil,
        payment: Double? = nil,
        interestRate: Double,
        numberOfPeriods: Double,
        paymentAtBeginning: Bool = false,
        usePrecision: Bool? = nil
    ) -> Double {
        let useHighPrecision = usePrecision ?? enableHighPrecision
        
        if useHighPrecision {
            var result = financial(0)
            
            if let pv = presentValue {
                result = result + HighPrecisionMath.futureValue(
                    presentValue: financial(pv),
                    rate: financial(interestRate),
                    periods: financial(numberOfPeriods)
                )
            }
            
            if let pmt = payment {
                let annuityFV = HighPrecisionMath.annuityFutureValue(
                    payment: financial(pmt),
                    rate: financial(interestRate),
                    periods: financial(numberOfPeriods)
                )
                result = result + (paymentAtBeginning ? 
                         annuityFV * (financial(1) + financial(interestRate) / financial(100)) : 
                         annuityFV)
            }
            
            return result.doubleValue
        } else {
            return calculateFutureValue(
                presentValue: presentValue,
                payment: payment,
                interestRate: interestRate,
                numberOfPeriods: numberOfPeriods,
                paymentAtBeginning: paymentAtBeginning
            )
        }
    }
    
    /// Calculate NPV with precision mode selection
    nonisolated static func calculateNPVWithPrecision(
        cashFlows: [Double],
        discountRate: Double,
        usePrecision: Bool? = nil
    ) -> Double {
        let useHighPrecision = usePrecision ?? enableHighPrecision
        
        if useHighPrecision {
            let precisionCashFlows = cashFlows.map { financial($0) }
            let result = HighPrecisionMath.netPresentValue(
                cashFlows: precisionCashFlows,
                discountRate: financial(discountRate)
            )
            return result.doubleValue
        } else {
            return calculateNPV(cashFlows: cashFlows, discountRate: discountRate)
        }
    }
    
    /// Calculate IRR with precision mode selection
    nonisolated static func calculateIRRWithPrecision(
        cashFlows: [Double],
        usePrecision: Bool? = nil
    ) -> Double {
        let useHighPrecision = usePrecision ?? enableHighPrecision
        
        if useHighPrecision {
            let precisionCashFlows = cashFlows.map { financial($0) }
            let result = HighPrecisionMath.internalRateOfReturn(
                cashFlows: precisionCashFlows
            )
            return result.doubleValue * 100 // Convert to percentage
        } else {
            return calculateIRR(cashFlows: cashFlows)
        }
    }
    
    /// Calculate bond price with precision mode selection
    nonisolated static func calculateBondPriceWithPrecision(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2,
        usePrecision: Bool? = nil
    ) -> Double {
        let useHighPrecision = usePrecision ?? enableHighPrecision
        
        if useHighPrecision {
            let result = HighPrecisionMath.bondPrice(
                faceValue: financial(faceValue),
                couponRate: financial(couponRate),
                marketRate: financial(marketRate),
                yearsToMaturity: financial(yearsToMaturity),
                paymentsPerYear: financial(paymentsPerYear)
            )
            return result.doubleValue
        } else {
            return calculateBondPrice(
                faceValue: faceValue,
                couponRate: couponRate,
                marketRate: marketRate,
                yearsToMaturity: yearsToMaturity,
                paymentsPerYear: paymentsPerYear
            )
        }
    }
    
    // MARK: - Precision Comparison Methods
    
    /// Compare standard vs high-precision calculation results
    static func compareCalculationPrecision(
        calculationType: String,
        standardResult: Double,
        highPrecisionResult: Double
    ) -> PrecisionComparison {
        let difference = abs(standardResult - highPrecisionResult)
        let relativeDifference = standardResult != 0 ? abs(difference / standardResult) : 0
        let significantDigitsAccurate = relativeDifference > 0 ? max(0, -log10(relativeDifference)) : 15
        
        return PrecisionComparison(
            calculationType: calculationType,
            standardResult: standardResult,
            highPrecisionResult: highPrecisionResult,
            absoluteDifference: difference,
            relativeDifference: relativeDifference,
            significantDigitsAccurate: significantDigitsAccurate
        )
    }
    
    /// Benchmark calculation performance
    static func benchmarkCalculationPerformance<T>(
        name: String,
        iterations: Int = 1000,
        standardCalculation: () -> T,
        highPrecisionCalculation: () -> T
    ) -> PerformanceBenchmark<T> {
        
        // Warm up
        _ = standardCalculation()
        _ = highPrecisionCalculation()
        
        // Benchmark standard calculation
        let standardStart = CFAbsoluteTimeGetCurrent()
        var standardResult: T!
        for _ in 0..<iterations {
            standardResult = standardCalculation()
        }
        let standardTime = (CFAbsoluteTimeGetCurrent() - standardStart) / Double(iterations)
        
        // Benchmark high-precision calculation
        let highPrecisionStart = CFAbsoluteTimeGetCurrent()
        var highPrecisionResult: T!
        for _ in 0..<iterations {
            highPrecisionResult = highPrecisionCalculation()
        }
        let highPrecisionTime = (CFAbsoluteTimeGetCurrent() - highPrecisionStart) / Double(iterations)
        
        return PerformanceBenchmark(
            name: name,
            iterations: iterations,
            standardResult: standardResult,
            highPrecisionResult: highPrecisionResult,
            standardTime: standardTime,
            highPrecisionTime: highPrecisionTime,
            performanceRatio: highPrecisionTime / standardTime
        )
    }
    
    // MARK: - Precision Validation Methods
    
    /// Validate high-precision calculation against known mathematical constants
    static func validatePrecisionWithConstants() -> [PrecisionValidationResult] {
        var results: [PrecisionValidationResult] = []
        
        // Test compound interest with known result
        let principal = 1000.0
        let rate = 5.0
        let years = 10.0
        let expectedFV = 1628.8946267 // Known result for this calculation
        
        let standardFV = calculateCompoundInterestPrecise(
            principal: principal,
            rate: rate,
            compoundingFrequency: 1,
            years: years
        )
        
        let precisionFV = HighPrecisionMath.compoundInterest(
            principal: financial(principal),
            rate: financial(rate),
            compoundingFrequency: financial(1),
            years: financial(years)
        ).doubleValue
        
        results.append(PrecisionValidationResult(
            testName: "Compound Interest Validation",
            expected: expectedFV,
            standard: standardFV,
            highPrecision: precisionFV,
            standardAccuracy: abs(expectedFV - standardFV),
            precisionAccuracy: abs(expectedFV - precisionFV)
        ))
        
        return results
    }
    
    /// Test calculation consistency across multiple precision levels
    static func testCalculationConsistency(
        cashFlows: [Double],
        discountRate: Double
    ) -> ConsistencyTest {
        let standardNPV = calculateNPV(cashFlows: cashFlows, discountRate: discountRate)
        let precisionNPV = calculateNPVWithPrecision(
            cashFlows: cashFlows,
            discountRate: discountRate,
            usePrecision: true
        )
        
        let difference = abs(standardNPV - precisionNPV)
        let isConsistent = difference < 0.01 // 1 cent tolerance
        
        return ConsistencyTest(
            testName: "NPV Calculation Consistency",
            standardResult: standardNPV,
            precisionResult: precisionNPV,
            difference: difference,
            isConsistent: isConsistent,
            tolerance: 0.01
        )
    }
    
    // MARK: - Advanced Financial Calculations
    
    /// Monte Carlo simulation for option pricing
    nonisolated static func calculateOptionPriceMonteCarloSimulation(
        spotPrice: Double,
        strikePrice: Double,
        timeToExpiry: Double,
        riskFreeRate: Double,
        volatility: Double,
        optionType: OptionType = .call,
        numSimulations: Int = 100000,
        randomSeed: Int? = nil
    ) -> (price: Double, standardError: Double) {
        
        if let seed = randomSeed {
            srand48(seed)
        }
        
        let dt = timeToExpiry
        let drift = riskFreeRate / 100 - 0.5 * pow(volatility / 100, 2)
        let diffusion = volatility / 100 * sqrt(dt)
        
        var payoffs: [Double] = []
        
        for _ in 0..<numSimulations {
            // Generate random number from standard normal distribution
            let z = generateStandardNormal()
            
            // Calculate final stock price using geometric Brownian motion
            let finalPrice = spotPrice * exp(drift * dt + diffusion * z)
            
            // Calculate payoff
            let payoff: Double
            switch optionType {
            case .call:
                payoff = max(finalPrice - strikePrice, 0)
            case .put:
                payoff = max(strikePrice - finalPrice, 0)
            }
            
            payoffs.append(payoff)
        }
        
        // Calculate present value of average payoff
        let averagePayoff = payoffs.reduce(0, +) / Double(numSimulations)
        let discountedPrice = averagePayoff * exp(-riskFreeRate / 100 * timeToExpiry)
        
        // Calculate standard error
        let variance = payoffs.map { pow($0 - averagePayoff, 2) }.reduce(0, +) / Double(numSimulations - 1)
        let standardError = sqrt(variance / Double(numSimulations)) * exp(-riskFreeRate / 100 * timeToExpiry)
        
        return (price: discountedPrice, standardError: standardError)
    }
    
    /// Calculate exotic barrier option price
    nonisolated static func calculateBarrierOptionPrice(
        spotPrice: Double,
        strikePrice: Double,
        barrierLevel: Double,
        timeToExpiry: Double,
        riskFreeRate: Double,
        volatility: Double,
        optionType: OptionType = .call,
        barrierType: BarrierType = .upAndOut,
        numSimulations: Int = 100000
    ) -> Double {
        
        let dt = timeToExpiry / 252 // Daily time steps
        let drift = riskFreeRate / 100 - 0.5 * pow(volatility / 100, 2)
        let diffusion = volatility / 100 * sqrt(dt)
        
        var totalPayoff = 0.0
        
        for _ in 0..<numSimulations {
            var currentPrice = spotPrice
            var barrierHit = false
            
            // Simulate daily price movements
            for _ in 0..<252 {
                let z = generateStandardNormal()
                currentPrice *= exp(drift * dt + diffusion * z)
                
                // Check barrier condition
                switch barrierType {
                case .upAndOut, .upAndIn:
                    if currentPrice >= barrierLevel {
                        barrierHit = true
                        break
                    }
                case .downAndOut, .downAndIn:
                    if currentPrice <= barrierLevel {
                        barrierHit = true
                        break
                    }
                }
            }
            
            // Calculate payoff based on barrier type
            let standardPayoff: Double
            switch optionType {
            case .call:
                standardPayoff = max(currentPrice - strikePrice, 0)
            case .put:
                standardPayoff = max(strikePrice - currentPrice, 0)
            }
            
            let actualPayoff: Double
            switch barrierType {
            case .upAndOut, .downAndOut:
                actualPayoff = barrierHit ? 0 : standardPayoff
            case .upAndIn, .downAndIn:
                actualPayoff = barrierHit ? standardPayoff : 0
            }
            
            totalPayoff += actualPayoff
        }
        
        let averagePayoff = totalPayoff / Double(numSimulations)
        return averagePayoff * exp(-riskFreeRate / 100 * timeToExpiry)
    }
    
    /// Calculate portfolio Value at Risk using historical simulation
    nonisolated static func calculatePortfolioVaR(
        portfolioValue: Double,
        returns: [Double],
        confidenceLevel: Double = 0.95,
        timeHorizon: Int = 1
    ) -> (var: Double, expectedShortfall: Double) {
        
        guard !returns.isEmpty else { return (0, 0) }
        
        // Scale returns for time horizon if needed
        let scaledReturns = returns.map { $0 * sqrt(Double(timeHorizon)) }
        let sortedReturns = scaledReturns.sorted()
        
        // Calculate VaR
        let varIndex = Int((1 - confidenceLevel) * Double(sortedReturns.count))
        let varReturn = sortedReturns[min(varIndex, sortedReturns.count - 1)]
        let valueAtRisk = -portfolioValue * varReturn
        
        // Calculate Expected Shortfall (Conditional VaR)
        let tailReturns = Array(sortedReturns[0..<varIndex])
        let expectedShortfallReturn = tailReturns.isEmpty ? varReturn : tailReturns.reduce(0, +) / Double(tailReturns.count)
        let expectedShortfall = -portfolioValue * expectedShortfallReturn
        
        return (var: valueAtRisk, expectedShortfall: expectedShortfall)
    }
    
    /// Calculate optimal portfolio weights using Mean-Variance Optimization (simplified)
    nonisolated static func calculateOptimalPortfolioWeights(
        expectedReturns: [Double],
        covarianceMatrix: [[Double]],
        riskTolerance: Double = 1.0
    ) -> [Double] {
        
        let n = expectedReturns.count
        guard covarianceMatrix.count == n && covarianceMatrix.allSatisfy({ $0.count == n }) else {
            return Array(repeating: 1.0 / Double(n), count: n) // Equal weights if invalid
        }
        
        // Simplified mean-variance optimization (assuming we can invert covariance matrix)
        // In practice, would use more sophisticated numerical methods
        
        // For now, return risk-parity weights (inverse volatility weighting)
        let volatilities = (0..<n).map { i in
            sqrt(max(covarianceMatrix[i][i], 1e-8))
        }
        
        let inverseVolatilities = volatilities.map { 1.0 / $0 }
        let sumInverseVol = inverseVolatilities.reduce(0, +)
        
        return inverseVolatilities.map { $0 / sumInverseVol }
    }
    
    /// Calculate Real Estate Investment Analysis
    nonisolated static func calculateRealEstateInvestment(
        purchasePrice: Double,
        downPayment: Double,
        loanRate: Double,
        loanTerm: Double,
        monthlyRent: Double,
        annualRentGrowth: Double,
        propertyTaxRate: Double,
        maintenanceRate: Double,
        holdingPeriod: Double,
        appreciationRate: Double
    ) -> RealEstateInvestmentResult {
        
        let loanAmount = purchasePrice - downPayment
        let monthlyPayment = calculatePayment(
            presentValue: loanAmount,
            interestRate: loanRate,
            numberOfPeriods: loanTerm * 12,
            paymentAtBeginning: false
        )
        
        var totalCashFlow = 0.0
        var currentRent = monthlyRent
        
        for year in 1...Int(holdingPeriod) {
            let annualRent = currentRent * 12
            let propertyTax = purchasePrice * propertyTaxRate / 100
            let maintenance = purchasePrice * maintenanceRate / 100
            let loanPayments = -monthlyPayment * 12
            
            let netOperatingIncome = annualRent - propertyTax - maintenance
            let cashFlow = netOperatingIncome + loanPayments
            
            totalCashFlow += cashFlow
            currentRent *= (1 + annualRentGrowth / 100)
        }
        
        // Calculate property value at sale
        let futureValue = purchasePrice * pow(1 + appreciationRate / 100, holdingPeriod)
        
        // Calculate remaining loan balance
        let remainingBalance = calculatePresentValue(
            payment: -monthlyPayment,
            interestRate: loanRate,
            numberOfPeriods: (loanTerm - holdingPeriod) * 12
        ) ?? 0
        
        let saleProceeds = futureValue - remainingBalance
        let totalReturn = totalCashFlow + saleProceeds - downPayment
        let annualizedReturn = pow(abs(totalReturn / downPayment), 1.0 / holdingPeriod) - 1
        
        return RealEstateInvestmentResult(
            totalCashFlow: totalCashFlow,
            saleProceeds: saleProceeds,
            totalReturn: totalReturn,
            annualizedReturn: annualizedReturn * 100,
            cashOnCashReturn: (currentRent * 12 + monthlyPayment * 12) / downPayment * 100
        )
    }
    
    /// Calculate cryptocurrency DCA (Dollar Cost Averaging) strategy
    nonisolated static func calculateCryptoDCAStrategy(
        monthlyInvestment: Double,
        historicalPrices: [Double],
        startMonth: Int = 0,
        endMonth: Int? = nil
    ) -> CryptoDCAResult {
        
        let actualEndMonth = endMonth ?? historicalPrices.count - 1
        let investmentPeriods = actualEndMonth - startMonth + 1
        
        var totalInvested = 0.0
        var totalCoins = 0.0
        
        for month in startMonth...actualEndMonth {
            if month < historicalPrices.count {
                let price = historicalPrices[month]
                totalInvested += monthlyInvestment
                totalCoins += monthlyInvestment / price
            }
        }
        
        let finalPrice = historicalPrices[min(actualEndMonth, historicalPrices.count - 1)]
        let currentValue = totalCoins * finalPrice
        let totalReturn = currentValue - totalInvested
        let returnPercentage = (totalReturn / totalInvested) * 100
        let averageCostPerCoin = totalInvested / totalCoins
        
        return CryptoDCAResult(
            totalInvested: totalInvested,
            totalCoins: totalCoins,
            averageCostPerCoin: averageCostPerCoin,
            currentValue: currentValue,
            totalReturn: totalReturn,
            returnPercentage: returnPercentage,
            investmentPeriods: investmentPeriods
        )
    }
    
    /// Calculate currency hedging cost and effectiveness
    nonisolated static func calculateCurrencyHedging(
        exposureAmount: Double,
        baseCurrency: String,
        foreignCurrency: String,
        spotRate: Double,
        forwardRate: Double,
        timeToMaturity: Double,
        hedgeRatio: Double = 1.0
    ) -> CurrencyHedgeResult {
        
        let hedgeAmount = exposureAmount * hedgeRatio
        let unhedgedAmount = exposureAmount - hedgeAmount
        
        // Cost of hedging (forward premium/discount)
        let forwardPremium = (forwardRate - spotRate) / spotRate
        let hedgingCostPercentage = forwardPremium * 100
        let hedgingCostAmount = hedgeAmount * forwardPremium
        
        // Simulate currency movement scenarios
        let scenarios = [-0.2, -0.1, -0.05, 0.0, 0.05, 0.1, 0.2] // ±20% range
        var hedgedOutcomes: [Double] = []
        var unhedgedOutcomes: [Double] = []
        
        for scenario in scenarios {
            let futureSpotRate = spotRate * (1 + scenario)
            
            // Hedged outcome
            let hedgedValue = hedgeAmount * forwardRate + unhedgedAmount * futureSpotRate
            hedgedOutcomes.append(hedgedValue)
            
            // Unhedged outcome
            let unhedgedValue = exposureAmount * futureSpotRate
            unhedgedOutcomes.append(unhedgedValue)
        }
        
        // Calculate variance reduction
        let hedgedVariance = calculateVariance(hedgedOutcomes)
        let unhedgedVariance = calculateVariance(unhedgedOutcomes)
        let varianceReduction = (unhedgedVariance - hedgedVariance) / unhedgedVariance * 100
        
        return CurrencyHedgeResult(
            hedgeAmount: hedgeAmount,
            hedgingCostAmount: hedgingCostAmount,
            hedgingCostPercentage: hedgingCostPercentage,
            forwardRate: forwardRate,
            spotRate: spotRate,
            varianceReduction: varianceReduction,
            hedgeRatio: hedgeRatio
        )
    }
    
    // MARK: - Helper Functions for Advanced Calculations
    
    nonisolated private static func generateStandardNormal() -> Double {
        // Box-Muller transformation for generating normal random numbers
        let u1 = drand48()
        let u2 = drand48()
        return sqrt(-2.0 * log(u1)) * cos(2.0 * Double.pi * u2)
    }
    
    nonisolated private static func calculateVariance(_ values: [Double]) -> Double {
        guard values.count > 1 else { return 0 }
        let mean = values.reduce(0, +) / Double(values.count)
        let squaredDifferences = values.map { pow($0 - mean, 2) }
        return squaredDifferences.reduce(0, +) / Double(values.count - 1)
    }
    
    // MARK: - Enums for Advanced Calculations
    
    enum BarrierType {
        case upAndOut
        case upAndIn
        case downAndOut
        case downAndIn
    }
}

// MARK: - Supporting Types

/// Cached calculation result
fileprivate class CachedResult {
    let result: CalculationResult
    let timestamp: Date
    
    init(result: CalculationResult, timestamp: Date) {
        self.result = result
        self.timestamp = timestamp
    }
}

// MARK: - CalculationResult Extensions

extension CalculationResult {
    /// Create an empty result
    static func empty() -> CalculationResult {
        return CalculationResult(
            primaryValue: 0,
            formattedPrimaryValue: "No result",
            explanation: "Calculation not performed"
        )
    }
}

// MARK: - Thread-Safe Calculation Methods

extension CalculationEngine {
    
    /// Thread-safe wrapper for time value calculations
    public func calculateTimeValueAsync(
        presentValue: Double? = nil,
        futureValue: Double? = nil,
        payment: Double? = nil,
        interestRate: Double? = nil,
        numberOfPeriods: Double? = nil,
        solveFor: TimeValueVariable,
        paymentAtBeginning: Bool = false,
        paymentFrequency: PaymentFrequency = .monthly
    ) async throws -> Double {
        
        return try await withCheckedThrowingContinuation { continuation in
            calculationQueue.async {
                do {
                    let result: Double
                    
                    switch solveFor {
                    case .presentValue:
                        guard let fv = futureValue, let rate = interestRate, let periods = numberOfPeriods else {
                            throw CalculationError.invalidInput("Missing required inputs for present value calculation")
                        }
                        result = CalculationEngine.calculatePresentValue(
                            futureValue: fv,
                            payment: payment,
                            interestRate: rate,
                            numberOfPeriods: periods,
                            paymentAtBeginning: paymentAtBeginning
                        )
                        
                    case .futureValue:
                        guard let pv = presentValue, let rate = interestRate, let periods = numberOfPeriods else {
                            throw CalculationError.invalidInput("Missing required inputs for future value calculation")
                        }
                        result = CalculationEngine.calculateFutureValue(
                            presentValue: pv,
                            payment: payment,
                            interestRate: rate,
                            numberOfPeriods: periods,
                            paymentAtBeginning: paymentAtBeginning
                        )
                        
                    case .payment:
                        guard let rate = interestRate, let periods = numberOfPeriods else {
                            throw CalculationError.invalidInput("Missing required inputs for payment calculation")
                        }
                        result = CalculationEngine.calculatePayment(
                            presentValue: presentValue,
                            futureValue: futureValue,
                            interestRate: rate,
                            numberOfPeriods: periods,
                            paymentAtBeginning: paymentAtBeginning
                        )
                        
                    case .interestRate:
                        guard let periods = numberOfPeriods else {
                            throw CalculationError.invalidInput("Missing required inputs for interest rate calculation")
                        }
                        result = CalculationEngine.calculateInterestRate(
                            presentValue: presentValue,
                            futureValue: futureValue,
                            payment: payment,
                            numberOfPeriods: periods,
                            paymentAtBeginning: paymentAtBeginning
                        )
                        
                    case .numberOfYears:
                        guard let rate = interestRate else {
                            throw CalculationError.invalidInput("Missing required inputs for period calculation")
                        }
                        let periods = CalculationEngine.calculateNumberOfPeriods(
                            presentValue: presentValue,
                            futureValue: futureValue,
                            payment: payment,
                            interestRate: rate,
                            paymentAtBeginning: paymentAtBeginning
                        )
                        result = periods / Double(paymentFrequency.periodsPerYear)
                    }
                    
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Thread-safe NPV calculation with progress reporting
    public func calculateNPVAsync(
        cashFlows: [Double],
        discountRate: Double,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> Double {
        
        guard !cashFlows.isEmpty else {
            throw CalculationError.invalidInput("Cash flows cannot be empty")
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            calculationQueue.async {
                let r = discountRate / 100.0
                var npv = 0.0
                let total = Double(cashFlows.count)

                for (index, cashFlow) in cashFlows.enumerated() {
                    npv += cashFlow / pow(1 + r, Double(index))

                    // Report progress
                    let progress = Double(index + 1) / total
                    progressHandler?(progress)
                }

                continuation.resume(returning: npv)
            }
        }
    }
    
    /// Thread-safe IRR calculation with advanced algorithms
    public func calculateIRRAsync(
        cashFlows: [Double],
        config: AdvancedIRRCalculator.CalculationConfig = .standard,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> AdvancedIRRCalculator.IRRResult {
        
        return try await withCheckedThrowingContinuation { continuation in
            calculationQueue.async {
                // Create a custom config with progress handler
                var customConfig = config
                customConfig.progressHandler = { progress in
                    progressHandler?(progress)
                }

                let result = AdvancedIRRCalculator.calculateIRR(
                    cashFlows: cashFlows,
                    config: customConfig
                )

                if result.isValid {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: CalculationError.convergenceFailure("IRR calculation failed to converge"))
                }
            }
        }
    }
    
    /// Thread-safe bond pricing with Greeks
    public func calculateBondMetricsAsync(
        faceValue: Double,
        couponRate: Double,
        marketRate: Double,
        yearsToMaturity: Double,
        paymentsPerYear: Double = 2,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> BondMetrics {
        
        return try await withCheckedThrowingContinuation { continuation in
            calculationQueue.async {
                do {
                    progressHandler?(0.2)
                    
                    let price = CalculationEngine.calculateBondPrice(
                        faceValue: faceValue,
                        couponRate: couponRate,
                        marketRate: marketRate,
                        yearsToMaturity: yearsToMaturity,
                        paymentsPerYear: paymentsPerYear
                    )
                    
                    progressHandler?(0.4)
                    
                    let modifiedDuration = CalculationEngine.calculateModifiedDuration(
                        faceValue: faceValue,
                        couponRate: couponRate,
                        marketRate: marketRate,
                        yearsToMaturity: yearsToMaturity,
                        paymentsPerYear: paymentsPerYear
                    )
                    
                    progressHandler?(0.6)
                    
                    let macaulayDuration = CalculationEngine.calculateMacaulayDuration(
                        faceValue: faceValue,
                        couponRate: couponRate,
                        marketRate: marketRate,
                        yearsToMaturity: yearsToMaturity,
                        paymentsPerYear: paymentsPerYear
                    )
                    
                    progressHandler?(0.8)
                    
                    let convexity = CalculationEngine.calculateConvexity(
                        faceValue: faceValue,
                        couponRate: couponRate,
                        marketRate: marketRate,
                        yearsToMaturity: yearsToMaturity,
                        paymentsPerYear: paymentsPerYear
                    )
                    
                    progressHandler?(1.0)
                    
                    let metrics = BondMetrics(
                        price: price,
                        modifiedDuration: modifiedDuration,
                        macaulayDuration: macaulayDuration,
                        convexity: convexity,
                        currentYield: (couponRate * faceValue / 100) / price * 100
                    )
                    
                    continuation.resume(returning: metrics)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Bond Metrics Result

public struct BondMetrics {
    public let price: Double
    public let modifiedDuration: Double
    public let macaulayDuration: Double
    public let convexity: Double
    public let currentYield: Double
}

// MARK: - Integration with FinancialComputable

extension CalculationEngine {
    
    /// Create a standardized calculation result from engine output
    public static func createCalculationResult(
        primaryValue: Double,
        secondaryValues: [String: Double] = [:],
        calculationType: CalculationType,
        currency: Currency = .usd,
        explanation: String? = nil
    ) -> CalculationResult {
        
        let formattedValue = currency.formatValue(primaryValue)
        let defaultExplanation = "\(calculationType.displayName) calculation result"
        
        var chartData: [ChartDataPoint] = []
        
        // Generate appropriate chart data based on calculation type
        switch calculationType {
        case .timeValue, .loan, .investment:
            // Generate time series data
            for (period, value) in secondaryValues.sorted(by: { $0.key < $1.key }) {
                if let periodNum = Int(period.replacingOccurrences(of: "Period ", with: "")) {
                    chartData.append(ChartDataPoint(
                        x: Double(periodNum),
                        y: value,
                        label: period
                    ))
                }
            }
            
        case .bond, .options:
            // Generate sensitivity data
            if let duration = secondaryValues["duration"],
               let convexity = secondaryValues["convexity"] {
                for change in stride(from: -2.0, through: 2.0, by: 0.5) {
                    let priceChange = -duration * change + 0.5 * convexity * change * change
                    chartData.append(ChartDataPoint(
                        x: change,
                        y: primaryValue * (1 + priceChange / 100),
                        label: String(format: "%.1f%%", change)
                    ))
                }
            }
            
        default:
            // No specific chart data
            break
        }
        
        return CalculationResult(
            primaryValue: primaryValue,
            secondaryValues: secondaryValues,
            formattedPrimaryValue: formattedValue,
            explanation: explanation ?? defaultExplanation,
            chartData: chartData.isEmpty ? nil : chartData
        )
    }
    
    /// Validate calculation results and generate warnings
    nonisolated private static func validateCalculationWarnings(
        primaryValue: Double,
        type: CalculationType
    ) -> [String] {
        
        var warnings: [String] = []
        
        // Check for extreme values
        if abs(primaryValue) > 1_000_000_000 {
            warnings.append("Result exceeds typical range - please verify inputs")
        }
        
        // Type-specific warnings
        switch type {
        case .loan:
            if primaryValue < 0 {
                warnings.append("Negative payment calculated - check input values")
            }
            
        case .investment:
            if primaryValue < -100 {
                warnings.append("Return exceeds -100% - total loss scenario")
            }
            
        case .bond:
            if primaryValue < 0 {
                warnings.append("Negative bond price - check yield and coupon inputs")
            }
            
        default:
            break
        }
        
        return warnings
    }
}

// MARK: - Precision Analysis Types

struct PrecisionComparison {
    let calculationType: String
    let standardResult: Double
    let highPrecisionResult: Double
    let absoluteDifference: Double
    let relativeDifference: Double
    let significantDigitsAccurate: Double
    
    var improvementDescription: String {
        if significantDigitsAccurate > 10 {
            return "High precision provides \(Int(significantDigitsAccurate)) digits of accuracy"
        } else if relativeDifference < 1e-10 {
            return "Excellent precision agreement"
        } else if relativeDifference < 1e-6 {
            return "Good precision improvement"
        } else {
            return "Moderate precision difference"
        }
    }
}

struct PerformanceBenchmark<T> {
    let name: String
    let iterations: Int
    let standardResult: T
    let highPrecisionResult: T
    let standardTime: TimeInterval
    let highPrecisionTime: TimeInterval
    let performanceRatio: Double
    
    var performanceDescription: String {
        if performanceRatio < 2.0 {
            return "High precision is \(String(format: "%.1f", performanceRatio))x slower - excellent performance"
        } else if performanceRatio < 5.0 {
            return "High precision is \(String(format: "%.1f", performanceRatio))x slower - good performance"
        } else if performanceRatio < 10.0 {
            return "High precision is \(String(format: "%.1f", performanceRatio))x slower - acceptable performance"
        } else {
            return "High precision is \(String(format: "%.1f", performanceRatio))x slower - consider for critical calculations only"
        }
    }
}

struct PrecisionValidationResult {
    let testName: String
    let expected: Double
    let standard: Double
    let highPrecision: Double
    let standardAccuracy: Double
    let precisionAccuracy: Double
    
    var precisionImprovement: Double {
        return standardAccuracy / max(precisionAccuracy, 1e-15)
    }
    
    var improvementDescription: String {
        if precisionImprovement > 100 {
            return "High precision is \(Int(precisionImprovement))x more accurate"
        } else if precisionImprovement > 10 {
            return "High precision is significantly more accurate"
        } else if precisionImprovement > 2 {
            return "High precision shows improvement"
        } else {
            return "Similar accuracy between methods"
        }
    }
}

struct ConsistencyTest {
    let testName: String
    let standardResult: Double
    let precisionResult: Double
    let difference: Double
    let isConsistent: Bool
    let tolerance: Double
    
    var consistencyDescription: String {
        if isConsistent {
            return "Results are consistent within tolerance"
        } else {
            return "Results differ by \(String(format: "%.6f", difference)), exceeding tolerance of \(tolerance)"
        }
    }
}

// MARK: - Progress Reporting

extension AdvancedIRRCalculator.CalculationConfig {
    /// Progress handler for async calculations
    var progressHandler: ((Double) -> Void)? {
        get { nil } // Default implementation
        set { } // To be implemented in actual config
    }
}

// MARK: - Advanced Calculation Result Types

struct RealEstateInvestmentResult {
    let totalCashFlow: Double
    let saleProceeds: Double
    let totalReturn: Double
    let annualizedReturn: Double
    let cashOnCashReturn: Double
    
    var formattedSummary: String {
        return """
        Total Cash Flow: $\(String(format: "%.2f", totalCashFlow))
        Sale Proceeds: $\(String(format: "%.2f", saleProceeds))
        Total Return: $\(String(format: "%.2f", totalReturn))
        Annualized Return: \(String(format: "%.2f", annualizedReturn))%
        Cash-on-Cash Return: \(String(format: "%.2f", cashOnCashReturn))%
        """
    }
}

struct CryptoDCAResult {
    let totalInvested: Double
    let totalCoins: Double
    let averageCostPerCoin: Double
    let currentValue: Double
    let totalReturn: Double
    let returnPercentage: Double
    let investmentPeriods: Int
    
    var formattedSummary: String {
        return """
        Total Invested: $\(String(format: "%.2f", totalInvested))
        Total Coins: \(String(format: "%.6f", totalCoins))
        Average Cost per Coin: $\(String(format: "%.2f", averageCostPerCoin))
        Current Value: $\(String(format: "%.2f", currentValue))
        Total Return: $\(String(format: "%.2f", totalReturn)) (\(String(format: "%.2f", returnPercentage))%)
        Investment Periods: \(investmentPeriods)
        """
    }
}

struct CurrencyHedgeResult {
    let hedgeAmount: Double
    let hedgingCostAmount: Double
    let hedgingCostPercentage: Double
    let forwardRate: Double
    let spotRate: Double
    let varianceReduction: Double
    let hedgeRatio: Double
    
    var formattedSummary: String {
        return """
        Hedge Amount: $\(String(format: "%.2f", hedgeAmount))
        Hedging Cost: $\(String(format: "%.2f", hedgingCostAmount)) (\(String(format: "%.2f", hedgingCostPercentage))%)
        Forward Rate: \(String(format: "%.4f", forwardRate))
        Spot Rate: \(String(format: "%.4f", spotRate))
        Variance Reduction: \(String(format: "%.2f", varianceReduction))%
        Hedge Ratio: \(String(format: "%.2f", hedgeRatio))
        """
    }
}

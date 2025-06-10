//
//  AdvancedBondPricingEngine.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation

/// Advanced bond pricing engine with comprehensive analytics matching Wolfram Alpha capabilities
class AdvancedBondPricingEngine: ObservableObject {
    
    private let yieldCurve: YieldCurve
    private let monteCarlo: MonteCarloEngine
    private let optionPricer: BondOptionPricer
    
    init(yieldCurve: YieldCurve = YieldCurve()) {
        self.yieldCurve = yieldCurve
        self.monteCarlo = MonteCarloEngine()
        self.optionPricer = BondOptionPricer()
    }
    
    // MARK: - Main Pricing Function
    
    func priceBond(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        bondStructure: BondStructure,
        creditAnalysis: CreditAnalysis,
        embeddedOptions: [EmbeddedOption] = [],
        taxAnalysis: TaxAnalysis? = nil,
        marketData: BondMarketData? = nil
    ) -> AdvancedBondResults {
        
        var results = AdvancedBondResults()
        
        // 1. Basic Bond Pricing
        let basicResults = calculateBasicBondMetrics(
            faceValue: faceValue,
            couponRate: couponRate,
            maturity: maturity,
            frequency: frequency,
            bondStructure: bondStructure,
            creditAnalysis: creditAnalysis
        )
        
        // 2. Option-Adjusted Analysis (if embedded options exist)
        if !embeddedOptions.isEmpty {
            let optionResults = calculateOptionAdjustedMetrics(
                basicPrice: basicResults.dirtyPrice,
                faceValue: faceValue,
                couponRate: couponRate,
                maturity: maturity,
                frequency: frequency,
                embeddedOptions: embeddedOptions,
                creditAnalysis: creditAnalysis
            )
            results.optionAdjustedSpread = optionResults.oas
            results.optionValue = optionResults.optionValue
            results.effectiveDuration = optionResults.effectiveDuration
            results.effectiveConvexity = optionResults.effectiveConvexity
        }
        
        // 3. Monte Carlo Analysis
        let monteCarloResults = monteCarlo.simulateBondPrice(
            faceValue: faceValue,
            couponRate: couponRate,
            maturity: maturity,
            frequency: frequency,
            creditAnalysis: creditAnalysis,
            simulations: 10000
        )
        
        // 4. Scenario Analysis
        let scenarioResults = performScenarioAnalysis(
            faceValue: faceValue,
            couponRate: couponRate,
            maturity: maturity,
            frequency: frequency,
            creditAnalysis: creditAnalysis,
            embeddedOptions: embeddedOptions
        )
        
        // 5. Tax Analysis
        if let taxAnalysis = taxAnalysis {
            results.afterTaxYield = taxAnalysis.calculateAfterTaxYield(basicResults.yieldToMaturity)
            if creditAnalysis.rating.rawValue.hasPrefix("AAA") || creditAnalysis.rating.rawValue.hasPrefix("AA") {
                results.taxEquivalentYield = taxAnalysis.calculateTaxEquivalentYield(basicResults.yieldToMaturity)
            }
        }
        
        // Combine all results
        results.dirtyPrice = basicResults.dirtyPrice
        results.cleanPrice = basicResults.cleanPrice
        results.accruedInterest = basicResults.accruedInterest
        results.yieldToMaturity = basicResults.yieldToMaturity
        results.yieldToCall = basicResults.yieldToCall
        results.yieldToWorst = basicResults.yieldToWorst
        results.macaulayDuration = basicResults.macaulayDuration
        results.modifiedDuration = basicResults.modifiedDuration
        results.convexity = basicResults.convexity
        results.dv01 = basicResults.dv01
        results.pvbp = basicResults.pvbp
        results.currentYield = basicResults.currentYield
        results.creditVaR = creditAnalysis.creditVaR
        results.expectedLoss = creditAnalysis.expectedLoss
        results.zSpread = calculateZSpread(basicResults.dirtyPrice, faceValue, couponRate, maturity, frequency)
        results.iSpread = calculateISpread(basicResults.yieldToMaturity, maturity)
        results.monteCarloPrice = monteCarloResults.meanPrice
        results.monteCarloStdDev = monteCarloResults.standardDeviation
        results.priceConfidenceInterval = monteCarloResults.confidenceInterval
        results.bullScenarioPrice = scenarioResults.bullPrice
        results.bearScenarioPrice = scenarioResults.bearPrice
        results.baseScenarioPrice = scenarioResults.basePrice
        
        return results
    }
    
    // MARK: - Basic Bond Metrics Calculation
    
    private func calculateBasicBondMetrics(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        bondStructure: BondStructure,
        creditAnalysis: CreditAnalysis
    ) -> BasicBondResults {
        
        let periodsPerYear = frequency.periodsPerYear
        let totalPeriods = Int(maturity * periodsPerYear)
        let riskFreeRate = yieldCurve.getYield(for: maturity)
        let creditAdjustedRate = (riskFreeRate + creditAnalysis.creditSpread) / periodsPerYear
        let periodCoupon = (couponRate / 100.0 * faceValue) / periodsPerYear
        
        var price = 0.0
        var accruedInterest = 0.0
        var macaulayDuration = 0.0
        var convexity = 0.0
        var cashFlows: [(period: Int, amount: Double, pv: Double)] = []
        
        // Calculate accrued interest (simplified - assumes 30 days since last coupon)
        accruedInterest = bondStructure == .zero ? 0.0 : (periodCoupon * 30.0 / (365.0 / periodsPerYear))
        
        switch bondStructure {
        case .fixed:
            (price, macaulayDuration, convexity, cashFlows) = calculateFixedRateBond(
                faceValue: faceValue,
                periodCoupon: periodCoupon,
                creditAdjustedRate: creditAdjustedRate,
                totalPeriods: totalPeriods,
                periodsPerYear: periodsPerYear
            )
            
        case .zero:
            price = faceValue / pow(1 + creditAdjustedRate, Double(totalPeriods))
            macaulayDuration = maturity
            convexity = maturity * (maturity + 1) / pow(1 + creditAdjustedRate, 2)
            
        case .floating:
            (price, macaulayDuration, convexity) = calculateFloatingRateBond(
                faceValue: faceValue,
                maturity: maturity,
                creditAnalysis: creditAnalysis
            )
            
        case .perpetual:
            price = (couponRate / 100.0 * faceValue) / (riskFreeRate + creditAnalysis.creditSpread)
            macaulayDuration = (1 + riskFreeRate + creditAnalysis.creditSpread) / (riskFreeRate + creditAnalysis.creditSpread)
            convexity = 2 / pow(riskFreeRate + creditAnalysis.creditSpread, 3)
            
        case .callable, .putable, .convertible:
            // These require option pricing models - will be handled in option-adjusted section
            (price, macaulayDuration, convexity, cashFlows) = calculateFixedRateBond(
                faceValue: faceValue,
                periodCoupon: periodCoupon,
                creditAdjustedRate: creditAdjustedRate,
                totalPeriods: totalPeriods,
                periodsPerYear: periodsPerYear
            )
            
        case .step:
            (price, macaulayDuration, convexity) = calculateStepUpBond(
                faceValue: faceValue,
                couponRate: couponRate,
                maturity: maturity,
                frequency: frequency,
                creditAnalysis: creditAnalysis
            )
            
        case .inverse:
            (price, macaulayDuration, convexity) = calculateInverseFloater(
                faceValue: faceValue,
                maturity: maturity,
                creditAnalysis: creditAnalysis
            )
        }
        
        let modifiedDuration = macaulayDuration / (1 + creditAdjustedRate)
        let dv01 = modifiedDuration * price * 0.0001
        let pvbp = dv01
        
        let yieldToMaturity = calculateYieldToMaturity(
            price: price,
            faceValue: faceValue,
            couponRate: couponRate,
            maturity: maturity,
            frequency: frequency
        )
        
        let yieldToCall = bondStructure == .callable ? 
            calculateYieldToCall(price: price, faceValue: faceValue, couponRate: couponRate, maturity: maturity, frequency: frequency) : nil
        
        let yieldToWorst = min(yieldToMaturity, yieldToCall ?? yieldToMaturity)
        
        let currentYield = bondStructure == .zero ? 0 : (couponRate / 100.0 * faceValue) / price
        let cleanPrice = price - accruedInterest
        
        return BasicBondResults(
            dirtyPrice: price,
            cleanPrice: cleanPrice,
            accruedInterest: accruedInterest,
            yieldToMaturity: yieldToMaturity,
            yieldToCall: yieldToCall,
            yieldToWorst: yieldToWorst,
            macaulayDuration: macaulayDuration,
            modifiedDuration: modifiedDuration,
            convexity: convexity,
            dv01: dv01,
            pvbp: pvbp,
            currentYield: currentYield
        )
    }
    
    // MARK: - Fixed Rate Bond Calculation
    
    private func calculateFixedRateBond(
        faceValue: Double,
        periodCoupon: Double,
        creditAdjustedRate: Double,
        totalPeriods: Int,
        periodsPerYear: Double
    ) -> (price: Double, duration: Double, convexity: Double, cashFlows: [(period: Int, amount: Double, pv: Double)]) {
        
        var price = 0.0
        var duration = 0.0
        var convexity = 0.0
        var cashFlows: [(period: Int, amount: Double, pv: Double)] = []
        
        // Coupon payments
        for i in 1...totalPeriods {
            let t = Double(i)
            let cashFlow = i == totalPeriods ? periodCoupon + faceValue : periodCoupon
            let pv = cashFlow / pow(1 + creditAdjustedRate, t)
            
            price += pv
            duration += (t / periodsPerYear) * pv
            convexity += t * (t + 1) * pv / pow(1 + creditAdjustedRate, 2)
            
            cashFlows.append((period: i, amount: cashFlow, pv: pv))
        }
        
        duration = duration / price
        convexity = convexity / price / periodsPerYear / periodsPerYear
        
        return (price, duration, convexity, cashFlows)
    }
    
    // MARK: - Option-Adjusted Metrics
    
    private func calculateOptionAdjustedMetrics(
        basicPrice: Double,
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        embeddedOptions: [EmbeddedOption],
        creditAnalysis: CreditAnalysis
    ) -> OptionAdjustedResults {
        
        // Use binomial tree for option pricing
        let tree = BinomialTree(
            steps: 100,
            maturity: maturity,
            volatility: embeddedOptions.first?.volatility ?? 0.2
        )
        
        let optionFreePrice = basicPrice
        let optionPrice = optionPricer.priceEmbeddedOptions(
            embeddedOptions: embeddedOptions,
            bondPrice: basicPrice,
            faceValue: faceValue,
            couponRate: couponRate,
            maturity: maturity,
            frequency: frequency,
            tree: tree
        )
        
        let optionAdjustedPrice = optionFreePrice - optionPrice
        let oas = calculateOAS(optionAdjustedPrice: optionAdjustedPrice, optionFreePrice: optionFreePrice)
        
        // Effective duration and convexity with embedded options
        let shiftSize = 0.01 // 100 basis points
        let upPrice = optionPricer.priceWithYieldShift(shift: shiftSize, bondPrice: basicPrice, embeddedOptions: embeddedOptions)
        let downPrice = optionPricer.priceWithYieldShift(shift: -shiftSize, bondPrice: basicPrice, embeddedOptions: embeddedOptions)
        
        let effectiveDuration = (downPrice - upPrice) / (2 * optionAdjustedPrice * shiftSize)
        let effectiveConvexity = (upPrice + downPrice - 2 * optionAdjustedPrice) / (optionAdjustedPrice * shiftSize * shiftSize)
        
        return OptionAdjustedResults(
            oas: oas,
            optionValue: optionPrice,
            effectiveDuration: effectiveDuration,
            effectiveConvexity: effectiveConvexity
        )
    }
    
    // MARK: - Floating Rate Bond
    
    private func calculateFloatingRateBond(
        faceValue: Double,
        maturity: Double,
        creditAnalysis: CreditAnalysis
    ) -> (price: Double, duration: Double, convexity: Double) {
        
        // For floating rate bonds, price typically trades close to par
        // Duration is approximately equal to the reset period
        let price = faceValue // Simplified - would be more complex in reality
        let duration = 0.25 // Quarterly reset assumption
        let convexity = 0.1 // Very low convexity for floaters
        
        return (price, duration, convexity)
    }
    
    // MARK: - Step-Up Bond
    
    private func calculateStepUpBond(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        creditAnalysis: CreditAnalysis
    ) -> (price: Double, duration: Double, convexity: Double) {
        
        // Simplified step-up calculation
        // In reality, would need the specific step schedule
        let basePrice = faceValue
        let adjustedPrice = basePrice * 1.02 // 2% premium for step-up feature
        let duration = maturity * 0.8 // Reduced duration due to step-up
        let convexity = maturity * 0.5
        
        return (adjustedPrice, duration, convexity)
    }
    
    // MARK: - Inverse Floater
    
    private func calculateInverseFloater(
        faceValue: Double,
        maturity: Double,
        creditAnalysis: CreditAnalysis
    ) -> (price: Double, duration: Double, convexity: Double) {
        
        // Inverse floaters have negative duration characteristics
        let price = faceValue * 0.98 // Typically trade at discount
        let duration = -maturity * 0.5 // Negative duration
        let convexity = maturity * 2.0 // High convexity
        
        return (price, duration, convexity)
    }
    
    // MARK: - Spread Calculations
    
    private func calculateZSpread(_ bondPrice: Double, _ faceValue: Double, _ couponRate: Double, _ maturity: Double, _ frequency: PaymentFrequency) -> Double {
        // Z-spread calculation using iterative method
        var zSpread = 0.01 // Initial guess
        let tolerance = 0.0001
        var iteration = 0
        let maxIterations = 100
        
        while iteration < maxIterations {
            let calculatedPrice = calculatePriceWithZSpread(faceValue, couponRate, maturity, frequency, zSpread)
            let priceDiff = calculatedPrice - bondPrice
            
            if abs(priceDiff) < tolerance {
                break
            }
            
            // Newton-Raphson iteration
            let deltaPrice = calculatePriceWithZSpread(faceValue, couponRate, maturity, frequency, zSpread + 0.0001) - calculatedPrice
            zSpread -= priceDiff / (deltaPrice / 0.0001)
            
            iteration += 1
        }
        
        return zSpread
    }
    
    private func calculatePriceWithZSpread(_ faceValue: Double, _ couponRate: Double, _ maturity: Double, _ frequency: PaymentFrequency, _ zSpread: Double) -> Double {
        let periodsPerYear = frequency.periodsPerYear
        let totalPeriods = Int(maturity * periodsPerYear)
        let periodCoupon = (couponRate / 100.0 * faceValue) / periodsPerYear
        
        var price = 0.0
        
        for i in 1...totalPeriods {
            let t = Double(i) / periodsPerYear
            let spotRate = yieldCurve.getSpotRate(for: t)
            let discountRate = (spotRate + zSpread) / periodsPerYear
            let cashFlow = i == totalPeriods ? periodCoupon + faceValue : periodCoupon
            
            price += cashFlow / pow(1 + discountRate, Double(i))
        }
        
        return price
    }
    
    private func calculateISpread(_ yieldToMaturity: Double, _ maturity: Double) -> Double {
        let interpolatedTreasuryYield = yieldCurve.getYield(for: maturity)
        return yieldToMaturity - interpolatedTreasuryYield
    }
    
    // MARK: - Yield Calculations
    
    private func calculateYieldToMaturity(price: Double, faceValue: Double, couponRate: Double, maturity: Double, frequency: PaymentFrequency) -> Double {
        // Newton-Raphson method for YTM
        var yield = 0.05 // Initial guess
        let tolerance = 0.000001
        var iteration = 0
        let maxIterations = 100
        
        while iteration < maxIterations {
            let (calculatedPrice, derivative) = calculatePriceAndDerivative(yield, faceValue, couponRate, maturity, frequency)
            let priceDiff = calculatedPrice - price
            
            if abs(priceDiff) < tolerance {
                break
            }
            
            yield -= priceDiff / derivative
            iteration += 1
        }
        
        return yield
    }
    
    private func calculatePriceAndDerivative(_ yield: Double, _ faceValue: Double, _ couponRate: Double, _ maturity: Double, _ frequency: PaymentFrequency) -> (price: Double, derivative: Double) {
        let periodsPerYear = frequency.periodsPerYear
        let totalPeriods = Int(maturity * periodsPerYear)
        let periodYield = yield / periodsPerYear
        let periodCoupon = (couponRate / 100.0 * faceValue) / periodsPerYear
        
        var price = 0.0
        var derivative = 0.0
        
        for i in 1...totalPeriods {
            let t = Double(i)
            let cashFlow = i == totalPeriods ? periodCoupon + faceValue : periodCoupon
            let discountFactor = pow(1 + periodYield, t)
            
            price += cashFlow / discountFactor
            derivative -= t * cashFlow / (discountFactor * (1 + periodYield) * periodsPerYear)
        }
        
        return (price, derivative)
    }
    
    private func calculateYieldToCall(price: Double, faceValue: Double, couponRate: Double, maturity: Double, frequency: PaymentFrequency) -> Double {
        // Simplified YTC calculation assuming call at par in 5 years
        let callDate = min(5.0, maturity)
        let callPrice = faceValue * 1.02 // 2% call premium
        
        return calculateYieldToMaturity(
            price: price,
            faceValue: callPrice,
            couponRate: couponRate,
            maturity: callDate,
            frequency: frequency
        )
    }
    
    // MARK: - Scenario Analysis
    
    private func performScenarioAnalysis(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        creditAnalysis: CreditAnalysis,
        embeddedOptions: [EmbeddedOption]
    ) -> ScenarioResults {
        
        let scenarios = [
            ScenarioDefinition(name: "Bull", yieldShift: -0.02, creditSpreadShift: -0.001, volatilityShift: -0.05, probability: 0.25),
            ScenarioDefinition(name: "Base", yieldShift: 0.0, creditSpreadShift: 0.0, volatilityShift: 0.0, probability: 0.5),
            ScenarioDefinition(name: "Bear", yieldShift: 0.03, creditSpreadShift: 0.002, volatilityShift: 0.1, probability: 0.25)
        ]
        
        var bullPrice = 0.0
        var basePrice = 0.0
        var bearPrice = 0.0
        
        for scenario in scenarios {
            let adjustedCredit = CreditAnalysis(
                rating: creditAnalysis.rating,
                customSpread: creditAnalysis.creditSpread + scenario.creditSpreadShift,
                recoveryRate: creditAnalysis.recoveryRate
            )
            
            let results = calculateBasicBondMetrics(
                faceValue: faceValue,
                couponRate: couponRate,
                maturity: maturity,
                frequency: frequency,
                bondStructure: .fixed,
                creditAnalysis: adjustedCredit
            )
            
            switch scenario.name {
            case "Bull": bullPrice = results.dirtyPrice
            case "Base": basePrice = results.dirtyPrice
            case "Bear": bearPrice = results.dirtyPrice
            default: break
            }
        }
        
        return ScenarioResults(bullPrice: bullPrice, basePrice: basePrice, bearPrice: bearPrice)
    }
    
    private func calculateOAS(optionAdjustedPrice: Double, optionFreePrice: Double) -> Double {
        // Simplified OAS calculation
        return log(optionFreePrice / optionAdjustedPrice) * 10000 // in basis points
    }
}

// MARK: - Supporting Structures

struct BasicBondResults {
    let dirtyPrice: Double
    let cleanPrice: Double
    let accruedInterest: Double
    let yieldToMaturity: Double
    let yieldToCall: Double?
    let yieldToWorst: Double
    let macaulayDuration: Double
    let modifiedDuration: Double
    let convexity: Double
    let dv01: Double
    let pvbp: Double
    let currentYield: Double
}

struct OptionAdjustedResults {
    let oas: Double
    let optionValue: Double
    let effectiveDuration: Double
    let effectiveConvexity: Double
}

struct ScenarioResults {
    let bullPrice: Double
    let basePrice: Double
    let bearPrice: Double
}

struct MonteCarloResults {
    let meanPrice: Double
    let standardDeviation: Double
    let confidenceInterval: (lower: Double, upper: Double)
}

// MARK: - Monte Carlo Engine

class MonteCarloEngine {
    func simulateBondPrice(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        creditAnalysis: CreditAnalysis,
        simulations: Int
    ) -> MonteCarloResults {
        
        var prices: [Double] = []
        
        for _ in 0..<simulations {
            // Generate random yield and credit spread
            let randomYield = generateRandomYield()
            let randomSpread = generateRandomCreditSpread(baseSpread: creditAnalysis.creditSpread)
            
            // Calculate price for this scenario
            let price = calculatePriceForScenario(
                faceValue: faceValue,
                couponRate: couponRate,
                maturity: maturity,
                frequency: frequency,
                yield: randomYield,
                creditSpread: randomSpread
            )
            
            prices.append(price)
        }
        
        let meanPrice = prices.reduce(0, +) / Double(prices.count)
        let variance = prices.map { pow($0 - meanPrice, 2) }.reduce(0, +) / Double(prices.count)
        let standardDeviation = sqrt(variance)
        
        let sortedPrices = prices.sorted()
        let lowerIndex = Int(0.025 * Double(prices.count))
        let upperIndex = Int(0.975 * Double(prices.count))
        let confidenceInterval = (lower: sortedPrices[lowerIndex], upper: sortedPrices[upperIndex])
        
        return MonteCarloResults(
            meanPrice: meanPrice,
            standardDeviation: standardDeviation,
            confidenceInterval: confidenceInterval
        )
    }
    
    private func generateRandomYield() -> Double {
        // Box-Muller transform for normal distribution
        let u1 = Double.random(in: 0...1)
        let u2 = Double.random(in: 0...1)
        let z = sqrt(-2 * log(u1)) * cos(2 * Double.pi * u2)
        return 0.05 + z * 0.02 // 5% mean, 2% volatility
    }
    
    private func generateRandomCreditSpread(baseSpread: Double) -> Double {
        let u1 = Double.random(in: 0...1)
        let u2 = Double.random(in: 0...1)
        let z = sqrt(-2 * log(u1)) * cos(2 * Double.pi * u2)
        return max(0, baseSpread + z * baseSpread * 0.5) // 50% volatility of base spread
    }
    
    private func calculatePriceForScenario(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        yield: Double,
        creditSpread: Double
    ) -> Double {
        
        let periodsPerYear = frequency.periodsPerYear
        let totalPeriods = Int(maturity * periodsPerYear)
        let totalRate = (yield + creditSpread) / periodsPerYear
        let periodCoupon = (couponRate / 100.0 * faceValue) / periodsPerYear
        
        var price = 0.0
        
        for i in 1...totalPeriods {
            let cashFlow = i == totalPeriods ? periodCoupon + faceValue : periodCoupon
            price += cashFlow / pow(1 + totalRate, Double(i))
        }
        
        return price
    }
}

// MARK: - Bond Option Pricer

class BondOptionPricer {
    
    func priceEmbeddedOptions(
        embeddedOptions: [EmbeddedOption],
        bondPrice: Double,
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        tree: BinomialTree
    ) -> Double {
        
        var totalOptionValue = 0.0
        
        for option in embeddedOptions {
            let optionValue = priceOption(
                option: option,
                bondPrice: bondPrice,
                faceValue: faceValue,
                couponRate: couponRate,
                maturity: maturity,
                frequency: frequency,
                tree: tree
            )
            totalOptionValue += optionValue
        }
        
        return totalOptionValue
    }
    
    private func priceOption(
        option: EmbeddedOption,
        bondPrice: Double,
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        tree: BinomialTree
    ) -> Double {
        
        // Simplified option pricing using Black-Scholes adapted for bonds
        let timeToExpiry = option.exerciseDates.first ?? maturity
        let volatility = option.volatility
        let riskFreeRate = 0.05 // Would normally come from yield curve
        
        let d1 = (log(bondPrice / option.exercisePrice) + (riskFreeRate + 0.5 * volatility * volatility) * timeToExpiry) / (volatility * sqrt(timeToExpiry))
        let d2 = d1 - volatility * sqrt(timeToExpiry)
        
        switch option.type {
        case .call:
            return bondPrice * normalCDF(d1) - option.exercisePrice * exp(-riskFreeRate * timeToExpiry) * normalCDF(d2)
        case .put:
            return option.exercisePrice * exp(-riskFreeRate * timeToExpiry) * normalCDF(-d2) - bondPrice * normalCDF(-d1)
        }
    }
    
    func priceWithYieldShift(shift: Double, bondPrice: Double, embeddedOptions: [EmbeddedOption]) -> Double {
        // Simplified yield shift pricing
        let shiftedPrice = bondPrice * (1 - shift * 5) // Approximation
        return shiftedPrice
    }
    
    private func normalCDF(_ x: Double) -> Double {
        return 0.5 * (1 + erf(x / sqrt(2)))
    }
    
    private func erf(_ x: Double) -> Double {
        // Approximation of error function
        let a1 =  0.254829592
        let a2 = -0.284496736
        let a3 =  1.421413741
        let a4 = -1.453152027
        let a5 =  1.061405429
        let p  =  0.3275911
        
        let sign = x < 0 ? -1.0 : 1.0
        let x = abs(x)
        
        let t = 1.0 / (1.0 + p * x)
        let y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x)
        
        return sign * y
    }
}

// MARK: - Binomial Tree

struct BinomialTree {
    let steps: Int
    let maturity: Double
    let volatility: Double
    let dt: Double
    let u: Double
    let d: Double
    let p: Double
    
    init(steps: Int, maturity: Double, volatility: Double) {
        self.steps = steps
        self.maturity = maturity
        self.volatility = volatility
        self.dt = maturity / Double(steps)
        self.u = exp(volatility * sqrt(dt))
        self.d = 1.0 / u
        self.p = (exp(0.05 * dt) - d) / (u - d) // Risk-neutral probability
    }
}
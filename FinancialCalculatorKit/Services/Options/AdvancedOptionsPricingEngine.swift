//
//  AdvancedOptionsPricingEngine.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation

/// Professional-grade options pricing engine with multiple models and advanced analytics
class AdvancedOptionsPricingEngine: ObservableObject {
    
    private let binomialPricer: BinomialTreePricer
    private let monteCarloPricer: MonteCarloOptionsPricer
    private let hestonPricer: HestonModelPricer
    private let sabrPricer: SABRModelPricer
    private let jumpDiffusionPricer: JumpDiffusionPricer
    private let exoticOptionsPricer: ExoticOptionsPricer
    
    init() {
        self.binomialPricer = BinomialTreePricer()
        self.monteCarloPricer = MonteCarloOptionsPricer()
        self.hestonPricer = HestonModelPricer()
        self.sabrPricer = SABRModelPricer()
        self.jumpDiffusionPricer = JumpDiffusionPricer()
        self.exoticOptionsPricer = ExoticOptionsPricer()
    }
    
    // MARK: - Main Pricing Function
    
    func priceOption(
        optionType: OptionType,
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double,
        volatilityModel: VolatilityModel = .blackScholes,
        hestonParams: HestonParameters? = nil,
        sabrParams: SABRParameters? = nil,
        jumpParams: JumpDiffusionParameters? = nil,
        barrierType: BarrierType? = nil,
        barrierLevel: Double? = nil,
        asianType: AsianType? = nil,
        monteCarloParams: MonteCarloParameters? = nil
    ) -> AdvancedOptionsResults {
        
        // 1. Black-Scholes baseline pricing
        let bsPrice = blackScholesPrice(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        // 2. Calculate advanced Greeks
        let greeks = calculateAdvancedGreeks(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        // 3. Model-specific pricing
        var binomialPrice: Double? = nil
        var monteCarloPrice: Double? = nil
        var monteCarloStdErr: Double? = nil
        var hestonPrice: Double? = nil
        var jumpDiffusionPrice: Double? = nil
        
        // Binomial tree pricing (for American options)
        if optionType == .american {
            binomialPrice = binomialPricer.priceAmericanOption(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility,
                steps: 1000
            )
        }
        
        // Monte Carlo pricing
        if let mcParams = monteCarloParams {
            let mcResult = monteCarloPricer.priceOption(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility,
                parameters: mcParams
            )
            monteCarloPrice = mcResult.price
            monteCarloStdErr = mcResult.standardError
        }
        
        // Heston model pricing
        if let hestonParams = hestonParams, hestonParams.isValid {
            hestonPrice = hestonPricer.priceOption(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                hestonParams: hestonParams
            )
        }
        
        // Jump-diffusion pricing
        if let jumpParams = jumpParams, jumpParams.isValid {
            jumpDiffusionPrice = jumpDiffusionPricer.priceOption(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility,
                jumpParams: jumpParams
            )
        }
        
        // 4. Exotic options pricing
        var barrierProbability: Double? = nil
        var asianAveragePrice: Double? = nil
        var lookbackMinMax: (min: Double, max: Double)? = nil
        
        if optionType == .barrier, let barrierType = barrierType, let barrierLevel = barrierLevel {
            let barrierResult = exoticOptionsPricer.priceBarrierOption(
                optionStyle: optionStyle,
                barrierType: barrierType,
                spotPrice: spotPrice,
                strike: strike,
                barrierLevel: barrierLevel,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            barrierProbability = barrierResult.knockoutProbability
        }
        
        if optionType == .asian, let asianType = asianType {
            asianAveragePrice = exoticOptionsPricer.priceAsianOption(
                optionStyle: optionStyle,
                asianType: asianType,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
        }
        
        if optionType == .lookback {
            let lookbackResult = exoticOptionsPricer.priceLookbackOption(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            lookbackMinMax = (min: lookbackResult.minPrice, max: lookbackResult.maxPrice)
        }
        
        // 5. Risk metrics calculation
        let riskMetrics = calculateRiskMetrics(
            optionPrice: bsPrice,
            greeks: greeks,
            spotPrice: spotPrice,
            volatility: volatility,
            timeToExpiration: timeToExpiration
        )
        
        // 6. Scenario analysis
        let deltaScenarios = generateDeltaScenarios(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        let vegaScenarios = generateVegaScenarios(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        let thetaDecay = generateThetaDecay(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        // 7. Calculate intrinsic and time value
        let intrinsicValue = calculateIntrinsicValue(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike
        )
        let timeValue = bsPrice - intrinsicValue
        
        // 8. Probability analysis
        let probOfProfit = calculateProbabilityOfProfit(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            optionPrice: bsPrice,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        let probDistribution = generateProbabilityDistribution(
            spotPrice: spotPrice,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        return AdvancedOptionsResults(
            optionPrice: bsPrice,
            intrinsicValue: intrinsicValue,
            timeValue: timeValue,
            impliedVolatility: volatility,
            greeks: greeks,
            riskMetrics: riskMetrics,
            strategyValue: bsPrice,
            maxProfit: optionStyle == .call ? Double.infinity : strike,
            maxLoss: -bsPrice,
            breakevenPoints: [calculateBreakeven(optionStyle: optionStyle, strike: strike, premium: bsPrice)],
            probabilityOfProfit: probOfProfit,
            probabilityDistribution: probDistribution,
            binomialTreePrice: binomialPrice,
            monteCarloPrice: monteCarloPrice,
            monteCarloStandardError: monteCarloStdErr,
            hestonPrice: hestonPrice,
            jumpDiffusionPrice: jumpDiffusionPrice,
            deltaScenarios: deltaScenarios,
            vegaScenarios: vegaScenarios,
            thetaDecay: thetaDecay,
            barrierProbability: barrierProbability,
            asianAveragePrice: asianAveragePrice,
            lookbackMinMax: lookbackMinMax
        )
    }
    
    // MARK: - Complex Strategy Pricing
    
    func priceComplexStrategy(
        strategy: ComplexStrategy,
        strategyDefinition: StrategyDefinition,
        spotPrice: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> AdvancedOptionsResults {
        
        var totalValue = 0.0
        var totalDelta = 0.0
        var totalGamma = 0.0
        var totalTheta = 0.0
        var totalVega = 0.0
        var totalRho = 0.0
        
        // Price each leg of the strategy
        for leg in strategyDefinition.legs {
            let legResult = priceOption(
                optionType: .european,
                optionStyle: leg.optionType,
                spotPrice: spotPrice,
                strike: leg.strike,
                timeToExpiration: leg.expiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            
            let quantity = Double(leg.quantity)
            totalValue += legResult.optionPrice * quantity
            totalDelta += legResult.greeks.delta * quantity
            totalGamma += legResult.greeks.gamma * quantity
            totalTheta += legResult.greeks.theta * quantity
            totalVega += legResult.greeks.vega * quantity
            totalRho += legResult.greeks.rho * quantity
        }
        
        // Add underlying position if applicable
        if strategyDefinition.underlyingPosition != 0 {
            totalValue += spotPrice * Double(strategyDefinition.underlyingPosition)
            totalDelta += Double(strategyDefinition.underlyingPosition)
        }
        
        let aggregatedGreeks = AdvancedGreeks(
            delta: totalDelta,
            vega: totalVega,
            theta: totalTheta,
            rho: totalRho,
            gamma: totalGamma
        )
        
        // Calculate strategy-specific metrics
        let (maxProfit, maxLoss, breakevenPoints) = calculateStrategyMetrics(
            strategy: strategy,
            strategyDefinition: strategyDefinition,
            spotPrice: spotPrice
        )
        
        let riskMetrics = calculateRiskMetrics(
            optionPrice: totalValue,
            greeks: aggregatedGreeks,
            spotPrice: spotPrice,
            volatility: volatility,
            timeToExpiration: strategyDefinition.legs.first?.expiration ?? 0.25
        )
        
        return AdvancedOptionsResults(
            optionPrice: totalValue,
            intrinsicValue: 0, // Calculate based on strategy
            timeValue: totalValue, // Simplified
            impliedVolatility: volatility,
            greeks: aggregatedGreeks,
            riskMetrics: riskMetrics,
            strategyValue: totalValue,
            maxProfit: maxProfit,
            maxLoss: maxLoss,
            breakevenPoints: breakevenPoints,
            probabilityOfProfit: 0.5, // Calculate based on strategy
            probabilityDistribution: []
        )
    }
    
    // MARK: - Black-Scholes Implementation
    
    private func blackScholesPrice(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> Double {
        
        let d1 = (log(spotPrice / strike) + (riskFreeRate - dividendYield + 0.5 * volatility * volatility) * timeToExpiration) / (volatility * sqrt(timeToExpiration))
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nd1 = cumulativeNormal(d1)
        let nd2 = cumulativeNormal(d2)
        let nmd1 = cumulativeNormal(-d1)
        let nmd2 = cumulativeNormal(-d2)
        
        switch optionStyle {
        case .call:
            return spotPrice * exp(-dividendYield * timeToExpiration) * nd1 - strike * exp(-riskFreeRate * timeToExpiration) * nd2
        case .put:
            return strike * exp(-riskFreeRate * timeToExpiration) * nmd2 - spotPrice * exp(-dividendYield * timeToExpiration) * nmd1
        }
    }
    
    // MARK: - Advanced Greeks Calculation
    
    private func calculateAdvancedGreeks(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> AdvancedGreeks {
        
        let d1 = (log(spotPrice / strike) + (riskFreeRate - dividendYield + 0.5 * volatility * volatility) * timeToExpiration) / (volatility * sqrt(timeToExpiration))
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nd1 = cumulativeNormal(d1)
        let nd2 = cumulativeNormal(d2)
        let nmd1 = cumulativeNormal(-d1)
        let nmd2 = cumulativeNormal(-d2)
        let npd1 = normalDensity(d1)
        let _ = normalDensity(d2)
        
        // First-order Greeks
        let delta = optionStyle == .call ? 
            exp(-dividendYield * timeToExpiration) * nd1 :
            -exp(-dividendYield * timeToExpiration) * nmd1
            
        let vega = spotPrice * exp(-dividendYield * timeToExpiration) * npd1 * sqrt(timeToExpiration) / 100.0
        
        let theta = optionStyle == .call ?
            (-spotPrice * exp(-dividendYield * timeToExpiration) * npd1 * volatility / (2 * sqrt(timeToExpiration)) -
             riskFreeRate * strike * exp(-riskFreeRate * timeToExpiration) * nd2 +
             dividendYield * spotPrice * exp(-dividendYield * timeToExpiration) * nd1) / 365.0 :
            (-spotPrice * exp(-dividendYield * timeToExpiration) * npd1 * volatility / (2 * sqrt(timeToExpiration)) +
             riskFreeRate * strike * exp(-riskFreeRate * timeToExpiration) * nmd2 -
             dividendYield * spotPrice * exp(-dividendYield * timeToExpiration) * nmd1) / 365.0
        
        let rho = optionStyle == .call ?
            strike * timeToExpiration * exp(-riskFreeRate * timeToExpiration) * nd2 / 100.0 :
            -strike * timeToExpiration * exp(-riskFreeRate * timeToExpiration) * nmd2 / 100.0
        
        let epsilon = optionStyle == .call ?
            -spotPrice * timeToExpiration * exp(-dividendYield * timeToExpiration) * nd1 / 100.0 :
            spotPrice * timeToExpiration * exp(-dividendYield * timeToExpiration) * nmd1 / 100.0
        
        // Second-order Greeks
        let gamma = exp(-dividendYield * timeToExpiration) * npd1 / (spotPrice * volatility * sqrt(timeToExpiration))
        
        let vanna = -exp(-dividendYield * timeToExpiration) * npd1 * d2 / volatility / 100.0
        
        let volga = spotPrice * exp(-dividendYield * timeToExpiration) * npd1 * sqrt(timeToExpiration) * d1 * d2 / (volatility * 10000.0)
        
        let charm = optionStyle == .call ?
            -exp(-dividendYield * timeToExpiration) * npd1 * (2 * (riskFreeRate - dividendYield) * timeToExpiration - d2 * volatility * sqrt(timeToExpiration)) / (2 * timeToExpiration * volatility * sqrt(timeToExpiration)) / 365.0 :
            exp(-dividendYield * timeToExpiration) * npd1 * (2 * (riskFreeRate - dividendYield) * timeToExpiration - d2 * volatility * sqrt(timeToExpiration)) / (2 * timeToExpiration * volatility * sqrt(timeToExpiration)) / 365.0
        
        let color = -exp(-dividendYield * timeToExpiration) * npd1 / (2 * spotPrice * timeToExpiration * volatility * sqrt(timeToExpiration)) *
                    (2 * dividendYield * timeToExpiration + 1 + (2 * (riskFreeRate - dividendYield) * timeToExpiration - d2 * volatility * sqrt(timeToExpiration)) * d1 / (volatility * sqrt(timeToExpiration))) / 365.0
        
        // Third-order Greeks (simplified)
        let speed = -gamma / spotPrice * (d1 / (volatility * sqrt(timeToExpiration)) + 1)
        
        let zomma = gamma * (d1 * d2 - 1) / volatility
        
        let ultima = -vega / volatility * (d1 * d2 * (1 - d1 * d2) + d1 * d1 + d2 * d2) / 100.0
        
        return AdvancedGreeks(
            delta: delta,
            vega: vega,
            theta: theta,
            rho: rho,
            epsilon: epsilon,
            gamma: gamma,
            vanna: vanna,
            volga: volga,
            charm: charm,
            color: color,
            speed: speed,
            zomma: zomma,
            ultima: ultima
        )
    }
    
    // MARK: - Risk Metrics Calculation
    
    private func calculateRiskMetrics(
        optionPrice: Double,
        greeks: AdvancedGreeks,
        spotPrice: Double,
        volatility: Double,
        timeToExpiration: Double
    ) -> OptionsRiskMetrics {
        
        // Simplified risk metrics calculation
        let dailyVolatility = volatility / sqrt(252)
        let valueAtRisk = abs(greeks.delta * spotPrice * dailyVolatility * 2.33) // 99% VaR
        let expectedShortfall = valueAtRisk * 1.3 // Simplified CVaR
        
        let maxDrawdown = optionPrice * 0.2 // Simplified estimate
        let sharpeRatio = 0.5 // Would calculate based on historical returns
        
        return OptionsRiskMetrics(
            valueAtRisk: valueAtRisk,
            expectedShortfall: expectedShortfall,
            maxDrawdown: maxDrawdown,
            sharpeRatio: sharpeRatio,
            sortinoRatio: 0.6,
            calmarRatio: 0.4,
            informationRatio: 0.3,
            treynorRatio: 0.25,
            portfolioDelta: greeks.delta,
            portfolioGamma: greeks.gamma,
            portfolioTheta: greeks.theta,
            portfolioVega: greeks.vega,
            portfolioRho: greeks.rho,
            directionalRisk: abs(greeks.delta * spotPrice * volatility),
            volatilityRisk: abs(greeks.vega * volatility),
            timeDecayRisk: abs(greeks.theta * timeToExpiration),
            interestRateRisk: abs(greeks.rho * 0.01),
            dividendRisk: abs(greeks.epsilon * 0.01)
        )
    }
    
    // MARK: - Scenario Analysis
    
    private func generateDeltaScenarios(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> [ScenarioResult] {
        
        var scenarios: [ScenarioResult] = []
        let spotShifts = [-0.2, -0.1, -0.05, 0.0, 0.05, 0.1, 0.2]
        
        for shift in spotShifts {
            let shiftedSpot = spotPrice * (1 + shift)
            let shiftedPrice = blackScholesPrice(
                optionStyle: optionStyle,
                spotPrice: shiftedSpot,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            
            let shiftedGreeks = calculateAdvancedGreeks(
                optionStyle: optionStyle,
                spotPrice: shiftedSpot,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            
            scenarios.append(ScenarioResult(
                scenarioName: "Spot \(shift >= 0 ? "+" : "")\(Int(shift * 100))%",
                parameter: shift,
                optionPrice: shiftedPrice,
                delta: shiftedGreeks.delta,
                gamma: shiftedGreeks.gamma,
                theta: shiftedGreeks.theta,
                vega: shiftedGreeks.vega,
                rho: shiftedGreeks.rho
            ))
        }
        
        return scenarios
    }
    
    private func generateVegaScenarios(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> [ScenarioResult] {
        
        var scenarios: [ScenarioResult] = []
        let volShifts = [-0.5, -0.25, -0.1, 0.0, 0.1, 0.25, 0.5]
        
        for shift in volShifts {
            let shiftedVol = max(0.01, volatility * (1 + shift))
            let shiftedPrice = blackScholesPrice(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: shiftedVol
            )
            
            let shiftedGreeks = calculateAdvancedGreeks(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: shiftedVol
            )
            
            scenarios.append(ScenarioResult(
                scenarioName: "Vol \(shift >= 0 ? "+" : "")\(Int(shift * 100))%",
                parameter: shift,
                optionPrice: shiftedPrice,
                delta: shiftedGreeks.delta,
                gamma: shiftedGreeks.gamma,
                theta: shiftedGreeks.theta,
                vega: shiftedGreeks.vega,
                rho: shiftedGreeks.rho
            ))
        }
        
        return scenarios
    }
    
    private func generateThetaDecay(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> [TheTaDecayPoint] {
        
        var thetaPoints: [TheTaDecayPoint] = []
        let totalDays = Int(timeToExpiration * 365)
        let step = max(1, totalDays / 50)
        
        for days in stride(from: totalDays, through: 1, by: -step) {
            let t = Double(days) / 365.0
            let price = blackScholesPrice(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: t,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            
            let greeks = calculateAdvancedGreeks(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: t,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            
            let intrinsic = calculateIntrinsicValue(optionStyle: optionStyle, spotPrice: spotPrice, strike: strike)
            let timeValue = price - intrinsic
            
            thetaPoints.append(TheTaDecayPoint(
                daysToExpiration: Double(days),
                optionPrice: price,
                theta: greeks.theta,
                timeValue: timeValue
            ))
        }
        
        return thetaPoints
    }
    
    // MARK: - Utility Functions
    
    private func calculateIntrinsicValue(optionStyle: OptionStyle, spotPrice: Double, strike: Double) -> Double {
        switch optionStyle {
        case .call:
            return max(0, spotPrice - strike)
        case .put:
            return max(0, strike - spotPrice)
        }
    }
    
    private func calculateBreakeven(optionStyle: OptionStyle, strike: Double, premium: Double) -> Double {
        switch optionStyle {
        case .call:
            return strike + premium
        case .put:
            return strike - premium
        }
    }
    
    private func calculateProbabilityOfProfit(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        optionPrice: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> Double {
        
        let breakeven = calculateBreakeven(optionStyle: optionStyle, strike: strike, premium: optionPrice)
        let drift = riskFreeRate - dividendYield - 0.5 * volatility * volatility
        let diffusion = volatility * sqrt(timeToExpiration)
        
        let logReturn = log(breakeven / spotPrice)
        let zScore = (logReturn - drift * timeToExpiration) / diffusion
        
        return optionStyle == .call ? 1.0 - cumulativeNormal(zScore) : cumulativeNormal(zScore)
    }
    
    private func generateProbabilityDistribution(
        spotPrice: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> [Double] {
        
        var distribution: [Double] = []
        let numPoints = 100
        let priceRange = (spotPrice * 0.5, spotPrice * 1.5)
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        let drift = riskFreeRate - dividendYield - 0.5 * volatility * volatility
        let diffusion = volatility * sqrt(timeToExpiration)
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            let logReturn = log(price / spotPrice)
            let z = (logReturn - drift * timeToExpiration) / diffusion
            let probability = exp(-0.5 * z * z) / (price * diffusion * sqrt(2 * .pi))
            distribution.append(probability)
        }
        
        return distribution
    }
    
    private func calculateStrategyMetrics(
        strategy: ComplexStrategy,
        strategyDefinition: StrategyDefinition,
        spotPrice: Double
    ) -> (maxProfit: Double, maxLoss: Double, breakevenPoints: [Double]) {
        
        // Simplified strategy metrics calculation
        // In a real implementation, this would be much more sophisticated
        
        switch strategy {
        case .call:
            return (Double.infinity, -strategyDefinition.totalCost, [strategyDefinition.legs.first!.strike + strategyDefinition.totalCost])
        case .put:
            let strike = strategyDefinition.legs.first!.strike
            return (strike - strategyDefinition.totalCost, -strategyDefinition.totalCost, [strike - strategyDefinition.totalCost])
        case .bullCallSpread:
            let lowStrike = strategyDefinition.legs.min(by: { $0.strike < $1.strike })!.strike
            let highStrike = strategyDefinition.legs.max(by: { $0.strike < $1.strike })!.strike
            let maxProfit = highStrike - lowStrike - strategyDefinition.totalCost
            return (maxProfit, -strategyDefinition.totalCost, [lowStrike + strategyDefinition.totalCost])
        default:
            return (strategyDefinition.totalCost * 2, -strategyDefinition.totalCost, [spotPrice])
        }
    }
    
    private func cumulativeNormal(_ x: Double) -> Double {
        return 0.5 * (1 + erf(x / sqrt(2)))
    }
    
    private func normalDensity(_ x: Double) -> Double {
        return exp(-0.5 * x * x) / sqrt(2 * .pi)
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

// MARK: - Specialized Pricers

class BinomialTreePricer {
    func priceAmericanOption(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double,
        steps: Int
    ) -> Double {
        
        let dt = timeToExpiration / Double(steps)
        let u = exp(volatility * sqrt(dt))
        let d = 1.0 / u
        let p = (exp((riskFreeRate - dividendYield) * dt) - d) / (u - d)
        let discount = exp(-riskFreeRate * dt)
        
        // Initialize asset prices at maturity
        let assetPrices = Array(0...steps).map { j in
            spotPrice * pow(u, Double(steps - j)) * pow(d, Double(j))
        }
        
        // Initialize option values at maturity
        var optionValues = assetPrices.map { S in
            switch optionStyle {
            case .call:
                return max(0, S - strike)
            case .put:
                return max(0, strike - S)
            }
        }
        
        // Work backwards through the tree
        for i in (0..<steps).reversed() {
            for j in 0...i {
                let S = spotPrice * pow(u, Double(i - j)) * pow(d, Double(j))
                
                // European value
                let europeanValue = discount * (p * optionValues[j] + (1 - p) * optionValues[j + 1])
                
                // Intrinsic value
                let intrinsicValue = switch optionStyle {
                case .call:
                    max(0, S - strike)
                case .put:
                    max(0, strike - S)
                }
                
                // American value (max of European and intrinsic)
                optionValues[j] = max(europeanValue, intrinsicValue)
            }
        }
        
        return optionValues[0]
    }
}

class MonteCarloOptionsPricer {
    func priceOption(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double,
        parameters: MonteCarloParameters
    ) -> (price: Double, standardError: Double) {
        
        var payoffs: [Double] = []
        let drift = riskFreeRate - dividendYield - 0.5 * volatility * volatility
        let diffusion = volatility * sqrt(timeToExpiration)
        
        for i in 0..<parameters.simulations {
            // Generate random normal
            let u1 = Double.random(in: 0...1)
            let u2 = Double.random(in: 0...1)
            var z = sqrt(-2 * log(u1)) * cos(2 * .pi * u2)
            
            // Antithetic variates
            if parameters.varianceReduction == .antithetic && i % 2 == 1 {
                z = -z
            }
            
            // Generate final stock price
            let finalPrice = spotPrice * exp(drift * timeToExpiration + diffusion * z)
            
            // Calculate payoff
            let payoff = switch optionStyle {
            case .call:
                max(0, finalPrice - strike)
            case .put:
                max(0, strike - finalPrice)
            }
            
            payoffs.append(payoff)
        }
        
        // Discount payoffs to present value
        let discountedPayoffs = payoffs.map { $0 * exp(-riskFreeRate * timeToExpiration) }
        
        let mean = discountedPayoffs.reduce(0, +) / Double(discountedPayoffs.count)
        let variance = discountedPayoffs.map { pow($0 - mean, 2) }.reduce(0, +) / Double(discountedPayoffs.count)
        let standardError = sqrt(variance / Double(discountedPayoffs.count))
        
        return (mean, standardError)
    }
}

class HestonModelPricer {
    func priceOption(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        hestonParams: HestonParameters
    ) -> Double {
        
        // Simplified Heston implementation using characteristic function
        // In practice, this would use FFT or other numerical methods
        
        // For now, return Black-Scholes with adjusted volatility
        let adjustedVol = sqrt(hestonParams.theta)
        
        let d1 = (log(spotPrice / strike) + (riskFreeRate - dividendYield + 0.5 * adjustedVol * adjustedVol) * timeToExpiration) / (adjustedVol * sqrt(timeToExpiration))
        let d2 = d1 - adjustedVol * sqrt(timeToExpiration)
        
        let nd1 = 0.5 * (1 + erf(d1 / sqrt(2)))
        let nd2 = 0.5 * (1 + erf(d2 / sqrt(2)))
        let nmd1 = 0.5 * (1 + erf(-d1 / sqrt(2)))
        let nmd2 = 0.5 * (1 + erf(-d2 / sqrt(2)))
        
        switch optionStyle {
        case .call:
            return spotPrice * exp(-dividendYield * timeToExpiration) * nd1 - strike * exp(-riskFreeRate * timeToExpiration) * nd2
        case .put:
            return strike * exp(-riskFreeRate * timeToExpiration) * nmd2 - spotPrice * exp(-dividendYield * timeToExpiration) * nmd1
        }
    }
    
    private func erf(_ x: Double) -> Double {
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

class SABRModelPricer {
    func priceOption(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        sabrParams: SABRParameters
    ) -> Double {
        
        // Simplified SABR implementation
        // Would use the SABR implied volatility formula
        
        let f = spotPrice * exp((riskFreeRate - dividendYield) * timeToExpiration)
        let k = strike
        
        // SABR implied volatility (simplified)
        let alpha = sabrParams.alpha
        let beta = sabrParams.beta
        let nu = sabrParams.nu
        let rho = sabrParams.rho
        
        let fk = f * k
        let logfk = log(f / k)
        
        let impliedVol = alpha / pow(fk, (1 - beta) / 2) * 
                        (1 + pow(logfk, 2) / 24 + pow(logfk, 4) / 1920) *
                        (1 + (pow(1 - beta, 2) * pow(alpha, 2)) / (24 * pow(fk, 1 - beta)) +
                         (rho * beta * nu * alpha) / (4 * pow(fk, (1 - beta) / 2)) +
                         (2 - 3 * pow(rho, 2)) * pow(nu, 2) / 24) * timeToExpiration
        
        // Use Black-Scholes with SABR implied volatility
        let d1 = (log(spotPrice / strike) + (riskFreeRate - dividendYield + 0.5 * impliedVol * impliedVol) * timeToExpiration) / (impliedVol * sqrt(timeToExpiration))
        let d2 = d1 - impliedVol * sqrt(timeToExpiration)
        
        let nd1 = 0.5 * (1 + erf(d1 / sqrt(2)))
        let nd2 = 0.5 * (1 + erf(d2 / sqrt(2)))
        let nmd1 = 0.5 * (1 + erf(-d1 / sqrt(2)))
        let nmd2 = 0.5 * (1 + erf(-d2 / sqrt(2)))
        
        switch optionStyle {
        case .call:
            return spotPrice * exp(-dividendYield * timeToExpiration) * nd1 - strike * exp(-riskFreeRate * timeToExpiration) * nd2
        case .put:
            return strike * exp(-riskFreeRate * timeToExpiration) * nmd2 - spotPrice * exp(-dividendYield * timeToExpiration) * nmd1
        }
    }
    
    private func erf(_ x: Double) -> Double {
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

class JumpDiffusionPricer {
    func priceOption(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double,
        jumpParams: JumpDiffusionParameters
    ) -> Double {
        
        // Merton jump-diffusion model
        let lambda = jumpParams.jumpIntensity
        let mJ = jumpParams.jumpMean
        let sigmaJ = jumpParams.jumpVolatility
        
        var price = 0.0
        let maxJumps = 20 // Truncate infinite series
        
        for n in 0...maxJumps {
            // Probability of n jumps
            let poissonProb = exp(-lambda * timeToExpiration) * pow(lambda * timeToExpiration, Double(n)) / factorial(n)
            
            // Adjusted parameters for n jumps
            let sigmaAdjusted = sqrt(volatility * volatility + Double(n) * sigmaJ * sigmaJ / timeToExpiration)
            let riskFreeAdjusted = riskFreeRate - lambda * (exp(mJ + 0.5 * sigmaJ * sigmaJ) - 1) + Double(n) * log(1 + mJ) / timeToExpiration
            
            // Black-Scholes price with adjusted parameters
            let bsPrice = blackScholesPrice(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeAdjusted,
                dividendYield: dividendYield,
                volatility: sigmaAdjusted
            )
            
            price += poissonProb * bsPrice
        }
        
        return price
    }
    
    private func factorial(_ n: Int) -> Double {
        if n <= 1 { return 1.0 }
        return Double(n) * factorial(n - 1)
    }
    
    private func blackScholesPrice(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> Double {
        
        let d1 = (log(spotPrice / strike) + (riskFreeRate - dividendYield + 0.5 * volatility * volatility) * timeToExpiration) / (volatility * sqrt(timeToExpiration))
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nd1 = 0.5 * (1 + erf(d1 / sqrt(2)))
        let nd2 = 0.5 * (1 + erf(d2 / sqrt(2)))
        let nmd1 = 0.5 * (1 + erf(-d1 / sqrt(2)))
        let nmd2 = 0.5 * (1 + erf(-d2 / sqrt(2)))
        
        switch optionStyle {
        case .call:
            return spotPrice * exp(-dividendYield * timeToExpiration) * nd1 - strike * exp(-riskFreeRate * timeToExpiration) * nd2
        case .put:
            return strike * exp(-riskFreeRate * timeToExpiration) * nmd2 - spotPrice * exp(-dividendYield * timeToExpiration) * nmd1
        }
    }
    
    private func erf(_ x: Double) -> Double {
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

class ExoticOptionsPricer {
    
    struct BarrierResult {
        let price: Double
        let knockoutProbability: Double
    }
    
    struct LookbackResult {
        let price: Double
        let minPrice: Double
        let maxPrice: Double
    }
    
    func priceBarrierOption(
        optionStyle: OptionStyle,
        barrierType: BarrierType,
        spotPrice: Double,
        strike: Double,
        barrierLevel: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> BarrierResult {
        
        // Simplified barrier option pricing using analytical formulas
        let mu = (riskFreeRate - dividendYield - 0.5 * volatility * volatility) / (volatility * volatility)
        let lambda = sqrt(mu * mu + 2 * riskFreeRate / (volatility * volatility))
        
        let _ = log(spotPrice / strike) / (volatility * sqrt(timeToExpiration)) + lambda * volatility * sqrt(timeToExpiration)
        let _ = log(spotPrice / barrierLevel) / (volatility * sqrt(timeToExpiration)) + lambda * volatility * sqrt(timeToExpiration)
        let _ = log(barrierLevel * barrierLevel / (spotPrice * strike)) / (volatility * sqrt(timeToExpiration)) + lambda * volatility * sqrt(timeToExpiration)
        let _ = log(barrierLevel / spotPrice) / (volatility * sqrt(timeToExpiration)) + lambda * volatility * sqrt(timeToExpiration)
        
        // Simplified calculation - in practice would use more sophisticated formulas
        let knockoutProb = switch barrierType {
        case .upAndOut, .upAndIn:
            spotPrice >= barrierLevel ? 1.0 : 0.3 // Simplified
        case .downAndOut, .downAndIn:
            spotPrice <= barrierLevel ? 1.0 : 0.3 // Simplified
        }
        
        // Approximate barrier option price
        let vanillaPrice = blackScholesPrice(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        let barrierPrice = switch barrierType {
        case .upAndOut, .downAndOut:
            vanillaPrice * (1 - knockoutProb)
        case .upAndIn, .downAndIn:
            vanillaPrice * knockoutProb
        }
        
        return BarrierResult(price: barrierPrice, knockoutProbability: knockoutProb)
    }
    
    func priceAsianOption(
        optionStyle: OptionStyle,
        asianType: AsianType,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> Double {
        
        // Simplified Asian option pricing
        // In practice, would use geometric Asian closed-form or Monte Carlo for arithmetic
        
        switch asianType {
        case .geometricAverage:
            // Geometric Asian has closed-form solution
            let adjustedVol = volatility / sqrt(3)
            let adjustedRate = 0.5 * (riskFreeRate + dividendYield + volatility * volatility / 6)
            
            return blackScholesPrice(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: adjustedRate,
                dividendYield: dividendYield,
                volatility: adjustedVol
            )
            
        case .arithmeticAverage:
            // Approximate arithmetic Asian using geometric
            let geometricPrice = priceAsianOption(
                optionStyle: optionStyle,
                asianType: .geometricAverage,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            )
            // Arithmetic is typically higher than geometric
            return geometricPrice * 1.05
            
        default:
            // Simplified for other types
            return blackScholesPrice(
                optionStyle: optionStyle,
                spotPrice: spotPrice,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate,
                dividendYield: dividendYield,
                volatility: volatility
            ) * 0.95
        }
    }
    
    func priceLookbackOption(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> LookbackResult {
        
        // Simplified lookback option pricing
        let _ = 2 * (riskFreeRate - dividendYield - volatility * volatility / 2) / (volatility * volatility)
        
        // Approximate min and max expected values
        let expectedMin = spotPrice * exp(-0.5826 * volatility * sqrt(timeToExpiration))
        let expectedMax = spotPrice * exp(0.5826 * volatility * sqrt(timeToExpiration))
        
        // Simplified lookback price
        let vanillaPrice = blackScholesPrice(
            optionStyle: optionStyle,
            spotPrice: spotPrice,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate,
            dividendYield: dividendYield,
            volatility: volatility
        )
        
        let lookbackPrice = vanillaPrice * 1.3 // Lookback premium
        
        return LookbackResult(price: lookbackPrice, minPrice: expectedMin, maxPrice: expectedMax)
    }
    
    private func blackScholesPrice(
        optionStyle: OptionStyle,
        spotPrice: Double,
        strike: Double,
        timeToExpiration: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double
    ) -> Double {
        
        let d1 = (log(spotPrice / strike) + (riskFreeRate - dividendYield + 0.5 * volatility * volatility) * timeToExpiration) / (volatility * sqrt(timeToExpiration))
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nd1 = 0.5 * (1 + erf(d1 / sqrt(2)))
        let nd2 = 0.5 * (1 + erf(d2 / sqrt(2)))
        let nmd1 = 0.5 * (1 + erf(-d1 / sqrt(2)))
        let nmd2 = 0.5 * (1 + erf(-d2 / sqrt(2)))
        
        switch optionStyle {
        case .call:
            return spotPrice * exp(-dividendYield * timeToExpiration) * nd1 - strike * exp(-riskFreeRate * timeToExpiration) * nd2
        case .put:
            return strike * exp(-riskFreeRate * timeToExpiration) * nmd2 - spotPrice * exp(-dividendYield * timeToExpiration) * nmd1
        }
    }
    
    private func erf(_ x: Double) -> Double {
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
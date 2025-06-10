//
//  AdvancedOptionsModels.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import SwiftData

// MARK: - Advanced Option Types

enum OptionType: String, CaseIterable, Identifiable {
    case european = "european"
    case american = "american"
    case asian = "asian"
    case barrier = "barrier"
    case lookback = "lookback"
    case binary = "binary"
    case compound = "compound"
    case rainbow = "rainbow"
    case quanto = "quanto"
    case spread = "spread"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .european: return "European"
        case .american: return "American"
        case .asian: return "Asian (Average)"
        case .barrier: return "Barrier"
        case .lookback: return "Lookback"
        case .binary: return "Binary/Digital"
        case .compound: return "Compound"
        case .rainbow: return "Rainbow (Multi-Asset)"
        case .quanto: return "Quanto"
        case .spread: return "Spread Options"
        }
    }
}

enum OptionStyle: String, CaseIterable, Identifiable {
    case call = "call"
    case put = "put"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .call: return "Call"
        case .put: return "Put"
        }
    }
}

enum BarrierType: String, CaseIterable, Identifiable {
    case upAndOut = "upAndOut"
    case upAndIn = "upAndIn"
    case downAndOut = "downAndOut"
    case downAndIn = "downAndIn"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .upAndOut: return "Up-and-Out"
        case .upAndIn: return "Up-and-In"
        case .downAndOut: return "Down-and-Out"
        case .downAndIn: return "Down-and-In"
        }
    }
}

enum AsianType: String, CaseIterable, Identifiable {
    case arithmeticAverage = "arithmeticAverage"
    case geometricAverage = "geometricAverage"
    case arithmeticStrike = "arithmeticStrike"
    case geometricStrike = "geometricStrike"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .arithmeticAverage: return "Arithmetic Average Price"
        case .geometricAverage: return "Geometric Average Price"
        case .arithmeticStrike: return "Arithmetic Average Strike"
        case .geometricStrike: return "Geometric Average Strike"
        }
    }
}

// MARK: - Volatility Models

enum VolatilityModel: String, CaseIterable, Identifiable {
    case blackScholes = "blackScholes"
    case heston = "heston"
    case sabr = "sabr"
    case jumpDiffusion = "jumpDiffusion"
    case stochasticVolatility = "stochasticVolatility"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .blackScholes: return "Black-Scholes (Constant Vol)"
        case .heston: return "Heston Stochastic Volatility"
        case .sabr: return "SABR Model"
        case .jumpDiffusion: return "Merton Jump-Diffusion"
        case .stochasticVolatility: return "General Stochastic Volatility"
        }
    }
}

// MARK: - Market Data Models

struct VolatilitySurface {
    let strikes: [Double]
    let expirations: [Double]
    let impliedVolatilities: [[Double]]
    let interpolationMethod: InterpolationMethod
    
    enum InterpolationMethod: String, CaseIterable, Identifiable {
        case linear = "linear"
        case cubic = "cubic"
        case sabr = "sabr"
        case svi = "svi"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .linear: return "Linear"
            case .cubic: return "Cubic Spline"
            case .sabr: return "SABR Interpolation"
            case .svi: return "SVI (Stochastic Volatility Inspired)"
            }
        }
    }
    
    func getImpliedVolatility(strike: Double, expiration: Double) -> Double {
        // Implementation would interpolate the volatility surface
        // For now, return a simple estimate
        let baseVol = 0.2
        let moneyness = strike / 100.0
        let timeEffect = sqrt(expiration)
        let skew = 0.1 * (1.0 - moneyness)
        
        return max(0.05, baseVol + skew + 0.05 * timeEffect)
    }
}

struct OptionsChainData {
    let symbol: String
    let spotPrice: Double
    let lastUpdate: Date
    let calls: [OptionQuote]
    let puts: [OptionQuote]
    let dividendYield: Double
    let riskFreeRate: Double
}

struct OptionQuote: Identifiable {
    let id = UUID()
    let strike: Double
    let expiration: Date
    let bid: Double
    let ask: Double
    let lastPrice: Double
    let volume: Int
    let openInterest: Int
    let impliedVolatility: Double
    let delta: Double
    let gamma: Double
    let theta: Double
    let vega: Double
    let rho: Double
    
    var midPrice: Double { (bid + ask) / 2.0 }
    var bidAskSpread: Double { ask - bid }
    var timeToExpiration: Double {
        expiration.timeIntervalSinceNow / (365.25 * 24 * 3600)
    }
}

// MARK: - Advanced Greeks

struct AdvancedGreeks {
    // First-order Greeks
    let delta: Double
    let vega: Double
    let theta: Double
    let rho: Double
    let epsilon: Double  // Dividend sensitivity
    
    // Second-order Greeks
    let gamma: Double
    let vanna: Double    // ∂²V/∂S∂σ
    let volga: Double    // ∂²V/∂σ²
    let charm: Double    // ∂²V/∂S∂t
    let color: Double    // ∂²V/∂S²∂t
    
    // Third-order Greeks
    let speed: Double    // ∂³V/∂S³
    let zomma: Double    // ∂³V/∂S²∂σ
    let ultima: Double   // ∂³V/∂σ³
    
    init(
        delta: Double = 0, vega: Double = 0, theta: Double = 0, rho: Double = 0, epsilon: Double = 0,
        gamma: Double = 0, vanna: Double = 0, volga: Double = 0, charm: Double = 0, color: Double = 0,
        speed: Double = 0, zomma: Double = 0, ultima: Double = 0
    ) {
        self.delta = delta
        self.vega = vega
        self.theta = theta
        self.rho = rho
        self.epsilon = epsilon
        self.gamma = gamma
        self.vanna = vanna
        self.volga = volga
        self.charm = charm
        self.color = color
        self.speed = speed
        self.zomma = zomma
        self.ultima = ultima
    }
}

// MARK: - Advanced Strategy Models

enum ComplexStrategy: String, CaseIterable, Identifiable {
    // Classic Strategies
    case call = "call"
    case put = "put"
    case coveredCall = "coveredCall"
    case protectivePut = "protectivePut"
    
    // Spreads
    case bullCallSpread = "bullCallSpread"
    case bearPutSpread = "bearPutSpread"
    case bullPutSpread = "bullPutSpread"
    case bearCallSpread = "bearCallSpread"
    case longCallSpread = "longCallSpread"
    case longPutSpread = "longPutSpread"
    
    // Volatility Strategies
    case longStraddle = "longStraddle"
    case shortStraddle = "shortStraddle"
    case longStrangle = "longStrangle"
    case shortStrangle = "shortStrangle"
    case longGuts = "longGuts"
    case shortGuts = "shortGuts"
    
    // Multi-leg Spreads
    case longCallButterfly = "longCallButterfly"
    case shortCallButterfly = "shortCallButterfly"
    case longPutButterfly = "longPutButterfly"
    case shortPutButterfly = "shortPutButterfly"
    case ironButterfly = "ironButterfly"
    case ironCondor = "ironCondor"
    case reverseIronCondor = "reverseIronCondor"
    
    // Advanced Strategies
    case calendarSpread = "calendarSpread"
    case diagonalSpread = "diagonalSpread"
    case ratioCallSpread = "ratioCallSpread"
    case ratioPutSpread = "ratioPutSpread"
    case callRatioBackspread = "callRatioBackspread"
    case putRatioBackspread = "putRatioBackspread"
    
    // Synthetic Strategies
    case syntheticLong = "syntheticLong"
    case syntheticShort = "syntheticShort"
    case syntheticCall = "syntheticCall"
    case syntheticPut = "syntheticPut"
    
    // Box and Conversion
    case longBox = "longBox"
    case shortBox = "shortBox"
    case conversion = "conversion"
    case reversal = "reversal"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .call: return "Long Call"
        case .put: return "Long Put"
        case .coveredCall: return "Covered Call"
        case .protectivePut: return "Protective Put"
        case .bullCallSpread: return "Bull Call Spread"
        case .bearPutSpread: return "Bear Put Spread"
        case .bullPutSpread: return "Bull Put Spread"
        case .bearCallSpread: return "Bear Call Spread"
        case .longCallSpread: return "Long Call Spread"
        case .longPutSpread: return "Long Put Spread"
        case .longStraddle: return "Long Straddle"
        case .shortStraddle: return "Short Straddle"
        case .longStrangle: return "Long Strangle"
        case .shortStrangle: return "Short Strangle"
        case .longGuts: return "Long Guts"
        case .shortGuts: return "Short Guts"
        case .longCallButterfly: return "Long Call Butterfly"
        case .shortCallButterfly: return "Short Call Butterfly"
        case .longPutButterfly: return "Long Put Butterfly"
        case .shortPutButterfly: return "Short Put Butterfly"
        case .ironButterfly: return "Iron Butterfly"
        case .ironCondor: return "Iron Condor"
        case .reverseIronCondor: return "Reverse Iron Condor"
        case .calendarSpread: return "Calendar Spread"
        case .diagonalSpread: return "Diagonal Spread"
        case .ratioCallSpread: return "Ratio Call Spread"
        case .ratioPutSpread: return "Ratio Put Spread"
        case .callRatioBackspread: return "Call Ratio Backspread"
        case .putRatioBackspread: return "Put Ratio Backspread"
        case .syntheticLong: return "Synthetic Long Stock"
        case .syntheticShort: return "Synthetic Short Stock"
        case .syntheticCall: return "Synthetic Call"
        case .syntheticPut: return "Synthetic Put"
        case .longBox: return "Long Box"
        case .shortBox: return "Short Box"
        case .conversion: return "Conversion"
        case .reversal: return "Reversal"
        }
    }
    
    var category: StrategyCategory {
        switch self {
        case .call, .put, .coveredCall, .protectivePut:
            return .basic
        case .bullCallSpread, .bearPutSpread, .bullPutSpread, .bearCallSpread, .longCallSpread, .longPutSpread:
            return .spreads
        case .longStraddle, .shortStraddle, .longStrangle, .shortStrangle, .longGuts, .shortGuts:
            return .volatility
        case .longCallButterfly, .shortCallButterfly, .longPutButterfly, .shortPutButterfly, .ironButterfly, .ironCondor, .reverseIronCondor:
            return .multiLeg
        case .calendarSpread, .diagonalSpread, .ratioCallSpread, .ratioPutSpread, .callRatioBackspread, .putRatioBackspread:
            return .advanced
        case .syntheticLong, .syntheticShort, .syntheticCall, .syntheticPut:
            return .synthetic
        case .longBox, .shortBox, .conversion, .reversal:
            return .arbitrage
        }
    }
}

enum StrategyCategory: String, CaseIterable, Identifiable {
    case basic = "basic"
    case spreads = "spreads"
    case volatility = "volatility"
    case multiLeg = "multiLeg"
    case advanced = "advanced"
    case synthetic = "synthetic"
    case arbitrage = "arbitrage"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .basic: return "Basic Strategies"
        case .spreads: return "Spreads"
        case .volatility: return "Volatility Strategies"
        case .multiLeg: return "Multi-Leg Spreads"
        case .advanced: return "Advanced Strategies"
        case .synthetic: return "Synthetic Positions"
        case .arbitrage: return "Arbitrage Strategies"
        }
    }
}

// MARK: - Strategy Leg Definition

struct StrategyLeg: Identifiable {
    let id = UUID()
    let optionType: OptionStyle
    let strike: Double
    let expiration: Double
    let quantity: Int  // Positive for long, negative for short
    let price: Double
    
    var isLong: Bool { quantity > 0 }
    var isShort: Bool { quantity < 0 }
    var absoluteQuantity: Int { abs(quantity) }
}

struct StrategyDefinition {
    let strategy: ComplexStrategy
    let legs: [StrategyLeg]
    let underlyingPosition: Int  // For strategies involving stock
    
    var totalCost: Double {
        legs.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var netDebit: Double {
        max(0, totalCost)
    }
    
    var netCredit: Double {
        max(0, -totalCost)
    }
}

// MARK: - Risk Metrics

struct OptionsRiskMetrics {
    let valueAtRisk: Double
    let expectedShortfall: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let sortinoRatio: Double
    let calmarRatio: Double
    let informationRatio: Double
    let treynorRatio: Double
    
    // Portfolio Greeks aggregation
    let portfolioDelta: Double
    let portfolioGamma: Double
    let portfolioTheta: Double
    let portfolioVega: Double
    let portfolioRho: Double
    
    // Risk decomposition
    let directionalRisk: Double
    let volatilityRisk: Double
    let timeDecayRisk: Double
    let interestRateRisk: Double
    let dividendRisk: Double
}

// MARK: - Monte Carlo Parameters

struct MonteCarloParameters {
    let simulations: Int
    let timeSteps: Int
    let randomSeed: Int?
    let varianceReduction: VarianceReductionTechnique
    let correlationMatrix: [[Double]]?
    
    enum VarianceReductionTechnique: String, CaseIterable, Identifiable {
        case none = "none"
        case antithetic = "antithetic"
        case controlVariates = "controlVariates"
        case stratifiedSampling = "stratifiedSampling"
        case importanceSampling = "importanceSampling"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .none: return "None"
            case .antithetic: return "Antithetic Variates"
            case .controlVariates: return "Control Variates"
            case .stratifiedSampling: return "Stratified Sampling"
            case .importanceSampling: return "Importance Sampling"
            }
        }
    }
}

// MARK: - Advanced Results

struct AdvancedOptionsResults {
    // Basic pricing
    let optionPrice: Double
    let intrinsicValue: Double
    let timeValue: Double
    let impliedVolatility: Double
    
    // Advanced Greeks
    let greeks: AdvancedGreeks
    
    // Risk metrics
    let riskMetrics: OptionsRiskMetrics
    
    // Strategy-specific
    let strategyValue: Double
    let maxProfit: Double
    let maxLoss: Double
    let breakevenPoints: [Double]
    let probabilityOfProfit: Double
    let probabilityDistribution: [Double]
    
    // Model-specific results
    let binomialTreePrice: Double?
    let monteCarloPrice: Double?
    let monteCarloStandardError: Double?
    let hestonPrice: Double?
    let jumpDiffusionPrice: Double?
    
    // Sensitivity analysis
    let deltaScenarios: [ScenarioResult]
    let vegaScenarios: [ScenarioResult]
    let thetaDecay: [TheTaDecayPoint]
    
    // Exotic option specifics
    let barrierProbability: Double?
    let asianAveragePrice: Double?
    let lookbackMinMax: (min: Double, max: Double)?
    
    init(
        optionPrice: Double = 0,
        intrinsicValue: Double = 0,
        timeValue: Double = 0,
        impliedVolatility: Double = 0,
        greeks: AdvancedGreeks = AdvancedGreeks(),
        riskMetrics: OptionsRiskMetrics = OptionsRiskMetrics(
            valueAtRisk: 0, expectedShortfall: 0, maxDrawdown: 0,
            sharpeRatio: 0, sortinoRatio: 0, calmarRatio: 0,
            informationRatio: 0, treynorRatio: 0,
            portfolioDelta: 0, portfolioGamma: 0, portfolioTheta: 0,
            portfolioVega: 0, portfolioRho: 0,
            directionalRisk: 0, volatilityRisk: 0, timeDecayRisk: 0,
            interestRateRisk: 0, dividendRisk: 0
        ),
        strategyValue: Double = 0,
        maxProfit: Double = 0,
        maxLoss: Double = 0,
        breakevenPoints: [Double] = [],
        probabilityOfProfit: Double = 0,
        probabilityDistribution: [Double] = [],
        binomialTreePrice: Double? = nil,
        monteCarloPrice: Double? = nil,
        monteCarloStandardError: Double? = nil,
        hestonPrice: Double? = nil,
        jumpDiffusionPrice: Double? = nil,
        deltaScenarios: [ScenarioResult] = [],
        vegaScenarios: [ScenarioResult] = [],
        thetaDecay: [TheTaDecayPoint] = [],
        barrierProbability: Double? = nil,
        asianAveragePrice: Double? = nil,
        lookbackMinMax: (min: Double, max: Double)? = nil
    ) {
        self.optionPrice = optionPrice
        self.intrinsicValue = intrinsicValue
        self.timeValue = timeValue
        self.impliedVolatility = impliedVolatility
        self.greeks = greeks
        self.riskMetrics = riskMetrics
        self.strategyValue = strategyValue
        self.maxProfit = maxProfit
        self.maxLoss = maxLoss
        self.breakevenPoints = breakevenPoints
        self.probabilityOfProfit = probabilityOfProfit
        self.probabilityDistribution = probabilityDistribution
        self.binomialTreePrice = binomialTreePrice
        self.monteCarloPrice = monteCarloPrice
        self.monteCarloStandardError = monteCarloStandardError
        self.hestonPrice = hestonPrice
        self.jumpDiffusionPrice = jumpDiffusionPrice
        self.deltaScenarios = deltaScenarios
        self.vegaScenarios = vegaScenarios
        self.thetaDecay = thetaDecay
        self.barrierProbability = barrierProbability
        self.asianAveragePrice = asianAveragePrice
        self.lookbackMinMax = lookbackMinMax
    }
}

struct ScenarioResult: Identifiable {
    let id = UUID()
    let scenarioName: String
    let parameter: Double
    let optionPrice: Double
    let delta: Double
    let gamma: Double
    let theta: Double
    let vega: Double
    let rho: Double
}

struct TheTaDecayPoint: Identifiable {
    let id = UUID()
    let daysToExpiration: Double
    let optionPrice: Double
    let theta: Double
    let timeValue: Double
}

// MARK: - Calibration Parameters

struct ModelCalibrationParameters {
    let marketPrices: [Double]
    let strikes: [Double]
    let expirations: [Double]
    let calibrationMethod: CalibrationMethod
    let objective: ObjectiveFunction
    let constraints: [ParameterConstraint]
    
    enum CalibrationMethod: String, CaseIterable, Identifiable {
        case leastSquares = "leastSquares"
        case maximumLikelihood = "maximumLikelihood"
        case vega = "vega"
        case relativeError = "relativeError"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .leastSquares: return "Least Squares"
            case .maximumLikelihood: return "Maximum Likelihood"
            case .vega: return "Vega-Weighted"
            case .relativeError: return "Relative Error Minimization"
            }
        }
    }
    
    enum ObjectiveFunction: String, CaseIterable, Identifiable {
        case priceError = "priceError"
        case impliedVolError = "impliedVolError"
        case vegaWeightedError = "vegaWeightedError"
        case relativeError = "relativeError"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .priceError: return "Price Error"
            case .impliedVolError: return "Implied Volatility Error"
            case .vegaWeightedError: return "Vega-Weighted Error"
            case .relativeError: return "Relative Error"
            }
        }
    }
}

struct ParameterConstraint {
    let parameter: String
    let lowerBound: Double
    let upperBound: Double
    let initialValue: Double
}

// MARK: - Stochastic Models Parameters

struct HestonParameters {
    let v0: Double      // Initial variance
    let kappa: Double   // Mean reversion speed
    let theta: Double   // Long-term variance
    let sigma: Double   // Volatility of variance
    let rho: Double     // Correlation between price and variance
    
    var isValid: Bool {
        v0 > 0 && kappa > 0 && theta > 0 && sigma > 0 && rho >= -1 && rho <= 1 && 2*kappa*theta >= sigma*sigma
    }
}

struct SABRParameters {
    let alpha: Double   // Initial volatility
    let beta: Double    // CEV parameter
    let nu: Double      // Volatility of volatility
    let rho: Double     // Correlation
    
    var isValid: Bool {
        alpha > 0 && beta >= 0 && beta <= 1 && nu >= 0 && rho >= -1 && rho <= 1
    }
}

struct JumpDiffusionParameters {
    let jumpIntensity: Double  // λ - jump frequency
    let jumpMean: Double       // μ_J - average jump size
    let jumpVolatility: Double // σ_J - jump size volatility
    
    var isValid: Bool {
        jumpIntensity >= 0 && jumpVolatility >= 0
    }
}
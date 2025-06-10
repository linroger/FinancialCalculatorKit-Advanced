//
//  AdvancedBondModels.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import SwiftData

// MARK: - Advanced Bond Types

enum BondCategory: String, CaseIterable, Identifiable {
    case treasury = "treasury"
    case corporate = "corporate"
    case municipal = "municipal"
    case international = "international"
    case inflationProtected = "inflationProtected"
    case convertible = "convertible"
    case assetBacked = "assetBacked"
    case mortgageBacked = "mortgageBacked"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .treasury: return "Treasury"
        case .corporate: return "Corporate"
        case .municipal: return "Municipal"
        case .international: return "International"
        case .inflationProtected: return "TIPS/Inflation-Protected"
        case .convertible: return "Convertible"
        case .assetBacked: return "Asset-Backed Securities"
        case .mortgageBacked: return "Mortgage-Backed Securities"
        }
    }
}

enum BondStructure: String, CaseIterable, Identifiable {
    case fixed = "fixed"
    case floating = "floating"
    case zero = "zero"
    case perpetual = "perpetual"
    case callable = "callable"
    case putable = "putable"
    case convertible = "convertible"
    case step = "step"
    case inverse = "inverse"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .fixed: return "Fixed Rate"
        case .floating: return "Floating Rate"
        case .zero: return "Zero Coupon"
        case .perpetual: return "Perpetual"
        case .callable: return "Callable"
        case .putable: return "Putable"
        case .convertible: return "Convertible"
        case .step: return "Step-Up/Step-Down"
        case .inverse: return "Inverse Floater"
        }
    }
}

// MARK: - Credit Risk Models

enum CreditRating: String, CaseIterable, Identifiable {
    // Investment Grade
    case aaa = "AAA"
    case aa1 = "AA+"
    case aa = "AA"
    case aa3 = "AA-"
    case a1 = "A+"
    case a = "A"
    case a3 = "A-"
    case baa1 = "BBB+"
    case baa = "BBB"
    case baa3 = "BBB-"
    
    // Speculative Grade
    case ba1 = "BB+"
    case ba = "BB"
    case ba3 = "BB-"
    case b1 = "B+"
    case b = "B"
    case b3 = "B-"
    case caa1 = "CCC+"
    case caa = "CCC"
    case caa3 = "CCC-"
    case ca = "CC"
    case c = "C"
    case d = "D"
    
    var id: String { rawValue }
    
    var isInvestmentGrade: Bool {
        switch self {
        case .aaa, .aa1, .aa, .aa3, .a1, .a, .a3, .baa1, .baa, .baa3:
            return true
        default:
            return false
        }
    }
    
    var defaultProbability: Double {
        switch self {
        case .aaa: return 0.0002
        case .aa1, .aa: return 0.0005
        case .aa3: return 0.0008
        case .a1, .a: return 0.0015
        case .a3: return 0.0025
        case .baa1, .baa: return 0.005
        case .baa3: return 0.008
        case .ba1, .ba: return 0.015
        case .ba3: return 0.025
        case .b1, .b: return 0.05
        case .b3: return 0.08
        case .caa1, .caa: return 0.15
        case .caa3: return 0.25
        case .ca: return 0.4
        case .c: return 0.6
        case .d: return 1.0
        }
    }
    
    var creditSpread: Double {
        switch self {
        case .aaa: return 0.0005
        case .aa1, .aa: return 0.001
        case .aa3: return 0.0015
        case .a1, .a: return 0.002
        case .a3: return 0.0025
        case .baa1, .baa: return 0.004
        case .baa3: return 0.006
        case .ba1, .ba: return 0.015
        case .ba3: return 0.025
        case .b1, .b: return 0.04
        case .b3: return 0.06
        case .caa1, .caa: return 0.1
        case .caa3: return 0.15
        case .ca: return 0.25
        case .c: return 0.4
        case .d: return 0.8
        }
    }
}

struct CreditAnalysis {
    let rating: CreditRating
    let creditSpread: Double
    let defaultProbability: Double
    let recoveryRate: Double
    let creditVaR: Double
    let expectedLoss: Double
    
    init(rating: CreditRating, customSpread: Double? = nil, recoveryRate: Double = 0.4) {
        self.rating = rating
        self.creditSpread = customSpread ?? rating.creditSpread
        self.defaultProbability = rating.defaultProbability
        self.recoveryRate = recoveryRate
        self.expectedLoss = defaultProbability * (1 - recoveryRate)
        self.creditVaR = defaultProbability * (1 - recoveryRate) * 2.33 // 99% confidence
    }
}

// MARK: - Yield Curve Models

struct YieldCurvePoint: Identifiable {
    let id = UUID()
    let maturity: Double
    let yield: Double
    let spotRate: Double
    let forwardRate: Double
    let discountFactor: Double
}

class YieldCurve: ObservableObject {
    @Published var points: [YieldCurvePoint] = []
    @Published var curveType: CurveType = .treasury
    @Published var interpolationMethod: InterpolationMethod = .cubic
    
    enum CurveType: String, CaseIterable, Identifiable {
        case treasury = "treasury"
        case swap = "swap"
        case corporate = "corporate"
        case municipal = "municipal"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .treasury: return "Treasury Curve"
            case .swap: return "Swap Curve"
            case .corporate: return "Corporate Curve"
            case .municipal: return "Municipal Curve"
            }
        }
    }
    
    enum InterpolationMethod: String, CaseIterable, Identifiable {
        case linear = "linear"
        case cubic = "cubic"
        case nelson = "nelson"
        case svensson = "svensson"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .linear: return "Linear"
            case .cubic: return "Cubic Spline"
            case .nelson: return "Nelson-Siegel"
            case .svensson: return "Svensson"
            }
        }
    }
    
    func getYield(for maturity: Double) -> Double {
        guard !points.isEmpty else { return 0.05 }
        
        // Find surrounding points
        let sorted = points.sorted { $0.maturity < $1.maturity }
        
        if maturity <= sorted.first!.maturity {
            return sorted.first!.yield
        }
        
        if maturity >= sorted.last!.maturity {
            return sorted.last!.yield
        }
        
        // Linear interpolation for now (can be enhanced with other methods)
        for i in 0..<(sorted.count - 1) {
            let p1 = sorted[i]
            let p2 = sorted[i + 1]
            
            if maturity >= p1.maturity && maturity <= p2.maturity {
                let weight = (maturity - p1.maturity) / (p2.maturity - p1.maturity)
                return p1.yield + weight * (p2.yield - p1.yield)
            }
        }
        
        return 0.05 // Default
    }
    
    func getSpotRate(for maturity: Double) -> Double {
        // Bootstrap spot rates from yield curve
        // Simplified implementation - in reality would use bond prices
        return getYield(for: maturity)
    }
    
    func getForwardRate(from t1: Double, to t2: Double) -> Double {
        let spot1 = getSpotRate(for: t1)
        let spot2 = getSpotRate(for: t2)
        
        // Forward rate calculation: (1 + r2)^t2 = (1 + r1)^t1 * (1 + f)^(t2-t1)
        let forwardRate = (pow(1 + spot2, t2) / pow(1 + spot1, t1)) - 1
        return forwardRate / (t2 - t1)
    }
}

// MARK: - Embedded Options

struct EmbeddedOption {
    let type: OptionType
    let exerciseStyle: ExerciseStyle
    let exercisePrice: Double
    let exerciseDates: [Double]
    let volatility: Double
    
    enum OptionType: String, CaseIterable, Identifiable {
        case call = "call"
        case put = "put"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .call: return "Call Option"
            case .put: return "Put Option"
            }
        }
    }
    
    enum ExerciseStyle: String, CaseIterable, Identifiable {
        case european = "european"
        case american = "american"
        case bermudan = "bermudan"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .european: return "European"
            case .american: return "American"
            case .bermudan: return "Bermudan"
            }
        }
    }
}

// MARK: - Advanced Bond Results

struct AdvancedBondResults {
    // Basic Pricing
    var dirtyPrice: Double = 0.0
    var cleanPrice: Double = 0.0
    var accruedInterest: Double = 0.0
    var yieldToMaturity: Double = 0.0
    var yieldToCall: Double? = nil
    var yieldToWorst: Double = 0.0
    
    // Duration and Convexity
    var macaulayDuration: Double = 0.0
    var modifiedDuration: Double = 0.0
    var effectiveDuration: Double = 0.0
    var keyRateDuration: [Double: Double] = [:]
    var convexity: Double = 0.0
    var effectiveConvexity: Double = 0.0
    
    // Risk Metrics
    var dv01: Double = 0.0
    var pvbp: Double = 0.0
    var creditVaR: Double = 0.0
    var expectedLoss: Double = 0.0
    
    // Option-Adjusted Metrics
    var optionAdjustedSpread: Double = 0.0
    var optionValue: Double = 0.0
    var zSpread: Double = 0.0
    var iSpread: Double = 0.0
    
    // Current Yields
    var currentYield: Double = 0.0
    var yieldToMaturityReal: Double = 0.0
    var taxEquivalentYield: Double = 0.0
    var afterTaxYield: Double = 0.0
    
    // Greeks (for bonds with embedded options)
    var delta: Double = 0.0
    var gamma: Double = 0.0
    var vega: Double = 0.0
    var theta: Double = 0.0
    var rho: Double = 0.0
    
    // Scenario Analysis
    var bullScenarioPrice: Double = 0.0
    var bearScenarioPrice: Double = 0.0
    var baseScenarioPrice: Double = 0.0
    
    // Monte Carlo Results
    var monteCarloPrice: Double = 0.0
    var monteCarloStdDev: Double = 0.0
    var priceConfidenceInterval: (lower: Double, upper: Double) = (0.0, 0.0)
}

// MARK: - Market Data Models

struct BondMarketData {
    let issuer: String
    let cusip: String?
    let isin: String?
    let sector: String
    let country: String
    let currency: String
    let issueDate: Date
    let maturityDate: Date
    let firstCallDate: Date?
    let lastTradeDate: Date?
    let lastTradePrice: Double?
    let bidPrice: Double?
    let askPrice: Double?
    let bidYield: Double?
    let askYield: Double?
    let volume: Double?
}

// MARK: - Tax Analysis

struct TaxAnalysis {
    let federalTaxRate: Double
    let stateTaxRate: Double
    let localTaxRate: Double
    let isSubjectToAMT: Bool
    let isTaxExempt: Bool
    
    func calculateAfterTaxYield(_ preYield: Double) -> Double {
        if isTaxExempt {
            return preYield
        }
        
        let totalTaxRate = federalTaxRate + stateTaxRate + localTaxRate
        return preYield * (1 - totalTaxRate)
    }
    
    func calculateTaxEquivalentYield(_ taxFreeYield: Double) -> Double {
        let totalTaxRate = federalTaxRate + stateTaxRate + localTaxRate
        return taxFreeYield / (1 - totalTaxRate)
    }
}

// MARK: - Scenario Definition

struct ScenarioDefinition {
    let name: String
    let yieldShift: Double
    let creditSpreadShift: Double
    let volatilityShift: Double
    let probability: Double
}
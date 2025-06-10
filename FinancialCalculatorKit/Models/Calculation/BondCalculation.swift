//
//  BondCalculation.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation
import SwiftData

/// Bond calculation model for pricing and yield analysis
@Model
final class BondCalculation {
    // MARK: - Common Properties
    var id: UUID
    var name: String
    private var calculationTypeRawValue: String = CalculationType.bond.rawValue
    var createdDate: Date
    var lastModified: Date
    var notes: String
    var isFavorite: Bool
    private var currencyRawValue: String
    
    /// Computed property for calculationType
    var calculationType: CalculationType {
        get {
            CalculationType(rawValue: calculationTypeRawValue) ?? .bond
        }
        set {
            calculationTypeRawValue = newValue.rawValue
        }
    }
    
    /// Computed property for currency
    var currency: Currency {
        get {
            Currency(rawValue: currencyRawValue) ?? .usd
        }
        set {
            currencyRawValue = newValue.rawValue
        }
    }
    
    // MARK: - Bond Specific Properties
    /// Face value (par value) of the bond
    var faceValue: Double
    
    /// Coupon rate (annual percentage)
    var couponRate: Double
    
    /// Years to maturity
    var maturity: Double
    
    /// Number of coupon payments per year
    private var frequencyRawValue: String
    
    /// Computed property for payment frequency
    var frequency: PaymentFrequency {
        get {
            PaymentFrequency(rawValue: frequencyRawValue) ?? .semiAnnual
        }
        set {
            frequencyRawValue = newValue.rawValue
        }
    }
    
    /// Bond category
    private var bondCategoryRawValue: String
    var bondCategory: BondCategory {
        get { BondCategory(rawValue: bondCategoryRawValue) ?? .corporate }
        set { bondCategoryRawValue = newValue.rawValue }
    }
    
    /// Bond structure
    private var bondStructureRawValue: String
    var bondStructure: BondStructure {
        get { BondStructure(rawValue: bondStructureRawValue) ?? .fixed }
        set { bondStructureRawValue = newValue.rawValue }
    }
    
    /// Credit rating
    private var creditRatingRawValue: String
    var creditRating: CreditRating {
        get { CreditRating(rawValue: creditRatingRawValue) ?? .a }
        set { creditRatingRawValue = newValue.rawValue }
    }
    
    /// Whether to use a custom credit spread
    var useCustomSpread: Bool
    
    /// Custom credit spread value
    var customCreditSpread: Double
    
    /// Federal tax rate
    var federalTaxRate: Double
    
    /// State tax rate
    var stateTaxRate: Double
    
    /// Local tax rate
    var localTaxRate: Double
    
    /// Whether the bond is tax-exempt
    var isTaxExempt: Bool
    
    /// Whether the bond has embedded options
    var hasEmbeddedOptions: Bool
    
    /// Call price (as percentage of par)
    var callPrice: Double
    
    /// Call date (in years)
    var callDate: Double
    
    /// Interest rate volatility for options
    var volatility: Double
    
    /// Whether to enable Monte Carlo simulation
    var enableMonteCarlo: Bool
    
    /// Number of Monte Carlo simulations
    var monteCarloSimulations: Int
    
    /// Whether to perform scenario analysis
    var performScenarioAnalysis: Bool
    
    /// Yield curve data for pricing (SwiftData compatible)
    var yieldCurveData: YieldCurveData
    
    /// Computed property to get YieldCurve for UI operations
    var yieldCurve: YieldCurve {
        return yieldCurveData.toYieldCurve()
    }
    
    init(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency,
        currency: Currency,
        bondCategory: BondCategory,
        bondStructure: BondStructure,
        creditRating: CreditRating,
        useCustomSpread: Bool,
        customCreditSpread: Double,
        federalTaxRate: Double,
        stateTaxRate: Double,
        localTaxRate: Double,
        isTaxExempt: Bool,
        hasEmbeddedOptions: Bool,
        callPrice: Double,
        callDate: Double,
        volatility: Double,
        enableMonteCarlo: Bool,
        monteCarloSimulations: Int,
        performScenarioAnalysis: Bool,
        yieldCurveData: YieldCurveData
    ) {
        self.id = UUID()
        self.name = "New Bond Calculation"
        self.createdDate = Date()
        self.lastModified = Date()
        self.notes = ""
        self.isFavorite = false
        self.currencyRawValue = currency.rawValue
        
        self.faceValue = faceValue
        self.couponRate = couponRate
        self.maturity = maturity
        self.frequencyRawValue = frequency.rawValue
        self.bondCategoryRawValue = bondCategory.rawValue
        self.bondStructureRawValue = bondStructure.rawValue
        self.creditRatingRawValue = creditRating.rawValue
        self.useCustomSpread = useCustomSpread
        self.customCreditSpread = customCreditSpread
        self.federalTaxRate = federalTaxRate
        self.stateTaxRate = stateTaxRate
        self.localTaxRate = localTaxRate
        self.isTaxExempt = isTaxExempt
        self.hasEmbeddedOptions = hasEmbeddedOptions
        self.callPrice = callPrice
        self.callDate = callDate
        self.volatility = volatility
        self.enableMonteCarlo = enableMonteCarlo
        self.monteCarloSimulations = monteCarloSimulations
        self.performScenarioAnalysis = performScenarioAnalysis
        self.yieldCurveData = yieldCurveData
    }
    
    // MARK: - Common Protocol Methods
    
    /// Update the last modified timestamp
    func updateTimestamp() {
        lastModified = Date()
    }
    
    /// Toggle favorite status
    func toggleFavorite() {
        isFavorite.toggle()
        updateTimestamp()
    }
    
    var result: CalculationResult {
        // This will be populated by the AdvancedBondPricingEngine
        return CalculationResult(primaryValue: 0, formattedPrimaryValue: "N/A", explanation: "Results are calculated by the AdvancedBondPricingEngine.")
    }
    
    var isValid: Bool {
        return faceValue > 0 && couponRate >= 0 && maturity > 0
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        if faceValue <= 0 { errors.append("Face value must be positive.") }
        if couponRate < 0 { errors.append("Coupon rate cannot be negative.") }
        if maturity <= 0 { errors.append("Maturity must be positive.") }
        return errors
    }
}

// MARK: - Protocol Conformance

extension BondCalculation: FinancialCalculationProtocol {}

/// What to solve for in bond calculations
enum BondSolveFor: String, CaseIterable, Identifiable {
    case price = "price"
    case yield = "yield"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .price:
            return "Bond Price"
        case .yield:
            return "Yield to Maturity (YTM)"
        }
    }
    
    var description: String {
        switch self {
        case .price:
            return "Calculate the theoretical price of the bond"
        case .yield:
            return "Calculate the yield to maturity based on current price"
        }
    }
}
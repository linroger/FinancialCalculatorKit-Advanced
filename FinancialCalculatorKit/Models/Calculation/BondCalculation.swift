//
//  BondCalculation.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation
import SwiftData

/// Type of bond
enum BondType: String, CaseIterable, Identifiable, Codable {
    case standardBond = "standard"
    case zeroCoupon = "zero_coupon"
    case callable = "callable"
    case puttable = "puttable"
    case convertible = "convertible"
    case floating = "floating"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .standardBond:
            return "Standard Bond"
        case .zeroCoupon:
            return "Zero Coupon Bond"
        case .callable:
            return "Callable Bond"
        case .puttable:
            return "Puttable Bond"
        case .convertible:
            return "Convertible Bond"
        case .floating:
            return "Floating Rate Bond"
        }
    }
}

/// Day count convention for bond calculations
enum DayCountConvention: String, CaseIterable, Identifiable, Codable {
    case thirty360 = "30/360"
    case actual360 = "Actual/360"
    case actual365 = "Actual/365"
    case actualActual = "Actual/Actual"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .thirty360:
            return "30/360"
        case .actual360:
            return "Actual/360"
        case .actual365:
            return "Actual/365"
        case .actualActual:
            return "Actual/Actual"
        }
    }

    var description: String {
        switch self {
        case .thirty360:
            return "Assumes 30 days per month and 360 days per year"
        case .actual360:
            return "Actual days divided by 360"
        case .actual365:
            return "Actual days divided by 365"
        case .actualActual:
            return "Actual days divided by actual days in year"
        }
    }
}

/// Bond calculation model for pricing and yield analysis
@Model
final class BondCalculation {
    // MARK: - Common Properties
    var id: UUID
    var metadata: CalculationMetadata
    
    // MARK: - Computed Properties for Backward Compatibility
    var name: String {
        get { metadata.name }
        set { metadata.name = newValue }
    }
    
    var calculationType: CalculationType {
        get { metadata.calculationType }
        set { metadata.calculationType = newValue }
    }
    
    var createdDate: Date {
        get { metadata.createdDate }
        set { metadata.createdDate = newValue }
    }
    
    var lastModified: Date {
        get { metadata.lastModified }
        set { metadata.lastModified = newValue }
    }
    
    var notes: String {
        get { metadata.notes }
        set { metadata.notes = newValue }
    }
    
    var isFavorite: Bool {
        get { metadata.isFavorite }
        set { metadata.isFavorite = newValue }
    }
    
    var currency: Currency {
        get { metadata.currency }
        set { metadata.currency = newValue }
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

    /// Bond type
    private var bondTypeRawValue: String
    var bondType: BondType {
        get { BondType(rawValue: bondTypeRawValue) ?? .standardBond }
        set { bondTypeRawValue = newValue.rawValue }
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
    var yieldCurveData: YieldCurveData?
    
    /// Computed property to get YieldCurve for UI operations
    var yieldCurve: YieldCurve? {
        return yieldCurveData?.toYieldCurve()
    }
    
    /// What to solve for (stored as raw value)
    private var solveForRawValue: String
    
    /// Computed property for solveFor
    var solveFor: BondSolveFor {
        get { BondSolveFor(rawValue: solveForRawValue) ?? .price }
        set { solveForRawValue = newValue.rawValue }
    }
    
    /// Market yield (used when solving for price)
    var marketYield: Double?
    
    /// Current price (used when solving for yield)
    var currentPrice: Double?
    
    /// Yield to maturity (calculated result)
    var yieldToMaturity: Double?
    
    init(
        faceValue: Double,
        couponRate: Double,
        maturity: Double,
        frequency: PaymentFrequency = .semiAnnual,
        currency: Currency = .usd,
        bondCategory: BondCategory = .corporate,
        bondStructure: BondStructure = .fixed,
        bondType: BondType = .standardBond,
        creditRating: CreditRating = .a,
        useCustomSpread: Bool = false,
        customCreditSpread: Double = 0.0,
        federalTaxRate: Double = 0.0,
        stateTaxRate: Double = 0.0,
        localTaxRate: Double = 0.0,
        isTaxExempt: Bool = false,
        hasEmbeddedOptions: Bool = false,
        callPrice: Double = 100.0,
        callDate: Double = 0.0,
        volatility: Double = 0.15,
        enableMonteCarlo: Bool = false,
        monteCarloSimulations: Int = 10000,
        performScenarioAnalysis: Bool = false,
        yieldCurveData: YieldCurveData? = nil,
        solveFor: BondSolveFor = .price,
        marketYield: Double? = nil,
        currentPrice: Double? = nil
    ) {
        self.id = UUID()
        self.metadata = CalculationMetadata(
            name: "New Bond Calculation",
            calculationType: .bond,
            currency: currency
        )
        
        self.faceValue = faceValue
        self.couponRate = couponRate
        self.maturity = maturity
        self.frequencyRawValue = frequency.rawValue
        self.bondCategoryRawValue = bondCategory.rawValue
        self.bondStructureRawValue = bondStructure.rawValue
        self.bondTypeRawValue = bondType.rawValue
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
        self.solveForRawValue = solveFor.rawValue
        self.marketYield = marketYield
        self.currentPrice = currentPrice
        self.yieldToMaturity = nil // Will be calculated
    }
    
    // MARK: - Common Protocol Methods
    
    /// Update the last modified timestamp
    func updateTimestamp() {
        metadata.updateTimestamp()
    }
    
    /// Toggle favorite status
    func toggleFavorite() {
        metadata.toggleFavorite()
    }
    
    var result: CalculationResult {
        guard isValid else {
            return CalculationResult(
                primaryValue: 0.0,
                formattedPrimaryValue: "Invalid inputs",
                explanation: "Please provide valid inputs for all required fields."
            )
        }
        
        let results = calculateBondMetrics()
        
        // Store the calculated yield to maturity
        self.yieldToMaturity = results.yieldToMaturity
        
        let primaryValue = solveFor == .price ? results.cleanPrice : results.yieldToMaturity
        let formattedValue = solveFor == .price ? 
            metadata.currency.formatValue(primaryValue) : 
            String(format: "%.2f%%", primaryValue)
        
        var secondaryValues: [String: Double] = [:]
        
        // Add all calculated metrics to secondary values
        secondaryValues["Clean Price"] = results.cleanPrice
        secondaryValues["Dirty Price"] = results.dirtyPrice
        secondaryValues["Accrued Interest"] = results.accruedInterest
        secondaryValues["YTM"] = results.yieldToMaturity
        secondaryValues["Current Yield"] = results.currentYield
        secondaryValues["Modified Duration"] = results.modifiedDuration
        secondaryValues["Macaulay Duration"] = results.macaulayDuration
        secondaryValues["Convexity"] = results.convexity
        secondaryValues["DV01"] = results.dv01
        
        if let ytc = results.yieldToCall {
            secondaryValues["Yield to Call"] = ytc
        }
        secondaryValues["Yield to Worst"] = results.yieldToWorst
        
        // Option-adjusted metrics
        if hasEmbeddedOptions {
            secondaryValues["OAS"] = results.optionAdjustedSpread
            secondaryValues["Option Value"] = results.optionValue
            secondaryValues["Z-Spread"] = results.zSpread
        }
        
        // Tax-adjusted yields
        if bondCategory == .municipal && !isTaxExempt {
            secondaryValues["Tax-Equivalent Yield"] = results.taxEquivalentYield
            secondaryValues["After-Tax Yield"] = results.afterTaxYield
        }
        
        // Credit metrics
        if useCustomSpread || creditRating != .aaa {
            secondaryValues["Credit Spread"] = useCustomSpread ? customCreditSpread : creditRating.creditSpread
            secondaryValues["Expected Loss"] = results.expectedLoss
            secondaryValues["Credit VaR"] = results.creditVaR
        }
        
        let explanation = generateExplanation(for: results)
        
        return CalculationResult(
            primaryValue: primaryValue,
            secondaryValues: secondaryValues,
            formattedPrimaryValue: formattedValue,
            explanation: explanation,
            chartData: generateYieldCurveChartData(),
            tableData: generateCashFlowTable()
        )
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

// MARK: - Bond Calculation Methods

extension BondCalculation {
    
    /// Calculate all bond metrics
    private func calculateBondMetrics() -> AdvancedBondResults {
        var results = AdvancedBondResults()
        
        // Determine market rate for calculations
        let baseRate = yieldCurveData?.getYield(for: maturity) ?? 0.05
        let creditSpread = useCustomSpread ? customCreditSpread : creditRating.creditSpread
        let marketRate = baseRate + creditSpread
        
        // Basic pricing calculations
        if solveFor == .price {
            // Calculate price from yield
            results.yieldToMaturity = marketYield ?? marketRate * 100
            let price = CalculationEngine.calculateBondPrice(
                faceValue: faceValue,
                couponRate: couponRate,
                marketRate: results.yieldToMaturity,
                yearsToMaturity: maturity,
                paymentsPerYear: frequency.periodsPerYear
            )
            results.cleanPrice = price
        } else {
            // Calculate yield from price
            results.cleanPrice = currentPrice ?? faceValue
            results.yieldToMaturity = CalculationEngine.calculateBondYTM(
                faceValue: faceValue,
                currentPrice: results.cleanPrice,
                couponRate: couponRate,
                yearsToMaturity: maturity,
                paymentsPerYear: frequency.periodsPerYear
            )
        }
        
        // Calculate accrued interest
        let daysSinceLastCoupon = 30.0 // Simplified - in production, use actual day count
        let couponPeriodDays = 365.0 / frequency.periodsPerYear
        results.accruedInterest = (faceValue * couponRate / 100.0 / frequency.periodsPerYear) * 
                                  (daysSinceLastCoupon / couponPeriodDays)
        results.dirtyPrice = results.cleanPrice + results.accruedInterest
        
        // Duration and convexity
        results.macaulayDuration = CalculationEngine.calculateMacaulayDuration(
            faceValue: faceValue,
            couponRate: couponRate,
            marketRate: results.yieldToMaturity,
            yearsToMaturity: maturity,
            paymentsPerYear: frequency.periodsPerYear
        )
        results.modifiedDuration = CalculationEngine.calculateModifiedDuration(
            faceValue: faceValue,
            couponRate: couponRate,
            marketRate: results.yieldToMaturity,
            yearsToMaturity: maturity,
            paymentsPerYear: frequency.periodsPerYear
        )
        results.convexity = CalculationEngine.calculateConvexity(
            faceValue: faceValue,
            couponRate: couponRate,
            marketRate: results.yieldToMaturity,
            yearsToMaturity: maturity,
            paymentsPerYear: frequency.periodsPerYear
        )
        
        // Risk metrics
        results.dv01 = results.modifiedDuration * results.dirtyPrice / 10000.0
        results.pvbp = results.dv01 // Price value of a basis point
        
        // Effective duration and convexity (if we have a yield curve)
        if let curve = yieldCurveData {
            let shockSize = 0.01 // 1 basis point
            let upPrice = calculatePriceWithShock(curve: curve, shock: shockSize)
            let downPrice = calculatePriceWithShock(curve: curve, shock: -shockSize)
            
            results.effectiveDuration = (downPrice - upPrice) / (2 * results.dirtyPrice * shockSize)
            results.effectiveConvexity = (upPrice + downPrice - 2 * results.dirtyPrice) / 
                                         (results.dirtyPrice * shockSize * shockSize)
        } else {
            results.effectiveDuration = results.modifiedDuration
            results.effectiveConvexity = results.convexity
        }
        
        // Current yield
        results.currentYield = (faceValue * couponRate / 100.0) / results.cleanPrice * 100.0
        
        // Yield to call (if callable)
        if hasEmbeddedOptions && callDate > 0 && callDate < maturity {
            results.yieldToCall = CalculationEngine.calculateBondYTM(
                faceValue: callPrice,
                currentPrice: results.cleanPrice,
                couponRate: couponRate,
                yearsToMaturity: callDate,
                paymentsPerYear: frequency.periodsPerYear
            )
            results.yieldToWorst = min(results.yieldToMaturity, results.yieldToCall ?? results.yieldToMaturity)
        } else {
            results.yieldToWorst = results.yieldToMaturity
        }
        
        // Tax-adjusted yields
        let totalTaxRate = federalTaxRate + stateTaxRate + localTaxRate
        if bondCategory == .municipal && !isTaxExempt {
            results.taxEquivalentYield = results.yieldToMaturity / (1 - totalTaxRate / 100.0)
            results.afterTaxYield = results.yieldToMaturity * (1 - totalTaxRate / 100.0)
        } else {
            results.taxEquivalentYield = results.yieldToMaturity
            results.afterTaxYield = results.yieldToMaturity * (1 - totalTaxRate / 100.0)
        }
        
        // Option-adjusted metrics (simplified)
        if hasEmbeddedOptions {
            results.optionValue = calculateEmbeddedOptionValue()
            results.optionAdjustedSpread = creditSpread * 100 - results.optionValue / results.modifiedDuration
            results.zSpread = creditSpread * 100
            results.iSpread = results.yieldToMaturity - (yieldCurveData?.getYield(for: maturity) ?? 0.05) * 100
        }
        
        // Credit metrics
        let creditAnalysis = CreditAnalysis(
            rating: creditRating,
            customSpread: useCustomSpread ? customCreditSpread : nil
        )
        results.expectedLoss = creditAnalysis.expectedLoss * faceValue
        results.creditVaR = creditAnalysis.creditVaR * faceValue
        
        // Key rate duration (simplified - just show for a few key rates)
        results.keyRateDuration = [
            1.0: results.modifiedDuration * 0.1,
            2.0: results.modifiedDuration * 0.2,
            5.0: results.modifiedDuration * 0.4,
            10.0: results.modifiedDuration * 0.8,
            30.0: results.modifiedDuration * 1.0
        ]
        
        return results
    }
    
    /// Calculate price with yield curve shock
    private func calculatePriceWithShock(curve: YieldCurveData, shock: Double) -> Double {
        let shockedRate = curve.getYield(for: maturity) + shock
        let creditSpread = useCustomSpread ? customCreditSpread : creditRating.creditSpread
        return CalculationEngine.calculateBondPrice(
            faceValue: faceValue,
            couponRate: couponRate,
            marketRate: (shockedRate + creditSpread) * 100,
            yearsToMaturity: maturity,
            paymentsPerYear: frequency.periodsPerYear
        )
    }
    
    /// Calculate embedded option value
    private func calculateEmbeddedOptionValue() -> Double {
        guard hasEmbeddedOptions else { return 0 }
        
        // Simplified Black-Scholes approximation for embedded call option
        let timeToCall = callDate > 0 ? callDate : maturity
        
        return CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: faceValue,
            strikePrice: callPrice,
            timeToExpiry: timeToCall,
            riskFreeRate: (yieldCurveData?.getYield(for: timeToCall) ?? 0.05) * 100,
            volatility: volatility,
            optionType: .call
        )
    }
    
    /// Generate explanation text
    private func generateExplanation(for results: AdvancedBondResults) -> String {
        var explanation = ""
        
        if solveFor == .price {
            explanation = "The bond is priced at \(metadata.currency.formatValue(results.cleanPrice)) "
            explanation += "(\(metadata.currency.formatValue(results.dirtyPrice)) including accrued interest) "
            explanation += "based on a yield of \(String(format: "%.2f%%", results.yieldToMaturity)). "
        } else {
            explanation = "The bond's yield to maturity is \(String(format: "%.2f%%", results.yieldToMaturity)) "
            explanation += "based on a price of \(metadata.currency.formatValue(results.cleanPrice)). "
        }
        
        explanation += "The bond has a modified duration of \(String(format: "%.2f", results.modifiedDuration)) years "
        explanation += "and convexity of \(String(format: "%.1f", results.convexity)). "
        
        if hasEmbeddedOptions {
            explanation += "The embedded option is worth \(metadata.currency.formatValue(results.optionValue)). "
            if let ytc = results.yieldToCall {
                explanation += "Yield to call is \(String(format: "%.2f%%", ytc)). "
            }
        }
        
        return explanation
    }
    
    /// Generate yield curve visualization data
    private func generateYieldCurveChartData() -> [ChartDataPoint] {
        guard let curve = yieldCurveData else { return [] }
        
        var data: [ChartDataPoint] = []
        let maturities = [0.25, 0.5, 1, 2, 3, 5, 7, 10, 20, 30]
        
        for mat in maturities {
            let yield = curve.getYield(for: mat) * 100
            data.append(ChartDataPoint(x: mat, y: yield, label: "\(mat)Y"))
        }
        
        // Add current bond position
        let bondYield = marketYield ?? yieldToMaturity ?? 5.0
        data.append(ChartDataPoint(
            x: maturity, 
            y: bondYield, 
            label: "This Bond"
        ))
        
        return data
    }
    
    /// Generate cash flow table
    private func generateCashFlowTable() -> [TableRow] {
        var rows: [TableRow] = []
        let periodsPerYear = frequency.periodsPerYear
        let totalPeriods = Int(maturity * periodsPerYear)
        let couponPayment = faceValue * couponRate / 100.0 / periodsPerYear
        
        for period in 1...totalPeriods {
            let time = Double(period) / periodsPerYear
            let isLastPeriod = period == totalPeriods
            let payment = isLastPeriod ? couponPayment + faceValue : couponPayment
            
            rows.append(TableRow(values: [
                "Period": "\(period)",
                "Time": String(format: "%.2f years", time),
                "Cash Flow": metadata.currency.formatValue(payment),
                "Type": isLastPeriod ? "Coupon + Principal" : "Coupon"
            ]))
        }
        
        return rows
    }
}

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
//
//  InvestmentCalculation.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation
import SwiftData

/// Investment calculation model for NPV, IRR, and performance analysis
@Model
final class InvestmentCalculation {
    // MARK: - Common Properties
    var id: UUID
    var metadata: CalculationMetadata
    
    // MARK: - Computed Properties for Backward Compatibility
    var name: String {
        get { metadata.name }
        set { metadata.name = newValue }
    }
    
    var currency: Currency {
        get { metadata.currency }
        set { metadata.currency = newValue }
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
    
    // MARK: - Investment Specific Properties
    /// Initial investment (negative value)
    var initialInvestment: Double
    
    /// Cash flows for each period
    @Attribute(.transformable(by: CashFlowsTransformer.self))
    var cashFlows: [Double]
    
    /// Discount rate for NPV (as percentage)
    var discountRate: Double
    
    /// Type of investment analysis
    private var analysisTypeRawValue: String
    
    /// Analysis type
    var analysisType: InvestmentAnalysisType {
        get {
            InvestmentAnalysisType(rawValue: analysisTypeRawValue) ?? .npv
        }
        set {
            analysisTypeRawValue = newValue.rawValue
        }
    }
    
    // MARK: - MIRR Parameters
    /// Finance rate for MIRR calculation (as percentage)
    var financeRate: Double = 8.0
    
    /// Reinvestment rate for MIRR calculation (as percentage)
    var reinvestmentRate: Double = 12.0
    
    // MARK: - Advanced IRR Parameters
    /// Configuration for advanced IRR calculation
    var useHighPrecision: Bool = false
    
    // MARK: - Blended IRR Parameters
    /// Multiple investment rounds for blended IRR calculation
    @Attribute(.transformable(by: InvestmentRoundsTransformer.self))
    var investmentRounds: [InvestmentRound] = []
    
    /// Whether to calculate discounted payback period
    var calculateDiscountedPayback: Bool = false
    
    init(
        name: String,
        initialInvestment: Double,
        cashFlows: [Double] = [],
        discountRate: Double = 10.0,
        analysisType: InvestmentAnalysisType = .npv,
        currency: Currency = .usd
    ) {
        self.id = UUID()
        self.metadata = CalculationMetadata(
            name: name,
            calculationType: .investment,
            currency: currency
        )
        
        self.initialInvestment = initialInvestment
        self.cashFlows = cashFlows
        self.discountRate = discountRate
        self.analysisTypeRawValue = analysisType.rawValue
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
        
        // Combine initial investment with cash flows
        var allCashFlows = [-abs(initialInvestment)]
        allCashFlows.append(contentsOf: cashFlows)
        
        let calculatedValue: Double
        var secondaryValues: [String: Double] = [:]
        var explanation: String = ""
        
        switch analysisType {
        case .npv:
            calculatedValue = CalculationEngine.calculateNPV(
                cashFlows: allCashFlows,
                discountRate: discountRate
            )
            
            explanation = calculatedValue > 0 ? 
                "The investment is profitable at the given discount rate" :
                "The investment would result in a loss at the given discount rate"
            
            secondaryValues["Initial Investment"] = initialInvestment
            secondaryValues["Total Cash Inflows"] = cashFlows.reduce(0, +)
            secondaryValues["Discount Rate"] = discountRate
            
            // Calculate profitability index
            let presentValueOfInflows = CalculationEngine.calculateNPV(
                cashFlows: [0] + cashFlows,
                discountRate: discountRate
            )
            let profitabilityIndex = presentValueOfInflows / abs(initialInvestment)
            secondaryValues["Profitability Index"] = profitabilityIndex
            
            // Calculate discounted payback period if requested
            if calculateDiscountedPayback {
                let discountedPayback = calculateDiscountedPaybackPeriod(
                    initialInvestment: initialInvestment,
                    cashFlows: cashFlows,
                    discountRate: discountRate
                )
                if discountedPayback > 0 {
                    secondaryValues["Discounted Payback Period"] = discountedPayback
                }
            }
            
        case .irr:
            calculatedValue = CalculationEngine.calculateIRR(cashFlows: allCashFlows)
            
            explanation = "The internal rate of return is the discount rate that makes NPV equal to zero"
            
            secondaryValues["Initial Investment"] = initialInvestment
            secondaryValues["Total Cash Inflows"] = cashFlows.reduce(0, +)
            
            // Calculate NPV at this IRR (should be close to 0)
            let npvAtIRR = CalculationEngine.calculateNPV(
                cashFlows: allCashFlows,
                discountRate: calculatedValue
            )
            secondaryValues["NPV at IRR"] = npvAtIRR
            
            // Calculate payback period
            var cumulativeCashFlow = -abs(initialInvestment)
            var paybackPeriod = 0.0
            for (index, cashFlow) in cashFlows.enumerated() {
                cumulativeCashFlow += cashFlow
                if cumulativeCashFlow >= 0 {
                    paybackPeriod = Double(index) + 1 - (cumulativeCashFlow - cashFlow) / cashFlow
                    break
                }
            }
            if paybackPeriod > 0 {
                secondaryValues["Payback Period"] = paybackPeriod
            }
            
            // Calculate discounted payback period if requested
            if calculateDiscountedPayback {
                let discountedPayback = calculateDiscountedPaybackPeriod(
                    initialInvestment: initialInvestment,
                    cashFlows: cashFlows,
                    discountRate: calculatedValue // Use IRR as discount rate
                )
                if discountedPayback > 0 {
                    secondaryValues["Discounted Payback Period"] = discountedPayback
                }
            }
            
        case .advancedIRR:
            let config = useHighPrecision ? 
                AdvancedIRRCalculator.CalculationConfig.highPrecision :
                AdvancedIRRCalculator.CalculationConfig.standard
            
            let irrResult = CalculationEngine.calculateAdvancedIRR(cashFlows: allCashFlows, config: config)
            calculatedValue = irrResult.isValid ? irrResult.irr * 100 : 0.0
            
            explanation = "Advanced IRR using \(irrResult.method.rawValue) method with \(irrResult.confidence.rawValue.lowercased()) confidence"
            
            secondaryValues["Initial Investment"] = initialInvestment
            secondaryValues["Total Cash Inflows"] = cashFlows.reduce(0, +)
            secondaryValues["NPV at IRR"] = irrResult.npvAtIRR
            secondaryValues["Calculation Method"] = Double(irrResult.method == .newtonRaphson ? 1 : 0)
            secondaryValues["Iterations"] = Double(irrResult.iterations)
            secondaryValues["Convergence Confidence"] = Double(irrResult.confidence == .high ? 3 : (irrResult.confidence == .medium ? 2 : 1))
            
            if !irrResult.multipleIRRs.isEmpty {
                secondaryValues["Multiple IRRs Detected"] = Double(irrResult.multipleIRRs.count)
            }
            
        case .mirr:
            calculatedValue = CalculationEngine.calculateMIRR(
                cashFlows: allCashFlows,
                financeRate: financeRate,
                reinvestmentRate: reinvestmentRate
            )
            
            explanation = "Modified IRR accounts for different rates for financing costs and reinvestment returns"
            
            secondaryValues["Initial Investment"] = initialInvestment
            secondaryValues["Total Cash Inflows"] = cashFlows.reduce(0, +)
            secondaryValues["Finance Rate"] = financeRate
            secondaryValues["Reinvestment Rate"] = reinvestmentRate
            
            // Calculate traditional IRR for comparison
            let traditionalIRR = CalculationEngine.calculateIRR(cashFlows: allCashFlows)
            secondaryValues["Traditional IRR"] = traditionalIRR
            
        case .blendedIRR:
            if !investmentRounds.isEmpty {
                // Use multiple investment rounds if available
                let followOnInvestments = investmentRounds.map { $0.toFollowOnInvestment() }
                calculatedValue = CalculationEngine.calculateBlendedIRR(investments: followOnInvestments)
                
                explanation = "Blended IRR for \(investmentRounds.count) investment rounds with different timing and amounts"
                
                secondaryValues["Investment Rounds"] = Double(investmentRounds.count)
                secondaryValues["Total Invested"] = investmentRounds.reduce(0) { $0 + abs($1.amount) }
                secondaryValues["Total Cash Inflows"] = investmentRounds.flatMap { $0.cashFlows }.reduce(0, +)
                
                // Add round-specific information
                for (index, round) in investmentRounds.enumerated() {
                    secondaryValues["Round \(index + 1) Amount"] = abs(round.amount)
                    secondaryValues["Round \(index + 1) Start Period"] = Double(round.startPeriod)
                }
            } else {
                // Fall back to single round calculation
                calculatedValue = CalculationEngine.calculateIRR(cashFlows: allCashFlows)
                
                explanation = "Blended IRR calculated as single investment round"
                
                secondaryValues["Initial Investment"] = initialInvestment
                secondaryValues["Total Cash Inflows"] = cashFlows.reduce(0, +)
                secondaryValues["Investment Rounds"] = 1
            }
            
        case .both:
            let npv = CalculationEngine.calculateNPV(
                cashFlows: allCashFlows,
                discountRate: discountRate
            )
            let irr = CalculationEngine.calculateIRR(cashFlows: allCashFlows)
            
            calculatedValue = npv // Primary value is NPV
            secondaryValues["IRR"] = irr
            secondaryValues["Initial Investment"] = initialInvestment
            secondaryValues["Total Cash Inflows"] = cashFlows.reduce(0, +)
            secondaryValues["Discount Rate"] = discountRate
            
            explanation = npv > 0 ? 
                "The investment is profitable with an IRR of \(String(format: "%.2f%%", irr))" :
                "The investment would result in a loss at the given discount rate"
        }
        
        // Generate chart data
        let chartData = generateCashFlowData()
        
        let formattedValue: String
        switch analysisType {
        case .npv:
            formattedValue = metadata.currency.formatValue(calculatedValue)
        case .irr, .advancedIRR, .mirr, .blendedIRR:
            formattedValue = String(format: "%.3f%%", calculatedValue)
        case .both:
            formattedValue = metadata.currency.formatValue(calculatedValue)
        }
        
        return CalculationResult(
            primaryValue: calculatedValue,
            secondaryValues: secondaryValues,
            formattedPrimaryValue: formattedValue,
            explanation: explanation,
            chartData: chartData
        )
    }
    
    var isValid: Bool {
        guard !metadata.name.isEmpty else { return false }
        
        return initialInvestment != 0 &&
               !cashFlows.isEmpty &&
               discountRate >= 0
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if metadata.name.isEmpty {
            errors.append("Name is required")
        }
        
        if initialInvestment == 0 {
            errors.append("Initial investment cannot be zero")
        }
        
        if cashFlows.isEmpty {
            errors.append("At least one cash flow is required")
        }
        
        if discountRate < 0 {
            errors.append("Discount rate cannot be negative")
        }
        
        return errors
    }
    
    /// Generate cash flow data for visualization
    private func generateCashFlowData() -> [ChartDataPoint] {
        var data: [ChartDataPoint] = []
        
        // Initial investment
        data.append(ChartDataPoint(
            x: 0,
            y: -abs(initialInvestment),
            label: "Initial Investment"
        ))
        
        // Cash flows
        for (index, cashFlow) in cashFlows.enumerated() {
            data.append(ChartDataPoint(
                x: Double(index + 1),
                y: cashFlow,
                label: "Period \(index + 1)"
            ))
        }
        
        return data
    }
    
    /// Calculate discounted payback period
    private func calculateDiscountedPaybackPeriod(
        initialInvestment: Double,
        cashFlows: [Double],
        discountRate: Double
    ) -> Double {
        var cumulativeDiscountedCashFlow = -abs(initialInvestment)
        let discountRateDecimal = discountRate / 100.0
        
        for (index, cashFlow) in cashFlows.enumerated() {
            let period = Double(index + 1)
            let discountedCashFlow = cashFlow / pow(1 + discountRateDecimal, period)
            cumulativeDiscountedCashFlow += discountedCashFlow
            
            if cumulativeDiscountedCashFlow >= 0 {
                // Interpolate to find exact period
                let previousCumulative = cumulativeDiscountedCashFlow - discountedCashFlow
                let fraction = -previousCumulative / discountedCashFlow
                return period - 1 + fraction
            }
        }
        
        // If payback period exceeds the number of periods, return -1
        return -1
    }
}

// MARK: - Protocol Conformance

extension InvestmentCalculation: FinancialCalculationProtocol {}

/// Type of investment analysis
enum InvestmentAnalysisType: String, CaseIterable, Identifiable {
    case npv = "npv"
    case irr = "irr"
    case both = "both"
    case advancedIRR = "advanced_irr"
    case mirr = "mirr"
    case blendedIRR = "blended_irr"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .npv:
            return "Net Present Value (NPV)"
        case .irr:
            return "Internal Rate of Return (IRR)"
        case .both:
            return "NPV & IRR"
        case .advancedIRR:
            return "Advanced IRR Analysis"
        case .mirr:
            return "Modified IRR (MIRR)"
        case .blendedIRR:
            return "Blended IRR"
        }
    }
    
    var description: String {
        switch self {
        case .npv:
            return "Calculate the present value of future cash flows"
        case .irr:
            return "Calculate the rate of return that makes NPV zero"
        case .both:
            return "Calculate both NPV and IRR for comprehensive analysis"
        case .advancedIRR:
            return "Calculate IRR using Newton-Raphson method with multiple IRR detection"
        case .mirr:
            return "Calculate Modified IRR with separate finance and reinvestment rates"
        case .blendedIRR:
            return "Calculate IRR for multiple investment rounds with different timing"
        }
    }
}

// MARK: - Supporting Types

/// Represents an investment round for blended IRR calculation
struct InvestmentRound: Codable {
    let name: String
    let amount: Double
    let startPeriod: Int
    let cashFlows: [Double]
    let weight: Double
    
    init(
        name: String,
        amount: Double,
        startPeriod: Int,
        cashFlows: [Double] = [],
        weight: Double = 1.0
    ) {
        self.name = name
        self.amount = amount
        self.startPeriod = startPeriod
        self.cashFlows = cashFlows
        self.weight = weight
    }
    
    /// Convert to FollowOnInvestment for calculation
    func toFollowOnInvestment() -> FollowOnInvestment {
        var allCashFlows = [-abs(amount)]
        allCashFlows.append(contentsOf: cashFlows)
        
        return FollowOnInvestment(
            cashFlows: allCashFlows,
            startPeriod: startPeriod,
            weight: weight,
            description: name
        )
    }
}

/// Transformer for storing InvestmentRound array in SwiftData
@objc(InvestmentRoundsTransformer)
final class InvestmentRoundsTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let rounds = value as? [InvestmentRound] else { return nil }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(rounds)
            return data as NSData
        } catch {
            print("Failed to encode investment rounds: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let rounds = try decoder.decode([InvestmentRound].self, from: data)
            return rounds
        } catch {
            print("Failed to decode investment rounds: \(error)")
            return nil
        }
    }
    
    /// Register the transformer for use with SwiftData
    static func register() {
        ValueTransformer.setValueTransformer(
            InvestmentRoundsTransformer(),
            forName: NSValueTransformerName("InvestmentRoundsTransformer")
        )
    }
}


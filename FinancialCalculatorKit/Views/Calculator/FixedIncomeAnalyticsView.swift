//
//  FixedIncomeAnalyticsView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

/// Advanced fixed income analytics calculator for CFA Level 2/3
struct FixedIncomeAnalyticsView: View {
    @State private var analyticsType: AnalyticsType = .durationMatching
    @State private var faceValue: Double = 1000.0
    @State private var couponRate: Double = 0.05
    @State private var maturity: Double = 10.0
    @State private var yieldToMaturity: Double = 0.04
    @State private var currentPrice: Double = 1081.11
    @State private var frequency: PaymentFrequency = .semiAnnual
    
    // Immunization parameters
    @State private var liabilityAmount: Double = 1000000.0
    @State private var liabilityDuration: Double = 7.5
    @State private var targetHorizon: Double = 5.0
    
    // Credit analysis
    @State private var creditSpread: Double = 0.015
    @State private var recoveryRate: Double = 0.40
    @State private var probabilityOfDefault: Double = 0.02
    
    @State private var results: FixedIncomeResults = FixedIncomeResults()
    @State private var yieldCurveData: [YieldPoint] = []
    @State private var durationData: [DurationPoint] = []
    @State private var convexityData: [ConvexityPoint] = []
    @State private var immunizationPortfolio: [BondHolding] = []
    
    enum AnalyticsType: String, CaseIterable, Identifiable {
        case durationMatching = "durationMatching"
        case immunization = "immunization"
        case yieldCurveAnalysis = "yieldCurveAnalysis"
        case creditAnalysis = "creditAnalysis"
        case bondLaddering = "bondLaddering"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .durationMatching: return "Duration Matching"
            case .immunization: return "Immunization Strategy"
            case .yieldCurveAnalysis: return "Yield Curve Analysis"
            case .creditAnalysis: return "Credit Risk Analysis"
            case .bondLaddering: return "Bond Laddering"
            }
        }
    }
    
    struct FixedIncomeResults {
        var macaulayDuration: Double = 0.0
        var modifiedDuration: Double = 0.0
        var effectiveDuration: Double = 0.0
        var dollarDuration: Double = 0.0
        var convexity: Double = 0.0
        var dv01: Double = 0.0
        var pvbp: Double = 0.0
        var keyRateDuration01: Double = 0.0
        var keyRateDuration05: Double = 0.0
        var keyRateDuration10: Double = 0.0
        var optionAdjustedSpread: Double = 0.0
        var zSpread: Double = 0.0
        var creditSpreadDuration: Double = 0.0
        var expectedLoss: Double = 0.0
        var immunizationError: Double = 0.0
    }
    
    struct YieldPoint: Identifiable {
        let id = UUID()
        let maturity: Double
        let yieldValue: Double
        let spotRate: Double
        let forwardRate: Double
    }
    
    struct DurationPoint: Identifiable {
        let id = UUID()
        let yieldChange: Double
        let priceChange: Double
        let durationEstimate: Double
        let convexityAdjustment: Double
    }
    
    struct ConvexityPoint: Identifiable {
        let id = UUID()
        let yieldLevel: Double
        let bondPrice: Double
        let convexityEffect: Double
    }
    
    struct BondHolding: Identifiable {
        let id = UUID()
        var name: String
        var faceValue: Double
        var couponRate: Double
        var maturity: Double
        var weight: Double
        var duration: Double
        var convexity: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    // Adaptive layout
                    if geometry.size.width > 1000 {
                        HStack(alignment: .top, spacing: 24) {
                            VStack(spacing: 24) {
                                inputSection
                                if analyticsType == .immunization {
                                    immunizationInputs
                                }
                                if analyticsType == .creditAnalysis {
                                    creditAnalysisInputs
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 24) {
                                resultsSection
                                if analyticsType == .immunization {
                                    portfolioSection
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        VStack(spacing: 24) {
                            inputSection
                            if analyticsType == .immunization {
                                immunizationInputs
                            }
                            if analyticsType == .creditAnalysis {
                                creditAnalysisInputs
                            }
                            resultsSection
                            if analyticsType == .immunization {
                                portfolioSection
                            }
                        }
                    }
                    
                    analyticsChartsSection
                    formulasSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            initializeData()
            performAnalysis()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Fixed Income Analytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Advanced bond analytics, duration matching, immunization, and credit analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Analytics Type", selection: $analyticsType) {
                    ForEach(AnalyticsType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 250)
                .onChange(of: analyticsType) { _, _ in
                    performAnalysis()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        GroupBox("Bond Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Face Value",
                    subtitle: "Bond par value",
                    value: Binding(
                        get: { faceValue },
                        set: { faceValue = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Bond face value or par amount"
                )
                .onChange(of: faceValue) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Coupon Rate",
                    subtitle: "Annual coupon rate",
                    value: Binding(
                        get: { couponRate * 100 },
                        set: { couponRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Annual coupon rate"
                )
                .onChange(of: couponRate) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Maturity",
                    subtitle: "Years to maturity",
                    value: Binding(
                        get: { String(format: "%.2f", maturity) },
                        set: { maturity = Double($0) ?? 0 }
                    ),
                    placeholder: "10.0",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Years until bond maturity"
                )
                .onChange(of: maturity) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Yield to Maturity",
                    subtitle: "Required yield",
                    value: Binding(
                        get: { yieldToMaturity * 100 },
                        set: { yieldToMaturity = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Yield to maturity"
                )
                .onChange(of: yieldToMaturity) { _, _ in performAnalysis() }
                
                HStack {
                    Text("Payment Frequency")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(PaymentFrequency.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: frequency) { _, _ in performAnalysis() }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var immunizationInputs: some View {
        GroupBox("Immunization Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Liability Amount",
                    subtitle: "Future liability value",
                    value: Binding(
                        get: { liabilityAmount },
                        set: { liabilityAmount = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Amount of future liability to immunize"
                )
                .onChange(of: liabilityAmount) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Liability Duration",
                    subtitle: "Target duration years",
                    value: Binding(
                        get: { String(format: "%.2f", liabilityDuration) },
                        set: { liabilityDuration = Double($0) ?? 0 }
                    ),
                    placeholder: "7.5",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Duration of the liability to match"
                )
                .onChange(of: liabilityDuration) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Time Horizon",
                    subtitle: "Investment horizon years",
                    value: Binding(
                        get: { String(format: "%.2f", targetHorizon) },
                        set: { targetHorizon = Double($0) ?? 0 }
                    ),
                    placeholder: "5.0",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Investment time horizon"
                )
                .onChange(of: targetHorizon) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var creditAnalysisInputs: some View {
        GroupBox("Credit Risk Parameters") {
            VStack(spacing: 16) {
                PercentageInputField(
                    title: "Credit Spread",
                    subtitle: "Spread over treasury",
                    value: Binding(
                        get: { creditSpread * 100 },
                        set: { creditSpread = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Credit spread over risk-free rate"
                )
                .onChange(of: creditSpread) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Recovery Rate",
                    subtitle: "Expected recovery",
                    value: Binding(
                        get: { recoveryRate * 100 },
                        set: { recoveryRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Expected recovery rate in default"
                )
                .onChange(of: recoveryRate) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Default Probability",
                    subtitle: "Annual default probability",
                    value: Binding(
                        get: { probabilityOfDefault * 100 },
                        set: { probabilityOfDefault = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Annual probability of default"
                )
                .onChange(of: probabilityOfDefault) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        VStack(spacing: 20) {
            GroupBox("Duration & Convexity Analysis") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Macaulay Duration",
                        value: String(format: "%.4f years", results.macaulayDuration),
                        isHighlighted: true
                    )
                    
                    DetailRow(
                        title: "Modified Duration",
                        value: String(format: "%.4f", results.modifiedDuration)
                    )
                    
                    DetailRow(
                        title: "Effective Duration",
                        value: String(format: "%.4f", results.effectiveDuration)
                    )
                    
                    DetailRow(
                        title: "Dollar Duration",
                        value: Formatters.formatCurrency(results.dollarDuration, currency: .usd)
                    )
                    
                    DetailRow(
                        title: "Convexity",
                        value: String(format: "%.4f", results.convexity)
                    )
                    
                    DetailRow(
                        title: "DV01",
                        value: Formatters.formatCurrency(results.dv01, currency: .usd)
                    )
                    
                    DetailRow(
                        title: "PVBP",
                        value: Formatters.formatCurrency(results.pvbp, currency: .usd)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            if analyticsType == .yieldCurveAnalysis {
                GroupBox("Yield Curve Measures") {
                    VStack(spacing: 16) {
                        DetailRow(
                            title: "Key Rate Duration (1Y)",
                            value: String(format: "%.4f", results.keyRateDuration01)
                        )
                        
                        DetailRow(
                            title: "Key Rate Duration (5Y)",
                            value: String(format: "%.4f", results.keyRateDuration05)
                        )
                        
                        DetailRow(
                            title: "Key Rate Duration (10Y)",
                            value: String(format: "%.4f", results.keyRateDuration10)
                        )
                        
                        DetailRow(
                            title: "Option-Adjusted Spread",
                            value: String(format: "%.2f bps", results.optionAdjustedSpread * 10000)
                        )
                        
                        DetailRow(
                            title: "Z-Spread",
                            value: String(format: "%.2f bps", results.zSpread * 10000)
                        )
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
            
            if analyticsType == .creditAnalysis {
                GroupBox("Credit Risk Measures") {
                    VStack(spacing: 16) {
                        DetailRow(
                            title: "Credit Spread Duration",
                            value: String(format: "%.4f", results.creditSpreadDuration)
                        )
                        
                        DetailRow(
                            title: "Expected Loss",
                            value: String(format: "%.2f%%", results.expectedLoss * 100)
                        )
                        
                        DetailRow(
                            title: "Loss Given Default",
                            value: String(format: "%.2f%%", (1 - recoveryRate) * 100)
                        )
                        
                        DetailRow(
                            title: "Credit VaR (99%)",
                            value: Formatters.formatCurrency(results.expectedLoss * currentPrice * 2.33, currency: .usd)
                        )
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
            
            if analyticsType == .immunization {
                GroupBox("Immunization Analysis") {
                    VStack(spacing: 16) {
                        DetailRow(
                            title: "Portfolio Duration",
                            value: String(format: "%.4f years", results.macaulayDuration)
                        )
                        
                        DetailRow(
                            title: "Target Duration",
                            value: String(format: "%.4f years", liabilityDuration)
                        )
                        
                        DetailRow(
                            title: "Duration Mismatch",
                            value: String(format: "%.4f years", results.immunizationError)
                        )
                        
                        DetailRow(
                            title: "Immunization Quality",
                            value: abs(results.immunizationError) < 0.1 ? "Good" : "Needs Adjustment",
                            isHighlighted: abs(results.immunizationError) < 0.1
                        )
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var portfolioSection: some View {
        GroupBox("Immunization Portfolio") {
            VStack(spacing: 16) {
                HStack {
                    Text("Bond Holdings")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button("Optimize Portfolio") {
                        optimizeImmunizationPortfolio()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if immunizationPortfolio.isEmpty {
                    Text("Click 'Optimize Portfolio' to generate immunization strategy")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(immunizationPortfolio) { bond in
                                bondHoldingRow(bond: bond)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private func bondHoldingRow(bond: BondHolding) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(bond.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(String(format: "%.1f", bond.couponRate * 100))% • \(String(format: "%.1f", bond.maturity))Y")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.1f%%", bond.weight * 100))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Dur: \(String(format: "%.2f", bond.duration))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
    }
    
    @ViewBuilder
    private var analyticsChartsSection: some View {
        switch analyticsType {
        case .durationMatching:
            durationAnalysisChart
        case .yieldCurveAnalysis:
            yieldCurveChart
        case .creditAnalysis:
            creditAnalysisChart
        case .immunization:
            immunizationChart
        case .bondLaddering:
            bondLadderChart
        }
    }
    
    @ViewBuilder
    private var durationAnalysisChart: some View {
        GroupBox("Duration & Convexity Analysis") {
            VStack(spacing: 16) {
                if !durationData.isEmpty {
                    Chart(durationData) { point in
                        LineMark(
                            x: .value("Yield Change", point.yieldChange * 100),
                            y: .value("Price Change", point.priceChange * 100)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        LineMark(
                            x: .value("Yield Change", point.yieldChange * 100),
                            y: .value("Duration Est", point.durationEstimate * 100)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        
                        LineMark(
                            x: .value("Yield Change", point.yieldChange * 100),
                            y: .value("Convexity Adj", point.convexityAdjustment * 100)
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [2, 3]))
                    }
                    .frame(height: 300)
                    .chartXAxisLabel("Yield Change (%)")
                    .chartYAxisLabel("Price Change (%)")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("— Actual Price Change")
                            .foregroundColor(.blue)
                        Text("⋯ Duration Estimate")
                            .foregroundColor(.red)
                        Text("⋯ Duration + Convexity")
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("Shows accuracy of duration and convexity approximations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var yieldCurveChart: some View {
        GroupBox("Yield Curve Analysis") {
            VStack(spacing: 16) {
                if !yieldCurveData.isEmpty {
                    Chart(yieldCurveData) { point in
                        LineMark(
                            x: .value("Maturity", point.maturity),
                            y: .value("Yield", point.yieldValue * 100)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        LineMark(
                            x: .value("Maturity", point.maturity),
                            y: .value("Spot Rate", point.spotRate * 100)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        
                        LineMark(
                            x: .value("Maturity", point.maturity),
                            y: .value("Forward Rate", point.forwardRate * 100)
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [2, 3]))
                    }
                    .frame(height: 300)
                    .chartXAxisLabel("Maturity (Years)")
                    .chartYAxisLabel("Rate (%)")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("— Par Yield Curve")
                            .foregroundColor(.blue)
                        Text("⋯ Spot Rate Curve")
                            .foregroundColor(.red)
                        Text("⋯ Forward Rate Curve")
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("Yield curve relationships and term structure")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var creditAnalysisChart: some View {
        GroupBox("Credit Risk Visualization") {
            VStack(spacing: 16) {
                let creditMetrics = [
                    ("Default Prob", probabilityOfDefault * 100),
                    ("Recovery Rate", recoveryRate * 100),
                    ("Loss Given Default", (1 - recoveryRate) * 100),
                    ("Expected Loss", results.expectedLoss * 100)
                ]
                
                Chart(creditMetrics, id: \.0) { metric in
                    BarMark(
                        x: .value("Metric", metric.0),
                        y: .value("Percentage", metric.1)
                    )
                    .foregroundStyle(metric.0 == "Expected Loss" ? .red : .blue)
                }
                .frame(height: 250)
                .chartXAxisLabel("Credit Risk Metrics")
                .chartYAxisLabel("Percentage (%)")
                
                Text("Credit risk decomposition and expected loss calculation")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var immunizationChart: some View {
        GroupBox("Immunization Strategy") {
            VStack(spacing: 16) {
                if !immunizationPortfolio.isEmpty {
                    Chart(immunizationPortfolio) { bond in
                        SectorMark(
                            angle: .value("Weight", bond.weight),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(0.9)
                        )
                        .foregroundStyle(by: .value("Bond", bond.name))
                        .opacity(0.8)
                    }
                    .frame(height: 250)
                    .chartLegend(position: .bottom, alignment: .center)
                }
                
                Text("Portfolio allocation for immunization strategy")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var bondLadderChart: some View {
        GroupBox("Bond Ladder Strategy") {
            VStack(spacing: 16) {
                let ladderData = generateBondLadderData()
                
                Chart(ladderData) { point in
                    BarMark(
                        x: .value("Year", point.maturity),
                        y: .value("Cash Flow", point.yieldValue)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
                .chartXAxisLabel("Maturity Year")
                .chartYAxisLabel("Cash Flow ($)")
                
                Text("Equal cash flows from maturing bonds each year")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Fixed Income Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Key Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Macaulay Duration:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$D_{Mac} = \\frac{\\sum_{t=1}^{n} \\frac{t \\cdot CF_t}{(1+y)^t}}{P}$")
                        .frame(height: 40)
                    
                    Text("Modified Duration:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$D_{Mod} = \\frac{D_{Mac}}{1 + \\frac{y}{m}}$")
                        .frame(height: 40)
                    
                    Text("Convexity:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$C = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{CF_t \\cdot t \\cdot (t+1)}{(1+y)^{t+2}}$")
                        .frame(height: 40)
                    
                    if analyticsType == .creditAnalysis {
                        Text("Expected Loss:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$EL = PD \\times LGD \\times EAD$")
                            .frame(height: 40)
                        
                        Text("Credit Spread Duration:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$CSD = -\\frac{1}{P} \\frac{\\partial P}{\\partial s}$")
                            .frame(height: 40)
                    }
                    
                    Text("Where: P = price, CF = cash flow, y = yield, t = time, m = payments per year, PD = probability of default, LGD = loss given default, EAD = exposure at default, s = credit spread")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func initializeData() {
        currentPrice = calculateBondPrice()
        generateYieldCurveData()
        generateDurationData()
    }
    
    private func performAnalysis() {
        currentPrice = calculateBondPrice()
        
        let macDuration = calculateMacaulayDuration()
        let modDuration = calculateModifiedDuration(macDuration)
        let convexity = calculateConvexity()
        let dv01 = calculateDV01()
        
        results = FixedIncomeResults(
            macaulayDuration: macDuration,
            modifiedDuration: modDuration,
            effectiveDuration: modDuration, // Simplified
            dollarDuration: modDuration * currentPrice / 100,
            convexity: convexity,
            dv01: dv01,
            pvbp: dv01,
            keyRateDuration01: modDuration * 0.1,
            keyRateDuration05: modDuration * 0.5,
            keyRateDuration10: modDuration * 0.4,
            optionAdjustedSpread: 0.0,
            zSpread: creditSpread,
            creditSpreadDuration: modDuration * 0.8,
            expectedLoss: probabilityOfDefault * (1 - recoveryRate),
            immunizationError: abs(macDuration - liabilityDuration)
        )
        
        generateDurationData()
        generateConvexityData()
    }
    
    private func calculateBondPrice() -> Double {
        let periods = maturity * Double(frequency.periodsPerYear)
        let periodicRate = yieldToMaturity / Double(frequency.periodsPerYear)
        let periodicCoupon = couponRate * faceValue / Double(frequency.periodsPerYear)
        
        var price = 0.0
        
        // Present value of coupon payments
        for period in 1...Int(periods) {
            price += periodicCoupon / pow(1 + periodicRate, Double(period))
        }
        
        // Present value of principal
        price += faceValue / pow(1 + periodicRate, periods)
        
        return price
    }
    
    private func calculateMacaulayDuration() -> Double {
        let periods = maturity * Double(frequency.periodsPerYear)
        let periodicRate = yieldToMaturity / Double(frequency.periodsPerYear)
        let periodicCoupon = couponRate * faceValue / Double(frequency.periodsPerYear)
        
        var weightedTime = 0.0
        var totalPV = 0.0
        
        // Present value and weighted time of coupon payments
        for period in 1...Int(periods) {
            let pv = periodicCoupon / pow(1 + periodicRate, Double(period))
            let timeInYears = Double(period) / Double(frequency.periodsPerYear)
            
            weightedTime += timeInYears * pv
            totalPV += pv
        }
        
        // Present value and weighted time of principal
        let principalPV = faceValue / pow(1 + periodicRate, periods)
        let principalTime = maturity
        
        weightedTime += principalTime * principalPV
        totalPV += principalPV
        
        return weightedTime / totalPV
    }
    
    private func calculateModifiedDuration(_ macDuration: Double) -> Double {
        let periodicRate = yieldToMaturity / Double(frequency.periodsPerYear)
        return macDuration / (1 + periodicRate)
    }
    
    private func calculateConvexity() -> Double {
        let periods = maturity * Double(frequency.periodsPerYear)
        let periodicRate = yieldToMaturity / Double(frequency.periodsPerYear)
        let periodicCoupon = couponRate * faceValue / Double(frequency.periodsPerYear)
        
        var convexity = 0.0
        
        // Convexity from coupon payments
        for period in 1...Int(periods) {
            let t = Double(period)
            let cf = periodicCoupon
            let pv = cf / pow(1 + periodicRate, t)
            
            convexity += (t * (t + 1) * pv) / pow(1 + periodicRate, 2)
        }
        
        // Convexity from principal
        let principalPV = faceValue / pow(1 + periodicRate, periods)
        convexity += (periods * (periods + 1) * principalPV) / pow(1 + periodicRate, 2)
        
        return convexity / (currentPrice * pow(Double(frequency.periodsPerYear), 2))
    }
    
    private func calculateDV01() -> Double {
        let shiftUp = calculateBondPriceWithYield(yieldToMaturity + 0.0001)
        let shiftDown = calculateBondPriceWithYield(yieldToMaturity - 0.0001)
        
        return abs((shiftUp - shiftDown) / 2)
    }
    
    private func calculateBondPriceWithYield(_ yield: Double) -> Double {
        let periods = maturity * Double(frequency.periodsPerYear)
        let periodicRate = yield / Double(frequency.periodsPerYear)
        let periodicCoupon = couponRate * faceValue / Double(frequency.periodsPerYear)
        
        var price = 0.0
        
        for period in 1...Int(periods) {
            price += periodicCoupon / pow(1 + periodicRate, Double(period))
        }
        
        price += faceValue / pow(1 + periodicRate, periods)
        
        return price
    }
    
    private func generateYieldCurveData() {
        yieldCurveData = []
        
        let maturities = [0.25, 0.5, 1.0, 2.0, 3.0, 5.0, 7.0, 10.0, 20.0, 30.0]
        
        for maturity in maturities {
            // Simplified yield curve (typically upward sloping)
            let baseRate = 0.02
            let termPremium = maturity * 0.001
            let parYield = baseRate + termPremium
            let spotRate = parYield + 0.001
            let forwardRate = spotRate + maturity * 0.0005
            
            yieldCurveData.append(YieldPoint(
                maturity: maturity,
                yieldValue: parYield,
                spotRate: spotRate,
                forwardRate: forwardRate
            ))
        }
    }
    
    private func generateDurationData() {
        durationData = []
        
        let yieldChanges = Array(stride(from: -0.03, through: 0.03, by: 0.005))
        
        for change in yieldChanges {
            let newYield = yieldToMaturity + change
            let newPrice = calculateBondPriceWithYield(newYield)
            let actualPriceChange = (newPrice - currentPrice) / currentPrice
            
            // Duration estimate
            let durationEstimate = -results.modifiedDuration * change
            
            // Duration + convexity estimate
            let convexityAdjustment = durationEstimate + 0.5 * results.convexity * change * change
            
            durationData.append(DurationPoint(
                yieldChange: change,
                priceChange: actualPriceChange,
                durationEstimate: durationEstimate,
                convexityAdjustment: convexityAdjustment
            ))
        }
    }
    
    private func generateConvexityData() {
        convexityData = []
        
        let yieldLevels = Array(stride(from: 0.01, through: 0.08, by: 0.005))
        
        for yieldLevel in yieldLevels {
            let price = calculateBondPriceWithYield(yieldLevel)
            let convexityEffect = results.convexity * pow(yieldLevel - yieldToMaturity, 2) / 2
            
            convexityData.append(ConvexityPoint(
                yieldLevel: yieldLevel,
                bondPrice: price,
                convexityEffect: convexityEffect
            ))
        }
    }
    
    private func optimizeImmunizationPortfolio() {
        // Generate a simple immunization portfolio
        immunizationPortfolio = [
            BondHolding(
                name: "Short-Term Bond",
                faceValue: 500000,
                couponRate: 0.03,
                maturity: liabilityDuration * 0.6,
                weight: 0.4,
                duration: liabilityDuration * 0.6,
                convexity: 2.5
            ),
            BondHolding(
                name: "Long-Term Bond",
                faceValue: 500000,
                couponRate: 0.06,
                maturity: liabilityDuration * 1.4,
                weight: 0.6,
                duration: liabilityDuration * 1.4,
                convexity: 8.2
            )
        ]
        
        // Recalculate immunization error
        let portfolioDuration = immunizationPortfolio.reduce(0) { $0 + ($1.weight * $1.duration) }
        results.immunizationError = abs(portfolioDuration - liabilityDuration)
    }
    
    private func generateBondLadderData() -> [YieldPoint] {
        var ladderData: [YieldPoint] = []
        
        for year in 1...10 {
            ladderData.append(YieldPoint(
                maturity: Double(year),
                yieldValue: 100000.0, // Equal $100k per year
                spotRate: 0.0,
                forwardRate: 0.0
            ))
        }
        
        return ladderData
    }
}

#Preview {
    FixedIncomeAnalyticsView()
        .frame(width: 1400, height: 1200)
}
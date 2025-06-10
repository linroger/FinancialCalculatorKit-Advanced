//
//  EquityValuationView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

/// Comprehensive equity valuation calculator for CFA exams
struct EquityValuationView: View {
    @State private var dividendGrowthRate: Double = 0.05  // 5%
    @State private var requiredReturn: Double = 0.10      // 10%
    @State private var currentDividend: Double = 2.0      // $2.00
    @State private var expectedDividend: Double = 2.10    // $2.10
    @State private var terminalGrowthRate: Double = 0.03  // 3%
    @State private var highGrowthYears: Double = 5        // 5 years
    @State private var valuationMethod: ValuationMethod = .ddm
    
    // Market multiples
    @State private var marketPE: Double = 15.0
    @State private var marketPB: Double = 1.5
    @State private var marketPS: Double = 2.0
    @State private var companyEPS: Double = 5.0
    @State private var companyBVPS: Double = 25.0
    @State private var companySales: Double = 100.0
    
    // DCF Parameters
    @State private var fcf1: Double = 10.0  // Free cash flow year 1
    @State private var fcfGrowthRate: Double = 0.08  // 8%
    @State private var wacc: Double = 0.09   // 9%
    @State private var terminalFCFGrowth: Double = 0.03  // 3%
    
    @State private var results: EquityResults = EquityResults()
    @State private var sensitivityData: [SensitivityPoint] = []
    @State private var compareData: [ComparisonPoint] = []
    
    enum ValuationMethod: String, CaseIterable, Identifiable {
        case ddm = "ddm"
        case twoStageDDM = "twoStageDDM"
        case dcf = "dcf"
        case multiples = "multiples"
        case capm = "capm"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .ddm: return "Dividend Discount Model"
            case .twoStageDDM: return "Two-Stage DDM"
            case .dcf: return "DCF Valuation"
            case .multiples: return "Market Multiples"
            case .capm: return "CAPM Analysis"
            }
        }
    }
    
    struct EquityResults {
        var intrinsicValue: Double = 0.0
        var currentYield: Double = 0.0
        var capitalGainsYield: Double = 0.0
        var totalReturn: Double = 0.0
        var pv: Double = 0.0
        var terminalValue: Double = 0.0
        var peRatio: Double = 0.0
        var pbRatio: Double = 0.0
        var psRatio: Double = 0.0
    }
    
    struct SensitivityPoint: Identifiable {
        let id = UUID()
        let parameter: String
        let value: Double
        let intrinsicValue: Double
    }
    
    struct ComparisonPoint: Identifiable {
        let id = UUID()
        let method: String
        let value: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    // Adaptive layout
                    if geometry.size.width > 800 {
                        HStack(alignment: .top, spacing: 24) {
                            inputSection
                            resultsSection
                        }
                    } else {
                        VStack(spacing: 24) {
                            inputSection
                            resultsSection
                        }
                    }
                    
                    formulasSection
                    sensitivitySection
                    comparisonSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            calculateValuation()
            generateSensitivityData()
            generateComparisonData()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Equity Valuation Models")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Comprehensive equity valuation using DDM, DCF, and multiples analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Valuation Method", selection: $valuationMethod) {
                    ForEach(ValuationMethod.allCases) { method in
                        Text(method.displayName).tag(method)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 400)
                .onChange(of: valuationMethod) { _, _ in
                    calculateAndUpdate()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
            switch valuationMethod {
            case .ddm, .twoStageDDM:
                dividendInputs
            case .dcf:
                dcfInputs
            case .multiples:
                multiplesInputs
            case .capm:
                capmInputs
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var dividendInputs: some View {
        GroupBox("Dividend Discount Model Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Current Dividend",
                    subtitle: "Most recent dividend per share",
                    value: Binding(
                        get: { currentDividend },
                        set: { currentDividend = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Most recent annual dividend per share"
                )
                .onChange(of: currentDividend) { _, _ in calculateAndUpdate() }
                
                if valuationMethod == .twoStageDDM {
                    CurrencyInputField(
                        title: "Expected Dividend (Year 1)",
                        subtitle: "Expected dividend next year",
                        value: Binding(
                            get: { expectedDividend },
                            set: { expectedDividend = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Expected dividend for next year"
                    )
                    .onChange(of: expectedDividend) { _, _ in calculateAndUpdate() }
                    
                    InputFieldView(
                        title: "High Growth Years",
                        subtitle: "Years of high growth",
                        value: Binding(
                            get: { String(format: "%.0f", highGrowthYears) },
                            set: { highGrowthYears = Double($0) ?? 0 }
                        ),
                        placeholder: "5",
                        keyboardType: .numberPad,
                        validation: .positiveNumber,
                        helpText: "Number of years of high growth"
                    )
                    .onChange(of: highGrowthYears) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Terminal Growth Rate",
                        subtitle: "Long-term growth rate",
                        value: Binding(
                            get: { terminalGrowthRate * 100 },
                            set: { terminalGrowthRate = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Long-term sustainable growth rate"
                    )
                    .onChange(of: terminalGrowthRate) { _, _ in calculateAndUpdate() }
                }
                
                PercentageInputField(
                    title: "Growth Rate",
                    subtitle: valuationMethod == .twoStageDDM ? "High growth rate" : "Constant growth rate",
                    value: Binding(
                        get: { dividendGrowthRate * 100 },
                        set: { dividendGrowthRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: valuationMethod == .twoStageDDM ? "High growth rate for initial years" : "Constant dividend growth rate"
                )
                .onChange(of: dividendGrowthRate) { _, _ in calculateAndUpdate() }
                
                PercentageInputField(
                    title: "Required Return",
                    subtitle: "Cost of equity",
                    value: Binding(
                        get: { requiredReturn * 100 },
                        set: { requiredReturn = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Required rate of return (cost of equity)"
                )
                .onChange(of: requiredReturn) { _, _ in calculateAndUpdate() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var dcfInputs: some View {
        GroupBox("DCF Model Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Free Cash Flow (Year 1)",
                    subtitle: "Expected FCF next year",
                    value: Binding(
                        get: { fcf1 },
                        set: { fcf1 = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Expected free cash flow for next year"
                )
                .onChange(of: fcf1) { _, _ in calculateAndUpdate() }
                
                PercentageInputField(
                    title: "FCF Growth Rate",
                    subtitle: "High growth rate",
                    value: Binding(
                        get: { fcfGrowthRate * 100 },
                        set: { fcfGrowthRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Free cash flow growth rate"
                )
                .onChange(of: fcfGrowthRate) { _, _ in calculateAndUpdate() }
                
                PercentageInputField(
                    title: "WACC",
                    subtitle: "Weighted average cost of capital",
                    value: Binding(
                        get: { wacc * 100 },
                        set: { wacc = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Weighted average cost of capital"
                )
                .onChange(of: wacc) { _, _ in calculateAndUpdate() }
                
                InputFieldView(
                    title: "High Growth Years",
                    subtitle: "Years of high growth",
                    value: Binding(
                        get: { String(format: "%.0f", highGrowthYears) },
                        set: { highGrowthYears = Double($0) ?? 0 }
                    ),
                    placeholder: "5",
                    keyboardType: .numberPad,
                    validation: .positiveNumber,
                    helpText: "Number of years of high FCF growth"
                )
                .onChange(of: highGrowthYears) { _, _ in calculateAndUpdate() }
                
                PercentageInputField(
                    title: "Terminal FCF Growth",
                    subtitle: "Long-term FCF growth",
                    value: Binding(
                        get: { terminalFCFGrowth * 100 },
                        set: { terminalFCFGrowth = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Long-term sustainable FCF growth rate"
                )
                .onChange(of: terminalFCFGrowth) { _, _ in calculateAndUpdate() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var multiplesInputs: some View {
        GroupBox("Market Multiples Analysis") {
            VStack(spacing: 16) {
                Text("Market Multiples")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                InputFieldView(
                    title: "Market P/E Ratio",
                    subtitle: "Industry/market P/E",
                    value: Binding(
                        get: { String(format: "%.1f", marketPE) },
                        set: { marketPE = Double($0) ?? 0 }
                    ),
                    placeholder: "15.0",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Market or industry P/E ratio"
                )
                .onChange(of: marketPE) { _, _ in calculateAndUpdate() }
                
                InputFieldView(
                    title: "Market P/B Ratio",
                    subtitle: "Industry/market P/B",
                    value: Binding(
                        get: { String(format: "%.1f", marketPB) },
                        set: { marketPB = Double($0) ?? 0 }
                    ),
                    placeholder: "1.5",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Market or industry P/B ratio"
                )
                .onChange(of: marketPB) { _, _ in calculateAndUpdate() }
                
                InputFieldView(
                    title: "Market P/S Ratio",
                    subtitle: "Industry/market P/S",
                    value: Binding(
                        get: { String(format: "%.1f", marketPS) },
                        set: { marketPS = Double($0) ?? 0 }
                    ),
                    placeholder: "2.0",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Market or industry P/S ratio"
                )
                .onChange(of: marketPS) { _, _ in calculateAndUpdate() }
                
                Divider()
                
                Text("Company Fundamentals")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CurrencyInputField(
                    title: "Earnings Per Share",
                    subtitle: "Company EPS",
                    value: Binding(
                        get: { companyEPS },
                        set: { companyEPS = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Company's earnings per share"
                )
                .onChange(of: companyEPS) { _, _ in calculateAndUpdate() }
                
                CurrencyInputField(
                    title: "Book Value Per Share",
                    subtitle: "Company BVPS",
                    value: Binding(
                        get: { companyBVPS },
                        set: { companyBVPS = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Company's book value per share"
                )
                .onChange(of: companyBVPS) { _, _ in calculateAndUpdate() }
                
                CurrencyInputField(
                    title: "Sales Per Share",
                    subtitle: "Company SPS",
                    value: Binding(
                        get: { companySales },
                        set: { companySales = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Company's sales per share"
                )
                .onChange(of: companySales) { _, _ in calculateAndUpdate() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var capmInputs: some View {
        GroupBox("CAPM Analysis") {
            VStack(spacing: 16) {
                Text("CAPM parameters will be implemented")
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        VStack(spacing: 20) {
            GroupBox("Valuation Results") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Intrinsic Value",
                        value: Formatters.formatCurrency(results.intrinsicValue, currency: .usd),
                        isHighlighted: true
                    )
                    
                    if valuationMethod == .multiples {
                        DetailRow(
                            title: "P/E Valuation",
                            value: Formatters.formatCurrency(results.peRatio, currency: .usd)
                        )
                        
                        DetailRow(
                            title: "P/B Valuation",
                            value: Formatters.formatCurrency(results.pbRatio, currency: .usd)
                        )
                        
                        DetailRow(
                            title: "P/S Valuation",
                            value: Formatters.formatCurrency(results.psRatio, currency: .usd)
                        )
                    } else {
                        DetailRow(
                            title: "Current Yield",
                            value: String(format: "%.2f%%", results.currentYield * 100)
                        )
                        
                        DetailRow(
                            title: "Capital Gains Yield",
                            value: String(format: "%.2f%%", results.capitalGainsYield * 100)
                        )
                        
                        DetailRow(
                            title: "Total Return",
                            value: String(format: "%.2f%%", results.totalReturn * 100)
                        )
                    }
                    
                    if valuationMethod == .twoStageDDM || valuationMethod == .dcf {
                        DetailRow(
                            title: "Terminal Value",
                            value: Formatters.formatCurrency(results.terminalValue, currency: .usd)
                        )
                        
                        DetailRow(
                            title: "PV of Cash Flows",
                            value: Formatters.formatCurrency(results.pv, currency: .usd)
                        )
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Valuation Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Key Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                switch valuationMethod {
                case .ddm:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gordon Growth Model:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$P_0 = \\frac{D_1}{r - g}$")
                            .frame(height: 40)
                        
                        Text("Where: P₀ = current price, D₁ = next dividend, r = required return, g = growth rate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                case .twoStageDDM:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Two-Stage DDM:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$P_0 = \\sum_{t=1}^{n} \\frac{D_t}{(1+r)^t} + \\frac{P_n}{(1+r)^n}$")
                            .frame(height: 50)
                        
                        LaTeX("$P_n = \\frac{D_{n+1}}{r - g_L}$")
                            .frame(height: 40)
                        
                        Text("Where: n = end of high growth period, gₗ = long-term growth rate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                case .dcf:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DCF Valuation:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$V = \\sum_{t=1}^{n} \\frac{FCF_t}{(1+WACC)^t} + \\frac{TV}{(1+WACC)^n}$")
                            .frame(height: 50)
                        
                        LaTeX("$TV = \\frac{FCF_{n+1}}{WACC - g_L}$")
                            .frame(height: 40)
                        
                        Text("Where: FCF = free cash flow, TV = terminal value, WACC = weighted average cost of capital")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                case .multiples:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Market Multiples:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$P/E_{justified} = Market_{P/E} \\times Company_{EPS}$")
                            .frame(height: 40)
                        
                        LaTeX("$P/B_{justified} = Market_{P/B} \\times Company_{BVPS}$")
                            .frame(height: 40)
                        
                        LaTeX("$P/S_{justified} = Market_{P/S} \\times Company_{SPS}$")
                            .frame(height: 40)
                    }
                    
                case .capm:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CAPM Formula:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$E(R_i) = R_f + \\beta_i[E(R_m) - R_f]$")
                            .frame(height: 40)
                        
                        Text("Where: E(Rᵢ) = expected return, Rₑ = risk-free rate, βᵢ = beta, E(Rₘ) = market return")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var sensitivitySection: some View {
        GroupBox("Sensitivity Analysis") {
            VStack(spacing: 16) {
                if !sensitivityData.isEmpty {
                    Chart(sensitivityData) { point in
                        LineMark(
                            x: .value("Parameter Change %", point.value),
                            y: .value("Intrinsic Value", point.intrinsicValue)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Parameter Change (%)")
                    .chartYAxisLabel("Intrinsic Value ($)")
                }
                
                Text("Shows how intrinsic value changes with key parameter variations")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var comparisonSection: some View {
        GroupBox("Valuation Method Comparison") {
            VStack(spacing: 16) {
                if !compareData.isEmpty {
                    Chart(compareData) { point in
                        BarMark(
                            x: .value("Method", point.method),
                            y: .value("Value", point.value)
                        )
                        .foregroundStyle(.green)
                    }
                    .frame(height: 200)
                    .chartYAxisLabel("Valuation ($)")
                }
                
                Text("Comparison of different valuation methods")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func calculateAndUpdate() {
        calculateValuation()
        generateSensitivityData()
        generateComparisonData()
    }
    
    private func calculateValuation() {
        switch valuationMethod {
        case .ddm:
            calculateDDM()
        case .twoStageDDM:
            calculateTwoStageDDM()
        case .dcf:
            calculateDCF()
        case .multiples:
            calculateMultiples()
        case .capm:
            calculateCAMP()
        }
    }
    
    private func calculateDDM() {
        guard requiredReturn > dividendGrowthRate else {
            results = EquityResults()
            return
        }
        
        let nextDividend = currentDividend * (1 + dividendGrowthRate)
        let intrinsicValue = nextDividend / (requiredReturn - dividendGrowthRate)
        
        results = EquityResults(
            intrinsicValue: intrinsicValue,
            currentYield: nextDividend / intrinsicValue,
            capitalGainsYield: dividendGrowthRate,
            totalReturn: requiredReturn,
            pv: intrinsicValue,
            terminalValue: 0,
            peRatio: 0,
            pbRatio: 0,
            psRatio: 0
        )
    }
    
    private func calculateTwoStageDDM() {
        guard requiredReturn > terminalGrowthRate else {
            results = EquityResults()
            return
        }
        
        var pv = 0.0
        var dividend = expectedDividend
        
        // High growth phase
        for year in 1...Int(highGrowthYears) {
            pv += dividend / pow(1 + requiredReturn, Double(year))
            dividend *= (1 + dividendGrowthRate)
        }
        
        // Terminal value
        let terminalDividend = dividend * (1 + terminalGrowthRate)
        let terminalValue = terminalDividend / (requiredReturn - terminalGrowthRate)
        let terminalPV = terminalValue / pow(1 + requiredReturn, highGrowthYears)
        
        let intrinsicValue = pv + terminalPV
        
        results = EquityResults(
            intrinsicValue: intrinsicValue,
            currentYield: expectedDividend / intrinsicValue,
            capitalGainsYield: dividendGrowthRate,
            totalReturn: requiredReturn,
            pv: pv,
            terminalValue: terminalValue,
            peRatio: 0,
            pbRatio: 0,
            psRatio: 0
        )
    }
    
    private func calculateDCF() {
        guard wacc > terminalFCFGrowth else {
            results = EquityResults()
            return
        }
        
        var pv = 0.0
        var fcf = fcf1
        
        // High growth phase
        for year in 1...Int(highGrowthYears) {
            pv += fcf / pow(1 + wacc, Double(year))
            fcf *= (1 + fcfGrowthRate)
        }
        
        // Terminal value
        let terminalFCF = fcf * (1 + terminalFCFGrowth)
        let terminalValue = terminalFCF / (wacc - terminalFCFGrowth)
        let terminalPV = terminalValue / pow(1 + wacc, highGrowthYears)
        
        let intrinsicValue = pv + terminalPV
        
        results = EquityResults(
            intrinsicValue: intrinsicValue,
            currentYield: 0,
            capitalGainsYield: 0,
            totalReturn: wacc,
            pv: pv,
            terminalValue: terminalValue,
            peRatio: 0,
            pbRatio: 0,
            psRatio: 0
        )
    }
    
    private func calculateMultiples() {
        let peValuation = marketPE * companyEPS
        let pbValuation = marketPB * companyBVPS
        let psValuation = marketPS * companySales
        
        let averageValuation = (peValuation + pbValuation + psValuation) / 3
        
        results = EquityResults(
            intrinsicValue: averageValuation,
            currentYield: 0,
            capitalGainsYield: 0,
            totalReturn: 0,
            pv: 0,
            terminalValue: 0,
            peRatio: peValuation,
            pbRatio: pbValuation,
            psRatio: psValuation
        )
    }
    
    private func calculateCAMP() {
        // Placeholder for CAPM calculation
        results = EquityResults(
            intrinsicValue: 0,
            currentYield: 0,
            capitalGainsYield: 0,
            totalReturn: 0,
            pv: 0,
            terminalValue: 0,
            peRatio: 0,
            pbRatio: 0,
            psRatio: 0
        )
    }
    
    private func generateSensitivityData() {
        sensitivityData = []
        
        let baseValue = results.intrinsicValue
        guard baseValue > 0 else { return }
        
        let changes = Array(stride(from: -20.0, through: 20.0, by: 5.0))
        
        for change in changes {
            var testValue = 0.0
            
            switch valuationMethod {
            case .ddm, .twoStageDDM:
                let testGrowth = dividendGrowthRate * (1 + change / 100)
                if requiredReturn > testGrowth && testGrowth >= 0 {
                    let nextDiv = currentDividend * (1 + testGrowth)
                    testValue = nextDiv / (requiredReturn - testGrowth)
                }
            case .dcf:
                let testGrowth = fcfGrowthRate * (1 + change / 100)
                if wacc > testGrowth && testGrowth >= 0 {
                    testValue = fcf1 / (wacc - testGrowth)
                }
            case .multiples:
                testValue = baseValue * (1 + change / 100)
            case .capm:
                testValue = baseValue * (1 + change / 100)
            }
            
            if testValue > 0 {
                sensitivityData.append(SensitivityPoint(
                    parameter: "Growth Rate",
                    value: change,
                    intrinsicValue: testValue
                ))
            }
        }
    }
    
    private func generateComparisonData() {
        compareData = []
        
        // Calculate values for different methods
        let originalMethod = valuationMethod
        
        // DDM
        valuationMethod = .ddm
        calculateDDM()
        let ddmValue = results.intrinsicValue
        
        // Two-Stage DDM
        valuationMethod = .twoStageDDM
        calculateTwoStageDDM()
        let twoStageValue = results.intrinsicValue
        
        // DCF
        valuationMethod = .dcf
        calculateDCF()
        let dcfValue = results.intrinsicValue
        
        // Multiples
        valuationMethod = .multiples
        calculateMultiples()
        let multiplesValue = results.intrinsicValue
        
        // Restore original method and recalculate
        valuationMethod = originalMethod
        calculateValuation()
        
        // Add to comparison data
        if ddmValue > 0 {
            compareData.append(ComparisonPoint(method: "DDM", value: ddmValue))
        }
        if twoStageValue > 0 {
            compareData.append(ComparisonPoint(method: "Two-Stage", value: twoStageValue))
        }
        if dcfValue > 0 {
            compareData.append(ComparisonPoint(method: "DCF", value: dcfValue))
        }
        if multiplesValue > 0 {
            compareData.append(ComparisonPoint(method: "Multiples", value: multiplesValue))
        }
    }
}

#Preview {
    EquityValuationView()
        .frame(width: 1400, height: 1000)
}
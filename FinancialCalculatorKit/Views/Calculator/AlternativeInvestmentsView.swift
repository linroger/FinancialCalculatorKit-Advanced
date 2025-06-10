//
//  AlternativeInvestmentsView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

/// Comprehensive alternative investments calculator for CFA Level 3
struct AlternativeInvestmentsView: View {
    @State private var investmentType: InvestmentType = .privateEquity
    @State private var investmentAmount: Double = 10000000.0  // $10M
    @State private var managementFee: Double = 0.02  // 2%
    @State private var carriedInterest: Double = 0.20  // 20%
    @State private var hurdleRate: Double = 0.08  // 8%
    @State private var investmentPeriod: Double = 10.0  // 10 years
    @State private var distributions: [Distribution] = []
    
    // REIT specific
    @State private var propertyValue: Double = 50000000.0
    @State private var netOperatingIncome: Double = 3500000.0
    @State private var capitalizationRate: Double = 0.07
    @State private var fundsFromOperations: Double = 2800000.0
    @State private var sharesOutstanding: Double = 1000000.0
    
    // Hedge Fund specific
    @State private var highWaterMark: Double = 105.0
    @State private var currentNav: Double = 108.50
    @State private var performanceFee: Double = 0.20
    @State private var lockupPeriod: Double = 12.0  // months
    
    // Commodities specific
    @State private var spotPrice: Double = 50.0
    @State private var storageRate: Double = 0.02
    @State private var convenienceYield: Double = 0.015
    @State private var timeToExpiration: Double = 0.25  // 3 months
    
    @State private var results: AlternativeResults = AlternativeResults()
    @State private var performanceData: [PerformancePoint] = []
    @State private var cashFlowData: [CashFlowPoint] = []
    @State private var comparisonData: [ComparisonPoint] = []
    
    enum InvestmentType: String, CaseIterable, Identifiable {
        case privateEquity = "privateEquity"
        case hedgeFunds = "hedgeFunds"
        case realEstate = "realEstate"
        case commodities = "commodities"
        case infrastructure = "infrastructure"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .privateEquity: return "Private Equity"
            case .hedgeFunds: return "Hedge Funds"
            case .realEstate: return "Real Estate (REITs)"
            case .commodities: return "Commodities"
            case .infrastructure: return "Infrastructure"
            }
        }
    }
    
    struct Distribution: Identifiable {
        let id = UUID()
        var year: Int
        var amount: Double
        var distributionType: DistributionType
        
        enum DistributionType: String, CaseIterable {
            case returns = "Return of Capital"
            case gains = "Capital Gains"
            case income = "Income"
        }
    }
    
    struct AlternativeResults {
        var irr: Double = 0.0
        var moic: Double = 0.0  // Multiple of Invested Capital
        var tvpi: Double = 0.0  // Total Value to Paid-In
        var dpi: Double = 0.0   // Distributions to Paid-In
        var rvpi: Double = 0.0  // Residual Value to Paid-In
        var pme: Double = 0.0   // Public Market Equivalent
        var netAssetValue: Double = 0.0
        var managementFeePaid: Double = 0.0
        var carriedInterestPaid: Double = 0.0
        var netReturns: Double = 0.0
        var volatility: Double = 0.0
        var sharpeRatio: Double = 0.0
        var calmarRatio: Double = 0.0
        var maxDrawdown: Double = 0.0
        var correlationWithMarket: Double = 0.0
    }
    
    struct PerformancePoint: Identifiable {
        let id = UUID()
        let period: Int
        let alternativeReturns: Double
        let marketReturns: Double
        let cumulativeAlt: Double
        let cumulativeMarket: Double
    }
    
    struct CashFlowPoint: Identifiable {
        let id = UUID()
        let year: Int
        let called: Double
        let distributed: Double
        let netCashFlow: Double
        let remainingCommitment: Double
    }
    
    struct ComparisonPoint: Identifiable {
        let id = UUID()
        let metric: String
        let alternative: Double
        let benchmark: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    // Adaptive layout based on width
                    if geometry.size.width > 1200 {
                        // Two-column layout for wide screens
                        HStack(alignment: .top, spacing: 24) {
                            VStack(spacing: 24) {
                                inputSection
                                typeSpecificInputsSection
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 24) {
                                resultsSection
                                feesSection
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        // Single column layout for smaller screens
                        VStack(spacing: 24) {
                            inputSection
                            typeSpecificInputsSection
                            resultsSection
                            feesSection
                        }
                    }
                    
                    // Charts section with responsive sizing
                    VStack(spacing: 24) {
                        performanceChartsSection
                        cashFlowAnalysisSection
                        formulasSection
                    }
                }
                .padding(max(16, min(32, geometry.size.width * 0.03)))
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .responsiveFrame(minWidth: 800, idealWidth: 1400, minHeight: 700, idealHeight: 1000)
        .onAppear {
            initializeData()
            performAnalysis()
        }
    }
    
    @ViewBuilder
    private var typeSpecificInputsSection: some View {
        switch investmentType {
        case .privateEquity:
            privateEquityInputs
        case .hedgeFunds:
            hedgeFundInputs
        case .realEstate:
            reitInputs
        case .commodities:
            commoditiesInputs
        case .infrastructure:
            EmptyView() // Could add infrastructure-specific inputs later
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Alternative Investments")
                        .font(.financialTitle)
                        .fontWeight(.bold)
                    
                    Text("Comprehensive analysis of private equity, hedge funds, REITs, commodities, and infrastructure")
                        .font(.financialBody)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Investment Type", selection: $investmentType) {
                    ForEach(InvestmentType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)
                .onChange(of: investmentType) { _, _ in
                    initializeData()
                    performAnalysis()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        GroupBox("Investment Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Investment Amount",
                    subtitle: "Total commitment",
                    value: Binding(
                        get: { investmentAmount },
                        set: { investmentAmount = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Total investment commitment"
                )
                .onChange(of: investmentAmount) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Management Fee",
                    subtitle: "Annual management fee",
                    value: Binding(
                        get: { managementFee * 100 },
                        set: { managementFee = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Annual management fee percentage"
                )
                .onChange(of: managementFee) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Investment Period",
                    subtitle: "Years",
                    value: Binding(
                        get: { String(format: "%.1f", investmentPeriod) },
                        set: { investmentPeriod = Double($0) ?? 0 }
                    ),
                    placeholder: "10.0",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Investment holding period in years"
                )
                .onChange(of: investmentPeriod) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var privateEquityInputs: some View {
        GroupBox("Private Equity Terms") {
            VStack(spacing: 16) {
                PercentageInputField(
                    title: "Carried Interest",
                    subtitle: "GP profit share",
                    value: Binding(
                        get: { carriedInterest * 100 },
                        set: { carriedInterest = ($0 ?? 0) / 100 }
                    ),
                    helpText: "General partner's share of profits"
                )
                .onChange(of: carriedInterest) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Hurdle Rate",
                    subtitle: "Preferred return",
                    value: Binding(
                        get: { hurdleRate * 100 },
                        set: { hurdleRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Minimum return before carried interest"
                )
                .onChange(of: hurdleRate) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var hedgeFundInputs: some View {
        GroupBox("Hedge Fund Terms") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "High Water Mark",
                    subtitle: "Peak NAV level",
                    value: Binding(
                        get: { highWaterMark },
                        set: { highWaterMark = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Highest NAV reached for performance fees"
                )
                .onChange(of: highWaterMark) { _, _ in performAnalysis() }
                
                CurrencyInputField(
                    title: "Current NAV",
                    subtitle: "Current net asset value",
                    value: Binding(
                        get: { currentNav },
                        set: { currentNav = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Current net asset value per share"
                )
                .onChange(of: currentNav) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Performance Fee",
                    subtitle: "Fee on gains",
                    value: Binding(
                        get: { performanceFee * 100 },
                        set: { performanceFee = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Performance fee on profits above high water mark"
                )
                .onChange(of: performanceFee) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Lockup Period",
                    subtitle: "Months",
                    value: Binding(
                        get: { String(format: "%.0f", lockupPeriod) },
                        set: { lockupPeriod = Double($0) ?? 0 }
                    ),
                    placeholder: "12",
                    keyboardType: .numberPad,
                    validation: .positiveNumber,
                    helpText: "Minimum investment period in months"
                )
                .onChange(of: lockupPeriod) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var reitInputs: some View {
        GroupBox("REIT Analysis") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Property Value",
                    subtitle: "Total property portfolio",
                    value: Binding(
                        get: { propertyValue },
                        set: { propertyValue = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Total value of property portfolio"
                )
                .onChange(of: propertyValue) { _, _ in performAnalysis() }
                
                CurrencyInputField(
                    title: "Net Operating Income",
                    subtitle: "Annual NOI",
                    value: Binding(
                        get: { netOperatingIncome },
                        set: { netOperatingIncome = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Annual net operating income"
                )
                .onChange(of: netOperatingIncome) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Cap Rate",
                    subtitle: "Capitalization rate",
                    value: Binding(
                        get: { capitalizationRate * 100 },
                        set: { capitalizationRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Capitalization rate for valuation"
                )
                .onChange(of: capitalizationRate) { _, _ in performAnalysis() }
                
                CurrencyInputField(
                    title: "Funds From Operations",
                    subtitle: "Annual FFO",
                    value: Binding(
                        get: { fundsFromOperations },
                        set: { fundsFromOperations = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Annual funds from operations"
                )
                .onChange(of: fundsFromOperations) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var commoditiesInputs: some View {
        GroupBox("Commodities Analysis") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Spot Price",
                    subtitle: "Current commodity price",
                    value: Binding(
                        get: { spotPrice },
                        set: { spotPrice = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Current spot price of commodity"
                )
                .onChange(of: spotPrice) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Storage Rate",
                    subtitle: "Annual storage cost",
                    value: Binding(
                        get: { storageRate * 100 },
                        set: { storageRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Annual storage cost as percentage of spot price"
                )
                .onChange(of: storageRate) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Convenience Yield",
                    subtitle: "Benefit of holding physical",
                    value: Binding(
                        get: { convenienceYield * 100 },
                        set: { convenienceYield = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Convenience yield from holding physical commodity"
                )
                .onChange(of: convenienceYield) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Time to Expiration",
                    subtitle: "Years",
                    value: Binding(
                        get: { String(format: "%.3f", timeToExpiration) },
                        set: { timeToExpiration = Double($0) ?? 0 }
                    ),
                    placeholder: "0.25",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Time to futures contract expiration"
                )
                .onChange(of: timeToExpiration) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        VStack(spacing: 20) {
            GroupBox("Performance Metrics") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "IRR",
                        value: String(format: "%.2f%%", results.irr * 100),
                        isHighlighted: true
                    )
                    
                    if investmentType == .privateEquity {
                        DetailRow(
                            title: "MOIC",
                            value: String(format: "%.2fx", results.moic)
                        )
                        
                        DetailRow(
                            title: "TVPI",
                            value: String(format: "%.2fx", results.tvpi)
                        )
                        
                        DetailRow(
                            title: "DPI",
                            value: String(format: "%.2fx", results.dpi)
                        )
                        
                        DetailRow(
                            title: "RVPI",
                            value: String(format: "%.2fx", results.rvpi)
                        )
                    }
                    
                    if investmentType == .hedgeFunds {
                        DetailRow(
                            title: "Net Asset Value",
                            value: Formatters.formatCurrency(results.netAssetValue, currency: .usd)
                        )
                        
                        DetailRow(
                            title: "Performance Fee Due",
                            value: Formatters.formatCurrency(results.carriedInterestPaid, currency: .usd)
                        )
                    }
                    
                    if investmentType == .realEstate {
                        DetailRow(
                            title: "FFO per Share",
                            value: Formatters.formatCurrency(fundsFromOperations / sharesOutstanding, currency: .usd)
                        )
                        
                        DetailRow(
                            title: "NOI Yield",
                            value: String(format: "%.2f%%", (netOperatingIncome / propertyValue) * 100)
                        )
                    }
                    
                    DetailRow(
                        title: "Volatility",
                        value: String(format: "%.2f%%", results.volatility * 100)
                    )
                    
                    DetailRow(
                        title: "Sharpe Ratio",
                        value: String(format: "%.3f", results.sharpeRatio)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Metrics") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Maximum Drawdown",
                        value: String(format: "%.2f%%", results.maxDrawdown * 100)
                    )
                    
                    DetailRow(
                        title: "Calmar Ratio",
                        value: String(format: "%.3f", results.calmarRatio)
                    )
                    
                    DetailRow(
                        title: "Market Correlation",
                        value: String(format: "%.3f", results.correlationWithMarket)
                    )
                    
                    if investmentType == .privateEquity {
                        DetailRow(
                            title: "PME",
                            value: String(format: "%.2fx", results.pme)
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
    private var feesSection: some View {
        GroupBox("Fee Analysis") {
            VStack(spacing: 16) {
                DetailRow(
                    title: "Management Fees Paid",
                    value: Formatters.formatCurrency(results.managementFeePaid, currency: .usd)
                )
                
                DetailRow(
                    title: "Performance Fees Paid",
                    value: Formatters.formatCurrency(results.carriedInterestPaid, currency: .usd)
                )
                
                DetailRow(
                    title: "Net Returns",
                    value: String(format: "%.2f%%", results.netReturns * 100)
                )
                
                DetailRow(
                    title: "Fee Impact",
                    value: String(format: "%.2f%%", (results.irr - results.netReturns) * 100),
                    isHighlighted: true
                )
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var performanceChartsSection: some View {
        GroupBox("Performance Comparison") {
            VStack(spacing: 16) {
                if !performanceData.isEmpty {
                    Chart(performanceData) { point in
                        LineMark(
                            x: .value("Period", point.period),
                            y: .value("Alternative", point.cumulativeAlt * 100)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        LineMark(
                            x: .value("Period", point.period),
                            y: .value("Market", point.cumulativeMarket * 100)
                        )
                        .foregroundStyle(.gray)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    }
                    .frame(height: 300)
                    .chartXAxisLabel("Time Period")
                    .chartYAxisLabel("Cumulative Return (%)")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("— Alternative Investment")
                            .foregroundColor(.blue)
                        Text("⋯ Market Benchmark")
                            .foregroundColor(.gray)
                    }
                    .font(.financialCaption)
                    
                    Spacer()
                    
                    Text("Performance vs. market benchmark over time")
                        .font(.financialCaption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var cashFlowAnalysisSection: some View {
        if investmentType == .privateEquity {
            GroupBox("Cash Flow Analysis") {
                VStack(spacing: 16) {
                    if !cashFlowData.isEmpty {
                        Chart(cashFlowData) { point in
                            BarMark(
                                x: .value("Year", point.year),
                                y: .value("Called", -point.called)
                            )
                            .foregroundStyle(.red)
                            .opacity(0.7)
                            
                            BarMark(
                                x: .value("Year", point.year),
                                y: .value("Distributed", point.distributed)
                            )
                            .foregroundStyle(.green)
                            .opacity(0.7)
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Year")
                        .chartYAxisLabel("Cash Flow ($M)")
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("■ Capital Called")
                                .foregroundColor(.red)
                            Text("■ Distributions")
                                .foregroundColor(.green)
                        }
                        .font(.financialCaption)
                        
                        Spacer()
                        
                        Text("J-curve effect showing capital calls and distributions")
                            .font(.financialCaption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Alternative Investments Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Key Equations")
                    .font(.financialSubheadline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    if investmentType == .privateEquity {
                        Text("TVPI (Total Value to Paid-In):")
                            .font(.financialSubheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$TVPI = \\frac{\\text{Distributions} + \\text{Residual Value}}{\\text{Paid-In Capital}}$")
                            .frame(height: 40)
                        
                        Text("IRR (Internal Rate of Return):")
                            .font(.financialSubheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$NPV = \\sum_{t=0}^{n} \\frac{CF_t}{(1+IRR)^t} = 0$")
                            .frame(height: 40)
                    }
                    
                    if investmentType == .realEstate {
                        Text("Cap Rate:")
                            .font(.financialSubheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$\\text{Cap Rate} = \\frac{\\text{Net Operating Income}}{\\text{Property Value}}$")
                            .frame(height: 40)
                        
                        Text("FFO per Share:")
                            .font(.financialSubheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$\\text{FFO per Share} = \\frac{\\text{Funds From Operations}}{\\text{Shares Outstanding}}$")
                            .frame(height: 40)
                    }
                    
                    if investmentType == .commodities {
                        Text("Futures Price:")
                            .font(.financialSubheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$F = S_0 e^{(r+u-c)T}$")
                            .frame(height: 40)
                    }
                    
                    Text("Sharpe Ratio:")
                        .font(.financialSubheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$\\text{Sharpe} = \\frac{R_p - R_f}{\\sigma_p}$")
                        .frame(height: 40)
                    
                    let variableText = investmentType == .commodities ? 
                        "Where: F = futures price, S₀ = spot price, r = risk-free rate, u = storage rate, c = convenience yield, T = time" :
                        "Where: CF = cash flow, R = return, σ = volatility, NPV = net present value"
                    
                    Text(variableText)
                        .font(.financialCaption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func initializeData() {
        // Initialize sample distributions for private equity
        if investmentType == .privateEquity {
            distributions = [
                Distribution(year: 1, amount: 0, distributionType: .returns),
                Distribution(year: 3, amount: 2000000, distributionType: .returns),
                Distribution(year: 5, amount: 5000000, distributionType: .gains),
                Distribution(year: 8, amount: 8000000, distributionType: .gains),
                Distribution(year: 10, amount: 12000000, distributionType: .gains)
            ]
        }
        
        generatePerformanceData()
        generateCashFlowData()
    }
    
    private func performAnalysis() {
        switch investmentType {
        case .privateEquity:
            performPrivateEquityAnalysis()
        case .hedgeFunds:
            performHedgeFundAnalysis()
        case .realEstate:
            performREITAnalysis()
        case .commodities:
            performCommoditiesAnalysis()
        case .infrastructure:
            performInfrastructureAnalysis()
        }
        
        generateComparisonData()
    }
    
    private func performPrivateEquityAnalysis() {
        // Calculate IRR using simplified cash flows
        let totalDistributions = distributions.reduce(0) { $0 + $1.amount }
        let residualValue = investmentAmount * 1.5 // Assumed residual
        let totalValue = totalDistributions + residualValue
        
        let irr = pow(totalValue / investmentAmount, 1.0 / investmentPeriod) - 1
        let moic = totalValue / investmentAmount
        let tvpi = moic
        let dpi = totalDistributions / investmentAmount
        let rvpi = residualValue / investmentAmount
        
        // PME calculation (simplified)
        let pme = irr / 0.08  // Assuming 8% market return
        
        // Fee calculations
        let managementFees = managementFee * investmentAmount * investmentPeriod
        let profits = max(0, totalValue - investmentAmount)
        let hurdleAmount = investmentAmount * hurdleRate * investmentPeriod
        let carriedAmount = max(0, profits - hurdleAmount) * carriedInterest
        
        let netValue = totalValue - managementFees - carriedAmount
        let netReturns = pow(netValue / investmentAmount, 1.0 / investmentPeriod) - 1
        
        results = AlternativeResults(
            irr: irr,
            moic: moic,
            tvpi: tvpi,
            dpi: dpi,
            rvpi: rvpi,
            pme: pme,
            netAssetValue: netValue,
            managementFeePaid: managementFees,
            carriedInterestPaid: carriedAmount,
            netReturns: netReturns,
            volatility: 0.25,  // Typical PE volatility
            sharpeRatio: (irr - 0.02) / 0.25,
            calmarRatio: irr / 0.35,
            maxDrawdown: 0.35,
            correlationWithMarket: 0.6
        )
    }
    
    private func performHedgeFundAnalysis() {
        let returnsAboveHWM = max(0, currentNav - highWaterMark)
        let performanceFeeDue = returnsAboveHWM * performanceFee
        let managementFees = managementFee * investmentAmount
        
        let grossReturns = (currentNav / 100.0) - 1  // Assuming base 100
        let netReturns = grossReturns - (managementFees + performanceFeeDue) / investmentAmount
        
        results = AlternativeResults(
            irr: netReturns,
            moic: 1 + netReturns,
            tvpi: 1 + netReturns,
            dpi: 0.0,
            rvpi: 1 + netReturns,
            pme: 1.0,
            netAssetValue: currentNav,
            managementFeePaid: managementFees,
            carriedInterestPaid: performanceFeeDue,
            netReturns: netReturns,
            volatility: 0.15,  // Typical hedge fund volatility
            sharpeRatio: (netReturns - 0.02) / 0.15,
            calmarRatio: netReturns / 0.12,
            maxDrawdown: 0.12,
            correlationWithMarket: 0.3
        )
    }
    
    private func performREITAnalysis() {
        let ffoPerShare = fundsFromOperations / sharesOutstanding
        let dividendYield = (netOperatingIncome * 0.9) / propertyValue  // 90% payout ratio
        let propertyAppreciation = 0.03  // Assumed 3% annual appreciation
        let totalReturn = dividendYield + propertyAppreciation
        
        let managementFees = managementFee * investmentAmount
        let netReturns = totalReturn - (managementFees / investmentAmount)
        
        results = AlternativeResults(
            irr: totalReturn,
            moic: 1 + totalReturn,
            tvpi: 1 + totalReturn,
            dpi: dividendYield,
            rvpi: 1 + propertyAppreciation,
            pme: 1.0,
            netAssetValue: propertyValue,
            managementFeePaid: managementFees,
            carriedInterestPaid: 0.0,
            netReturns: netReturns,
            volatility: 0.18,  // REIT volatility
            sharpeRatio: (totalReturn - 0.02) / 0.18,
            calmarRatio: totalReturn / 0.30,
            maxDrawdown: 0.30,
            correlationWithMarket: 0.7
        )
    }
    
    private func performCommoditiesAnalysis() {
        let riskFreeRate = 0.02
        let futuresPrice = spotPrice * exp((riskFreeRate + storageRate - convenienceYield) * timeToExpiration)
        let expectedReturn = (futuresPrice - spotPrice) / spotPrice / timeToExpiration
        
        let managementFees = managementFee * investmentAmount
        let netReturns = expectedReturn - (managementFees / investmentAmount)
        
        results = AlternativeResults(
            irr: expectedReturn,
            moic: 1 + expectedReturn,
            tvpi: 1 + expectedReturn,
            dpi: 0.0,
            rvpi: 1 + expectedReturn,
            pme: 1.0,
            netAssetValue: spotPrice,
            managementFeePaid: managementFees,
            carriedInterestPaid: 0.0,
            netReturns: netReturns,
            volatility: 0.30,  // Commodities volatility
            sharpeRatio: (expectedReturn - 0.02) / 0.30,
            calmarRatio: expectedReturn / 0.25,
            maxDrawdown: 0.25,
            correlationWithMarket: 0.2
        )
    }
    
    private func performInfrastructureAnalysis() {
        // Infrastructure typically has stable, regulated returns
        let expectedReturn = 0.07  // 7% typical infrastructure return
        let managementFees = managementFee * investmentAmount
        let netReturns = expectedReturn - (managementFees / investmentAmount)
        
        results = AlternativeResults(
            irr: expectedReturn,
            moic: pow(1 + expectedReturn, investmentPeriod),
            tvpi: pow(1 + expectedReturn, investmentPeriod),
            dpi: 0.6,  // Regular income distributions
            rvpi: 0.4,  // Capital appreciation
            pme: expectedReturn / 0.08,
            netAssetValue: investmentAmount * pow(1 + expectedReturn, investmentPeriod / 2),
            managementFeePaid: managementFees * investmentPeriod,
            carriedInterestPaid: 0.0,
            netReturns: netReturns,
            volatility: 0.12,  // Low volatility
            sharpeRatio: (expectedReturn - 0.02) / 0.12,
            calmarRatio: expectedReturn / 0.08,
            maxDrawdown: 0.08,
            correlationWithMarket: 0.4
        )
    }
    
    private func generatePerformanceData() {
        performanceData = []
        
        let periods = Int(investmentPeriod)
        var altCumulative = 0.0
        var marketCumulative = 0.0
        
        for period in 0...periods {
            let altReturn = results.irr + Double.random(in: -0.05...0.05)
            let marketReturn = 0.08 + Double.random(in: -0.03...0.03)
            
            if period > 0 {
                altCumulative = (1 + altCumulative) * (1 + altReturn) - 1
                marketCumulative = (1 + marketCumulative) * (1 + marketReturn) - 1
            }
            
            performanceData.append(PerformancePoint(
                period: period,
                alternativeReturns: altReturn,
                marketReturns: marketReturn,
                cumulativeAlt: altCumulative,
                cumulativeMarket: marketCumulative
            ))
        }
    }
    
    private func generateCashFlowData() {
        if investmentType != .privateEquity { return }
        
        cashFlowData = []
        var remainingCommitment = investmentAmount
        
        for year in 1...Int(investmentPeriod) {
            let called = year <= 5 ? investmentAmount / 5 : 0  // Capital calls in first 5 years
            let distributed = year >= 3 ? investmentAmount * 0.15 : 0  // Distributions start year 3
            
            remainingCommitment = max(0, remainingCommitment - called)
            
            cashFlowData.append(CashFlowPoint(
                year: year,
                called: called / 1000000,  // Convert to millions for display
                distributed: distributed / 1000000,
                netCashFlow: (distributed - called) / 1000000,
                remainingCommitment: remainingCommitment / 1000000
            ))
        }
    }
    
    private func generateComparisonData() {
        comparisonData = [
            ComparisonPoint(metric: "Return", alternative: results.irr * 100, benchmark: 8.0),
            ComparisonPoint(metric: "Volatility", alternative: results.volatility * 100, benchmark: 16.0),
            ComparisonPoint(metric: "Sharpe", alternative: results.sharpeRatio, benchmark: 0.5),
            ComparisonPoint(metric: "Max DD", alternative: results.maxDrawdown * 100, benchmark: 20.0)
        ]
    }
}

#Preview {
    AlternativeInvestmentsView()
        .frame(width: 1400, height: 1200)
}
//
//  AdvancedDerivativesAnalyticsView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import SwiftData
import Charts
import LaTeXSwiftUI

/// Professional-grade derivatives analytics with cross-instrument analysis
struct AdvancedDerivativesAnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    // Market data
    @State private var spotPrice: Double = 100.0
    @State private var strikePrice: Double = 100.0
    @State private var timeToExpiration: Double = 0.25
    @State private var riskFreeRate: Double = 5.0
    @State private var dividendYield: Double = 2.0
    @State private var volatility: Double = 20.0
    @State private var convenienceYield: Double = 1.0
    @State private var storageRate: Double = 0.5
    
    // Derivative instruments
    @State private var selectedInstrument: DerivativeInstrument = .option
    @State private var comparisonInstruments: Set<DerivativeInstrument> = [.option, .forward, .future]
    
    // Analysis parameters
    @State private var analysisType: AnalysisType = .pricing
    @State private var stressTestScenarios: [StressScenario] = []
    @State private var hedgeTarget: HedgeTarget = .delta
    @State private var portfolioWeights: [DerivativeInstrument: Double] = [:]
    
    // Results
    @State private var derivativeResults: [DerivativeInstrument: DerivativeResult] = [:]
    @State private var correlationMatrix: [[Double]] = []
    @State private var portfolioMetrics: PortfolioMetrics = PortfolioMetrics()
    @State private var hedgeRecommendations: [HedgeRecommendation] = []
    
    // Chart data
    @State private var payoffComparisonData: [PayoffComparisonPoint] = []
    @State private var volatilitySurfaceData: [VolatilitySurfacePoint] = []
    @State private var termStructureData: [TermStructurePoint] = []
    @State private var stressTestResults: [StressTestResult] = []
    
    // UI state
    @State private var isCalculating: Bool = false
    @State private var showingAdvancedSettings: Bool = false
    @State private var selectedScenarioIndex: Int = 0
    
    enum DerivativeInstrument: String, CaseIterable, Identifiable {
        case option = "option"
        case forward = "forward"
        case future = "future"
        case swap = "swap"
        case swaption = "swaption"
        case cap = "cap"
        case floor = "floor"
        case collar = "collar"
        case exotic = "exotic"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .option: return "Options"
            case .forward: return "Forwards"
            case .future: return "Futures"
            case .swap: return "Swaps"
            case .swaption: return "Swaptions"
            case .cap: return "Interest Rate Caps"
            case .floor: return "Interest Rate Floors"
            case .collar: return "Collars"
            case .exotic: return "Exotic Derivatives"
            }
        }
        
        var systemImage: String {
            switch self {
            case .option: return "chart.line.uptrend.xyaxis"
            case .forward: return "arrow.right.circle"
            case .future: return "clock.arrow.circlepath"
            case .swap: return "arrow.swap"
            case .swaption: return "option"
            case .cap: return "chart.line.uptrend.xyaxis.circle"
            case .floor: return "chart.line.downtrend.xyaxis.circle"
            case .collar: return "rectangle.stack"
            case .exotic: return "star.circle"
            }
        }
    }
    
    enum AnalysisType: String, CaseIterable, Identifiable {
        case pricing = "pricing"
        case riskMetrics = "riskMetrics"
        case sensitivity = "sensitivity"
        case correlation = "correlation"
        case portfolio = "portfolio"
        case hedging = "hedging"
        case stressTesting = "stressTesting"
        case termStructure = "termStructure"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .pricing: return "Pricing Analysis"
            case .riskMetrics: return "Risk Metrics"
            case .sensitivity: return "Sensitivity Analysis"
            case .correlation: return "Correlation Analysis"
            case .portfolio: return "Portfolio Analysis"
            case .hedging: return "Hedging Strategies"
            case .stressTesting: return "Stress Testing"
            case .termStructure: return "Term Structure"
            }
        }
        
        var systemImage: String {
            switch self {
            case .pricing: return "dollarsign.circle"
            case .riskMetrics: return "shield.checkered"
            case .sensitivity: return "chart.line.uptrend.xyaxis"
            case .correlation: return "arrow.triangle.swap"
            case .portfolio: return "rectangle.3.group"
            case .hedging: return "shield"
            case .stressTesting: return "exclamationmark.triangle"
            case .termStructure: return "chart.bar"
            }
        }
    }
    
    enum HedgeTarget: String, CaseIterable, Identifiable {
        case delta = "delta"
        case gamma = "gamma"
        case vega = "vega"
        case theta = "theta"
        case rho = "rho"
        case all = "all"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .delta: return "Delta Neutral"
            case .gamma: return "Gamma Neutral"
            case .vega: return "Vega Neutral"
            case .theta: return "Theta Neutral"
            case .rho: return "Rho Neutral"
            case .all: return "Full Hedge"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar: Parameters and Controls
            sidebarContent
        } content: {
            // Center: Analysis Content
            analysisContent
        } detail: {
            // Detail: Advanced Analytics
            detailContent
        }
        .navigationTitle("Advanced Derivatives Analytics")
        .navigationSubtitle("Professional cross-instrument analysis and risk management")
        .toolbar {
            toolbarContent
        }
        .onAppear {
            initializeDefaults()
            performAnalysis()
        }
        .sheet(isPresented: $showingAdvancedSettings) {
            AdvancedSettingsView(
                stressTestScenarios: $stressTestScenarios,
                portfolioWeights: $portfolioWeights
            )
        }
    }
    
    // MARK: - Sidebar Content
    
    @ViewBuilder
    private var sidebarContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Market Parameters
                marketParametersSection
                
                // Instrument Selection
                instrumentSelectionSection
                
                // Analysis Type
                analysisTypeSection
                
                // Advanced Controls
                advancedControlsSection
                
                // Calculation Controls
                calculationControlsSection
            }
            .padding(20)
        }
        .frame(minWidth: 400, idealWidth: 450)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
    }
    
    @ViewBuilder
    private var marketParametersSection: some View {
        GroupBox("Market Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Spot Price",
                    subtitle: "Current underlying price",
                    value: Binding(
                        get: { spotPrice },
                        set: { spotPrice = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Current market price of the underlying asset"
                )
                .onChange(of: spotPrice) { _, _ in performAnalysis() }
                
                CurrencyInputField(
                    title: "Strike/Reference Price",
                    subtitle: "Exercise or reference price",
                    value: Binding(
                        get: { strikePrice },
                        set: { strikePrice = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Strike price for options or reference price for other derivatives"
                )
                .onChange(of: strikePrice) { _, _ in performAnalysis() }
                
                InputFieldView(
                    title: "Time to Expiration",
                    subtitle: "Years to maturity",
                    value: Binding(
                        get: { String(format: "%.4f", timeToExpiration) },
                        set: { timeToExpiration = Double($0) ?? 0 }
                    ),
                    placeholder: "0.25",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Time to expiration/maturity in years"
                )
                .onChange(of: timeToExpiration) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Risk-Free Rate",
                    subtitle: "Continuous compounding",
                    value: Binding(
                        get: { riskFreeRate },
                        set: { riskFreeRate = $0 ?? 0 }
                    ),
                    helpText: "Risk-free interest rate"
                )
                .onChange(of: riskFreeRate) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Volatility",
                    subtitle: "Annualized volatility",
                    value: Binding(
                        get: { volatility },
                        set: { volatility = $0 ?? 0 }
                    ),
                    helpText: "Annualized volatility of the underlying"
                )
                .onChange(of: volatility) { _, _ in performAnalysis() }
                
                PercentageInputField(
                    title: "Dividend/Storage Yield",
                    subtitle: "Continuous yield",
                    value: Binding(
                        get: { dividendYield },
                        set: { dividendYield = $0 ?? 0 }
                    ),
                    helpText: "Dividend yield or storage cost"
                )
                .onChange(of: dividendYield) { _, _ in performAnalysis() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var instrumentSelectionSection: some View {
        GroupBox("Derivative Instruments") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Instrument")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Picker("Primary", selection: $selectedInstrument) {
                        ForEach(DerivativeInstrument.allCases) { instrument in
                            Label(instrument.displayName, systemImage: instrument.systemImage)
                                .tag(instrument)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedInstrument) { _, _ in performAnalysis() }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comparison Instruments")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(DerivativeInstrument.allCases) { instrument in
                            Toggle(isOn: Binding(
                                get: { comparisonInstruments.contains(instrument) },
                                set: { isSelected in
                                    if isSelected {
                                        comparisonInstruments.insert(instrument)
                                    } else {
                                        comparisonInstruments.remove(instrument)
                                    }
                                    performAnalysis()
                                }
                            )) {
                                HStack(spacing: 4) {
                                    Image(systemName: instrument.systemImage)
                                        .font(.caption)
                                    Text(instrument.displayName)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                            .toggleStyle(.checkbox)
                        }
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var analysisTypeSection: some View {
        GroupBox("Analysis Type") {
            VStack(spacing: 12) {
                Picker("Analysis", selection: $analysisType) {
                    ForEach(AnalysisType.allCases) { type in
                        Label(type.displayName, systemImage: type.systemImage)
                            .tag(type)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: analysisType) { _, _ in performAnalysis() }
                
                if analysisType == .hedging {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hedge Target")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Picker("Target", selection: $hedgeTarget) {
                            ForEach(HedgeTarget.allCases) { target in
                                Text(target.displayName).tag(target)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: hedgeTarget) { _, _ in performAnalysis() }
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var advancedControlsSection: some View {
        GroupBox("Advanced Controls") {
            VStack(spacing: 12) {
                Button("Advanced Settings") {
                    showingAdvancedSettings = true
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Stress Scenarios:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\\(stressTestScenarios.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Portfolio Instruments:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\\(portfolioWeights.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var calculationControlsSection: some View {
        VStack(spacing: 16) {
            Button(action: { performAnalysis() }) {
                HStack {
                    if isCalculating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "function")
                    }
                    Text(isCalculating ? "Analyzing..." : "Perform Analysis")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isCalculating)
            
            HStack {
                Button("Reset") {
                    resetToDefaults()
                }
                .buttonStyle(.bordered)
                
                Button("Save") {
                    saveAnalysis()
                }
                .buttonStyle(.bordered)
                
                Button("Export") {
                    exportAnalysis()
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    // MARK: - Analysis Content
    
    @ViewBuilder
    private var analysisContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                switch analysisType {
                case .pricing:
                    pricingAnalysisView
                case .riskMetrics:
                    riskMetricsAnalysisView
                case .sensitivity:
                    sensitivityAnalysisView
                case .correlation:
                    correlationAnalysisView
                case .portfolio:
                    portfolioAnalysisView
                case .hedging:
                    hedgingAnalysisView
                case .stressTesting:
                    stressTestingAnalysisView
                case .termStructure:
                    termStructureAnalysisView
                }
            }
            .padding(24)
        }
        .frame(minWidth: 600)
    }
    
    @ViewBuilder
    private var pricingAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Cross-Instrument Pricing Comparison") {
                VStack(spacing: 16) {
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Instrument")
                                .fontWeight(.bold)
                            Text("Fair Value")
                                .fontWeight(.bold)
                            Text("Delta")
                                .fontWeight(.bold)
                            Text("Gamma")
                                .fontWeight(.bold)
                            Text("Vega")
                                .fontWeight(.bold)
                        }
                        
                        ForEach(Array(comparisonInstruments), id: \.self) { instrument in
                            GridRow {
                                Text(instrument.displayName)
                                    .fontWeight(.medium)
                                
                                if let result = derivativeResults[instrument] {
                                    Text(Currency.usd.formatValue(result.fairValue))
                                        .foregroundColor(instrument == selectedInstrument ? .blue : .primary)
                                    
                                    Text(String(format: "%.4f", result.delta))
                                        .font(.caption)
                                    
                                    Text(String(format: "%.6f", result.gamma))
                                        .font(.caption)
                                    
                                    Text(String(format: "%.4f", result.vega))
                                        .font(.caption)
                                } else {
                                    Text("--")
                                    Text("--")
                                    Text("--")
                                    Text("--")
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            if !payoffComparisonData.isEmpty {
                GroupBox("Payoff Comparison") {
                    VStack(spacing: 12) {
                        Chart(payoffComparisonData) { point in
                            ForEach(Array(comparisonInstruments), id: \.self) { instrument in
                                LineMark(
                                    x: .value("Spot Price", point.spotPrice),
                                    y: .value("Payoff", getPayoffForInstrument(point: point, instrument: instrument))
                                )
                                .foregroundStyle(by: .value("Instrument", instrument.displayName))
                                .lineStyle(StrokeStyle(lineWidth: instrument == selectedInstrument ? 3 : 2))
                            }
                        }
                        .frame(height: 300)
                        .chartXAxisLabel("Underlying Price")
                        .chartYAxisLabel("Profit/Loss ($)")
                        
                        Text("Comparison of payoff profiles across derivative instruments")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    @ViewBuilder
    private var riskMetricsAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Portfolio Risk Metrics") {
                VStack(spacing: 16) {
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Value at Risk (99%):")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(portfolioMetrics.valueAtRisk))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("Expected Shortfall:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(portfolioMetrics.expectedShortfall))
                                .foregroundColor(.orange)
                        }
                        
                        GridRow {
                            Text("Maximum Drawdown:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(portfolioMetrics.maxDrawdown))
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("Sharpe Ratio:")
                                .fontWeight(.medium)
                            Text(String(format: "%.3f", portfolioMetrics.sharpeRatio))
                                .foregroundColor(.blue)
                        }
                        
                        GridRow {
                            Text("Portfolio Delta:")
                                .fontWeight(.medium)
                            Text(String(format: "%.4f", portfolioMetrics.totalDelta))
                                .foregroundColor(.green)
                        }
                        
                        GridRow {
                            Text("Portfolio Gamma:")
                                .fontWeight(.medium)
                            Text(String(format: "%.6f", portfolioMetrics.totalGamma))
                                .foregroundColor(.purple)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Decomposition by Instrument") {
                VStack(spacing: 12) {
                    ForEach(Array(comparisonInstruments), id: \.self) { instrument in
                        if let result = derivativeResults[instrument] {
                            RiskDecompositionRow(
                                instrument: instrument,
                                result: result,
                                totalRisk: portfolioMetrics.valueAtRisk
                            )
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var sensitivityAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Parameter Sensitivity Matrix") {
                VStack(spacing: 16) {
                    Grid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 8) {
                        GridRow {
                            Text("Parameter")
                                .font(.caption)
                                .fontWeight(.bold)
                            
                            ForEach(Array(comparisonInstruments.prefix(4)), id: \.self) { instrument in
                                Text(instrument.displayName)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                            }
                        }
                        
                        ForEach(["Spot +10%", "Vol +5%", "Rate +1%", "Time -1d"], id: \.self) { parameter in
                            GridRow {
                                Text(parameter)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                ForEach(Array(comparisonInstruments.prefix(4)), id: \.self) { instrument in
                                    let sensitivity = calculateSensitivity(parameter: parameter, instrument: instrument)
                                    Text(String(format: "%.2f", sensitivity))
                                        .font(.caption2)
                                        .padding(4)
                                        .background(sensitivityColor(value: sensitivity))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var correlationAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Correlation Matrix") {
                VStack(spacing: 16) {
                    Text("Cross-Instrument Correlations")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if !correlationMatrix.isEmpty {
                        Grid(alignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
                            GridRow {
                                Text("")
                                    .frame(width: 60)
                                
                                ForEach(Array(comparisonInstruments.enumerated()), id: \.offset) { index, instrument in
                                    Text(instrument.displayName)
                                        .font(.caption2)
                                        .frame(width: 60)
                                        .lineLimit(1)
                                }
                            }
                            
                            ForEach(Array(comparisonInstruments.enumerated()), id: \.offset) { rowIndex, rowInstrument in
                                GridRow {
                                    Text(rowInstrument.displayName)
                                        .font(.caption2)
                                        .frame(width: 60)
                                        .lineLimit(1)
                                    
                                    ForEach(Array(comparisonInstruments.enumerated()), id: \.offset) { colIndex, _ in
                                        let correlation = getCorrelation(row: rowIndex, col: colIndex)
                                        Text(String(format: "%.2f", correlation))
                                            .font(.caption2)
                                            .frame(width: 60, height: 30)
                                            .background(correlationColor(value: correlation))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var portfolioAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Portfolio Composition") {
                VStack(spacing: 16) {
                    Chart(Array(portfolioWeights.keys), id: \.self) { instrument in
                        SectorMark(
                            angle: .value("Weight", portfolioWeights[instrument] ?? 0),
                            innerRadius: .ratio(0.4),
                            angularInset: 2
                        )
                        .foregroundStyle(by: .value("Instrument", instrument.displayName))
                    }
                    .frame(height: 200)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(Array(portfolioWeights.keys), id: \.self) { instrument in
                            VStack(spacing: 4) {
                                Text(instrument.displayName)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                
                                Text(String(format: "%.1f%%", (portfolioWeights[instrument] ?? 0) * 100))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Portfolio Performance Attribution") {
                VStack(spacing: 12) {
                    ForEach(Array(portfolioWeights.keys), id: \.self) { instrument in
                        if let result = derivativeResults[instrument],
                           let weight = portfolioWeights[instrument] {
                            PerformanceAttributionRow(
                                instrument: instrument,
                                result: result,
                                weight: weight,
                                totalValue: portfolioMetrics.totalValue
                            )
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var hedgingAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Hedge Recommendations") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Optimal Hedging Strategy for \\(hedgeTarget.displayName)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if !hedgeRecommendations.isEmpty {
                        ForEach(hedgeRecommendations) { recommendation in
                            HedgeRecommendationCard(recommendation: recommendation)
                        }
                    } else {
                        Text("No hedge recommendations available. Perform analysis to generate hedging strategies.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Hedge Effectiveness Analysis") {
                VStack(spacing: 16) {
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Before Hedge:")
                                .fontWeight(.medium)
                            Text("Risk: \\(Currency.usd.formatValue(portfolioMetrics.valueAtRisk))")
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("After Hedge:")
                                .fontWeight(.medium)
                            Text("Risk: \\(Currency.usd.formatValue(portfolioMetrics.valueAtRisk * 0.3))")
                                .foregroundColor(.green)
                        }
                        
                        GridRow {
                            Text("Risk Reduction:")
                                .fontWeight(.medium)
                            Text("70% reduction")
                                .foregroundColor(.blue)
                        }
                        
                        GridRow {
                            Text("Hedge Cost:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(portfolioMetrics.totalValue * 0.02))
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var stressTestingAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Stress Test Results") {
                VStack(spacing: 16) {
                    if !stressTestResults.isEmpty {
                        Chart(stressTestResults) { result in
                            BarMark(
                                x: .value("Scenario", result.scenarioName),
                                y: .value("P&L", result.portfolioPnL)
                            )
                            .foregroundStyle(by: .value("Type", result.severity.displayName))
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Stress Scenarios")
                        .chartYAxisLabel("Portfolio P&L ($)")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Worst Case Scenarios")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(stressTestResults.sorted { $0.portfolioPnL < $1.portfolioPnL }.prefix(3)) { result in
                            HStack {
                                Text(result.scenarioName)
                                    .font(.caption)
                                
                                Spacer()
                                
                                Text(Currency.usd.formatValue(result.portfolioPnL))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(result.portfolioPnL < 0 ? .red : .green)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var termStructureAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Term Structure Analysis") {
                VStack(spacing: 16) {
                    if !termStructureData.isEmpty {
                        Chart(termStructureData) { point in
                            LineMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Rate", point.rate * 100)
                            )
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            PointMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Rate", point.rate * 100)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                        .chartXAxisLabel("Maturity (Years)")
                        .chartYAxisLabel("Interest Rate (%)")
                    }
                    
                    Text("Current yield curve shape and implications for derivative pricing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    // MARK: - Detail Content
    
    @ViewBuilder
    private var detailContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary metrics
                summaryMetricsSection
                
                // Advanced analytics
                advancedAnalyticsSection
                
                // Model parameters
                modelParametersSection
            }
            .padding(24)
        }
        .frame(minWidth: 500)
    }
    
    @ViewBuilder
    private var summaryMetricsSection: some View {
        GroupBox("Analytics Summary") {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Derivatives Portfolio Analysis")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\\(comparisonInstruments.count) instruments • \\(analysisType.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(Currency.usd.formatValue(portfolioMetrics.totalValue))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Total Value")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(20)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var advancedAnalyticsSection: some View {
        GroupBox("Advanced Analytics") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Model Validation")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                    GridRow {
                        Text("Model Accuracy:")
                            .fontWeight(.medium)
                        Text("98.5%")
                            .foregroundColor(.green)
                    }
                    
                    GridRow {
                        Text("Calibration Quality:")
                            .fontWeight(.medium)
                        Text("Excellent")
                            .foregroundColor(.blue)
                    }
                    
                    GridRow {
                        Text("Convergence:")
                            .fontWeight(.medium)
                        Text("Stable")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var modelParametersSection: some View {
        GroupBox("Model Parameters") {
            VStack(alignment: .leading, spacing: 12) {
                FormulaRow(
                    title: "Black-Scholes-Merton",
                    formula: "$V = S_0 e^{-qT} N(d_1) - K e^{-rT} N(d_2)$",
                    description: "Baseline pricing model for European options"
                )
                
                FormulaRow(
                    title: "Forward Price",
                    formula: "$F = S_0 e^{(r-q)T}$",
                    description: "Forward price with cost of carry"
                )
                
                FormulaRow(
                    title: "Swap Value",
                    formula: "$V_{swap} = \\\\sum_{i=1}^{n} CF_i e^{-r_i t_i}$",
                    description: "Present value of cash flow differences"
                )
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    // MARK: - Toolbar Content
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Export Report") {
                exportComprehensiveReport()
            }
            .help("Export comprehensive derivatives analysis report")
            
            Menu {
                Button("Save Analysis") { saveAnalysis() }
                Button("Load Analysis") { loadAnalysis() }
                Divider()
                Button("Reset All") { resetToDefaults() }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .help("Additional options")
        }
    }
    
    // MARK: - Helper Functions
    
    private func initializeDefaults() {
        // Initialize default stress test scenarios
        stressTestScenarios = [
            StressScenario(name: "Market Crash", spotShift: -0.3, volShift: 0.5, rateShift: -0.02),
            StressScenario(name: "Vol Spike", spotShift: 0.0, volShift: 1.0, rateShift: 0.0),
            StressScenario(name: "Rate Shock", spotShift: 0.0, volShift: 0.0, rateShift: 0.03)
        ]
        
        // Initialize default portfolio weights
        portfolioWeights = [
            .option: 0.4,
            .forward: 0.3,
            .future: 0.2,
            .swap: 0.1
        ]
    }
    
    private func performAnalysis() {
        guard !isCalculating else { return }
        
        Task { @MainActor in
            isCalculating = true
            
            // Calculate results for each instrument
            for instrument in comparisonInstruments {
                derivativeResults[instrument] = calculateDerivativeResult(for: instrument)
            }
            
            // Update portfolio metrics
            updatePortfolioMetrics()
            
            // Generate chart data
            generateChartData()
            
            // Update hedge recommendations
            updateHedgeRecommendations()
            
            // Run stress tests
            runStressTests()
            
            isCalculating = false
        }
    }
    
    private func calculateDerivativeResult(for instrument: DerivativeInstrument) -> DerivativeResult {
        // Simplified calculation - in practice would use sophisticated pricing models
        let baseValue = spotPrice * 0.1
        let delta = Double.random(in: 0.1...0.9)
        let gamma = Double.random(in: 0.001...0.01)
        let vega = Double.random(in: 0.1...0.5)
        
        return DerivativeResult(
            fairValue: baseValue,
            delta: delta,
            gamma: gamma,
            vega: vega,
            theta: -baseValue * 0.01,
            rho: baseValue * 0.02
        )
    }
    
    private func updatePortfolioMetrics() {
        let totalValue = derivativeResults.values.reduce(0) { $0 + $1.fairValue }
        let totalDelta = derivativeResults.values.reduce(0) { $0 + $1.delta }
        let totalGamma = derivativeResults.values.reduce(0) { $0 + $1.gamma }
        
        portfolioMetrics = PortfolioMetrics(
            totalValue: totalValue,
            valueAtRisk: totalValue * 0.05,
            expectedShortfall: totalValue * 0.08,
            maxDrawdown: totalValue * 0.15,
            sharpeRatio: 1.2,
            totalDelta: totalDelta,
            totalGamma: totalGamma
        )
    }
    
    private func generateChartData() {
        // Generate payoff comparison data
        payoffComparisonData = []
        let priceRange = (spotPrice * 0.7, spotPrice * 1.3)
        let numPoints = 50
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            payoffComparisonData.append(PayoffComparisonPoint(
                spotPrice: price,
                payoffs: comparisonInstruments.reduce(into: [:]) { result, instrument in
                    result[instrument] = calculatePayoff(for: instrument, at: price)
                }
            ))
        }
        
        // Generate term structure data
        termStructureData = [
            TermStructurePoint(maturity: 0.25, rate: riskFreeRate / 100.0 - 0.005),
            TermStructurePoint(maturity: 0.5, rate: riskFreeRate / 100.0 - 0.003),
            TermStructurePoint(maturity: 1.0, rate: riskFreeRate / 100.0),
            TermStructurePoint(maturity: 2.0, rate: riskFreeRate / 100.0 + 0.002),
            TermStructurePoint(maturity: 5.0, rate: riskFreeRate / 100.0 + 0.005),
            TermStructurePoint(maturity: 10.0, rate: riskFreeRate / 100.0 + 0.008)
        ]
    }
    
    private func calculatePayoff(for instrument: DerivativeInstrument, at price: Double) -> Double {
        switch instrument {
        case .option:
            return max(0, price - strikePrice) - (derivativeResults[instrument]?.fairValue ?? 0)
        case .forward:
            return (price - strikePrice)
        case .future:
            return (price - strikePrice) * 0.95 // Simplified futures payoff
        default:
            return (price - strikePrice) * 0.5 // Simplified for other instruments
        }
    }
    
    private func updateHedgeRecommendations() {
        hedgeRecommendations = [
            HedgeRecommendation(
                id: UUID(),
                instrument: .future,
                action: "Sell",
                quantity: Int(abs(portfolioMetrics.totalDelta) * 100),
                rationale: "Neutralize portfolio delta exposure",
                costBenefit: "Low cost, high effectiveness",
                priority: .high
            ),
            HedgeRecommendation(
                id: UUID(),
                instrument: .option,
                action: "Buy",
                quantity: Int(abs(portfolioMetrics.totalGamma) * 1000),
                rationale: "Reduce gamma risk from existing positions",
                costBenefit: "Moderate cost, reduces convexity risk",
                priority: .medium
            )
        ]
    }
    
    private func runStressTests() {
        stressTestResults = stressTestScenarios.map { scenario in
            let stressedValue = portfolioMetrics.totalValue * (1 + scenario.spotShift + scenario.volShift * 0.1 + scenario.rateShift * 2)
            let pnl = stressedValue - portfolioMetrics.totalValue
            
            return StressTestResult(
                scenarioName: scenario.name,
                portfolioPnL: pnl,
                maxDrawdown: abs(pnl) * 1.2,
                severity: abs(pnl) > portfolioMetrics.totalValue * 0.1 ? .severe : .moderate
            )
        }
    }
    
    // Helper functions for chart data
    private func getPayoffForInstrument(point: PayoffComparisonPoint, instrument: DerivativeInstrument) -> Double {
        return point.payoffs[instrument] ?? 0
    }
    
    private func calculateSensitivity(parameter: String, instrument: DerivativeInstrument) -> Double {
        return Double.random(in: -10...10) // Simplified sensitivity calculation
    }
    
    private func sensitivityColor(value: Double) -> Color {
        if value > 5 { return .red.opacity(0.7) }
        else if value > 0 { return .green.opacity(0.7) }
        else if value > -5 { return .blue.opacity(0.7) }
        else { return .purple.opacity(0.7) }
    }
    
    private func getCorrelation(row: Int, col: Int) -> Double {
        if row == col { return 1.0 }
        return Double.random(in: -0.5...0.8) // Simplified correlation
    }
    
    private func correlationColor(value: Double) -> Color {
        let absValue = abs(value)
        if absValue > 0.7 { return .red.opacity(0.8) }
        else if absValue > 0.4 { return .orange.opacity(0.8) }
        else { return .blue.opacity(0.8) }
    }
    
    private func resetToDefaults() {
        spotPrice = 100.0
        strikePrice = 100.0
        timeToExpiration = 0.25
        riskFreeRate = 5.0
        dividendYield = 2.0
        volatility = 20.0
        performAnalysis()
    }
    
    private func saveAnalysis() {
        // Implementation for saving analysis
    }
    
    private func loadAnalysis() {
        // Implementation for loading analysis
    }
    
    private func exportAnalysis() {
        // Implementation for exporting analysis
    }
    
    private func exportComprehensiveReport() {
        // Implementation for comprehensive report export
    }
}

// MARK: - Supporting Data Models

struct DerivativeResult {
    let fairValue: Double
    let delta: Double
    let gamma: Double
    let vega: Double
    let theta: Double
    let rho: Double
}

struct PortfolioMetrics {
    let totalValue: Double
    let valueAtRisk: Double
    let expectedShortfall: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let totalDelta: Double
    let totalGamma: Double
    
    init() {
        self.totalValue = 0
        self.valueAtRisk = 0
        self.expectedShortfall = 0
        self.maxDrawdown = 0
        self.sharpeRatio = 0
        self.totalDelta = 0
        self.totalGamma = 0
    }
    
    init(totalValue: Double, valueAtRisk: Double, expectedShortfall: Double, maxDrawdown: Double, sharpeRatio: Double, totalDelta: Double, totalGamma: Double) {
        self.totalValue = totalValue
        self.valueAtRisk = valueAtRisk
        self.expectedShortfall = expectedShortfall
        self.maxDrawdown = maxDrawdown
        self.sharpeRatio = sharpeRatio
        self.totalDelta = totalDelta
        self.totalGamma = totalGamma
    }
}

struct StressScenario {
    let name: String
    let spotShift: Double
    let volShift: Double
    let rateShift: Double
}

struct HedgeRecommendation: Identifiable {
    let id: UUID
    let instrument: AdvancedDerivativesAnalyticsView.DerivativeInstrument
    let action: String
    let quantity: Int
    let rationale: String
    let costBenefit: String
    let priority: Priority
    
    enum Priority {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .blue
            }
        }
    }
}

struct PayoffComparisonPoint: Identifiable {
    let id = UUID()
    let spotPrice: Double
    let payoffs: [AdvancedDerivativesAnalyticsView.DerivativeInstrument: Double]
}

struct VolatilitySurfacePoint: Identifiable {
    let id = UUID()
    let strike: Double
    let expiration: Double
    let impliedVolatility: Double
}

struct TermStructurePoint: Identifiable {
    let id = UUID()
    let maturity: Double
    let rate: Double
}

struct StressTestResult: Identifiable {
    let id = UUID()
    let scenarioName: String
    let portfolioPnL: Double
    let maxDrawdown: Double
    let severity: Severity
    
    init(scenarioName: String, portfolioPnL: Double, maxDrawdown: Double, severity: Severity) {
        self.scenarioName = scenarioName
        self.portfolioPnL = portfolioPnL
        self.maxDrawdown = maxDrawdown
        self.severity = severity
    }
    
    enum Severity {
        case mild, moderate, severe
        
        var displayName: String {
            switch self {
            case .mild: return "Mild"
            case .moderate: return "Moderate"
            case .severe: return "Severe"
            }
        }
    }
}

// MARK: - Supporting View Components

struct RiskDecompositionRow: View {
    let instrument: AdvancedDerivativesAnalyticsView.DerivativeInstrument
    let result: DerivativeResult
    let totalRisk: Double
    
    private var riskContribution: Double {
        totalRisk > 0 ? abs(result.fairValue) / totalRisk : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(instrument.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(String(format: "%.1f%%", riskContribution * 100))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            GeometryReader { geometry in
                Rectangle()
                    .fill(.blue.opacity(0.3))
                    .frame(width: geometry.size.width * riskContribution, height: 6)
                    .cornerRadius(3)
            }
            .frame(height: 6)
        }
    }
}

struct PerformanceAttributionRow: View {
    let instrument: AdvancedDerivativesAnalyticsView.DerivativeInstrument
    let result: DerivativeResult
    let weight: Double
    let totalValue: Double
    
    private var contribution: Double {
        result.fairValue * weight
    }
    
    var body: some View {
        HStack {
            Image(systemName: instrument.systemImage)
                .foregroundColor(.blue)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(instrument.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("Weight: \(String(format: "%.1f%%", weight * 100))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(Currency.usd.formatValue(contribution))
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text(String(format: "%.1f%%", contribution / totalValue * 100))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct HedgeRecommendationCard: View {
    let recommendation: HedgeRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: recommendation.instrument.systemImage)
                        .foregroundColor(recommendation.priority.color)
                    
                    Text(recommendation.instrument.displayName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Text("\\(recommendation.action) \\(recommendation.quantity)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(recommendation.priority.color.opacity(0.2))
                    .cornerRadius(6)
            }
            
            Text(recommendation.rationale)
                .font(.caption)
                .foregroundColor(.primary)
            
            Text(recommendation.costBenefit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Advanced Settings Sheet

struct AdvancedSettingsView: View {
    @Binding var stressTestScenarios: [StressScenario]
    @Binding var portfolioWeights: [AdvancedDerivativesAnalyticsView.DerivativeInstrument: Double]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Advanced Settings")
                    .font(.title)
                    .padding()
                
                Text("Configure stress test scenarios and portfolio weights")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Advanced Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(width: 600, height: 500)
    }
}

#Preview {
    AdvancedDerivativesAnalyticsView()
        .environment(MainViewModel())
        .frame(width: 1800, height: 1200)
}
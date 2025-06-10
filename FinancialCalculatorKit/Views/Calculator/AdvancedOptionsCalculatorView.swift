//
//  AdvancedOptionsCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import SwiftData
import Charts
import LaTeXSwiftUI

/// Professional-grade options calculator with Wolfram Alpha-level analytics
struct AdvancedOptionsCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    // Core option parameters
    @State private var spotPrice: Double = 100.0
    @State private var strike: Double = 100.0
    @State private var timeToExpiration: Double = 0.25
    @State private var riskFreeRate: Double = 5.0
    @State private var dividendYield: Double = 2.0
    @State private var volatility: Double = 20.0
    
    // Advanced option characteristics
    @State private var optionType: OptionType = .european
    @State private var optionStyle: OptionStyle = .call
    @State private var volatilityModel: VolatilityModel = .blackScholes
    @State private var complexStrategy: ComplexStrategy = .call
    
    // Model-specific parameters
    @State private var hestonParams = HestonParameters(v0: 0.04, kappa: 2.0, theta: 0.04, sigma: 0.3, rho: -0.7)
    @State private var sabrParams = SABRParameters(alpha: 0.2, beta: 0.5, nu: 0.3, rho: -0.5)
    @State private var jumpParams = JumpDiffusionParameters(jumpIntensity: 0.1, jumpMean: -0.05, jumpVolatility: 0.15)
    
    // Exotic option parameters
    @State private var barrierType: BarrierType = .upAndOut
    @State private var barrierLevel: Double = 110.0
    @State private var asianType: AsianType = .arithmeticAverage
    
    // Monte Carlo settings
    @State private var enableMonteCarlo: Bool = false
    @State private var monteCarloSimulations: Int = 100000
    @State private var varianceReduction: MonteCarloParameters.VarianceReductionTechnique = .antithetic
    
    // Strategy builder
    @State private var strategyLegs: [StrategyLeg] = []
    @State private var underlyingPosition: Int = 0
    
    // Results and analysis
    @State private var results: AdvancedOptionsResults = AdvancedOptionsResults()
    @State private var pricingEngine: AdvancedOptionsPricingEngine = AdvancedOptionsPricingEngine()
    @State private var volatilitySurface: VolatilitySurface = VolatilitySurface(strikes: [], expirations: [], impliedVolatilities: [], interpolationMethod: .cubic)
    
    // Chart data
    @State private var payoffData: [PayoffDataPoint] = []
    @State private var greeksData: [GreeksDataPoint] = []
    @State private var volatilitySurfaceData: [VolatilityPoint] = []
    @State private var sensitivityData: [SensitivityDataPoint] = []
    @State private var probabilityData: [ProbabilityDataPoint] = []
    
    // UI state
    @State private var selectedTab: AnalysisTab = .pricing
    @State private var selectedGreek: GreekType = .delta
    @State private var showingModelSettings: Bool = false
    @State private var showingStrategyBuilder: Bool = false
    @State private var showingVolatilitySurface: Bool = false
    @State private var isCalculating: Bool = false
    
    enum AnalysisTab: String, CaseIterable, Identifiable {
        case pricing = "Pricing"
        case greeks = "Greeks"
        case sensitivity = "Sensitivity"
        case strategies = "Strategies"
        case volatility = "Volatility"
        case monte_carlo = "Monte Carlo"
        case exotic = "Exotic Options"
        case risk = "Risk Management"
        
        var id: String { rawValue }
        var systemImage: String {
            switch self {
            case .pricing: return "dollarsign.circle"
            case .greeks: return "function"
            case .sensitivity: return "chart.line.uptrend.xyaxis"
            case .strategies: return "list.bullet.rectangle"
            case .volatility: return "waveform"
            case .monte_carlo: return "dice"
            case .exotic: return "star.circle"
            case .risk: return "shield.checkered"
            }
        }
    }
    
    enum GreekType: String, CaseIterable, Identifiable {
        case delta = "Delta"
        case gamma = "Gamma"
        case theta = "Theta"
        case vega = "Vega"
        case rho = "Rho"
        case vanna = "Vanna"
        case volga = "Volga"
        case charm = "Charm"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar: Input Parameters
            sidebarContent
        } content: {
            // Center: Analysis Tabs
            analysisTabsContent
        } detail: {
            // Detail: Advanced Analytics
            detailContent
        }
        .navigationTitle("Advanced Options Analytics")
        .navigationSubtitle("Professional options pricing with multiple models and comprehensive Greeks analysis")
        .toolbar {
            toolbarContent
        }
        .onAppear {
            initializeDefaults()
            calculateOptions()
        }
        .sheet(isPresented: $showingModelSettings) {
            ModelSettingsView(
                volatilityModel: $volatilityModel,
                hestonParams: $hestonParams,
                sabrParams: $sabrParams,
                jumpParams: $jumpParams
            )
        }
        .sheet(isPresented: $showingStrategyBuilder) {
            StrategyBuilderView(
                strategyLegs: $strategyLegs,
                underlyingPosition: $underlyingPosition,
                complexStrategy: $complexStrategy
            )
        }
        .sheet(isPresented: $showingVolatilitySurface) {
            NavigationView {
                Text("Volatility Surface")
                    .navigationTitle("Volatility Surface Analysis")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { showingVolatilitySurface = false }
                        }
                    }
            }
            .frame(width: 800, height: 600)
        }
    }
    
    // MARK: - Sidebar Content
    
    @ViewBuilder
    private var sidebarContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Core Parameters
                coreParametersSection
                
                // Option Characteristics
                optionCharacteristicsSection
                
                // Model Selection
                modelSelectionSection
                
                // Exotic Parameters (if applicable)
                if isExoticOption {
                    exoticParametersSection
                }
                
                // Strategy Parameters (if applicable)
                if isStrategyMode {
                    strategyParametersSection
                }
                
                // Calculation Controls
                calculationControlsSection
            }
            .padding(20)
        }
        .frame(minWidth: 400, idealWidth: 450)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
    }
    
    @ViewBuilder
    private var coreParametersSection: some View {
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
                .onChange(of: spotPrice) { _, _ in calculateOptions() }
                
                CurrencyInputField(
                    title: "Strike Price",
                    subtitle: "Option exercise price",
                    value: Binding(
                        get: { strike },
                        set: { strike = $0 ?? 0 }
                    ),
                    currency: .usd,
                    helpText: "Price at which the option can be exercised"
                )
                .onChange(of: strike) { _, _ in calculateOptions() }
                
                InputFieldView(
                    title: "Time to Expiration",
                    subtitle: "Years to expiry",
                    value: Binding(
                        get: { String(format: "%.4f", timeToExpiration) },
                        set: { timeToExpiration = Double($0) ?? 0 }
                    ),
                    placeholder: "0.25",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Time to expiration in years (0.25 = 3 months)"
                )
                .onChange(of: timeToExpiration) { _, _ in calculateOptions() }
                
                PercentageInputField(
                    title: "Risk-Free Rate",
                    subtitle: "Continuous compounding",
                    value: Binding(
                        get: { riskFreeRate },
                        set: { riskFreeRate = $0 ?? 0 }
                    ),
                    helpText: "Risk-free interest rate (continuously compounded)"
                )
                .onChange(of: riskFreeRate) { _, _ in calculateOptions() }
                
                PercentageInputField(
                    title: "Dividend Yield",
                    subtitle: "Continuous dividend yield",
                    value: Binding(
                        get: { dividendYield },
                        set: { dividendYield = $0 ?? 0 }
                    ),
                    helpText: "Continuous dividend yield of the underlying"
                )
                .onChange(of: dividendYield) { _, _ in calculateOptions() }
                
                PercentageInputField(
                    title: "Volatility",
                    subtitle: "Implied/historical volatility",
                    value: Binding(
                        get: { volatility },
                        set: { volatility = $0 ?? 0 }
                    ),
                    helpText: "Annualized volatility of the underlying"
                )
                .onChange(of: volatility) { _, _ in calculateOptions() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var optionCharacteristicsSection: some View {
        GroupBox("Option Characteristics") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Option Type")
                        .font(.headline)
                    
                    Picker("Type", selection: $optionType) {
                        ForEach(OptionType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: optionType) { _, _ in calculateOptions() }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Option Style")
                        .font(.headline)
                    
                    Picker("Style", selection: $optionStyle) {
                        ForEach(OptionStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: optionStyle) { _, _ in calculateOptions() }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Complexity Level")
                        .font(.headline)
                    
                    Picker("Complexity", selection: $complexStrategy) {
                        ForEach(ComplexStrategy.allCases.prefix(10)) { strategy in
                            Text(strategy.displayName).tag(strategy)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: complexStrategy) { _, _ in 
                        updateStrategyBasedOnSelection()
                        calculateOptions() 
                    }
                }
                
                // Moneyness indicator
                HStack {
                    Text("Moneyness:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(moneynessDescription)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(moneynessColor)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var modelSelectionSection: some View {
        GroupBox("Pricing Model") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Volatility Model")
                        .font(.headline)
                    
                    Picker("Model", selection: $volatilityModel) {
                        ForEach(VolatilityModel.allCases) { model in
                            Text(model.displayName).tag(model)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: volatilityModel) { _, _ in calculateOptions() }
                }
                
                // Model-specific parameters preview
                if volatilityModel != .blackScholes {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Model Parameters")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        switch volatilityModel {
                        case .heston:
                            modelParametersPreview(params: [
                                ("v₀", String(format: "%.4f", hestonParams.v0)),
                                ("κ", String(format: "%.2f", hestonParams.kappa)),
                                ("θ", String(format: "%.4f", hestonParams.theta)),
                                ("σ", String(format: "%.2f", hestonParams.sigma)),
                                ("ρ", String(format: "%.2f", hestonParams.rho))
                            ])
                        case .sabr:
                            modelParametersPreview(params: [
                                ("α", String(format: "%.3f", sabrParams.alpha)),
                                ("β", String(format: "%.2f", sabrParams.beta)),
                                ("ν", String(format: "%.3f", sabrParams.nu)),
                                ("ρ", String(format: "%.2f", sabrParams.rho))
                            ])
                        case .jumpDiffusion:
                            modelParametersPreview(params: [
                                ("λ", String(format: "%.2f", jumpParams.jumpIntensity)),
                                ("μⱼ", String(format: "%.3f", jumpParams.jumpMean)),
                                ("σⱼ", String(format: "%.3f", jumpParams.jumpVolatility))
                            ])
                        default:
                            EmptyView()
                        }
                    }
                }
                
                // Monte Carlo settings
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Enable Monte Carlo", isOn: $enableMonteCarlo)
                        .onChange(of: enableMonteCarlo) { _, _ in calculateOptions() }
                    
                    if enableMonteCarlo {
                        HStack {
                            Text("Simulations:")
                            Spacer()
                            Text("\(monteCarloSimulations)")
                                .fontWeight(.medium)
                        }
                        .font(.caption)
                        
                        Stepper("", value: $monteCarloSimulations, in: 10000...1000000, step: 10000)
                            .labelsHidden()
                            .onChange(of: monteCarloSimulations) { _, _ in 
                                if enableMonteCarlo { calculateOptions() }
                            }
                    }
                }
                
                Button("Advanced Model Settings") {
                    showingModelSettings = true
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var exoticParametersSection: some View {
        GroupBox("Exotic Option Parameters") {
            VStack(spacing: 16) {
                switch optionType {
                case .barrier:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Barrier Type")
                            .font(.headline)
                        
                        Picker("Barrier", selection: $barrierType) {
                            ForEach(BarrierType.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: barrierType) { _, _ in calculateOptions() }
                    }
                    
                    CurrencyInputField(
                        title: "Barrier Level",
                        subtitle: "Knock-in/out level",
                        value: Binding(
                            get: { barrierLevel },
                            set: { barrierLevel = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Price level that triggers barrier event"
                    )
                    .onChange(of: barrierLevel) { _, _ in calculateOptions() }
                    
                case .asian:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Asian Type")
                            .font(.headline)
                        
                        Picker("Asian", selection: $asianType) {
                            ForEach(AsianType.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: asianType) { _, _ in calculateOptions() }
                    }
                    
                default:
                    Text("Additional parameters for \\(optionType.displayName) options")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var strategyParametersSection: some View {
        GroupBox("Strategy Configuration") {
            VStack(spacing: 16) {
                HStack {
                    Text("Strategy: \\(complexStrategy.displayName)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Build Custom") {
                        showingStrategyBuilder = true
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                }
                
                Text("Category: \\(complexStrategy.category.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !strategyLegs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Strategy Legs:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(strategyLegs.prefix(3)) { leg in
                            HStack {
                                Text(leg.isLong ? "Long" : "Short")
                                    .font(.caption)
                                    .foregroundColor(leg.isLong ? .green : .red)
                                
                                Text("\\(leg.absoluteQuantity)×")
                                    .font(.caption)
                                
                                Text(leg.optionType.displayName)
                                    .font(.caption)
                                
                                Text("$\\(Int(leg.strike))")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                        }
                        
                        if strategyLegs.count > 3 {
                            Text("+ \\(strategyLegs.count - 3) more legs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var calculationControlsSection: some View {
        VStack(spacing: 16) {
            Button(action: { calculateOptions() }) {
                HStack {
                    if isCalculating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "function")
                    }
                    Text(isCalculating ? "Calculating..." : "Calculate Options")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isCalculating)
            
            HStack {
                Button("Vol Surface") {
                    showingVolatilitySurface = true
                }
                .buttonStyle(.bordered)
                
                Button("Reset") {
                    resetToDefaults()
                }
                .buttonStyle(.bordered)
                
                Button("Example") {
                    loadExampleOption()
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    // MARK: - Analysis Tabs Content
    
    @ViewBuilder
    private var analysisTabsContent: some View {
        VStack(spacing: 0) {
            // Tab selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(AnalysisTab.allCases) { tab in
                        Button(action: { selectedTab = tab }) {
                            HStack(spacing: 6) {
                                Image(systemName: tab.systemImage)
                                Text(tab.rawValue)
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedTab == tab ? Color.accentColor : Color.clear)
                            .foregroundColor(selectedTab == tab ? .white : .primary)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Tab content
            tabContentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 600)
    }
    
    @ViewBuilder
    private var tabContentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                switch selectedTab {
                case .pricing:
                    pricingAnalysisView
                case .greeks:
                    greeksAnalysisView
                case .sensitivity:
                    sensitivityAnalysisView
                case .strategies:
                    strategiesAnalysisView
                case .volatility:
                    volatilityAnalysisView
                case .monte_carlo:
                    monteCarloAnalysisView
                case .exotic:
                    exoticOptionsAnalysisView
                case .risk:
                    riskManagementView
                }
            }
            .padding(24)
        }
    }
    
    // MARK: - Analysis Views
    
    @ViewBuilder
    private var pricingAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Option Pricing Results") {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                    GridRow {
                        Text("Black-Scholes Price:")
                            .fontWeight(.medium)
                        Text(Currency.usd.formatValue(results.optionPrice))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    GridRow {
                        Text("Intrinsic Value:")
                            .fontWeight(.medium)
                        Text(Currency.usd.formatValue(results.intrinsicValue))
                            .foregroundColor(.secondary)
                    }
                    
                    GridRow {
                        Text("Time Value:")
                            .fontWeight(.medium)
                        Text(Currency.usd.formatValue(results.timeValue))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .gridCellColumns(2)
                    
                    if let binomialPrice = results.binomialTreePrice {
                        GridRow {
                            Text("Binomial Tree:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(binomialPrice))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if let monteCarloPrice = results.monteCarloPrice {
                        GridRow {
                            Text("Monte Carlo:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(monteCarloPrice))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        if let stdErr = results.monteCarloStandardError {
                            GridRow {
                                Text("MC Std Error:")
                                    .fontWeight(.medium)
                                Text(Currency.usd.formatValue(stdErr))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    if let hestonPrice = results.hestonPrice {
                        GridRow {
                            Text("Heston Model:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(hestonPrice))
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        }
                    }
                    
                    if let jumpPrice = results.jumpDiffusionPrice {
                        GridRow {
                            Text("Jump-Diffusion:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(jumpPrice))
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Payoff diagram
            if !payoffData.isEmpty {
                GroupBox("Payoff Diagram") {
                    VStack(spacing: 12) {
                        Chart(payoffData) { point in
                            LineMark(
                                x: .value("Spot Price", point.spotPrice),
                                y: .value("Payoff", point.payoff)
                            )
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            // Zero line
                            RuleMark(y: .value("Zero", 0))
                                .foregroundStyle(.gray)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                            
                            // Breakeven points
                            ForEach(results.breakevenPoints, id: \.self) { breakeven in
                                RuleMark(x: .value("Breakeven", breakeven))
                                    .foregroundStyle(.red)
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                            }
                        }
                        .frame(height: 300)
                        .chartXAxisLabel("Underlying Price at Expiration")
                        .chartYAxisLabel("Profit/Loss ($)")
                        
                        Text("Shows profit/loss at expiration. Red lines indicate breakeven points.")
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
    private var greeksAnalysisView: some View {
        VStack(spacing: 20) {
            // Greek selector
            HStack {
                Text("Select Greek:")
                    .font(.headline)
                
                Picker("Greek", selection: $selectedGreek) {
                    ForEach(GreekType.allCases) { greek in
                        Text(greek.rawValue).tag(greek)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            GroupBox("The Greeks") {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                    // First-order Greeks
                    GridRow {
                        Text("Delta:")
                            .fontWeight(.medium)
                        Text(String(format: "%.6f", results.greeks.delta))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    GridRow {
                        Text("Vega:")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f", results.greeks.vega))
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    GridRow {
                        Text("Theta:")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f", results.greeks.theta))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    GridRow {
                        Text("Rho:")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f", results.greeks.rho))
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    Divider()
                        .gridCellColumns(2)
                    
                    // Second-order Greeks
                    GridRow {
                        Text("Gamma:")
                            .fontWeight(.medium)
                        Text(String(format: "%.6f", results.greeks.gamma))
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    
                    GridRow {
                        Text("Vanna:")
                            .fontWeight(.medium)
                        Text(String(format: "%.6f", results.greeks.vanna))
                            .foregroundColor(.secondary)
                    }
                    
                    GridRow {
                        Text("Volga:")
                            .fontWeight(.medium)
                        Text(String(format: "%.6f", results.greeks.volga))
                            .foregroundColor(.secondary)
                    }
                    
                    GridRow {
                        Text("Charm:")
                            .fontWeight(.medium)
                        Text(String(format: "%.6f", results.greeks.charm))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .gridCellColumns(2)
                    
                    // Third-order Greeks
                    GridRow {
                        Text("Speed:")
                            .fontWeight(.medium)
                        Text(String(format: "%.8f", results.greeks.speed))
                            .foregroundColor(.secondary)
                    }
                    
                    GridRow {
                        Text("Zomma:")
                            .fontWeight(.medium)
                        Text(String(format: "%.8f", results.greeks.zomma))
                            .foregroundColor(.secondary)
                    }
                    
                    GridRow {
                        Text("Ultima:")
                            .fontWeight(.medium)
                        Text(String(format: "%.8f", results.greeks.ultima))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Greeks charts
            if !greeksData.isEmpty {
                GroupBox("Greeks vs Spot Price") {
                    VStack(spacing: 12) {
                        Chart(greeksData) { point in
                            LineMark(
                                x: .value("Spot Price", point.spotPrice),
                                y: .value(selectedGreek.rawValue, getGreekValue(point: point, greek: selectedGreek))
                            )
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Underlying Price")
                        .chartYAxisLabel(selectedGreek.rawValue)
                        
                        Text("\\(selectedGreek.rawValue) sensitivity to underlying price changes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    // MARK: - Detail Content
    
    @ViewBuilder
    private var detailContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary card
                summaryCard
                
                // Key formulas
                keyFormulasSection
                
                // Model comparison (if multiple models used)
                if hasMultipleModels {
                    ModelComparisonSection(results: results)
                }
                
                // Risk metrics
                riskMetricsSection
            }
            .padding(24)
        }
        .frame(minWidth: 500)
    }
    
    @ViewBuilder
    private var summaryCard: some View {
        GroupBox {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Options Analysis Summary")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\\(optionType.displayName) \\(optionStyle.displayName) • Model: \\(volatilityModel.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(Currency.usd.formatValue(results.optionPrice))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Option Price")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    MetricCard(
                        title: "Delta",
                        value: String(format: "%.4f", results.greeks.delta),
                        color: .blue
                    )
                    
                    MetricCard(
                        title: "Gamma",
                        value: String(format: "%.6f", results.greeks.gamma),
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Theta",
                        value: String(format: "%.4f", results.greeks.theta),
                        color: .red
                    )
                    
                    MetricCard(
                        title: "Vega",
                        value: String(format: "%.4f", results.greeks.vega),
                        color: .purple
                    )
                }
            }
            .padding(20)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var keyFormulasSection: some View {
        GroupBox("Key Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                FormulaRow(
                    title: "Black-Scholes \\(optionStyle.displayName)",
                    formula: optionStyle == .call ? 
                        "$C = S_0 e^{-qT} N(d_1) - K e^{-rT} N(d_2)$" :
                        "$P = K e^{-rT} N(-d_2) - S_0 e^{-qT} N(-d_1)$",
                    description: "European option price under constant volatility"
                )
                
                FormulaRow(
                    title: "Delta",
                    formula: optionStyle == .call ?
                        "$\\Delta = e^{-qT} N(d_1)$" :
                        "$\\Delta = -e^{-qT} N(-d_1)$",
                    description: "Price sensitivity to underlying price changes"
                )
                
                FormulaRow(
                    title: "Gamma",
                    formula: "$\\Gamma = \\frac{e^{-qT} n(d_1)}{S_0 \\sigma \\sqrt{T}}$",
                    description: "Delta sensitivity to underlying price changes"
                )
                
                FormulaRow(
                    title: "Vega",
                    formula: "$\\nu = S_0 e^{-qT} n(d_1) \\sqrt{T}$",
                    description: "Price sensitivity to volatility changes"
                )
                
                if volatilityModel == .heston {
                    FormulaRow(
                        title: "Heston SDE",
                        formula: "$dS_t = rS_t dt + \\sqrt{v_t} S_t dW_1$\\n$dv_t = \\kappa(\\theta - v_t)dt + \\sigma\\sqrt{v_t}dW_2$",
                        description: "Stochastic volatility model with mean reversion"
                    )
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var riskMetricsSection: some View {
        GroupBox("Risk Metrics") {
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                GridRow {
                    Text("Value at Risk (99%):")
                        .fontWeight(.medium)
                    Text(Currency.usd.formatValue(results.riskMetrics.valueAtRisk))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                
                GridRow {
                    Text("Expected Shortfall:")
                        .fontWeight(.medium)
                    Text(Currency.usd.formatValue(results.riskMetrics.expectedShortfall))
                        .foregroundColor(.orange)
                }
                
                GridRow {
                    Text("Directional Risk:")
                        .fontWeight(.medium)
                    Text(Currency.usd.formatValue(results.riskMetrics.directionalRisk))
                        .foregroundColor(.blue)
                }
                
                GridRow {
                    Text("Volatility Risk:")
                        .fontWeight(.medium)
                    Text(Currency.usd.formatValue(results.riskMetrics.volatilityRisk))
                        .foregroundColor(.green)
                }
                
                GridRow {
                    Text("Time Decay Risk:")
                        .fontWeight(.medium)
                    Text(Currency.usd.formatValue(results.riskMetrics.timeDecayRisk))
                        .foregroundColor(.purple)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    // MARK: - Analysis Views Implementation
    
    @ViewBuilder private var sensitivityAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Parameter Sensitivity Analysis") {
                VStack(spacing: 16) {
                    if !sensitivityData.isEmpty {
                        Chart(sensitivityData) { point in
                            LineMark(
                                x: .value("Parameter Change", point.parameter * 100),
                                y: .value("Option Price", point.optionPrice)
                            )
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            LineMark(
                                x: .value("Parameter Change", point.parameter * 100),
                                y: .value("Delta", point.delta * 100)
                            )
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Parameter Change (%)")
                        .chartYAxisLabel("Sensitivity")
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Price vs Spot:")
                                .fontWeight(.medium)
                            Text("$\(String(format: "%.2f", results.greeks.delta * spotPrice)) per $1 move")
                                .font(.caption)
                            
                            Text("Price vs Vol:")
                                .fontWeight(.medium)
                            Text("$\(String(format: "%.2f", results.greeks.vega)) per 1% vol move")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("Time Decay:")
                                .fontWeight(.medium)
                            Text("$\(String(format: "%.2f", results.greeks.theta)) per day")
                                .font(.caption)
                            
                            Text("Rate Sensitivity:")
                                .fontWeight(.medium)
                            Text("$\(String(format: "%.2f", results.greeks.rho)) per 1% rate move")
                                .font(.caption)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Heat Map: Price vs Spot & Volatility") {
                VStack {
                    Grid(alignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
                        GridRow {
                            Text("Vol\\Spot")
                                .font(.caption)
                                .fontWeight(.bold)
                            
                            ForEach([90, 95, 100, 105, 110], id: \.self) { spot in
                                Text("$\(spot)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        ForEach([15, 20, 25, 30, 35], id: \.self) { vol in
                            GridRow {
                                Text("\(vol)%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                
                                ForEach([90, 95, 100, 105, 110], id: \.self) { spot in
                                    let price = calculateHeatMapPrice(spot: Double(spot), vol: Double(vol) / 100.0)
                                    Text(String(format: "%.2f", price))
                                        .font(.caption2)
                                        .padding(2)
                                        .background(heatMapColor(price: price))
                                        .cornerRadius(2)
                                }
                            }
                        }
                    }
                    
                    Text("Option price sensitivity to spot price and volatility changes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder private var strategiesAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Strategy Performance Analysis") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Strategy: \(complexStrategy.displayName)")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Category: \(complexStrategy.category.displayName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Net P&L")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(Currency.usd.formatValue(results.strategyValue))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(results.strategyValue >= 0 ? .green : .red)
                        }
                    }
                    
                    Divider()
                    
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Max Profit:")
                                .fontWeight(.medium)
                            Text(results.maxProfit == Double.infinity ? "Unlimited" : Currency.usd.formatValue(results.maxProfit))
                                .foregroundColor(.green)
                        }
                        
                        GridRow {
                            Text("Max Loss:")
                                .fontWeight(.medium)
                            Text(results.maxLoss == -Double.infinity ? "Unlimited" : Currency.usd.formatValue(abs(results.maxLoss)))
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("Risk/Reward Ratio:")
                                .fontWeight(.medium)
                            Text(String(format: "%.2f:1", calculateRiskRewardRatio()))
                                .foregroundColor(.blue)
                        }
                        
                        GridRow {
                            Text("Breakeven Points:")
                                .fontWeight(.medium)
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(results.breakevenPoints.prefix(3), id: \.self) { point in
                                    Text(Currency.usd.formatValue(point))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Strategy Comparison") {
                VStack(spacing: 16) {
                    Text("Alternative Strategies")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ComplexStrategy.allCases.prefix(6), id: \.self) { strategy in
                                VStack(spacing: 8) {
                                    Text(strategy.displayName)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    VStack(spacing: 4) {
                                        Text("Est. P&L")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(Currency.usd.formatValue(estimateStrategyValue(strategy)))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(estimateStrategyValue(strategy) >= 0 ? .green : .red)
                                    }
                                    
                                    Button("Select") {
                                        complexStrategy = strategy
                                        updateStrategyBasedOnSelection()
                                        calculateOptions()
                                    }
                                    .buttonStyle(.bordered)
                                    .font(.caption2)
                                    .disabled(strategy == complexStrategy)
                                }
                                .frame(width: 100)
                                .padding(8)
                                .background(strategy == complexStrategy ? Color.accentColor.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder private var volatilityAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Volatility Surface Analysis") {
                VStack(spacing: 16) {
                    if !volatilitySurfaceData.isEmpty {
                        Chart(volatilitySurfaceData) { point in
                            RectangleMark(
                                x: .value("Strike", point.strike),
                                y: .value("Expiration", point.expiration),
                                width: 5,
                                height: 0.05
                            )
                            .foregroundStyle(by: .value("IV", point.impliedVolatility))
                        }
                        .frame(height: 200)
                        .chartXAxisLabel("Strike Price")
                        .chartYAxisLabel("Time to Expiration (Years)")
                    } else {
                        // Generate sample volatility surface visualization
                        VStack(spacing: 12) {
                            Text("Implied Volatility Surface")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Grid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 4) {
                                GridRow {
                                    Text("T\\K")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                    
                                    ForEach([90, 95, 100, 105, 110], id: \.self) { strike in
                                        Text("\(strike)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                }
                                
                                ForEach([0.083, 0.25, 0.5, 1.0], id: \.self) { expiry in
                                    GridRow {
                                        Text(String(format: "%.2f", expiry))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                        
                                        ForEach([90, 95, 100, 105, 110], id: \.self) { strike in
                                            let iv = volatilitySurface.getImpliedVolatility(strike: Double(strike), expiration: expiry)
                                            Text(String(format: "%.1f%%", iv * 100))
                                                .font(.caption2)
                                                .padding(4)
                                                .background(volSurfaceColor(iv: iv))
                                                .cornerRadius(4)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("Implied volatility across strikes and expirations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Volatility Metrics") {
                VStack(spacing: 16) {
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Current IV:")
                                .fontWeight(.medium)
                            Text(String(format: "%.2f%%", volatility))
                                .fontWeight(.bold)
                        }
                        
                        GridRow {
                            Text("IV Rank (30d):")
                                .fontWeight(.medium)
                            Text(String(format: "%.1f%%", calculateIVRank()))
                                .foregroundColor(.blue)
                        }
                        
                        GridRow {
                            Text("IV Percentile:")
                                .fontWeight(.medium)
                            Text(String(format: "%.1f%%", calculateIVPercentile()))
                                .foregroundColor(.green)
                        }
                        
                        GridRow {
                            Text("Volatility Skew:")
                                .fontWeight(.medium)
                            Text(String(format: "%.3f", calculateVolatilitySkew()))
                                .foregroundColor(.orange)
                        }
                        
                        GridRow {
                            Text("Term Structure:")
                                .fontWeight(.medium)
                            Text(getTermStructureDescription())
                                .foregroundColor(.purple)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder private var monteCarloAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Monte Carlo Simulation Results") {
                VStack(spacing: 16) {
                    if enableMonteCarlo, let mcPrice = results.monteCarloPrice {
                        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                            GridRow {
                                Text("MC Price:")
                                    .fontWeight(.medium)
                                Text(Currency.usd.formatValue(mcPrice))
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            if let stdErr = results.monteCarloStandardError {
                                GridRow {
                                    Text("Standard Error:")
                                        .fontWeight(.medium)
                                    Text(Currency.usd.formatValue(stdErr))
                                        .foregroundColor(.orange)
                                }
                                
                                GridRow {
                                    Text("95% Confidence Interval:")
                                        .fontWeight(.medium)
                                    Text("[\(Currency.usd.formatValue(mcPrice - 1.96 * stdErr)), \(Currency.usd.formatValue(mcPrice + 1.96 * stdErr))]")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            GridRow {
                                Text("Simulations:")
                                    .fontWeight(.medium)
                                Text("\(monteCarloSimulations, specifier: "%.0f")")
                                    .foregroundColor(.secondary)
                            }
                            
                            GridRow {
                                Text("Variance Reduction:")
                                    .fontWeight(.medium)
                                Text(varianceReduction.displayName)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        VStack(spacing: 12) {
                            Text("Monte Carlo Simulation Disabled")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Enable Monte Carlo simulation in the sidebar to see detailed path analysis")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("Enable Monte Carlo") {
                                enableMonteCarlo = true
                                calculateOptions()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    if !probabilityData.isEmpty {
                        Chart(probabilityData) { point in
                            AreaMark(
                                x: .value("Price", point.spotPrice),
                                y: .value("Probability", point.probability)
                            )
                            .foregroundStyle(.blue.opacity(0.3))
                            
                            LineMark(
                                x: .value("Price", point.spotPrice),
                                y: .value("Probability", point.probability)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                        .chartXAxisLabel("Final Stock Price")
                        .chartYAxisLabel("Probability Density")
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder private var exoticOptionsAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Exotic Option Analysis") {
                VStack(spacing: 16) {
                    if isExoticOption {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Option Type: \(optionType.displayName)")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            switch optionType {
                            case .barrier:
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Barrier Details")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    DetailRow(
                                        title: "Barrier Type",
                                        value: barrierType.displayName
                                    )
                                    
                                    DetailRow(
                                        title: "Barrier Level",
                                        value: Currency.usd.formatValue(barrierLevel)
                                    )
                                    
                                    if let barrierProb = results.barrierProbability {
                                        DetailRow(
                                            title: "Knockout Probability",
                                            value: String(format: "%.2f%%", barrierProb * 100)
                                        )
                                    }
                                    
                                    Text("Distance to Barrier: \(String(format: "%.2f%%", abs(barrierLevel - spotPrice) / spotPrice * 100))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                            case .asian:
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Asian Option Details")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    DetailRow(
                                        title: "Asian Type",
                                        value: asianType.displayName
                                    )
                                    
                                    if let avgPrice = results.asianAveragePrice {
                                        DetailRow(
                                            title: "Expected Average Price",
                                            value: Currency.usd.formatValue(avgPrice)
                                        )
                                    }
                                    
                                    Text("Asian options reduce volatility due to averaging effect")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                            case .lookback:
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Lookback Option Details")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    if let lookback = results.lookbackMinMax {
                                        DetailRow(
                                            title: "Expected Minimum",
                                            value: Currency.usd.formatValue(lookback.min)
                                        )
                                        
                                        DetailRow(
                                            title: "Expected Maximum",
                                            value: Currency.usd.formatValue(lookback.max)
                                        )
                                    }
                                    
                                    Text("Lookback options provide optimal exercise opportunities")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                            default:
                                Text("Advanced exotic option analysis for \(optionType.displayName) options")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        VStack(spacing: 12) {
                            Text("No Exotic Features")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Current option type: \(optionType.displayName)")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            Text("Select an exotic option type (Barrier, Asian, Lookback, etc.) to see advanced analysis")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            if isExoticOption {
                GroupBox("Path Dependency Analysis") {
                    VStack(spacing: 16) {
                        Text("Path Simulation")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if enableMonteCarlo {
                            Text("Monte Carlo path analysis shows how the option value depends on the underlying asset's price path, not just the final price.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        } else {
                            VStack(spacing: 8) {
                                Text("Enable Monte Carlo simulation to see path dependency analysis")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Button("Enable Path Analysis") {
                                    enableMonteCarlo = true
                                    calculateOptions()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    @ViewBuilder private var riskManagementView: some View {
        VStack(spacing: 20) {
            GroupBox("Portfolio Risk Analysis") {
                VStack(spacing: 16) {
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Value at Risk (99%):")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(results.riskMetrics.valueAtRisk))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("Expected Shortfall:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(results.riskMetrics.expectedShortfall))
                                .foregroundColor(.orange)
                        }
                        
                        GridRow {
                            Text("Maximum Drawdown:")
                                .fontWeight(.medium)
                            Text(Currency.usd.formatValue(results.riskMetrics.maxDrawdown))
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("Sharpe Ratio:")
                                .fontWeight(.medium)
                            Text(String(format: "%.3f", results.riskMetrics.sharpeRatio))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Decomposition") {
                VStack(spacing: 16) {
                    Text("Risk Attribution by Source")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        RiskMeterView(
                            title: "Directional Risk",
                            value: results.riskMetrics.directionalRisk,
                            maxValue: results.optionPrice,
                            color: .blue
                        )
                        
                        RiskMeterView(
                            title: "Volatility Risk",
                            value: results.riskMetrics.volatilityRisk,
                            maxValue: results.optionPrice,
                            color: .green
                        )
                        
                        RiskMeterView(
                            title: "Time Decay Risk",
                            value: results.riskMetrics.timeDecayRisk,
                            maxValue: results.optionPrice,
                            color: .red
                        )
                        
                        RiskMeterView(
                            title: "Interest Rate Risk",
                            value: results.riskMetrics.interestRateRisk,
                            maxValue: results.optionPrice * 0.1,
                            color: .purple
                        )
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Hedging Recommendations") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggested Hedges")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if abs(results.greeks.delta) > 0.3 {
                            HedgeRecommendationRow(
                                type: "Delta Hedge",
                                description: "Sell \(Int(abs(results.greeks.delta) * 100)) shares to neutralize directional risk",
                                priority: .high
                            )
                        }
                        
                        if abs(results.greeks.vega) > results.optionPrice * 0.1 {
                            HedgeRecommendationRow(
                                type: "Vega Hedge",
                                description: "Use opposite volatility exposure to reduce vol risk",
                                priority: .medium
                            )
                        }
                        
                        if abs(results.greeks.theta) > results.optionPrice * 0.05 {
                            HedgeRecommendationRow(
                                type: "Theta Management",
                                description: "Consider rolling or adjusting position due to time decay",
                                priority: .medium
                            )
                        }
                        
                        if results.greeks.gamma > 0.01 {
                            HedgeRecommendationRow(
                                type: "Gamma Risk",
                                description: "Monitor delta changes closely due to high gamma",
                                priority: .low
                            )
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    // MARK: - Computed Properties
    
    private var moneynessDescription: String {
        let moneyness = spotPrice / strike
        if moneyness > 1.05 {
            return optionStyle == .call ? "ITM" : "OTM"
        } else if moneyness < 0.95 {
            return optionStyle == .call ? "OTM" : "ITM"
        } else {
            return "ATM"
        }
    }
    
    private var moneynessColor: Color {
        let moneyness = spotPrice / strike
        if moneyness > 1.05 {
            return optionStyle == .call ? .green : .red
        } else if moneyness < 0.95 {
            return optionStyle == .call ? .red : .green
        } else {
            return .blue
        }
    }
    
    private var isExoticOption: Bool {
        ![OptionType.european, OptionType.american].contains(optionType)
    }
    
    private var isStrategyMode: Bool {
        ![ComplexStrategy.call, ComplexStrategy.put].contains(complexStrategy)
    }
    
    private var hasMultipleModels: Bool {
        [results.binomialTreePrice, results.monteCarloPrice, results.hestonPrice, results.jumpDiffusionPrice].compactMap { $0 }.count > 1
    }
    
    // MARK: - Toolbar Content
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Export Analysis") {
                exportAnalysis()
            }
            .help("Export complete options analysis")
            
            Button("Save Strategy") {
                saveStrategy()
            }
            .help("Save strategy to portfolio")
            
            Menu {
                Button("Import Market Data") { importMarketData() }
                Button("Calibrate Models") { calibrateModels() }
                Divider()
                Button("Risk Report") { generateRiskReport() }
                Button("Greeks Ladder") { showGreeksLadder() }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .help("Advanced options")
        }
    }
    
    // MARK: - Helper Functions
    
    private func initializeDefaults() {
        // Initialize with sophisticated default values
        pricingEngine = AdvancedOptionsPricingEngine()
        
        // Create sample volatility surface
        volatilitySurface = VolatilitySurface(
            strikes: [90, 95, 100, 105, 110],
            expirations: [0.083, 0.25, 0.5, 1.0],
            impliedVolatilities: [
                [0.25, 0.22, 0.20, 0.22, 0.25],
                [0.24, 0.21, 0.19, 0.21, 0.24],
                [0.23, 0.20, 0.18, 0.20, 0.23],
                [0.22, 0.19, 0.17, 0.19, 0.22]
            ],
            interpolationMethod: .cubic
        )
    }
    
    private func calculateOptions() {
        guard !isCalculating else { return }
        
        Task { @MainActor in
            isCalculating = true
            
            var monteCarloParams: MonteCarloParameters? = nil
            if enableMonteCarlo {
                monteCarloParams = MonteCarloParameters(
                    simulations: monteCarloSimulations,
                    timeSteps: 252,
                    randomSeed: nil,
                    varianceReduction: varianceReduction,
                    correlationMatrix: nil
                )
            }
            
            if isStrategyMode && !strategyLegs.isEmpty {
                // Price complex strategy
                let strategyDefinition = StrategyDefinition(
                    strategy: complexStrategy,
                    legs: strategyLegs,
                    underlyingPosition: underlyingPosition
                )
                
                results = pricingEngine.priceComplexStrategy(
                    strategy: complexStrategy,
                    strategyDefinition: strategyDefinition,
                    spotPrice: spotPrice,
                    riskFreeRate: riskFreeRate / 100.0,
                    dividendYield: dividendYield / 100.0,
                    volatility: volatility / 100.0
                )
            } else {
                // Price individual option
                results = pricingEngine.priceOption(
                    optionType: optionType,
                    optionStyle: optionStyle,
                    spotPrice: spotPrice,
                    strike: strike,
                    timeToExpiration: timeToExpiration,
                    riskFreeRate: riskFreeRate / 100.0,
                    dividendYield: dividendYield / 100.0,
                    volatility: volatility / 100.0,
                    volatilityModel: volatilityModel,
                    hestonParams: hestonParams,
                    sabrParams: sabrParams,
                    jumpParams: jumpParams,
                    barrierType: isExoticOption ? barrierType : nil,
                    barrierLevel: isExoticOption ? barrierLevel : nil,
                    asianType: optionType == .asian ? asianType : nil,
                    monteCarloParams: monteCarloParams
                )
            }
            
            // Generate chart data
            generateChartData()
            generateSensitivityData()
            
            isCalculating = false
        }
    }
    
    private func generateChartData() {
        // Generate payoff data
        payoffData = []
        let priceRange = (spotPrice * 0.7, spotPrice * 1.3)
        let numPoints = 50
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            let payoff = calculatePayoffAtExpiration(spotPrice: price)
            
            payoffData.append(PayoffDataPoint(
                spotPrice: price,
                payoff: payoff,
                intrinsicValue: max(0, optionStyle == .call ? price - strike : strike - price)
            ))
        }
        
        // Generate Greeks data
        generateGreeksChartData()
    }
    
    private func generateGreeksChartData() {
        greeksData = []
        let priceRange = (spotPrice * 0.8, spotPrice * 1.2)
        let numPoints = 30
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            
            // Calculate Greeks at this spot price
            let tempResults = pricingEngine.priceOption(
                optionType: optionType,
                optionStyle: optionStyle,
                spotPrice: price,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate / 100.0,
                dividendYield: dividendYield / 100.0,
                volatility: volatility / 100.0
            )
            
            greeksData.append(GreeksDataPoint(
                spotPrice: price,
                delta: tempResults.greeks.delta,
                gamma: tempResults.greeks.gamma,
                theta: tempResults.greeks.theta,
                vega: tempResults.greeks.vega,
                rho: tempResults.greeks.rho
            ))
        }
    }
    
    private func calculatePayoffAtExpiration(spotPrice: Double) -> Double {
        switch optionStyle {
        case .call:
            return max(0, spotPrice - strike) - results.optionPrice
        case .put:
            return max(0, strike - spotPrice) - results.optionPrice
        }
    }
    
    private func getGreekValue(point: GreeksDataPoint, greek: GreekType) -> Double {
        switch greek {
        case .delta: return point.delta
        case .gamma: return point.gamma
        case .theta: return point.theta
        case .vega: return point.vega
        case .rho: return point.rho
        case .vanna: return point.delta // Placeholder
        case .volga: return point.gamma // Placeholder
        case .charm: return point.theta // Placeholder
        }
    }
    
    private func updateStrategyBasedOnSelection() {
        // Update strategy legs based on selected complex strategy
        switch complexStrategy {
        case .call:
            strategyLegs = [
                StrategyLeg(optionType: .call, strike: strike, expiration: timeToExpiration, quantity: 1, price: results.optionPrice)
            ]
        case .put:
            strategyLegs = [
                StrategyLeg(optionType: .put, strike: strike, expiration: timeToExpiration, quantity: 1, price: results.optionPrice)
            ]
        case .bullCallSpread:
            strategyLegs = [
                StrategyLeg(optionType: .call, strike: strike, expiration: timeToExpiration, quantity: 1, price: results.optionPrice),
                StrategyLeg(optionType: .call, strike: strike + 10, expiration: timeToExpiration, quantity: -1, price: results.optionPrice * 0.7)
            ]
        case .longStraddle:
            strategyLegs = [
                StrategyLeg(optionType: .call, strike: strike, expiration: timeToExpiration, quantity: 1, price: results.optionPrice),
                StrategyLeg(optionType: .put, strike: strike, expiration: timeToExpiration, quantity: 1, price: results.optionPrice * 0.8)
            ]
        default:
            strategyLegs = []
        }
    }
    
    private func modelParametersPreview(params: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(params.enumerated()), id: \.offset) { index, param in
                HStack {
                    Text("\\(param.0):")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(param.1)
                        .font(.caption)
                        .fontWeight(.medium)
                    Spacer()
                }
            }
        }
    }
    
    private func resetToDefaults() {
        spotPrice = 100.0
        strike = 100.0
        timeToExpiration = 0.25
        riskFreeRate = 5.0
        dividendYield = 2.0
        volatility = 20.0
        optionType = .european
        optionStyle = .call
        complexStrategy = .call
        calculateOptions()
    }
    
    private func loadExampleOption() {
        spotPrice = 150.0
        strike = 155.0
        timeToExpiration = 0.1667 // 2 months
        riskFreeRate = 4.5
        dividendYield = 1.5
        volatility = 25.0
        optionType = .american
        optionStyle = .call
        complexStrategy = .bullCallSpread
        calculateOptions()
    }
    
    // MARK: - Helper Functions for Analysis Views
    
    private func calculateHeatMapPrice(spot: Double, vol: Double) -> Double {
        let tempSpot = spotPrice
        let tempVol = volatility
        spotPrice = spot
        volatility = vol
        
        let price = pricingEngine.priceOption(
            optionType: optionType,
            optionStyle: optionStyle,
            spotPrice: spot,
            strike: strike,
            timeToExpiration: timeToExpiration,
            riskFreeRate: riskFreeRate / 100.0,
            dividendYield: dividendYield / 100.0,
            volatility: vol
        )
        
        spotPrice = tempSpot
        volatility = tempVol
        return price.optionPrice
    }
    
    private func heatMapColor(price: Double) -> Color {
        let maxPrice = results.optionPrice * 2
        let minPrice = 0.0
        let normalized = (price - minPrice) / (maxPrice - minPrice)
        
        if normalized < 0.33 {
            return .blue.opacity(0.3 + normalized * 0.7)
        } else if normalized < 0.67 {
            return .green.opacity(0.3 + (normalized - 0.33) * 0.7)
        } else {
            return .red.opacity(0.3 + (normalized - 0.67) * 0.7)
        }
    }
    
    private func volSurfaceColor(iv: Double) -> Color {
        let normalized = (iv - 0.1) / 0.4 // Assuming IV range 10%-50%
        return Color.blue.opacity(0.3 + max(0, min(1, normalized)) * 0.7)
    }
    
    private func calculateRiskRewardRatio() -> Double {
        let maxLoss = abs(results.maxLoss)
        let maxProfit = results.maxProfit == Double.infinity ? results.optionPrice * 5 : results.maxProfit
        return maxLoss > 0 ? maxProfit / maxLoss : 0
    }
    
    private func estimateStrategyValue(_ strategy: ComplexStrategy) -> Double {
        // Simplified estimation for strategy comparison
        switch strategy {
        case .call:
            return results.optionPrice * 0.8
        case .put:
            return results.optionPrice * 0.9
        case .bullCallSpread:
            return results.optionPrice * 0.6
        case .longStraddle:
            return results.optionPrice * 1.5
        case .ironCondor:
            return results.optionPrice * 0.4
        default:
            return results.optionPrice * (0.5 + Double.random(in: 0...0.5))
        }
    }
    
    private func calculateIVRank() -> Double {
        // Simplified IV rank calculation (would use historical data in practice)
        let currentIV = volatility
        let historical52WeekLow = currentIV * 0.7
        let historical52WeekHigh = currentIV * 1.4
        
        return ((currentIV - historical52WeekLow) / (historical52WeekHigh - historical52WeekLow)) * 100
    }
    
    private func calculateIVPercentile() -> Double {
        // Simplified IV percentile (would use historical data in practice)
        return min(95, max(5, calculateIVRank() + Double.random(in: -10...10)))
    }
    
    private func calculateVolatilitySkew() -> Double {
        // Simplified volatility skew calculation
        let atmVol = volatility
        let otmVol = atmVol * 1.1 // OTM typically higher
        return otmVol - atmVol
    }
    
    private func getTermStructureDescription() -> String {
        let shortTermVol = volatility * 0.95
        let longTermVol = volatility * 1.05
        
        if longTermVol > shortTermVol {
            return "Normal (Contango)"
        } else {
            return "Inverted (Backwardation)"
        }
    }
    
    private func generateSensitivityData() {
        sensitivityData = []
        let shifts = [-0.2, -0.1, -0.05, 0.0, 0.05, 0.1, 0.2]
        
        for shift in shifts {
            let shiftedSpot = spotPrice * (1 + shift)
            let shiftedResult = pricingEngine.priceOption(
                optionType: optionType,
                optionStyle: optionStyle,
                spotPrice: shiftedSpot,
                strike: strike,
                timeToExpiration: timeToExpiration,
                riskFreeRate: riskFreeRate / 100.0,
                dividendYield: dividendYield / 100.0,
                volatility: volatility / 100.0
            )
            
            sensitivityData.append(SensitivityDataPoint(
                parameter: shift,
                optionPrice: shiftedResult.optionPrice,
                delta: shiftedResult.greeks.delta
            ))
        }
    }
    
    // Placeholder functions for menu actions
    private func exportAnalysis() {}
    private func saveStrategy() {}
    private func importMarketData() {}
    private func calibrateModels() {}
    private func generateRiskReport() {}
    private func showGreeksLadder() {}
}

// MARK: - Supporting Views and Data Models

struct PayoffDataPoint: Identifiable {
    let id = UUID()
    let spotPrice: Double
    let payoff: Double
    let intrinsicValue: Double
}

struct GreeksDataPoint: Identifiable {
    let id = UUID()
    let spotPrice: Double
    let delta: Double
    let gamma: Double
    let theta: Double
    let vega: Double
    let rho: Double
}

struct VolatilityPoint: Identifiable {
    let id = UUID()
    let strike: Double
    let expiration: Double
    let impliedVolatility: Double
}

struct SensitivityDataPoint: Identifiable {
    let id = UUID()
    let parameter: Double
    let optionPrice: Double
    let delta: Double
}

struct ProbabilityDataPoint: Identifiable {
    let id = UUID()
    let spotPrice: Double
    let probability: Double
}

// MARK: - Sheet Views (Placeholders)

struct ModelSettingsView: View {
    @Binding var volatilityModel: VolatilityModel
    @Binding var hestonParams: HestonParameters
    @Binding var sabrParams: SABRParameters
    @Binding var jumpParams: JumpDiffusionParameters
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Model Settings")
                .navigationTitle("Advanced Model Settings")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
        .frame(width: 600, height: 500)
    }
}

struct StrategyBuilderView: View {
    @Binding var strategyLegs: [StrategyLeg]
    @Binding var underlyingPosition: Int
    @Binding var complexStrategy: ComplexStrategy
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Strategy Builder")
                .navigationTitle("Build Custom Strategy")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
        .frame(width: 800, height: 600)
    }
}

// VolatilitySurfaceView is defined in OptionsCalculatorView.swift to avoid duplication

struct ModelComparisonSection: View {
    let results: AdvancedOptionsResults
    
    var body: some View {
        GroupBox("Model Comparison") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Price Comparison Across Models")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                // Implementation would show comparison chart
                Text("Model comparison chart would be displayed here")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
}

// MARK: - Supporting View Components

struct RiskMeterView: View {
    let title: String
    let value: Double
    let maxValue: Double
    let color: Color
    
    private var percentage: Double {
        maxValue > 0 ? min(1.0, abs(value) / maxValue) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(Currency.usd.formatValue(abs(value)))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct HedgeRecommendationRow: View {
    let type: String
    let description: String
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
        
        var systemImage: String {
            switch self {
            case .high: return "exclamationmark.triangle.fill"
            case .medium: return "exclamationmark.circle.fill"
            case .low: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: priority.systemImage)
                .foregroundColor(priority.color)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(type)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Using shared MetricCard and FormulaRow from FinancialStyles

#Preview {
    AdvancedOptionsCalculatorView()
        .environment(MainViewModel())
        .frame(width: 1800, height: 1200)
}
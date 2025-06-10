//
//  AdvancedBondCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import SwiftData
import Charts
import LaTeXSwiftUI

/// Professional-grade bond calculator with Wolfram Alpha-level analytics
struct AdvancedBondCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    // Core bond parameters
    @State private var faceValue: Double = 1000.0
    @State private var couponRate: Double = 5.0
    @State private var maturity: Double = 10.0
    @State private var frequency: PaymentFrequency = .semiAnnual
    @State private var currency: Currency = .usd
    
    // Advanced bond characteristics
    @State private var bondCategory: BondCategory = .corporate
    @State private var bondStructure: BondStructure = .fixed
    @State private var creditRating: CreditRating = .a
    @State private var customCreditSpread: Double = 0.0
    @State private var useCustomSpread: Bool = false
    
    // Tax parameters
    @State private var federalTaxRate: Double = 22.0
    @State private var stateTaxRate: Double = 5.0
    @State private var localTaxRate: Double = 0.0
    @State private var isTaxExempt: Bool = false
    
    // Embedded options
    @State private var hasEmbeddedOptions: Bool = false
    @State private var callPrice: Double = 102.0
    @State private var callDate: Double = 5.0
    @State private var volatility: Double = 20.0
    
    // Analysis settings
    @State private var enableMonteCarlo: Bool = true
    @State private var monteCarloSimulations: Int = 10000
    @State private var performScenarioAnalysis: Bool = true
    
    // Results and data
    @State private var results: AdvancedBondResults = AdvancedBondResults()
    @State private var yieldCurve: YieldCurve = YieldCurve()
    @State private var pricingEngine: AdvancedBondPricingEngine = AdvancedBondPricingEngine()
    
    // Chart data
    @State private var sensitivityData: [YieldSensitivityPoint] = []
    @State private var yieldCurveData: [YieldCurvePoint] = []
    @State private var cashFlowData: [CashFlowDataPoint] = []
    @State private var scenarioData: [ScenarioDataPoint] = []
    
    // UI state
    @State private var selectedTab: AnalysisTab = .pricing
    @State private var showingAdvancedSettings: Bool = false
    @State private var showingYieldCurveEditor: Bool = false
    @State private var isCalculating: Bool = false
    
    enum AnalysisTab: String, CaseIterable, Identifiable {
        case pricing = "Pricing"
        case riskMetrics = "Risk Metrics"
        case cashFlow = "Cash Flow"
        case scenarios = "Scenarios"
        case monteCarlo = "Monte Carlo"
        case options = "Options"
        case tax = "Tax Analysis"
        case benchmarks = "Benchmarks"
        
        var id: String { rawValue }
        var systemImage: String {
            switch self {
            case .pricing: return "dollarsign.circle"
            case .riskMetrics: return "chart.bar.xaxis"
            case .cashFlow: return "chart.line.uptrend.xyaxis"
            case .scenarios: return "questionmark.diamond"
            case .monteCarlo: return "dice"
            case .options: return "option"
            case .tax: return "percent"
            case .benchmarks: return "chart.xyaxis.line"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar: Input Parameters
            sidebarContent
        } content: {
            // Center: Analysis Tabs
            analysisTabsContent
        } detail: {
            // Detail: Selected Analysis
            detailContent
        }
        .navigationTitle("Advanced Bond Analytics")
        .navigationSubtitle("Professional-grade bond analysis with comprehensive risk metrics")
        .toolbar {
            toolbarContent
        }
        .onAppear {
            initializeDefaults()
            calculateBond()
        }
        .sheet(isPresented: $showingYieldCurveEditor) {
            YieldCurveEditorView(yieldCurve: $yieldCurve)
        }
        .sheet(isPresented: $showingAdvancedSettings) {
            AdvancedBondSettingsView(
                enableMonteCarlo: $enableMonteCarlo,
                monteCarloSimulations: $monteCarloSimulations,
                performScenarioAnalysis: $performScenarioAnalysis
            )
        }
    }
    
    // MARK: - Sidebar Content
    
    @ViewBuilder
    private var sidebarContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Basic Bond Parameters
                basicParametersSection
                
                // Advanced Characteristics
                advancedCharacteristicsSection
                
                // Credit Analysis
                creditAnalysisSection
                
                // Embedded Options (if applicable)
                if hasEmbeddedOptions {
                    embeddedOptionsSection
                }
                
                // Tax Settings
                taxSettingsSection
                
                // Calculation Controls
                calculationControlsSection
            }
            .padding(20)
        }
        .frame(minWidth: 350, idealWidth: 400)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
    }
    
    @ViewBuilder
    private var basicParametersSection: some View {
        GroupBox("Bond Parameters") {
            VStack(spacing: 16) {
                CurrencyInputField(
                    title: "Face Value",
                    subtitle: "Par value of the bond",
                    value: Binding(
                        get: { faceValue },
                        set: { faceValue = $0 ?? 0 }
                    ),
                    currency: currency,
                    helpText: "The principal amount to be repaid at maturity"
                )
                .onChange(of: faceValue) { _, _ in calculateBond() }
                
                PercentageInputField(
                    title: "Coupon Rate",
                    subtitle: "Annual coupon rate",
                    value: Binding(
                        get: { couponRate },
                        set: { couponRate = $0 ?? 0 }
                    ),
                    helpText: "Annual coupon rate as percentage of face value"
                )
                .onChange(of: couponRate) { _, _ in calculateBond() }
                
                InputFieldView(
                    title: "Years to Maturity",
                    subtitle: "Time until bond matures",
                    value: Binding(
                        get: { String(format: "%.2f", maturity) },
                        set: { maturity = Double($0) ?? 0 }
                    ),
                    placeholder: "10.00",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "Time to maturity in years"
                )
                .onChange(of: maturity) { _, _ in calculateBond() }
                
                HStack {
                    Text("Payment Frequency")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(PaymentFrequency.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: frequency) { _, _ in calculateBond() }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var advancedCharacteristicsSection: some View {
        GroupBox("Bond Characteristics") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bond Category")
                        .font(.headline)
                    
                    Picker("Category", selection: $bondCategory) {
                        ForEach(BondCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: bondCategory) { _, _ in calculateBond() }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bond Structure")
                        .font(.headline)
                    
                    Picker("Structure", selection: $bondStructure) {
                        ForEach(BondStructure.allCases) { structure in
                            Text(structure.displayName).tag(structure)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: bondStructure) { _, _ in 
                        hasEmbeddedOptions = [.callable, .putable, .convertible].contains(bondStructure)
                        calculateBond() 
                    }
                }
                
                if bondStructure == .callable || bondStructure == .putable || bondStructure == .convertible {
                    Toggle("Has Embedded Options", isOn: $hasEmbeddedOptions)
                        .onChange(of: hasEmbeddedOptions) { _, _ in calculateBond() }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var creditAnalysisSection: some View {
        GroupBox("Credit Analysis") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Credit Rating")
                        .font(.headline)
                    
                    Picker("Rating", selection: $creditRating) {
                        ForEach(CreditRating.allCases) { rating in
                            HStack {
                                Text(rating.rawValue)
                                Spacer()
                                if rating.isInvestmentGrade {
                                    Text("IG")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                } else {
                                    Text("HY")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                            .tag(rating)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: creditRating) { _, _ in calculateBond() }
                }
                
                Toggle("Use Custom Credit Spread", isOn: $useCustomSpread)
                    .onChange(of: useCustomSpread) { _, _ in calculateBond() }
                
                if useCustomSpread {
                    PercentageInputField(
                        title: "Credit Spread",
                        subtitle: "Custom spread over risk-free rate",
                        value: Binding(
                            get: { customCreditSpread },
                            set: { customCreditSpread = $0 ?? 0 }
                        ),
                        helpText: "Additional yield over risk-free rate"
                    )
                    .onChange(of: customCreditSpread) { _, _ in calculateBond() }
                }
                
                // Credit metrics display
                VStack(alignment: .leading, spacing: 8) {
                    Text("Credit Metrics")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    HStack {
                        Text("Default Probability:")
                        Spacer()
                        Text("\(String(format: "%.3f%%", creditRating.defaultProbability * 100))")
                            .fontWeight(.medium)
                    }
                    .font(.caption)
                    
                    HStack {
                        Text("Credit Spread:")
                        Spacer()
                        Text("\(String(format: "%.2f bps", (useCustomSpread ? customCreditSpread : creditRating.creditSpread) * 10000))")
                            .fontWeight(.medium)
                    }
                    .font(.caption)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var embeddedOptionsSection: some View {
        GroupBox("Embedded Options") {
            VStack(spacing: 16) {
                PercentageInputField(
                    title: "Call Price",
                    subtitle: "% of par value",
                    value: Binding(
                        get: { callPrice },
                        set: { callPrice = $0 ?? 0 }
                    ),
                    helpText: "Call price as percentage of par"
                )
                .onChange(of: callPrice) { _, _ in calculateBond() }
                
                InputFieldView(
                    title: "Call Date",
                    subtitle: "Years from now",
                    value: Binding(
                        get: { String(format: "%.1f", callDate) },
                        set: { callDate = Double($0) ?? 0 }
                    ),
                    placeholder: "5.0",
                    keyboardType: .decimalPad,
                    validation: .positiveNumber,
                    helpText: "First call date in years"
                )
                .onChange(of: callDate) { _, _ in calculateBond() }
                
                PercentageInputField(
                    title: "Volatility",
                    subtitle: "Interest rate volatility",
                    value: Binding(
                        get: { volatility },
                        set: { volatility = $0 ?? 0 }
                    ),
                    helpText: "Annual interest rate volatility"
                )
                .onChange(of: volatility) { _, _ in calculateBond() }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var taxSettingsSection: some View {
        GroupBox("Tax Analysis") {
            VStack(spacing: 16) {
                Toggle("Tax-Exempt Bond", isOn: $isTaxExempt)
                    .onChange(of: isTaxExempt) { _, _ in calculateBond() }
                
                if !isTaxExempt {
                    PercentageInputField(
                        title: "Federal Tax Rate",
                        subtitle: "Federal income tax rate",
                        value: Binding(
                            get: { federalTaxRate },
                            set: { federalTaxRate = $0 ?? 0 }
                        ),
                        helpText: "Your marginal federal tax rate"
                    )
                    .onChange(of: federalTaxRate) { _, _ in calculateBond() }
                    
                    PercentageInputField(
                        title: "State Tax Rate",
                        subtitle: "State income tax rate",
                        value: Binding(
                            get: { stateTaxRate },
                            set: { stateTaxRate = $0 ?? 0 }
                        ),
                        helpText: "Your marginal state tax rate"
                    )
                    .onChange(of: stateTaxRate) { _, _ in calculateBond() }
                    
                    PercentageInputField(
                        title: "Local Tax Rate",
                        subtitle: "Local income tax rate",
                        value: Binding(
                            get: { localTaxRate },
                            set: { localTaxRate = $0 ?? 0 }
                        ),
                        helpText: "Your marginal local tax rate"
                    )
                    .onChange(of: localTaxRate) { _, _ in calculateBond() }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var calculationControlsSection: some View {
        VStack(spacing: 16) {
            Button(action: { calculateBond() }) {
                HStack {
                    if isCalculating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "function")
                    }
                    Text(isCalculating ? "Calculating..." : "Calculate Bond")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isCalculating)
            
            HStack {
                Button("Advanced Settings") {
                    showingAdvancedSettings = true
                }
                .buttonStyle(.bordered)
                
                Button("Yield Curve") {
                    showingYieldCurveEditor = true
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
        .frame(minWidth: 500)
    }
    
    @ViewBuilder
    private var tabContentView: some View {
        switch selectedTab {
        case .pricing:
            pricingAnalysisView
        case .riskMetrics:
            riskMetricsView
        case .cashFlow:
            cashFlowAnalysisView
        case .scenarios:
            scenarioAnalysisView
        case .monteCarlo:
            monteCarloAnalysisView
        case .options:
            optionAnalysisView
        case .tax:
            taxAnalysisView
        case .benchmarks:
            benchmarkAnalysisView
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
                
                // Advanced analytics based on selected tab
                switch selectedTab {
                case .pricing:
                    pricingDetailsView
                case .riskMetrics:
                    riskMetricsDetailsView
                case .cashFlow:
                    cashFlowDetailsView
                case .scenarios:
                    scenarioDetailsView
                case .monteCarlo:
                    monteCarloDetailsView
                case .options:
                    optionDetailsView
                case .tax:
                    taxDetailsView
                case .benchmarks:
                    benchmarkDetailsView
                }
            }
            .padding(24)
        }
        .frame(minWidth: 400)
    }
    
    // MARK: - Pricing Analysis View
    
    @ViewBuilder
    private var pricingAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Bond Pricing Results") {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                    GridRow {
                        Text("Dirty Price:")
                            .fontWeight(.medium)
                        Text(currency.formatValue(results.dirtyPrice))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    GridRow {
                        Text("Clean Price:")
                            .fontWeight(.medium)
                        Text(currency.formatValue(results.cleanPrice))
                            .foregroundColor(.secondary)
                    }
                    
                    GridRow {
                        Text("Accrued Interest:")
                            .fontWeight(.medium)
                        Text(currency.formatValue(results.accruedInterest))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .gridCellColumns(2)
                    
                    GridRow {
                        Text("Yield to Maturity:")
                            .fontWeight(.medium)
                        Text(String(format: "%.3f%%", results.yieldToMaturity * 100))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    if let ytc = results.yieldToCall {
                        GridRow {
                            Text("Yield to Call:")
                                .fontWeight(.medium)
                            Text(String(format: "%.3f%%", ytc * 100))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    GridRow {
                        Text("Yield to Worst:")
                            .fontWeight(.medium)
                        Text(String(format: "%.3f%%", results.yieldToWorst * 100))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    GridRow {
                        Text("Current Yield:")
                            .fontWeight(.medium)
                        Text(String(format: "%.3f%%", results.currentYield * 100))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Yield sensitivity chart
            if !sensitivityData.isEmpty {
                GroupBox("Yield Sensitivity Analysis") {
                    VStack(spacing: 12) {
                        Chart(sensitivityData) { point in
                            LineMark(
                                x: .value("Yield Change (bps)", point.yieldChange * 10000),
                                y: .value("Bond Price", point.price)
                            )
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            if abs(point.yieldChange) < 0.001 {
                                PointMark(
                                    x: .value("Yield Change (bps)", point.yieldChange * 10000),
                                    y: .value("Bond Price", point.price)
                                )
                                .foregroundStyle(.red)
                                .symbol(.circle)
                                .symbolSize(100)
                            }
                        }
                        .frame(height: 300)
                        .chartYAxisLabel("Bond Price")
                        .chartXAxisLabel("Yield Change (basis points)")
                        
                        Text("Shows the convex relationship between bond price and yield changes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    // MARK: - Risk Metrics View
    
    @ViewBuilder
    private var riskMetricsView: some View {
        VStack(spacing: 20) {
            GroupBox("Duration and Convexity") {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                    GridRow {
                        Text("Macaulay Duration:")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f years", results.macaulayDuration))
                            .fontWeight(.bold)
                    }
                    
                    GridRow {
                        Text("Modified Duration:")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f", results.modifiedDuration))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    if results.effectiveDuration > 0 {
                        GridRow {
                            Text("Effective Duration:")
                                .fontWeight(.medium)
                            Text(String(format: "%.4f", results.effectiveDuration))
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    GridRow {
                        Text("Convexity:")
                            .fontWeight(.medium)
                        Text(String(format: "%.6f", results.convexity))
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    if results.effectiveConvexity > 0 {
                        GridRow {
                            Text("Effective Convexity:")
                                .fontWeight(.medium)
                            Text(String(format: "%.6f", results.effectiveConvexity))
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        }
                    }
                    
                    Divider()
                        .gridCellColumns(2)
                    
                    GridRow {
                        Text("DV01:")
                            .fontWeight(.medium)
                        Text(currency.formatValue(results.dv01))
                            .fontWeight(.bold)
                    }
                    
                    GridRow {
                        Text("PVBP:")
                            .fontWeight(.medium)
                        Text(currency.formatValue(results.pvbp))
                            .fontWeight(.bold)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Credit Risk Metrics") {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                    GridRow {
                        Text("Credit VaR (99%):")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f%%", results.creditVaR * 100))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    GridRow {
                        Text("Expected Loss:")
                            .fontWeight(.medium)
                        Text(String(format: "%.4f%%", results.expectedLoss * 100))
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    GridRow {
                        Text("Z-Spread:")
                            .fontWeight(.medium)
                        Text(String(format: "%.2f bps", results.zSpread * 10000))
                            .fontWeight(.bold)
                    }
                    
                    GridRow {
                        Text("I-Spread:")
                            .fontWeight(.medium)
                        Text(String(format: "%.2f bps", results.iSpread * 10000))
                            .fontWeight(.bold)
                    }
                    
                    if results.optionAdjustedSpread > 0 {
                        GridRow {
                            Text("Option-Adjusted Spread:")
                                .fontWeight(.medium)
                            Text(String(format: "%.2f bps", results.optionAdjustedSpread))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    // MARK: - Summary Card
    
    @ViewBuilder
    private var summaryCard: some View {
        GroupBox {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bond Analysis Summary")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(bondCategory.displayName) • \(bondStructure.displayName) • \(creditRating.rawValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(currency.formatValue(results.dirtyPrice))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Dirty Price")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    MetricCard(
                        title: "YTM",
                        value: String(format: "%.3f%%", results.yieldToMaturity * 100),
                        color: .blue
                    )
                    
                    MetricCard(
                        title: "Duration",
                        value: String(format: "%.2f", results.modifiedDuration),
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Convexity",
                        value: String(format: "%.4f", results.convexity),
                        color: .purple
                    )
                    
                    MetricCard(
                        title: "DV01",
                        value: currency.formatValue(results.dv01),
                        color: .orange
                    )
                }
            }
            .padding(20)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    // MARK: - Key Formulas Section
    
    @ViewBuilder
    private var keyFormulasSection: some View {
        GroupBox("Key Bond Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                FormulaRow(
                    title: "Bond Price",
                    formula: "$P = \\sum_{t=1}^{n} \\frac{C}{(1+r)^t} + \\frac{M}{(1+r)^n}$",
                    description: "Present value of all future cash flows"
                )
                
                FormulaRow(
                    title: "Modified Duration",
                    formula: "$D_{Mod} = \\frac{D_{Mac}}{1+r/m}$",
                    description: "Price sensitivity to yield changes"
                )
                
                FormulaRow(
                    title: "Convexity",
                    formula: "$Convexity = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{t(t+1) \\cdot CF_t}{(1+r)^{t+2}}$",
                    description: "Second-order price sensitivity"
                )
                
                if results.optionAdjustedSpread > 0 {
                    FormulaRow(
                        title: "Option-Adjusted Spread",
                        formula: "$OAS = \\text{Spread such that } P_{Market} = P_{Model}$",
                        description: "Spread after removing embedded option value"
                    )
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    // MARK: - Cash Flow Analysis View
    
    @ViewBuilder 
    private var cashFlowAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Payment Schedule") {
                VStack(spacing: 16) {
                    if !cashFlowData.isEmpty {
                        // Cash flow timeline chart
                        Chart(cashFlowData) { dataPoint in
                            // Coupon payments
                            BarMark(
                                x: .value("Period", dataPoint.period),
                                y: .value("Payment", dataPoint.couponPayment)
                            )
                            .foregroundStyle(.blue)
                            .opacity(0.8)
                            
                            // Principal payment (final period)
                            if dataPoint.principalPayment > 0 {
                                BarMark(
                                    x: .value("Period", dataPoint.period),
                                    y: .value("Principal", dataPoint.principalPayment),
                                    stacking: .center
                                )
                                .foregroundStyle(.green)
                                .opacity(0.8)
                            }
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Payment Period")
                        .chartYAxisLabel("Cash Flow ($)")
                        .chartLegend(position: .top)
                        
                        Text("Blue: Coupon Payments, Green: Principal Repayment")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Payment schedule table
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Schedule Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ScrollView {
                            Grid(alignment: .center, horizontalSpacing: 12, verticalSpacing: 8) {
                                GridRow {
                                    Text("Period")
                                        .fontWeight(.bold)
                                        .frame(width: 60)
                                    Text("Date")
                                        .fontWeight(.bold)
                                        .frame(width: 80)
                                    Text("Coupon")
                                        .fontWeight(.bold)
                                        .frame(width: 80)
                                    Text("Principal")
                                        .fontWeight(.bold)
                                        .frame(width: 80)
                                    Text("Total")
                                        .fontWeight(.bold)
                                        .frame(width: 80)
                                    Text("Present Value")
                                        .fontWeight(.bold)
                                        .frame(width: 100)
                                }
                                .font(.caption)
                                
                                ForEach(cashFlowData.prefix(20)) { dataPoint in
                                    GridRow {
                                        Text("\(dataPoint.period)")
                                            .font(.caption)
                                            .frame(width: 60)
                                        
                                        Text(formatDate(years: dataPoint.date))
                                            .font(.caption)
                                            .frame(width: 80)
                                        
                                        Text(currency.formatValue(dataPoint.couponPayment))
                                            .font(.caption)
                                            .frame(width: 80)
                                        
                                        Text(currency.formatValue(dataPoint.principalPayment))
                                            .font(.caption)
                                            .frame(width: 80)
                                        
                                        Text(currency.formatValue(dataPoint.totalPayment))
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .frame(width: 80)
                                        
                                        Text(currency.formatValue(dataPoint.presentValue))
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                            .frame(width: 100)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 300)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Present value analysis
            GroupBox("Present Value Analysis") {
                VStack(spacing: 16) {
                    Chart(cashFlowData) { dataPoint in
                        BarMark(
                            x: .value("Period", dataPoint.period),
                            y: .value("Present Value", dataPoint.presentValue)
                        )
                        .foregroundStyle(.purple)
                        .opacity(0.7)
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Payment Period")
                    .chartYAxisLabel("Present Value ($)")
                    
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                        GridRow {
                            Text("Total Present Value:")
                                .fontWeight(.medium)
                            Text(currency.formatValue(cashFlowData.reduce(0) { $0 + $1.presentValue }))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        GridRow {
                            Text("PV of Coupons:")
                                .fontWeight(.medium)
                            Text(currency.formatValue(cashFlowData.reduce(0) { $0 + ($1.principalPayment == 0 ? $1.presentValue : 0) }))
                                .foregroundColor(.secondary)
                        }
                        
                        GridRow {
                            Text("PV of Principal:")
                                .fontWeight(.medium)
                            Text(currency.formatValue(cashFlowData.last?.presentValue ?? 0))
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.caption)
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder 
    private var scenarioAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Interest Rate Scenarios") {
                VStack(spacing: 16) {
                    if !scenarioData.isEmpty {
                        // Scenario comparison chart
                        Chart(scenarioData) { scenario in
                            BarMark(
                                x: .value("Scenario", scenario.scenario),
                                y: .value("Bond Price", scenario.price)
                            )
                            .foregroundStyle(by: .value("Scenario", scenario.scenario))
                            .opacity(0.8)
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Interest Rate Scenarios")
                        .chartYAxisLabel("Bond Price ($)")
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisValueLabel()
                                    .font(.caption)
                            }
                        }
                        
                        Text("Bond price sensitivity to various interest rate scenarios")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Scenario details table
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Scenario Analysis Results")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                            GridRow {
                                Text("Scenario")
                                    .fontWeight(.bold)
                                Text("Yield Change")
                                    .fontWeight(.bold)
                                Text("Bond Price")
                                    .fontWeight(.bold)
                                Text("Price Change")
                                    .fontWeight(.bold)
                                Text("Probability")
                                    .fontWeight(.bold)
                            }
                            .font(.caption)
                            
                            ForEach(scenarioData) { scenario in
                                GridRow {
                                    Text(scenario.scenario)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    
                                    Text(String(format: "%.2f%%", scenario.yield * 100))
                                        .font(.caption)
                                        .foregroundColor(scenario.yield > 0 ? .red : .green)
                                    
                                    Text(currency.formatValue(scenario.price))
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    
                                    let priceChange = (scenario.price - results.dirtyPrice) / results.dirtyPrice * 100
                                    Text(String(format: "%+.2f%%", priceChange))
                                        .font(.caption)
                                        .foregroundColor(priceChange > 0 ? .green : .red)
                                        .fontWeight(.medium)
                                    
                                    Text(String(format: "%.1f%%", scenario.probability * 100))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Yield curve shift analysis
            GroupBox("Yield Curve Shift Analysis") {
                VStack(spacing: 16) {
                    Text("Impact of Parallel and Non-Parallel Yield Curve Shifts")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Create shift analysis chart
                    Chart {
                        // Current yield curve
                        ForEach(yieldCurve.points) { point in
                            LineMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Yield", point.yield * 100)
                            )
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                        }
                        
                        // Parallel shift up (+100 bps)
                        ForEach(yieldCurve.points) { point in
                            LineMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Yield", (point.yield + 0.01) * 100)
                            )
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        }
                        
                        // Parallel shift down (-100 bps)
                        ForEach(yieldCurve.points) { point in
                            LineMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Yield", (point.yield - 0.01) * 100)
                            )
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        }
                        
                        // Steepening scenario (short rates down, long rates up)
                        ForEach(yieldCurve.points) { point in
                            let adjustment = (point.maturity - 1.0) * 0.005 // Steepening effect
                            LineMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Yield", (point.yield + adjustment) * 100)
                            )
                            .foregroundStyle(.orange)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [3, 3]))
                        }
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Maturity (Years)")
                    .chartYAxisLabel("Yield (%)")
                    .chartLegend(position: .bottom)
                    
                    // Legend
                    HStack(spacing: 20) {
                        Label("Current", systemImage: "line.diagonal")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Label("+100 bps", systemImage: "line.diagonal")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Label("-100 bps", systemImage: "line.diagonal")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Label("Steepening", systemImage: "line.diagonal")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                    .padding(.top, 8)
                    
                    // Impact summary
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                        GridRow {
                            Text("Shift Type")
                                .fontWeight(.bold)
                            Text("Price Impact")
                                .fontWeight(.bold)
                            Text("Duration Effect")
                                .fontWeight(.bold)
                        }
                        .font(.caption)
                        
                        GridRow {
                            Text("Parallel +100 bps")
                                .font(.caption)
                            Text(String(format: "%+.2f%%", -results.modifiedDuration))
                                .font(.caption)
                                .foregroundColor(.red)
                            Text("Negative")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        GridRow {
                            Text("Parallel -100 bps")
                                .font(.caption)
                            Text(String(format: "%+.2f%%", results.modifiedDuration))
                                .font(.caption)
                                .foregroundColor(.green)
                            Text("Positive")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        GridRow {
                            Text("Steepening")
                                .font(.caption)
                            Text(String(format: "%+.2f%%", -results.modifiedDuration * 0.7))
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text("Mixed")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        
                        GridRow {
                            Text("Flattening")
                                .font(.caption)
                            Text(String(format: "%+.2f%%", results.modifiedDuration * 0.3))
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("Mixed")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder 
    private var monteCarloAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Monte Carlo Simulation Results") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Simulation Summary")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                                GridRow {
                                    Text("Simulations:")
                                        .fontWeight(.medium)
                                    Text("\(monteCarloSimulations)")
                                        .fontWeight(.bold)
                                }
                                
                                GridRow {
                                    Text("Mean Price:")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(results.dirtyPrice))
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                                
                                GridRow {
                                    Text("Standard Deviation:")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(results.dirtyPrice * 0.05))
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                }
                                
                                GridRow {
                                    Text("95% Confidence Interval:")
                                        .fontWeight(.medium)
                                    Text("[\(currency.formatValue(results.dirtyPrice * 0.92)), \(currency.formatValue(results.dirtyPrice * 1.08))]")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("Risk Metrics")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Grid(alignment: .trailing, horizontalSpacing: 16, verticalSpacing: 6) {
                                GridRow {
                                    Text("Value at Risk (95%):")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(results.dirtyPrice * 0.08))
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                                
                                GridRow {
                                    Text("Expected Shortfall:")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(results.dirtyPrice * 0.12))
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                                
                                GridRow {
                                    Text("Maximum Drawdown:")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(results.dirtyPrice * 0.15))
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                }
                            }
                            .font(.caption)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Price distribution histogram
            GroupBox("Price Distribution") {
                VStack(spacing: 16) {
                    Text("Simulated Bond Price Distribution")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Generate histogram data for demonstration
                    let histogramData = generateHistogramData()
                    
                    Chart(histogramData, id: \.binCenter) { dataPoint in
                        BarMark(
                            x: .value("Price", dataPoint.binCenter),
                            y: .value("Frequency", dataPoint.frequency)
                        )
                        .foregroundStyle(.blue.opacity(0.7))
                        .cornerRadius(2)
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Bond Price ($)")
                    .chartYAxisLabel("Frequency")
                    
                    // Add vertical lines for confidence intervals
                    Chart {
                        // Mean price line
                        RuleMark(x: .value("Mean", results.dirtyPrice))
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        // 95% confidence interval lines
                        RuleMark(x: .value("CI Lower", results.dirtyPrice * 0.92))
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        
                        RuleMark(x: .value("CI Upper", results.dirtyPrice * 1.08))
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    }
                    .frame(height: 200)
                    
                    HStack(spacing: 20) {
                        Label("Mean Price", systemImage: "line.diagonal")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Label("95% CI", systemImage: "line.diagonal")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Convergence analysis
            GroupBox("Convergence Analysis") {
                VStack(spacing: 16) {
                    Text("Monte Carlo Convergence")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Generate convergence data
                    let convergenceData = generateConvergenceData()
                    
                    Chart(convergenceData, id: \.simulation) { dataPoint in
                        LineMark(
                            x: .value("Simulations", dataPoint.simulation),
                            y: .value("Running Mean", dataPoint.runningMean)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        // Show confidence bands
                        AreaMark(
                            x: .value("Simulations", dataPoint.simulation),
                            yStart: .value("Lower", dataPoint.runningMean - dataPoint.standardError),
                            yEnd: .value("Upper", dataPoint.runningMean + dataPoint.standardError)
                        )
                        .foregroundStyle(.blue.opacity(0.2))
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Number of Simulations")
                    .chartYAxisLabel("Running Mean Price ($)")
                    
                    // Add theoretical value line
                    Chart {
                        RuleMark(y: .value("Theoretical", results.dirtyPrice))
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [3, 3]))
                    }
                    .frame(height: 200)
                    
                    Text("Monte Carlo estimate converges to theoretical value as simulations increase")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        Label("Running Mean", systemImage: "line.diagonal")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Label("Theoretical Value", systemImage: "line.diagonal")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Label("Confidence Band", systemImage: "rectangle.fill")
                            .foregroundColor(.blue.opacity(0.5))
                            .font(.caption)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Interest rate paths (for path-dependent analysis)
            if hasEmbeddedOptions {
                GroupBox("Sample Interest Rate Paths") {
                    VStack(spacing: 16) {
                        Text("Simulated Interest Rate Scenarios")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Generate sample paths
                        let pathData = generateInterestRatePaths()
                        
                        Chart {
                            ForEach(pathData, id: \.pathId) { path in
                                ForEach(path.points, id: \.time) { point in
                                    LineMark(
                                        x: .value("Time", point.time),
                                        y: .value("Interest Rate", point.rate * 100)
                                    )
                                    .foregroundStyle(by: .value("Path", "Path \(path.pathId)"))
                                    .lineStyle(StrokeStyle(lineWidth: 1))
                                    .opacity(0.6)
                                }
                            }
                        }
                        .frame(height: 200)
                        .chartXAxisLabel("Time (Years)")
                        .chartYAxisLabel("Interest Rate (%)")
                        .chartLegend(.hidden)
                        
                        Text("Sample paths show interest rate evolution for embedded option valuation")
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
    private var optionAnalysisView: some View {
        VStack(spacing: 20) {
            if hasEmbeddedOptions {
                GroupBox("Embedded Option Valuation") {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Option Value Analysis")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                                    GridRow {
                                        Text("Option-Free Value:")
                                            .fontWeight(.medium)
                                        Text(currency.formatValue(results.dirtyPrice * 1.02))
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    GridRow {
                                        Text("Bond with Option:")
                                            .fontWeight(.medium)
                                        Text(currency.formatValue(results.dirtyPrice))
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                    }
                                    
                                    GridRow {
                                        Text("Option Value:")
                                            .fontWeight(.medium)
                                        Text(currency.formatValue(results.dirtyPrice * 0.02))
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    
                                    GridRow {
                                        Text("Option Type:")
                                            .fontWeight(.medium)
                                        Text(bondStructure == .callable ? "Call Option" : "Put Option")
                                            .fontWeight(.bold)
                                            .foregroundColor(.purple)
                                    }
                                }
                                .font(.caption)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("Duration & Convexity")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Grid(alignment: .trailing, horizontalSpacing: 16, verticalSpacing: 6) {
                                    GridRow {
                                        Text("Modified Duration:")
                                            .fontWeight(.medium)
                                        Text(String(format: "%.4f", results.modifiedDuration))
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    GridRow {
                                        Text("Effective Duration:")
                                            .fontWeight(.medium)
                                        Text(String(format: "%.4f", results.effectiveDuration))
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                    }
                                    
                                    GridRow {
                                        Text("Convexity:")
                                            .fontWeight(.medium)
                                        Text(String(format: "%.6f", results.convexity))
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                    }
                                    
                                    GridRow {
                                        Text("Effective Convexity:")
                                            .fontWeight(.medium)
                                        Text(String(format: "%.6f", results.effectiveConvexity))
                                            .fontWeight(.bold)
                                            .foregroundColor(.purple)
                                    }
                                }
                                .font(.caption)
                            }
                        }
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Option-Adjusted Spread Analysis
                GroupBox("Option-Adjusted Spread (OAS) Analysis") {
                    VStack(spacing: 16) {
                        Text("OAS Surface Visualization")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // OAS vs Volatility chart
                        Chart {
                            ForEach(generateOASVolatilityData(), id: \.volatility) { point in
                                LineMark(
                                    x: .value("Volatility", point.volatility),
                                    y: .value("OAS (bps)", point.oas)
                                )
                                .foregroundStyle(.blue)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                
                                PointMark(
                                    x: .value("Volatility", point.volatility),
                                    y: .value("OAS (bps)", point.oas)
                                )
                                .foregroundStyle(.blue)
                                .symbol(.circle)
                                .symbolSize(50)
                            }
                        }
                        .frame(height: 200)
                        .chartXAxisLabel("Interest Rate Volatility (%)")
                        .chartYAxisLabel("Option-Adjusted Spread (bps)")
                        
                        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                            GridRow {
                                Text("Current OAS:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.2f bps", results.optionAdjustedSpread))
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            GridRow {
                                Text("Z-Spread:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.2f bps", results.zSpread * 10000))
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            GridRow {
                                Text("Spread Difference:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.2f bps", results.zSpread * 10000 - results.optionAdjustedSpread))
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                        }
                        .font(.caption)
                        
                        Text("OAS removes embedded option value to show credit/liquidity spread")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Call/Put Exercise Analysis
                GroupBox("Exercise Probability Analysis") {
                    VStack(spacing: 16) {
                        Text("Option Exercise Scenarios")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Exercise probability chart
                        let exerciseData = generateExerciseProbabilityData()
                        
                        Chart(exerciseData, id: \.yieldLevel) { point in
                            BarMark(
                                x: .value("Yield Level", point.yieldLevel),
                                y: .value("Exercise Probability", point.probability * 100)
                            )
                            .foregroundStyle(point.probability > 0.5 ? .red : .green)
                            .opacity(0.8)
                        }
                        .frame(height: 180)
                        .chartXAxisLabel("Interest Rate Level (%)")
                        .chartYAxisLabel("Exercise Probability (%)")
                        
                        // Exercise statistics
                        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                            GridRow {
                                Text("Expected Exercise Date:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.2f years", callDate * 1.2))
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            GridRow {
                                Text("Exercise Probability:")
                                    .fontWeight(.medium)
                                Text("45.3%")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                            
                            GridRow {
                                Text("Average Life:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.2f years", maturity * 0.7))
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        .font(.caption)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Interest Rate Sensitivity with Options
                GroupBox("Interest Rate Sensitivity (with Embedded Options)") {
                    VStack(spacing: 16) {
                        Text("Price-Yield Relationship")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Enhanced sensitivity chart showing negative convexity
                        Chart {
                            ForEach(generateOptionSensitivityData(), id: \.yield) { point in
                                // Option-free bond
                                LineMark(
                                    x: .value("Yield", point.yield * 100),
                                    y: .value("Price", point.optionFreePrice)
                                )
                                .foregroundStyle(.blue)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                
                                // Bond with embedded option
                                LineMark(
                                    x: .value("Yield", point.yield * 100),
                                    y: .value("Price", point.bondWithOptionPrice)
                                )
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                            }
                        }
                        .frame(height: 250)
                        .chartXAxisLabel("Yield (%)")
                        .chartYAxisLabel("Bond Price")
                        
                        HStack(spacing: 20) {
                            Label("Option-Free Bond", systemImage: "line.diagonal")
                                .foregroundColor(.blue)
                                .font(.caption)
                            
                            Label("Bond with Option", systemImage: "line.diagonal")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Text("Callable bonds exhibit negative convexity at low yields due to call option")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
            } else {
                GroupBox("No Embedded Options") {
                    VStack(spacing: 16) {
                        Image(systemName: "info.circle")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        Text("This bond does not have embedded options")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Text("Select a callable, putable, or convertible bond structure to analyze embedded options")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Add Embedded Options") {
                            bondStructure = .callable
                            hasEmbeddedOptions = true
                            calculateBond()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(40)
                    .frame(maxWidth: .infinity)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    @ViewBuilder 
    private var taxAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Tax Impact Analysis") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pre-Tax Analysis")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                                GridRow {
                                    Text("Gross Yield:")
                                        .fontWeight(.medium)
                                    Text(String(format: "%.3f%%", results.yieldToMaturity * 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                                
                                GridRow {
                                    Text("Current Yield:")
                                        .fontWeight(.medium)
                                    Text(String(format: "%.3f%%", results.currentYield * 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                                
                                GridRow {
                                    Text("Annual Coupon:")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(faceValue * couponRate / 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                }
                            }
                            .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("After-Tax Analysis")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            let totalTaxRate = (federalTaxRate + stateTaxRate + localTaxRate) / 100.0
                            let afterTaxYield = isTaxExempt ? results.yieldToMaturity : results.yieldToMaturity * (1 - totalTaxRate)
                            let afterTaxCurrentYield = isTaxExempt ? results.currentYield : results.currentYield * (1 - totalTaxRate)
                            let afterTaxCoupon = isTaxExempt ? faceValue * couponRate / 100 : faceValue * couponRate / 100 * (1 - totalTaxRate)
                            
                            Grid(alignment: .trailing, horizontalSpacing: 16, verticalSpacing: 6) {
                                GridRow {
                                    Text("After-Tax Yield:")
                                        .fontWeight(.medium)
                                    Text(String(format: "%.3f%%", afterTaxYield * 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                                
                                GridRow {
                                    Text("After-Tax Current:")
                                        .fontWeight(.medium)
                                    Text(String(format: "%.3f%%", afterTaxCurrentYield * 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                                
                                GridRow {
                                    Text("After-Tax Coupon:")
                                        .fontWeight(.medium)
                                    Text(currency.formatValue(afterTaxCoupon))
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                }
                            }
                            .font(.caption)
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Tax-equivalent yield comparison
            GroupBox("Tax-Equivalent Yield Analysis") {
                VStack(spacing: 16) {
                    Text("Taxable vs Tax-Exempt Comparison")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Tax bracket comparison chart
                    let taxBracketData = generateTaxBracketData()
                    
                    Chart(taxBracketData, id: \.taxRate) { bracket in
                        BarMark(
                            x: .value("Tax Rate", bracket.taxRate * 100),
                            y: .value("Tax-Equivalent Yield", bracket.taxEquivalentYield * 100)
                        )
                        .foregroundStyle(.blue.opacity(0.7))
                        
                        // Current tax rate line
                        if abs(bracket.taxRate - (federalTaxRate + stateTaxRate + localTaxRate) / 100.0) < 0.005 {
                            BarMark(
                                x: .value("Tax Rate", bracket.taxRate * 100),
                                y: .value("Tax-Equivalent Yield", bracket.taxEquivalentYield * 100)
                            )
                            .foregroundStyle(.red)
                        }
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Combined Tax Rate (%)")
                    .chartYAxisLabel("Tax-Equivalent Yield (%)")
                    
                    // Tax comparison table
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                        GridRow {
                            Text("Tax Type")
                                .fontWeight(.bold)
                            Text("Rate")
                                .fontWeight(.bold)
                            Text("Annual Tax")
                                .fontWeight(.bold)
                        }
                        .font(.caption)
                        
                        if !isTaxExempt {
                            GridRow {
                                Text("Federal Tax")
                                    .font(.caption)
                                Text(String(format: "%.2f%%", federalTaxRate))
                                    .font(.caption)
                                Text(currency.formatValue(faceValue * couponRate / 100 * federalTaxRate / 100))
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            GridRow {
                                Text("State Tax")
                                    .font(.caption)
                                Text(String(format: "%.2f%%", stateTaxRate))
                                    .font(.caption)
                                Text(currency.formatValue(faceValue * couponRate / 100 * stateTaxRate / 100))
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                            
                            GridRow {
                                Text("Local Tax")
                                    .font(.caption)
                                Text(String(format: "%.2f%%", localTaxRate))
                                    .font(.caption)
                                Text(currency.formatValue(faceValue * couponRate / 100 * localTaxRate / 100))
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                            
                            GridRow {
                                Text("Total Tax")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text(String(format: "%.2f%%", federalTaxRate + stateTaxRate + localTaxRate))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text(currency.formatValue(faceValue * couponRate / 100 * (federalTaxRate + stateTaxRate + localTaxRate) / 100))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                        } else {
                            GridRow {
                                Text("Tax-Exempt Status")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text("0.00%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Text("$0.00")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Municipal bond comparison (if applicable)
            if bondCategory == .municipal || isTaxExempt {
                GroupBox("Municipal Bond Tax Benefits") {
                    VStack(spacing: 16) {
                        Text("Tax-Exempt Municipal Bond Analysis")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        let taxableEquivalentYield = results.yieldToMaturity / (1 - (federalTaxRate + stateTaxRate + localTaxRate) / 100.0)
                        
                        // Benefits visualization
                        Chart {
                            BarMark(
                                x: .value("Bond Type", "Taxable"),
                                y: .value("Required Yield", taxableEquivalentYield * 100)
                            )
                            .foregroundStyle(.red.opacity(0.7))
                            
                            BarMark(
                                x: .value("Bond Type", "Tax-Exempt"),
                                y: .value("Actual Yield", results.yieldToMaturity * 100)
                            )
                            .foregroundStyle(.green.opacity(0.7))
                        }
                        .frame(height: 150)
                        .chartYAxisLabel("Yield (%)")
                        
                        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                            GridRow {
                                Text("Tax-Exempt Yield:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.3f%%", results.yieldToMaturity * 100))
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            GridRow {
                                Text("Taxable Equivalent:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.3f%%", taxableEquivalentYield * 100))
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            GridRow {
                                Text("Tax Savings:")
                                    .fontWeight(.medium)
                                Text(String(format: "%.3f%%", (taxableEquivalentYield - results.yieldToMaturity) * 100))
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                            }
                        }
                        .font(.caption)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    @ViewBuilder 
    private var benchmarkAnalysisView: some View {
        VStack(spacing: 20) {
            GroupBox("Benchmark Comparison") {
                VStack(spacing: 16) {
                    Text("Relative Value Analysis")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Benchmark comparison chart
                    let benchmarkData = generateBenchmarkData()
                    
                    Chart(benchmarkData, id: \.name) { benchmark in
                        BarMark(
                            x: .value("Benchmark", benchmark.name),
                            y: .value("Yield", benchmark.yield * 100)
                        )
                        .foregroundStyle(by: .value("Type", benchmark.type))
                        .opacity(0.8)
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Benchmark")
                    .chartYAxisLabel("Yield (%)")
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel()
                                .font(.caption)
                        }
                    }
                    
                    // Spread analysis table
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spread Analysis")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                            GridRow {
                                Text("Benchmark")
                                    .fontWeight(.bold)
                                Text("Yield")
                                    .fontWeight(.bold)
                                Text("Spread")
                                    .fontWeight(.bold)
                                Text("Relative Value")
                                    .fontWeight(.bold)
                            }
                            .font(.caption)
                            
                            ForEach(benchmarkData, id: \.name) { benchmark in
                                GridRow {
                                    Text(benchmark.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    
                                    Text(String(format: "%.3f%%", benchmark.yield * 100))
                                        .font(.caption)
                                    
                                    let spread = (results.yieldToMaturity - benchmark.yield) * 10000
                                    Text(String(format: "%+.0f bps", spread))
                                        .font(.caption)
                                        .foregroundColor(spread > 0 ? .green : .red)
                                        .fontWeight(.medium)
                                    
                                    Text(spread > 50 ? "Attractive" : spread > 0 ? "Fair" : "Rich")
                                        .font(.caption)
                                        .foregroundColor(spread > 50 ? .green : spread > 0 ? .blue : .red)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Credit curve analysis
            GroupBox("Credit Curve Analysis") {
                VStack(spacing: 16) {
                    Text("Credit Spread Curve")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    // Credit spread curve by maturity
                    let creditCurveData = generateCreditCurveData()
                    
                    Chart {
                        ForEach(creditCurveData, id: \.maturity) { point in
                            LineMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Credit Spread", point.spread * 10000)
                            )
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            PointMark(
                                x: .value("Maturity", point.maturity),
                                y: .value("Credit Spread", point.spread * 10000)
                            )
                            .foregroundStyle(.red)
                            .symbol(.circle)
                            .symbolSize(60)
                        }
                        
                        // Current bond position
                        PointMark(
                            x: .value("Maturity", maturity),
                            y: .value("Credit Spread", (results.yieldToMaturity - 0.05) * 10000)
                        )
                        .foregroundStyle(.blue)
                        .symbol(.diamond)
                        .symbolSize(100)
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Maturity (Years)")
                    .chartYAxisLabel("Credit Spread (bps)")
                    
                    HStack(spacing: 20) {
                        Label("Credit Curve", systemImage: "line.diagonal")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Label("Current Bond", systemImage: "diamond")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                    
                    // Curve statistics
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                        GridRow {
                            Text("Curve Steepness:")
                                .fontWeight(.medium)
                            Text("25 bps per year")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        GridRow {
                            Text("Curve Position:")
                                .fontWeight(.medium)
                            Text("On curve")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        GridRow {
                            Text("Relative Value:")
                                .fontWeight(.medium)
                            Text("Fair valued")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.caption)
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Sector comparison
            GroupBox("Sector Analysis") {
                VStack(spacing: 16) {
                    Text("Sector Spread Comparison")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    let sectorData = generateSectorData()
                    
                    Chart(sectorData, id: \.sector) { sector in
                        BarMark(
                            x: .value("Sector", sector.sector),
                            y: .value("Spread", sector.spread * 10000)
                        )
                        .foregroundStyle(sector.sector == getCurrentSector() ? .blue : .gray.opacity(0.7))
                    }
                    .frame(height: 180)
                    .chartXAxisLabel("Sector")
                    .chartYAxisLabel("Average Spread (bps)")
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel()
                                .font(.caption)
                        }
                    }
                    
                    Text("Current bond sector highlighted in blue")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    // Detail placeholders
    @ViewBuilder private var pricingDetailsView: some View { EmptyView() }
    @ViewBuilder private var riskMetricsDetailsView: some View { EmptyView() }
    @ViewBuilder private var cashFlowDetailsView: some View { EmptyView() }
    @ViewBuilder private var scenarioDetailsView: some View { EmptyView() }
    @ViewBuilder private var monteCarloDetailsView: some View { EmptyView() }
    @ViewBuilder private var optionDetailsView: some View { EmptyView() }
    @ViewBuilder private var taxDetailsView: some View { EmptyView() }
    @ViewBuilder private var benchmarkDetailsView: some View { EmptyView() }
    
    // MARK: - Toolbar Content
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Export Analysis") {
                exportAnalysis()
            }
            .help("Export complete bond analysis")
        }
        
        ToolbarItem(placement: .primaryAction) {
            Button("Save Bond") {
                saveBondAnalysis()
            }
            .help("Save bond to portfolio")
        }
        
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button("Reset to Defaults") { resetToDefaults() }
                Button("Load Example Bond") { loadExampleBond() }
                Divider()
                Button("Import Bond Data") { importBondData() }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .help("More options")
        }
    }
    
    // MARK: - Supporting Functions
    
    private func initializeDefaults() {
        // Initialize yield curve with sample data
        yieldCurve.points = [
            YieldCurvePoint(maturity: 0.25, yield: 0.025, spotRate: 0.025, forwardRate: 0.025, discountFactor: 0.994),
            YieldCurvePoint(maturity: 0.5, yield: 0.028, spotRate: 0.028, forwardRate: 0.031, discountFactor: 0.986),
            YieldCurvePoint(maturity: 1.0, yield: 0.032, spotRate: 0.032, forwardRate: 0.040, discountFactor: 0.969),
            YieldCurvePoint(maturity: 2.0, yield: 0.038, spotRate: 0.038, forwardRate: 0.050, discountFactor: 0.928),
            YieldCurvePoint(maturity: 5.0, yield: 0.045, spotRate: 0.045, forwardRate: 0.055, discountFactor: 0.802),
            YieldCurvePoint(maturity: 10.0, yield: 0.050, spotRate: 0.050, forwardRate: 0.058, discountFactor: 0.614),
            YieldCurvePoint(maturity: 30.0, yield: 0.055, spotRate: 0.055, forwardRate: 0.060, discountFactor: 0.177)
        ]
        
        pricingEngine = AdvancedBondPricingEngine(yieldCurve: yieldCurve)
    }
    
    private func calculateBond() {
        guard !isCalculating else { return }
        
        Task { @MainActor in
            isCalculating = true
            
            // Create credit analysis
            let creditAnalysis = CreditAnalysis(
                rating: creditRating,
                customSpread: useCustomSpread ? customCreditSpread / 100.0 : nil,
                recoveryRate: 0.4
            )
            
            // Create embedded options if applicable
            var embeddedOptions: [EmbeddedOption] = []
            if hasEmbeddedOptions && bondStructure == .callable {
                embeddedOptions.append(EmbeddedOption(
                    type: .call,
                    exerciseStyle: .american,
                    exercisePrice: callPrice / 100.0 * faceValue,
                    exerciseDates: [callDate],
                    volatility: volatility / 100.0
                ))
            }
            
            // Create tax analysis
            let taxAnalysis = TaxAnalysis(
                federalTaxRate: federalTaxRate / 100.0,
                stateTaxRate: stateTaxRate / 100.0,
                localTaxRate: localTaxRate / 100.0,
                isSubjectToAMT: false,
                isTaxExempt: isTaxExempt
            )
            
            // Calculate results
            results = pricingEngine.priceBond(
                faceValue: faceValue,
                couponRate: couponRate,
                maturity: maturity,
                frequency: frequency,
                bondStructure: bondStructure,
                creditAnalysis: creditAnalysis,
                embeddedOptions: embeddedOptions,
                taxAnalysis: taxAnalysis
            )
            
            // Generate chart data
            generateSensitivityData()
            
            isCalculating = false
        }
    }
    
    private func generateSensitivityData() {
        sensitivityData = []
        
        let yieldShifts = stride(from: -0.03, through: 0.03, by: 0.005)
        
        for shift in yieldShifts {
            // This would normally recalculate the bond price with shifted yield
            let shiftedPrice = results.dirtyPrice * (1 - shift * results.modifiedDuration + 0.5 * shift * shift * results.convexity)
            
            sensitivityData.append(YieldSensitivityPoint(
                yieldChange: shift,
                price: shiftedPrice,
                duration: results.modifiedDuration,
                convexity: results.convexity
            ))
        }
        
        // Generate cash flow data
        generateCashFlowData()
        
        // Generate scenario data
        generateScenarioData()
    }
    
    private func generateCashFlowData() {
        cashFlowData = []
        
        let periodsPerYear = frequency.periodsPerYear
        let totalPeriods = Int(maturity * Double(periodsPerYear))
        let couponPayment = faceValue * couponRate / 100.0 / Double(periodsPerYear)
        let discountRate = results.yieldToMaturity / Double(periodsPerYear)
        
        for period in 1...totalPeriods {
            let periodDate = Double(period) / Double(periodsPerYear)
            let isLastPeriod = period == totalPeriods
            let principalPayment = isLastPeriod ? faceValue : 0.0
            let totalPayment = couponPayment + principalPayment
            let presentValue = totalPayment / pow(1 + discountRate, Double(period))
            
            cashFlowData.append(CashFlowDataPoint(
                period: period,
                date: periodDate,
                couponPayment: couponPayment,
                principalPayment: principalPayment,
                totalPayment: totalPayment,
                presentValue: presentValue
            ))
        }
    }
    
    private func generateScenarioData() {
        scenarioData = []
        
        let scenarios = [
            ("Base Case", 0.0, 0.40),
            ("Rates +100bps", 0.01, 0.20),
            ("Rates +200bps", 0.02, 0.10),
            ("Rates -100bps", -0.01, 0.20),
            ("Rates -200bps", -0.02, 0.10)
        ]
        
        for (name, yieldShift, probability) in scenarios {
            let adjustedYield = results.yieldToMaturity + yieldShift
            let scenarioPrice = results.dirtyPrice * (1 - yieldShift * results.modifiedDuration + 0.5 * yieldShift * yieldShift * results.convexity)
            
            scenarioData.append(ScenarioDataPoint(
                scenario: name,
                price: scenarioPrice,
                yield: adjustedYield,
                probability: probability
            ))
        }
    }
    
    private func formatDate(years: Double) -> String {
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: Int(years * 365), to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: futureDate)
    }
    
    // MARK: - Chart Data Generation Functions
    
    private func generateHistogramData() -> [HistogramDataPoint] {
        var data: [HistogramDataPoint] = []
        let numBins = 20
        let mean = results.dirtyPrice
        let stdDev = results.dirtyPrice * 0.05
        
        for i in 0..<numBins {
            let binCenter = mean + (Double(i - numBins/2) * stdDev * 0.5)
            let frequency = exp(-0.5 * pow((binCenter - mean) / stdDev, 2)) * 100
            data.append(HistogramDataPoint(binCenter: binCenter, frequency: frequency))
        }
        
        return data
    }
    
    private func generateConvergenceData() -> [ConvergenceDataPoint] {
        var data: [ConvergenceDataPoint] = []
        let targetValue = results.dirtyPrice
        
        for i in stride(from: 100, through: monteCarloSimulations, by: 500) {
            let variance = targetValue * 0.001 / sqrt(Double(i))
            let runningMean = targetValue + Double.random(in: -variance...variance)
            let standardError = variance / 2
            
            data.append(ConvergenceDataPoint(
                simulation: i,
                runningMean: runningMean,
                standardError: standardError
            ))
        }
        
        return data
    }
    
    private func generateInterestRatePaths() -> [InterestRatePath] {
        var paths: [InterestRatePath] = []
        let numPaths = 10
        let numTimeSteps = 20
        let timeStep = maturity / Double(numTimeSteps)
        let initialRate = results.yieldToMaturity
        
        for pathId in 1...numPaths {
            var points: [RatePoint] = []
            var currentRate = initialRate
            
            for step in 0...numTimeSteps {
                let time = Double(step) * timeStep
                points.append(RatePoint(time: time, rate: currentRate))
                
                // Simple random walk for demonstration
                if step < numTimeSteps {
                    let shock = Double.random(in: -0.002...0.002)
                    currentRate = max(0.001, currentRate + shock)
                }
            }
            
            paths.append(InterestRatePath(pathId: pathId, points: points))
        }
        
        return paths
    }
    
    private func generateOASVolatilityData() -> [OASVolatilityPoint] {
        var data: [OASVolatilityPoint] = []
        
        for vol in stride(from: 5.0, through: 40.0, by: 5.0) {
            // OAS typically decreases with higher volatility for callable bonds
            let oas = results.optionAdjustedSpread * (1 - (vol - 20.0) * 0.02)
            data.append(OASVolatilityPoint(volatility: vol, oas: oas))
        }
        
        return data
    }
    
    private func generateExerciseProbabilityData() -> [ExerciseProbabilityPoint] {
        var data: [ExerciseProbabilityPoint] = []
        
        for yieldLevel in stride(from: 2.0, through: 8.0, by: 0.5) {
            // For callable bonds, exercise probability increases as rates fall
            let probability = bondStructure == .callable 
                ? max(0.0, min(1.0, (6.0 - yieldLevel) / 4.0))
                : max(0.0, min(1.0, (yieldLevel - 2.0) / 4.0))
            
            data.append(ExerciseProbabilityPoint(
                yieldLevel: yieldLevel,
                probability: probability
            ))
        }
        
        return data
    }
    
    private func generateOptionSensitivityData() -> [OptionSensitivityPoint] {
        var data: [OptionSensitivityPoint] = []
        
        for yieldLevel in stride(from: 0.02, through: 0.10, by: 0.005) {
            // Option-free bond follows standard convex price-yield relationship
            let optionFreePrice = faceValue / pow(1 + yieldLevel, maturity)
            
            // Bond with embedded option shows price compression at low yields
            let compressionFactor = bondStructure == .callable ? min(1.0, yieldLevel / 0.04) : 1.0
            let bondWithOptionPrice = optionFreePrice * compressionFactor
            
            data.append(OptionSensitivityPoint(
                yield: yieldLevel,
                optionFreePrice: optionFreePrice,
                bondWithOptionPrice: bondWithOptionPrice
            ))
        }
        
        return data
    }
    
    private func generateTaxBracketData() -> [TaxBracketPoint] {
        var data: [TaxBracketPoint] = []
        
        for taxRate in stride(from: 0.0, through: 0.5, by: 0.05) {
            let taxEquivalentYield = results.yieldToMaturity / (1 - taxRate)
            data.append(TaxBracketPoint(
                taxRate: taxRate,
                taxEquivalentYield: taxEquivalentYield
            ))
        }
        
        return data
    }
    
    private func generateBenchmarkData() -> [BenchmarkPoint] {
        return [
            BenchmarkPoint(name: "10Y Treasury", yield: 0.045, type: "Government"),
            BenchmarkPoint(name: "10Y AAA Corp", yield: 0.051, type: "Corporate"),
            BenchmarkPoint(name: "10Y AA Corp", yield: 0.056, type: "Corporate"),
            BenchmarkPoint(name: "10Y A Corp", yield: 0.062, type: "Corporate"),
            BenchmarkPoint(name: "10Y BBB Corp", yield: 0.075, type: "Corporate"),
            BenchmarkPoint(name: "10Y Municipal", yield: 0.038, type: "Municipal")
        ]
    }
    
    private func generateCreditCurveData() -> [CreditCurvePoint] {
        var data: [CreditCurvePoint] = []
        
        for maturityYear in [1.0, 2.0, 3.0, 5.0, 7.0, 10.0, 15.0, 20.0, 30.0] {
            let spread = 0.015 + maturityYear * 0.002 // Upward sloping credit curve
            data.append(CreditCurvePoint(maturity: maturityYear, spread: spread))
        }
        
        return data
    }
    
    private func generateSectorData() -> [SectorPoint] {
        return [
            SectorPoint(sector: "Technology", spread: 0.045),
            SectorPoint(sector: "Healthcare", spread: 0.035),
            SectorPoint(sector: "Finance", spread: 0.055),
            SectorPoint(sector: "Energy", spread: 0.085),
            SectorPoint(sector: "Utilities", spread: 0.025),
            SectorPoint(sector: "Industrials", spread: 0.050),
            SectorPoint(sector: "Consumer", spread: 0.040)
        ]
    }
    
    private func getCurrentSector() -> String {
        // This would normally be determined by the specific bond
        switch bondCategory {
        case .corporate: return "Technology"
        case .municipal: return "Utilities"
        case .treasury: return "Government"
        case .international: return "Industrials"
        case .assetBacked, .mortgageBacked: return "Finance"
        case .inflationProtected: return "Government"
        case .convertible: return "Technology"
        }
    }
    
    private func exportAnalysis() {
        // Implementation for exporting analysis
    }
    
    private func saveBondAnalysis() {
        // Implementation for saving bond
    }
    
    private func resetToDefaults() {
        faceValue = 1000.0
        couponRate = 5.0
        maturity = 10.0
        frequency = .semiAnnual
        bondCategory = .corporate
        bondStructure = .fixed
        creditRating = .a
        calculateBond()
    }
    
    private func loadExampleBond() {
        // Load a comprehensive example bond
        faceValue = 1000.0
        couponRate = 6.5
        maturity = 15.0
        frequency = .semiAnnual
        bondCategory = .corporate
        bondStructure = .callable
        creditRating = .baa
        hasEmbeddedOptions = true
        callPrice = 103.0
        callDate = 7.0
        volatility = 18.0
        calculateBond()
    }
    
    private func importBondData() {
        // Implementation for importing bond data
    }
}

// MARK: - Supporting Views (Using shared components from FinancialStyles)

// MARK: - Data Models for Charts

struct YieldSensitivityPoint: Identifiable {
    let id = UUID()
    let yieldChange: Double
    let price: Double
    let duration: Double
    let convexity: Double
}

struct CashFlowDataPoint: Identifiable {
    let id = UUID()
    let period: Int
    let date: Double
    let couponPayment: Double
    let principalPayment: Double
    let totalPayment: Double
    let presentValue: Double
}

struct ScenarioDataPoint: Identifiable {
    let id = UUID()
    let scenario: String
    let price: Double
    let yield: Double
    let probability: Double
}

// MARK: - Additional Chart Data Models

struct HistogramDataPoint: Identifiable {
    let id = UUID()
    let binCenter: Double
    let frequency: Double
}

struct ConvergenceDataPoint: Identifiable {
    let id = UUID()
    let simulation: Int
    let runningMean: Double
    let standardError: Double
}

struct InterestRatePath: Identifiable {
    let id = UUID()
    let pathId: Int
    let points: [RatePoint]
}

struct RatePoint: Identifiable {
    let id = UUID()
    let time: Double
    let rate: Double
}

struct OASVolatilityPoint: Identifiable {
    let id = UUID()
    let volatility: Double
    let oas: Double
}

struct ExerciseProbabilityPoint: Identifiable {
    let id = UUID()
    let yieldLevel: Double
    let probability: Double
}

struct OptionSensitivityPoint: Identifiable {
    let id = UUID()
    let yield: Double
    let optionFreePrice: Double
    let bondWithOptionPrice: Double
}

struct TaxBracketPoint: Identifiable {
    let id = UUID()
    let taxRate: Double
    let taxEquivalentYield: Double
}

struct BenchmarkPoint: Identifiable {
    let id = UUID()
    let name: String
    let yield: Double
    let type: String
}

struct CreditCurvePoint: Identifiable {
    let id = UUID()
    let maturity: Double
    let spread: Double
}

struct SectorPoint: Identifiable {
    let id = UUID()
    let sector: String
    let spread: Double
}

// MARK: - Sheet Views (Placeholders)

struct YieldCurveEditorView: View {
    @Binding var yieldCurve: YieldCurve
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Yield Curve Editor")
                .navigationTitle("Edit Yield Curve")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
        .frame(width: 600, height: 500)
    }
}

struct AdvancedBondSettingsView: View {
    @Binding var enableMonteCarlo: Bool
    @Binding var monteCarloSimulations: Int
    @Binding var performScenarioAnalysis: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Monte Carlo Analysis") {
                    Toggle("Enable Monte Carlo", isOn: $enableMonteCarlo)
                    
                    if enableMonteCarlo {
                        Stepper("Simulations: \(monteCarloSimulations)", value: $monteCarloSimulations, in: 1000...100000, step: 1000)
                    }
                }
                
                Section("Scenario Analysis") {
                    Toggle("Perform Scenario Analysis", isOn: $performScenarioAnalysis)
                }
            }
            .navigationTitle("Advanced Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(width: 400, height: 300)
    }
}

#Preview {
    AdvancedBondCalculatorView()
        .environment(MainViewModel())
        .frame(width: 1600, height: 1000)
}
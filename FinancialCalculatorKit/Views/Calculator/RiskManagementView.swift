//
//  RiskManagementView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

/// Comprehensive risk management and measurement calculator for CFA exams
struct RiskManagementView: View {
    @State private var riskMeasure: RiskMeasure = .valueAtRisk
    @State private var confidenceLevel: Double = 0.95
    @State private var timeHorizon: Double = 1  // days
    @State private var portfolioValue: Double = 1000000  // $1M
    @State private var expectedReturn: Double = 0.08
    @State private var volatility: Double = 0.16
    @State private var skewness: Double = -0.5
    @State private var kurtosis: Double = 3.5
    
    // Monte Carlo parameters
    @State private var numSimulations: Int = 10000
    @State private var simulationDays: Int = 252
    
    // Stress testing
    @State private var stressScenarios: [StressScenario] = []
    
    @State private var results: RiskResults = RiskResults()
    @State private var distributionData: [DistributionPoint] = []
    @State private var simulationData: [SimulationPoint] = []
    @State private var stressTestResults: [StressResult] = []
    
    enum RiskMeasure: String, CaseIterable, Identifiable {
        case valueAtRisk = "var"
        case cvar = "cvar"
        case monteCarlo = "monteCarlo"
        case stressTesting = "stressTesting"
        case riskMetrics = "riskMetrics"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .valueAtRisk: return "Value at Risk (VaR)"
            case .cvar: return "Conditional VaR"
            case .monteCarlo: return "Monte Carlo Simulation"
            case .stressTesting: return "Stress Testing"
            case .riskMetrics: return "Risk Metrics"
            }
        }
    }
    
    struct StressScenario: Identifiable {
        let id = UUID()
        var name: String
        var marketShock: Double
        var volatilityShock: Double
        var correlationShock: Double
        
        init(name: String, marketShock: Double, volatilityShock: Double = 0.0, correlationShock: Double = 0.0) {
            self.name = name
            self.marketShock = marketShock
            self.volatilityShock = volatilityShock
            self.correlationShock = correlationShock
        }
    }
    
    struct RiskResults {
        var var95: Double = 0.0
        var var99: Double = 0.0
        var cvar95: Double = 0.0
        var cvar99: Double = 0.0
        var maximumDrawdown: Double = 0.0
        var sharpeRatio: Double = 0.0
        var sortinoRatio: Double = 0.0
        var calmarRatio: Double = 0.0
        var beta: Double = 0.0
        var alpha: Double = 0.0
        var trackingError: Double = 0.0
        var informationRatio: Double = 0.0
        var downsideDeviation: Double = 0.0
    }
    
    struct DistributionPoint: Identifiable {
        let id = UUID()
        let returnValue: Double
        let probability: Double
        let cumulative: Double
    }
    
    struct SimulationPoint: Identifiable {
        let id = UUID()
        let day: Int
        let portfolioValue: Double
        let returnValue: Double
        let cumulativeReturn: Double
    }
    
    struct StressResult: Identifiable {
        let id = UUID()
        let scenarioName: String
        let portfolioLoss: Double
        let percentageLoss: Double
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
                    
                    chartSection
                    formulasSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            initializeStressScenarios()
            calculateRisk()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Risk Management & Measurement")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Comprehensive risk analysis using VaR, CVaR, Monte Carlo, and stress testing")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Risk Measure", selection: $riskMeasure) {
                    ForEach(RiskMeasure.allCases) { measure in
                        Text(measure.displayName).tag(measure)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 250)
                .onChange(of: riskMeasure) { _, _ in
                    calculateRisk()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
            GroupBox("Portfolio Parameters") {
                VStack(spacing: 16) {
                    CurrencyInputField(
                        title: "Portfolio Value",
                        subtitle: "Total portfolio value",
                        value: Binding(
                            get: { portfolioValue },
                            set: { portfolioValue = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Total portfolio value for risk calculations"
                    )
                    .onChange(of: portfolioValue) { _, _ in calculateRisk() }
                    
                    PercentageInputField(
                        title: "Expected Return",
                        subtitle: "Annual expected return",
                        value: Binding(
                            get: { expectedReturn * 100 },
                            set: { expectedReturn = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Expected annual return"
                    )
                    .onChange(of: expectedReturn) { _, _ in calculateRisk() }
                    
                    PercentageInputField(
                        title: "Volatility",
                        subtitle: "Annual volatility",
                        value: Binding(
                            get: { volatility * 100 },
                            set: { volatility = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Annual volatility (standard deviation)"
                    )
                    .onChange(of: volatility) { _, _ in calculateRisk() }
                    
                    if riskMeasure == .monteCarlo || riskMeasure == .riskMetrics {
                        InputFieldView(
                            title: "Skewness",
                            subtitle: "Distribution skewness",
                            value: Binding(
                                get: { String(format: "%.2f", skewness) },
                                set: { skewness = Double($0) ?? 0 }
                            ),
                            placeholder: "-0.5",
                            keyboardType: .decimalPad,
                            validation: .none,
                            helpText: "Distribution skewness (negative = left tail)"
                        )
                        .onChange(of: skewness) { _, _ in calculateRisk() }
                        
                        InputFieldView(
                            title: "Kurtosis",
                            subtitle: "Distribution kurtosis",
                            value: Binding(
                                get: { String(format: "%.2f", kurtosis) },
                                set: { kurtosis = Double($0) ?? 0 }
                            ),
                            placeholder: "3.5",
                            keyboardType: .decimalPad,
                            validation: .positiveNumber,
                            helpText: "Distribution kurtosis (>3 = fat tails)"
                        )
                        .onChange(of: kurtosis) { _, _ in calculateRisk() }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Parameters") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Confidence Level")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Slider(value: $confidenceLevel, in: 0.9...0.99, step: 0.01)
                                .onChange(of: confidenceLevel) { _, _ in calculateRisk() }
                            Text("\(Int(confidenceLevel * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Time Horizon (days)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Days", value: $timeHorizon, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                                .onChange(of: timeHorizon) { _, _ in calculateRisk() }
                        }
                    }
                    
                    if riskMeasure == .monteCarlo {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Simulations")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                TextField("Sims", value: $numSimulations, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 100)
                                    .onChange(of: numSimulations) { _, _ in calculateRisk() }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Simulation Days")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                TextField("Days", value: $simulationDays, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 100)
                                    .onChange(of: simulationDays) { _, _ in calculateRisk() }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            if riskMeasure == .stressTesting {
                stressTestingInputs
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var stressTestingInputs: some View {
        GroupBox("Stress Test Scenarios") {
            VStack(spacing: 16) {
                HStack {
                    Text("Stress Scenarios")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button("Add Scenario") {
                        addStressScenario()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset Defaults") {
                        initializeStressScenarios()
                        calculateRisk()
                    }
                    .buttonStyle(.bordered)
                }
                
                if stressScenarios.isEmpty {
                    Text("No stress scenarios. Click 'Reset Defaults' to add standard scenarios.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    VStack(spacing: 12) {
                        ForEach(stressScenarios.indices, id: \.self) { index in
                            stressScenarioRow(for: index)
                        }
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private func stressScenarioRow(for index: Int) -> some View {
        VStack(spacing: 8) {
            HStack {
                TextField("Scenario Name", text: $stressScenarios[index].name)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 150)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Market Shock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Market", value: $stressScenarios[index].marketShock, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Vol Shock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Vol", value: $stressScenarios[index].volatilityShock, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                
                Button("Remove") {
                    removeStressScenario(at: index)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .onChange(of: stressScenarios[index].marketShock) { _, _ in calculateRisk() }
        .onChange(of: stressScenarios[index].volatilityShock) { _, _ in calculateRisk() }
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        VStack(spacing: 20) {
            GroupBox("Risk Measurements") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "VaR (95%)",
                        value: Formatters.formatCurrency(results.var95, currency: .usd),
                        isHighlighted: true
                    )
                    
                    DetailRow(
                        title: "VaR (99%)",
                        value: Formatters.formatCurrency(results.var99, currency: .usd)
                    )
                    
                    DetailRow(
                        title: "CVaR (95%)",
                        value: Formatters.formatCurrency(results.cvar95, currency: .usd)
                    )
                    
                    DetailRow(
                        title: "CVaR (99%)",
                        value: Formatters.formatCurrency(results.cvar99, currency: .usd)
                    )
                    
                    if riskMeasure == .riskMetrics || riskMeasure == .monteCarlo {
                        DetailRow(
                            title: "Maximum Drawdown",
                            value: String(format: "%.2f%%", results.maximumDrawdown * 100)
                        )
                        
                        DetailRow(
                            title: "Downside Deviation",
                            value: String(format: "%.2f%%", results.downsideDeviation * 100)
                        )
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            if riskMeasure == .riskMetrics {
                GroupBox("Risk-Adjusted Returns") {
                    VStack(spacing: 16) {
                        DetailRow(
                            title: "Sharpe Ratio",
                            value: String(format: "%.3f", results.sharpeRatio)
                        )
                        
                        DetailRow(
                            title: "Sortino Ratio",
                            value: String(format: "%.3f", results.sortinoRatio)
                        )
                        
                        DetailRow(
                            title: "Calmar Ratio",
                            value: String(format: "%.3f", results.calmarRatio)
                        )
                        
                        DetailRow(
                            title: "Information Ratio",
                            value: String(format: "%.3f", results.informationRatio)
                        )
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
            
            if riskMeasure == .stressTesting && !stressTestResults.isEmpty {
                GroupBox("Stress Test Results") {
                    VStack(spacing: 12) {
                        ForEach(stressTestResults) { result in
                            HStack {
                                Text(result.scenarioName)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(Formatters.formatCurrency(result.portfolioLoss, currency: .usd))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(result.portfolioLoss < 0 ? .red : .green)
                                    
                                    Text("(\(String(format: "%.1f", result.percentageLoss))%)")
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
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var chartSection: some View {
        switch riskMeasure {
        case .valueAtRisk, .cvar:
            distributionChart
        case .monteCarlo:
            monteCarloChart
        case .stressTesting:
            stressTestChart
        case .riskMetrics:
            riskMetricsChart
        }
    }
    
    @ViewBuilder
    private var distributionChart: some View {
        GroupBox("Return Distribution & VaR") {
            VStack(spacing: 16) {
                if !distributionData.isEmpty {
                    Chart(distributionData) { point in
                        BarMark(
                            x: .value("Return", point.returnValue * 100),
                            y: .value("Probability", point.probability)
                        )
                        .foregroundStyle(.blue)
                        .opacity(0.7)
                        
                        // VaR line
                        if abs(point.cumulative - (1 - confidenceLevel)) < 0.01 {
                            RuleMark(x: .value("VaR", point.returnValue * 100))
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                        }
                    }
                    .frame(height: 250)
                    .chartXAxisLabel("Return (%)")
                    .chartYAxisLabel("Probability Density")
                }
                
                Text("Red line shows VaR at \(Int(confidenceLevel * 100))% confidence level")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var monteCarloChart: some View {
        GroupBox("Monte Carlo Simulation Paths") {
            VStack(spacing: 16) {
                if !simulationData.isEmpty {
                    Chart(simulationData) { point in
                        LineMark(
                            x: .value("Day", point.day),
                            y: .value("Portfolio Value", point.portfolioValue)
                        )
                        .foregroundStyle(.blue)
                        .opacity(0.1)
                        .lineStyle(StrokeStyle(lineWidth: 1))
                    }
                    .frame(height: 250)
                    .chartXAxisLabel("Trading Days")
                    .chartYAxisLabel("Portfolio Value ($)")
                }
                
                Text("Shows \(min(numSimulations, 100)) simulation paths out of \(numSimulations) total")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var stressTestChart: some View {
        GroupBox("Stress Test Impact") {
            VStack(spacing: 16) {
                if !stressTestResults.isEmpty {
                    Chart(stressTestResults) { result in
                        BarMark(
                            x: .value("Scenario", result.scenarioName),
                            y: .value("Loss %", result.percentageLoss)
                        )
                        .foregroundStyle(result.portfolioLoss < 0 ? .red : .green)
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Stress Scenario")
                    .chartYAxisLabel("Portfolio Loss (%)")
                }
                
                Text("Impact of various stress scenarios on portfolio value")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var riskMetricsChart: some View {
        GroupBox("Risk Metrics Comparison") {
            VStack(spacing: 16) {
                let metrics = [
                    ("Sharpe", results.sharpeRatio),
                    ("Sortino", results.sortinoRatio),
                    ("Calmar", results.calmarRatio),
                    ("Info", results.informationRatio)
                ]
                
                Chart(metrics, id: \.0) { metric in
                    BarMark(
                        x: .value("Metric", metric.0),
                        y: .value("Value", metric.1)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
                .chartXAxisLabel("Risk-Adjusted Return Metrics")
                .chartYAxisLabel("Ratio Value")
                
                Text("Comparison of risk-adjusted return metrics")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Risk Management Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Key Risk Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Value at Risk (Parametric):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$VaR_{\\alpha} = \\mu - Z_{\\alpha} \\sigma \\sqrt{t}$")
                        .frame(height: 40)
                    
                    Text("Conditional VaR (Expected Shortfall):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$CVaR_{\\alpha} = E[L | L > VaR_{\\alpha}]$")
                        .frame(height: 40)
                    
                    Text("Sharpe Ratio:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$S = \\frac{E(R_p) - R_f}{\\sigma_p}$")
                        .frame(height: 40)
                    
                    Text("Sortino Ratio:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$Sortino = \\frac{E(R_p) - MAR}{DD}$")
                        .frame(height: 40)
                    
                    Text("Maximum Drawdown:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$MDD = \\max_{t} \\left[ \\frac{Peak_t - Trough_t}{Peak_t} \\right]$")
                        .frame(height: 40)
                    
                    Text("Where: μ = expected return, σ = volatility, Z = z-score, t = time, MAR = minimum acceptable return, DD = downside deviation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func initializeStressScenarios() {
        stressScenarios = [
            StressScenario(name: "2008 Financial Crisis", marketShock: -0.50, volatilityShock: 0.80),
            StressScenario(name: "Black Monday 1987", marketShock: -0.22, volatilityShock: 0.60),
            StressScenario(name: "Dot-com Crash", marketShock: -0.35, volatilityShock: 0.40),
            StressScenario(name: "COVID-19 Crash", marketShock: -0.35, volatilityShock: 1.20),
            StressScenario(name: "Interest Rate Shock", marketShock: -0.15, volatilityShock: 0.30)
        ]
    }
    
    private func addStressScenario() {
        stressScenarios.append(StressScenario(name: "Custom Scenario", marketShock: -0.10))
    }
    
    private func removeStressScenario(at index: Int) {
        stressScenarios.remove(at: index)
        calculateRisk()
    }
    
    private func calculateRisk() {
        switch riskMeasure {
        case .valueAtRisk:
            calculateVaR()
            generateDistributionData()
        case .cvar:
            calculateCVaR()
            generateDistributionData()
        case .monteCarlo:
            performMonteCarloSimulation()
        case .stressTesting:
            performStressTesting()
        case .riskMetrics:
            calculateRiskMetrics()
        }
    }
    
    private func calculateVaR() {
        let riskFreeRate = 0.02
        let dailyReturn = expectedReturn / 252.0
        let dailyVol = volatility / sqrt(252.0)
        
        // Parametric VaR calculation
        let z95 = 1.645  // 95% confidence
        let z99 = 2.326  // 99% confidence
        
        let var95Daily = dailyReturn - z95 * dailyVol
        let var99Daily = dailyReturn - z99 * dailyVol
        
        // Scale by time horizon and portfolio value
        let timeScaling = sqrt(timeHorizon)
        let var95 = abs(var95Daily * timeScaling * portfolioValue)
        let var99 = abs(var99Daily * timeScaling * portfolioValue)
        
        // CVaR approximation (assuming normal distribution)
        let cvar95 = var95 * 1.3  // Approximate factor
        let cvar99 = var99 * 1.15  // Approximate factor
        
        let sharpe = (expectedReturn - riskFreeRate) / volatility
        
        results = RiskResults(
            var95: var95,
            var99: var99,
            cvar95: cvar95,
            cvar99: cvar99,
            maximumDrawdown: 0.0,
            sharpeRatio: sharpe,
            sortinoRatio: 0.0,
            calmarRatio: 0.0,
            beta: 0.0,
            alpha: 0.0,
            trackingError: 0.0,
            informationRatio: 0.0,
            downsideDeviation: 0.0
        )
    }
    
    private func calculateCVaR() {
        calculateVaR() // CVaR includes VaR calculation
    }
    
    private func performMonteCarloSimulation() {
        simulationData = []
        
        let dt = 1.0 / 252.0  // Daily time step
        let drift = expectedReturn - 0.5 * volatility * volatility
        
        var portfolioValues: [Double] = []
        let numPathsToShow = min(numSimulations, 100)
        
        for simulation in 0..<numPathsToShow {
            var value = portfolioValue
            
            for day in 0...simulationDays {
                if day > 0 {
                    let random = Double.random(in: -3...3) // Simplified normal random
                    let returnToday = drift * dt + volatility * sqrt(dt) * random
                    value *= (1 + returnToday)
                }
                
                if simulation == 0 || day % 10 == 0 { // Sample some data points
                    simulationData.append(SimulationPoint(
                        day: day,
                        portfolioValue: value,
                        returnValue: day > 0 ? (value / portfolioValue - 1) : 0,
                        cumulativeReturn: (value - portfolioValue) / portfolioValue
                    ))
                }
            }
            
            portfolioValues.append(value)
        }
        
        // Calculate VaR from simulation results
        portfolioValues.sort()
        let var95Index = Int(Double(portfolioValues.count) * (1 - confidenceLevel))
        let var99Index = Int(Double(portfolioValues.count) * 0.01)
        
        let finalValue95 = portfolioValues[var95Index]
        let finalValue99 = portfolioValues[var99Index]
        
        let var95 = portfolioValue - finalValue95
        let var99 = portfolioValue - finalValue99
        
        // CVaR calculation
        let tailValues95 = Array(portfolioValues[0...var95Index])
        let tailValues99 = Array(portfolioValues[0...var99Index])
        
        let avgTail95 = tailValues95.reduce(0, +) / Double(tailValues95.count)
        let avgTail99 = tailValues99.reduce(0, +) / Double(tailValues99.count)
        
        let cvar95 = portfolioValue - avgTail95
        let cvar99 = portfolioValue - avgTail99
        
        // Maximum drawdown approximation
        let maxDrawdown = ((portfolioValues.max() ?? portfolioValue) - (portfolioValues.min() ?? portfolioValue)) / (portfolioValues.max() ?? portfolioValue)
        
        results = RiskResults(
            var95: max(0, var95),
            var99: max(0, var99),
            cvar95: max(0, cvar95),
            cvar99: max(0, cvar99),
            maximumDrawdown: maxDrawdown,
            sharpeRatio: (expectedReturn - 0.02) / volatility,
            sortinoRatio: 0.0,
            calmarRatio: 0.0,
            beta: 0.0,
            alpha: 0.0,
            trackingError: 0.0,
            informationRatio: 0.0,
            downsideDeviation: volatility * 0.7
        )
    }
    
    private func performStressTesting() {
        stressTestResults = []
        
        for scenario in stressScenarios {
            let stressedReturn = expectedReturn + scenario.marketShock
            let stressedVolatility = volatility * (1 + scenario.volatilityShock)
            
            // Calculate portfolio loss under stress
            let portfolioLoss = portfolioValue * scenario.marketShock
            let percentageLoss = scenario.marketShock * 100
            
            stressTestResults.append(StressResult(
                scenarioName: scenario.name,
                portfolioLoss: portfolioLoss,
                percentageLoss: percentageLoss
            ))
        }
        
        // Calculate overall stress metrics
        let worstCase = stressTestResults.min { $0.portfolioLoss < $1.portfolioLoss }
        let worstLoss = worstCase?.portfolioLoss ?? 0
        
        results = RiskResults(
            var95: abs(worstLoss * 0.5),
            var99: abs(worstLoss * 0.7),
            cvar95: abs(worstLoss * 0.6),
            cvar99: abs(worstLoss * 0.8),
            maximumDrawdown: abs(worstLoss / portfolioValue),
            sharpeRatio: (expectedReturn - 0.02) / volatility,
            sortinoRatio: 0.0,
            calmarRatio: 0.0,
            beta: 0.0,
            alpha: 0.0,
            trackingError: 0.0,
            informationRatio: 0.0,
            downsideDeviation: 0.0
        )
    }
    
    private func calculateRiskMetrics() {
        let riskFreeRate = 0.02
        let benchmarkReturn = 0.07
        
        // Calculate various risk metrics
        let sharpe = (expectedReturn - riskFreeRate) / volatility
        let downsideVol = volatility * 0.7  // Simplified downside volatility
        let sortino = (expectedReturn - riskFreeRate) / downsideVol
        let maxDD = volatility * 2.0  // Approximation
        let calmar = expectedReturn / maxDD
        let trackingErr = volatility * 0.3  // Approximation
        let infoRatio = (expectedReturn - benchmarkReturn) / trackingErr
        
        // VaR calculations
        let z95 = 1.645
        let z99 = 2.326
        let var95 = portfolioValue * z95 * volatility / sqrt(252) * sqrt(timeHorizon)
        let var99 = portfolioValue * z99 * volatility / sqrt(252) * sqrt(timeHorizon)
        
        results = RiskResults(
            var95: var95,
            var99: var99,
            cvar95: var95 * 1.3,
            cvar99: var99 * 1.15,
            maximumDrawdown: maxDD,
            sharpeRatio: sharpe,
            sortinoRatio: sortino,
            calmarRatio: calmar,
            beta: 1.0,  // Approximation
            alpha: expectedReturn - benchmarkReturn,
            trackingError: trackingErr,
            informationRatio: infoRatio,
            downsideDeviation: downsideVol
        )
    }
    
    private func generateDistributionData() {
        distributionData = []
        
        let numPoints = 50
        let returnRange = (-0.15, 0.15)  // -15% to +15%
        let step = (returnRange.1 - returnRange.0) / Double(numPoints)
        
        var cumulative = 0.0
        
        for i in 0..<numPoints {
            let returnValue = returnRange.0 + Double(i) * step
            
            // Simplified normal distribution probability
            let z = (returnValue - expectedReturn / 252) / (volatility / sqrt(252))
            let probability = exp(-0.5 * z * z) / sqrt(2 * .pi)
            
            cumulative += probability * step
            
            distributionData.append(DistributionPoint(
                returnValue: returnValue,
                probability: probability,
                cumulative: cumulative
            ))
        }
    }
}

#Preview {
    RiskManagementView()
        .frame(width: 1400, height: 1200)
}
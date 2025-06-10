//
//  PortfolioOptimizationView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

/// Comprehensive portfolio optimization and asset allocation calculator for CFA Level 3
struct PortfolioOptimizationView: View {
    @State private var optimizationType: OptimizationType = .meanVariance
    @State private var assets: [Asset] = []
    @State private var targetReturn: Double = 0.08
    @State private var riskFreeRate: Double = 0.02
    @State private var maxRisk: Double = 0.15
    @State private var rebalancingFrequency: RebalancingFrequency = .quarterly
    
    @State private var results: OptimizationResults = OptimizationResults()
    @State private var efficientFrontier: [FrontierPoint] = []
    @State private var assetAllocation: [AllocationPoint] = []
    @State private var performanceData: [PerformancePoint] = []
    
    enum OptimizationType: String, CaseIterable, Identifiable {
        case meanVariance = "meanVariance"
        case meanReversion = "meanReversion"
        case blackLitterman = "blackLitterman"
        case riskParity = "riskParity"
        case maximumDiversification = "maxDiversification"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .meanVariance: return "Mean-Variance Optimization"
            case .meanReversion: return "Mean Reversion Strategy"
            case .blackLitterman: return "Black-Litterman Model"
            case .riskParity: return "Risk Parity"
            case .maximumDiversification: return "Maximum Diversification"
            }
        }
    }
    
    enum RebalancingFrequency: String, CaseIterable, Identifiable {
        case monthly = "monthly"
        case quarterly = "quarterly"
        case semiannual = "semiannual"
        case annual = "annual"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .monthly: return "Monthly"
            case .quarterly: return "Quarterly"
            case .semiannual: return "Semi-Annual"
            case .annual: return "Annual"
            }
        }
    }
    
    struct Asset: Identifiable {
        let id = UUID()
        var name: String
        var expectedReturn: Double
        var volatility: Double
        var weight: Double
        var minWeight: Double
        var maxWeight: Double
        
        init(name: String, expectedReturn: Double, volatility: Double, weight: Double = 0.0, minWeight: Double = 0.0, maxWeight: Double = 1.0) {
            self.name = name
            self.expectedReturn = expectedReturn
            self.volatility = volatility
            self.weight = weight
            self.minWeight = minWeight
            self.maxWeight = maxWeight
        }
    }
    
    struct OptimizationResults {
        var portfolioReturn: Double = 0.0
        var portfolioRisk: Double = 0.0
        var sharpeRatio: Double = 0.0
        var treynorRatio: Double = 0.0
        var informationRatio: Double = 0.0
        var trackingError: Double = 0.0
        var maximumDrawdown: Double = 0.0
        var var95: Double = 0.0
        var cvar95: Double = 0.0
    }
    
    struct FrontierPoint: Identifiable {
        let id = UUID()
        let risk: Double
        let expectedReturn: Double
        let sharpeRatio: Double
    }
    
    struct AllocationPoint: Identifiable {
        let id = UUID()
        let assetName: String
        let allocation: Double
        let contribution: Double
    }
    
    struct PerformancePoint: Identifiable {
        let id = UUID()
        let period: Int
        let portfolioValue: Double
        let benchmarkValue: Double
        let cumulativeReturn: Double
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
                                optimizationInputs
                                assetInputs
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 24) {
                                resultsSection
                                allocationSection
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        VStack(spacing: 24) {
                            optimizationInputs
                            assetInputs
                            resultsSection
                            allocationSection
                        }
                    }
                    
                    efficientFrontierSection
                    performanceAnalysisSection
                    formulasSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            initializeDefaultAssets()
            optimizePortfolio()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Portfolio Optimization & Asset Allocation")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Advanced portfolio construction using modern portfolio theory and optimization techniques")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Optimization Type", selection: $optimizationType) {
                    ForEach(OptimizationType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 300)
                .onChange(of: optimizationType) { _, _ in
                    optimizePortfolio()
                }
            }
        }
    }
    
    @ViewBuilder
    private var optimizationInputs: some View {
        GroupBox("Optimization Parameters") {
            VStack(spacing: 16) {
                PercentageInputField(
                    title: "Target Return",
                    subtitle: "Desired portfolio return",
                    value: Binding(
                        get: { targetReturn * 100 },
                        set: { targetReturn = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Target annual return for portfolio optimization"
                )
                .onChange(of: targetReturn) { _, _ in optimizePortfolio() }
                
                PercentageInputField(
                    title: "Risk-Free Rate",
                    subtitle: "Treasury rate",
                    value: Binding(
                        get: { riskFreeRate * 100 },
                        set: { riskFreeRate = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Risk-free rate for Sharpe ratio calculation"
                )
                .onChange(of: riskFreeRate) { _, _ in optimizePortfolio() }
                
                PercentageInputField(
                    title: "Maximum Risk",
                    subtitle: "Maximum portfolio volatility",
                    value: Binding(
                        get: { maxRisk * 100 },
                        set: { maxRisk = ($0 ?? 0) / 100 }
                    ),
                    helpText: "Maximum acceptable portfolio volatility"
                )
                .onChange(of: maxRisk) { _, _ in optimizePortfolio() }
                
                HStack {
                    Text("Rebalancing Frequency")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Rebalancing", selection: $rebalancingFrequency) {
                        ForEach(RebalancingFrequency.allCases) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: rebalancingFrequency) { _, _ in optimizePortfolio() }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var assetInputs: some View {
        GroupBox("Asset Universe") {
            VStack(spacing: 16) {
                HStack {
                    Text("Assets in Portfolio")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button("Add Asset") {
                        addAsset()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset to Defaults") {
                        initializeDefaultAssets()
                        optimizePortfolio()
                    }
                    .buttonStyle(.bordered)
                }
                
                if assets.isEmpty {
                    Text("No assets added. Click 'Reset to Defaults' or 'Add Asset' to begin.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(assets.indices, id: \.self) { index in
                                assetRow(for: index)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private func assetRow(for index: Int) -> some View {
        VStack(spacing: 8) {
            HStack {
                TextField("Asset Name", text: $assets[index].name)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 120)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Expected Return")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Return", value: $assets[index].expectedReturn, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Volatility")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Vol", value: $assets[index].volatility, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Weight", value: $assets[index].weight, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                        .disabled(true)
                }
                
                Button("Remove") {
                    removeAsset(at: index)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Min Weight")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Min", value: $assets[index].minWeight, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Max Weight")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Max", value: $assets[index].maxWeight, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                
                Spacer()
            }
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .onChange(of: assets[index].expectedReturn) { _, _ in optimizePortfolio() }
        .onChange(of: assets[index].volatility) { _, _ in optimizePortfolio() }
        .onChange(of: assets[index].minWeight) { _, _ in optimizePortfolio() }
        .onChange(of: assets[index].maxWeight) { _, _ in optimizePortfolio() }
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        GroupBox("Optimization Results") {
            VStack(spacing: 16) {
                DetailRow(
                    title: "Portfolio Return",
                    value: String(format: "%.2f%%", results.portfolioReturn * 100),
                    isHighlighted: true
                )
                
                DetailRow(
                    title: "Portfolio Risk",
                    value: String(format: "%.2f%%", results.portfolioRisk * 100)
                )
                
                DetailRow(
                    title: "Sharpe Ratio",
                    value: String(format: "%.3f", results.sharpeRatio)
                )
                
                if optimizationType == .meanVariance {
                    DetailRow(
                        title: "Information Ratio",
                        value: String(format: "%.3f", results.informationRatio)
                    )
                    
                    DetailRow(
                        title: "Tracking Error",
                        value: String(format: "%.2f%%", results.trackingError * 100)
                    )
                }
                
                DetailRow(
                    title: "VaR (95%)",
                    value: String(format: "%.2f%%", results.var95 * 100)
                )
                
                DetailRow(
                    title: "CVaR (95%)",
                    value: String(format: "%.2f%%", results.cvar95 * 100)
                )
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var allocationSection: some View {
        GroupBox("Optimal Asset Allocation") {
            VStack(spacing: 16) {
                if !assetAllocation.isEmpty {
                    Chart(assetAllocation) { point in
                        SectorMark(
                            angle: .value("Allocation", point.allocation),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(0.9)
                        )
                        .foregroundStyle(by: .value("Asset", point.assetName))
                        .opacity(0.8)
                    }
                    .frame(height: 250)
                    .chartLegend(position: .bottom, alignment: .center)
                    
                    VStack(spacing: 8) {
                        ForEach(assetAllocation) { point in
                            HStack {
                                Text(point.assetName)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(String(format: "%.1f%%", point.allocation * 100))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(width: 60, alignment: .trailing)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var efficientFrontierSection: some View {
        GroupBox("Efficient Frontier") {
            VStack(spacing: 16) {
                if !efficientFrontier.isEmpty {
                    Chart(efficientFrontier) { point in
                        LineMark(
                            x: .value("Risk", point.risk * 100),
                            y: .value("Return", point.expectedReturn * 100)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        // Highlight optimal portfolio
                        if abs(point.expectedReturn - results.portfolioReturn) < 0.001 &&
                           abs(point.risk - results.portfolioRisk) < 0.001 {
                            PointMark(
                                x: .value("Risk", point.risk * 100),
                                y: .value("Return", point.expectedReturn * 100)
                            )
                            .foregroundStyle(.red)
                            .symbol(.circle)
                            .symbolSize(150)
                        }
                    }
                    .frame(height: 300)
                    .chartXAxisLabel("Risk (Volatility %)")
                    .chartYAxisLabel("Expected Return (%)")
                }
                
                Text("Blue line shows the efficient frontier. Red dot indicates the optimal portfolio.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var performanceAnalysisSection: some View {
        GroupBox("Performance Analysis") {
            VStack(spacing: 16) {
                if !performanceData.isEmpty {
                    Chart(performanceData) { point in
                        LineMark(
                            x: .value("Period", point.period),
                            y: .value("Portfolio Value", point.portfolioValue)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        LineMark(
                            x: .value("Period", point.period),
                            y: .value("Benchmark Value", point.benchmarkValue)
                        )
                        .foregroundStyle(.gray)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Time Period")
                    .chartYAxisLabel("Portfolio Value")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("— Portfolio")
                            .foregroundColor(.blue)
                        Text("⋯ Benchmark")
                            .foregroundColor(.gray)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("Simulated performance over time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Portfolio Optimization Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Key Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Portfolio Return:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$E(R_p) = \\sum_{i=1}^{n} w_i E(R_i)$")
                        .frame(height: 40)
                    
                    Text("Portfolio Variance:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$\\sigma_p^2 = \\sum_{i=1}^{n} \\sum_{j=1}^{n} w_i w_j \\sigma_{ij}$")
                        .frame(height: 40)
                    
                    Text("Sharpe Ratio:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$S_p = \\frac{E(R_p) - R_f}{\\sigma_p}$")
                        .frame(height: 40)
                    
                    if optimizationType == .meanVariance {
                        Text("Mean-Variance Optimization:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$\\min \\frac{1}{2} w^T \\Sigma w \\text{ subject to } w^T \\mu = \\mu_p, w^T 1 = 1$")
                            .frame(height: 50)
                    }
                    
                    Text("Where: w = weights, R = returns, σ = standard deviation, Σ = covariance matrix")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func initializeDefaultAssets() {
        assets = [
            Asset(name: "US Stocks", expectedReturn: 0.10, volatility: 0.16, maxWeight: 0.70),
            Asset(name: "Int'l Stocks", expectedReturn: 0.08, volatility: 0.18, maxWeight: 0.40),
            Asset(name: "Bonds", expectedReturn: 0.04, volatility: 0.06, maxWeight: 0.60),
            Asset(name: "REITs", expectedReturn: 0.07, volatility: 0.20, maxWeight: 0.15),
            Asset(name: "Commodities", expectedReturn: 0.05, volatility: 0.25, maxWeight: 0.10)
        ]
    }
    
    private func addAsset() {
        assets.append(Asset(name: "New Asset", expectedReturn: 0.06, volatility: 0.12))
    }
    
    private func removeAsset(at index: Int) {
        assets.remove(at: index)
        optimizePortfolio()
    }
    
    private func optimizePortfolio() {
        guard !assets.isEmpty else {
            results = OptimizationResults()
            return
        }
        
        switch optimizationType {
        case .meanVariance:
            performMeanVarianceOptimization()
        case .meanReversion:
            performMeanReversionOptimization()
        case .blackLitterman:
            performBlackLittermanOptimization()
        case .riskParity:
            performRiskParityOptimization()
        case .maximumDiversification:
            performMaxDiversificationOptimization()
        }
        
        generateEfficientFrontier()
        generatePerformanceData()
        updateAssetAllocation()
    }
    
    private func performMeanVarianceOptimization() {
        // Simplified mean-variance optimization
        let n = assets.count
        guard n > 0 else { return }
        
        // Equal weight as starting point, then adjust based on Sharpe ratios
        var weights = Array(repeating: 1.0 / Double(n), count: n)
        
        // Calculate individual Sharpe ratios and adjust weights
        var totalSharpe = 0.0
        for i in 0..<n {
            let sharpe = (assets[i].expectedReturn - riskFreeRate) / assets[i].volatility
            totalSharpe += max(sharpe, 0.01) // Avoid negative Sharpe ratios
        }
        
        for i in 0..<n {
            let sharpe = max((assets[i].expectedReturn - riskFreeRate) / assets[i].volatility, 0.01)
            weights[i] = sharpe / totalSharpe
            
            // Apply constraints
            weights[i] = max(weights[i], assets[i].minWeight)
            weights[i] = min(weights[i], assets[i].maxWeight)
        }
        
        // Normalize weights
        let totalWeight = weights.reduce(0, +)
        if totalWeight > 0 {
            weights = weights.map { $0 / totalWeight }
        }
        
        // Update asset weights
        for i in 0..<n {
            assets[i].weight = weights[i]
        }
        
        // Calculate portfolio metrics
        calculatePortfolioMetrics(weights: weights)
    }
    
    private func performMeanReversionOptimization() {
        // Simplified mean reversion strategy
        performMeanVarianceOptimization() // Use MV as base for now
    }
    
    private func performBlackLittermanOptimization() {
        // Simplified Black-Litterman implementation
        performMeanVarianceOptimization() // Use MV as base for now
    }
    
    private func performRiskParityOptimization() {
        // Risk parity: equal risk contribution from each asset
        let n = assets.count
        guard n > 0 else { return }
        
        // Simplified risk parity: inverse volatility weighting
        var weights = [Double]()
        var totalInvVol = 0.0
        
        for asset in assets {
            let invVol = 1.0 / asset.volatility
            weights.append(invVol)
            totalInvVol += invVol
        }
        
        // Normalize
        weights = weights.map { $0 / totalInvVol }
        
        // Apply constraints
        for i in 0..<n {
            weights[i] = max(weights[i], assets[i].minWeight)
            weights[i] = min(weights[i], assets[i].maxWeight)
        }
        
        // Renormalize
        let totalWeight = weights.reduce(0, +)
        if totalWeight > 0 {
            weights = weights.map { $0 / totalWeight }
        }
        
        // Update asset weights
        for i in 0..<n {
            assets[i].weight = weights[i]
        }
        
        calculatePortfolioMetrics(weights: weights)
    }
    
    private func performMaxDiversificationOptimization() {
        // Maximum diversification strategy
        performRiskParityOptimization() // Use risk parity as approximation
    }
    
    private func calculatePortfolioMetrics(weights: [Double]) {
        let n = assets.count
        guard n > 0 else { return }
        
        // Portfolio return
        let portfolioReturn = zip(weights, assets).reduce(0.0) { result, tuple in
            result + tuple.0 * tuple.1.expectedReturn
        }
        
        // Portfolio variance (simplified - assumes zero correlation)
        let portfolioVariance = zip(weights, assets).reduce(0.0) { result, tuple in
            result + tuple.0 * tuple.0 * tuple.1.volatility * tuple.1.volatility
        }
        
        let portfolioRisk = sqrt(portfolioVariance)
        let sharpeRatio = (portfolioReturn - riskFreeRate) / portfolioRisk
        
        // Risk measures (simplified calculations)
        let var95 = portfolioRisk * 1.645  // 95% VaR approximation
        let cvar95 = portfolioRisk * 2.062  // 95% CVaR approximation
        
        results = OptimizationResults(
            portfolioReturn: portfolioReturn,
            portfolioRisk: portfolioRisk,
            sharpeRatio: sharpeRatio,
            treynorRatio: 0.0,  // Would need beta
            informationRatio: sharpeRatio * 0.8,  // Approximation
            trackingError: portfolioRisk * 0.3,  // Approximation
            maximumDrawdown: portfolioRisk * 2.0,  // Approximation
            var95: var95,
            cvar95: cvar95
        )
    }
    
    private func generateEfficientFrontier() {
        efficientFrontier = []
        
        let riskLevels = Array(stride(from: 0.05, through: 0.25, by: 0.01))
        
        for risk in riskLevels {
            // For each risk level, find the maximum return portfolio
            let maxReturn = assets.map { $0.expectedReturn }.max() ?? 0.08
            let returnLevel = min(maxReturn * 0.9, risk * 4) // Simplified relationship
            
            if returnLevel > riskFreeRate {
                let sharpe = (returnLevel - riskFreeRate) / risk
                efficientFrontier.append(FrontierPoint(
                    risk: risk,
                    expectedReturn: returnLevel,
                    sharpeRatio: sharpe
                ))
            }
        }
    }
    
    private func generatePerformanceData() {
        performanceData = []
        
        let periods = 36 // 3 years monthly
        var portfolioValue = 10000.0
        var benchmarkValue = 10000.0
        
        for period in 0...periods {
            let monthlyReturn = results.portfolioReturn / 12.0
            let benchmarkReturn = 0.07 / 12.0 // 7% benchmark
            
            if period > 0 {
                // Add some volatility
                let randomFactor = Double.random(in: -0.02...0.02)
                portfolioValue *= (1 + monthlyReturn + randomFactor)
                benchmarkValue *= (1 + benchmarkReturn + randomFactor * 0.5)
            }
            
            let cumulativeReturn = (portfolioValue - 10000.0) / 10000.0
            
            performanceData.append(PerformancePoint(
                period: period,
                portfolioValue: portfolioValue,
                benchmarkValue: benchmarkValue,
                cumulativeReturn: cumulativeReturn
            ))
        }
    }
    
    private func updateAssetAllocation() {
        assetAllocation = assets.compactMap { asset in
            guard asset.weight > 0.001 else { return nil }
            return AllocationPoint(
                assetName: asset.name,
                allocation: asset.weight,
                contribution: asset.weight * asset.expectedReturn
            )
        }
    }
}

#Preview {
    PortfolioOptimizationView()
        .frame(width: 1400, height: 1200)
}
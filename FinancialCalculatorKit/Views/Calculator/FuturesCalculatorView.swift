//
//  FuturesCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

struct FuturesCalculatorView: View {
    @State private var spotPrice: Double = 100.0
    @State private var futuresPrice: Double = 105.0
    @State private var riskFreeRate: Double = 0.05  // 5%
    @State private var timeToMaturity: Double = 0.25  // 3 months
    @State private var dividendYield: Double = 0.02  // 2%
    @State private var convenienceYield: Double = 0.0
    @State private var storageRate: Double = 0.01
    @State private var contractSize: Double = 100.0
    @State private var initialMargin: Double = 5000.0
    @State private var maintenanceMargin: Double = 3000.0
    @State private var contractType: FuturesType = .equity
    
    @State private var results: FuturesResults = FuturesResults()
    @State private var marginData: [MarginPoint] = []
    @State private var basisData: [BasisPoint] = []
    
    enum FuturesType: String, CaseIterable, Identifiable {
        case equity = "equity"
        case currency = "currency"
        case commodity = "commodity"
        case interest = "interest"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .equity: return "Equity Index"
            case .currency: return "Currency"
            case .commodity: return "Commodity"
            case .interest: return "Interest Rate"
            }
        }
    }
    
    struct FuturesResults {
        var theoreticalPrice: Double = 0.0
        var fairValue: Double = 0.0
        var basis: Double = 0.0
        var dailyPnL: Double = 0.0
        var marginCall: Double = 0.0
        var carryCost: Double = 0.0
        var impliedRepo: Double = 0.0
    }
    
    struct MarginPoint: Identifiable {
        let id = UUID()
        let day: Int
        let futuresPrice: Double
        let accountBalance: Double
        let marginCall: Double
    }
    
    struct BasisPoint: Identifiable {
        let id = UUID()
        let timeToMaturity: Double
        let basis: Double
        let carryCost: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    // Adaptive layout: side-by-side if wide enough, single column if narrow
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
                    marginAnalysisSection
                    basisSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            calculateFutures()
            generateMarginData()
            generateBasisData()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Futures Contracts Pricing")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Analyze futures pricing, margin requirements, and basis calculations")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Contract Type", selection: $contractType) {
                    ForEach(FuturesType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 300)
                .onChange(of: contractType) { _, _ in
                    calculateAndUpdate()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
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
                        helpText: "Current price of underlying asset"
                    )
                    .onChange(of: spotPrice) { _, _ in calculateAndUpdate() }
                    
                    CurrencyInputField(
                        title: "Futures Price",
                        subtitle: "Current contract price",
                        value: Binding(
                            get: { futuresPrice },
                            set: { futuresPrice = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Current futures contract price"
                    )
                    .onChange(of: futuresPrice) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Risk-Free Rate",
                        subtitle: "Interest rate",
                        value: Binding(
                            get: { riskFreeRate * 100 },
                            set: { riskFreeRate = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Risk-free interest rate"
                    )
                    .onChange(of: riskFreeRate) { _, _ in calculateAndUpdate() }
                    
                    InputFieldView(
                        title: "Time to Maturity",
                        subtitle: "Years to expiration",
                        value: Binding(
                            get: { String(format: "%.4f", timeToMaturity) },
                            set: { timeToMaturity = Double($0) ?? 0 }
                        ),
                        placeholder: "0.25",
                        keyboardType: .decimalPad,
                        validation: .positiveNumber,
                        helpText: "Time to maturity in years"
                    )
                    .onChange(of: timeToMaturity) { _, _ in calculateAndUpdate() }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Contract Specifications") {
                VStack(spacing: 16) {
                    InputFieldView(
                        title: "Contract Size",
                        subtitle: "Units per contract",
                        value: Binding(
                            get: { String(format: "%.0f", contractSize) },
                            set: { contractSize = Double($0) ?? 0 }
                        ),
                        placeholder: "100",
                        keyboardType: .numberPad,
                        validation: .positiveNumber,
                        helpText: "Number of units per contract"
                    )
                    .onChange(of: contractSize) { _, _ in calculateAndUpdate() }
                    
                    CurrencyInputField(
                        title: "Initial Margin",
                        subtitle: "Required deposit",
                        value: Binding(
                            get: { initialMargin },
                            set: { initialMargin = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Required initial margin deposit"
                    )
                    .onChange(of: initialMargin) { _, _ in calculateAndUpdate() }
                    
                    CurrencyInputField(
                        title: "Maintenance Margin",
                        subtitle: "Minimum level",
                        value: Binding(
                            get: { maintenanceMargin },
                            set: { maintenanceMargin = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Minimum margin level"
                    )
                    .onChange(of: maintenanceMargin) { _, _ in calculateAndUpdate() }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            if contractType == .equity || contractType == .commodity {
                GroupBox("Asset-Specific Parameters") {
                    VStack(spacing: 16) {
                        if contractType == .equity {
                            PercentageInputField(
                                title: "Dividend Yield",
                                subtitle: "Expected dividend yield",
                                value: Binding(
                                    get: { dividendYield * 100 },
                                    set: { dividendYield = ($0 ?? 0) / 100 }
                                ),
                                helpText: "Expected dividend yield"
                            )
                            .onChange(of: dividendYield) { _, _ in calculateAndUpdate() }
                        }
                        
                        if contractType == .commodity {
                            PercentageInputField(
                                title: "Storage Rate",
                                subtitle: "Storage cost percentage",
                                value: Binding(
                                    get: { storageRate * 100 },
                                    set: { storageRate = ($0 ?? 0) / 100 }
                                ),
                                helpText: "Storage cost percentage"
                            )
                            .onChange(of: storageRate) { _, _ in calculateAndUpdate() }
                            
                            PercentageInputField(
                                title: "Convenience Yield",
                                subtitle: "Holding benefit",
                                value: Binding(
                                    get: { convenienceYield * 100 },
                                    set: { convenienceYield = ($0 ?? 0) / 100 }
                                ),
                                helpText: "Convenience yield from holding physical"
                            )
                            .onChange(of: convenienceYield) { _, _ in calculateAndUpdate() }
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
    private var resultsSection: some View {
        VStack(spacing: 20) {
            GroupBox("Futures Pricing Results") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Theoretical Price",
                        value: String(format: "$%.2f", results.theoreticalPrice)
                    )
                    
                    DetailRow(
                        title: "Basis",
                        value: String(format: "$%.2f", results.basis),
                        isHighlighted: abs(results.basis) > 0.01
                    )
                    
                    DetailRow(
                        title: "Carry Cost",
                        value: String(format: "$%.2f", results.carryCost)
                    )
                    
                    DetailRow(
                        title: "Implied Repo Rate",
                        value: String(format: "%.3f%%", results.impliedRepo * 100)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Margin Analysis") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Daily P&L",
                        value: String(format: "$%.2f", results.dailyPnL),
                        isHighlighted: abs(results.dailyPnL) > 0.01
                    )
                    
                    DetailRow(
                        title: "Margin Call Amount",
                        value: String(format: "$%.2f", results.marginCall),
                        isHighlighted: results.marginCall > 0.01
                    )
                    
                    DetailRow(
                        title: "Leverage Ratio",
                        value: String(format: "%.1fx", (spotPrice * contractSize) / initialMargin)
                    )
                    
                    DetailRow(
                        title: "Margin Utilization",
                        value: String(format: "%.1f%%", (initialMargin - maintenanceMargin) / initialMargin * 100)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Futures Pricing Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Theoretical Pricing")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("General Futures Price:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$F = S_0 e^{rT}$")
                        .frame(height: 40)
                    
                    Text("With Income/Costs:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$F = S_0 e^{(r - q + u - c)T}$")
                        .frame(height: 40)
                    
                    Text("Basis Relationship:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$Basis = F - S = (r - q + u - c) \\cdot S \\cdot T$")
                        .frame(height: 40)
                    
                    Text("Daily P&L:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$P\\&L = (F_{today} - F_{yesterday}) \\times ContractSize$")
                        .frame(height: 40)
                    
                    if contractType == .interest {
                        Text("Interest Rate Futures:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$Price = 100 - YieldBasisPoints$")
                            .frame(height: 40)
                    }
                }
                
                Text("where: r = risk-free rate, q = dividend yield, u = storage cost, c = convenience yield")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var marginAnalysisSection: some View {
        GroupBox("Margin Requirements Analysis") {
            VStack(spacing: 16) {
                if !marginData.isEmpty {
                    Chart(marginData) { point in
                        LineMark(
                            x: .value("Day", point.day),
                            y: .value("Futures Price", point.futuresPrice)
                        )
                        .foregroundStyle(.blue)
                        
                        AreaMark(
                            x: .value("Day", point.day),
                            yStart: .value("Maintenance", maintenanceMargin),
                            yEnd: .value("Account Balance", point.accountBalance)
                        )
                        .foregroundStyle(.green.opacity(0.3))
                        
                        if point.marginCall > 0 {
                            PointMark(
                                x: .value("Day", point.day),
                                y: .value("Margin Call", point.marginCall)
                            )
                            .foregroundStyle(.red)
                            .symbol(.circle)
                        }
                    }
                    .frame(height: 200)
                    .chartYAxisLabel("Value")
                    .chartXAxisLabel("Trading Days")
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var basisSection: some View {
        GroupBox("Basis Analysis") {
            VStack(spacing: 16) {
                if !basisData.isEmpty {
                    Chart(basisData) { point in
                        LineMark(
                            x: .value("Time to Maturity", point.timeToMaturity),
                            y: .value("Basis", point.basis)
                        )
                        .foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("Time to Maturity", point.timeToMaturity),
                            y: .value("Carry Cost", point.carryCost)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    }
                    .frame(height: 200)
                    .chartYAxisLabel("Basis / Carry Cost")
                    .chartXAxisLabel("Time to Maturity (Years)")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("● Basis")
                            .foregroundColor(.blue)
                        Text("⋯ Theoretical Carry")
                            .foregroundColor(.red)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("Convergence to zero at maturity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func calculateAndUpdate() {
        calculateFutures()
        generateMarginData()
        generateBasisData()
    }
    
    private func calculateFutures() {
        let adjustedRate: Double
        
        switch contractType {
        case .equity:
            adjustedRate = riskFreeRate - dividendYield
        case .currency:
            adjustedRate = riskFreeRate  // Simplified
        case .commodity:
            adjustedRate = riskFreeRate + storageRate - convenienceYield
        case .interest:
            adjustedRate = riskFreeRate
        }
        
        // Theoretical futures price
        let theoreticalPrice = spotPrice * exp(adjustedRate * timeToMaturity)
        
        // Basis calculation
        let basis = futuresPrice - spotPrice
        
        // Carry cost
        let carryCost = spotPrice * (adjustedRate * timeToMaturity)
        
        // Daily P&L (simplified as price difference)
        let dailyPnL = (futuresPrice - theoreticalPrice) * contractSize
        
        // Margin call calculation
        let currentMargin = initialMargin + dailyPnL
        let marginCall = max(0, maintenanceMargin - currentMargin)
        
        // Implied repo rate
        let impliedRepo = log(futuresPrice / spotPrice) / timeToMaturity
        
        results = FuturesResults(
            theoreticalPrice: theoreticalPrice,
            fairValue: theoreticalPrice,
            basis: basis,
            dailyPnL: dailyPnL,
            marginCall: marginCall,
            carryCost: carryCost,
            impliedRepo: impliedRepo
        )
    }
    
    private func generateMarginData() {
        marginData = []
        
        var accountBalance = initialMargin
        
        for day in 0...10 {
            let priceVolatility = Double.random(in: -0.02...0.02)
            let dayPrice = futuresPrice * (1 + priceVolatility)
            let dailyPnL = (dayPrice - futuresPrice) * contractSize
            
            accountBalance += dailyPnL
            let marginCall = max(0, maintenanceMargin - accountBalance)
            
            if marginCall > 0 {
                accountBalance += marginCall
            }
            
            marginData.append(MarginPoint(
                day: day,
                futuresPrice: dayPrice,
                accountBalance: accountBalance,
                marginCall: marginCall
            ))
        }
    }
    
    private func generateBasisData() {
        basisData = []
        
        let timePoints = stride(from: 0.01, through: 1.0, by: 0.05)
        
        for time in timePoints {
            let adjustedRate = riskFreeRate - dividendYield + storageRate - convenienceYield
            let theoreticalBasis = spotPrice * (exp(adjustedRate * time) - 1)
            let carryCost = spotPrice * adjustedRate * time
            
            basisData.append(BasisPoint(
                timeToMaturity: time,
                basis: theoreticalBasis,
                carryCost: carryCost
            ))
        }
    }
}

#Preview {
    FuturesCalculatorView()
        .frame(width: 1200, height: 800)
}
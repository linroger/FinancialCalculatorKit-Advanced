//
//  ForwardsCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

struct ForwardsCalculatorView: View {
    @State private var spotPrice: Double = 100.0
    @State private var strikePrice: Double = 105.0
    @State private var riskFreeRate: Double = 0.05  // 5%
    @State private var timeToMaturity: Double = 0.25  // 3 months
    @State private var dividendYield: Double = 0.02  // 2%
    @State private var storageRate: Double = 0.01  // 1%
    @State private var convenienceYield: Double = 0.0
    @State private var contractType: ForwardType = .equity
    
    @State private var results: ForwardResults = ForwardResults()
    @State private var sensitivityData: [SensitivityPoint] = []
    
    enum ForwardType: String, CaseIterable, Identifiable {
        case equity = "equity"
        case currency = "currency"
        case commodity = "commodity"
        case bond = "bond"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .equity: return "Equity Forward"
            case .currency: return "FX Forward"
            case .commodity: return "Commodity Forward"
            case .bond: return "Bond Forward"
            }
        }
    }
    
    struct ForwardResults {
        var forwardPrice: Double = 0.0
        var forwardValue: Double = 0.0
        var payoff: Double = 0.0
        var profit: Double = 0.0
    }
    
    struct SensitivityPoint: Identifiable {
        let id = UUID()
        let parameter: String
        let value: Double
        let forwardPrice: Double
        let forwardValue: Double
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
                    sensitivitySection
                    chartSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            calculateForward()
            generateSensitivityData()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Forward Contracts Pricing")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Price forward contracts with comprehensive risk analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Contract Type", selection: $contractType) {
                    ForEach(ForwardType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 300)
                .onChange(of: contractType) { _, _ in
                    calculateForward()
                    generateSensitivityData()
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
                        subtitle: "Current market price",
                        value: Binding(
                            get: { spotPrice },
                            set: { spotPrice = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Current market price of the underlying asset"
                    )
                    .onChange(of: spotPrice) { _, _ in calculateAndUpdate() }
                    
                    CurrencyInputField(
                        title: "Strike Price",
                        subtitle: "Forward delivery price",
                        value: Binding(
                            get: { strikePrice },
                            set: { strikePrice = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Forward contract delivery price"
                    )
                    .onChange(of: strikePrice) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Risk-Free Rate",
                        subtitle: "Continuously compounded rate",
                        value: Binding(
                            get: { riskFreeRate * 100 },
                            set: { riskFreeRate = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Continuously compounded risk-free interest rate"
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
                        helpText: "Time to maturity in years (e.g., 0.25 for 3 months)"
                    )
                    .onChange(of: timeToMaturity) { _, _ in calculateAndUpdate() }
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
                                subtitle: "Continuous dividend yield",
                                value: Binding(
                                    get: { dividendYield * 100 },
                                    set: { dividendYield = ($0 ?? 0) / 100 }
                                ),
                                helpText: "Continuous dividend yield"
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
                                helpText: "Storage cost as percentage of spot price"
                            )
                            .onChange(of: storageRate) { _, _ in calculateAndUpdate() }
                            
                            PercentageInputField(
                                title: "Convenience Yield",
                                subtitle: "Holding benefit",
                                value: Binding(
                                    get: { convenienceYield * 100 },
                                    set: { convenienceYield = ($0 ?? 0) / 100 }
                                ),
                                helpText: "Benefit from holding physical commodity"
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
            GroupBox("Forward Pricing Results") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Forward Price",
                        value: String(format: "$%.2f", results.forwardPrice)
                    )
                    
                    DetailRow(
                        title: "Forward Value",
                        value: String(format: "$%.2f", results.forwardValue)
                    )
                    
                    DetailRow(
                        title: "Payoff at Maturity",
                        value: String(format: "$%.2f", results.payoff)
                    )
                    
                    DetailRow(
                        title: "P&L vs Strike",
                        value: String(format: "$%.2f", results.profit),
                        isHighlighted: abs(results.profit) > 0.01
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Metrics") {
                VStack(spacing: 12) {
                    DetailRow(
                        title: "Delta",
                        value: String(format: "%.4f", calculateDelta())
                    )
                    
                    DetailRow(
                        title: "Price Sensitivity",
                        value: String(format: "%.2f", calculatePriceSensitivity())
                    )
                    
                    DetailRow(
                        title: "Rate Sensitivity",
                        value: String(format: "%.4f", calculateRateSensitivity())
                    )
                    
                    DetailRow(
                        title: "Time Decay",
                        value: String(format: "%.4f", calculateTimeDecay())
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
        GroupBox("Forward Pricing Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Pricing Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("General Forward Price:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX(forwardPriceFormula)
                        .frame(height: 40)
                    
                    Text("Forward Value:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$V_f = (S_t - K)e^{-r(T-t)}$")
                        .frame(height: 40)
                    
                    if contractType == .equity {
                        Text("Equity Forward (with dividends):")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$F = S_0 e^{(r-q)T}$")
                            .frame(height: 40)
                    }
                    
                    if contractType == .commodity {
                        Text("Commodity Forward:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$F = S_0 e^{(r+u-c)T}$")
                            .frame(height: 40)
                        
                        Text("where u = storage rate, c = convenience yield")
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
                            x: .value("Parameter Value", point.value),
                            y: .value("Forward Price", point.forwardPrice)
                        )
                        .foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("Parameter Value", point.value),
                            y: .value("Forward Value", point.forwardValue)
                        )
                        .foregroundStyle(.red)
                    }
                    .frame(height: 200)
                    .chartYAxisLabel("Price")
                    .chartXAxisLabel("Spot Price")
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var chartSection: some View {
        GroupBox("Payoff Diagram") {
            VStack(spacing: 16) {
                let payoffData = generatePayoffData()
                
                Chart(payoffData) { point in
                    LineMark(
                        x: .value("Spot Price", point.spotPrice),
                        y: .value("Payoff", point.payoff)
                    )
                    .foregroundStyle(.green)
                    
                    RuleMark(y: .value("Zero", 0))
                        .foregroundStyle(.gray)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                }
                .frame(height: 200)
                .chartYAxisLabel("Payoff")
                .chartXAxisLabel("Spot Price at Maturity")
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private var forwardPriceFormula: String {
        switch contractType {
        case .equity:
            return "$F = S_0 e^{(r-q)T}$"
        case .currency:
            return "$F = S_0 e^{(r_d-r_f)T}$"
        case .commodity:
            return "$F = S_0 e^{(r+u-c)T}$"
        case .bond:
            return "$F = (S_0 - PV_{coupon})e^{rT}$"
        }
    }
    
    private func calculateAndUpdate() {
        calculateForward()
        generateSensitivityData()
    }
    
    private func calculateForward() {
        let adjustedRate: Double
        
        switch contractType {
        case .equity:
            adjustedRate = riskFreeRate - dividendYield
        case .currency:
            adjustedRate = riskFreeRate  // Simplified - would need foreign rate
        case .commodity:
            adjustedRate = riskFreeRate + storageRate - convenienceYield
        case .bond:
            adjustedRate = riskFreeRate  // Simplified - would need coupon adjustments
        }
        
        // Forward price calculation
        let forwardPrice = spotPrice * exp(adjustedRate * timeToMaturity)
        
        // Forward value calculation (for existing contract at strike price)
        let forwardValue = (spotPrice * exp(-dividendYield * timeToMaturity) - strikePrice * exp(-riskFreeRate * timeToMaturity))
        
        // Payoff calculation
        let payoff = spotPrice - strikePrice
        let profit = forwardPrice - strikePrice
        
        results = ForwardResults(
            forwardPrice: forwardPrice,
            forwardValue: forwardValue,
            payoff: payoff,
            profit: profit
        )
    }
    
    private func generateSensitivityData() {
        sensitivityData = []
        
        let spotRange = stride(from: spotPrice * 0.7, through: spotPrice * 1.3, by: spotPrice * 0.05)
        
        for spot in spotRange {
            let tempResults = calculateForwardForSpot(spot)
            sensitivityData.append(SensitivityPoint(
                parameter: "Spot",
                value: spot,
                forwardPrice: tempResults.forwardPrice,
                forwardValue: tempResults.forwardValue
            ))
        }
    }
    
    private func calculateForwardForSpot(_ spot: Double) -> ForwardResults {
        let adjustedRate: Double
        
        switch contractType {
        case .equity:
            adjustedRate = riskFreeRate - dividendYield
        case .currency:
            adjustedRate = riskFreeRate
        case .commodity:
            adjustedRate = riskFreeRate + storageRate - convenienceYield
        case .bond:
            adjustedRate = riskFreeRate
        }
        
        let forwardPrice = spot * exp(adjustedRate * timeToMaturity)
        let forwardValue = (spot * exp(-dividendYield * timeToMaturity) - strikePrice * exp(-riskFreeRate * timeToMaturity))
        let payoff = spot - strikePrice
        let profit = forwardPrice - strikePrice
        
        return ForwardResults(
            forwardPrice: forwardPrice,
            forwardValue: forwardValue,
            payoff: payoff,
            profit: profit
        )
    }
    
    struct PayoffPoint: Identifiable {
        let id = UUID()
        let spotPrice: Double
        let payoff: Double
    }
    
    private func generatePayoffData() -> [PayoffPoint] {
        let range = stride(from: spotPrice * 0.5, through: spotPrice * 1.5, by: spotPrice * 0.05)
        return range.map { spot in
            PayoffPoint(spotPrice: spot, payoff: spot - strikePrice)
        }
    }
    
    private func calculateDelta() -> Double {
        return exp(-dividendYield * timeToMaturity)
    }
    
    private func calculatePriceSensitivity() -> Double {
        let bump = 0.01 * spotPrice
        let upResults = calculateForwardForSpot(spotPrice + bump)
        let downResults = calculateForwardForSpot(spotPrice - bump)
        return (upResults.forwardPrice - downResults.forwardPrice) / (2 * bump)
    }
    
    private func calculateRateSensitivity() -> Double {
        let bump = 0.0001  // 1 bp
        let originalRate = riskFreeRate
        
        // Calculate with rate bump
        let adjustedRate = originalRate + bump - dividendYield
        let upPrice = spotPrice * exp(adjustedRate * timeToMaturity)
        
        // Calculate with rate down
        let adjustedRateDown = originalRate - bump - dividendYield
        let downPrice = spotPrice * exp(adjustedRateDown * timeToMaturity)
        
        return (upPrice - downPrice) / (2 * bump)
    }
    
    private func calculateTimeDecay() -> Double {
        let bump = 1.0 / 365.0  // 1 day
        let upTime = timeToMaturity + bump
        let downTime = max(0, timeToMaturity - bump)
        
        let adjustedRate = riskFreeRate - dividendYield
        let upPrice = spotPrice * exp(adjustedRate * upTime)
        let downPrice = spotPrice * exp(adjustedRate * downTime)
        
        return (upPrice - downPrice) / (2 * bump)
    }
}

#Preview {
    ForwardsCalculatorView()
        .frame(width: 1200, height: 800)
}
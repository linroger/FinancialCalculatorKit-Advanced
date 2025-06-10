//
//  OptionsStrategiesView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

/// Advanced options strategies calculator with Greeks analysis for CFA Level 2/3
struct OptionsStrategiesView: View {
    @State private var strategy: OptionsStrategy = .call
    @State private var spotPrice: Double = 100.0
    @State private var strikePrice: Double = 100.0
    @State private var strikePrice2: Double = 110.0  // For spreads
    @State private var timeToExpiration: Double = 0.25  // 3 months
    @State private var riskFreeRate: Double = 0.05
    @State private var volatility: Double = 0.20
    @State private var dividendYield: Double = 0.02
    
    // Strategy parameters
    @State private var quantity1: Int = 1
    @State private var quantity2: Int = 1
    @State private var premiumPaid: Double = 0.0
    
    @State private var results: OptionsResults = OptionsResults()
    @State private var payoffData: [PayoffPoint] = []
    @State private var greeksData: [GreeksPoint] = []
    @State private var probabilityData: [ProbabilityPoint] = []
    
    enum OptionsStrategy: String, CaseIterable, Identifiable {
        case call = "call"
        case put = "put"
        case callSpread = "callSpread"
        case putSpread = "putSpread"
        case straddle = "straddle"
        case strangle = "strangle"
        case butterfly = "butterfly"
        case condor = "condor"
        case collar = "collar"
        case ratio = "ratio"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .call: return "Long Call"
            case .put: return "Long Put"
            case .callSpread: return "Bull Call Spread"
            case .putSpread: return "Bear Put Spread"
            case .straddle: return "Long Straddle"
            case .strangle: return "Long Strangle"
            case .butterfly: return "Butterfly Spread"
            case .condor: return "Iron Condor"
            case .collar: return "Protective Collar"
            case .ratio: return "Ratio Spread"
            }
        }
    }
    
    struct OptionsResults {
        var optionPrice: Double = 0.0
        var strategyValue: Double = 0.0
        var maxProfit: Double = 0.0
        var maxLoss: Double = 0.0
        var breakeven: Double = 0.0
        var breakeven2: Double = 0.0  // For strategies with 2 breakevens
        var delta: Double = 0.0
        var gamma: Double = 0.0
        var theta: Double = 0.0
        var vega: Double = 0.0
        var rho: Double = 0.0
        var probabilityOfProfit: Double = 0.0
    }
    
    struct PayoffPoint: Identifiable {
        let id = UUID()
        let spotPrice: Double
        let payoff: Double
        let intrinsicValue: Double
        let timeValue: Double
    }
    
    struct GreeksPoint: Identifiable {
        let id = UUID()
        let spotPrice: Double
        let delta: Double
        let gamma: Double
        let theta: Double
        let vega: Double
    }
    
    struct ProbabilityPoint: Identifiable {
        let id = UUID()
        let spotPrice: Double
        let probability: Double
        let cumulative: Double
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
                    
                    payoffDiagramSection
                    greeksAnalysisSection
                    probabilityAnalysisSection
                    formulasSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            calculateOptions()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Options Strategies & Greeks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Advanced options strategies with Black-Scholes pricing and comprehensive Greeks analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Strategy", selection: $strategy) {
                    ForEach(OptionsStrategy.allCases) { strat in
                        Text(strat.displayName).tag(strat)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)
                .onChange(of: strategy) { _, _ in
                    calculateOptions()
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
                        subtitle: "Current stock price",
                        value: Binding(
                            get: { spotPrice },
                            set: { spotPrice = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Current market price of the underlying stock"
                    )
                    .onChange(of: spotPrice) { _, _ in calculateOptions() }
                    
                    CurrencyInputField(
                        title: "Strike Price",
                        subtitle: "Exercise price",
                        value: Binding(
                            get: { strikePrice },
                            set: { strikePrice = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Option exercise price"
                    )
                    .onChange(of: strikePrice) { _, _ in calculateOptions() }
                    
                    if needsSecondStrike {
                        CurrencyInputField(
                            title: "Strike Price 2",
                            subtitle: "Second exercise price",
                            value: Binding(
                                get: { strikePrice2 },
                                set: { strikePrice2 = $0 ?? 0 }
                            ),
                            currency: .usd,
                            helpText: "Second option exercise price for spreads"
                        )
                        .onChange(of: strikePrice2) { _, _ in calculateOptions() }
                    }
                    
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
                        helpText: "Time to expiration in years"
                    )
                    .onChange(of: timeToExpiration) { _, _ in calculateOptions() }
                    
                    PercentageInputField(
                        title: "Risk-Free Rate",
                        subtitle: "Continuous rate",
                        value: Binding(
                            get: { riskFreeRate * 100 },
                            set: { riskFreeRate = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Risk-free interest rate"
                    )
                    .onChange(of: riskFreeRate) { _, _ in calculateOptions() }
                    
                    PercentageInputField(
                        title: "Volatility",
                        subtitle: "Implied volatility",
                        value: Binding(
                            get: { volatility * 100 },
                            set: { volatility = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Implied volatility of the underlying"
                    )
                    .onChange(of: volatility) { _, _ in calculateOptions() }
                    
                    PercentageInputField(
                        title: "Dividend Yield",
                        subtitle: "Continuous dividend",
                        value: Binding(
                            get: { dividendYield * 100 },
                            set: { dividendYield = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Continuous dividend yield"
                    )
                    .onChange(of: dividendYield) { _, _ in calculateOptions() }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Strategy Parameters") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Quantity 1")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Qty", value: $quantity1, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                                .onChange(of: quantity1) { _, _ in calculateOptions() }
                        }
                        
                        if needsSecondQuantity {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Quantity 2")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                TextField("Qty", value: $quantity2, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 80)
                                    .onChange(of: quantity2) { _, _ in calculateOptions() }
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        VStack(spacing: 20) {
            GroupBox("Strategy Analysis") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Strategy Value",
                        value: Formatters.formatCurrency(results.strategyValue, currency: .usd),
                        isHighlighted: true
                    )
                    
                    DetailRow(
                        title: "Max Profit",
                        value: results.maxProfit == Double.infinity ? "Unlimited" : Formatters.formatCurrency(results.maxProfit, currency: .usd)
                    )
                    
                    DetailRow(
                        title: "Max Loss",
                        value: results.maxLoss == -Double.infinity ? "Unlimited" : Formatters.formatCurrency(abs(results.maxLoss), currency: .usd)
                    )
                    
                    DetailRow(
                        title: "Breakeven",
                        value: Formatters.formatCurrency(results.breakeven, currency: .usd)
                    )
                    
                    if results.breakeven2 > 0 {
                        DetailRow(
                            title: "Breakeven 2",
                            value: Formatters.formatCurrency(results.breakeven2, currency: .usd)
                        )
                    }
                    
                    DetailRow(
                        title: "Probability of Profit",
                        value: String(format: "%.1f%%", results.probabilityOfProfit * 100)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("The Greeks") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Delta",
                        value: String(format: "%.4f", results.delta)
                    )
                    
                    DetailRow(
                        title: "Gamma",
                        value: String(format: "%.6f", results.gamma)
                    )
                    
                    DetailRow(
                        title: "Theta",
                        value: String(format: "%.4f", results.theta)
                    )
                    
                    DetailRow(
                        title: "Vega",
                        value: String(format: "%.4f", results.vega)
                    )
                    
                    DetailRow(
                        title: "Rho",
                        value: String(format: "%.4f", results.rho)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var payoffDiagramSection: some View {
        GroupBox("Payoff Diagram") {
            VStack(spacing: 16) {
                if !payoffData.isEmpty {
                    Chart(payoffData) { point in
                        LineMark(
                            x: .value("Spot Price", point.spotPrice),
                            y: .value("Payoff", point.payoff)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        // Breakeven lines
                        if abs(point.payoff) < 1.0 {
                            RuleMark(x: .value("Breakeven", point.spotPrice))
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        }
                        
                        // Zero line
                        RuleMark(y: .value("Zero", 0))
                            .foregroundStyle(.gray)
                            .lineStyle(StrokeStyle(lineWidth: 1))
                    }
                    .frame(height: 300)
                    .chartXAxisLabel("Stock Price at Expiration")
                    .chartYAxisLabel("Profit/Loss ($)")
                }
                
                Text("Shows profit/loss at expiration. Red lines indicate breakeven points.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var greeksAnalysisSection: some View {
        GroupBox("Greeks Analysis") {
            VStack(spacing: 16) {
                if !greeksData.isEmpty {
                    Chart(greeksData) { point in
                        LineMark(
                            x: .value("Spot Price", point.spotPrice),
                            y: .value("Delta", point.delta)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        LineMark(
                            x: .value("Spot Price", point.spotPrice),
                            y: .value("Gamma", point.gamma * 100)  // Scale for visibility
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        
                        LineMark(
                            x: .value("Spot Price", point.spotPrice),
                            y: .value("Theta", point.theta * 10)  // Scale for visibility
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [2, 3]))
                    }
                    .frame(height: 250)
                    .chartXAxisLabel("Stock Price")
                    .chartYAxisLabel("Greeks Values")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("— Delta")
                            .foregroundColor(.blue)
                        Text("⋯ Gamma (×100)")
                            .foregroundColor(.red)
                        Text("⋯ Theta (×10)")
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("Greeks sensitivity to stock price changes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var probabilityAnalysisSection: some View {
        GroupBox("Probability Analysis") {
            VStack(spacing: 16) {
                if !probabilityData.isEmpty {
                    Chart(probabilityData) { point in
                        AreaMark(
                            x: .value("Stock Price", point.spotPrice),
                            y: .value("Probability", point.probability)
                        )
                        .foregroundStyle(.blue.opacity(0.3))
                        
                        LineMark(
                            x: .value("Stock Price", point.spotPrice),
                            y: .value("Probability", point.probability)
                        )
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .frame(height: 200)
                    .chartXAxisLabel("Stock Price at Expiration")
                    .chartYAxisLabel("Probability Density")
                }
                
                Text("Probability distribution of stock price at expiration (log-normal)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var formulasSection: some View {
        GroupBox("Black-Scholes & Greeks Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Key Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Black-Scholes Call Option:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$C = S_0 e^{-qT} N(d_1) - K e^{-rT} N(d_2)$")
                        .frame(height: 40)
                    
                    Text("Black-Scholes Put Option:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$P = K e^{-rT} N(-d_2) - S_0 e^{-qT} N(-d_1)$")
                        .frame(height: 40)
                    
                    Text("d₁ and d₂:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$d_1 = \\frac{\\ln(S_0/K) + (r-q+\\sigma^2/2)T}{\\sigma\\sqrt{T}}$")
                        .frame(height: 50)
                    
                    LaTeX("$d_2 = d_1 - \\sigma\\sqrt{T}$")
                        .frame(height: 40)
                    
                    Text("The Greeks:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$\\Delta = e^{-qT} N(d_1)$ (Call), $\\Delta = -e^{-qT} N(-d_1)$ (Put)")
                        .frame(height: 40)
                    
                    LaTeX("$\\Gamma = \\frac{e^{-qT} n(d_1)}{S_0 \\sigma \\sqrt{T}}$")
                        .frame(height: 40)
                    
                    LaTeX("$\\Theta = -\\frac{S_0 e^{-qT} n(d_1) \\sigma}{2\\sqrt{T}} - rK e^{-rT} N(d_2) + qS_0 e^{-qT} N(d_1)$")
                        .frame(height: 50)
                    
                    LaTeX("$\\nu = S_0 e^{-qT} n(d_1) \\sqrt{T}$")
                        .frame(height: 40)
                    
                    LaTeX("$\\rho = KT e^{-rT} N(d_2)$ (Call), $\\rho = -KT e^{-rT} N(-d_2)$ (Put)")
                        .frame(height: 40)
                    
                    Text("Where: S₀ = spot price, K = strike, r = risk-free rate, q = dividend yield, σ = volatility, T = time, N(x) = cumulative normal, n(x) = normal density")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private var needsSecondStrike: Bool {
        switch strategy {
        case .call, .put:
            return false
        case .callSpread, .putSpread, .strangle, .butterfly, .condor, .collar, .ratio:
            return true
        case .straddle:
            return false
        }
    }
    
    private var needsSecondQuantity: Bool {
        switch strategy {
        case .callSpread, .putSpread, .straddle, .strangle, .butterfly, .condor, .collar, .ratio:
            return true
        default:
            return false
        }
    }
    
    private func calculateOptions() {
        // Calculate Black-Scholes option prices
        let callPrice = blackScholesCall()
        let putPrice = blackScholesPut()
        
        // Calculate strategy value based on selected strategy
        let strategyValue = calculateStrategyValue(callPrice: callPrice, putPrice: putPrice)
        
        // Calculate Greeks
        let greeks = calculateGreeks()
        
        // Calculate strategy metrics
        let (maxProfit, maxLoss, breakeven, breakeven2) = calculateStrategyMetrics()
        
        // Calculate probability of profit
        let probProfit = calculateProbabilityOfProfit()
        
        results = OptionsResults(
            optionPrice: strategy == .call ? callPrice : putPrice,
            strategyValue: strategyValue,
            maxProfit: maxProfit,
            maxLoss: maxLoss,
            breakeven: breakeven,
            breakeven2: breakeven2,
            delta: greeks.delta,
            gamma: greeks.gamma,
            theta: greeks.theta,
            vega: greeks.vega,
            rho: greeks.rho,
            probabilityOfProfit: probProfit
        )
        
        generatePayoffData()
        generateGreeksData()
        generateProbabilityData()
    }
    
    private func blackScholesCall() -> Double {
        let d1 = calculateD1()
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nd1 = cumulativeNormal(d1)
        let nd2 = cumulativeNormal(d2)
        
        let callPrice = spotPrice * exp(-dividendYield * timeToExpiration) * nd1 -
                       strikePrice * exp(-riskFreeRate * timeToExpiration) * nd2
        
        return max(0, callPrice)
    }
    
    private func blackScholesPut() -> Double {
        let d1 = calculateD1()
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nmd1 = cumulativeNormal(-d1)
        let nmd2 = cumulativeNormal(-d2)
        
        let putPrice = strikePrice * exp(-riskFreeRate * timeToExpiration) * nmd2 -
                      spotPrice * exp(-dividendYield * timeToExpiration) * nmd1
        
        return max(0, putPrice)
    }
    
    private func calculateD1() -> Double {
        let numerator = log(spotPrice / strikePrice) + 
                       (riskFreeRate - dividendYield + 0.5 * volatility * volatility) * timeToExpiration
        let denominator = volatility * sqrt(timeToExpiration)
        return numerator / denominator
    }
    
    private func cumulativeNormal(_ x: Double) -> Double {
        // Approximation of cumulative normal distribution
        return 0.5 * (1 + erf(x / sqrt(2)))
    }
    
    private func normalDensity(_ x: Double) -> Double {
        return exp(-0.5 * x * x) / sqrt(2 * .pi)
    }
    
    private func calculateStrategyValue(callPrice: Double, putPrice: Double) -> Double {
        switch strategy {
        case .call:
            return callPrice * Double(quantity1)
        case .put:
            return putPrice * Double(quantity1)
        case .callSpread:
            // Bull call spread: long lower strike, short higher strike
            let longCall = callPrice * Double(quantity1)
            let shortCall = blackScholesCallWithStrike(strikePrice2) * Double(quantity2)
            return longCall - shortCall
        case .putSpread:
            // Bear put spread: long higher strike, short lower strike
            let longPut = blackScholesPutWithStrike(strikePrice2) * Double(quantity1)
            let shortPut = putPrice * Double(quantity2)
            return longPut - shortPut
        case .straddle:
            return (callPrice + putPrice) * Double(quantity1)
        case .strangle:
            let otherStrikePut = blackScholesPutWithStrike(strikePrice2)
            return (callPrice * Double(quantity1)) + (otherStrikePut * Double(quantity2))
        case .butterfly:
            // Long butterfly: buy 1 low, sell 2 middle, buy 1 high
            let lowCall = callPrice
            let midCall = blackScholesCallWithStrike((strikePrice + strikePrice2) / 2)
            let highCall = blackScholesCallWithStrike(strikePrice2)
            return lowCall - 2 * midCall + highCall
        case .condor:
            // Iron condor approximation
            return (callPrice + putPrice) * 0.5
        case .collar:
            // Protective collar: long stock, long put, short call
            let putComponent = putPrice * Double(quantity1)
            let callComponent = blackScholesCallWithStrike(strikePrice2) * Double(quantity2)
            return putComponent - callComponent
        case .ratio:
            return callPrice * Double(quantity1) - blackScholesCallWithStrike(strikePrice2) * Double(quantity2)
        }
    }
    
    private func blackScholesCallWithStrike(_ strike: Double) -> Double {
        let originalStrike = strikePrice
        strikePrice = strike
        let price = blackScholesCall()
        strikePrice = originalStrike
        return price
    }
    
    private func blackScholesPutWithStrike(_ strike: Double) -> Double {
        let originalStrike = strikePrice
        strikePrice = strike
        let price = blackScholesPut()
        strikePrice = originalStrike
        return price
    }
    
    private func calculateGreeks() -> (delta: Double, gamma: Double, theta: Double, vega: Double, rho: Double) {
        let d1 = calculateD1()
        let d2 = d1 - volatility * sqrt(timeToExpiration)
        
        let nd1 = cumulativeNormal(d1)
        let nd2 = cumulativeNormal(d2)
        let npd1 = normalDensity(d1)
        
        let callDelta = exp(-dividendYield * timeToExpiration) * nd1
        let putDelta = -exp(-dividendYield * timeToExpiration) * cumulativeNormal(-d1)
        
        let gamma = exp(-dividendYield * timeToExpiration) * npd1 / (spotPrice * volatility * sqrt(timeToExpiration))
        
        let callTheta = -(spotPrice * exp(-dividendYield * timeToExpiration) * npd1 * volatility) / (2 * sqrt(timeToExpiration)) -
                       riskFreeRate * strikePrice * exp(-riskFreeRate * timeToExpiration) * nd2 +
                       dividendYield * spotPrice * exp(-dividendYield * timeToExpiration) * nd1
        
        let vega = spotPrice * exp(-dividendYield * timeToExpiration) * npd1 * sqrt(timeToExpiration)
        
        let callRho = strikePrice * timeToExpiration * exp(-riskFreeRate * timeToExpiration) * nd2
        let putRho = -strikePrice * timeToExpiration * exp(-riskFreeRate * timeToExpiration) * cumulativeNormal(-d2)
        
        // Strategy Greeks (simplified for individual options)
        let delta = strategy == .call ? callDelta : putDelta
        let theta = callTheta / 365.0  // Convert to daily
        let rho = strategy == .call ? callRho : putRho
        
        return (delta, gamma, theta, vega, rho)
    }
    
    private func calculateStrategyMetrics() -> (maxProfit: Double, maxLoss: Double, breakeven: Double, breakeven2: Double) {
        switch strategy {
        case .call:
            let premium = results.optionPrice
            return (Double.infinity, -premium, strikePrice + premium, 0.0)
        case .put:
            let premium = results.optionPrice
            return (strikePrice - premium, -premium, strikePrice - premium, 0.0)
        case .callSpread:
            let netPremium = results.strategyValue
            let maxProfit = (strikePrice2 - strikePrice) - netPremium
            return (maxProfit, -netPremium, strikePrice + netPremium, 0.0)
        case .putSpread:
            let netPremium = results.strategyValue
            let maxProfit = (strikePrice2 - strikePrice) - netPremium
            return (maxProfit, -netPremium, strikePrice2 - netPremium, 0.0)
        case .straddle:
            let premium = results.strategyValue
            return (Double.infinity, -premium, strikePrice - premium, strikePrice + premium)
        case .strangle:
            let premium = results.strategyValue
            let lowerBreakeven = min(strikePrice, strikePrice2) - premium
            let upperBreakeven = max(strikePrice, strikePrice2) + premium
            return (Double.infinity, -premium, lowerBreakeven, upperBreakeven)
        default:
            // Simplified for other strategies
            return (results.strategyValue * 2, -results.strategyValue, strikePrice, 0.0)
        }
    }
    
    private func calculateProbabilityOfProfit() -> Double {
        // Simplified probability calculation using log-normal distribution
        let drift = riskFreeRate - dividendYield - 0.5 * volatility * volatility
        let diffusion = volatility * sqrt(timeToExpiration)
        
        let logReturn = log(results.breakeven / spotPrice)
        let zScore = (logReturn - drift * timeToExpiration) / diffusion
        
        return 1.0 - cumulativeNormal(zScore)
    }
    
    private func generatePayoffData() {
        payoffData = []
        
        let priceRange = (spotPrice * 0.5, spotPrice * 1.5)
        let numPoints = 50
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            let payoff = calculatePayoffAtExpiration(spotPrice: price)
            
            payoffData.append(PayoffPoint(
                spotPrice: price,
                payoff: payoff,
                intrinsicValue: max(0, price - strikePrice),
                timeValue: 0  // At expiration
            ))
        }
    }
    
    private func calculatePayoffAtExpiration(spotPrice: Double) -> Double {
        switch strategy {
        case .call:
            return max(0, spotPrice - strikePrice) - results.optionPrice
        case .put:
            return max(0, strikePrice - spotPrice) - results.optionPrice
        case .callSpread:
            let longPayoff = max(0, spotPrice - strikePrice)
            let shortPayoff = max(0, spotPrice - strikePrice2)
            return longPayoff - shortPayoff - results.strategyValue
        case .putSpread:
            let longPayoff = max(0, strikePrice2 - spotPrice)
            let shortPayoff = max(0, strikePrice - spotPrice)
            return longPayoff - shortPayoff - results.strategyValue
        case .straddle:
            return max(0, spotPrice - strikePrice) + max(0, strikePrice - spotPrice) - results.strategyValue
        case .strangle:
            let callPayoff = max(0, spotPrice - strikePrice)
            let putPayoff = max(0, strikePrice2 - spotPrice)
            return callPayoff + putPayoff - results.strategyValue
        default:
            // Simplified for other strategies
            return max(0, spotPrice - strikePrice) - results.strategyValue
        }
    }
    
    private func generateGreeksData() {
        greeksData = []
        
        let priceRange = (spotPrice * 0.7, spotPrice * 1.3)
        let numPoints = 30
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            
            // Calculate Greeks at this spot price
            let originalSpot = spotPrice
            spotPrice = price
            let greeks = calculateGreeks()
            spotPrice = originalSpot
            
            greeksData.append(GreeksPoint(
                spotPrice: price,
                delta: greeks.delta,
                gamma: greeks.gamma,
                theta: greeks.theta,
                vega: greeks.vega
            ))
        }
    }
    
    private func generateProbabilityData() {
        probabilityData = []
        
        let priceRange = (spotPrice * 0.5, spotPrice * 1.5)
        let numPoints = 50
        let step = (priceRange.1 - priceRange.0) / Double(numPoints)
        
        let drift = riskFreeRate - dividendYield - 0.5 * volatility * volatility
        let diffusion = volatility * sqrt(timeToExpiration)
        
        var cumulative = 0.0
        
        for i in 0...numPoints {
            let price = priceRange.0 + Double(i) * step
            
            // Log-normal probability density
            let logReturn = log(price / spotPrice)
            let z = (logReturn - drift * timeToExpiration) / diffusion
            let probability = exp(-0.5 * z * z) / (price * diffusion * sqrt(2 * .pi))
            
            cumulative += probability * step
            
            probabilityData.append(ProbabilityPoint(
                spotPrice: price,
                probability: probability,
                cumulative: cumulative
            ))
        }
    }
}

#Preview {
    OptionsStrategiesView()
        .frame(width: 1400, height: 1200)
}
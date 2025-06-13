//
//  OptionsCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/9/25.
//

import SwiftUI
import SwiftData
import Charts
import LaTeXSwiftUI

/// Advanced options pricing calculator using Black-Scholes model
struct OptionsCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    @State private var calculationName: String = ""
    @State private var spotPrice: Double = 100.0
    @State private var strikePrice: Double = 100.0
    @State private var timeToExpiry: Double = 0.25 // 3 months
    @State private var riskFreeRate: Double = 5.0
    @State private var volatility: Double = 20.0
    @State private var optionType: CalculationEngine.OptionType = .call
    @State private var currency: Currency = .usd
    
    @State private var isCalculating: Bool = false
    @State private var calculationResult: OptionsResult?
    @State private var validationErrors: [String] = []
    @State private var showingGreeksAnalysis: Bool = false
    @State private var showingVolatilitySurface: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                HStack(alignment: .top, spacing: 24) {
                    inputSection
                    resultSection
                }
                
                if let result = calculationResult {
                    analysisSection
                }
            }
            .padding(24)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Calculate") {
                    performCalculation()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canCalculate)
                
                Menu {
                    Button("Save Calculation") {
                        saveCalculation()
                    }
                    .disabled(!canSave)
                    
                    Button("Greeks Analysis") {
                        showingGreeksAnalysis = true
                    }
                    .disabled(calculationResult == nil)
                    
                    Button("Volatility Surface") {
                        showingVolatilitySurface = true
                    }
                    .disabled(calculationResult == nil)
                    
                    Divider()
                    
                    Button("Reset Fields") {
                        resetFields()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingGreeksAnalysis) {
            if let result = calculationResult {
                GreeksAnalysisView(
                    baseResult: result,
                    optionData: currentOptionData
                )
            }
        }
        .sheet(isPresented: $showingVolatilitySurface) {
            if let result = calculationResult {
                VolatilitySurfaceView(
                    baseResult: result,
                    optionData: currentOptionData
                )
            }
        }
        .onAppear {
            currency = mainViewModel.userPreferences.defaultCurrency
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Options Calculator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Black-Scholes options pricing model with Greeks analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if isCalculating {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else if calculationResult != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Text("Advanced Derivatives Pricing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Black-Scholes Formula Display
            LaTeX("$$C = S_0 \\cdot N(d_1) - K \\cdot e^{-rT} \\cdot N(d_2)$$")
                .frame(height: 40)
                .padding(.vertical, 8)
            
            Text("where $d_1 = \\frac{\\ln(S_0/K) + (r + \\sigma^2/2)T}{\\sigma\\sqrt{T}}$ and $d_2 = d_1 - \\sigma\\sqrt{T}$")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Error display
            if !validationErrors.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(validationErrors, id: \.self) { error in
                        Text("• \(error)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.red.opacity(0.1))
                )
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
            // Basic option parameters
            GroupBox("Option Parameters") {
                VStack(spacing: 16) {
                    // Calculation name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Calculation Name")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        TextField("Enter calculation name", text: $calculationName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Option type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Option Type")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Picker("Option Type", selection: $optionType) {
                            Text("Call Option").tag(CalculationEngine.OptionType.call)
                            Text("Put Option").tag(CalculationEngine.OptionType.put)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: optionType) { _, _ in
                            clearResults()
                        }
                    }
                    
                    // Spot price
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current Stock Price (S₀)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                            }
                            .buttonStyle(.plain)
                            .help("Current market price of the underlying asset")
                        }
                        
                        CurrencyInputField(
                            title: "Spot Price",
                            value: Binding(
                                get: { spotPrice },
                                set: { 
                                    spotPrice = max(0, $0 ?? 0)
                                    clearResults()
                                }
                            ),
                            currency: currency,
                            isRequired: true,
                            helpText: "Current market price of the underlying asset"
                        )
                    }
                    
                    // Strike price
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Strike Price (K)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                            }
                            .buttonStyle(.plain)
                            .help("Exercise price of the option")
                        }
                        
                        CurrencyInputField(
                            title: "Strike Price",
                            value: Binding(
                                get: { strikePrice },
                                set: { 
                                    strikePrice = max(0, $0 ?? 0)
                                    clearResults()
                                }
                            ),
                            currency: currency,
                            isRequired: true,
                            helpText: "Exercise price of the option"
                        )
                    }
                    
                    // Time to expiry
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Time to Expiry (Years)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                            }
                            .buttonStyle(.plain)
                            .help("Time remaining until option expiration")
                        }
                        
                        TextField("Years", value: $timeToExpiry, format: .number.precision(.fractionLength(4)))
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: timeToExpiry) { _, newValue in
                                timeToExpiry = max(0.0001, newValue)
                                clearResults()
                            }
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Market parameters
            GroupBox("Market Parameters") {
                VStack(spacing: 16) {
                    // Risk-free rate
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Risk-Free Rate (%)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                            }
                            .buttonStyle(.plain)
                            .help("Risk-free interest rate (e.g., Treasury rate)")
                        }
                        
                        PercentageInputField(
                            title: "Risk-Free Rate",
                            value: Binding(
                                get: { riskFreeRate },
                                set: { 
                                    if let newValue = $0 { 
                                        riskFreeRate = max(0, newValue)
                                        clearResults()
                                    }
                                }
                            ),
                            isRequired: true,
                            helpText: "Risk-free interest rate (e.g., Treasury rate)"
                        )
                    }
                    
                    // Volatility
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Volatility (σ %)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                            }
                            .buttonStyle(.plain)
                            .help("Annualized volatility of the underlying asset")
                        }
                        
                        PercentageInputField(
                            title: "Volatility",
                            value: Binding(
                                get: { volatility },
                                set: { 
                                    if let newValue = $0 { 
                                        volatility = max(0, newValue)
                                        clearResults()
                                    }
                                }
                            ),
                            isRequired: true,
                            helpText: "Annualized volatility of the underlying asset"
                        )
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Currency selection
            GroupBox("Settings") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Currency")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Picker("Currency", selection: $currency) {
                        ForEach(Currency.allCases.prefix(8)) { curr in
                            Text("\(curr.displayName) (\(curr.symbol))")
                                .tag(curr)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: currency) { _, _ in
                        clearResults()
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: 20) {
            if let result = calculationResult {
                // Primary result - Option Price
                GroupBox {
                    VStack(spacing: 16) {
                        Text("\(optionType == .call ? "Call" : "Put") Option Price")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(currency.formatValue(result.optionPrice))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Black-Scholes theoretical value")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        // Moneyness indicator
                        HStack {
                            let moneyness = getMoneyness()
                            Image(systemName: getMoneynessSFSymbol(moneyness))
                                .foregroundColor(getMoneynesColor(moneyness))
                            
                            Text(moneyness)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(getMoneynesColor(moneyness))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(getMoneynesColor(getMoneyness()).opacity(0.1))
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Greeks
                GroupBox("Option Greeks") {
                    VStack(spacing: 12) {
                        DetailRow(
                            title: "Delta (Δ)",
                            value: String(format: "%.4f", result.delta),
                            isHighlighted: true
                        )
                        DetailRow(
                            title: "Gamma (Γ)",
                            value: String(format: "%.6f", result.gamma)
                        )
                        DetailRow(
                            title: "Theta (Θ)",
                            value: String(format: "%.4f", result.theta)
                        )
                        DetailRow(
                            title: "Vega (ν)",
                            value: String(format: "%.4f", result.vega)
                        )
                        DetailRow(
                            title: "Rho (ρ)",
                            value: String(format: "%.4f", result.rho)
                        )
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Risk Metrics
                GroupBox("Risk Analysis") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(generateRiskInsights(), id: \.self) { insight in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                
                                Text(insight)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Action buttons
                VStack(spacing: 12) {
                    Button("Greeks Analysis") {
                        showingGreeksAnalysis = true
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    
                    Button("Volatility Surface") {
                        showingVolatilitySurface = true
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
            } else {
                // Placeholder when no results
                GroupBox {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("Enter option parameters and calculate to see pricing")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var analysisSection: some View {
        VStack(spacing: 20) {
            // Option price sensitivity chart
            if let result = calculationResult {
                GroupBox("Price Sensitivity Analysis") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Option Price vs Underlying Price")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Chart {
                            ForEach(generatePriceSensitivityData(), id: \.spotPrice) { point in
                                LineMark(
                                    x: .value("Spot Price", point.spotPrice),
                                    y: .value("Option Price", point.optionPrice)
                                )
                                .foregroundStyle(.blue)
                                .interpolationMethod(.catmullRom)
                                
                                // Highlight current spot price
                                if abs(point.spotPrice - spotPrice) < 1 {
                                    PointMark(
                                        x: .value("Spot Price", point.spotPrice),
                                        y: .value("Option Price", point.optionPrice)
                                    )
                                    .foregroundStyle(.red)
                                    .symbolSize(100)
                                }
                            }
                            
                            // Add strike price line
                            RuleMark(x: .value("Strike", strikePrice))
                                .foregroundStyle(.gray)
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let price = value.as(Double.self) {
                                        Text(currency.symbol + "\(Int(price))")
                                    }
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let price = value.as(Double.self) {
                                        Text(currency.symbol + String(format: "%.2f", price))
                                    }
                                }
                            }
                        }
                        
                        Text("Red dot shows current spot price. Dashed line shows strike price.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var canCalculate: Bool {
        !calculationName.isEmpty &&
        spotPrice > 0 &&
        strikePrice > 0 &&
        timeToExpiry > 0 &&
        riskFreeRate >= 0 &&
        volatility > 0
    }
    
    private var canSave: Bool {
        canCalculate && calculationResult != nil
    }
    
    private var currentOptionData: (spotPrice: Double, strikePrice: Double, timeToExpiry: Double, riskFreeRate: Double, volatility: Double, optionType: CalculationEngine.OptionType) {
        (spotPrice, strikePrice, timeToExpiry, riskFreeRate, volatility, optionType)
    }
    
    private func performCalculation() {
        guard canCalculate else {
            validateInputs()
            return
        }
        
        isCalculating = true
        validationErrors = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let optionPrice = CalculationEngine.calculateBlackScholesOptionPrice(
                spotPrice: spotPrice,
                strikePrice: strikePrice,
                timeToExpiry: timeToExpiry,
                riskFreeRate: riskFreeRate,
                volatility: volatility,
                optionType: optionType
            )
            
            let delta = CalculationEngine.calculateOptionDelta(
                spotPrice: spotPrice,
                strikePrice: strikePrice,
                timeToExpiry: timeToExpiry,
                riskFreeRate: riskFreeRate,
                volatility: volatility,
                optionType: optionType
            )
            
            // Calculate other Greeks (simplified calculations)
            let gamma = calculateGamma()
            let theta = calculateTheta()
            let vega = calculateVega()
            let rho = calculateRho()
            
            calculationResult = OptionsResult(
                optionPrice: optionPrice,
                delta: delta,
                gamma: gamma,
                theta: theta,
                vega: vega,
                rho: rho
            )
            
            isCalculating = false
        }
    }
    
    private func validateInputs() {
        validationErrors = []
        
        if calculationName.isEmpty {
            validationErrors.append("Calculation name is required")
        }
        
        if spotPrice <= 0 {
            validationErrors.append("Spot price must be positive")
        }
        
        if strikePrice <= 0 {
            validationErrors.append("Strike price must be positive")
        }
        
        if timeToExpiry <= 0 {
            validationErrors.append("Time to expiry must be positive")
        }
        
        if volatility <= 0 {
            validationErrors.append("Volatility must be positive")
        }
    }
    
    private func clearResults() {
        calculationResult = nil
        validationErrors = []
    }
    
    private func resetFields() {
        calculationName = ""
        spotPrice = 100.0
        strikePrice = 100.0
        timeToExpiry = 0.25
        riskFreeRate = 5.0
        volatility = 20.0
        optionType = .call
        clearResults()
    }
    
    private func saveCalculation() {
        // Implementation for saving calculation
    }
    
    private func getMoneyness() -> String {
        if optionType == .call {
            if spotPrice > strikePrice * 1.05 {
                return "In-the-Money"
            } else if spotPrice < strikePrice * 0.95 {
                return "Out-of-the-Money"
            } else {
                return "At-the-Money"
            }
        } else {
            if spotPrice < strikePrice * 0.95 {
                return "In-the-Money"
            } else if spotPrice > strikePrice * 1.05 {
                return "Out-of-the-Money"
            } else {
                return "At-the-Money"
            }
        }
    }
    
    private func getMoneynessSFSymbol(_ moneyness: String) -> String {
        switch moneyness {
        case "In-the-Money": return "arrow.up.circle.fill"
        case "Out-of-the-Money": return "arrow.down.circle.fill"
        default: return "minus.circle.fill"
        }
    }
    
    private func getMoneynesColor(_ moneyness: String) -> Color {
        switch moneyness {
        case "In-the-Money": return .green
        case "Out-of-the-Money": return .red
        default: return .orange
        }
    }
    
    private func generateRiskInsights() -> [String] {
        guard let result = calculationResult else { return [] }
        
        var insights: [String] = []
        
        if abs(result.delta) > 0.7 {
            insights.append("High delta indicates strong correlation with underlying price movements")
        }
        
        if result.gamma > 0.05 {
            insights.append("High gamma suggests delta will change rapidly with price movements")
        }
        
        if abs(result.theta) > result.optionPrice * 0.1 {
            insights.append("High time decay - option loses significant value daily")
        }
        
        if result.vega > result.optionPrice * 0.5 {
            insights.append("High vega indicates strong sensitivity to volatility changes")
        }
        
        if timeToExpiry < 0.083 { // Less than 1 month
            insights.append("Short time to expiry increases time decay risk")
        }
        
        return insights
    }
    
    private func generatePriceSensitivityData() -> [PriceSensitivityPoint] {
        var data: [PriceSensitivityPoint] = []
        let priceRange = spotPrice * 0.4 // ±40% of current spot price
        
        for i in stride(from: spotPrice - priceRange, through: spotPrice + priceRange, by: priceRange / 20) {
            let optionPrice = CalculationEngine.calculateBlackScholesOptionPrice(
                spotPrice: i,
                strikePrice: strikePrice,
                timeToExpiry: timeToExpiry,
                riskFreeRate: riskFreeRate,
                volatility: volatility,
                optionType: optionType
            )
            data.append(PriceSensitivityPoint(spotPrice: i, optionPrice: optionPrice))
        }
        
        return data
    }
    
    // Simplified Greeks calculations
    private func calculateGamma() -> Double {
        // Numerical approximation
        let h = 0.01
        let delta1 = CalculationEngine.calculateOptionDelta(
            spotPrice: spotPrice + h,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate,
            volatility: volatility,
            optionType: optionType
        )
        let delta2 = CalculationEngine.calculateOptionDelta(
            spotPrice: spotPrice - h,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate,
            volatility: volatility,
            optionType: optionType
        )
        return (delta1 - delta2) / (2 * h)
    }
    
    private func calculateTheta() -> Double {
        // Numerical approximation
        let h = 1.0 / 365.0 // 1 day
        guard timeToExpiry > h else { return 0 }
        
        let price1 = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate,
            volatility: volatility,
            optionType: optionType
        )
        let price2 = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry - h,
            riskFreeRate: riskFreeRate,
            volatility: volatility,
            optionType: optionType
        )
        return price2 - price1
    }
    
    private func calculateVega() -> Double {
        // Numerical approximation
        let h = 0.01
        let price1 = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate,
            volatility: volatility + h,
            optionType: optionType
        )
        let price2 = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate,
            volatility: volatility - h,
            optionType: optionType
        )
        return (price1 - price2) / (2 * h)
    }
    
    private func calculateRho() -> Double {
        // Numerical approximation
        let h = 0.01
        let price1 = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate + h,
            volatility: volatility,
            optionType: optionType
        )
        let price2 = CalculationEngine.calculateBlackScholesOptionPrice(
            spotPrice: spotPrice,
            strikePrice: strikePrice,
            timeToExpiry: timeToExpiry,
            riskFreeRate: riskFreeRate - h,
            volatility: volatility,
            optionType: optionType
        )
        return (price1 - price2) / (2 * h)
    }
}

// MARK: - Supporting Types

struct OptionsResult {
    let optionPrice: Double
    let delta: Double
    let gamma: Double
    let theta: Double
    let vega: Double
    let rho: Double
}

struct PriceSensitivityPoint {
    let spotPrice: Double
    let optionPrice: Double
}

// MARK: - Supporting Views

struct GreeksAnalysisView: View {
    let baseResult: OptionsResult
    let optionData: (spotPrice: Double, strikePrice: Double, timeToExpiry: Double, riskFreeRate: Double, volatility: Double, optionType: CalculationEngine.OptionType)
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Greeks Analysis")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    // Greeks explanations with charts would go here
                    GroupBox("Delta Analysis") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Delta measures the rate of change of option price with respect to the underlying asset price.")
                                .font(.body)
                            
                            DetailRow(title: "Current Delta", value: String(format: "%.4f", baseResult.delta))
                            DetailRow(title: "Interpretation", value: "For every $1 move in underlying, option moves $\(String(format: "%.2f", abs(baseResult.delta)))")
                        }
                        .padding()
                    }
                    
                    // More Greeks analysis would continue here...
                }
                .padding()
            }
            .navigationTitle("Greeks Analysis")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 600, minHeight: 500)
    }
}

struct VolatilitySurfaceView: View {
    let baseResult: OptionsResult
    let optionData: (spotPrice: Double, strikePrice: Double, timeToExpiry: Double, riskFreeRate: Double, volatility: Double, optionType: CalculationEngine.OptionType)
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Volatility Surface")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    // Volatility surface visualization would go here
                    GroupBox("Implied Volatility Analysis") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Current Implied Volatility: \(String(format: "%.2f%%", optionData.volatility))")
                                .font(.headline)
                            
                            Text("Volatility surface shows how implied volatility varies across different strikes and expiration dates.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Volatility Surface")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 600, minHeight: 500)
    }
}

#Preview {
    OptionsCalculatorView()
        .environment(MainViewModel())
        .frame(width: 1200, height: 800)
}
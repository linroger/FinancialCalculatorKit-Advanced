//
//  SwapsCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI

struct SwapsCalculatorView: View {
    @State private var notionalAmount: Double = 10000000.0  // $10M
    @State private var fixedRate: Double = 0.05  // 5%
    @State private var currentRate: Double = 0.045  // 4.5%
    @State private var tenor: Double = 5.0  // 5 years
    @State private var paymentFrequency: PaymentFrequency = .semiAnnual
    @State private var swapType: SwapType = .interestRate
    @State private var dayCountConvention: DayCount = .actual360
    @State private var timeElapsed: Double = 1.0  // 1 year elapsed
    
    @State private var results: SwapResults = SwapResults()
    @State private var cashFlowData: [CashFlowPoint] = []
    @State private var sensitivityData: [SensitivityPoint] = []
    
    enum SwapType: String, CaseIterable, Identifiable {
        case interestRate = "interestRate"
        case currency = "currency"
        case commodity = "commodity"
        case totalReturn = "totalReturn"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .interestRate: return "Interest Rate Swap"
            case .currency: return "Currency Swap"
            case .commodity: return "Commodity Swap"
            case .totalReturn: return "Total Return Swap"
            }
        }
    }
    
    enum DayCount: String, CaseIterable, Identifiable {
        case actual360 = "actual360"
        case actual365 = "actual365"
        case thirty360 = "thirty360"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .actual360: return "Actual/360"
            case .actual365: return "Actual/365"
            case .thirty360: return "30/360"
            }
        }
    }
    
    struct SwapResults {
        var swapValue: Double = 0.0
        var fixedLegPV: Double = 0.0
        var floatingLegPV: Double = 0.0
        var dv01: Double = 0.0
        var duration: Double = 0.0
        var convexity: Double = 0.0
        var annualizedPnL: Double = 0.0
    }
    
    struct CashFlowPoint: Identifiable {
        let id = UUID()
        let period: Int
        let date: Double
        let fixedPayment: Double
        let floatingPayment: Double
        let netPayment: Double
        let presentValue: Double
    }
    
    struct SensitivityPoint: Identifiable {
        let id = UUID()
        let rateShift: Double
        let swapValue: Double
        let dv01: Double
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
                    cashFlowSection
                    sensitivitySection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            calculateSwap()
            generateCashFlowData()
            generateSensitivityData()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Swap Contracts Pricing")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Comprehensive swap pricing with risk analytics and cash flow analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Swap Type", selection: $swapType) {
                    ForEach(SwapType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 400)
                .onChange(of: swapType) { _, _ in
                    calculateAndUpdate()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
            GroupBox("Swap Terms") {
                VStack(spacing: 16) {
                    CurrencyInputField(
                        title: "Notional Amount",
                        subtitle: "Principal amount",
                        value: Binding(
                            get: { notionalAmount },
                            set: { notionalAmount = $0 ?? 0 }
                        ),
                        currency: .usd,
                        helpText: "Principal amount for swap calculations"
                    )
                    .onChange(of: notionalAmount) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Fixed Rate",
                        subtitle: "Fixed leg rate",
                        value: Binding(
                            get: { fixedRate * 100 },
                            set: { fixedRate = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Fixed rate paid/received in swap"
                    )
                    .onChange(of: fixedRate) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Current Floating Rate",
                        subtitle: "Floating rate index",
                        value: Binding(
                            get: { currentRate * 100 },
                            set: { currentRate = ($0 ?? 0) / 100 }
                        ),
                        helpText: "Current level of floating rate index"
                    )
                    .onChange(of: currentRate) { _, _ in calculateAndUpdate() }
                    
                    InputFieldView(
                        title: "Tenor (Years)",
                        subtitle: "Total maturity",
                        value: Binding(
                            get: { String(format: "%.1f", tenor) },
                            set: { tenor = Double($0) ?? 0 }
                        ),
                        placeholder: "5.0",
                        keyboardType: .decimalPad,
                        validation: .positiveNumber,
                        helpText: "Total maturity of the swap"
                    )
                    .onChange(of: tenor) { _, _ in calculateAndUpdate() }
                    
                    InputFieldView(
                        title: "Time Elapsed",
                        subtitle: "Years since inception",
                        value: Binding(
                            get: { String(format: "%.2f", timeElapsed) },
                            set: { timeElapsed = Double($0) ?? 0 }
                        ),
                        placeholder: "1.0",
                        keyboardType: .decimalPad,
                        validation: .nonNegativeNumber,
                        helpText: "Years elapsed since swap inception"
                    )
                    .onChange(of: timeElapsed) { _, _ in calculateAndUpdate() }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Market Conventions") {
                VStack(spacing: 16) {
                    HStack {
                        Text("Payment Frequency")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Picker("Payment Frequency", selection: $paymentFrequency) {
                            ForEach(PaymentFrequency.allCases) { freq in
                                Text(freq.displayName).tag(freq)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: paymentFrequency) { _, _ in calculateAndUpdate() }
                    }
                    
                    HStack {
                        Text("Day Count")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Picker("Day Count", selection: $dayCountConvention) {
                            ForEach(DayCount.allCases) { convention in
                                Text(convention.displayName).tag(convention)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: dayCountConvention) { _, _ in calculateAndUpdate() }
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
            GroupBox("Swap Valuation") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Swap Value",
                        value: String(format: "$%.2f", results.swapValue),
                        isHighlighted: abs(results.swapValue) > 0.01
                    )
                    
                    DetailRow(
                        title: "Fixed Leg PV",
                        value: String(format: "$%.2f", results.fixedLegPV)
                    )
                    
                    DetailRow(
                        title: "Floating Leg PV",
                        value: String(format: "$%.2f", results.floatingLegPV)
                    )
                    
                    DetailRow(
                        title: "Annualized P&L",
                        value: String(format: "$%.2f", results.annualizedPnL),
                        isHighlighted: abs(results.annualizedPnL) > 0.01
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Metrics") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "DV01",
                        value: String(format: "$%.2f", results.dv01)
                    )
                    
                    DetailRow(
                        title: "Modified Duration",
                        value: String(format: "%.4f", results.duration)
                    )
                    
                    DetailRow(
                        title: "Convexity",
                        value: String(format: "%.6f", results.convexity)
                    )
                    
                    DetailRow(
                        title: "Interest Rate Risk",
                        value: riskLevel,
                        isHighlighted: riskLevel == "High"
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
        GroupBox("Swap Pricing Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Valuation Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Swap Value:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$V_{swap} = PV_{fixed} - PV_{floating}$")
                        .frame(height: 40)
                    
                    Text("Fixed Leg Present Value:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$PV_{fixed} = R_{fixed} \\times N \\times \\sum_{i=1}^{n} \\frac{\\Delta t_i}{(1+r_i)^{t_i}}$")
                        .frame(height: 40)
                    
                    Text("Floating Leg Present Value:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$PV_{floating} = N \\times (1 - DF_n)$")
                        .frame(height: 40)
                    
                    Text("DV01 Calculation:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$DV01 = -\\frac{dV}{dr} \\times 0.0001$")
                        .frame(height: 40)
                    
                    Text("Modified Duration:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$D_{mod} = -\\frac{1}{V} \\times \\frac{dV}{dr}$")
                        .frame(height: 40)
                }
                
                Text("where: N = notional, R = fixed rate, DF = discount factor, r = interest rate")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var cashFlowSection: some View {
        GroupBox("Cash Flow Analysis") {
            VStack(spacing: 16) {
                if !cashFlowData.isEmpty {
                    Chart(cashFlowData) { point in
                        BarMark(
                            x: .value("Period", point.period),
                            y: .value("Fixed Payment", point.fixedPayment)
                        )
                        .foregroundStyle(.blue)
                        
                        BarMark(
                            x: .value("Period", point.period),
                            y: .value("Floating Payment", -point.floatingPayment)
                        )
                        .foregroundStyle(.red)
                        
                        LineMark(
                            x: .value("Period", point.period),
                            y: .value("Net Payment", point.netPayment)
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .frame(height: 250)
                    .chartYAxisLabel("Payment Amount")
                    .chartXAxisLabel("Payment Period")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("■ Fixed Payments")
                            .foregroundColor(.blue)
                        Text("■ Floating Payments")
                            .foregroundColor(.red)
                        Text("— Net Cash Flow")
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var sensitivitySection: some View {
        GroupBox("Interest Rate Sensitivity") {
            VStack(spacing: 16) {
                if !sensitivityData.isEmpty {
                    Chart(sensitivityData) { point in
                        LineMark(
                            x: .value("Rate Change (bps)", point.rateShift * 10000),
                            y: .value("Swap Value", point.swapValue)
                        )
                        .foregroundStyle(.blue)
                        
                        PointMark(
                            x: .value("Rate Change (bps)", 0),
                            y: .value("Current Value", results.swapValue)
                        )
                        .foregroundStyle(.red)
                        .symbol(.circle)
                        .symbolSize(100)
                    }
                    .frame(height: 200)
                    .chartYAxisLabel("Swap Value")
                    .chartXAxisLabel("Rate Change (basis points)")
                }
                
                Text("Shows swap value sensitivity to parallel yield curve shifts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private var riskLevel: String {
        let dv01Percent = abs(results.dv01) / notionalAmount * 10000
        if dv01Percent < 0.01 {
            return "Low"
        } else if dv01Percent < 0.05 {
            return "Medium"
        } else {
            return "High"
        }
    }
    
    private func calculateAndUpdate() {
        calculateSwap()
        generateCashFlowData()
        generateSensitivityData()
    }
    
    private func calculateSwap() {
        let paymentsPerYear = paymentFrequency.periodsPerYear
        let totalPayments = Int(tenor * paymentsPerYear)
        let paymentInterval = 1.0 / paymentsPerYear
        
        var fixedLegPV = 0.0
        var floatingLegPV = 0.0
        var durationNumerator = 0.0
        var convexityNumerator = 0.0
        
        // Calculate present values
        for i in 1...totalPayments {
            let timeToPayment = Double(i) * paymentInterval
            
            // Skip payments that have already occurred
            if timeToPayment <= timeElapsed {
                continue
            }
            
            let discountFactor = exp(-currentRate * timeToPayment)
            
            // Fixed leg payment
            let fixedPayment = notionalAmount * fixedRate * paymentInterval
            let fixedPV = fixedPayment * discountFactor
            fixedLegPV += fixedPV
            
            // Duration and convexity calculations
            durationNumerator += fixedPV * timeToPayment
            convexityNumerator += fixedPV * timeToPayment * timeToPayment
        }
        
        // Simplified floating leg PV (for plain vanilla swap)
        floatingLegPV = notionalAmount * (1 - exp(-currentRate * (tenor - timeElapsed)))
        
        // Swap value (receiver perspective - receive fixed, pay floating)
        let swapValue = fixedLegPV - floatingLegPV
        
        // Risk metrics
        let duration = fixedLegPV > 0 ? durationNumerator / fixedLegPV : 0
        let convexity = fixedLegPV > 0 ? convexityNumerator / fixedLegPV : 0
        let dv01 = calculateDV01()
        
        // Annualized P&L
        let annualizedPnL = swapValue * paymentsPerYear
        
        results = SwapResults(
            swapValue: swapValue,
            fixedLegPV: fixedLegPV,
            floatingLegPV: floatingLegPV,
            dv01: dv01,
            duration: duration,
            convexity: convexity,
            annualizedPnL: annualizedPnL
        )
    }
    
    private func calculateDV01() -> Double {
        let bumpSize = 0.0001  // 1 basis point
        
        // Calculate value with rate bump up
        let upValue = calculateSwapValue(rateShift: bumpSize)
        let downValue = calculateSwapValue(rateShift: -bumpSize)
        
        return -(upValue - downValue) / 2
    }
    
    private func calculateSwapValue(rateShift: Double) -> Double {
        let shiftedRate = currentRate + rateShift
        let paymentsPerYear = paymentFrequency.periodsPerYear
        let totalPayments = Int(tenor * paymentsPerYear)
        let paymentInterval = 1.0 / paymentsPerYear
        
        var fixedLegPV = 0.0
        
        for i in 1...totalPayments {
            let timeToPayment = Double(i) * paymentInterval
            
            if timeToPayment <= timeElapsed {
                continue
            }
            
            let discountFactor = exp(-shiftedRate * timeToPayment)
            let fixedPayment = notionalAmount * fixedRate * paymentInterval
            fixedLegPV += fixedPayment * discountFactor
        }
        
        let floatingLegPV = notionalAmount * (1 - exp(-shiftedRate * (tenor - timeElapsed)))
        
        return fixedLegPV - floatingLegPV
    }
    
    private func generateCashFlowData() {
        cashFlowData = []
        
        let paymentsPerYear = paymentFrequency.periodsPerYear
        let totalPayments = Int(tenor * paymentsPerYear)
        let paymentInterval = 1.0 / paymentsPerYear
        
        for i in 1...totalPayments {
            let timeToPayment = Double(i) * paymentInterval
            let discountFactor = exp(-currentRate * timeToPayment)
            
            let fixedPayment = notionalAmount * fixedRate * paymentInterval
            let floatingPayment = notionalAmount * currentRate * paymentInterval
            let netPayment = fixedPayment - floatingPayment
            let presentValue = netPayment * discountFactor
            
            cashFlowData.append(CashFlowPoint(
                period: i,
                date: timeToPayment,
                fixedPayment: fixedPayment,
                floatingPayment: floatingPayment,
                netPayment: netPayment,
                presentValue: presentValue
            ))
        }
    }
    
    private func generateSensitivityData() {
        sensitivityData = []
        
        let rateShifts = stride(from: -0.02, through: 0.02, by: 0.002)
        
        for shift in rateShifts {
            let shiftedValue = calculateSwapValue(rateShift: shift)
            let shiftedDV01 = abs(calculateSwapValue(rateShift: shift + 0.0001) - 
                                 calculateSwapValue(rateShift: shift - 0.0001)) / 2
            
            sensitivityData.append(SensitivityPoint(
                rateShift: shift,
                swapValue: shiftedValue,
                dv01: shiftedDV01
            ))
        }
    }
}

#Preview {
    SwapsCalculatorView()
        .frame(width: 1200, height: 800)
}
//
//  BondCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI
import SwiftData
import Charts
import LaTeXSwiftUI

/// Enhanced bond pricing calculator with duration, convexity, DV01, and PVBP analysis
struct BondCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    @State private var faceValue: Double = 1000.0
    @State private var couponRate: Double = 5.0  // Annual %
    @State private var marketYield: Double = 4.5  // Annual %
    @State private var yearsToMaturity: Double = 5.0
    @State private var paymentFrequency: PaymentFrequency = .semiAnnual
    @State private var currency: Currency = .usd
    @State private var bondType: BondType = .fixed
    
    @State private var results: BondResults = BondResults()
    @State private var sensitivityData: [SensitivityPoint] = []
    @State private var riskMetricsData: [RiskMetricPoint] = []
    @State private var cashFlowData: [CashFlowPoint] = []
    
    enum BondType: String, CaseIterable, Identifiable {
        case fixed = "fixed"
        case zero = "zero"
        case perpetual = "perpetual"
        case callable = "callable"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .fixed: return "Fixed Coupon"
            case .zero: return "Zero Coupon"
            case .perpetual: return "Perpetual"
            case .callable: return "Callable"
            }
        }
    }
    
    struct BondResults {
        var price: Double = 0.0
        var yieldToMaturity: Double = 0.0
        var macaulayDuration: Double = 0.0
        var modifiedDuration: Double = 0.0
        var convexity: Double = 0.0
        var dv01: Double = 0.0
        var pvbp: Double = 0.0
        var accruedInterest: Double = 0.0
        var cleanPrice: Double = 0.0
        var dirtyPrice: Double = 0.0
        var currentYield: Double = 0.0
        var yieldToCall: Double? = nil
    }
    
    struct SensitivityPoint: Identifiable {
        let id = UUID()
        let yieldChange: Double
        let price: Double
        let duration: Double
        let convexity: Double
    }
    
    struct RiskMetricPoint: Identifiable {
        let id = UUID()
        let maturity: Double
        let duration: Double
        let convexity: Double
    }
    
    struct CashFlowPoint: Identifiable {
        let id = UUID()
        let period: Int
        let date: Double
        let couponPayment: Double
        let principalPayment: Double
        let totalPayment: Double
        let presentValue: Double
        let cumulativePV: Double
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
                    riskMetricsSection
                    sensitivityChartsSection
                    cashFlowSection
                }
                .padding(24)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear {
            calculateBond()
            generateSensitivityData()
            generateRiskMetricsData()
            generateCashFlowData()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Advanced Bond Analytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Comprehensive bond pricing with duration, convexity, DV01, PVBP, and risk analysis")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Picker("Bond Type", selection: $bondType) {
                    ForEach(BondType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 300)
                .onChange(of: bondType) { _, _ in
                    calculateAndUpdate()
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
            GroupBox("Bond Parameters") {
                VStack(spacing: 16) {
                    CurrencyInputField(
                        title: "Face Value",
                        subtitle: "Par value",
                        value: Binding(
                            get: { faceValue },
                            set: { faceValue = $0 ?? 0 }
                        ),
                        currency: currency,
                        helpText: "Par value of the bond"
                    )
                    .onChange(of: faceValue) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Coupon Rate",
                        subtitle: "Annual coupon rate",
                        value: Binding(
                            get: { couponRate },
                            set: { couponRate = $0 ?? 0 }
                        ),
                        helpText: "Annual coupon rate"
                    )
                    .onChange(of: couponRate) { _, _ in calculateAndUpdate() }
                    
                    PercentageInputField(
                        title: "Market Yield",
                        subtitle: "Required yield to maturity",
                        value: Binding(
                            get: { marketYield },
                            set: { marketYield = $0 ?? 0 }
                        ),
                        helpText: "Required yield to maturity"
                    )
                    .onChange(of: marketYield) { _, _ in calculateAndUpdate() }
                    
                    InputFieldView(
                        title: "Years to Maturity",
                        subtitle: "Time to maturity",
                        value: Binding(
                            get: { String(format: "%.2f", yearsToMaturity) },
                            set: { yearsToMaturity = Double($0) ?? 0 }
                        ),
                        placeholder: "5.0",
                        keyboardType: .decimalPad,
                        validation: .positiveNumber,
                        helpText: "Time to maturity in years"
                    )
                    .onChange(of: yearsToMaturity) { _, _ in calculateAndUpdate() }
                    
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
            GroupBox("Bond Pricing") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Bond Price",
                        value: currency.formatValue(results.price),
                        isHighlighted: true
                    )
                    
                    DetailRow(
                        title: "Clean Price",
                        value: currency.formatValue(results.cleanPrice)
                    )
                    
                    DetailRow(
                        title: "Dirty Price",
                        value: currency.formatValue(results.dirtyPrice)
                    )
                    
                    DetailRow(
                        title: "Current Yield",
                        value: String(format: "%.3f%%", results.currentYield * 100)
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            GroupBox("Risk Metrics") {
                VStack(spacing: 16) {
                    DetailRow(
                        title: "Macaulay Duration",
                        value: String(format: "%.4f", results.macaulayDuration)
                    )
                    
                    DetailRow(
                        title: "Modified Duration",
                        value: String(format: "%.4f", results.modifiedDuration)
                    )
                    
                    DetailRow(
                        title: "Convexity",
                        value: String(format: "%.6f", results.convexity)
                    )
                    
                    DetailRow(
                        title: "DV01",
                        value: currency.formatValue(results.dv01)
                    )
                    
                    DetailRow(
                        title: "PVBP",
                        value: currency.formatValue(results.pvbp)
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
        GroupBox("Bond Pricing & Risk Formulas") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Core Equations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bond Price:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$P = \\sum_{t=1}^{n} \\frac{C}{(1+r)^t} + \\frac{M}{(1+r)^n}$")
                        .frame(height: 50)
                    
                    Text("Macaulay Duration:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$D_{Mac} = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{t \\cdot CF_t}{(1+r)^t}$")
                        .frame(height: 50)
                    
                    Text("Modified Duration:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$D_{Mod} = \\frac{D_{Mac}}{1+r}$")
                        .frame(height: 40)
                    
                    Text("Convexity:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$Convexity = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{t(t+1) \\cdot CF_t}{(1+r)^{t+2}}$")
                        .frame(height: 50)
                    
                    Text("DV01:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$DV01 = -D_{Mod} \\times P \\times 0.0001$")
                        .frame(height: 40)
                    
                    Text("PVBP (same as DV01):")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LaTeX("$PVBP = \\frac{\\partial P}{\\partial r} \\times 0.0001$")
                        .frame(height: 40)
                    
                    if bondType == .zero {
                        Text("Zero Coupon Bond:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$P = \\frac{M}{(1+r)^n}$")
                            .frame(height: 40)
                    }
                    
                    if bondType == .perpetual {
                        Text("Perpetual Bond:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        LaTeX("$P = \\frac{C}{r}$")
                            .frame(height: 40)
                    }
                }
                
                Text("where: P = price, C = coupon payment, M = maturity value, r = yield, t = time period")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var riskMetricsSection: some View {
        GroupBox("Duration and Convexity Analysis") {
            VStack(spacing: 16) {
                if !riskMetricsData.isEmpty {
                    Chart(riskMetricsData) { point in
                        LineMark(
                            x: .value("Maturity", point.maturity),
                            y: .value("Duration", point.duration)
                        )
                        .foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("Maturity", point.maturity),
                            y: .value("Convexity", point.convexity / 10) // Scale for visibility
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    }
                    .frame(height: 250)
                    .chartYAxisLabel("Duration / Convexity (÷10)")
                    .chartXAxisLabel("Years to Maturity")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("— Duration")
                            .foregroundColor(.blue)
                        Text("⋯ Convexity (÷10)")
                            .foregroundColor(.red)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("Shows how duration and convexity change with maturity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var sensitivityChartsSection: some View {
        GroupBox("Interest Rate Sensitivity Analysis") {
            VStack(spacing: 16) {
                if !sensitivityData.isEmpty {
                    Chart(sensitivityData) { point in
                        LineMark(
                            x: .value("Yield Change (bps)", point.yieldChange * 10000),
                            y: .value("Bond Price", point.price)
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        // Current price point
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
                    .frame(height: 250)
                    .chartYAxisLabel("Bond Price")
                    .chartXAxisLabel("Yield Change (basis points)")
                }
                
                Text("Shows bond price sensitivity to yield changes (convex relationship)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Duration and Convexity Approximation Comparison
                VStack(alignment: .leading, spacing: 8) {
                    Text("Price Change Approximations:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("First-order (Duration only):")
                        .font(.caption)
                    LaTeX("$\\Delta P \\approx -D_{Mod} \\times P \\times \\Delta r$")
                        .frame(height: 30)
                    
                    Text("Second-order (Duration + Convexity):")
                        .font(.caption)
                    LaTeX("$\\Delta P \\approx -D_{Mod} \\times P \\times \\Delta r + \\frac{1}{2} \\times Convexity \\times P \\times (\\Delta r)^2$")
                        .frame(height: 40)
                }
                .padding(.top)
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
                            y: .value("Payment", point.totalPayment)
                        )
                        .foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("Period", point.period),
                            y: .value("Present Value", point.presentValue)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .frame(height: 200)
                    .chartYAxisLabel("Cash Flow Amount")
                    .chartXAxisLabel("Payment Period")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("■ Cash Flows")
                            .foregroundColor(.blue)
                        Text("— Present Values")
                            .foregroundColor(.red)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Total PV: \(Formatters.formatCurrency(cashFlowData.last?.cumulativePV ?? 0, currency: currency))")
                        Text("Weighted Duration: \(String(format: "%.2f", results.macaulayDuration)) years")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func calculateAndUpdate() {
        calculateBond()
        generateSensitivityData()
        generateRiskMetricsData()
        generateCashFlowData()
    }
    
    private func calculateBond() {
        let periodsPerYear = paymentFrequency.periodsPerYear
        let totalPeriods = Int(yearsToMaturity * periodsPerYear)
        let periodYield = marketYield / 100.0 / periodsPerYear
        let periodCoupon = (couponRate / 100.0 * faceValue) / periodsPerYear
        
        var price = 0.0
        var macaulayDuration = 0.0
        var modifiedDuration = 0.0
        var convexity = 0.0
        
        switch bondType {
        case .fixed:
            // Standard bond pricing
            for i in 1...totalPeriods {
                let t = Double(i)
                let pv = periodCoupon / pow(1 + periodYield, t)
                price += pv
                macaulayDuration += (t / periodsPerYear) * pv
                convexity += t * (t + 1) * pv / pow(1 + periodYield, 2)
            }
            
            // Add principal repayment
            let principalPV = faceValue / pow(1 + periodYield, Double(totalPeriods))
            price += principalPV
            macaulayDuration += (yearsToMaturity * principalPV)
            convexity += Double(totalPeriods) * (Double(totalPeriods) + 1) * principalPV / pow(1 + periodYield, 2)
            
        case .zero:
            // Zero coupon bond
            price = faceValue / pow(1 + periodYield, Double(totalPeriods))
            macaulayDuration = yearsToMaturity
            convexity = yearsToMaturity * (yearsToMaturity + 1) / pow(1 + periodYield, 2)
            
        case .perpetual:
            // Perpetual bond (consol)
            price = (couponRate / 100.0 * faceValue) / (marketYield / 100.0)
            macaulayDuration = (1 + marketYield / 100.0) / (marketYield / 100.0)
            convexity = 2 / pow(marketYield / 100.0, 3)
            
        case .callable:
            // Simplified callable bond (same as fixed for now)
            for i in 1...totalPeriods {
                let t = Double(i)
                let pv = periodCoupon / pow(1 + periodYield, t)
                price += pv
                macaulayDuration += (t / periodsPerYear) * pv
                convexity += t * (t + 1) * pv / pow(1 + periodYield, 2)
            }
            price += faceValue / pow(1 + periodYield, Double(totalPeriods))
        }
        
        // Finalize calculations
        macaulayDuration = macaulayDuration / price
        modifiedDuration = macaulayDuration / (1 + marketYield / 100.0 / periodsPerYear)
        convexity = convexity / price / periodsPerYear / periodsPerYear
        
        // Risk metrics
        let dv01 = modifiedDuration * price * 0.0001
        let pvbp = dv01  // PVBP is the same as DV01
        
        // Other metrics
        let currentYield = bondType == .zero ? 0 : (couponRate / 100.0 * faceValue) / price
        let accruedInterest = 0.0  // Simplified
        let cleanPrice = price
        let dirtyPrice = price + accruedInterest
        
        results = BondResults(
            price: price,
            yieldToMaturity: marketYield / 100.0,
            macaulayDuration: macaulayDuration,
            modifiedDuration: modifiedDuration,
            convexity: convexity,
            dv01: dv01,
            pvbp: pvbp,
            accruedInterest: accruedInterest,
            cleanPrice: cleanPrice,
            dirtyPrice: dirtyPrice,
            currentYield: currentYield,
            yieldToCall: nil
        )
    }
    
    private func generateSensitivityData() {
        sensitivityData = []
        
        let yieldShifts = stride(from: -0.03, through: 0.03, by: 0.005)  // -3% to +3%
        
        for shift in yieldShifts {
            let shiftedYield = marketYield + shift * 100
            let tempResults = calculateBondForYield(shiftedYield)
            
            sensitivityData.append(SensitivityPoint(
                yieldChange: shift,
                price: tempResults.price,
                duration: tempResults.modifiedDuration,
                convexity: tempResults.convexity
            ))
        }
    }
    
    private func generateRiskMetricsData() {
        riskMetricsData = []
        
        let maturities = stride(from: 0.5, through: 30.0, by: 0.5)
        
        for maturity in maturities {
            let tempResults = calculateBondForMaturity(maturity)
            
            riskMetricsData.append(RiskMetricPoint(
                maturity: maturity,
                duration: tempResults.modifiedDuration,
                convexity: tempResults.convexity
            ))
        }
    }
    
    private func generateCashFlowData() {
        cashFlowData = []
        
        let periodsPerYear = paymentFrequency.periodsPerYear
        let totalPeriods = Int(yearsToMaturity * periodsPerYear)
        let periodYield = marketYield / 100.0 / periodsPerYear
        let periodCoupon = (couponRate / 100.0 * faceValue) / periodsPerYear
        
        var cumulativePV = 0.0
        
        for i in 1...totalPeriods {
            let couponPayment = bondType == .zero ? 0.0 : periodCoupon
            let principalPayment = (i == totalPeriods) ? faceValue : 0.0
            let totalPayment = couponPayment + principalPayment
            
            let presentValue = totalPayment / pow(1 + periodYield, Double(i))
            cumulativePV += presentValue
            
            cashFlowData.append(CashFlowPoint(
                period: i,
                date: Double(i) / periodsPerYear,
                couponPayment: couponPayment,
                principalPayment: principalPayment,
                totalPayment: totalPayment,
                presentValue: presentValue,
                cumulativePV: cumulativePV
            ))
        }
    }
    
    private func calculateBondForYield(_ yield: Double) -> BondResults {
        let originalYield = marketYield
        marketYield = yield
        calculateBond()
        let tempResults = results
        marketYield = originalYield
        return tempResults
    }
    
    private func calculateBondForMaturity(_ maturity: Double) -> BondResults {
        let originalMaturity = yearsToMaturity
        yearsToMaturity = maturity
        calculateBond()
        let tempResults = results
        yearsToMaturity = originalMaturity
        return tempResults
    }
}

#Preview {
    BondCalculatorView()
        .environment(MainViewModel())
        .frame(width: 1400, height: 1000)
}
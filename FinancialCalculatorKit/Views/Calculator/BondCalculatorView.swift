//
//  BondCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on Phase 3 implementation.
//

import SwiftUI
import SwiftData
import Charts

/// Comprehensive bond calculator with yield, duration, and advanced analytics
struct BondCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    @State private var calculation: BondCalculation?
    @State private var faceValue: Double?
    @State private var couponRate: Double?
    @State private var maturity: Double?
    @State private var marketYield: Double?
    @State private var currentPrice: Double?
    @State private var frequency: PaymentFrequency = .semiAnnual
    @State private var bondType: BondType = .standardBond
    @State private var currency: Currency = .usd
    
    @State private var isCalculating: Bool = false
    @State private var calculationResult: CalculationResult?
    @State private var validationErrors: [String] = []
    @State private var selectedAnalysis: AnalysisType = .pricing
    @State private var showAdvancedSettings: Bool = false
    
    enum AnalysisType: String, CaseIterable {
        case pricing = "Price & Yield"
        case duration = "Duration & Risk"
        case cashFlow = "Cash Flows"
        
        var icon: String {
            switch self {
            case .pricing: return "dollarsign.circle"
            case .duration: return "gauge"
            case .cashFlow: return "chart.bar"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                HStack(alignment: .top, spacing: 24) {
                    inputSection
                    resultSection
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
                
                Button("Save") {
                    saveCalculation()
                }
                .disabled(calculationResult == nil)
                
                Button("Clear") {
                    clearAll()
                }
                .buttonStyle(.bordered)
            }
        }
        .onAppear {
            loadUserPreferences()
            if let existingCalculation = mainViewModel.selectedCalculation as? BondCalculation {
                loadExistingCalculation(existingCalculation)
            }
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bond Calculator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Calculate bond prices, yields, duration, convexity, and analyze cash flows for various bond types.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Picker("Bond Type", selection: $bondType) {
                        ForEach(BondType.allCases) { type in
                            Text(type.displayName)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 200)
                    
                    HStack(spacing: 8) {
                        Text("Currency:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Picker("Currency", selection: $currency) {
                            ForEach(Currency.allCases.prefix(8)) { curr in
                                Text("\(curr.symbol) \(curr.rawValue)")
                                    .tag(curr)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 100)
                    }
                }
            }
            
            if !validationErrors.isEmpty {
                VStack(spacing: 8) {
                    ForEach(validationErrors, id: \.self) { error in
                        StatusIndicator(.error, message: error)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 20) {
            DynamicInputSection(
                title: "Bond Details",
                subtitle: "Primary bond characteristics",
                variant: .emphasis
            ) {
                VStack(spacing: 16) {
                    DynamicCurrencyField(
                        title: "Face Value",
                        subtitle: "Par value at maturity",
                        value: $faceValue,
                        currency: currency,
                        configuration: DynamicFieldConfiguration(
                            isRequired: true,
                            helpText: "The amount paid at maturity (typically $1,000)"
                        )
                    )
                    
                    DynamicPercentageField(
                        title: "Coupon Rate",
                        subtitle: "Annual interest rate",
                        value: $couponRate,
                        configuration: DynamicFieldConfiguration(
                            isRequired: bondType != .zeroCoupon,
                            isDisabled: bondType == .zeroCoupon,
                            helpText: "Annual interest rate paid on face value"
                        )
                    )
                    
                    DynamicInputField(
                        title: "Years to Maturity",
                        subtitle: "Time until bond matures",
                        value: Binding(
                            get: { maturity?.description ?? "" },
                            set: { maturity = Double($0) }
                        ),
                        configuration: DynamicFieldConfiguration(
                            isRequired: true,
                            helpText: "Number of years until the bond matures",
                            validation: .positiveNumber
                        ),
                        keyboardType: .decimalPad,
                        placeholder: "10"
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Payment Frequency")
                            .font(.headline)
                            .fontWeight(.medium)

                        Picker("Payment Frequency", selection: $frequency) {
                            Text("Annual").tag(PaymentFrequency.annual)
                            Text("Semi-Annual").tag(PaymentFrequency.semiAnnual)
                            Text("Quarterly").tag(PaymentFrequency.quarterly)
                            Text("Monthly").tag(PaymentFrequency.monthly)
                        }
                        .pickerStyle(.segmented)
                        .disabled(bondType == .zeroCoupon)
                    }
                }
            }
            
            DynamicInputSection(
                title: "Market Data",
                subtitle: "Enter yield OR price to calculate the other",
                variant: .accent
            ) {
                VStack(spacing: 16) {
                    DynamicPercentageField(
                        title: "Market Yield",
                        subtitle: "Market required return",
                        value: $marketYield,
                        configuration: DynamicFieldConfiguration(
                            isRequired: currentPrice == nil,
                            isDisabled: currentPrice != nil,
                            helpText: "Enter yield to calculate price"
                        )
                    )

                    Text("OR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)

                    DynamicCurrencyField(
                        title: "Market Price",
                        subtitle: "Current trading price",
                        value: $currentPrice,
                        currency: currency,
                        configuration: DynamicFieldConfiguration(
                            isRequired: marketYield == nil,
                            isDisabled: marketYield != nil,
                            helpText: "Enter price to calculate yield"
                        )
                    )
                }
            }
            
            DynamicInputSection(
                title: "Advanced Settings",
                subtitle: "Additional bond parameters",
                isExpanded: showAdvancedSettings
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    if bondType == .callable || bondType == .puttable {
                        DynamicCurrencyField(
                            title: bondType == .callable ? "Call Price" : "Put Price",
                            subtitle: "Option exercise price",
                            value: .constant(nil),
                            currency: currency,
                            configuration: DynamicFieldConfiguration(
                                helpText: "Price at which bond can be \(bondType == .callable ? "called" : "put")"
                            )
                        )

                        DynamicInputField(
                            title: "Option Exercise Date",
                            subtitle: "Years until option can be exercised",
                            value: .constant(""),
                            configuration: DynamicFieldConfiguration(
                                helpText: "When the option becomes exercisable",
                                validation: .positiveNumber
                            ),
                            keyboardType: .decimalPad,
                            placeholder: "5"
                        )
                    }
                }
            }
        }
        .frame(maxWidth: 450)
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: 20) {
            if isCalculating {
                LoadingStateView(message: "Calculating bond metrics...")
            } else if let result = calculationResult, let calc = calculation {
                // Analysis type selector
                Picker("Analysis", selection: $selectedAnalysis) {
                    ForEach(AnalysisType.allCases, id: \.self) { type in
                        Label(type.rawValue, systemImage: type.icon)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                
                // Selected analysis view
                switch selectedAnalysis {
                case .pricing:
                    BondPricingResultView(
                        result: result,
                        calculation: calc,
                        currency: currency
                    )
                case .duration:
                    BondDurationResultView(
                        result: result,
                        calculation: calc,
                        currency: currency
                    )
                case .cashFlow:
                    BondCashFlowResultView(
                        result: result,
                        calculation: calc,
                        currency: currency
                    )
                }
            } else {
                placeholderResultView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var placeholderResultView: some View {
        EmptyStateView(
            icon: "chart.line.uptrend.xyaxis",
            title: "Ready to Calculate",
            subtitle: "Enter bond details and either yield or price to calculate comprehensive bond analytics.",
            actionTitle: "Load Example",
            action: {
                loadExample()
            }
        )
    }
    
    private var canCalculate: Bool {
        guard let _ = faceValue,
              let _ = maturity else { return false }

        if bondType != .zeroCoupon && couponRate == nil {
            return false
        }

        return marketYield != nil || currentPrice != nil
    }
    
    private func performCalculation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCalculating = true
            validationErrors = []
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let calculationName = "Bond Calculator - \(formatter.string(from: Date()))"

        let currentCalculation: BondCalculation
        if let existingCalc = calculation {
            currentCalculation = existingCalc
        } else {
            currentCalculation = BondCalculation(
                faceValue: faceValue ?? 1000,
                couponRate: couponRate ?? 0,
                maturity: maturity ?? 0,
                frequency: frequency,
                currency: currency,
                bondType: bondType,
                marketYield: marketYield,
                currentPrice: currentPrice
            )
        }

        if currentCalculation.modelContext == nil {
            currentCalculation.name = calculationName
        }
        currentCalculation.faceValue = faceValue ?? 1000
        currentCalculation.couponRate = bondType == .zeroCoupon ? 0 : (couponRate ?? 0)
        currentCalculation.maturity = maturity ?? 0
        currentCalculation.frequency = frequency
        currentCalculation.marketYield = marketYield
        currentCalculation.currentPrice = currentPrice
        currentCalculation.bondType = bondType
        currentCalculation.currency = currency

        // Simulate calculation delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCalculating = false

                if currentCalculation.isValid {
                    calculationResult = currentCalculation.result
                    calculation = currentCalculation
                } else {
                    validationErrors = currentCalculation.validationErrors
                    calculationResult = nil
                }
            }
        }
    }
    
    private func saveCalculation() {
        guard let calc = calculation else { return }
        
        if calc.modelContext == nil {
            modelContext.insert(calc)
        }
        
        do {
            try modelContext.save()
            // Show success feedback
        } catch {
            mainViewModel.handleError(.dataExportFailed("Failed to save calculation: \(error.localizedDescription)"))
        }
    }
    
    private func clearAll() {
        withAnimation(.easeInOut(duration: 0.3)) {
            faceValue = nil
            couponRate = nil
            maturity = nil
            marketYield = nil
            currentPrice = nil
            calculationResult = nil
            validationErrors = []
        }
    }

    private func loadUserPreferences() {
        currency = mainViewModel.userPreferences.defaultCurrency
        frequency = mainViewModel.userPreferences.defaultPaymentFrequency
    }

    private func loadExistingCalculation(_ existingCalculation: BondCalculation) {
        calculation = existingCalculation
        faceValue = existingCalculation.faceValue
        couponRate = existingCalculation.couponRate
        maturity = existingCalculation.maturity
        marketYield = existingCalculation.marketYield
        currentPrice = existingCalculation.currentPrice
        frequency = existingCalculation.frequency
        bondType = existingCalculation.bondType
        currency = existingCalculation.currency

        performCalculation()
    }

    private func loadExample() {
        withAnimation(.easeInOut(duration: 0.3)) {
            faceValue = 1000
            couponRate = 5.0
            maturity = 10
            marketYield = 4.5
            currentPrice = nil
            frequency = .semiAnnual
            bondType = .standardBond
        }
    }
}

// MARK: - Result View Components

struct BondPricingResultView: View {
    let result: CalculationResult
    let calculation: BondCalculation
    let currency: Currency
    
    var body: some View {
        VStack(spacing: 20) {
            // Primary result card
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(calculation.currentPrice != nil ? "Yield to Maturity" : "Bond Price")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text(result.formattedPrimaryValue)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                
                Divider()
                
                // Key metrics
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    if let cleanPrice = result.secondaryValues["Clean Price"] {
                        MetricCard(
                            title: "Clean Price",
                            value: currency.formatValue(cleanPrice),
                            icon: "dollarsign.circle",
                            color: .green,
                            subtitle: "Excluding accrued interest"
                        )
                    }
                    
                    if let accruedInterest = result.secondaryValues["Accrued Interest"] {
                        MetricCard(
                            title: "Accrued Interest",
                            value: currency.formatValue(accruedInterest),
                            icon: "calendar.badge.clock",
                            color: .orange,
                            subtitle: nil
                        )
                    }
                    
                    if let currentYield = result.secondaryValues["Current Yield"] {
                        MetricCard(
                            title: "Current Yield",
                            value: String(format: "%.3f%%", currentYield),
                            icon: "percent",
                            color: .purple,
                            subtitle: "Annual coupon / price"
                        )
                    }
                    
                    if let ytm = result.secondaryValues["Yield to Maturity"] {
                        MetricCard(
                            title: "YTM",
                            value: String(format: "%.3f%%", ytm),
                            icon: "chart.xyaxis.line",
                            color: .blue,
                            subtitle: "Total return if held"
                        )
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    )
            )
            
            // Price sensitivity chart
            if let priceData = generatePriceSensitivityData() {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Price-Yield Relationship")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Chart(priceData) { point in
                        LineMark(
                            x: .value("Yield", point.x),
                            y: .value("Price", point.y)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        if let currentYield = calculation.yieldToMaturity {
                            if abs(point.x - currentYield) < 0.1 {
                                PointMark(
                                    x: .value("Current", point.x),
                                    y: .value("Price", point.y)
                                )
                                .foregroundStyle(Color.orange)
                                .symbolSize(150)
                            }
                        }
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let yield = value.as(Double.self) {
                                    Text("\(String(format: "%.0f", yield))%")
                                        .font(.caption)
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
                                    Text(currency.formatValue(price))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(NSColor.windowBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private func generatePriceSensitivityData() -> [ChartDataPoint]? {
        guard let currentYield = calculation.yieldToMaturity else { return nil }

        var dataPoints: [ChartDataPoint] = []
        let yieldRange = stride(from: max(0, currentYield - 3), to: currentYield + 3, by: 0.25)

        for yield in yieldRange {
            let price = CalculationEngine.calculateBondPrice(
                faceValue: calculation.faceValue,
                couponRate: calculation.couponRate,
                marketRate: yield,
                yearsToMaturity: calculation.maturity,
                paymentsPerYear: Double(calculation.frequency.periodsPerYear)
            )
            dataPoints.append(ChartDataPoint(x: yield, y: price))
        }

        return dataPoints
    }
}

struct BondDurationResultView: View {
    let result: CalculationResult
    let calculation: BondCalculation
    let currency: Currency
    
    var body: some View {
        VStack(spacing: 20) {
            // Duration metrics
            VStack(spacing: 16) {
                Text("Duration & Risk Metrics")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    if let duration = result.secondaryValues["Duration"] {
                        MetricCard(
                            title: "Macaulay Duration",
                            value: String(format: "%.3f years", duration),
                            icon: "timer",
                            color: .blue,
                            subtitle: "Weighted avg. time"
                        )
                    }
                    
                    if let modDuration = result.secondaryValues["Modified Duration"] {
                        MetricCard(
                            title: "Modified Duration",
                            value: String(format: "%.3f", modDuration),
                            icon: "gauge",
                            color: .orange,
                            subtitle: "Price sensitivity"
                        )
                    }
                    
                    if let convexity = result.secondaryValues["Convexity"] {
                        MetricCard(
                            title: "Convexity",
                            value: String(format: "%.2f", convexity),
                            icon: "waveform",
                            color: .purple,
                            subtitle: "2nd order sensitivity"
                        )
                    }
                    
                    if let dv01 = result.secondaryValues["DV01"] {
                        MetricCard(
                            title: "DV01",
                            value: currency.formatValue(dv01),
                            icon: "arrow.up.arrow.down",
                            color: .green,
                            subtitle: "Price change per bp"
                        )
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                    )
            )
            
            // Price sensitivity scenarios
            VStack(alignment: .leading, spacing: 12) {
                Text("Interest Rate Sensitivity")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                let scenarios = generateRateScenarios()
                
                ForEach(scenarios, id: \.change) { scenario in
                    HStack {
                        Text(scenario.change > 0 ? "+\(scenario.change) bps" : "\(scenario.change) bps")
                            .font(.callout)
                            .fontWeight(.medium)
                            .frame(width: 80, alignment: .leading)
                        
                        // Price change bar
                        GeometryReader { geometry in
                            let width = abs(scenario.priceChange) / scenarios.map { abs($0.priceChange) }.max()! * geometry.size.width * 0.8
                            let isPositive = scenario.priceChange > 0
                            
                            HStack(spacing: 0) {
                                if !isPositive {
                                    Spacer()
                                }
                                
                                Rectangle()
                                    .fill(isPositive ? Color.green : Color.red)
                                    .frame(width: width, height: 20)
                                    .cornerRadius(4)
                                
                                if isPositive {
                                    Spacer()
                                }
                            }
                            .frame(width: geometry.size.width)
                        }
                        .frame(height: 20)
                        
                        Text(currency.formatValue(scenario.newPrice))
                            .font(.callout)
                            .frame(width: 100, alignment: .trailing)
                        
                        Text(String(format: "%+.2f%%", scenario.percentChange))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(scenario.priceChange > 0 ? .green : .red)
                            .frame(width: 60, alignment: .trailing)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.windowBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
            )
        }
    }
    
    private func generateRateScenarios() -> [(change: Int, newPrice: Double, priceChange: Double, percentChange: Double)] {
        guard let currentPrice = result.primaryValue as Double?,
              let modDuration = result.secondaryValues["Modified Duration"],
              let convexity = result.secondaryValues["Convexity"] else { return [] }
        
        let scenarios = [-200, -100, -50, 50, 100, 200]
        
        return scenarios.map { bps in
            let yieldChange = Double(bps) / 10000
            let priceChange = -modDuration * yieldChange + 0.5 * convexity * yieldChange * yieldChange
            let newPrice = currentPrice * (1 + priceChange)
            
            return (
                change: bps,
                newPrice: newPrice,
                priceChange: newPrice - currentPrice,
                percentChange: priceChange * 100
            )
        }
    }
}

struct BondCashFlowResultView: View {
    let result: CalculationResult
    let calculation: BondCalculation
    let currency: Currency
    
    @State private var showFullSchedule: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Cash flow summary
            VStack(spacing: 16) {
                Text("Cash Flow Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Coupons")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(currency.formatValue(totalCoupons))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Face Value")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(currency.formatValue(calculation.faceValue))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Total Cash Flows")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(currency.formatValue(totalCoupons + calculation.faceValue))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.opacity(0.3), lineWidth: 2)
                    )
            )
            
            // Cash flow timeline
            if let cashFlows = generateCashFlowData() {
                CashFlowTimelineChart(
                    cashFlows: cashFlows,
                    currency: currency
                )
            }
            
            // Detailed schedule toggle
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showFullSchedule.toggle()
                }
            }) {
                HStack {
                    Image(systemName: showFullSchedule ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                    
                    Text(showFullSchedule ? "Hide Payment Schedule" : "Show Full Payment Schedule")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(numberOfPayments) payments")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
            
            // Payment schedule table
            if showFullSchedule, let schedule = generatePaymentSchedule() {
                BondPaymentTable(
                    entries: schedule,
                    currency: currency
                )
            }
        }
    }
    
    private var totalCoupons: Double {
        let couponPayment = calculation.faceValue * calculation.couponRate / 100 / Double(calculation.frequency.periodsPerYear)
        let periods = calculation.maturity * Double(calculation.frequency.periodsPerYear)
        return couponPayment * periods
    }

    private var numberOfPayments: Int {
        Int(calculation.maturity * Double(calculation.frequency.periodsPerYear))
    }
    
    private func generateCashFlowData() -> [ChartDataPoint]? {
        var cashFlows: [ChartDataPoint] = []

        let couponPayment = calculation.faceValue * calculation.couponRate / 100 / Double(calculation.frequency.periodsPerYear)
        let periodsPerYear = calculation.frequency.periodsPerYear
        let totalPeriods = Int(calculation.maturity * Double(periodsPerYear))

        // Show first few and last few payments for visualization
        let periodsToShow = min(totalPeriods, 8)

        for i in 1...periodsToShow {
            let period = i <= 4 ? i : totalPeriods - (periodsToShow - i)
            let year = Double(period) / Double(periodsPerYear)
            var payment = couponPayment

            if period == totalPeriods {
                payment += calculation.faceValue
            }

            cashFlows.append(ChartDataPoint(
                x: year,
                y: payment,
                label: period == totalPeriods ? "Maturity" : "Period \(period)"
            ))
        }

        return cashFlows
    }

    private func generatePaymentSchedule() -> [BondPaymentEntry]? {
        var entries: [BondPaymentEntry] = []

        let couponPayment = calculation.faceValue * calculation.couponRate / 100 / Double(calculation.frequency.periodsPerYear)
        let periodsPerYear = calculation.frequency.periodsPerYear
        let totalPeriods = Int(calculation.maturity * Double(periodsPerYear))
        let discountRate = (calculation.yieldToMaturity ?? 5.0) / 100 / Double(periodsPerYear)

        for period in 1...totalPeriods {
            let year = Double(period) / Double(periodsPerYear)
            var cashFlow = couponPayment

            if period == totalPeriods {
                cashFlow += calculation.faceValue
            }

            let presentValue = cashFlow / pow(1 + discountRate, Double(period))

            entries.append(BondPaymentEntry(
                period: period,
                year: year,
                cashFlow: cashFlow,
                presentValue: presentValue,
                isFinal: period == totalPeriods
            ))
        }

        return entries
    }
}

struct BondPaymentEntry: Identifiable {
    let id = UUID()
    let period: Int
    let year: Double
    let cashFlow: Double
    let presentValue: Double
    let isFinal: Bool
}

struct BondPaymentTable: View {
    let entries: [BondPaymentEntry]
    let currency: Currency
    
    var body: some View {
        InteractiveDataTable(
            title: "Payment Schedule",
            data: entries,
            columns: [
                TableColumn(
                    id: "period",
                    title: "Period",
                    width: 80,
                    alignment: .center,
                    content: { entry in
                        Text("\(entry.period)")
                            .font(.system(.body, design: .monospaced))
                    },
                    searchableText: { "\($0.period)" },
                    compare: { $0.period < $1.period }
                ),
                TableColumn(
                    id: "year",
                    title: "Year",
                    width: 80,
                    alignment: .center,
                    content: { entry in
                        Text(String(format: "%.2f", entry.year))
                            .font(.system(.body, design: .monospaced))
                    },
                    searchableText: { String(format: "%.2f", $0.year) },
                    compare: { $0.year < $1.year }
                ),
                TableColumn(
                    id: "cashFlow",
                    title: "Cash Flow",
                    width: 140,
                    alignment: .trailing,
                    showSummary: true,
                    summaryLabel: "Total",
                    content: { entry in
                        HStack {
                            Spacer()
                            Text(currency.formatValue(entry.cashFlow))
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(entry.isFinal ? .bold : .regular)
                            if entry.isFinal {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    },
                    searchableText: { currency.formatValue($0.cashFlow) },
                    compare: { $0.cashFlow < $1.cashFlow },
                    summary: { entries in
                        currency.formatValue(entries.reduce(0) { $0 + $1.cashFlow })
                    }
                ),
                TableColumn(
                    id: "presentValue",
                    title: "Present Value",
                    width: 140,
                    alignment: .trailing,
                    showSummary: true,
                    content: { entry in
                        Text(currency.formatValue(entry.presentValue))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.green)
                    },
                    searchableText: { currency.formatValue($0.presentValue) },
                    compare: { $0.presentValue < $1.presentValue },
                    summary: { entries in
                        currency.formatValue(entries.reduce(0) { $0 + $1.presentValue })
                    }
                )
            ],
            rowHeight: 36,
            showSummary: true,
            allowExport: true
        )
    }
}

#Preview {
    BondCalculatorView()
        .environment(MainViewModel())
        .modelContainer(for: BondCalculation.self, inMemory: true)
        .frame(width: 1200, height: 800)
}
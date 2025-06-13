//
//  LoanResultView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on Phase 3 implementation.
//

import SwiftUI
import Charts

/// Enhanced result display for Loan calculations with interactive visualizations
struct LoanResultView: View {
    let result: CalculationResult
    let calculation: LoanCalculation
    let currency: Currency
    @Binding var showAmortizationTable: Bool
    
    @State private var selectedVisualization: VisualizationType = .amortizationChart
    @State private var showDetailedBreakdown: Bool = false
    @State private var comparisonScenarios: [ComparisonScenario] = []
    
    enum VisualizationType: String, CaseIterable {
        case amortizationChart = "Amortization"
        case paymentBreakdown = "Payment Breakdown"
        case interestSavings = "Interest Savings"
        case comparison = "Scenario Comparison"
        
        var icon: String {
            switch self {
            case .amortizationChart: return "chart.line.downtrend.xyaxis"
            case .paymentBreakdown: return "chart.pie"
            case .interestSavings: return "dollarsign.arrow.trianglehead.counterclockwise.rotate.90"
            case .comparison: return "chart.bar.xaxis"
            }
        }
    }
    
    struct ComparisonScenario: Identifiable {
        let id = UUID()
        let name: String
        let interestRate: Double
        let termYears: Double
        let extraPayment: Double
        let totalInterest: Double
        let monthlyPayment: Double
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Primary result display
                primaryResultCard
                
                // Quick metrics
                quickMetricsGrid
                
                // Visualization selector
                visualizationSelector
                
                // Selected visualization
                selectedVisualizationView
                
                // Amortization table toggle
                amortizationTableToggle
                
                // Key insights
                keyInsightsSection
            }
        }
    }
    
    @ViewBuilder
    private var primaryResultCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(calculation.paymentFrequency.displayName) Payment")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(currency.formatValue(result.primaryValue))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if calculation.extraPayment > 0 {
                        HStack(spacing: 4) {
                            Text("includes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("+ \(currency.formatValue(calculation.extraPayment))")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            Text("extra")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: calculation.loanType == .mortgage ? "house.fill" : "creditcard.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                    )
            }
            
            Divider()
            
            // Loan summary
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Loan Amount")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(currency.formatValue(calculation.principalAmount - calculation.downPayment))
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                if calculation.downPayment > 0 {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Down Payment")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        Text(currency.formatValue(calculation.downPayment))
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Interest Rate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.3f%%", calculation.annualInterestRate))
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Term")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(calculation.loanTermYears)) years")
                        .font(.callout)
                        .fontWeight(.semibold)
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
    }
    
    @ViewBuilder
    private var quickMetricsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            LoanMetricCard(
                title: "Total Interest",
                value: currency.formatValue(result.secondaryValues["Total Interest"] ?? 0),
                icon: "percent",
                color: .orange,
                subtitle: interestPercentageText
            )

            LoanMetricCard(
                title: "Total Payments",
                value: currency.formatValue(result.secondaryValues["Total Payments"] ?? 0),
                icon: "banknote.fill",
                color: .blue,
                subtitle: paymentCountText
            )

            if let timeSaved = result.secondaryValues["Time Saved (Years)"], timeSaved > 0 {
                LoanMetricCard(
                    title: "Time Saved",
                    value: formatTimeValue(timeSaved),
                    icon: "clock.arrow.circlepath",
                    color: .green,
                    subtitle: "with extra payments"
                )

                LoanMetricCard(
                    title: "Interest Saved",
                    value: currency.formatValue(result.secondaryValues["Interest Saved"] ?? 0),
                    icon: "arrow.down.circle.fill",
                    color: .green,
                    subtitle: "vs. regular payments"
                )
            }
        }
    }
    
    @ViewBuilder
    private var visualizationSelector: some View {
        Picker("Visualization", selection: $selectedVisualization) {
            ForEach(VisualizationType.allCases, id: \.self) { type in
                Label(type.rawValue, systemImage: type.icon)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private var selectedVisualizationView: some View {
        switch selectedVisualization {
        case .amortizationChart:
            amortizationChartView
        case .paymentBreakdown:
            paymentBreakdownView
        case .interestSavings:
            interestSavingsView
        case .comparison:
            scenarioComparisonView
        }
    }
    
    @ViewBuilder
    private var amortizationChartView: some View {
        let amortizationSchedule = calculation.calculateAmortization()
        if !amortizationSchedule.isEmpty {
            AmortizationChart(
                entries: amortizationSchedule,
                currency: currency,
                showBreakdown: true
            )
        }
    }
    
    @ViewBuilder
    private var paymentBreakdownView: some View {
        VStack(spacing: 16) {
            // Monthly payment breakdown
            if let totalInterest = result.secondaryValues["Total Interest"],
               let totalPayments = result.secondaryValues["Total Payments"] {
                let principal = totalPayments - totalInterest
                
                BreakdownPieChart(
                    segments: [
                        ("Principal", principal, .blue),
                        ("Interest", totalInterest, .orange)
                    ],
                    title: "Total Payment Breakdown",
                    currency: currency
                )
            }
            
            // First vs Last payment comparison
            let schedule = calculation.calculateAmortization()
            if !schedule.isEmpty,
               let firstPayment = schedule.first,
               let lastPayment = schedule.last(where: { $0.remainingBalance > 0 }) {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Evolution")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 20) {
                        PaymentComparisonCard(
                            title: "First Payment",
                            principal: firstPayment.principalPayment,
                            interest: firstPayment.interestPayment,
                            currency: currency
                        )
                        
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        PaymentComparisonCard(
                            title: "Last Payment",
                            principal: lastPayment.principalPayment,
                            interest: lastPayment.interestPayment,
                            currency: currency
                        )
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
    
    @ViewBuilder
    private var interestSavingsView: some View {
        VStack(spacing: 16) {
            // Interest over time chart
            let schedule = calculation.calculateAmortization()
            if !schedule.isEmpty {
                InterestAccumulationChart(
                    schedule: schedule,
                    currency: currency,
                    extraPayment: calculation.extraPayment
                )
            }
            
            // Savings strategies
            VStack(alignment: .leading, spacing: 12) {
                Text("Interest Reduction Strategies")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                ForEach(savingsStrategies, id: \.title) { strategy in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: strategy.icon)
                            .font(.title3)
                            .foregroundColor(strategy.color)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(strategy.title)
                                .font(.callout)
                                .fontWeight(.medium)
                            
                            Text(strategy.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if let savings = strategy.potentialSavings {
                                Text("Potential savings: \(currency.formatValue(savings))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(strategy.color.opacity(0.05))
                    )
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
    
    @ViewBuilder
    private var scenarioComparisonView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Scenario Comparison")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Generate Scenarios") {
                    generateComparisonScenarios()
                }
                .buttonStyle(.bordered)
            }
            
            if !comparisonScenarios.isEmpty {
                // Comparison chart
                Chart(comparisonScenarios) { scenario in
                    BarMark(
                        x: .value("Scenario", scenario.name),
                        y: .value("Total Interest", scenario.totalInterest)
                    )
                    .foregroundStyle(Color.orange.gradient)
                    .annotation(position: .top) {
                        Text(currency.formatValue(scenario.totalInterest))
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .font(.caption)
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text(Formatters.formatAbbreviated(amount))
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                // Scenario details table
                VStack(spacing: 0) {
                    ForEach(comparisonScenarios) { scenario in
                        ScenarioRow(scenario: scenario, currency: currency)
                        
                        if scenario.id != comparisonScenarios.last?.id {
                            Divider()
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(NSColor.controlBackgroundColor))
                )
            } else {
                EmptyStateView(
                    icon: "chart.bar.xaxis",
                    title: "No Scenarios Generated",
                    subtitle: "Click 'Generate Scenarios' to compare different loan options"
                )
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
        .onAppear {
            if comparisonScenarios.isEmpty {
                generateComparisonScenarios()
            }
        }
    }
    
    @ViewBuilder
    private var amortizationTableToggle: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showAmortizationTable.toggle()
            }
        }) {
            HStack {
                Image(systemName: showAmortizationTable ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                    .font(.title3)
                
                Text(showAmortizationTable ? "Hide Amortization Schedule" : "Show Full Amortization Schedule")
                    .font(.callout)
                    .fontWeight(.medium)
                
                Spacer()
                
                let schedule = calculation.calculateAmortization()
            if !schedule.isEmpty {
                    Text("\(schedule.count) payments")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
    }
    
    @ViewBuilder
    private var keyInsightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Insights")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(generateInsights(), id: \.self) { insight in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        
                        Text(insight)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.yellow.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Helper Methods
    
    private var interestPercentageText: String? {
        guard let totalInterest = result.secondaryValues["Total Interest"],
              let totalPayments = result.secondaryValues["Total Payments"],
              totalPayments > 0 else { return nil }
        
        let percentage = (totalInterest / totalPayments) * 100
        return String(format: "%.1f%% of total", percentage)
    }
    
    private var paymentCountText: String? {
        let periods = calculation.paymentFrequency.periodsPerYear * calculation.loanTermYears
        return "\(Int(periods)) payments"
    }
    
    private func formatTimeValue(_ years: Double) -> String {
        let totalMonths = Int(years * 12)
        let displayYears = totalMonths / 12
        let displayMonths = totalMonths % 12
        
        if displayYears > 0 && displayMonths > 0 {
            return "\(displayYears)y \(displayMonths)m"
        } else if displayYears > 0 {
            return "\(displayYears) years"
        } else {
            return "\(displayMonths) months"
        }
    }
    
    private var savingsStrategies: [(title: String, description: String, icon: String, color: Color, potentialSavings: Double?)] {
        var strategies: [(String, String, String, Color, Double?)] = []
        
        // Extra payment strategy
        let extraPaymentAmount = 100.0
        let extraSavings = calculateSavingsWithExtraPayment(extraPaymentAmount)
        strategies.append((
            "Extra Monthly Payment",
            "Add \(currency.formatValue(extraPaymentAmount)) to each payment",
            "plus.circle.fill",
            .green,
            extraSavings
        ))
        
        // Biweekly payment strategy
        if calculation.paymentFrequency == .monthly {
            let biweeklySavings = calculateBiweeklySavings()
            strategies.append((
                "Biweekly Payments",
                "Pay half the monthly amount every two weeks (26 payments/year)",
                "calendar.badge.clock",
                .blue,
                biweeklySavings
            ))
        }
        
        // Lump sum strategy
        let lumpSum = 5000.0
        let lumpSumSavings = calculateLumpSumSavings(lumpSum)
        strategies.append((
            "Annual Lump Sum",
            "Make a \(currency.formatValue(lumpSum)) extra payment yearly",
            "banknote.fill",
            .purple,
            lumpSumSavings
        ))
        
        return strategies
    }
    
    private func calculateSavingsWithExtraPayment(_ amount: Double) -> Double? {
        // Simplified calculation - in reality would recalculate full amortization
        guard let totalInterest = result.secondaryValues["Total Interest"] else { return nil }
        
        let principal = calculation.principalAmount - calculation.downPayment
        let percentageReduction = (amount * 12 * calculation.loanTermYears) / principal
        return totalInterest * percentageReduction * 0.7 // Rough estimate
    }
    
    private func calculateBiweeklySavings() -> Double? {
        // Biweekly payments result in 26 half-payments = 13 full payments per year
        guard let totalInterest = result.secondaryValues["Total Interest"] else { return nil }
        
        // Rough estimate: one extra payment per year reduces term by ~7 years on a 30-year mortgage
        let termReduction = calculation.loanTermYears * 0.23
        return totalInterest * (termReduction / calculation.loanTermYears)
    }
    
    private func calculateLumpSumSavings(_ amount: Double) -> Double? {
        guard let totalInterest = result.secondaryValues["Total Interest"] else { return nil }
        
        let principal = calculation.principalAmount - calculation.downPayment
        let impactFactor = amount / principal * 10 // Rough multiplier for interest impact
        return totalInterest * impactFactor * 0.5
    }
    
    private func generateComparisonScenarios() {
        comparisonScenarios = []
        
        // Current scenario
        if let totalInterest = result.secondaryValues["Total Interest"] {
            comparisonScenarios.append(ComparisonScenario(
                name: "Current",
                interestRate: calculation.annualInterestRate,
                termYears: calculation.loanTermYears,
                extraPayment: calculation.extraPayment,
                totalInterest: totalInterest,
                monthlyPayment: result.primaryValue
            ))
        }
        
        // Lower rate scenario
        let lowerRate = max(calculation.annualInterestRate - 1.0, 1.0)
        if let lowerRateResult = calculateScenario(rate: lowerRate) {
            comparisonScenarios.append(ComparisonScenario(
                name: "Lower Rate",
                interestRate: lowerRate,
                termYears: calculation.loanTermYears,
                extraPayment: calculation.extraPayment,
                totalInterest: lowerRateResult.totalInterest,
                monthlyPayment: lowerRateResult.payment
            ))
        }
        
        // Shorter term scenario
        let shorterTerm = calculation.loanTermYears == 30 ? 15 : max(calculation.loanTermYears - 5, 1)
        if let shorterTermResult = calculateScenario(termYears: shorterTerm) {
            comparisonScenarios.append(ComparisonScenario(
                name: "\(Int(shorterTerm))yr Term",
                interestRate: calculation.annualInterestRate,
                termYears: shorterTerm,
                extraPayment: calculation.extraPayment,
                totalInterest: shorterTermResult.totalInterest,
                monthlyPayment: shorterTermResult.payment
            ))
        }
        
        // Extra payment scenario
        let extraPayment = result.primaryValue * 0.1 // 10% extra
        if let extraPaymentResult = calculateScenario(extraPayment: extraPayment) {
            comparisonScenarios.append(ComparisonScenario(
                name: "+10% Extra",
                interestRate: calculation.annualInterestRate,
                termYears: calculation.loanTermYears,
                extraPayment: extraPayment,
                totalInterest: extraPaymentResult.totalInterest,
                monthlyPayment: result.primaryValue + extraPayment
            ))
        }
    }
    
    private func calculateScenario(
        rate: Double? = nil,
        termYears: Double? = nil,
        extraPayment: Double? = nil
    ) -> (payment: Double, totalInterest: Double)? {
        let principal = calculation.principalAmount - calculation.downPayment
        let r = (rate ?? calculation.annualInterestRate) / 100 / Double(calculation.paymentFrequency.periodsPerYear)
        let n = (termYears ?? calculation.loanTermYears) * Double(calculation.paymentFrequency.periodsPerYear)
        let extra = extraPayment ?? calculation.extraPayment
        
        // Calculate payment
        let payment = CalculationEngine.calculateLoanPayment(
            principal: principal,
            interestRate: r * 100, // Convert decimal to percentage
            numberOfPayments: n
        )
        
        // Estimate total interest (simplified)
        let totalPayments = (payment + extra) * n
        let totalInterest = totalPayments - principal
        
        return (payment: payment, totalInterest: totalInterest)
    }
    
    private func generateInsights() -> [String] {
        var insights: [String] = []
        
        // Interest cost insight
        if let totalInterest = result.secondaryValues["Total Interest"],
           let principal = result.secondaryValues["Principal"] ?? (calculation.principalAmount - calculation.downPayment) as Double? {
            let interestPercentage = (totalInterest / principal) * 100
            insights.append(String(format: "You'll pay %.1f%% of the loan amount in interest over the life of the loan", interestPercentage))
        }
        
        // Extra payment insight
        if calculation.extraPayment > 0,
           let timeSaved = result.secondaryValues["Time Saved (Years)"],
           let interestSaved = result.secondaryValues["Interest Saved"] {
            insights.append("Your extra payments will save \(formatTimeValue(timeSaved)) and \(currency.formatValue(interestSaved)) in interest")
        }
        
        // Early payment insight
        let schedule = calculation.calculateAmortization()
        if !schedule.isEmpty {
            let periodsPerYear = Int(calculation.paymentFrequency.periodsPerYear)
            let firstYear = schedule.prefix(periodsPerYear).reduce(0.0, { $0 + $1.interestPayment })
            let firstYearPrincipal = schedule.prefix(periodsPerYear).reduce(0.0, { $0 + $1.principalPayment })
            let interestRatio = firstYear / (firstYear + firstYearPrincipal) * 100
            insights.append(String(format: "In the first year, %.1f%% of your payments go toward interest", interestRatio))
        }
        
        // Refinancing insight
        if calculation.annualInterestRate > 5.0 {
            insights.append("Consider refinancing if rates drop by 0.75% or more to potentially save thousands")
        }
        
        return insights
    }
}

struct LoanMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(color)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct PaymentComparisonCard: View {
    let title: String
    let principal: Double
    let interest: Double
    let currency: Currency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                    Text("Principal: \(currency.formatValue(principal))")
                        .font(.caption)
                }
                
                HStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 8, height: 8)
                    Text("Interest: \(currency.formatValue(interest))")
                        .font(.caption)
                }
            }
            
            // Visual bar
            GeometryReader { geometry in
                let total = principal + interest
                let principalWidth = (principal / total) * geometry.size.width
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: principalWidth)
                    
                    Rectangle()
                        .fill(Color.orange)
                }
                .frame(height: 8)
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}

struct InterestAccumulationChart: View {
    let schedule: [AmortizationEntry]
    let currency: Currency
    let extraPayment: Double

    private var chartData: [AmortizationEntry] {
        schedule.filter { entry in
            entry.paymentNumber == 1 ||
            entry.paymentNumber == schedule.count ||
            entry.paymentNumber % max(1, schedule.count / 50) == 0
        }
    }

    private var showComparisonLine: Bool {
        return extraPayment > 0 && schedule.last != nil
    }

    private var comparisonBaseInterest: Double {
        return (schedule.last?.cumulativeInterest ?? 0) * 1.15
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cumulative Interest Over Time")
                .font(.headline)
                .fontWeight(.semibold)

            Chart {
                ForEach(chartData, id: \.paymentNumber) { entry in
                    LineMark(
                        x: .value("Period", entry.paymentNumber),
                        y: .value("Cumulative Interest", entry.cumulativeInterest)
                    )
                    .foregroundStyle(Color.orange.gradient)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }

                if showComparisonLine {
                    LineMark(
                        x: .value("Period", 1),
                        y: .value("Without Extra", 0)
                    )

                    LineMark(
                        x: .value("Period", schedule.count),
                        y: .value("Without Extra", comparisonBaseInterest)
                    )
                    .foregroundStyle(Color.red.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let period = value.as(Int.self) {
                            Text("Year \(period / 12)")
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
                        if let amount = value.as(Double.self) {
                            Text(Formatters.formatAbbreviated(amount))
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

struct ScenarioRow: View {
    let scenario: LoanResultView.ComparisonScenario
    let currency: Currency
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(scenario.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    Label("\(String(format: "%.2f%%", scenario.interestRate))", systemImage: "percent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("\(Int(scenario.termYears))yr", systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if scenario.extraPayment > 0 {
                        Label("+\(currency.formatValue(scenario.extraPayment))", systemImage: "plus.circle")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(currency.formatValue(scenario.monthlyPayment))
                    .font(.callout)
                    .fontWeight(.medium)
                
                Text("per month")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    let calculation = LoanCalculation(
        name: "Sample Mortgage",
        principalAmount: 400000,
        annualInterestRate: 6.5,
        loanTermYears: 30,
        paymentFrequency: .monthly,
        downPayment: 80000,
        extraPayment: 200,
        loanType: .mortgage,
        currency: .usd
    )
    
    return ScrollView {
        LoanResultView(
            result: calculation.result,
            calculation: calculation,
            currency: .usd,
            showAmortizationTable: .constant(false)
        )
    }
    .frame(width: 700)
    .padding()
}
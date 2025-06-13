//
//  TimeValueResultView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on Phase 3 implementation.
//

import SwiftUI
import Charts

/// Enhanced result display for Time Value calculations with interactive visualizations
struct TimeValueResultView: View {
    let result: CalculationResult
    let calculation: TimeValueCalculation
    let currency: Currency
    
    @State private var showDetailedBreakdown: Bool = false
    @State private var selectedVisualization: VisualizationType = .growthChart
    
    enum VisualizationType: String, CaseIterable {
        case growthChart = "Growth Over Time"
        case paymentBreakdown = "Payment Analysis"
        case cashFlowTimeline = "Cash Flow Timeline"
        
        var icon: String {
            switch self {
            case .growthChart: return "chart.line.uptrend.xyaxis"
            case .paymentBreakdown: return "chart.pie"
            case .cashFlowTimeline: return "timeline.selection"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Primary result display
                primaryResultCard
                
                // Visualization selector
                visualizationSelector
                
                // Selected visualization
                selectedVisualizationView
                
                // Detailed breakdown
                if showDetailedBreakdown {
                    detailedBreakdownSection
                }
                
                // Key insights
                keyInsightsSection
            }
        }
    }
    
    @ViewBuilder
    private var primaryResultCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Calculated \(calculation.solveFor.displayName)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(formatPrimaryResult())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: resultIcon)
                    .font(.title)
                    .foregroundColor(resultColor)
                    .padding()
                    .background(
                        Circle()
                            .fill(resultColor.opacity(0.1))
                    )
            }
            
            Divider()
            
            // Summary metrics
            HStack(spacing: 20) {
                if let totalPayments = calculateTotalPayments() {
                    MetricView(
                        title: "Total Payments",
                        value: currency.formatValue(totalPayments),
                        icon: "banknote.fill",
                        color: .blue
                    )
                }
                
                if let totalInterest = calculateTotalInterest() {
                    MetricView(
                        title: "Total Interest",
                        value: currency.formatValue(totalInterest),
                        icon: "percent",
                        color: .orange
                    )
                }
                
                if let effectiveRate = calculateEffectiveRate() {
                    MetricView(
                        title: "Effective Rate",
                        value: String(format: "%.3f%%", effectiveRate),
                        icon: "gauge.with.needle.fill",
                        color: .purple
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
                        .stroke(resultColor.opacity(0.3), lineWidth: 2)
                )
        )
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
        case .growthChart:
            growthOverTimeChart
        case .paymentBreakdown:
            paymentBreakdownView
        case .cashFlowTimeline:
            cashFlowTimelineView
        }
    }
    
    @ViewBuilder
    private var growthOverTimeChart: some View {
        let dataPoints = generateGrowthData()
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Value Growth Over Time")
                .font(.headline)
                .fontWeight(.semibold)
            
            Chart {
                // Present value line
                if let pv = calculation.presentValue, pv > 0 {
                    ForEach(dataPoints) { point in
                        LineMark(
                            x: .value("Year", point.x),
                            y: .value("Value", point.y)
                        )
                        .foregroundStyle(Color.blue)
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                }
                
                // Payment accumulation if applicable
                if let payment = calculation.payment, payment != 0 {
                    ForEach(dataPoints) { point in
                        LineMark(
                            x: .value("Year", point.x),
                            y: .value("Payments", point.paymentTotal ?? 0)
                        )
                        .foregroundStyle(Color.green)
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    }
                }
                
                // Future value marker
                if let fv = calculation.futureValue {
                    PointMark(
                        x: .value("Year", calculation.numberOfYears ?? 0),
                        y: .value("FV", fv)
                    )
                    .foregroundStyle(Color.orange)
                    .symbolSize(150)
                    .annotation(position: .top) {
                        Text("FV: \(currency.formatValue(fv))")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(4)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            .frame(height: 300)
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let year = value.as(Double.self) {
                            Text("Year \(Int(year))")
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
            .chartLegend(position: .top, alignment: .trailing)
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
    
    @ViewBuilder
    private var paymentBreakdownView: some View {
        if let payment = calculation.payment,
           let years = calculation.numberOfYears {

            let periods = calculation.paymentFrequency.periodsPerYear
            let totalPayments = payment * Double(periods) * years
            let principal = calculation.presentValue ?? 0
            let interest = totalPayments - principal
            
            BreakdownPieChart(
                segments: [
                    ("Principal", abs(principal), .blue),
                    ("Interest", abs(interest), .orange)
                ],
                title: "Total Payment Breakdown",
                currency: currency
            )
        } else {
            EmptyStateView(
                icon: "chart.pie",
                title: "No Payment Data",
                subtitle: "Payment breakdown is not available for this calculation type"
            )
        }
    }
    
    @ViewBuilder
    private var cashFlowTimelineView: some View {
        let cashFlows = generateCashFlowData()
        
        CashFlowTimelineChart(
            cashFlows: cashFlows,
            currency: currency
        )
    }
    
    @ViewBuilder
    private var detailedBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Detailed Breakdown")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: { showDetailedBreakdown.toggle() }) {
                    Image(systemName: "chevron.up")
                        .rotationEffect(.degrees(showDetailedBreakdown ? 0 : 180))
                }
                .buttonStyle(.plain)
            }
            
            if showDetailedBreakdown {
                VStack(spacing: 12) {
                    DetailRow(title: "Present Value", value: currency.formatValue(calculation.presentValue ?? 0))
                    DetailRow(title: "Future Value", value: currency.formatValue(calculation.futureValue ?? 0))
                    DetailRow(title: "Payment", value: currency.formatValue(calculation.payment ?? 0))
                    DetailRow(title: "Interest Rate", value: String(format: "%.3f%%", calculation.annualInterestRate ?? 0))
                    DetailRow(title: "Time Period", value: "\(Int(calculation.numberOfYears ?? 0)) years")
                    DetailRow(title: "Payment Frequency", value: calculation.paymentFrequency.displayName)
                    DetailRow(title: "Payments Made", value: calculation.paymentsAtBeginning ? "Beginning of Period" : "End of Period")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
                )
            }
        }
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
    
    private func formatPrimaryResult() -> String {
        switch calculation.solveFor {
        case .presentValue, .futureValue, .payment:
            return currency.formatValue(result.primaryValue)
        case .interestRate:
            return String(format: "%.3f%%", result.primaryValue)
        case .numberOfYears:
            return String(format: "%.2f years", result.primaryValue)
        }
    }
    
    private var resultIcon: String {
        switch calculation.solveFor {
        case .presentValue, .futureValue: return "dollarsign.circle.fill"
        case .payment: return "calendar.badge.clock"
        case .interestRate: return "percent"
        case .numberOfYears: return "clock.fill"
        }
    }
    
    private var resultColor: Color {
        switch calculation.solveFor {
        case .presentValue, .futureValue: return .green
        case .payment: return .blue
        case .interestRate: return .orange
        case .numberOfYears: return .purple
        }
    }
    
    private func calculateTotalPayments() -> Double? {
        guard let payment = calculation.payment,
              let years = calculation.numberOfYears else { return nil }

        let periods = calculation.paymentFrequency.periodsPerYear
        return payment * Double(periods) * years
    }
    
    private func calculateTotalInterest() -> Double? {
        guard let totalPayments = calculateTotalPayments(),
              let principal = calculation.presentValue else { return nil }
        
        return totalPayments - principal
    }
    
    private func calculateEffectiveRate() -> Double? {
        guard let nominalRate = calculation.annualInterestRate else { return nil }

        let periods = calculation.paymentFrequency.periodsPerYear
        let periodicRate = nominalRate / 100 / Double(periods)
        return (pow(1 + periodicRate, Double(periods)) - 1) * 100
    }
    
    private func generateGrowthData() -> [ChartDataPoint] {
        var dataPoints: [ChartDataPoint] = []

        guard let years = calculation.numberOfYears,
              let rate = calculation.annualInterestRate else { return dataPoints }

        let periods = calculation.paymentFrequency.periodsPerYear
        let pv = calculation.presentValue ?? 0
        let payment = calculation.payment ?? 0
        let periodicRate = rate / 100 / Double(periods)
        
        for year in 0...Int(years) {
            let n = Double(year) * Double(periods)
            
            // Calculate future value at this point
            let fvFromPV = pv * pow(1 + periodicRate, n)
            let fvFromPayments: Double
            
            if payment != 0 {
                if calculation.paymentsAtBeginning {
                    fvFromPayments = payment * (1 + periodicRate) * ((pow(1 + periodicRate, n) - 1) / periodicRate)
                } else {
                    fvFromPayments = payment * ((pow(1 + periodicRate, n) - 1) / periodicRate)
                }
            } else {
                fvFromPayments = 0
            }
            
            dataPoints.append(ChartDataPoint(
                x: Double(year),
                y: fvFromPV + fvFromPayments,
                label: "Year \(year)",
                paymentTotal: payment * n
            ))
        }
        
        return dataPoints
    }
    
    private func generateCashFlowData() -> [ChartDataPoint] {
        var cashFlows: [ChartDataPoint] = []
        
        // Initial investment (if any)
        if let pv = calculation.presentValue, pv != 0 {
            cashFlows.append(ChartDataPoint(
                x: 0,
                y: -pv,
                label: "Initial Investment"
            ))
        }
        
        // Periodic payments
        if let payment = calculation.payment,
           let years = calculation.numberOfYears,
           payment != 0 {

            let periods = calculation.paymentFrequency.periodsPerYear
            let periodsToShow = min(Int(years * Double(periods)), 12)
            for period in 1...periodsToShow {
                cashFlows.append(ChartDataPoint(
                    x: Double(period),
                    y: payment,
                    label: "Period \(period)"
                ))
            }

            if periodsToShow < Int(years * Double(periods)) {
                cashFlows.append(ChartDataPoint(
                    x: Double(periodsToShow + 1),
                    y: payment,
                    label: "..."
                ))
            }
        }
        
        // Future value
        if let fv = calculation.futureValue,
           let years = calculation.numberOfYears,
           fv != 0 {
            cashFlows.append(ChartDataPoint(
                x: years,
                y: fv,
                label: "Future Value"
            ))
        }
        
        return cashFlows
    }
    
    private func generateInsights() -> [String] {
        var insights: [String] = []
        
        // Interest vs principal insight
        if let totalInterest = calculateTotalInterest(),
           let principal = calculation.presentValue,
           principal > 0 {
            let interestPercentage = (totalInterest / principal) * 100
            insights.append(String(format: "Total interest paid represents %.1f%% of the principal amount", interestPercentage))
        }
        
        // Effective rate insight
        if let effectiveRate = calculateEffectiveRate(),
           let nominalRate = calculation.annualInterestRate {
            let difference = effectiveRate - nominalRate
            if abs(difference) > 0.01 {
                insights.append(String(format: "The effective annual rate (%.3f%%) is %.3f%% higher than the nominal rate due to compounding", effectiveRate, difference))
            }
        }
        
        // Payment timing insight
        if calculation.paymentsAtBeginning {
            insights.append("Making payments at the beginning of each period reduces the total interest paid")
        }
        
        // Time value insight
        if let pv = calculation.presentValue,
           let fv = calculation.futureValue,
           pv > 0 && fv > 0 {
            let growth = ((fv / pv) - 1) * 100
            insights.append(String(format: "The investment grows by %.1f%% over the time period", growth))
        }
        
        return insights
    }
}

struct MetricView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.callout)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let calculation = TimeValueCalculation(
        name: "Sample Calculation",
        paymentFrequency: .monthly,
        paymentsAtBeginning: false,
        solveFor: .futureValue,
        currency: .usd
    )
    
    calculation.presentValue = 10000
    calculation.payment = 500
    calculation.annualInterestRate = 7.0
    calculation.numberOfYears = 10
    
    return TimeValueResultView(
        result: calculation.result,
        calculation: calculation,
        currency: .usd
    )
    .frame(width: 600)
    .padding()
}
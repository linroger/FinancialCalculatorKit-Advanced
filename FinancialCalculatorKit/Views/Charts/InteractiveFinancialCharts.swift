//
//  InteractiveFinancialCharts.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on Phase 3 implementation.
//

import SwiftUI
import Charts

/// Interactive loan amortization chart with detailed breakdown
struct AmortizationChart: View {
    let entries: [AmortizationEntry]
    let currency: Currency
    let showBreakdown: Bool
    
    @State private var selectedEntry: AmortizationEntry?
    @State private var hoveredPeriod: Int?
    @State private var chartSelection: ChartSelection = .balance
    
    enum ChartSelection: String, CaseIterable {
        case balance = "Remaining Balance"
        case payment = "Payment Breakdown"
        case cumulative = "Cumulative Interest"
        
        var icon: String {
            switch self {
            case .balance: return "chart.line.uptrend.xyaxis"
            case .payment: return "chart.bar.fill"
            case .cumulative: return "chart.xyaxis.line"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Chart header with controls
            HStack {
                Text("Amortization Schedule")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Picker("Chart Type", selection: $chartSelection) {
                    ForEach(ChartSelection.allCases, id: \.self) { selection in
                        Label(selection.rawValue, systemImage: selection.icon)
                            .tag(selection)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 400)
            }
            
            // Main chart
            chartContent
                .frame(height: 300)
            
            // Detail view
            if let selected = selectedEntry {
                selectedDetailView(selected)
            }
            
            // Summary statistics
            if showBreakdown {
                summaryStatistics
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
    
    @ViewBuilder
    private var chartContent: some View {
        switch chartSelection {
        case .balance:
            balanceChart
        case .payment:
            paymentBreakdownChart
        case .cumulative:
            cumulativeInterestChart
        }
    }
    
    @ViewBuilder
    private var balanceChart: some View {
        Chart(entries) { entry in
            LineMark(
                x: .value("Period", entry.paymentNumber),
                y: .value("Balance", entry.remainingBalance)
            )
            .foregroundStyle(Color.blue.gradient)
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            if let hovered = hoveredPeriod, entry.paymentNumber == hovered {
                PointMark(
                    x: .value("Period", entry.paymentNumber),
                    y: .value("Balance", entry.remainingBalance)
                )
                .foregroundStyle(Color.blue)
                .symbolSize(120)

                RuleMark(x: .value("Period", entry.paymentNumber))
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let period = value.as(Int.self) {
                        Text("Period \(period)")
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
                        Text(currency.formatValue(amount))
                            .font(.caption)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onContinuousHover { phase in
                        handleHover(phase, proxy: proxy, geometry: geometry)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var paymentBreakdownChart: some View {
        Chart(entries.prefix(min(entries.count, 60))) { entry in
            BarMark(
                x: .value("Period", entry.paymentNumber),
                y: .value("Principal", entry.principalPayment)
            )
            .foregroundStyle(Color.green.gradient)
            .position(by: .value("Type", "Principal"))

            BarMark(
                x: .value("Period", entry.paymentNumber),
                y: .value("Interest", entry.interestPayment)
            )
            .foregroundStyle(Color.orange.gradient)
            .position(by: .value("Type", "Interest"))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let period = value.as(Int.self) {
                        Text("\(period)")
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
    
    @ViewBuilder
    private var cumulativeInterestChart: some View {
        Chart {
            ForEach(entries) { entry in
                AreaMark(
                    x: .value("Period", entry.paymentNumber),
                    y: .value("Cumulative Interest", entry.cumulativeInterest)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.red.opacity(0.8), Color.red.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("Period", entry.paymentNumber),
                    y: .value("Cumulative Interest", entry.cumulativeInterest)
                )
                .foregroundStyle(Color.red)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            // Add total payment line for comparison
            ForEach(entries) { entry in
                LineMark(
                    x: .value("Period", entry.paymentNumber),
                    y: .value("Total Paid", entry.cumulativePrincipal + entry.cumulativeInterest)
                )
                .foregroundStyle(Color.blue.opacity(0.5))
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let period = value.as(Int.self) {
                        Text("Period \(period)")
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
                        Text(currency.formatValue(amount))
                            .font(.caption)
                    }
                }
            }
        }
    }
    
    private func handleHover(_ phase: HoverPhase, proxy: ChartProxy, geometry: GeometryProxy) {
        switch phase {
        case .active(let location):
            guard let plotFrame = proxy.plotFrame else { return }
            let origin = geometry[plotFrame].origin
            let relativeX = location.x - origin.x
            
            if let period = proxy.value(atX: relativeX, as: Int.self) {
                hoveredPeriod = period
                selectedEntry = entries.first { $0.paymentNumber == period }
            }
        case .ended:
            hoveredPeriod = nil
        }
    }
    
    @ViewBuilder
    private func selectedDetailView(_ entry: AmortizationEntry) -> some View {
        HStack(spacing: 24) {
            DetailColumn(title: "Period", value: "\(entry.paymentNumber)")
            DetailColumn(title: "Payment", value: currency.formatValue(entry.payment))
            DetailColumn(title: "Principal", value: currency.formatValue(entry.principalPayment))
            DetailColumn(title: "Interest", value: currency.formatValue(entry.interestPayment))
            DetailColumn(title: "Balance", value: currency.formatValue(entry.remainingBalance))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var summaryStatistics: some View {
        if let lastEntry = entries.last {
            HStack(spacing: 32) {
                StatisticView(
                    title: "Total Interest Paid",
                    value: currency.formatValue(lastEntry.cumulativeInterest),
                    icon: "dollarsign.circle.fill",
                    color: .orange
                )
                
                StatisticView(
                    title: "Total Amount Paid",
                    value: currency.formatValue(lastEntry.cumulativePrincipal + lastEntry.cumulativeInterest),
                    icon: "banknote.fill",
                    color: .blue
                )
                
                if let firstEntry = entries.first {
                    let interestPercentage = (lastEntry.cumulativeInterest / firstEntry.remainingBalance) * 100
                    StatisticView(
                        title: "Interest as % of Principal",
                        value: String(format: "%.1f%%", interestPercentage),
                        icon: "percent",
                        color: .purple
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
            )
        }
    }
}

/// Interactive investment performance chart
struct InvestmentPerformanceChart: View {
    let cashFlows: [ChartDataPoint]
    let npvPoints: [ChartDataPoint]
    let irr: Double
    let currency: Currency
    
    @State private var selectedMetric: PerformanceMetric = .cashFlow
    @State private var showProjections: Bool = false
    @State private var projectionYears: Int = 5
    
    enum PerformanceMetric: String, CaseIterable {
        case cashFlow = "Cash Flows"
        case npv = "NPV Analysis"
        case cumulative = "Cumulative Returns"
        
        var description: String {
            switch self {
            case .cashFlow: return "Period-by-period cash inflows and outflows"
            case .npv: return "Net present value at different discount rates"
            case .cumulative: return "Running total of cash flows over time"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with controls
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Investment Performance Analysis")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Toggle("Show Projections", isOn: $showProjections)
                        .toggleStyle(.switch)
                }
                
                Picker("Metric", selection: $selectedMetric) {
                    ForEach(PerformanceMetric.allCases, id: \.self) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(.segmented)
                
                Text(selectedMetric.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Chart based on selection
            Group {
                switch selectedMetric {
                case .cashFlow:
                    cashFlowChart
                case .npv:
                    npvAnalysisChart
                case .cumulative:
                    cumulativeReturnsChart
                }
            }
            .frame(height: 350)
            
            // IRR indicator
            irrIndicator
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
    private var cashFlowChart: some View {
        Chart {
            ForEach(cashFlows) { point in
                BarMark(
                    x: .value("Period", point.x),
                    y: .value("Cash Flow", point.y)
                )
                .foregroundStyle(point.y >= 0 ? Color.green.gradient : Color.red.gradient)
                .cornerRadius(4)
                
                // Add projected cash flows if enabled
                if showProjections && point.x == cashFlows.last?.x {
                    ForEach(1...projectionYears, id: \.self) { year in
                        BarMark(
                            x: .value("Period", point.x + Double(year)),
                            y: .value("Projected", projectedCashFlow(baseValue: point.y, year: year))
                        )
                        .foregroundStyle(Color.blue.gradient.opacity(0.5))
                        .cornerRadius(4)
                    }
                }
            }
            
            // Add break-even line
            RuleMark(y: .value("Break-even", 0))
                .foregroundStyle(Color.gray)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let period = value.as(Double.self) {
                        Text(period == 0 ? "Initial" : "Year \(Int(period))")
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
                        Text(currency.formatValue(amount))
                            .font(.caption)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var npvAnalysisChart: some View {
        if !npvPoints.isEmpty {
            Chart {
                ForEach(npvPoints) { point in
                    LineMark(
                        x: .value("Discount Rate", point.x),
                        y: .value("NPV", point.y)
                    )
                    .foregroundStyle(Color.blue.gradient)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))

                    // Highlight IRR point (where NPV = 0)
                    if abs(point.x - irr) < 0.5 {
                        PointMark(
                            x: .value("IRR", point.x),
                            y: .value("NPV", point.y)
                        )
                        .foregroundStyle(Color.orange)
                        .symbolSize(150)
                        .annotation(position: .top) {
                            Text("IRR: \(String(format: "%.2f%%", irr))")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }

                // Add zero line
                RuleMark(y: .value("Zero NPV", 0))
                    .foregroundStyle(Color.gray)

                // Add shaded regions
                if let firstPoint = npvPoints.first, let lastPoint = npvPoints.last {
                    RectangleMark(
                        xStart: .value("Start", firstPoint.x),
                        xEnd: .value("End", irr),
                        yStart: .value("Bottom", npvPoints.map { $0.y }.min() ?? 0),
                        yEnd: .value("Top", npvPoints.map { $0.y }.max() ?? 0)
                    )
                    .foregroundStyle(Color.green.opacity(0.05))
                }
            }
        }
    }
    
    @ViewBuilder
    private var cumulativeReturnsChart: some View {
        let cumulativeData = calculateCumulativeReturns()
        
        Chart(cumulativeData) { point in
            AreaMark(
                x: .value("Period", point.x),
                y: .value("Cumulative", point.y)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: point.y >= 0 
                        ? [Color.green.opacity(0.8), Color.green.opacity(0.1)]
                        : [Color.red.opacity(0.8), Color.red.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)
            
            LineMark(
                x: .value("Period", point.x),
                y: .value("Cumulative", point.y)
            )
            .foregroundStyle(point.y >= 0 ? Color.green : Color.red)
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 2))
        }
    }
    
    @ViewBuilder
    private var irrIndicator: some View {
        HStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Internal Rate of Return (IRR)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(String(format: "%.3f%%", irr))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            if irr > 15 {
                Label("Strong Returns", systemImage: "arrow.up.circle.fill")
                    .foregroundColor(.green)
            } else if irr > 8 {
                Label("Moderate Returns", systemImage: "arrow.right.circle.fill")
                    .foregroundColor(.orange)
            } else {
                Label("Low Returns", systemImage: "arrow.down.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
        )
    }
    
    private func projectedCashFlow(baseValue: Double, year: Int) -> Double {
        // Simple projection with growth rate based on IRR
        let growthRate = min(max(irr / 100, 0.02), 0.15) // Cap growth between 2% and 15%
        return baseValue * pow(1 + growthRate, Double(year))
    }
    
    private func calculateCumulativeReturns() -> [ChartDataPoint] {
        var cumulative = 0.0
        var result: [ChartDataPoint] = []
        
        for point in cashFlows {
            cumulative += point.y
            result.append(ChartDataPoint(
                x: point.x,
                y: cumulative,
                label: point.label
            ))
        }
        
        return result
    }
}

/// Supporting views for interactive charts
struct DetailColumn: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

struct StatisticView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            // Sample amortization data
            AmortizationChart(
                entries: generateSampleAmortization(),
                currency: .usd,
                showBreakdown: true
            )
            
            // Sample investment data
            InvestmentPerformanceChart(
                cashFlows: [
                    ChartDataPoint(x: 0, y: -100000, label: "Initial"),
                    ChartDataPoint(x: 1, y: 20000, label: "Year 1"),
                    ChartDataPoint(x: 2, y: 25000, label: "Year 2"),
                    ChartDataPoint(x: 3, y: 30000, label: "Year 3"),
                    ChartDataPoint(x: 4, y: 35000, label: "Year 4"),
                    ChartDataPoint(x: 5, y: 140000, label: "Year 5")
                ],
                npvPoints: generateNPVCurve(),
                irr: 12.5,
                currency: .usd
            )
        }
        .padding()
    }
    .frame(width: 800)
}

// Helper functions for preview
private func generateSampleAmortization() -> [AmortizationEntry] {
    var entries: [AmortizationEntry] = []
    let principal = 300000.0
    let rate = 0.05 / 12
    let periods = 360
    let payment = 1610.46
    
    var balance = principal
    var cumulativeInterest = 0.0
    var cumulativePrincipal = 0.0
    
    for period in 1...min(periods, 60) { // Show first 60 for preview
        let interestPayment = balance * rate
        let principalPayment = payment - interestPayment
        balance -= principalPayment
        cumulativeInterest += interestPayment
        cumulativePrincipal += principalPayment
        
        entries.append(AmortizationEntry(
            paymentNumber: period,
            payment: payment,
            principalPayment: principalPayment,
            interestPayment: interestPayment,
            remainingBalance: max(0, balance),
            cumulativePrincipal: cumulativePrincipal,
            cumulativeInterest: cumulativeInterest
        ))
    }
    
    return entries
}

private func generateNPVCurve() -> [ChartDataPoint] {
    let cashFlows = [-100000.0, 20000, 25000, 30000, 35000, 140000]
    var points: [ChartDataPoint] = []
    
    for rate in stride(from: 0.0, through: 30.0, by: 0.5) {
        let npv = CalculationEngine.calculateNPV(cashFlows: cashFlows, discountRate: rate)
        points.append(ChartDataPoint(x: rate, y: npv))
    }
    
    return points
}
//
//  CompactCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts

/// Compact, feature-rich financial calculator for popout windows
struct CompactCalculatorView: View {
    @State private var principal: Double = 10000.0
    @State private var interestRate: Double = 4.5
    @State private var termYears: Double = 30.0
    @State private var paymentFrequency: PaymentFrequency = .monthly
    @State private var solveFor: SolveVariable = .payment
    @State private var currency: Currency = .usd
    
    @State private var result: Double = 0.0
    @State private var monthlyPayment: Double = 0.0
    @State private var totalInterest: Double = 0.0
    @State private var totalPaid: Double = 0.0
    @State private var cashFlowData: [CashFlowItem] = []
    @State private var balanceData: [BalanceItem] = []
    
    enum SolveVariable: String, CaseIterable, Identifiable {
        case payment = "payment"
        case principal = "principal"
        case interestRate = "interestRate"
        case term = "term"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .payment: return "Monthly Payment"
            case .principal: return "Principal Amount"
            case .interestRate: return "Interest Rate"
            case .term: return "Loan Term"
            }
        }
        
        var symbol: String {
            switch self {
            case .payment: return "💰"
            case .principal: return "🏛️"
            case .interestRate: return "📈"
            case .term: return "⏰"
            }
        }
    }
    
    struct CashFlowItem: Identifiable {
        let id = UUID()
        let paymentNumber: Int
        let principalPayment: Double
        let interestPayment: Double
        let totalPayment: Double
        let remainingBalance: Double
    }
    
    struct BalanceItem: Identifiable {
        let id = UUID()
        let year: Double
        let balance: Double
        let cumulativeInterest: Double
        let cumulativePrincipal: Double
    }
    
    var body: some View {
        VStack(spacing: 16) {
            headerSection
            inputSection
            
            HStack(spacing: 16) {
                resultSection
                chartSection
            }
            
            cashFlowTable
        }
        .padding(20)
        .frame(width: 800, height: 600)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            calculateResults()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Quick Financial Calculator")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Compact calculator for instant financial calculations")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Text("Solve for:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("Solve For", selection: $solveFor) {
                    ForEach(SolveVariable.allCases) { variable in
                        Label(variable.displayName, systemImage: "")
                            .tag(variable)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 160)
                .onChange(of: solveFor) { _, _ in calculateResults() }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Principal:")
                        .frame(width: 80, alignment: .leading)
                    
                    TextField("10,000", value: $principal, format: .currency(code: currency.rawValue))
                        .textFieldStyle(.roundedBorder)
                        .disabled(solveFor == .principal)
                        .onChange(of: principal) { _, _ in calculateResults() }
                }
                
                HStack {
                    Text("Interest:")
                        .frame(width: 80, alignment: .leading)
                    
                    HStack {
                        TextField("4.5", value: $interestRate, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .disabled(solveFor == .interestRate)
                            .onChange(of: interestRate) { _, _ in calculateResults() }
                        
                        Text("%")
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Term:")
                        .frame(width: 80, alignment: .leading)
                    
                    HStack {
                        TextField("30", value: $termYears, format: .number.precision(.fractionLength(0)))
                            .textFieldStyle(.roundedBorder)
                            .disabled(solveFor == .term)
                            .onChange(of: termYears) { _, _ in calculateResults() }
                        
                        Text("years")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Button(action: calculateResults) {
                Label("Calculate", systemImage: "function")
                    .font(.system(.body, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                Text(solveFor.displayName)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(formatResult())
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1))
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
            
            VStack(spacing: 4) {
                CompactDetailRow(title: "Monthly Payment", value: currency.formatValue(monthlyPayment))
                CompactDetailRow(title: "Total Interest", value: currency.formatValue(totalInterest))
                CompactDetailRow(title: "Total Paid", value: currency.formatValue(totalPaid))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Loan Balance Over Time")
                .font(.headline)
                .fontWeight(.medium)
            
            if !balanceData.isEmpty {
                Chart(balanceData) { item in
                    LineMark(
                        x: .value("Year", item.year),
                        y: .value("Balance", item.balance)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Year", item.year),
                        y: .value("Balance", item.balance)
                    )
                    .foregroundStyle(.blue.opacity(0.1))
                }
                .frame(height: 120)
                .chartXAxis {
                    AxisMarks(values: .stride(by: 5)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let year = value.as(Double.self) {
                                Text("\(Int(year))")
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let balance = value.as(Double.self) {
                                Text(currency.formatValue(balance))
                                    .font(.caption2)
                            }
                        }
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 120)
                    .overlay(
                        Text("No data available")
                            .foregroundColor(.secondary)
                    )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var cashFlowTable: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payment Schedule (First 12 Payments)")
                .font(.headline)
                .fontWeight(.medium)
            
            if !cashFlowData.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        // Header
                        HStack {
                            Text("Payment")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 60)
                            
                            Text("Principal")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 80)
                            
                            Text("Interest")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 80)
                            
                            Text("Total")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 80)
                            
                            Text("Balance")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 100)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(NSColor.controlAccentColor).opacity(0.1))
                        
                        ForEach(cashFlowData.prefix(12)) { item in
                            HStack {
                                Text("\(item.paymentNumber)")
                                    .font(.caption)
                                    .frame(width: 60)
                                
                                Text(currency.formatValue(item.principalPayment))
                                    .font(.caption)
                                    .frame(width: 80)
                                
                                Text(currency.formatValue(item.interestPayment))
                                    .font(.caption)
                                    .frame(width: 80)
                                
                                Text(currency.formatValue(item.totalPayment))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .frame(width: 80)
                                
                                Text(currency.formatValue(item.remainingBalance))
                                    .font(.caption)
                                    .frame(width: 100)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                item.paymentNumber % 2 == 0 ? 
                                Color(NSColor.controlBackgroundColor) : 
                                Color.clear
                            )
                        }
                    }
                }
                .frame(height: 180)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                )
            }
        }
    }
    
    private func formatResult() -> String {
        switch solveFor {
        case .payment:
            return currency.formatValue(monthlyPayment)
        case .principal:
            return currency.formatValue(result)
        case .interestRate:
            return String(format: "%.2f%%", result)
        case .term:
            return String(format: "%.1f years", result)
        }
    }
    
    private func calculateResults() {
        let monthlyRate = interestRate / 100.0 / 12.0
        let totalPayments = termYears * 12.0
        
        switch solveFor {
        case .payment:
            if monthlyRate == 0 {
                monthlyPayment = principal / totalPayments
            } else {
                monthlyPayment = principal * (monthlyRate * pow(1 + monthlyRate, totalPayments)) / 
                                (pow(1 + monthlyRate, totalPayments) - 1)
            }
            result = monthlyPayment
            
        case .principal:
            if monthlyRate == 0 {
                result = monthlyPayment * totalPayments
            } else {
                result = monthlyPayment * (pow(1 + monthlyRate, totalPayments) - 1) / 
                        (monthlyRate * pow(1 + monthlyRate, totalPayments))
            }
            principal = result
            monthlyPayment = result * (monthlyRate * pow(1 + monthlyRate, totalPayments)) / 
                           (pow(1 + monthlyRate, totalPayments) - 1)
            
        case .interestRate:
            // Simplified approximation for interest rate calculation
            let approxRate = (monthlyPayment * totalPayments - principal) / (principal * termYears) * 100
            result = approxRate
            interestRate = approxRate
            
        case .term:
            if monthlyRate == 0 {
                result = principal / monthlyPayment / 12.0
            } else {
                result = log(1 + (monthlyPayment / (principal * monthlyRate))) / (12 * log(1 + monthlyRate))
            }
            termYears = result
        }
        
        // Calculate additional metrics
        totalPaid = monthlyPayment * totalPayments
        totalInterest = totalPaid - principal
        
        // Generate cash flow data
        generateCashFlowData()
        generateBalanceData()
    }
    
    private func generateCashFlowData() {
        cashFlowData = []
        
        let monthlyRate = interestRate / 100.0 / 12.0
        let totalPayments = Int(termYears * 12.0)
        var remainingBalance = principal
        
        for payment in 1...min(totalPayments, 60) { // Limit to 60 payments for performance
            let interestPayment = remainingBalance * monthlyRate
            let principalPayment = monthlyPayment - interestPayment
            remainingBalance -= principalPayment
            
            cashFlowData.append(CashFlowItem(
                paymentNumber: payment,
                principalPayment: principalPayment,
                interestPayment: interestPayment,
                totalPayment: monthlyPayment,
                remainingBalance: max(0, remainingBalance)
            ))
        }
    }
    
    private func generateBalanceData() {
        balanceData = []
        
        let monthlyRate = interestRate / 100.0 / 12.0
        let totalPayments = termYears * 12.0
        var remainingBalance = principal
        
        // Generate yearly data points
        for year in stride(from: 0, through: termYears, by: 1) {
            let paymentsToDate = year * 12.0
            
            if paymentsToDate < totalPayments {
                var tempBalance = principal
                
                for _ in 1...Int(paymentsToDate) {
                    let interestPayment = tempBalance * monthlyRate
                    let principalPayment = monthlyPayment - interestPayment
                    tempBalance -= principalPayment
                    
                    if tempBalance <= 0 {
                        tempBalance = 0
                        break
                    }
                }
                
                balanceData.append(BalanceItem(
                    year: year,
                    balance: max(0, tempBalance),
                    cumulativeInterest: (monthlyPayment * paymentsToDate) - (principal - tempBalance),
                    cumulativePrincipal: principal - tempBalance
                ))
            }
        }
    }
}

/// Simple detail row for compact display
private struct CompactDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    CompactCalculatorView()
        .frame(width: 800, height: 600)
}

//
//  AmortizationView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/8/25.
//

import SwiftUI
import Charts

struct AmortizationView: View {
    @State private var principal: String = ""
    @State private var interestRate: String = ""
    @State private var numberOfPayments: String = ""
    @State private var schedule: [AmortizationEntry] = []
    @State private var errorMessage: String = ""
    @State private var paymentFrequency: PaymentFrequency = .monthly
    @State private var selectedTab = 0
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(MainViewModel.self) private var viewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amortization Schedule")
                        .font(.financialTitle)
                    Text("Generate a detailed loan payment schedule showing principal and interest breakdown")
                        .font(.financialSubheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Input Section
                VStack(spacing: 16) {
                    InputFieldView(
                        title: "Principal Amount",
                        subtitle: nil,
                        value: $principal,
                        placeholder: "Enter loan amount",
                        keyboardType: .numberPad,
                        validation: nil,
                        helpText: "The total amount borrowed",
                        isRequired: true
                    )
                    .numbersOnly(text: $principal)
                    
                    InputFieldView(
                        title: "Annual Interest Rate",
                        subtitle: "APR %",
                        value: $interestRate,
                        placeholder: "Enter interest rate",
                        keyboardType: .decimalPad,
                        validation: nil,
                        helpText: "Annual percentage rate (APR)",
                        isRequired: true
                    )
                    .numbersOnly(text: $interestRate)
                    
                    HStack {
                        InputFieldView(
                            title: "Number of Payments",
                            subtitle: nil,
                            value: $numberOfPayments,
                            placeholder: "Enter number of payments",
                            keyboardType: .numberPad,
                            validation: nil,
                            helpText: "Total number of payments",
                            isRequired: true
                        )
                        .numbersOnly(text: $numberOfPayments)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Payment Frequency")
                                .font(.financialCaption)
                                .foregroundColor(.secondary)
                            
                            Picker("Frequency", selection: $paymentFrequency) {
                                ForEach(PaymentFrequency.allCases, id: \.self) { frequency in
                                    Text(frequency.displayName).tag(frequency)
                                }
                            }
                            .pickerStyle(.menu)
                            .financialCard()
                        }
                    }
                }
                .padding(.horizontal)
                
                // Calculate Button
                Button(action: calculateAmortization) {
                    Label("Generate Schedule", systemImage: "tablecells")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .disabled(principal.isEmpty || interestRate.isEmpty || numberOfPayments.isEmpty)
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.financialCaption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale))
                }
                
                // Results Section
                if !schedule.isEmpty {
                    VStack(spacing: 16) {
                        // Summary Card
                        summaryCard
                        
                        // Tab Selection
                        Picker("View", selection: $selectedTab) {
                            Text("Chart").tag(0)
                            Text("Table").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        // Content based on tab
                        if selectedTab == 0 {
                            chartView
                        } else {
                            tableView
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Amortization")
    }
    
    private func calculateAmortization() {
        // Reset error message
        errorMessage = ""
        
        // Validate inputs
        guard let principalValue = Double(principal),
              let interestRateValue = Double(interestRate),
              let numberOfPaymentsValue = Double(numberOfPayments) else {
            errorMessage = "Please enter valid numeric values"
            return
        }
        
        guard principalValue > 0 else {
            errorMessage = "Principal must be greater than 0"
            return
        }
        
        guard interestRateValue >= 0 else {
            errorMessage = "Interest rate cannot be negative"
            return
        }
        
        guard numberOfPaymentsValue > 0 else {
            errorMessage = "Number of payments must be greater than 0"
            return
        }
        
        // Calculate loan term in years based on payment frequency
        let loanTermYears = paymentFrequency.yearsFromPeriods(numberOfPaymentsValue)
        
        // Create a LoanCalculation object
        let loanCalc = LoanCalculation(
            name: "Amortization Schedule",
            principalAmount: principalValue,
            annualInterestRate: interestRateValue,
            loanTermYears: loanTermYears,
            paymentFrequency: paymentFrequency
        )
        
        // Generate the amortization schedule
        schedule = loanCalc.calculateAmortization()
    }
    
    // MARK: - View Components
    
    private var summaryCard: some View {
        VStack(spacing: 12) {
            if let firstPayment = schedule.first {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monthly Payment")
                            .font(.financialCaption)
                            .foregroundColor(.secondary)
                        Text(viewModel.userPreferences.defaultCurrency.formatValue(firstPayment.payment))
                            .font(.financialHeadline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Total Interest")
                            .font(.financialCaption)
                            .foregroundColor(.secondary)
                        Text(viewModel.userPreferences.defaultCurrency.formatValue(totalInterest))
                            .font(.financialHeadline)
                            .foregroundColor(.orange)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Payments")
                            .font(.financialCaption)
                            .foregroundColor(.secondary)
                        Text(viewModel.userPreferences.defaultCurrency.formatValue(totalPayments))
                            .font(.financialSubheadline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Interest Rate")
                            .font(.financialCaption)
                            .foregroundColor(.secondary)
                        Text("\(interestRate)%")
                            .font(.financialSubheadline)
                    }
                }
            }
        }
        .padding()
        .financialCard()
        .padding(.horizontal)
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Breakdown Over Time")
                .font(.financialSubheadline)
                .padding(.horizontal)
            
            Chart {
                ForEach(Array(schedule.enumerated()), id: \.element.id) { index, entry in
                    BarMark(
                        x: .value("Payment", index + 1),
                        y: .value("Amount", entry.principalPayment),
                        stacking: .standard
                    )
                    .foregroundStyle(by: .value("Type", "Principal"))
                    
                    BarMark(
                        x: .value("Payment", index + 1),
                        y: .value("Amount", entry.interestPayment),
                        stacking: .standard
                    )
                    .foregroundStyle(by: .value("Type", "Interest"))
                }
            }
            .chartForegroundStyleScale([
                "Principal": Color.blue,
                "Interest": Color.orange
            ])
            .frame(height: 300)
            .padding(.horizontal)
            
            // Balance Over Time Chart
            Text("Remaining Balance")
                .font(.financialSubheadline)
                .padding(.horizontal)
                .padding(.top)
            
            Chart {
                ForEach(Array(schedule.enumerated()), id: \.element.id) { index, entry in
                    LineMark(
                        x: .value("Payment", index + 1),
                        y: .value("Balance", entry.remainingBalance)
                    )
                    .foregroundStyle(Color.green)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Payment", index + 1),
                        y: .value("Balance", entry.remainingBalance)
                    )
                    .foregroundStyle(Color.green.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
    
    private var tableView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Amortization Schedule")
                .font(.financialSubheadline)
                .padding(.horizontal)
            
            // Table Header
            tableHeader
            
            // Table Content
            tableContent
        }
    }
    
    private var tableHeader: some View {
        HStack {
            Text("#")
                .frame(width: 40, alignment: .leading)
            Text("Payment")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("Principal")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("Interest")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("Balance")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.financialCaption)
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
    
    private var tableContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(schedule.enumerated()), id: \.element.id) { index, entry in
                    tableRow(index: index, entry: entry)
                }
            }
        }
        .frame(maxHeight: 400)
        .financialCard()
        .padding(.horizontal)
    }
    
    private func tableRow(index: Int, entry: AmortizationEntry) -> some View {
        HStack {
            Text("\(entry.paymentNumber)")
                .frame(width: 40, alignment: .leading)
            Text(formatCurrency(entry.payment))
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(formatCurrency(entry.principalPayment))
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(formatCurrency(entry.interestPayment))
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(formatCurrency(entry.remainingBalance))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.financialNumber)
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
    }
    
    // MARK: - Helper Properties and Functions
    
    private var totalInterest: Double {
        schedule.reduce(0) { $0 + $1.interestPayment }
    }
    
    private var totalPayments: Double {
        schedule.reduce(0) { $0 + $1.payment }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        viewModel.userPreferences.defaultCurrency.formatValue(value)
    }
}

#Preview {
    NavigationStack {
        AmortizationView()
            .environment(MainViewModel())
    }
}

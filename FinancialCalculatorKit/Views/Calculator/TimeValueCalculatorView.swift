//
//  TimeValueCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI
import SwiftData
import LaTeXSwiftUI

/// Fully functional Time Value of Money calculator interface
struct TimeValueCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    @State private var calculation: TimeValueCalculation?
    @State private var calculationName: String = ""
    @State private var presentValue: Double? = nil
    @State private var futureValue: Double? = nil
    @State private var payment: Double? = nil
    @State private var interestRate: Double? = nil
    @State private var numberOfYears: Double? = nil
    @State private var paymentFrequency: PaymentFrequency = .monthly
    @State private var paymentsAtBeginning: Bool = false
    @State private var solveFor: TimeValueVariable = .futureValue
    @State private var currency: Currency = .usd
    
    @State private var isCalculating: Bool = false
    @State private var calculationResult: CalculationResult?
    @State private var validationErrors: [String] = []
    
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
                .disabled(calculationResult == nil || calculationName.isEmpty)
                
                Button("Clear") {
                    clearAll()
                }
                .buttonStyle(.bordered)
            }
        }
        .onAppear {
            loadUserPreferences()
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Time Value of Money Calculator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Calculate present value, future value, payments, interest rates, and time periods using the fundamental principles of time value of money.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Picker("Solve For", selection: $solveFor) {
                        ForEach(TimeValueVariable.allCases) { variable in
                            Text(variable.displayName)
                                .tag(variable)
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
                        StatusIndicator(status: .error, message: error)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: 24) {
            GroupBox("Calculation Details") {
                VStack(spacing: 20) {
                    InputFieldView(
                        title: "Calculation Name",
                        value: $calculationName,
                        placeholder: "My TVM Calculation",
                        validation: .required,
                        helpText: "Give this calculation a descriptive name for easy reference",
                        isRequired: true
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Frequency")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Picker("Payment Frequency", selection: $paymentFrequency) {
                            ForEach(PaymentFrequency.allCases) { freq in
                                Text(freq.displayName)
                                    .tag(freq)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Payments at Beginning of Period", isOn: $paymentsAtBeginning)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text("Check if payments are made at the beginning of each period (annuity due) rather than at the end (ordinary annuity)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .groupBoxStyle(FinancialGroupBoxStyle(variant: .standard))
            
            GroupBox("Financial Values") {
                VStack(spacing: 20) {
                    CurrencyInputField(
                        title: "Present Value (PV)",
                        subtitle: "Current value of future cash flows",
                        value: $presentValue,
                        currency: currency,
                        isRequired: solveFor != .presentValue,
                        helpText: "The current value of the investment or loan principal"
                    )
                    .disabled(solveFor == .presentValue)
                    .opacity(solveFor == .presentValue ? 0.6 : 1.0)
                    
                    CurrencyInputField(
                        title: "Future Value (FV)",
                        subtitle: "Value at a specific future date",
                        value: $futureValue,
                        currency: currency,
                        isRequired: solveFor != .futureValue,
                        helpText: "The value of the investment at the end of the time period"
                    )
                    .disabled(solveFor == .futureValue)
                    .opacity(solveFor == .futureValue ? 0.6 : 1.0)
                    
                    CurrencyInputField(
                        title: "Payment (PMT)",
                        subtitle: "Periodic payment amount",
                        value: $payment,
                        currency: currency,
                        isRequired: solveFor != .payment,
                        helpText: "The amount of each regular payment"
                    )
                    .disabled(solveFor == .payment)
                    .opacity(solveFor == .payment ? 0.6 : 1.0)
                    
                    PercentageInputField(
                        title: "Annual Interest Rate",
                        subtitle: "Nominal annual rate",
                        value: $interestRate,
                        isRequired: solveFor != .interestRate,
                        helpText: "The annual interest rate as a percentage"
                    )
                    .disabled(solveFor == .interestRate)
                    .opacity(solveFor == .interestRate ? 0.6 : 1.0)
                    
                    InputFieldView(
                        title: "Number of Years",
                        subtitle: "Time period",
                        value: Binding(
                            get: { numberOfYears?.description ?? "" },
                            set: { numberOfYears = Double($0) }
                        ),
                        placeholder: "10",
                        keyboardType: .decimalPad,
                        validation: solveFor != .numberOfYears ? .positiveNumber : nil,
                        helpText: "The total time period in years",
                        isRequired: solveFor != .numberOfYears
                    )
                    .disabled(solveFor == .numberOfYears)
                    .opacity(solveFor == .numberOfYears ? 0.6 : 1.0)
                }
            }
            .groupBoxStyle(FinancialGroupBoxStyle(variant: .emphasis, isHighlighted: calculationResult != nil))
        }
        .frame(maxWidth: 420)
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: 20) {
            if isCalculating {
                LoadingStateView(message: "Calculating time value of money...")
            } else if let result = calculationResult {
                ResultDisplayView(
                    result: result,
                    currency: currency
                )
            } else {
                placeholderResultView
            }
            
            // Formula reference
            TimeValueFormulaReferenceView(solveFor: solveFor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var placeholderResultView: some View {
        EmptyStateView(
            icon: "function",
            title: "Ready to Calculate",
            subtitle: "Fill in the known values above and the calculator will solve for the selected variable.",
            actionTitle: "Quick Example",
            action: {
                loadQuickExample()
            }
        )
    }
    
    private var canCalculate: Bool {
        let filledValues = [presentValue, futureValue, payment, interestRate, numberOfYears].compactMap { $0 }.count
        return filledValues >= 4 && !calculationName.isEmpty
    }
    
    private func performCalculation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCalculating = true
            validationErrors = []
        }
        
        // Create a temporary calculation for validation and result computation
        let tempCalculation = TimeValueCalculation(
            name: calculationName,
            paymentFrequency: paymentFrequency,
            paymentsAtBeginning: paymentsAtBeginning,
            solveFor: solveFor,
            currency: currency
        )
        
        tempCalculation.presentValue = presentValue
        tempCalculation.futureValue = futureValue
        tempCalculation.payment = payment
        tempCalculation.annualInterestRate = interestRate
        tempCalculation.numberOfYears = numberOfYears
        
        // Simulate calculation delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCalculating = false
                
                if tempCalculation.isValid {
                    calculationResult = tempCalculation.result
                    calculation = tempCalculation
                } else {
                    validationErrors = tempCalculation.validationErrors
                    calculationResult = nil
                }
            }
        }
    }
    
    private func saveCalculation() {
        guard let calc = calculation else { return }
        
        modelContext.insert(calc)
        
        do {
            try modelContext.save()
            
            // Show success feedback
            withAnimation(.easeInOut(duration: 0.2)) {
                // Could add a success indicator here
            }
        } catch {
            mainViewModel.handleError(.dataExportFailed("Failed to save calculation: \(error.localizedDescription)"))
        }
    }
    
    private func clearAll() {
        withAnimation(.easeInOut(duration: 0.3)) {
            presentValue = nil
            futureValue = nil
            payment = nil
            interestRate = nil
            numberOfYears = nil
            calculationResult = nil
            validationErrors = []
            calculationName = ""
        }
    }
    
    private func loadUserPreferences() {
        currency = mainViewModel.userPreferences.defaultCurrency
        paymentFrequency = mainViewModel.userPreferences.defaultPaymentFrequency
    }
    
    private func loadQuickExample() {
        withAnimation(.easeInOut(duration: 0.3)) {
            calculationName = "Retirement Savings Example"
            presentValue = 10000.0
            payment = 500.0
            interestRate = 7.0
            numberOfYears = 25.0
            solveFor = .futureValue
            paymentFrequency = .monthly
            paymentsAtBeginning = false
        }
    }
}



/// Time Value formula reference component
struct TimeValueFormulaReferenceView: View {
    let solveFor: TimeValueVariable
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "function")
                        .foregroundColor(.accentColor)
                    
                    Text("Formula Reference")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text(formulaDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    LaTeX(formulaText)
                        .frame(height: 50)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                    
                    if !variableDefinitions.isEmpty {
                        Text("Where:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        ForEach(variableDefinitions, id: \.0) { variable, definition in
                            HStack(alignment: .top, spacing: 8) {
                                Text(variable)
                                    .font(.system(.caption, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentColor)
                                
                                Text("=")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(definition)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColor.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var formulaDescription: String {
        switch solveFor {
        case .presentValue:
            return "Calculate the present value of future cash flows."
        case .futureValue:
            return "Calculate the future value of present investments."
        case .payment:
            return "Calculate the required periodic payment amount."
        case .interestRate:
            return "Calculate the required interest rate."
        case .numberOfYears:
            return "Calculate the time required to reach the target."
        }
    }
    
    private var formulaText: String {
        switch solveFor {
        case .presentValue:
            return "$$PV = \\frac{FV}{(1 + r)^n} + PMT \\times \\frac{1 - (1 + r)^{-n}}{r}$$"
        case .futureValue:
            return "$$FV = PV \\times (1 + r)^n + PMT \\times \\frac{(1 + r)^n - 1}{r}$$"
        case .payment:
            return "$$PMT = \\frac{PV \\times r}{1 - (1 + r)^{-n}}$$"
        case .interestRate:
            return "$$r = \\text{Solved using iterative methods (Newton-Raphson)}$$"
        case .numberOfYears:
            return "$$n = \\frac{\\ln(FV/PV)}{\\ln(1 + r)}$$"
        }
    }
    
    private var variableDefinitions: [(String, String)] {
        [
            ("PV", "Present Value"),
            ("FV", "Future Value"),
            ("PMT", "Periodic Payment"),
            ("r", "Interest rate per period"),
            ("n", "Number of periods")
        ]
    }
}

#Preview {
    TimeValueCalculatorView()
        .environment(MainViewModel())
        .modelContainer(for: TimeValueCalculation.self, inMemory: true)
        .frame(width: 1200, height: 800)
}
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
    @State private var presentValue: Double?
    @State private var futureValue: Double?
    @State private var payment: Double?
    @State private var interestRate: Double?
    @State private var numberOfYears: Double?
    @State private var paymentFrequency: PaymentFrequency
    @State private var paymentsAtBeginning: Bool
    @State private var solveFor: TimeValueVariable
    @State private var currency: Currency
    
    @State private var isCalculating: Bool = false
    @State private var calculationResult: CalculationResult?
    @State private var validationErrors: [String] = []
    
    init() {
        _presentValue = State(initialValue: nil)
        _futureValue = State(initialValue: nil)
        _payment = State(initialValue: nil)
        _interestRate = State(initialValue: nil)
        _numberOfYears = State(initialValue: nil)
        _paymentFrequency = State(initialValue: .monthly)
        _paymentsAtBeginning = State(initialValue: false)
        _solveFor = State(initialValue: .futureValue)
        _currency = State(initialValue: .usd)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: FinancialSpacing.xl) {
                headerSection

                HStack(alignment: .top, spacing: FinancialSpacing.xl) {
                    inputSection
                    resultSection
                }
            }
            .padding(FinancialSpacing.xl)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Calculate") {
                    performCalculation()
                }
                .buttonStyle(FinancialButtonStyle(style: .primary))
                .disabled(!canCalculate)

                Button("Save") {
                    saveCalculation()
                }
                .buttonStyle(FinancialButtonStyle(style: .success))
                .disabled(calculationResult == nil)

                Button("Clear") {
                    clearAll()
                }
                .buttonStyle(FinancialButtonStyle(style: .ghost))
            }
        }
        .onAppear {
            loadUserPreferences()
            if let existingCalculation = mainViewModel.selectedCalculation as? TimeValueCalculation {
                calculation = existingCalculation
                presentValue = existingCalculation.presentValue
                futureValue = existingCalculation.futureValue
                payment = existingCalculation.payment
                interestRate = existingCalculation.annualInterestRate
                numberOfYears = existingCalculation.numberOfYears
                paymentFrequency = existingCalculation.paymentFrequency
                paymentsAtBeginning = existingCalculation.paymentsAtBeginning
                solveFor = existingCalculation.solveFor
                currency = existingCalculation.currency
                
                // Re-calculate to display results for existing calculation
                performCalculation()
            }
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: FinancialSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: FinancialSpacing.xs) {
                    Text("Time Value of Money Calculator")
                        .font(.financialTitle)

                    Text("Calculate present value, future value, payments, interest rates, and time periods using the fundamental principles of time value of money.")
                        .font(.financialBody)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: FinancialSpacing.sm) {
                    Picker("Solve For", selection: $solveFor) {
                        ForEach(TimeValueVariable.allCases) { variable in
                            Text(variable.displayName)
                                .tag(variable)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 200)

                    HStack(spacing: FinancialSpacing.sm) {
                        Text("Currency:")
                            .font(.financialCaption)
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
                VStack(spacing: FinancialSpacing.sm) {
                    ForEach(validationErrors, id: \.self) { error in
                        StatusIndicator(.error, message: error)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var inputSection: some View {
        VStack(spacing: FinancialSpacing.xl) {
            DynamicInputSection(
                title: "Calculation Details",
                subtitle: "Configure payment timing and frequency"
            ) {
                VStack(spacing: FinancialSpacing.lg) {
                    VStack(alignment: .leading, spacing: FinancialSpacing.md) {
                        Text("Payment Frequency")
                            .font(.financialSubheadline)

                        Picker("Payment Frequency", selection: $paymentFrequency) {
                            ForEach(PaymentFrequency.allCases) { freq in
                                Text(freq.displayName)
                                    .tag(freq)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: FinancialSpacing.sm) {
                        Toggle("Payments at Beginning of Period", isOn: $paymentsAtBeginning)
                            .font(.financialBody)

                        Text("Check if payments are made at the beginning of each period (annuity due) rather than at the end (ordinary annuity)")
                            .font(.financialCaption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            DynamicInputSection(
                title: "Financial Values",
                subtitle: "Enter known values to solve for \(solveFor.displayName)",
                variant: .emphasis
            ) {
                VStack(spacing: FinancialSpacing.lg) {
                    DynamicCurrencyField(
                        title: "Present Value (PV)",
                        subtitle: "Current value of future cash flows",
                        value: $presentValue,
                        currency: currency,
                        configuration: DynamicFieldConfiguration(
                            isRequired: solveFor != .presentValue,
                            isDisabled: solveFor == .presentValue,
                            helpText: "The current value of the investment or loan principal"
                        )
                    )
                    
                    DynamicCurrencyField(
                        title: "Future Value (FV)",
                        subtitle: "Value at a specific future date",
                        value: $futureValue,
                        currency: currency,
                        configuration: DynamicFieldConfiguration(
                            isRequired: solveFor != .futureValue,
                            isDisabled: solveFor == .futureValue,
                            helpText: "The value of the investment at the end of the time period"
                        )
                    )
                    
                    DynamicCurrencyField(
                        title: "Payment (PMT)",
                        subtitle: "Periodic payment amount",
                        value: $payment,
                        currency: currency,
                        configuration: DynamicFieldConfiguration(
                            isRequired: solveFor != .payment,
                            isDisabled: solveFor == .payment,
                            helpText: "The amount of each regular payment"
                        )
                    )
                    
                    DynamicPercentageField(
                        title: "Annual Interest Rate",
                        subtitle: "Nominal annual rate",
                        value: $interestRate,
                        configuration: DynamicFieldConfiguration(
                            isRequired: solveFor != .interestRate,
                            isDisabled: solveFor == .interestRate,
                            helpText: "The annual interest rate as a percentage"
                        )
                    )
                    
                    DynamicInputField(
                        title: "Number of Years",
                        subtitle: "Time period",
                        value: Binding(
                            get: { numberOfYears?.description ?? "" },
                            set: { numberOfYears = Double($0) }
                        ),
                        configuration: DynamicFieldConfiguration(
                            isRequired: solveFor != .numberOfYears,
                            isDisabled: solveFor == .numberOfYears,
                            helpText: "The total time period in years",
                            validation: solveFor != .numberOfYears ? .positiveNumber : nil
                        ),
                        keyboardType: .decimalPad,
                        placeholder: "10"
                    )
                }
            }
        }
        .frame(maxWidth: 420)
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: FinancialSpacing.lg) {
            if isCalculating {
                LoadingStateView(message: "Calculating time value of money...")
            } else if let result = calculationResult, let calc = calculation {
                TimeValueResultView(
                    result: result,
                    calculation: calc,
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
        return filledValues >= 4
    }
    
    private func performCalculation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCalculating = true
            validationErrors = []
        }
        
        // Create or update the calculation object
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let calculationName = "Time Value Calculator - \(formatter.string(from: Date()))"

        var currentCalculation: TimeValueCalculation
        if let existingCalc = calculation {
            currentCalculation = existingCalc
        } else {
            currentCalculation = TimeValueCalculation(
                name: calculationName,
                paymentFrequency: paymentFrequency,
                paymentsAtBeginning: paymentsAtBeginning,
                solveFor: solveFor,
                currency: currency
            )
        }
        
        if currentCalculation.modelContext == nil {
            // Only update name for new calculations
            currentCalculation.name = calculationName
        }
        currentCalculation.presentValue = presentValue
        currentCalculation.futureValue = futureValue
        currentCalculation.payment = payment
        currentCalculation.annualInterestRate = interestRate
        currentCalculation.numberOfYears = numberOfYears
        currentCalculation.paymentFrequency = paymentFrequency
        currentCalculation.paymentsAtBeginning = paymentsAtBeginning
        currentCalculation.solveFor = solveFor
        currentCalculation.currency = currency
        
        // Simulate calculation delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCalculating = false
                
                if currentCalculation.isValid {
                    calculationResult = currentCalculation.result
                    calculation = currentCalculation // Update the @State calculation
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
            // Only insert if it's a new calculation not yet in context
            modelContext.insert(calc)
        }
        
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
        }
    }
    
    private func loadUserPreferences() {
        currency = mainViewModel.userPreferences.defaultCurrency
        paymentFrequency = mainViewModel.userPreferences.defaultPaymentFrequency
    }
    
    private func loadQuickExample() {
        withAnimation(.easeInOut(duration: 0.3)) {
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
        VStack(alignment: .leading, spacing: FinancialSpacing.md) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "function")
                        .foregroundColor(.accentColor)

                    Text("Formula Reference")
                        .font(.financialSubheadline)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.financialCaption)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: FinancialSpacing.md) {
                    Text(formulaDescription)
                        .font(.financialBody)
                        .foregroundColor(.secondary)

                    LaTeX(formulaText)
                        .frame(height: 50)
                        .padding(FinancialSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )

                    if !variableDefinitions.isEmpty {
                        Text("Where:")
                            .font(.financialCaption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        ForEach(variableDefinitions, id: \.0) { variable, definition in
                            HStack(alignment: .top, spacing: FinancialSpacing.sm) {
                                Text(variable)
                                    .font(.financialNumberSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentColor)

                                Text("=")
                                    .font(.financialCaption)
                                    .foregroundColor(.secondary)

                                Text(definition)
                                    .font(.financialCaption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(FinancialSpacing.standard)
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
            return "$PV = \\frac{FV}{(1 + r)^n} + PMT \\times \\frac{1 - (1 + r)^{-n}}{r}$"
        case .futureValue:
            return "$FV = PV \\times (1 + r)^n + PMT \\times \\frac{(1 + r)^n - 1}{r}$"
        case .payment:
            return "$PMT = \\frac{PV \\times r}{1 - (1 + r)^{-n}}$"
        case .interestRate:
            return "$r = \\text{Solved using iterative methods (Newton-Raphson)}$"
        case .numberOfYears:
            return "$n = \\frac{\\ln(FV/PV)}{\\ln(1 + r)}$"
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
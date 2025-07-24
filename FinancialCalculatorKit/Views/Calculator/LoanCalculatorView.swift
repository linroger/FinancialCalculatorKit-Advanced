//
//  LoanCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI
import SwiftData

/// Comprehensive loan calculator with amortization schedule and charts
struct LoanCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel
    
    @State private var calculation: LoanCalculation?
    @State private var principalAmount: Double? = nil
    @State private var annualInterestRate: Double? = nil
    @State private var loanTermYears: Double? = nil
    @State private var downPayment: Double? = nil
    @State private var extraPayment: Double? = nil
    @State private var paymentFrequency: PaymentFrequency = .monthly
    @State private var loanType: LoanType = .standardLoan
    @State private var currency: Currency = .usd
    
    @State private var isCalculating: Bool = false
    @State private var calculationResult: CalculationResult?
    @State private var validationErrors: [String] = []
    @State private var showAmortizationTable: Bool = false
    
    private var isMortgage: Bool {
        loanType == .mortgage
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: FinancialSpacing.xl) {
                headerSection

                HStack(alignment: .top, spacing: FinancialSpacing.xl) {
                    inputSection
                    resultSection
                }

                if showAmortizationTable, let calc = calculation {
                    let schedule = calc.calculateAmortization()
                    AmortizationTable(
                        entries: schedule,
                        currency: currency,
                        showFullSchedule: true
                    )
                }
            }
            .responsivePadding()
        }
        .background(Color(NSColor.windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Calculate") {
                    performCalculation()
                }
                .buttonStyle(FinancialButtonStyle(style: .primary))
                .financialHover(style: .button)
                .disabled(!canCalculate)

                if calculationResult != nil {
                    Button(showAmortizationTable ? "Hide Schedule" : "Show Schedule") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showAmortizationTable.toggle()
                        }
                    }
                    .buttonStyle(FinancialButtonStyle(style: .secondary))
                    .financialHover(style: .button)
                }

                Button("Save") {
                    saveCalculation()
                }
                .buttonStyle(FinancialButtonStyle(style: .success))
                .financialHover(style: .button)
                .disabled(calculationResult == nil)

                Button("Clear") {
                    clearAll()
                }
                .buttonStyle(FinancialButtonStyle(style: .ghost))
                .financialHover(style: .button)
            }
        }
        .onAppear {
            loadUserPreferences()
            if let existingCalculation = mainViewModel.selectedCalculation as? LoanCalculation {
                calculation = existingCalculation
                principalAmount = existingCalculation.principalAmount
                annualInterestRate = existingCalculation.annualInterestRate
                loanTermYears = existingCalculation.loanTermYears
                downPayment = existingCalculation.downPayment
                extraPayment = existingCalculation.extraPayment
                paymentFrequency = existingCalculation.paymentFrequency
                loanType = existingCalculation.loanType
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
                    Text(isMortgage ? "Mortgage Calculator" : "Loan Calculator")
                        .font(.financialTitle)

                    Text(isMortgage ?
                         "Calculate mortgage payments, total interest, and create detailed amortization schedules for home loans." :
                         "Calculate loan payments, interest costs, and payment schedules for various types of loans.")
                        .font(.financialBody)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: FinancialSpacing.sm) {
                    Picker("Loan Type", selection: $loanType) {
                        ForEach(LoanType.allCases) { type in
                            Text(type.displayName)
                                .tag(type)
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
        VStack(spacing: FinancialSpacing.lg) {
            DynamicInputSection(
                title: "Loan Details",
                subtitle: isMortgage ? "Home purchase information" : "Loan parameters",
                variant: .emphasis
            ) {
                VStack(spacing: FinancialSpacing.standard) {
                    DynamicCurrencyField(
                        title: isMortgage ? "Home Price" : "Loan Amount",
                        subtitle: isMortgage ? "Total purchase price" : "Principal amount borrowed",
                        value: $principalAmount,
                        currency: currency,
                        configuration: DynamicFieldConfiguration(
                            isRequired: true,
                            helpText: isMortgage ? "The total purchase price of the home" : "The total amount you want to borrow"
                        )
                    )
                    
                    ConditionalSection(condition: isMortgage) {
                        DynamicCurrencyField(
                            title: "Down Payment",
                            subtitle: "Initial payment amount",
                            value: $downPayment,
                            currency: currency,
                            configuration: DynamicFieldConfiguration(
                                helpText: "The amount you pay upfront (typically 10-20% of home price)"
                            )
                        )
                    }
                    
                    DynamicPercentageField(
                        title: "Annual Interest Rate",
                        subtitle: "APR (Annual Percentage Rate)",
                        value: $annualInterestRate,
                        configuration: DynamicFieldConfiguration(
                            isRequired: true,
                            helpText: "The annual interest rate charged by the lender"
                        )
                    )
                    
                    DynamicInputField(
                        title: "Loan Term",
                        subtitle: "Repayment period in years",
                        value: Binding(
                            get: { loanTermYears?.description ?? "" },
                            set: { loanTermYears = Double($0) }
                        ),
                        configuration: DynamicFieldConfiguration(
                            isRequired: true,
                            helpText: "The number of years to repay the loan",
                            validation: .positiveNumber
                        ),
                        keyboardType: .decimalPad,
                        placeholder: isMortgage ? "30" : "5"
                    )
                    
                    VStack(alignment: .leading, spacing: FinancialSpacing.sm) {
                        Text("Payment Frequency")
                            .font(.financialSubheadline)

                        Picker("Payment Frequency", selection: $paymentFrequency) {
                            ForEach(PaymentFrequency.allCases.filter { $0 != .daily && $0 != .weekly }) { freq in
                                Text(freq.displayName)
                                    .tag(freq)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
            
            DynamicInputSection(
                title: "Additional Options",
                subtitle: "Optional parameters to reduce interest",
                isExpanded: false
            ) {
                DynamicCurrencyField(
                    title: "Extra Payment",
                    subtitle: "Additional amount per payment",
                    value: $extraPayment,
                    currency: currency,
                    configuration: DynamicFieldConfiguration(
                        helpText: "Additional amount to pay each period to reduce principal faster"
                    )
                )
            }
        }
        .frame(minWidth: 350, maxWidth: 450)
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: FinancialSpacing.lg) {
            if isCalculating {
                LoadingStateView(message: "Calculating loan details...")
            } else if let result = calculationResult, let calc = calculation {
                LoanResultView(
                    result: result,
                    calculation: calc,
                    currency: currency,
                    showAmortizationTable: $showAmortizationTable
                )
            } else {
                placeholderResultView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var placeholderResultView: some View {
        VStack(spacing: FinancialSpacing.standard) {
            Image(systemName: isMortgage ? "house" : "creditcard")
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.6))
            
            Text("Enter loan details and tap Calculate")
                .font(.financialSubheadline)
                .foregroundColor(.secondary)
            
            Text(isMortgage ? 
                 "Fill in your mortgage details above to calculate monthly payments and see the amortization schedule." :
                 "Fill in your loan details above to calculate payments and total interest costs.")
                .font(.financialBody)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FinancialSpacing.section)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(NSColor.separatorColor).opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var canCalculate: Bool {
        return principalAmount != nil &&
               annualInterestRate != nil &&
               loanTermYears != nil
    }
    
    private func performCalculation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCalculating = true
            validationErrors = []
        }
        
        guard let principal = principalAmount,
              let rate = annualInterestRate,
              let term = loanTermYears else {
            validationErrors = ["Please fill in all required fields"]
            isCalculating = false
            return
        }
        
        // Create a temporary calculation for validation and result computation
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let calculationName = "\(isMortgage ? "Mortgage" : "Loan") Calculator - \(formatter.string(from: Date()))"
        
        let tempCalculation = LoanCalculation(
            name: calculationName,
            principalAmount: principal,
            annualInterestRate: rate,
            loanTermYears: term,
            paymentFrequency: paymentFrequency,
            downPayment: downPayment ?? 0,
            extraPayment: extraPayment ?? 0,
            loanType: loanType,
            currency: currency
        )
        
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
        guard let principal = principalAmount,
              let rate = annualInterestRate,
              let term = loanTermYears else {
            mainViewModel.handleError(.invalidInput("Cannot save calculation with missing principal, interest rate, or loan term."))
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let autoGeneratedName = "\(isMortgage ? "Mortgage" : "Loan") Calculator - \(formatter.string(from: Date()))"
        
        var currentCalculation: LoanCalculation
        if let existingCalc = calculation {
            currentCalculation = existingCalc
        } else {
            currentCalculation = LoanCalculation(
                name: autoGeneratedName,
                principalAmount: principal,
                annualInterestRate: rate,
                loanTermYears: term,
                paymentFrequency: paymentFrequency,
                downPayment: downPayment ?? 0,
                extraPayment: extraPayment ?? 0,
                loanType: loanType,
                currency: currency
            )
        }

        if currentCalculation.modelContext == nil {
            // Only update name for new calculations
            currentCalculation.name = autoGeneratedName
        }
        currentCalculation.principalAmount = principal
        currentCalculation.annualInterestRate = rate
        currentCalculation.loanTermYears = term
        currentCalculation.downPayment = downPayment ?? 0
        currentCalculation.extraPayment = extraPayment ?? 0
        currentCalculation.paymentFrequency = paymentFrequency
        currentCalculation.loanType = loanType
        currentCalculation.currency = currency
        currentCalculation.updateTimestamp()
        
        if currentCalculation.modelContext == nil {
            modelContext.insert(currentCalculation)
        }
        
        do {
            try modelContext.save()
            calculation = currentCalculation // Ensure the @State calculation is updated
            // Show success feedback
        } catch {
            mainViewModel.handleError(.dataExportFailed("Failed to save calculation: \(error.localizedDescription)"))
        }
    }
    
    private func clearAll() {
        withAnimation(.easeInOut(duration: 0.3)) {
            principalAmount = nil
            annualInterestRate = nil
            loanTermYears = nil
            downPayment = nil
            extraPayment = nil
            calculationResult = nil
            validationErrors = []
            showAmortizationTable = false
        }
    }
    
    private func loadUserPreferences() {
        currency = mainViewModel.userPreferences.defaultCurrency
        paymentFrequency = mainViewModel.userPreferences.defaultPaymentFrequency
    }
}

/// Loan insights and tips component
struct LoanInsightsView: View {
    let principalAmount: Double
    let interestRate: Double
    let termYears: Double
    let isMortgage: Bool
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: FinancialSpacing.md) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.yellow)

                    Text(isMortgage ? "Mortgage Insights" : "Loan Tips")
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
                    ForEach(insights, id: \.0) { insight, description in
                        HStack(alignment: .top, spacing: FinancialSpacing.md) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.financialBody)

                            VStack(alignment: .leading, spacing: FinancialSpacing.xs) {
                                Text(insight)
                                    .font(.financialBody)
                                    .fontWeight(.medium)

                                Text(description)
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
                .fill(Color.yellow.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var insights: [(String, String)] {
        var tips: [(String, String)] = []
        
        if interestRate > 7 {
            tips.append(("High Interest Rate", "Consider shopping around for better rates or improving your credit score"))
        }
        
        if isMortgage && termYears > 15 {
            tips.append(("Consider Shorter Term", "A 15-year mortgage typically offers lower rates and saves significant interest"))
        }
        
        if principalAmount > 0 {
            tips.append(("Extra Payments", "Adding just $50-100 extra per payment can save thousands in interest"))
        }
        
        if isMortgage {
            tips.append(("PMI Consideration", "If down payment is less than 20%, you may need private mortgage insurance"))
            tips.append(("Total Housing Costs", "Remember to budget for property taxes, insurance, and maintenance"))
        }
        
        tips.append(("Emergency Fund", "Maintain 3-6 months of payments in savings before taking on debt"))
        
        return tips
    }
}

#Preview {
    LoanCalculatorView()
        .environment(MainViewModel())
        .modelContainer(for: LoanCalculation.self, inMemory: true)
        .frame(width: 1200, height: 800)
}
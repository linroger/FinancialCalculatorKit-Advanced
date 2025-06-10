import SwiftUI
import Charts
import UniformTypeIdentifiers

struct FutureValueRow: Identifiable {
    let id = UUID()
    let period: Int
    let value: Double
}

struct FutureValueView: View {
    @State private var presentValue: Double = 1000
    @State private var interestRate: Double = 5.0 // 5%
    @State private var periods: Int = 10
    @State private var history: [FutureValueRow] = []
    @State private var validationResults: [String: FinancialValidation.ValidationResult] = [:]
    @State private var calculationError: String?
    @State private var isCalculating: Bool = false
    @State private var showPrecisionMode: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            GroupBox("Future Value Calculator") {
                VStack(spacing: 16) {
                    EnhancedCurrencyInputField(
                        title: "Present Value",
                        subtitle: "Initial investment amount",
                        value: $presentValue,
                        currency: .usd,
                        isRequired: true,
                        helpText: "Enter the initial amount of money to invest",
                        maxValue: 1_000_000_000.0,
                        minValue: 1.0
                    )
                    
                    EnhancedPercentageInputField(
                        title: "Interest Rate",
                        subtitle: "Annual percentage rate",
                        value: $interestRate,
                        isRequired: true,
                        helpText: "Enter the annual interest rate (e.g., 5.0 for 5%)",
                        maxValue: 50.0,
                        minValue: -10.0
                    )
                    
                    EnhancedIntegerInputField(
                        title: "Number of Periods",
                        subtitle: "Years of investment",
                        value: $periods,
                        isRequired: true,
                        helpText: "Enter the number of years for the investment",
                        maxValue: 100,
                        minValue: 1
                    )
                    
                    // Calculation options
                    HStack {
                        Toggle("High Precision Mode", isOn: $showPrecisionMode)
                            .font(.caption)
                            .help("Use high-precision calculations for more accurate results")
                        
                        Spacer()
                        
                        Button("Calculate Future Value") {
                            calculate()
                        }
                        .buttonStyle(FinancialButtonStyle(style: .primary, size: .medium))
                        .help("Calculate the future value based on your inputs")
                        .disabled(isCalculating || !allValidationsPass)
                    }
                    
                    // Show validation summary
                    if !validationResults.isEmpty && !FinancialValidation.shared.allValid(validationResults) {
                        ValidationSummaryView(results: validationResults)
                    }
                    
                    // Show calculation error
                    if let calculationError = calculationError {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                            
                            Text(calculationError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .groupBoxStyle(FinancialGroupBoxStyle(variant: .standard))
            if !history.isEmpty {
                GroupBox("Results") {
                    VStack(spacing: 16) {
                        MetricCard(
                            title: "Future Value",
                            value: Formatters.formatCurrency(history.last?.value ?? 0, currency: .usd),
                            subtitle: "After \(periods) years",
                            trend: nil,
                            trendValue: nil,
                            icon: "chart.line.uptrend.xyaxis",
                            color: .financialGreen
                        )
                        
                        Chart(history) { item in
                            LineMark(
                                x: .value("Period", item.period),
                                y: .value("Value", item.value)
                            )
                            .foregroundStyle(Color.financialBlue)
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisValueLabel {
                                    if let doubleValue = value.as(Double.self) {
                                        Text(Formatters.formatAbbreviated(doubleValue))
                                    }
                                }
                            }
                        }
                        
                        Table(history) {
                            TableColumn("Period") { item in 
                                Text("\(item.period)")
                                    .font(.financialNumber)
                            }
                            TableColumn("Value") { item in 
                                Text(Formatters.formatCurrency(item.value, currency: .usd))
                                    .font(.financialCurrency)
                            }
                        }
                        .frame(maxHeight: 200)
                        
                        HStack {
                            Spacer()
                            Button("Export CSV") { 
                                exportCSV() 
                            }
                            .buttonStyle(FinancialButtonStyle(style: .secondary, size: .small))
                            .help("Export calculation results to CSV file")
                        }
                    }
                }
                .groupBoxStyle(FinancialGroupBoxStyle(variant: .result))
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Future Value")
    }

    // Computed property to check if all validations pass
    private var allValidationsPass: Bool {
        return FinancialValidation.shared.allValid(validationResults)
    }
    
    private func calculate() {
        isCalculating = true
        calculationError = nil
        
        // Validate all inputs
        validateInputs()
        
        // Check if validations pass
        guard allValidationsPass else {
            isCalculating = false
            return
        }
        
        Task { @MainActor in
            do {
                if showPrecisionMode {
                    // Use high-precision calculations
                    let context = FinancialValidation.ValidationContext(
                        calculationType: .investment,
                        fieldName: "futureValue",
                        currency: .usd
                    )
                    
                    let result = HighPrecisionMath.validateAndCalculateFutureValue(
                        presentValue: presentValue,
                        rate: interestRate,
                        periods: Double(periods),
                        context: context
                    )
                    
                    switch result {
                    case .success(let futureValue):
                        // Generate series using high precision
                        history = generateHighPrecisionSeries(
                            presentValue: presentValue,
                            rate: interestRate,
                            periods: periods
                        )
                    case .failure(let validationResult):
                        calculationError = "Validation failed: \(validationResult)"
                    }
                } else {
                    // Use standard calculations
                    let rateAsDecimal = interestRate / 100.0
                    let series = FinancialCalculator.futureValueSeries(
                        presentValue: presentValue,
                        interestRate: rateAsDecimal,
                        periods: periods
                    )
                    history = series.map { FutureValueRow(period: $0.period, value: $0.value) }
                }
            } catch {
                calculationError = "Calculation failed: \(error.localizedDescription)"
            }
            
            isCalculating = false
        }
    }
    
    private func validateInputs() {
        // Clear previous results
        validationResults.removeAll()
        
        let context = FinancialValidation.ValidationContext(
            calculationType: .investment,
            fieldName: "futureValue",
            relatedFields: [
                "presentValue": presentValue,
                "interestRate": interestRate,
                "periods": Double(periods)
            ],
            currency: .usd
        )
        
        // Validate present value
        validationResults["presentValue"] = FinancialValidation.shared.validatePrincipal(
            presentValue,
            context: context
        )
        
        // Validate interest rate
        validationResults["interestRate"] = FinancialValidation.shared.validateInterestRate(
            interestRate,
            context: context,
            allowNegative: true
        )
        
        // Validate periods
        validationResults["periods"] = FinancialValidation.shared.validateTerm(
            Double(periods),
            fieldName: "Periods",
            context: context
        )
    }
    
    private func generateHighPrecisionSeries(
        presentValue: Double,
        rate: Double,
        periods: Int
    ) -> [FutureValueRow] {
        var series: [FutureValueRow] = []
        
        for period in 0...periods {
            let context = FinancialValidation.ValidationContext(
                calculationType: .investment,
                fieldName: "futureValue"
            )
            
            let result = HighPrecisionMath.validateAndCalculateFutureValue(
                presentValue: presentValue,
                rate: rate,
                periods: Double(period),
                context: context
            )
            
            switch result {
            case .success(let futureValue):
                let roundedValue = Currency.usd.roundFinancially(futureValue.doubleValue)
                series.append(FutureValueRow(period: period, value: roundedValue))
            case .failure:
                // Fallback to standard calculation for this period
                let rateDecimal = rate / 100.0
                let value = presentValue * pow(1 + rateDecimal, Double(period))
                let roundedValue = Currency.usd.roundFinancially(value)
                series.append(FutureValueRow(period: period, value: roundedValue))
            }
        }
        
        return series
    }

    @MainActor
    private func exportCSV() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.commaSeparatedText]
        let historyData = history  // Capture history outside the closure
        panel.begin { response in
            Task { @MainActor in
                if response == .OK, let url = panel.url {
                    let rows = historyData.map { ["\($0.period)", String(format: "%.2f", $0.value)] }
                    try? CSVHelper.export(rows: [["Period", "Value"]] + rows, to: url)
                }
            }
        }
    }
}

#Preview {
    FutureValueView()
}

//
//  HighPrecisionCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  High-precision financial calculator with precision comparison tools
//

import SwiftUI

struct HighPrecisionCalculatorView: View {
    @State private var selectedCalculationType: CalculationType = .compoundInterest
    @State private var enablePrecisionMode: Bool = false
    @State private var comparisonResults: [PrecisionComparison] = []
    @State private var benchmarkResults: [String] = []
    @State private var validationResults: [FinancialValidation.ValidationResult] = []
    @State private var showingComparison: Bool = false
    @State private var showingBenchmark: Bool = false
    
    // Calculation inputs
    @State private var principal: String = "10000"
    @State private var interestRate: String = "5.5"
    @State private var compoundingFrequency: String = "12"
    @State private var years: String = "10"
    @State private var futureValue: String = ""
    @State private var payment: String = "500"
    @State private var numberOfPeriods: String = "60"
    
    // Bond calculation inputs
    @State private var faceValue: String = "1000"
    @State private var couponRate: String = "4.5"
    @State private var marketRate: String = "5.0"
    @State private var yearsToMaturity: String = "10"
    @State private var paymentsPerYear: String = "2"
    
    // Cash flow inputs for NPV/IRR
    @State private var cashFlowText: String = "-10000, 2000, 3000, 4000, 3500, 2500"
    @State private var discountRate: String = "8.0"
    
    // Results
    @State private var standardResult: Double = 0
    @State private var precisionResult: Double = 0
    @State private var precisionDifference: Double = 0
    
    enum CalculationType: String, CaseIterable {
        case compoundInterest = "Compound Interest"
        case presentValue = "Present Value"
        case futureValue = "Future Value"
        case npv = "Net Present Value"
        case irr = "Internal Rate of Return"
        case bondPrice = "Bond Price"
        
        var icon: String {
            switch self {
            case .compoundInterest: return "percent.circle"
            case .presentValue: return "dollarsign.circle"
            case .futureValue: return "chart.line.uptrend.xyaxis.circle"
            case .npv: return "plus.minus.circle"
            case .irr: return "arrow.2.squarepath.circle"
            case .bondPrice: return "building.columns.circle"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with precision toggle
                precisionHeaderView
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Calculation type selector
                        calculationTypeSelector
                        
                        // Input fields based on calculation type
                        inputFieldsSection
                        
                        // Calculate button
                        calculateButton
                        
                        // Results section
                        if standardResult != 0 || precisionResult != 0 {
                            resultsSection
                        }
                        
                        // Comparison and analysis tools
                        analysisToolsSection
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("High-Precision Calculator")
        .onAppear {
            runInitialValidation()
        }
    }
    
    private var precisionHeaderView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "dial.max.fill")
                    .foregroundColor(.blue)
                Text("Precision Mode")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: $enablePrecisionMode)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            Text(enablePrecisionMode ? 
                 "Using high-precision Decimal arithmetic (28-29 digits)" : 
                 "Using standard Double precision (15-17 digits)")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    private var calculationTypeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Calculation Type")
                .font(.headline)
                .foregroundColor(.primary)
            
            Picker("Calculation Type", selection: $selectedCalculationType) {
                ForEach(CalculationType.allCases, id: \.self) { type in
                    HStack {
                        Image(systemName: type.icon)
                        Text(type.rawValue)
                    }
                    .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    @ViewBuilder
    private var inputFieldsSection: some View {
        VStack(spacing: 16) {
            switch selectedCalculationType {
            case .compoundInterest:
                compoundInterestInputs
            case .presentValue, .futureValue:
                timeValueInputs
            case .npv, .irr:
                cashFlowInputs
            case .bondPrice:
                bondInputs
            }
        }
    }
    
    private var compoundInterestInputs: some View {
        VStack(spacing: 12) {
            Group {
                HStack {
                    Text("Principal ($)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("10000", text: $principal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Interest Rate (%)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("5.5", text: $interestRate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Compounding/Year")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("12", text: $compoundingFrequency)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Years")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("10", text: $years)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
    
    private var timeValueInputs: some View {
        VStack(spacing: 12) {
            Group {
                if selectedCalculationType == .presentValue {
                    HStack {
                        Text("Future Value ($)")
                            .frame(minWidth: 120, alignment: .leading)
                        TextField("15000", text: $futureValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                } else {
                    HStack {
                        Text("Present Value ($)")
                            .frame(minWidth: 120, alignment: .leading)
                        TextField("10000", text: $principal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                }
                
                HStack {
                    Text("Interest Rate (%)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("5.5", text: $interestRate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Periods")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("60", text: $numberOfPeriods)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
    
    private var cashFlowInputs: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Cash Flows (comma-separated)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                TextEditor(text: $cashFlowText)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                Text("Example: -10000, 2000, 3000, 4000, 3500, 2500")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if selectedCalculationType == .npv {
                HStack {
                    Text("Discount Rate (%)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("8.0", text: $discountRate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
    
    private var bondInputs: some View {
        VStack(spacing: 12) {
            Group {
                HStack {
                    Text("Face Value ($)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("1000", text: $faceValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Coupon Rate (%)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("4.5", text: $couponRate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Market Rate (%)")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("5.0", text: $marketRate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Years to Maturity")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("10", text: $yearsToMaturity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Payments/Year")
                        .frame(minWidth: 120, alignment: .leading)
                    TextField("2", text: $paymentsPerYear)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
    
    private var calculateButton: some View {
        Button(action: performCalculation) {
            HStack {
                Image(systemName: "calculator")
                Text("Calculate")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    private var resultsSection: some View {
        VStack(spacing: 16) {
            Text("Calculation Results")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                resultRow(title: "Standard Precision", value: standardResult, color: .orange)
                resultRow(title: "High Precision", value: precisionResult, color: .blue)
                
                if precisionDifference != 0 {
                    resultRow(title: "Difference", value: precisionDifference, color: .red, isDifference: true)
                    
                    let relativeDiff = standardResult != 0 ? abs(precisionDifference / standardResult) * 100 : 0
                    Text("Relative Difference: \(String(format: "%.8f", relativeDiff))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private func resultRow(title: String, value: Double, color: Color, isDifference: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(formatResult(value, isDifference: isDifference))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
    
    private var analysisToolsSection: some View {
        VStack(spacing: 16) {
            Text("Analysis Tools")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                Button(action: runPrecisionComparison) {
                    HStack {
                        Image(systemName: "scale.3d")
                        Text("Compare Precision")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: runPerformanceBenchmark) {
                    HStack {
                        Image(systemName: "speedometer")
                        Text("Performance Benchmark")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: runValidationTests) {
                    HStack {
                        Image(systemName: "checkmark.seal")
                        Text("Validation Tests")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showingComparison) {
            PrecisionComparisonView(results: comparisonResults)
        }
        .sheet(isPresented: $showingBenchmark) {
            BenchmarkResultsView(results: benchmarkResults)
        }
    }
    
    // MARK: - Calculation Methods
    
    private func performCalculation() {
        switch selectedCalculationType {
        case .compoundInterest:
            calculateCompoundInterest()
        case .presentValue:
            calculatePresentValue()
        case .futureValue:
            calculateFutureValue()
        case .npv:
            calculateNPV()
        case .irr:
            calculateIRR()
        case .bondPrice:
            calculateBondPrice()
        }
    }
    
    private func calculateCompoundInterest() {
        guard let p = Double(principal),
              let r = Double(interestRate),
              let n = Double(compoundingFrequency),
              let t = Double(years) else { return }
        
        standardResult = CalculationEngine.calculateCompoundInterestWithPrecision(
            principal: p, rate: r, compoundingFrequency: n, years: t, usePrecision: false
        )
        
        precisionResult = CalculationEngine.calculateCompoundInterestWithPrecision(
            principal: p, rate: r, compoundingFrequency: n, years: t, usePrecision: true
        )
        
        precisionDifference = precisionResult - standardResult
    }
    
    private func calculatePresentValue() {
        guard let fv = Double(futureValue),
              let r = Double(interestRate),
              let n = Double(numberOfPeriods) else { return }
        
        standardResult = CalculationEngine.calculatePresentValueWithPrecision(
            futureValue: fv, interestRate: r, numberOfPeriods: n, usePrecision: false
        )
        
        precisionResult = CalculationEngine.calculatePresentValueWithPrecision(
            futureValue: fv, interestRate: r, numberOfPeriods: n, usePrecision: true
        )
        
        precisionDifference = precisionResult - standardResult
    }
    
    private func calculateFutureValue() {
        guard let pv = Double(principal),
              let r = Double(interestRate),
              let n = Double(numberOfPeriods) else { return }
        
        standardResult = CalculationEngine.calculateFutureValueWithPrecision(
            presentValue: pv, interestRate: r, numberOfPeriods: n, usePrecision: false
        )
        
        precisionResult = CalculationEngine.calculateFutureValueWithPrecision(
            presentValue: pv, interestRate: r, numberOfPeriods: n, usePrecision: true
        )
        
        precisionDifference = precisionResult - standardResult
    }
    
    private func calculateNPV() {
        let cashFlows = parseCashFlows()
        guard !cashFlows.isEmpty,
              let rate = Double(discountRate) else { return }
        
        standardResult = CalculationEngine.calculateNPVWithPrecision(
            cashFlows: cashFlows, discountRate: rate, usePrecision: false
        )
        
        precisionResult = CalculationEngine.calculateNPVWithPrecision(
            cashFlows: cashFlows, discountRate: rate, usePrecision: true
        )
        
        precisionDifference = precisionResult - standardResult
    }
    
    private func calculateIRR() {
        let cashFlows = parseCashFlows()
        guard !cashFlows.isEmpty else { return }
        
        standardResult = CalculationEngine.calculateIRRWithPrecision(
            cashFlows: cashFlows, usePrecision: false
        )
        
        precisionResult = CalculationEngine.calculateIRRWithPrecision(
            cashFlows: cashFlows, usePrecision: true
        )
        
        precisionDifference = precisionResult - standardResult
    }
    
    private func calculateBondPrice() {
        guard let face = Double(faceValue),
              let coupon = Double(couponRate),
              let market = Double(marketRate),
              let maturity = Double(yearsToMaturity),
              let payments = Double(paymentsPerYear) else { return }
        
        standardResult = CalculationEngine.calculateBondPriceWithPrecision(
            faceValue: face, couponRate: coupon, marketRate: market,
            yearsToMaturity: maturity, paymentsPerYear: payments, usePrecision: false
        )
        
        precisionResult = CalculationEngine.calculateBondPriceWithPrecision(
            faceValue: face, couponRate: coupon, marketRate: market,
            yearsToMaturity: maturity, paymentsPerYear: payments, usePrecision: true
        )
        
        precisionDifference = precisionResult - standardResult
    }
    
    // MARK: - Analysis Methods
    
    private func runPrecisionComparison() {
        performCalculation()
        
        let comparison = CalculationEngine.compareCalculationPrecision(
            calculationType: selectedCalculationType.rawValue,
            standardResult: standardResult,
            highPrecisionResult: precisionResult
        )
        
        comparisonResults = [comparison]
        showingComparison = true
    }
    
    private func runPerformanceBenchmark() {
        let iterations = 1000
        
        switch selectedCalculationType {
        case .compoundInterest:
            let benchmark = CalculationEngine.benchmarkCalculationPerformance(
                name: "Compound Interest",
                iterations: iterations,
                standardCalculation: {
                    guard let p = Double(principal), let r = Double(interestRate),
                          let n = Double(compoundingFrequency), let t = Double(years) else { return 0.0 }
                    return CalculationEngine.calculateCompoundInterestWithPrecision(
                        principal: p, rate: r, compoundingFrequency: n, years: t, usePrecision: false
                    )
                },
                highPrecisionCalculation: {
                    guard let p = Double(principal), let r = Double(interestRate),
                          let n = Double(compoundingFrequency), let t = Double(years) else { return 0.0 }
                    return CalculationEngine.calculateCompoundInterestWithPrecision(
                        principal: p, rate: r, compoundingFrequency: n, years: t, usePrecision: true
                    )
                }
            )
            
            benchmarkResults = [
                "Calculation: \(benchmark.name)",
                "Iterations: \(benchmark.iterations)",
                "Standard Time: \(String(format: "%.6f", benchmark.standardTime))s",
                "High-Precision Time: \(String(format: "%.6f", benchmark.highPrecisionTime))s",
                benchmark.performanceDescription
            ]
            
        default:
            benchmarkResults = ["Benchmark not implemented for this calculation type"]
        }
        
        showingBenchmark = true
    }
    
    private func runValidationTests() {
        // TODO: Fix type mismatch - validatePrecisionWithConstants returns [PrecisionValidationResult]
        // validationResults = CalculationEngine.validatePrecisionWithConstants()
    }
    
    private func runInitialValidation() {
        runValidationTests()
    }
    
    // MARK: - Helper Methods
    
    private func parseCashFlows() -> [Double] {
        return cashFlowText
            .components(separatedBy: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
    }
    
    private func formatResult(_ value: Double, isDifference: Bool = false) -> String {
        if isDifference {
            let formatter = NumberFormatter()
            formatter.numberStyle = .scientific
            formatter.maximumFractionDigits = 6
            return formatter.string(from: NSNumber(value: value)) ?? "0"
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 8
            return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
        }
    }
}

// MARK: - Supporting Views

struct PrecisionComparisonView: View {
    let results: [PrecisionComparison]
    
    var body: some View {
        NavigationView {
            List(results, id: \.calculationType) { result in
                VStack(alignment: .leading, spacing: 8) {
                    Text(result.calculationType)
                        .font(.headline)
                    
                    Text("Standard: \(String(format: "%.10f", result.standardResult))")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text("High-Precision: \(String(format: "%.10f", result.highPrecisionResult))")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Difference: \(String(format: "%.2e", result.absoluteDifference))")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Text(result.improvementDescription)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Precision Comparison")
        }
    }
}

struct BenchmarkResultsView: View {
    let results: [String]
    
    var body: some View {
        NavigationView {
            List(results, id: \.self) { result in
                Text(result)
                    .font(.system(.body, design: .monospaced))
            }
            .navigationTitle("Performance Benchmark")
        }
    }
}

#Preview {
    HighPrecisionCalculatorView()
}
//
//  PrecisionDemoView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Demo view showcasing high-precision financial calculations
//

import SwiftUI
import Foundation

struct PrecisionDemoView: View {
    @State private var validationSummary: HighPrecisionValidation.ValidationSummary?
    @State private var performanceComparison: HighPrecisionValidation.PerformanceComparison?
    @State private var accuracyAnalysis: HighPrecisionValidation.AccuracyAnalysis?
    @State private var showingFullReport = false
    @State private var fullReport = ""
    @State private var isRunningTests = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerView
                    
                    // Quick validation section
                    if let validation = validationSummary {
                        validationResultsView(validation)
                    } else {
                        runTestsButton
                    }
                    
                    // Performance comparison
                    if let performance = performanceComparison {
                        performanceView(performance)
                    }
                    
                    // Accuracy analysis
                    if let accuracy = accuracyAnalysis {
                        accuracyView(accuracy)
                    }
                    
                    // Demonstration examples
                    demonstrationExamples
                    
                    // Full report button
                    if validationSummary != nil {
                        fullReportButton
                    }
                }
                .padding()
            }
        }
        .navigationTitle("High-Precision Demo")
        .sheet(isPresented: $showingFullReport) {
            FullReportView(report: fullReport)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "dial.max.fill")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("High-Precision Financial Calculator")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Experience financial-grade precision with Decimal arithmetic")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var runTestsButton: some View {
        Button(action: runValidationTests) {
            HStack {
                if isRunningTests {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "play.circle.fill")
                }
                Text(isRunningTests ? "Running Tests..." : "Run Precision Tests")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isRunningTests ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isRunningTests)
    }
    
    private func validationResultsView(_ validation: HighPrecisionValidation.ValidationSummary) -> some View {
        VStack(spacing: 16) {
            Text("Validation Results")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Summary card
            VStack(spacing: 12) {
                HStack {
                    Text("Overall Result")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(validation.overallResult ? "PASS" : "FAIL")
                        .fontWeight(.bold)
                        .foregroundColor(validation.overallResult ? .green : .red)
                }
                
                HStack {
                    Text("Success Rate")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", validation.successRate))%")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("Tests Passed")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(validation.passedTests)/\(validation.totalTests)")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Individual test results
            VStack(spacing: 8) {
                ForEach(validation.tests.indices, id: \.self) { index in
                    let test = validation.tests[index]
                    testResultRow(test)
                }
            }
        }
    }
    
    private func testResultRow(_ test: HighPrecisionValidation.ValidationTest) -> some View {
        HStack {
            Image(systemName: test.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(test.passed ? .green : .red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(test.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(test.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(String(format: "%.1f", test.improvementFactor))x")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("improvement")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
    }
    
    private func performanceView(_ performance: HighPrecisionValidation.PerformanceComparison) -> some View {
        VStack(spacing: 16) {
            Text("Performance Analysis")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Standard Time")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.6f", performance.standardTime))s")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(.orange)
                }
                
                HStack {
                    Text("Precision Time")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.6f", performance.precisionTime))s")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("Slowdown Factor")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", performance.slowdownFactor))x")
                        .fontWeight(.bold)
                        .foregroundColor(performance.slowdownFactor < 5 ? .green : .orange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommendation:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(performance.recommendation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private func accuracyView(_ accuracy: HighPrecisionValidation.AccuracyAnalysis) -> some View {
        VStack(spacing: 16) {
            Text("Accuracy Analysis")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Average Improvement")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", accuracy.averageImprovement))x")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("Maximum Improvement")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", accuracy.maxImprovement))x")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recommended Use Cases:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    ForEach(accuracy.recommendedUseCases, id: \.self) { useCase in
                        HStack {
                            Text("•")
                                .foregroundColor(.blue)
                            Text(useCase)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var demonstrationExamples: some View {
        VStack(spacing: 16) {
            Text("Live Demonstration")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // Example 1: Floating point precision issue
                demonstrationCard(
                    title: "Floating Point Precision",
                    standardResult: String(format: "%.15f", 0.1 + 0.2),
                    precisionResult: (HighPrecisionMath.FinancialDecimal(0.1) + HighPrecisionMath.FinancialDecimal(0.2)).formatted(decimalPlaces: 15),
                    expectedResult: "0.3",
                    description: "Classic floating point precision issue"
                )
                
                // Example 2: Large number compound interest
                let largeCompound = demonstrateCompoundInterest()
                demonstrationCard(
                    title: "Large Number Compounding",
                    standardResult: String(format: "%.2f", largeCompound.standard),
                    precisionResult: largeCompound.precision.currencyFormatted(),
                    expectedResult: "Precise calculation",
                    description: "$1M compounded for 30 years"
                )
                
                // Example 3: Small rate precision
                let smallRate = demonstrateSmallRate()
                demonstrationCard(
                    title: "Small Rate Precision",
                    standardResult: String(format: "%.8f", smallRate.standard),
                    precisionResult: smallRate.precision.formatted(decimalPlaces: 8),
                    expectedResult: "High precision",
                    description: "0.01% interest rate calculation"
                )
            }
        }
    }
    
    private func demonstrationCard(
        title: String,
        standardResult: String,
        precisionResult: String,
        expectedResult: String,
        description: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Standard:")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    Text(standardResult)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("High-Precision:")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text(precisionResult)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
    
    private var fullReportButton: some View {
        Button(action: generateFullReport) {
            HStack {
                Image(systemName: "doc.text")
                Text("View Full Report")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Actions
    
    private func runValidationTests() {
        isRunningTests = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let validation = HighPrecisionValidation.runQuickValidation()
            let performance = HighPrecisionValidation.runPerformanceComparison()
            let accuracy = HighPrecisionValidation.analyzeAccuracyImprovement()
            
            DispatchQueue.main.async {
                self.validationSummary = validation
                self.performanceComparison = performance
                self.accuracyAnalysis = accuracy
                self.isRunningTests = false
            }
        }
    }
    
    private func generateFullReport() {
        fullReport = HighPrecisionValidation.generateValidationReport()
        showingFullReport = true
    }
    
    // MARK: - Demo Calculations
    
    private func demonstrateCompoundInterest() -> (standard: Double, precision: HighPrecisionMath.FinancialDecimal) {
        let principal = 1_000_000.0
        let rate = 3.25
        let years = 30.0
        
        let standard = principal * pow(1 + rate/100, years)
        let precision = HighPrecisionMath.futureValue(
            presentValue: HighPrecisionMath.FinancialDecimal(principal),
            rate: HighPrecisionMath.FinancialDecimal(rate),
            periods: HighPrecisionMath.FinancialDecimal(years)
        )
        
        return (standard, precision)
    }
    
    private func demonstrateSmallRate() -> (standard: Double, precision: HighPrecisionMath.FinancialDecimal) {
        let principal = 100_000.0
        let rate = 0.01 // 0.01%
        let years = 1.0
        
        let standard = principal * pow(1 + rate/100, years)
        let precision = HighPrecisionMath.futureValue(
            presentValue: HighPrecisionMath.FinancialDecimal(principal),
            rate: HighPrecisionMath.FinancialDecimal(rate),
            periods: HighPrecisionMath.FinancialDecimal(years)
        )
        
        return (standard, precision)
    }
}

// MARK: - Supporting Views

struct FullReportView: View {
    let report: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(report)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
            }
            .navigationTitle("Validation Report")
        }
    }
}

#Preview {
    PrecisionDemoView()
}
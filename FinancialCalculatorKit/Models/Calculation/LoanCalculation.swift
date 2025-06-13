//
//  LoanCalculation.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation
import SwiftData

/// Loan calculation model for standard loans and mortgages
@Model
final class LoanCalculation {
    // MARK: - Common Properties
    var id: UUID
    var metadata: CalculationMetadata
    
    // MARK: - Loan Specific Properties
    /// Principal loan amount
    var principalAmount: Double
    
    /// Annual interest rate (as percentage)
    var annualInterestRate: Double
    
    /// Loan term in years
    var loanTermYears: Double
    
    /// Payment frequency (stored as raw value)
    private var paymentFrequencyRawValue: String
    
    /// Down payment amount (for mortgages)
    var downPayment: Double
    
    /// Additional monthly payment
    var extraPayment: Double
    
    /// Loan type (stored as raw value)
    private var loanTypeRawValue: String
    
    // MARK: - Loan Type Specific Properties
    
    /// Balloon payment amount (for balloon loans)
    var balloonPayment: Double
    
    /// Interest-only period in years (for interest-only loans)
    var interestOnlyPeriod: Double
    
    /// Line of credit limit (for line of credit)
    var creditLimit: Double
    
    /// Current balance on line of credit
    var currentBalance: Double
    
    /// Student loan deferment period in years
    var defermentPeriod: Double
    
    /// Income-driven repayment percentage (for student loans)
    var incomeBasedPaymentPercent: Double
    
    /// Annual income (for income-driven repayment)
    var annualIncome: Double
    
    /// Computed property for paymentFrequency
    var paymentFrequency: PaymentFrequency {
        get {
            PaymentFrequency(rawValue: paymentFrequencyRawValue) ?? .monthly
        }
        set {
            paymentFrequencyRawValue = newValue.rawValue
        }
    }
    
    /// Computed property for loanType
    var loanType: LoanType {
        get {
            LoanType(rawValue: loanTypeRawValue) ?? .standardLoan
        }
        set {
            loanTypeRawValue = newValue.rawValue
        }
    }
    
    init(
        name: String,
        principalAmount: Double,
        annualInterestRate: Double,
        loanTermYears: Double,
        paymentFrequency: PaymentFrequency = .monthly,
        downPayment: Double = 0.0,
        extraPayment: Double = 0.0,
        loanType: LoanType = .standardLoan,
        currency: Currency = .usd,
        balloonPayment: Double = 0.0,
        interestOnlyPeriod: Double = 0.0,
        creditLimit: Double = 0.0,
        currentBalance: Double = 0.0,
        defermentPeriod: Double = 0.0,
        incomeBasedPaymentPercent: Double = 0.0,
        annualIncome: Double = 0.0
    ) {
        self.id = UUID()
        let calculationType = loanType == .mortgage ? CalculationType.mortgage : CalculationType.loan
        self.metadata = CalculationMetadata(
            name: name,
            calculationType: calculationType,
            currency: currency
        )
        
        self.principalAmount = principalAmount
        self.annualInterestRate = annualInterestRate
        self.loanTermYears = loanTermYears
        self.paymentFrequencyRawValue = paymentFrequency.rawValue
        self.downPayment = downPayment
        self.extraPayment = extraPayment
        self.loanTypeRawValue = loanType.rawValue
        self.balloonPayment = balloonPayment
        self.interestOnlyPeriod = interestOnlyPeriod
        self.creditLimit = creditLimit
        self.currentBalance = currentBalance
        self.defermentPeriod = defermentPeriod
        self.incomeBasedPaymentPercent = incomeBasedPaymentPercent
        self.annualIncome = annualIncome
    }
    
    // MARK: - Common Protocol Methods
    
    /// Update the last modified timestamp
    func updateTimestamp() {
        metadata.updateTimestamp()
    }
    
    /// Toggle favorite status
    func toggleFavorite() {
        metadata.toggleFavorite()
    }
    
    var result: CalculationResult {
        guard isValid else {
            return CalculationResult(
                primaryValue: 0.0,
                formattedPrimaryValue: "Invalid inputs",
                explanation: "Please provide valid inputs for all required fields."
            )
        }
        
        let amortization = calculateAmortization()
        let monthlyPayment = amortization.first?.payment ?? 0.0
        let totalInterest = amortization.reduce(0) { $0 + $1.interestPayment }
        let totalPayments = amortization.reduce(0) { $0 + $1.payment }
        
        let formattedPayment = metadata.currency.formatValue(monthlyPayment)
        
        var secondaryValues: [String: Double] = [:]
        secondaryValues["Total Interest"] = totalInterest
        secondaryValues["Total Payments"] = totalPayments
        secondaryValues["Principal Amount"] = principalAmount - downPayment
        
        if downPayment > 0 {
            secondaryValues["Down Payment"] = downPayment
        }
        
        if extraPayment > 0 {
            secondaryValues["Extra Payment"] = extraPayment
            // Calculate time saved with extra payments
            let timeWithoutExtra = calculatePayoffTime(extraPayment: 0)
            let timeWithExtra = calculatePayoffTime(extraPayment: extraPayment)
            secondaryValues["Time Saved (Years)"] = timeWithoutExtra - timeWithExtra
        }
        
        // Add loan type specific values
        switch loanType {
        case .balloonLoan:
            if balloonPayment > 0 {
                secondaryValues["Balloon Payment"] = balloonPayment
                secondaryValues["Regular Payment"] = monthlyPayment
            }
        case .interestOnlyLoan:
            if interestOnlyPeriod > 0 {
                secondaryValues["Interest-Only Period (Years)"] = interestOnlyPeriod
                let ioPayment = (principalAmount - downPayment) * paymentFrequency.periodRate(from: annualInterestRate) / 100
                secondaryValues["Interest-Only Payment"] = ioPayment
            }
        case .lineOfCredit:
            secondaryValues["Credit Limit"] = creditLimit
            secondaryValues["Current Balance"] = currentBalance
            secondaryValues["Available Credit"] = creditLimit - currentBalance
        case .studentLoan:
            if defermentPeriod > 0 {
                secondaryValues["Deferment Period (Years)"] = defermentPeriod
            }
            if incomeBasedPaymentPercent > 0 {
                secondaryValues["Income-Based Payment %"] = incomeBasedPaymentPercent
                secondaryValues["Annual Income"] = annualIncome
            }
        default:
            break
        }
        
        let explanation = generateLoanExplanation()
        
        // Generate chart data for payment breakdown over time
        let chartData = generatePaymentBreakdownData(amortization: amortization)
        
        // Generate table data for amortization schedule
        let tableData = generateAmortizationTable(amortization: amortization)
        
        return CalculationResult(
            primaryValue: monthlyPayment,
            secondaryValues: secondaryValues,
            formattedPrimaryValue: formattedPayment,
            explanation: explanation,
            chartData: chartData,
            tableData: tableData
        )
    }
    
    var isValid: Bool {
        guard !metadata.name.isEmpty else { return false }
        
        return principalAmount > 0 &&
               annualInterestRate >= 0 &&
               loanTermYears > 0 &&
               downPayment >= 0 &&
               extraPayment >= 0 &&
               downPayment < principalAmount
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if metadata.name.isEmpty {
            errors.append("Name is required")
        }
        
        if principalAmount <= 0 {
            errors.append("Principal amount must be positive")
        }
        
        if annualInterestRate < 0 {
            errors.append("Interest rate cannot be negative")
        }
        
        if loanTermYears <= 0 {
            errors.append("Loan term must be positive")
        }
        
        if downPayment < 0 {
            errors.append("Down payment cannot be negative")
        }
        
        if extraPayment < 0 {
            errors.append("Extra payment cannot be negative")
        }
        
        if downPayment >= principalAmount {
            errors.append("Down payment must be less than principal amount")
        }
        
        return errors
    }
    
    /// Calculate monthly payment amount based on loan type
    func calculateMonthlyPayment() -> Double {
        let loanAmount = principalAmount - downPayment
        let periodRate = paymentFrequency.periodRate(from: annualInterestRate)
        let numberOfPayments = paymentFrequency.numberOfPeriods(from: loanTermYears)
        
        switch loanType {
        case .interestOnlyLoan:
            // For interest-only loans, calculate interest-only payment during IO period
            let interestOnlyPayments = paymentFrequency.numberOfPeriods(from: interestOnlyPeriod)
            if interestOnlyPayments > 0 {
                // Interest-only payment
                return (loanAmount * periodRate / 100) + extraPayment
            } else {
                // After IO period, calculate regular amortizing payment
                let remainingPayments = numberOfPayments - interestOnlyPayments
                let basePayment = CalculationEngine.calculateLoanPayment(
                    principal: loanAmount,
                    interestRate: periodRate * 100,
                    numberOfPayments: remainingPayments
                )
                return basePayment + extraPayment
            }
            
        case .balloonLoan:
            // For balloon loans, calculate payment with balloon amount
            let adjustedPrincipal = loanAmount - balloonPayment / pow(1 + periodRate / 100, numberOfPayments)
            let basePayment = CalculationEngine.calculateLoanPayment(
                principal: adjustedPrincipal,
                interestRate: periodRate * 100,
                numberOfPayments: numberOfPayments
            )
            return basePayment + extraPayment
            
        case .lineOfCredit:
            // For line of credit, calculate based on current balance
            let balance = currentBalance > 0 ? currentBalance : loanAmount
            // Minimum payment is typically interest + 1-2% of principal
            let interestPayment = balance * periodRate / 100
            let principalPayment = balance * 0.01 // 1% of balance
            return interestPayment + principalPayment + extraPayment
            
        case .studentLoan:
            // Handle deferment and income-driven repayment
            if defermentPeriod > 0 {
                return 0 // No payment during deferment
            } else if incomeBasedPaymentPercent > 0 && annualIncome > 0 {
                // Income-driven repayment
                let monthlyIncome = annualIncome / 12
                return monthlyIncome * (incomeBasedPaymentPercent / 100) + extraPayment
            } else {
                // Standard calculation
                let basePayment = CalculationEngine.calculateLoanPayment(
                    principal: loanAmount,
                    interestRate: periodRate * 100,
                    numberOfPayments: numberOfPayments
                )
                return basePayment + extraPayment
            }
            
        default:
            // Standard loan calculation for other types
            let basePayment = CalculationEngine.calculateLoanPayment(
                principal: loanAmount,
                interestRate: periodRate * 100,
                numberOfPayments: numberOfPayments
            )
            return basePayment + extraPayment
        }
    }
    
    /// Calculate complete amortization schedule based on loan type
    func calculateAmortization() -> [AmortizationEntry] {
        switch loanType {
        case .interestOnlyLoan:
            return calculateInterestOnlyAmortization()
        case .balloonLoan:
            return calculateBalloonAmortization()
        case .lineOfCredit:
            return calculateLineOfCreditAmortization()
        case .studentLoan:
            return calculateStudentLoanAmortization()
        default:
            return calculateStandardAmortization()
        }
    }
    
    /// Calculate standard loan amortization
    private func calculateStandardAmortization() -> [AmortizationEntry] {
        let loanAmount = principalAmount - downPayment
        let monthlyRate = paymentFrequency.periodRate(from: annualInterestRate / 100)
        let basePayment = calculateMonthlyPayment() - extraPayment
        let totalPayment = basePayment + extraPayment
        
        var schedule: [AmortizationEntry] = []
        var remainingBalance = loanAmount
        var paymentNumber = 1
        let maxPayments = Int(paymentFrequency.numberOfPeriods(from: loanTermYears))
        
        while remainingBalance > 0.01 && paymentNumber <= maxPayments {
            let interestPayment = remainingBalance * monthlyRate
            var principalPayment = totalPayment - interestPayment
            
            // Ensure we don't overpay
            if principalPayment > remainingBalance {
                principalPayment = remainingBalance
            }
            
            let actualPayment = interestPayment + principalPayment
            remainingBalance -= principalPayment
            
            // If balance is paid off, stop generating entries
            if remainingBalance <= 0.01 {
                remainingBalance = 0.0
            }
            
            let entry = AmortizationEntry(
                paymentNumber: paymentNumber,
                payment: actualPayment,
                principalPayment: principalPayment,
                interestPayment: interestPayment,
                remainingBalance: remainingBalance
            )
            
            schedule.append(entry)
            paymentNumber += 1
            
            if remainingBalance < 0.01 {
                break
            }
        }
        
        return schedule
    }
    
    /// Calculate interest-only loan amortization
    private func calculateInterestOnlyAmortization() -> [AmortizationEntry] {
        let loanAmount = principalAmount - downPayment
        let monthlyRate = paymentFrequency.periodRate(from: annualInterestRate / 100)
        let totalPayments = Int(paymentFrequency.numberOfPeriods(from: loanTermYears))
        let interestOnlyPayments = Int(paymentFrequency.numberOfPeriods(from: interestOnlyPeriod))
        
        var schedule: [AmortizationEntry] = []
        var remainingBalance = loanAmount
        var paymentNumber = 1
        
        // Interest-only period
        for payment in 1...min(interestOnlyPayments, totalPayments) {
            let interestPayment = remainingBalance * monthlyRate
            let entry = AmortizationEntry(
                paymentNumber: payment,
                payment: interestPayment + extraPayment,
                principalPayment: extraPayment,
                interestPayment: interestPayment,
                remainingBalance: remainingBalance - extraPayment
            )
            remainingBalance -= extraPayment
            schedule.append(entry)
            paymentNumber += 1
        }
        
        // Amortizing period
        if paymentNumber <= totalPayments {
            let remainingPayments = totalPayments - paymentNumber + 1
            let payment = CalculationEngine.calculateLoanPayment(
                principal: remainingBalance,
                interestRate: monthlyRate * 100,
                numberOfPayments: Double(remainingPayments)
            ) + extraPayment
            
            while remainingBalance > 0.01 && paymentNumber <= totalPayments {
                let interestPayment = remainingBalance * monthlyRate
                var principalPayment = payment - interestPayment
                
                if principalPayment > remainingBalance {
                    principalPayment = remainingBalance
                }
                
                let actualPayment = interestPayment + principalPayment
                remainingBalance -= principalPayment
                
                if remainingBalance <= 0.01 {
                    remainingBalance = 0.0
                }
                
                let entry = AmortizationEntry(
                    paymentNumber: paymentNumber,
                    payment: actualPayment,
                    principalPayment: principalPayment,
                    interestPayment: interestPayment,
                    remainingBalance: remainingBalance
                )
                
                schedule.append(entry)
                paymentNumber += 1
            }
        }
        
        return schedule
    }
    
    /// Calculate balloon loan amortization
    private func calculateBalloonAmortization() -> [AmortizationEntry] {
        let loanAmount = principalAmount - downPayment
        let monthlyRate = paymentFrequency.periodRate(from: annualInterestRate / 100)
        let totalPayments = Int(paymentFrequency.numberOfPeriods(from: loanTermYears))
        let adjustedPrincipal = loanAmount - balloonPayment / pow(1 + monthlyRate, Double(totalPayments))
        let payment = CalculationEngine.calculateLoanPayment(
            principal: adjustedPrincipal,
            interestRate: monthlyRate * 100,
            numberOfPayments: Double(totalPayments)
        ) + extraPayment
        
        var schedule: [AmortizationEntry] = []
        var remainingBalance = loanAmount
        
        // Regular payments
        for paymentNumber in 1..<totalPayments {
            let interestPayment = remainingBalance * monthlyRate
            let principalPayment = payment - interestPayment
            remainingBalance -= principalPayment
            
            let entry = AmortizationEntry(
                paymentNumber: paymentNumber,
                payment: payment,
                principalPayment: principalPayment,
                interestPayment: interestPayment,
                remainingBalance: remainingBalance
            )
            
            schedule.append(entry)
        }
        
        // Final balloon payment
        if totalPayments > 0 {
            let interestPayment = remainingBalance * monthlyRate
            let principalPayment = remainingBalance // Pay off remaining balance
            let finalPayment = interestPayment + principalPayment
            
            let entry = AmortizationEntry(
                paymentNumber: totalPayments,
                payment: finalPayment,
                principalPayment: principalPayment,
                interestPayment: interestPayment,
                remainingBalance: 0.0
            )
            
            schedule.append(entry)
        }
        
        return schedule
    }
    
    /// Calculate line of credit amortization
    private func calculateLineOfCreditAmortization() -> [AmortizationEntry] {
        // For line of credit, we'll show a simplified schedule based on current balance
        let balance = currentBalance > 0 ? currentBalance : principalAmount - downPayment
        let monthlyRate = paymentFrequency.periodRate(from: annualInterestRate / 100)
        let minPaymentRate = 0.01 // 1% of balance minimum
        
        var schedule: [AmortizationEntry] = []
        var remainingBalance = balance
        var paymentNumber = 1
        let maxPayments = Int(paymentFrequency.numberOfPeriods(from: loanTermYears))
        
        while remainingBalance > 0.01 && paymentNumber <= maxPayments {
            let interestPayment = remainingBalance * monthlyRate
            let minPrincipalPayment = remainingBalance * minPaymentRate
            let principalPayment = max(minPrincipalPayment, extraPayment)
            let payment = interestPayment + principalPayment
            
            remainingBalance -= principalPayment
            if remainingBalance <= 0.01 {
                remainingBalance = 0.0
            }
            
            let entry = AmortizationEntry(
                paymentNumber: paymentNumber,
                payment: payment,
                principalPayment: principalPayment,
                interestPayment: interestPayment,
                remainingBalance: remainingBalance
            )
            
            schedule.append(entry)
            paymentNumber += 1
        }
        
        return schedule
    }
    
    /// Calculate student loan amortization
    private func calculateStudentLoanAmortization() -> [AmortizationEntry] {
        let loanAmount = principalAmount - downPayment
        let monthlyRate = paymentFrequency.periodRate(from: annualInterestRate / 100)
        let totalPayments = Int(paymentFrequency.numberOfPeriods(from: loanTermYears))
        let defermentPayments = Int(paymentFrequency.numberOfPeriods(from: defermentPeriod))
        
        var schedule: [AmortizationEntry] = []
        var remainingBalance = loanAmount
        var paymentNumber = 1
        
        // Deferment period (interest may capitalize)
        for payment in 1...min(defermentPayments, totalPayments) {
            let interestPayment = remainingBalance * monthlyRate
            remainingBalance += interestPayment // Interest capitalizes during deferment
            
            let entry = AmortizationEntry(
                paymentNumber: payment,
                payment: 0.0,
                principalPayment: 0.0,
                interestPayment: 0.0, // Show as 0 since it's capitalized
                remainingBalance: remainingBalance
            )
            
            schedule.append(entry)
            paymentNumber += 1
        }
        
        // Repayment period
        if paymentNumber <= totalPayments {
            let remainingPayments = totalPayments - paymentNumber + 1
            
            // Calculate payment based on income-driven or standard
            let payment: Double
            if incomeBasedPaymentPercent > 0 && annualIncome > 0 {
                payment = (annualIncome / 12) * (incomeBasedPaymentPercent / 100) + extraPayment
            } else {
                payment = CalculationEngine.calculateLoanPayment(
                    principal: remainingBalance,
                    interestRate: monthlyRate * 100,
                    numberOfPayments: Double(remainingPayments)
                ) + extraPayment
            }
            
            while remainingBalance > 0.01 && paymentNumber <= totalPayments {
                let interestPayment = remainingBalance * monthlyRate
                var principalPayment = payment - interestPayment
                
                // For income-driven, principal payment might be negative (negative amortization)
                if principalPayment < 0 && incomeBasedPaymentPercent > 0 {
                    remainingBalance += abs(principalPayment) // Balance increases
                    principalPayment = 0
                } else if principalPayment > remainingBalance {
                    principalPayment = remainingBalance
                }
                
                let actualPayment = payment
                remainingBalance -= principalPayment
                
                if remainingBalance <= 0.01 {
                    remainingBalance = 0.0
                }
                
                let entry = AmortizationEntry(
                    paymentNumber: paymentNumber,
                    payment: actualPayment,
                    principalPayment: principalPayment,
                    interestPayment: interestPayment,
                    remainingBalance: remainingBalance
                )
                
                schedule.append(entry)
                paymentNumber += 1
            }
        }
        
        return schedule
    }
    
    /// Calculate payoff time with given extra payment
    private func calculatePayoffTime(extraPayment: Double) -> Double {
        // Create a temporary copy to avoid state mutation
        let loanAmount = principalAmount - downPayment
        let monthlyRate = paymentFrequency.periodRate(from: annualInterestRate / 100)
        let basePayment = calculateMonthlyPayment() - self.extraPayment
        let totalPayment = basePayment + extraPayment
        
        var remainingBalance = loanAmount
        var paymentCount = 0
        let maxPayments = Int(paymentFrequency.numberOfPeriods(from: loanTermYears))
        
        while remainingBalance > 0.01 && paymentCount < maxPayments {
            let interestPayment = remainingBalance * monthlyRate
            var principalPayment = totalPayment - interestPayment
            
            if principalPayment > remainingBalance {
                principalPayment = remainingBalance
            }
            
            remainingBalance -= principalPayment
            paymentCount += 1
            
            if remainingBalance <= 0.01 {
                break
            }
        }
        
        return paymentFrequency.yearsFromPeriods(Double(paymentCount))
    }
    
    /// Generate chart data for payment breakdown visualization
    private func generatePaymentBreakdownData(amortization: [AmortizationEntry]) -> [ChartDataPoint] {
        var data: [ChartDataPoint] = []
        
        for (index, entry) in amortization.enumerated() {
            let year = paymentFrequency.yearsFromPeriods(Double(index + 1))
            
            // Create data points for principal and interest
            data.append(ChartDataPoint(x: year, y: entry.principalPayment, label: "Principal"))
            data.append(ChartDataPoint(x: year, y: entry.interestPayment, label: "Interest"))
        }
        
        return data
    }
    
    /// Generate amortization table data
    private func generateAmortizationTable(amortization: [AmortizationEntry]) -> [TableRow] {
        return amortization.map { entry in
            TableRow(values: [
                "Payment #": "\(entry.paymentNumber)",
                "Payment": metadata.currency.formatValue(entry.payment),
                "Principal": metadata.currency.formatValue(entry.principalPayment),
                "Interest": metadata.currency.formatValue(entry.interestPayment),
                "Balance": metadata.currency.formatValue(entry.remainingBalance)
            ])
        }
    }
    
    /// Generate loan explanation based on loan type
    private func generateLoanExplanation() -> String {
        switch loanType {
        case .balloonLoan:
            return "Balloon loan with regular payments of \(metadata.currency.formatValue(calculateMonthlyPayment())) and a final balloon payment of \(metadata.currency.formatValue(balloonPayment))"
            
        case .interestOnlyLoan:
            if interestOnlyPeriod > 0 {
                let ioPayment = (principalAmount - downPayment) * paymentFrequency.periodRate(from: annualInterestRate) / 100
                return "Interest-only loan with \(interestOnlyPeriod) year(s) of interest-only payments of \(metadata.currency.formatValue(ioPayment)), followed by principal and interest payments"
            } else {
                return "Interest-only loan with fully amortizing payments"
            }
            
        case .lineOfCredit:
            return "Line of credit with \(metadata.currency.formatValue(creditLimit)) limit and \(metadata.currency.formatValue(currentBalance)) current balance. Minimum payment based on interest plus 1% of principal"
            
        case .studentLoan:
            if defermentPeriod > 0 {
                return "Student loan with \(defermentPeriod) year(s) deferment period. Interest will capitalize during deferment"
            } else if incomeBasedPaymentPercent > 0 {
                return "Student loan with income-driven repayment at \(incomeBasedPaymentPercent)% of monthly income"
            } else {
                return "Student loan with standard monthly payments"
            }
            
        case .mortgage:
            return "Mortgage payment including principal and interest. Property taxes and insurance not included"
            
        default:
            return "\(loanType.displayName) payment including principal and interest"
        }
    }
}

// MARK: - Protocol Conformance

extension LoanCalculation: FinancialCalculationProtocol {}


/// Single entry in an amortization schedule
struct AmortizationEntry: Identifiable {
    let id = UUID()
    let paymentNumber: Int
    let payment: Double
    let principalPayment: Double
    let interestPayment: Double
    let remainingBalance: Double
    
    var cumulativePrincipal: Double = 0.0
    var cumulativeInterest: Double = 0.0
}
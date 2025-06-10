//
//  TimeValueVariable.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import Foundation

/// Variables that can be solved for in time value of money calculations
enum TimeValueVariable: String, CaseIterable, Identifiable {
    case presentValue = "presentValue"
    case futureValue = "futureValue"
    case payment = "payment"
    case interestRate = "interestRate"
    case numberOfYears = "numberOfYears"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .presentValue:
            return "Present Value (PV)"
        case .futureValue:
            return "Future Value (FV)"
        case .payment:
            return "Payment (PMT)"
        case .interestRate:
            return "Interest Rate (%)"
        case .numberOfYears:
            return "Number of Periods (N)"
        }
    }
    
    var shortName: String {
        switch self {
        case .presentValue:
            return "PV"
        case .futureValue:
            return "FV"
        case .payment:
            return "PMT"
        case .interestRate:
            return "I/Y"
        case .numberOfYears:
            return "N"
        }
    }
    
    var description: String {
        switch self {
        case .presentValue:
            return "The current value of a future sum of money or stream of cash flows given a specified rate of return"
        case .futureValue:
            return "The value of an asset or cash at a specified date in the future that is equivalent in value to a specified sum today"
        case .payment:
            return "The amount of money paid out at regular intervals (annuity payment)"
        case .interestRate:
            return "The amount charged, expressed as a percentage of principal, by a lender to a borrower for the use of assets"
        case .numberOfYears:
            return "The time period in years for the calculation"
        }
    }
    
    var unit: String {
        switch self {
        case .presentValue, .futureValue, .payment:
            return "Currency"
        case .interestRate:
            return "Percentage"
        case .numberOfYears:
            return "Years"
        }
    }
    
    var systemImage: String {
        switch self {
        case .presentValue:
            return "dollarsign.circle"
        case .futureValue:
            return "dollarsign.circle.fill"
        case .payment:
            return "arrow.right.circle"
        case .interestRate:
            return "percent"
        case .numberOfYears:
            return "calendar"
        }
    }
    
    /// Check if this variable requires positive values only
    var requiresPositiveValue: Bool {
        switch self {
        case .presentValue, .futureValue, .payment, .numberOfYears:
            return true
        case .interestRate:
            return false // Interest rates can be negative in rare cases
        }
    }
    
    /// Get typical range for validation
    var validRange: ClosedRange<Double>? {
        switch self {
        case .presentValue, .futureValue, .payment:
            return 0.01...1_000_000_000 // $0.01 to $1B
        case .interestRate:
            return -10...100 // -10% to 100%
        case .numberOfYears:
            return 1...50 // 1 to 50 years
        }
    }
    
    /// Format value for display
    func formatValue(_ value: Double, currency: Currency = .usd) -> String {
        switch self {
        case .presentValue, .futureValue, .payment:
            return Formatters.formatCurrency(value, currency: currency)
        case .interestRate:
            return Formatters.formatPercentage(value, decimalPlaces: 3)
        case .numberOfYears:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value)) ?? String(value)
        }
    }
}
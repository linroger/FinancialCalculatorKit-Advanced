//
//  LoanType.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import Foundation

/// Types of loans with different calculation methods and characteristics
enum LoanType: String, CaseIterable, Identifiable {
    case standardLoan = "standardLoan"
    case mortgage = "mortgage"
    case autoLoan = "autoLoan"
    case personalLoan = "personalLoan"
    case studentLoan = "studentLoan"
    case businessLoan = "businessLoan"
    case lineOfCredit = "lineOfCredit"
    case balloonLoan = "balloonLoan"
    case interestOnlyLoan = "interestOnlyLoan"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .standardLoan:
            return "Standard Loan"
        case .mortgage:
            return "Mortgage"
        case .autoLoan:
            return "Auto Loan"
        case .personalLoan:
            return "Personal Loan"
        case .studentLoan:
            return "Student Loan"
        case .businessLoan:
            return "Business Loan"
        case .lineOfCredit:
            return "Line of Credit"
        case .balloonLoan:
            return "Balloon Loan"
        case .interestOnlyLoan:
            return "Interest-Only Loan"
        }
    }
    
    var description: String {
        switch self {
        case .standardLoan:
            return "Basic fixed-rate loan with equal monthly payments"
        case .mortgage:
            return "Real estate loan typically with 15-30 year terms"
        case .autoLoan:
            return "Vehicle financing with the car as collateral"
        case .personalLoan:
            return "Unsecured loan for personal expenses"
        case .studentLoan:
            return "Educational loan with potential deferment options"
        case .businessLoan:
            return "Commercial loan for business purposes"
        case .lineOfCredit:
            return "Revolving credit facility with variable payments"
        case .balloonLoan:
            return "Loan with large final payment at maturity"
        case .interestOnlyLoan:
            return "Loan where only interest is paid initially"
        }
    }
    
    var typicalTermRange: ClosedRange<Double> {
        switch self {
        case .standardLoan, .personalLoan:
            return 1...7 // 1-7 years
        case .mortgage:
            return 10...30 // 10-30 years
        case .autoLoan:
            return 2...8 // 2-8 years
        case .studentLoan:
            return 5...25 // 5-25 years
        case .businessLoan:
            return 1...25 // 1-25 years
        case .lineOfCredit:
            return 1...10 // 1-10 years
        case .balloonLoan:
            return 3...7 // 3-7 years
        case .interestOnlyLoan:
            return 5...30 // 5-30 years
        }
    }
    
    var typicalInterestRateRange: ClosedRange<Double> {
        switch self {
        case .standardLoan:
            return 5...15 // 5%-15%
        case .mortgage:
            return 3...8 // 3%-8%
        case .autoLoan:
            return 3...12 // 3%-12%
        case .personalLoan:
            return 6...25 // 6%-25%
        case .studentLoan:
            return 3...8 // 3%-8%
        case .businessLoan:
            return 4...20 // 4%-20%
        case .lineOfCredit:
            return 5...18 // 5%-18%
        case .balloonLoan:
            return 4...12 // 4%-12%
        case .interestOnlyLoan:
            return 3...10 // 3%-10%
        }
    }
    
    var systemImage: String {
        switch self {
        case .standardLoan:
            return "doc.text"
        case .mortgage:
            return "house"
        case .autoLoan:
            return "car"
        case .personalLoan:
            return "person.circle"
        case .studentLoan:
            return "graduationcap"
        case .businessLoan:
            return "building.2"
        case .lineOfCredit:
            return "creditcard"
        case .balloonLoan:
            return "balloon"
        case .interestOnlyLoan:
            return "percent"
        }
    }
    
    var defaultCompoundingFrequency: PaymentFrequency {
        switch self {
        case .standardLoan, .personalLoan, .autoLoan, .mortgage, .studentLoan, .businessLoan, .balloonLoan, .interestOnlyLoan:
            return .monthly
        case .lineOfCredit:
            return .monthly // Can vary, but monthly is common
        }
    }
    
    /// Check if this loan type supports balloon payments
    var supportsBalloonPayments: Bool {
        switch self {
        case .balloonLoan:
            return true
        case .mortgage, .businessLoan:
            return true // Optional
        default:
            return false
        }
    }
    
    /// Check if this loan type supports interest-only periods
    var supportsInterestOnlyPeriods: Bool {
        switch self {
        case .interestOnlyLoan:
            return true
        case .mortgage, .businessLoan, .lineOfCredit:
            return true // Optional
        default:
            return false
        }
    }
    
    /// Check if this loan type typically requires collateral
    var requiresCollateral: Bool {
        switch self {
        case .mortgage, .autoLoan:
            return true
        case .businessLoan:
            return true // Usually
        case .studentLoan, .balloonLoan:
            return false // Often
        case .standardLoan, .personalLoan, .lineOfCredit, .interestOnlyLoan:
            return false
        }
    }
    
    /// Get typical loan amount range
    var typicalAmountRange: ClosedRange<Double> {
        switch self {
        case .standardLoan:
            return 1_000...100_000
        case .mortgage:
            return 50_000...2_000_000
        case .autoLoan:
            return 5_000...100_000
        case .personalLoan:
            return 1_000...50_000
        case .studentLoan:
            return 1_000...200_000
        case .businessLoan:
            return 10_000...10_000_000
        case .lineOfCredit:
            return 5_000...500_000
        case .balloonLoan:
            return 10_000...1_000_000
        case .interestOnlyLoan:
            return 50_000...5_000_000
        }
    }
}
//
//  CalculationType.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation

/// Types of financial calculations supported by the app
enum CalculationType: String, CaseIterable, Identifiable {
    case timeValue = "timeValue"
    case loan = "loan"
    case mortgage = "mortgage"
    case bond = "bond"
    case investment = "investment"
    case options = "options"
    case mathExpression = "mathExpression"
    case depreciation = "depreciation"
    case currency = "currency"
    case conversion = "conversion"
    case futureValue = "futureValue"
    case tickerHistory = "tickerHistory"
    case forwards = "forwards"
    case futures = "futures"
    case swaps = "swaps"
    case scientific = "scientific"
    case advancedScientific = "advancedScientific"
    case equityValuation = "equityValuation"
    case portfolioOptimization = "portfolioOptimization"
    case riskManagement = "riskManagement"
    case fixedIncomeAnalytics = "fixedIncomeAnalytics"
    case alternativeInvestments = "alternativeInvestments"
    case fredData = "fredData"
    case derivativesAnalytics = "derivativesAnalytics"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .timeValue:
            return "Time Value of Money"
        case .loan:
            return "Loan Calculator"
        case .mortgage:
            return "Mortgage Calculator"
        case .bond:
            return "Bond Calculator"
        case .investment:
            return "Investment Analysis"
        case .options:
            return "Options Calculator"
        case .mathExpression:
            return "Math Expression"
        case .depreciation:
            return "Depreciation"
        case .currency:
            return "Currency Exchange"
        case .conversion:
            return "Unit Conversion"
        case .futureValue:
            return "Future Value Calculator"
        case .tickerHistory:
            return "Ticker History"
        case .forwards:
            return "Forwards Pricing"
        case .futures:
            return "Futures Pricing"
        case .swaps:
            return "Swaps Pricing"
        case .scientific:
            return "Scientific Calculator"
        case .advancedScientific:
            return "Advanced Scientific Calculator"
        case .equityValuation:
            return "Equity Valuation"
        case .portfolioOptimization:
            return "Portfolio Optimization"
        case .riskManagement:
            return "Risk Management"
        case .fixedIncomeAnalytics:
            return "Fixed Income Analytics"
        case .alternativeInvestments:
            return "Alternative Investments"
        case .fredData:
            return "FRED Economic Data"
        case .derivativesAnalytics:
            return "Derivatives Analytics"
        }
    }
    
    var description: String {
        switch self {
        case .timeValue:
            return "Calculate present value, future value, payment, interest rate, and number of periods"
        case .loan:
            return "Analyze loan payments, interest, and amortization schedules"
        case .mortgage:
            return "Calculate mortgage payments, total interest, and payment schedules"
        case .bond:
            return "Bond pricing, yield calculations, and sensitivity analysis"
        case .investment:
            return "NPV, IRR, MIRR, and investment performance analysis"
        case .options:
            return "Black-Scholes options pricing with Greeks analysis and risk assessment"
        case .mathExpression:
            return "Advanced mathematical expression evaluator with financial functions and variables"
        case .depreciation:
            return "Straight-line, declining balance, and MACRS depreciation"
        case .currency:
            return "Real-time currency exchange rates and conversions"
        case .conversion:
            return "Unit conversions for international calculations"
        case .futureValue:
            return "Interactive future value calculator with charts and CSV export"
        case .tickerHistory:
            return "Stock ticker history charts with real-time market data"
        case .forwards:
            return "Forward contract pricing with risk analysis and P&L calculations"
        case .futures:
            return "Futures contract pricing, margin requirements, and basis calculations"
        case .swaps:
            return "Interest rate, currency, and commodity swap pricing with sensitivity analysis"
        case .scientific:
            return "Advanced scientific calculator with LaTeX expression display and mathematical functions"
        case .advancedScientific:
            return "Professional scientific calculator with variable management, equation documents, LaTeX rendering, and extensive function library"
        case .equityValuation:
            return "Comprehensive equity valuation using DDM, DCF, and multiples analysis for CFA preparation"
        case .portfolioOptimization:
            return "Modern portfolio theory, asset allocation, and optimization techniques for institutional investors"
        case .riskManagement:
            return "VaR, CVaR, Monte Carlo simulation, stress testing, and comprehensive risk measurement"
        case .fixedIncomeAnalytics:
            return "Duration matching, immunization strategies, yield curve analysis, and credit risk assessment"
        case .alternativeInvestments:
            return "Private equity, hedge funds, REITs, commodities, and infrastructure investment analysis"
        case .fredData:
            return "Explore, visualize, and analyze economic data from the Federal Reserve Bank of St. Louis"
        case .derivativesAnalytics:
            return "Professional cross-instrument derivatives analysis with portfolio risk management, hedging strategies, and comprehensive stress testing"
        }
    }
    
    var systemImage: String {
        switch self {
        case .timeValue:
            return "clock.arrow.circlepath"
        case .loan:
            return "creditcard"
        case .mortgage:
            return "house"
        case .bond:
            return "chart.line.uptrend.xyaxis"
        case .investment:
            return "chart.bar.fill"
        case .options:
            return "function"
        case .mathExpression:
            return "x.squareroot"
        case .depreciation:
            return "arrow.down.right.circle"
        case .currency:
            return "dollarsign.circle"
        case .conversion:
            return "arrow.left.arrow.right"
        case .futureValue:
            return "chart.line.uptrend.xyaxis"
        case .tickerHistory:
            return "chart.xyaxis.line"
        case .forwards:
            return "arrow.forward.circle"
        case .futures:
            return "clock.arrow.2.circlepath"
        case .swaps:
            return "arrow.triangle.swap"
        case .scientific:
            return "equal.square"
        case .advancedScientific:
            return "function.variable"
        case .equityValuation:
            return "building.columns"
        case .portfolioOptimization:
            return "chart.pie"
        case .riskManagement:
            return "shield.checkered"
        case .fixedIncomeAnalytics:
            return "chart.line.text.clipboard"
        case .alternativeInvestments:
            return "building.2"
        case .fredData:
            return "chart.xyaxis.line"
        case .derivativesAnalytics:
            return "rectangle.3.group.connected"
        }
    }
}
//
//  CalculationEngineTests.swift
//  FinancialCalculatorKitTests
//
//  Created by Roger Lin on 6/8/25.
//

import Testing
import Foundation
@testable import FinancialCalculatorKit

struct CalculationEngineTests {
    
    // MARK: - Time Value of Money Tests
    
    @Test("Present Value calculations should be accurate")
    func testPresentValue() {
        // Test 1: Simple present value of a future lump sum
        let pv1 = CalculationEngine.calculatePresentValue(
            futureValue: 1000,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(abs(pv1 - 613.91) < 0.01)
        
        // Test 2: Present value of an annuity
        let pv2 = CalculationEngine.calculatePresentValue(
            payment: 100,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(abs(pv2 - 772.17) < 0.01)
        
        // Test 3: Present value with both future value and annuity
        let pv3 = CalculationEngine.calculatePresentValue(
            futureValue: 1000,
            payment: 100,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(abs(pv3 - 1386.09) < 0.01)
        
        // Test 4: Present value with payment at beginning
        let pv4 = CalculationEngine.calculatePresentValue(
            payment: 100,
            interestRate: 5,
            numberOfPeriods: 10,
            paymentAtBeginning: true
        )
        #expect(abs(pv4 - 810.78) < 0.01)
        
        // Test 5: Zero interest rate
        let pv5 = CalculationEngine.calculatePresentValue(
            futureValue: 1000,
            payment: 100,
            interestRate: 0,
            numberOfPeriods: 10
        )
        #expect(abs(pv5 - 2000) < 0.01)
    }
    
    @Test("Future Value calculations should be accurate")
    func testFutureValue() {
        // Test 1: Simple future value of a present lump sum
        let fv1 = CalculationEngine.calculateFutureValue(
            presentValue: 1000,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(abs(fv1 - 1628.89) < 0.01)
        
        // Test 2: Future value of an annuity
        let fv2 = CalculationEngine.calculateFutureValue(
            payment: 100,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(abs(fv2 - 1257.79) < 0.01)
        
        // Test 3: Future value with both present value and annuity
        let fv3 = CalculationEngine.calculateFutureValue(
            presentValue: 1000,
            payment: 100,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(abs(fv3 - 2886.68) < 0.01)
        
        // Test 4: Future value with payment at beginning
        let fv4 = CalculationEngine.calculateFutureValue(
            payment: 100,
            interestRate: 5,
            numberOfPeriods: 10,
            paymentAtBeginning: true
        )
        #expect(abs(fv4 - 1320.68) < 0.01)
    }
    
    @Test("Payment calculations should be accurate")
    func testPayment() {
        // Test 1: Loan payment calculation
        let pmt1 = CalculationEngine.calculatePayment(
            presentValue: 10000,
            interestRate: 5,
            numberOfPeriods: 60
        )
        #expect(abs(pmt1 - (-188.71)) < 0.01)
        
        // Test 2: Payment to reach future value
        let pmt2 = CalculationEngine.calculatePayment(
            futureValue: 10000,
            interestRate: 5,
            numberOfPeriods: 60
        )
        #expect(abs(pmt2 - (-147.05)) < 0.01)
        
        // Test 3: Payment with both PV and FV
        let pmt3 = CalculationEngine.calculatePayment(
            presentValue: 5000,
            futureValue: 10000,
            interestRate: 5,
            numberOfPeriods: 60
        )
        #expect(abs(pmt3 - (-241.10)) < 0.01)
        
        // Test 4: Zero interest rate
        let pmt4 = CalculationEngine.calculatePayment(
            presentValue: 10000,
            interestRate: 0,
            numberOfPeriods: 60
        )
        #expect(abs(pmt4 - (-166.67)) < 0.01)
    }
    
    @Test("Interest Rate calculations should converge")
    func testInterestRate() {
        // Test 1: Simple loan rate calculation
        let rate1 = CalculationEngine.calculateInterestRate(
            presentValue: 10000,
            payment: -200,
            numberOfPeriods: 60
        )
        #expect(abs(rate1 - 7.42) < 0.1)
        
        // Test 2: Investment rate calculation
        let rate2 = CalculationEngine.calculateInterestRate(
            presentValue: -1000,
            futureValue: 2000,
            numberOfPeriods: 10
        )
        #expect(abs(rate2 - 7.18) < 0.1)
    }
    
    @Test("Number of Periods calculations should be accurate")
    func testNumberOfPeriods() {
        // Test 1: Simple compound interest periods
        let n1 = CalculationEngine.calculateNumberOfPeriods(
            presentValue: 1000,
            futureValue: 2000,
            interestRate: 7
        )
        #expect(abs(n1 - 10.24) < 0.01)
        
        // Test 2: Loan periods with payment
        let n2 = CalculationEngine.calculateNumberOfPeriods(
            presentValue: 10000,
            payment: -200,
            interestRate: 5
        )
        #expect(abs(n2 - 69.66) < 0.1)
        
        // Test 3: Annuity periods to reach target
        let n3 = CalculationEngine.calculateNumberOfPeriods(
            futureValue: 10000,
            payment: -100,
            interestRate: 5
        )
        #expect(abs(n3 - 69.90) < 0.1)
    }
    
    // MARK: - Loan Calculation Tests
    
    @Test("Loan payment calculations should be accurate")
    func testLoanPayment() {
        // Test 1: Standard mortgage payment
        let payment1 = CalculationEngine.calculateLoanPayment(
            principal: 200000,
            interestRate: 4.5,
            numberOfPayments: 360
        )
        #expect(abs(payment1 - 1013.37) < 0.01)
        
        // Test 2: Auto loan payment
        let payment2 = CalculationEngine.calculateLoanPayment(
            principal: 25000,
            interestRate: 3.9,
            numberOfPayments: 60
        )
        #expect(abs(payment2 - 459.29) < 0.01)
        
        // Test 3: Zero interest loan
        let payment3 = CalculationEngine.calculateLoanPayment(
            principal: 10000,
            interestRate: 0,
            numberOfPayments: 12
        )
        #expect(abs(payment3 - 833.33) < 0.01)
    }
    
    @Test("Remaining balance calculations should be accurate")
    func testRemainingBalance() {
        // Test: Remaining balance after 5 years on a 30-year mortgage
        let balance = CalculationEngine.calculateRemainingBalance(
            principal: 200000,
            interestRate: 4.5,
            totalPayments: 360,
            paymentsMade: 60
        )
        #expect(abs(balance - 178433.56) < 1.0)
    }
    
    // MARK: - Investment Analysis Tests
    
    @Test("NPV calculations should be accurate")
    func testNPV() {
        // Test 1: Simple NPV calculation
        let cashFlows1 = [-1000.0, 300.0, 300.0, 300.0, 300.0, 300.0]
        let npv1 = CalculationEngine.calculateNPV(
            cashFlows: cashFlows1,
            discountRate: 10
        )
        #expect(abs(npv1 - 137.24) < 0.01)
        
        // Test 2: NPV with varying cash flows
        let cashFlows2 = [-5000.0, 1000.0, 1500.0, 2000.0, 2500.0, 1000.0]
        let npv2 = CalculationEngine.calculateNPV(
            cashFlows: cashFlows2,
            discountRate: 8
        )
        #expect(abs(npv2 - 1447.85) < 0.01)
    }
    
    @Test("IRR calculations should converge")
    func testIRR() {
        // Test 1: Simple IRR calculation
        let cashFlows1 = [-1000.0, 300.0, 300.0, 300.0, 300.0, 300.0]
        let irr1 = CalculationEngine.calculateIRR(cashFlows: cashFlows1)
        #expect(abs(irr1 - 15.24) < 0.1)
        
        // Test 2: IRR with varying cash flows
        let cashFlows2 = [-5000.0, 1000.0, 1500.0, 2000.0, 2500.0, 1000.0]
        let irr2 = CalculationEngine.calculateIRR(cashFlows: cashFlows2)
        #expect(abs(irr2 - 17.29) < 0.1)
        
        // Test 3: IRR with no positive return
        let cashFlows3 = [-1000.0, 100.0, 100.0, 100.0]
        let irr3 = CalculationEngine.calculateIRR(cashFlows: cashFlows3)
        #expect(irr3 < 0)
    }
    
    // MARK: - Bond Calculation Tests
    
    @Test("Bond price calculations should be accurate")
    func testBondPrice() {
        // Test 1: Standard bond pricing
        let price1 = CalculationEngine.calculateBondPrice(
            faceValue: 1000,
            couponRate: 5,
            marketRate: 4,
            yearsToMaturity: 10,
            paymentsPerYear: 2
        )
        #expect(abs(price1 - 1081.10) < 0.01)
        
        // Test 2: Discount bond
        let price2 = CalculationEngine.calculateBondPrice(
            faceValue: 1000,
            couponRate: 3,
            marketRate: 5,
            yearsToMaturity: 5,
            paymentsPerYear: 2
        )
        #expect(abs(price2 - 913.06) < 0.01)
    }
    
    @Test("Bond YTM calculations should converge")
    func testBondYTM() {
        // Test: Calculate YTM for a bond trading at a premium
        let ytm = CalculationEngine.calculateBondYTM(
            faceValue: 1000,
            currentPrice: 1100,
            couponRate: 6,
            yearsToMaturity: 10,
            paymentsPerYear: 2
        )
        #expect(abs(ytm - 4.56) < 0.1)
    }
    
    // MARK: - Duration and Convexity Tests
    
    @Test("Duration calculations should be accurate")
    func testDuration() {
        // Test: Modified duration calculation
        let modDuration = CalculationEngine.calculateModifiedDuration(
            faceValue: 1000,
            couponRate: 5,
            marketRate: 4,
            yearsToMaturity: 10,
            paymentsPerYear: 2
        )
        #expect(abs(modDuration - 7.98) < 0.1)
        
        // Test: Macaulay duration
        let macDuration = CalculationEngine.calculateMacaulayDuration(
            faceValue: 1000,
            couponRate: 5,
            marketRate: 4,
            yearsToMaturity: 10,
            paymentsPerYear: 2
        )
        #expect(abs(macDuration - 8.14) < 0.1)
    }
    
    @Test("Convexity calculations should be positive")
    func testConvexity() {
        let convexity = CalculationEngine.calculateConvexity(
            faceValue: 1000,
            couponRate: 5,
            marketRate: 4,
            yearsToMaturity: 10,
            paymentsPerYear: 2
        )
        #expect(convexity > 0)
        #expect(abs(convexity - 75.72) < 1.0)
    }
    
    // MARK: - Statistical Tests
    
    @Test("Standard deviation calculations should be accurate")
    func testStandardDeviation() {
        let returns = [0.05, 0.10, -0.02, 0.08, 0.03, -0.01, 0.12]
        let stdDev = CalculationEngine.calculateStandardDeviation(returns)
        #expect(abs(stdDev - 0.0536) < 0.001)
    }
    
    @Test("Sharpe ratio calculations should be meaningful")
    func testSharpeRatio() {
        let returns = [0.12, 0.08, 0.15, 0.05, 0.10] // Annual returns
        let riskFreeRate = 2.0 // 2% risk-free rate
        let sharpe = CalculationEngine.calculateSharpeRatio(
            returns: returns,
            riskFreeRate: riskFreeRate
        )
        #expect(sharpe > 0)
        #expect(abs(sharpe - 1.625) < 0.1)
    }
}

// MARK: - Mathematical Bug Fix Tests

extension CalculationEngineTests {
    
    @Test("Forward rate calculation should use correct formula")
    func testForwardRateCalculation() {
        // The forward rate should be calculated using the formula:
        // f = [(1 + r2)^t2 / (1 + r1)^t1]^(1/(t2-t1)) - 1
        
        // Test case: 1-year spot rate = 3%, 2-year spot rate = 4%
        // Expected 1-year forward rate starting in 1 year ≈ 5.01%
        
        let yieldCurve = YieldCurveData()
        
        // We need to test the corrected formula in YieldCurveTypes.swift
        let forwardRate = yieldCurve.getForwardRate(from: 1, to: 2)
        
        // With corrected formula, this should be approximately 0.0501 (5.01%)
        #expect(abs(forwardRate - 0.0501) < 0.001)
    }
    
    @Test("Loan amortization should handle early payoff correctly")
    func testLoanAmortizationWithExtraPayments() {
        // This test verifies that the loan amortization loop terminates
        // when the balance reaches zero due to extra payments
        
        let loanCalc = LoanCalculation(
            name: "Test Loan",
            currency: .usd
        )
        loanCalc.principal = 10000
        loanCalc.interestRate = 5
        loanCalc.loanTerm = 5
        loanCalc.extraPayment = 500
        
        let schedule = loanCalc.calculateAmortization()
        
        // Verify that the schedule stops when balance hits zero
        let lastEntry = schedule.last!
        #expect(lastEntry.endingBalance <= 0.01)
        
        // Verify no negative balances
        for entry in schedule {
            #expect(entry.endingBalance >= -0.01)
        }
    }
    
    @Test("Time value chart should include payment streams")
    func testTimeValueChartWithPayments() {
        let tvCalc = TimeValueCalculation(
            name: "Test",
            paymentFrequency: .annual,
            solveFor: .futureValue
        )
        tvCalc.presentValue = 1000
        tvCalc.payment = 100
        tvCalc.annualInterestRate = 5
        tvCalc.numberOfYears = 10
        
        let result = tvCalc.result
        let chartData = result.chartData ?? []
        
        // The chart should show growth including both PV and payments
        #expect(!chartData.isEmpty)
        
        // Final value should include both compounded PV and annuity FV
        let finalValue = chartData.last?.y ?? 0
        let expectedFV = 1000 * pow(1.05, 10) + 100 * (pow(1.05, 10) - 1) / 0.05
        #expect(abs(finalValue - expectedFV) < 1.0)
    }
}

// MARK: - Edge Case Tests

extension CalculationEngineTests {
    
    @Test("Calculations should handle zero and negative inputs gracefully")
    func testEdgeCases() {
        // Zero interest rate
        let pv1 = CalculationEngine.calculatePresentValue(
            futureValue: 1000,
            interestRate: 0,
            numberOfPeriods: 10
        )
        #expect(pv1 == 1000)
        
        // Negative present value (investment)
        let fv1 = CalculationEngine.calculateFutureValue(
            presentValue: -1000,
            interestRate: 5,
            numberOfPeriods: 10
        )
        #expect(fv1 < 0)
        
        // Very small interest rate
        let pmt1 = CalculationEngine.calculatePayment(
            presentValue: 10000,
            interestRate: 0.01,
            numberOfPeriods: 12
        )
        #expect(abs(pmt1) > 0)
        #expect(abs(pmt1) < 10000)
    }
    
    @Test("IRR should handle edge cases")
    func testIRREdgeCases() {
        // All negative cash flows
        let cashFlows1 = [-1000.0, -100.0, -100.0, -100.0]
        let irr1 = CalculationEngine.calculateIRR(cashFlows: cashFlows1)
        #expect(irr1 == 0.0) // Should return 0 or indicate no solution
        
        // Single cash flow
        let cashFlows2 = [-1000.0]
        let irr2 = CalculationEngine.calculateIRR(cashFlows: cashFlows2)
        #expect(irr2 == 0.0)
        
        // Very high return
        let cashFlows3 = [-100.0, 5000.0]
        let irr3 = CalculationEngine.calculateIRR(cashFlows: cashFlows3)
        #expect(irr3 > 100)
    }
}
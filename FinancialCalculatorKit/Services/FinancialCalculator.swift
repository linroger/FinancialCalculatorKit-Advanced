import Foundation

struct FinancialCalculator {
    static func futureValue(presentValue: Double, interestRate: Double, periods: Int) -> Double {
        pow(1 + interestRate, Double(periods)) * presentValue
    }

    static func futureValueSeries(presentValue: Double, interestRate: Double, periods: Int) -> [(period: Int, value: Double)] {
        (0...periods).map { period in
            (period, futureValue(presentValue: presentValue, interestRate: interestRate, periods: period))
        }
    }
}

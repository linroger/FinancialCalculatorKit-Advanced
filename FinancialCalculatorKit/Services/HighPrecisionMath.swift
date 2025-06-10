//
//  HighPrecisionMath.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  High-precision arithmetic system for financial calculations
//

import Foundation

/// High-precision arithmetic system for financial-grade calculations
public class HighPrecisionMath {
    
    // MARK: - Configuration
    
    /// Precision modes for calculations
    public enum PrecisionMode {
        case standard       // Standard Double precision
        case high           // Decimal precision (28-29 significant digits)
        case ultrahigh      // Custom extended precision
    }
    
    /// Rounding modes for financial calculations
    public enum RoundingMode {
        case bankers       // Banker's rounding (round half to even)
        case awayFromZero  // Round half away from zero
        case up            // Always round up
        case down          // Always round down
        case plain         // Standard rounding
    }
    
    /// Global precision configuration
    nonisolated(unsafe) public static var defaultPrecisionMode: PrecisionMode = .high
    nonisolated(unsafe) public static var defaultRoundingMode: RoundingMode = .bankers
    nonisolated(unsafe) public static var defaultDecimalPlaces: Int = 12
    
    // MARK: - FinancialDecimal Wrapper
    
    /// Enhanced Decimal wrapper for financial calculations
    public struct FinancialDecimal: Comparable, Equatable {
        private let value: Decimal
        public let precision: Int
        
        // MARK: - Initialization
        
        public init(_ value: Decimal, precision: Int = HighPrecisionMath.defaultDecimalPlaces) {
            self.value = value
            self.precision = precision
        }
        
        public init(_ value: Double, precision: Int = HighPrecisionMath.defaultDecimalPlaces) {
            self.value = Decimal(value)
            self.precision = precision
        }
        
        public init(_ value: Int, precision: Int = HighPrecisionMath.defaultDecimalPlaces) {
            self.value = Decimal(value)
            self.precision = precision
        }
        
        public init(_ value: String, precision: Int = HighPrecisionMath.defaultDecimalPlaces) {
            self.value = Decimal(string: value) ?? Decimal.zero
            self.precision = precision
        }
        
        // MARK: - Properties
        
        public var decimalValue: Decimal {
            return value
        }
        
        public var doubleValue: Double {
            return NSDecimalNumber(decimal: value).doubleValue
        }
        
        public var isZero: Bool {
            return value.isZero
        }
        
        public var isNaN: Bool {
            return value.isNaN
        }
        
        public var isFinite: Bool {
            return value.isFinite
        }
        
        public var sign: FloatingPointSign {
            return value.sign
        }
        
        // MARK: - Arithmetic Operations
        
        public static func + (lhs: FinancialDecimal, rhs: FinancialDecimal) -> FinancialDecimal {
            let result = lhs.value + rhs.value
            return FinancialDecimal(result, precision: max(lhs.precision, rhs.precision))
        }
        
        public static func - (lhs: FinancialDecimal, rhs: FinancialDecimal) -> FinancialDecimal {
            let result = lhs.value - rhs.value
            return FinancialDecimal(result, precision: max(lhs.precision, rhs.precision))
        }
        
        public static func * (lhs: FinancialDecimal, rhs: FinancialDecimal) -> FinancialDecimal {
            let result = lhs.value * rhs.value
            return FinancialDecimal(result, precision: max(lhs.precision, rhs.precision))
        }
        
        public static func / (lhs: FinancialDecimal, rhs: FinancialDecimal) -> FinancialDecimal {
            guard !rhs.value.isZero else {
                return FinancialDecimal(Decimal.nan, precision: max(lhs.precision, rhs.precision))
            }
            let result = lhs.value / rhs.value
            return FinancialDecimal(result, precision: max(lhs.precision, rhs.precision))
        }
        
        // MARK: - Comparison Operations
        
        public static func == (lhs: FinancialDecimal, rhs: FinancialDecimal) -> Bool {
            return lhs.value == rhs.value
        }
        
        public static func < (lhs: FinancialDecimal, rhs: FinancialDecimal) -> Bool {
            return lhs.value < rhs.value
        }
        
        public static func <= (lhs: FinancialDecimal, rhs: FinancialDecimal) -> Bool {
            return lhs.value <= rhs.value
        }
        
        public static func > (lhs: FinancialDecimal, rhs: FinancialDecimal) -> Bool {
            return lhs.value > rhs.value
        }
        
        public static func >= (lhs: FinancialDecimal, rhs: FinancialDecimal) -> Bool {
            return lhs.value >= rhs.value
        }
        
        // MARK: - Rounding Functions
        
        public func rounded(to places: Int? = nil, mode: RoundingMode = HighPrecisionMath.defaultRoundingMode) -> FinancialDecimal {
            let targetPlaces = places ?? precision
            let multiplier = FinancialDecimal(pow(10.0, Double(targetPlaces)))
            let scaled = self * multiplier
            
            let roundedValue: Decimal
            switch mode {
            case .bankers:
                roundedValue = HighPrecisionMath.bankersRound(scaled.value)
            case .awayFromZero:
                roundedValue = HighPrecisionMath.roundAwayFromZero(scaled.value)
            case .up:
                roundedValue = HighPrecisionMath.roundUp(scaled.value)
            case .down:
                roundedValue = HighPrecisionMath.roundDown(scaled.value)
            case .plain:
                roundedValue = HighPrecisionMath.plainRound(scaled.value)
            }
            
            return FinancialDecimal(roundedValue, precision: targetPlaces) / multiplier
        }
        
        // MARK: - Mathematical Functions
        
        public func power(_ exponent: FinancialDecimal) -> FinancialDecimal {
            return HighPrecisionMath.power(self, exponent)
        }
        
        public func sqrt() -> FinancialDecimal {
            return HighPrecisionMath.sqrt(self)
        }
        
        public func log() -> FinancialDecimal {
            return HighPrecisionMath.log(self)
        }
        
        public func exp() -> FinancialDecimal {
            return HighPrecisionMath.exp(self)
        }
        
        // MARK: - String Representation
        
        public func formatted(decimalPlaces: Int? = nil) -> String {
            let places = decimalPlaces ?? precision
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = places
            formatter.maximumFractionDigits = places
            formatter.roundingMode = .halfEven
            
            return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0"
        }
        
        public func currencyFormatted(currencyCode: String = "USD", decimalPlaces: Int? = nil) -> String {
            let places = decimalPlaces ?? min(precision, 2) // Currency typically uses 2 decimal places
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = currencyCode
            formatter.minimumFractionDigits = places
            formatter.maximumFractionDigits = places
            formatter.roundingMode = .halfEven
            
            return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "$0.00"
        }
        
        public func percentageFormatted(decimalPlaces: Int? = nil) -> String {
            let places = decimalPlaces ?? min(precision, 4)
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.minimumFractionDigits = places
            formatter.maximumFractionDigits = places
            formatter.roundingMode = .halfEven
            
            return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0%"
        }
    }
    
    // MARK: - Rounding Functions
    
    /// Banker's rounding (round half to even)
    // MARK: - Rounding Functions

    /// Banker's rounding (round half to even)
    public static func bankersRound(_ value: Decimal) -> Decimal {
        var result = value
        var mutableValue = value
        NSDecimalRound(&result, &mutableValue, 0, .bankers)
        return result
    }

    /// Round half away from zero
    public static func roundAwayFromZero(_ value: Decimal) -> Decimal {
        var result = value
        var mutableValue = value
        NSDecimalRound(&result, &mutableValue, 0, .plain)
        return result
    }

    /// Always round up
    public static func roundUp(_ value: Decimal) -> Decimal {
        var result = value
        var mutableValue = value
        NSDecimalRound(&result, &mutableValue, 0, .up)
        return result
    }

    /// Always round down
    public static func roundDown(_ value: Decimal) -> Decimal {
        var result = value
        var mutableValue = value
        NSDecimalRound(&result, &mutableValue, 0, .down)
        return result
    }

    /// Standard rounding
    public static func plainRound(_ value: Decimal) -> Decimal {
        var result = value
        var mutableValue = value
        NSDecimalRound(&result, &mutableValue, 0, .plain)
        return result
    }
    // MARK: - Advanced Mathematical Functions
    
    /// High-precision power function
    public static func power(_ base: FinancialDecimal, _ exponent: FinancialDecimal) -> FinancialDecimal {
        // Use Double precision for complex calculations, then convert back
        let baseDouble = base.doubleValue
        let expDouble = exponent.doubleValue
        
        // Handle special cases
        if base.isZero && exponent.doubleValue > 0 {
            return FinancialDecimal(0, precision: base.precision)
        }
        
        if base.isZero && exponent.doubleValue <= 0 {
            return FinancialDecimal(Decimal.nan, precision: base.precision)
        }
        
        if exponent.isZero {
            return FinancialDecimal(1, precision: base.precision)
        }
        
        // For integer exponents, use repeated multiplication for better precision
        if floor(expDouble) == expDouble && abs(expDouble) <= 100 {
            return powerByRepeatedMultiplication(base, Int(expDouble))
        }
        
        // For non-integer exponents, use logarithmic approach
        let result = pow(baseDouble, expDouble)
        return FinancialDecimal(result, precision: base.precision)
    }
    
    /// Power by repeated multiplication for integer exponents
    private static func powerByRepeatedMultiplication(_ base: FinancialDecimal, _ exponent: Int) -> FinancialDecimal {
        if exponent == 0 {
            return FinancialDecimal(1, precision: base.precision)
        }
        
        if exponent == 1 {
            return base
        }
        
        if exponent < 0 {
            return FinancialDecimal(1, precision: base.precision) / powerByRepeatedMultiplication(base, -exponent)
        }
        
        var result = FinancialDecimal(1, precision: base.precision)
        var currentBase = base
        var currentExp = exponent
        
        while currentExp > 0 {
            if currentExp % 2 == 1 {
                result = result * currentBase
            }
            currentBase = currentBase * currentBase
            currentExp /= 2
        }
        
        return result
    }
    
    /// High-precision square root using Newton's method
    public static func sqrt(_ value: FinancialDecimal) -> FinancialDecimal {
        if value < FinancialDecimal(0) {
            return FinancialDecimal(Decimal.nan, precision: value.precision)
        }
        
        if value.isZero {
            return FinancialDecimal(0, precision: value.precision)
        }
        
        // Use Newton's method for high precision
        var x = FinancialDecimal(value.doubleValue.squareRoot(), precision: value.precision)
        let tolerance = FinancialDecimal(pow(10.0, Double(-value.precision)), precision: value.precision)
        
        for _ in 0..<50 { // Maximum iterations
            let nextX = (x + value / x) / FinancialDecimal(2, precision: value.precision)
            if abs((nextX - x).doubleValue) < tolerance.doubleValue {
                return nextX
            }
            x = nextX
        }
        
        return x
    }
    
    /// High-precision natural logarithm
    public static func log(_ value: FinancialDecimal) -> FinancialDecimal {
        if value <= FinancialDecimal(0) {
            return FinancialDecimal(Decimal.nan, precision: value.precision)
        }
        
        // Use Double precision for now, could be improved with series expansion
        let result = Foundation.log(value.doubleValue)
        return FinancialDecimal(result, precision: value.precision)
    }
    
    /// High-precision exponential function
    public static func exp(_ value: FinancialDecimal) -> FinancialDecimal {
        // Use Double precision for now, could be improved with series expansion
        let result = Foundation.exp(value.doubleValue)
        return FinancialDecimal(result, precision: value.precision)
    }
    
    // MARK: - Financial Calculations
    
    /// High-precision compound interest calculation
    public static func compoundInterest(
        principal: FinancialDecimal,
        rate: FinancialDecimal,
        compoundingFrequency: FinancialDecimal,
        years: FinancialDecimal
    ) -> FinancialDecimal {
        // A = P(1 + r/n)^(nt)
        let ratePerPeriod = rate / (FinancialDecimal(100) * compoundingFrequency)
        let totalPeriods = compoundingFrequency * years
        let onePlusRate = FinancialDecimal(1) + ratePerPeriod
        
        return principal * onePlusRate.power(totalPeriods)
    }
    
    /// High-precision present value calculation
    public static func presentValue(
        futureValue: FinancialDecimal,
        rate: FinancialDecimal,
        periods: FinancialDecimal
    ) -> FinancialDecimal {
        // PV = FV / (1 + r)^n
        let onePlusRate = FinancialDecimal(1) + rate / FinancialDecimal(100)
        return futureValue / onePlusRate.power(periods)
    }
    
    /// High-precision future value calculation
    public static func futureValue(
        presentValue: FinancialDecimal,
        rate: FinancialDecimal,
        periods: FinancialDecimal
    ) -> FinancialDecimal {
        // FV = PV * (1 + r)^n
        let onePlusRate = FinancialDecimal(1) + rate / FinancialDecimal(100)
        return presentValue * onePlusRate.power(periods)
    }
    
    /// High-precision annuity present value
    public static func annuityPresentValue(
        payment: FinancialDecimal,
        rate: FinancialDecimal,
        periods: FinancialDecimal
    ) -> FinancialDecimal {
        // PV = PMT * [(1 - (1 + r)^-n) / r]
        let rateDecimal = rate / FinancialDecimal(100)
        let onePlusRate = FinancialDecimal(1) + rateDecimal
        let discount = FinancialDecimal(1) / onePlusRate.power(periods)
        
        return payment * (FinancialDecimal(1) - discount) / rateDecimal
    }
    
    /// High-precision annuity future value
    public static func annuityFutureValue(
        payment: FinancialDecimal,
        rate: FinancialDecimal,
        periods: FinancialDecimal
    ) -> FinancialDecimal {
        // FV = PMT * [((1 + r)^n - 1) / r]
        let rateDecimal = rate / FinancialDecimal(100)
        let onePlusRate = FinancialDecimal(1) + rateDecimal
        let compound = onePlusRate.power(periods)
        
        return payment * (compound - FinancialDecimal(1)) / rateDecimal
    }
    
    /// High-precision NPV calculation
    public static func netPresentValue(
        cashFlows: [FinancialDecimal],
        discountRate: FinancialDecimal
    ) -> FinancialDecimal {
        var npv = FinancialDecimal(0)
        let rateDecimal = discountRate / FinancialDecimal(100)
        let onePlusRate = FinancialDecimal(1) + rateDecimal
        
        for (index, cashFlow) in cashFlows.enumerated() {
            let period = FinancialDecimal(index)
            let discountFactor = onePlusRate.power(period)
            npv = npv + cashFlow / discountFactor
        }
        
        return npv
    }
    
    /// High-precision IRR calculation using Newton-Raphson method
    public static func internalRateOfReturn(
        cashFlows: [FinancialDecimal],
        initialGuess: FinancialDecimal = FinancialDecimal(0.1),
        tolerance: FinancialDecimal = FinancialDecimal(0.00001),
        maxIterations: Int = 100
    ) -> FinancialDecimal {
        var rate = initialGuess
        
        for _ in 0..<maxIterations {
            let npv = netPresentValue(cashFlows: cashFlows, discountRate: rate * FinancialDecimal(100))
            let npvDerivative = calculateNPVDerivative(cashFlows: cashFlows, rate: rate)
            
            if abs(npv.doubleValue) < tolerance.doubleValue {
                return rate
            }
            
            if npvDerivative.isZero {
                break
            }
            
            rate = rate - npv / npvDerivative
        }
        
        return rate
    }
    
    /// Calculate NPV derivative for IRR calculation
    private static func calculateNPVDerivative(cashFlows: [FinancialDecimal], rate: FinancialDecimal) -> FinancialDecimal {
        var derivative = FinancialDecimal(0)
        let onePlusRate = FinancialDecimal(1) + rate
        
        for (index, cashFlow) in cashFlows.enumerated() {
            let period = FinancialDecimal(index)
            let discountFactor = onePlusRate.power(period + FinancialDecimal(1))
            derivative = derivative - cashFlow * period / discountFactor
        }
        
        return derivative
    }
    
    /// High-precision bond price calculation
    public static func bondPrice(
        faceValue: FinancialDecimal,
        couponRate: FinancialDecimal,
        marketRate: FinancialDecimal,
        yearsToMaturity: FinancialDecimal,
        paymentsPerYear: FinancialDecimal = FinancialDecimal(2)
    ) -> FinancialDecimal {
        let periodicCoupon = faceValue * couponRate / FinancialDecimal(100) / paymentsPerYear
        let periodicRate = marketRate / FinancialDecimal(100) / paymentsPerYear
        let totalPeriods = yearsToMaturity * paymentsPerYear
        
        // Present value of coupon payments
        let couponPV = annuityPresentValue(
            payment: periodicCoupon,
            rate: periodicRate * FinancialDecimal(100),
            periods: totalPeriods
        )
        
        // Present value of face value
        let facePV = presentValue(
            futureValue: faceValue,
            rate: periodicRate * FinancialDecimal(100),
            periods: totalPeriods
        )
        
        return couponPV + facePV
    }
    
    // MARK: - Utility Functions
    
    /// Convert Double to FinancialDecimal with default precision
    public static func decimal(_ value: Double) -> FinancialDecimal {
        return FinancialDecimal(value, precision: defaultDecimalPlaces)
    }
    
    /// Convert array of Doubles to FinancialDecimals
    public static func decimals(_ values: [Double]) -> [FinancialDecimal] {
        return values.map { FinancialDecimal($0, precision: defaultDecimalPlaces) }
    }
    
    /// Performance comparison between standard and high-precision calculations
    public static func benchmarkCalculation<T>(
        name: String,
        standardCalculation: () -> T,
        highPrecisionCalculation: () -> T
    ) -> (standardResult: T, highPrecisionResult: T, standardTime: TimeInterval, highPrecisionTime: TimeInterval) {
        
        let standardStart = CFAbsoluteTimeGetCurrent()
        let standardResult = standardCalculation()
        let standardTime = CFAbsoluteTimeGetCurrent() - standardStart
        
        let highPrecisionStart = CFAbsoluteTimeGetCurrent()
        let highPrecisionResult = highPrecisionCalculation()
        let highPrecisionTime = CFAbsoluteTimeGetCurrent() - highPrecisionStart
        
        return (standardResult, highPrecisionResult, standardTime, highPrecisionTime)
    }
    
    /// Validate calculation accuracy by comparing with known results
    public static func validateCalculation(
        calculated: FinancialDecimal,
        expected: FinancialDecimal,
        tolerance: FinancialDecimal = FinancialDecimal(0.00001)
    ) -> Bool {
        let difference = abs((calculated - expected).doubleValue)
        return difference < tolerance.doubleValue
    }
}

// MARK: - Extensions


extension HighPrecisionMath.FinancialDecimal: CustomStringConvertible {
    public var description: String {
        return formatted()
    }
}

extension HighPrecisionMath.FinancialDecimal: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

extension HighPrecisionMath.FinancialDecimal: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

// MARK: - Convenience Functions

/// Global convenience function for creating FinancialDecimal
public func financial(_ value: Double, precision: Int = HighPrecisionMath.defaultDecimalPlaces) -> HighPrecisionMath.FinancialDecimal {
    return HighPrecisionMath.FinancialDecimal(value, precision: precision)
}

/// Global convenience function for creating FinancialDecimal from String
public func financial(_ value: String, precision: Int = HighPrecisionMath.defaultDecimalPlaces) -> HighPrecisionMath.FinancialDecimal {
    return HighPrecisionMath.FinancialDecimal(value, precision: precision)
}

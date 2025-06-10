//
//  AdvancedMathFunctions.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation

/// Advanced mathematical functions library
class AdvancedMathFunctions {
    
    // MARK: - Trigonometric Functions
    
    /// Secant function
    static func sec(_ x: Double) -> Double {
        return 1.0 / cos(x)
    }
    
    /// Cosecant function
    static func csc(_ x: Double) -> Double {
        return 1.0 / sin(x)
    }
    
    /// Cotangent function
    static func cot(_ x: Double) -> Double {
        return 1.0 / tan(x)
    }
    
    /// Inverse secant function
    static func asec(_ x: Double) -> Double {
        return acos(1.0 / x)
    }
    
    /// Inverse cosecant function
    static func acsc(_ x: Double) -> Double {
        return asin(1.0 / x)
    }
    
    /// Inverse cotangent function
    static func acot(_ x: Double) -> Double {
        return atan(1.0 / x)
    }
    
    // MARK: - Hyperbolic Functions
    
    /// Hyperbolic sine
    static func sinh(_ x: Double) -> Double {
        return (exp(x) - exp(-x)) / 2.0
    }
    
    /// Hyperbolic cosine
    static func cosh(_ x: Double) -> Double {
        return (exp(x) + exp(-x)) / 2.0
    }
    
    /// Hyperbolic tangent
    static func tanh(_ x: Double) -> Double {
        return sinh(x) / cosh(x)
    }
    
    /// Hyperbolic secant
    static func sech(_ x: Double) -> Double {
        return 1.0 / cosh(x)
    }
    
    /// Hyperbolic cosecant
    static func csch(_ x: Double) -> Double {
        return 1.0 / sinh(x)
    }
    
    /// Hyperbolic cotangent
    static func coth(_ x: Double) -> Double {
        return cosh(x) / sinh(x)
    }
    
    /// Inverse hyperbolic sine
    static func asinh(_ x: Double) -> Double {
        return log(x + sqrt(x * x + 1))
    }
    
    /// Inverse hyperbolic cosine
    static func acosh(_ x: Double) -> Double {
        return log(x + sqrt(x * x - 1))
    }
    
    /// Inverse hyperbolic tangent
    static func atanh(_ x: Double) -> Double {
        return 0.5 * log((1 + x) / (1 - x))
    }
    
    /// Inverse hyperbolic secant
    static func asech(_ x: Double) -> Double {
        return acosh(1.0 / x)
    }
    
    /// Inverse hyperbolic cosecant
    static func acsch(_ x: Double) -> Double {
        return asinh(1.0 / x)
    }
    
    /// Inverse hyperbolic cotangent
    static func acoth(_ x: Double) -> Double {
        return atanh(1.0 / x)
    }
    
    // MARK: - Logarithmic Functions
    
    /// Logarithm base 2
    static func log2(_ x: Double) -> Double {
        return log(x) / log(2.0)
    }
    
    /// Logarithm base 10
    static func log10(_ x: Double) -> Double {
        return log(x) / log(10.0)
    }
    
    /// Logarithm with custom base
    static func logBase(_ x: Double, base: Double) -> Double {
        return log(x) / log(base)
    }
    
    // MARK: - Exponential Functions
    
    /// Exponential base 2
    static func exp2(_ x: Double) -> Double {
        return pow(2.0, x)
    }
    
    /// Exponential base 10
    static func exp10(_ x: Double) -> Double {
        return pow(10.0, x)
    }
    
    // MARK: - Root Functions
    
    /// Cube root
    static func cbrt(_ x: Double) -> Double {
        return copysign(pow(abs(x), 1.0/3.0), x)
    }
    
    /// nth root
    static func nthRoot(_ x: Double, n: Double) -> Double {
        if n == 0 { return Double.nan }
        if x < 0 && n.remainder(dividingBy: 2) == 0 {
            return Double.nan // Even root of negative number
        }
        return copysign(pow(abs(x), 1.0/n), x)
    }
    
    // MARK: - Factorial and Combinatorics
    
    /// Factorial function
    static func factorial(_ n: Double) -> Double {
        let intN = Int(n)
        if n != Double(intN) || n < 0 { return Double.nan }
        if intN > 170 { return Double.infinity } // Overflow protection
        
        var result = 1.0
        for i in 2...intN {
            result *= Double(i)
        }
        return result
    }
    
    /// Gamma function (extension of factorial to real numbers)
    static func gamma(_ x: Double) -> Double {
        // Lanczos approximation
        let g = 7.0
        let c = [0.99999999999980993,
                 676.5203681218851,
                 -1259.1392167224028,
                 771.32342877765313,
                 -176.61502916214059,
                 12.507343278686905,
                 -0.13857109526572012,
                 9.9843695780195716e-6,
                 1.5056327351493116e-7]
        
        if x < 0.5 {
            return .pi / (sin(.pi * x) * gamma(1 - x))
        }
        
        let z = x - 1
        var x = c[0]
        for i in 1..<c.count {
            x += c[i] / (z + Double(i))
        }
        
        let t = z + g + 0.5
        let sqrt2pi = sqrt(2 * .pi)
        
        return sqrt2pi * pow(t, z + 0.5) * exp(-t) * x
    }
    
    /// Binomial coefficient (n choose k)
    static func binomial(_ n: Double, _ k: Double) -> Double {
        if k < 0 || k > n { return 0 }
        if k == 0 || k == n { return 1 }
        
        let intN = Int(n)
        let intK = Int(k)
        
        if n != Double(intN) || k != Double(intK) {
            // Use gamma function for non-integer values
            return gamma(n + 1) / (gamma(k + 1) * gamma(n - k + 1))
        }
        
        // Optimize for integers
        let k = min(intK, intN - intK)
        var result = 1.0
        
        for i in 0..<k {
            result = result * Double(intN - i) / Double(i + 1)
        }
        
        return result
    }
    
    /// Permutation (nPr)
    static func permutation(_ n: Double, _ r: Double) -> Double {
        if r < 0 || r > n { return 0 }
        return gamma(n + 1) / gamma(n - r + 1)
    }
    
    // MARK: - Statistical Functions
    
    /// Greatest common divisor
    static func gcd(_ a: Double, _ b: Double) -> Double {
        let intA = Int(abs(a))
        let intB = Int(abs(b))
        
        func euclideanGCD(_ a: Int, _ b: Int) -> Int {
            return b == 0 ? a : euclideanGCD(b, a % b)
        }
        
        return Double(euclideanGCD(intA, intB))
    }
    
    /// Least common multiple
    static func lcm(_ a: Double, _ b: Double) -> Double {
        return abs(a * b) / gcd(a, b)
    }
    
    /// Random number between 0 and 1
    static func random() -> Double {
        return Double.random(in: 0...1)
    }
    
    /// Random integer between min and max (inclusive)
    static func randomInt(min: Int = 0, max: Int = 100) -> Double {
        return Double(Int.random(in: min...max))
    }
    
    // MARK: - Number Theory Functions
    
    /// Check if number is prime
    static func isPrime(_ n: Double) -> Bool {
        let intN = Int(n)
        if n != Double(intN) || intN < 2 { return false }
        if intN == 2 { return true }
        if intN % 2 == 0 { return false }
        
        let limit = Int(sqrt(Double(intN)))
        for i in stride(from: 3, through: limit, by: 2) {
            if intN % i == 0 { return false }
        }
        return true
    }
    
    /// Sum of digits
    static func digitSum(_ n: Double) -> Double {
        let intN = Int(abs(n))
        var sum = 0
        var num = intN
        
        while num > 0 {
            sum += num % 10
            num /= 10
        }
        
        return Double(sum)
    }
    
    // MARK: - Complex Number Utilities
    
    /// Real part of a complex number (identity for real numbers)
    static func real(_ x: Double) -> Double {
        return x
    }
    
    /// Imaginary part (always 0 for real numbers)
    static func imaginary(_ x: Double) -> Double {
        return 0.0
    }
    
    // MARK: - Special Functions
    
    /// Error function
    static func erf(_ x: Double) -> Double {
        // Abramowitz and Stegun approximation
        let a1 =  0.254829592
        let a2 = -0.284496736
        let a3 =  1.421413741
        let a4 = -1.453152027
        let a5 =  1.061405429
        let p  =  0.3275911
        
        let sign = x < 0 ? -1.0 : 1.0
        let x = abs(x)
        
        let t = 1.0 / (1.0 + p * x)
        let y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x)
        
        return sign * y
    }
    
    /// Complementary error function
    static func erfc(_ x: Double) -> Double {
        return 1.0 - erf(x)
    }
    
    /// Beta function
    static func beta(_ x: Double, _ y: Double) -> Double {
        return gamma(x) * gamma(y) / gamma(x + y)
    }
    
    // MARK: - Utility Functions
    
    /// Sign function
    static func sign(_ x: Double) -> Double {
        if x > 0 { return 1.0 }
        if x < 0 { return -1.0 }
        return 0.0
    }
    
    /// Step function (Heaviside)
    static func step(_ x: Double) -> Double {
        return x >= 0 ? 1.0 : 0.0
    }
    
    /// Clamp function
    static func clamp(_ x: Double, min: Double, max: Double) -> Double {
        return Swift.min(Swift.max(x, min), max)
    }
    
    /// Linear interpolation
    static func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        return a + t * (b - a)
    }
    
    // MARK: - Summation and Product Functions
    
    /// Sum of arithmetic sequence
    static func arithmeticSum(first: Double, last: Double, count: Double) -> Double {
        return count * (first + last) / 2.0
    }
    
    /// Sum of geometric sequence
    static func geometricSum(first: Double, ratio: Double, count: Double) -> Double {
        if abs(ratio - 1.0) < 1e-15 {
            return first * count
        }
        return first * (1 - pow(ratio, count)) / (1 - ratio)
    }
    
    /// Product of arithmetic sequence
    static func arithmeticProduct(first: Double, last: Double, count: Double) -> Double {
        if count <= 0 { return 1.0 }
        let intCount = Int(count)
        let diff = (last - first) / (count - 1)
        
        var product = 1.0
        for i in 0..<intCount {
            product *= first + Double(i) * diff
        }
        return product
    }
    
    // MARK: - Function Registration
    
    /// Get all available function names
    static func getAllFunctionNames() -> [String] {
        return [
            // Trigonometric
            "sec", "csc", "cot", "asec", "acsc", "acot",
            // Hyperbolic
            "sinh", "cosh", "tanh", "sech", "csch", "coth",
            "asinh", "acosh", "atanh", "asech", "acsch", "acoth",
            // Logarithmic
            "log2", "log10", "logbase",
            // Exponential
            "exp2", "exp10",
            // Root functions
            "cbrt", "nthroot",
            // Factorial and combinatorics
            "factorial", "gamma", "binomial", "permutation",
            // Number theory
            "gcd", "lcm", "isprime", "digitsum",
            // Random
            "random", "randomint",
            // Complex utilities
            "real", "imaginary",
            // Special functions
            "erf", "erfc", "beta",
            // Utility
            "sign", "step", "clamp", "lerp",
            // Summation/product
            "arithmeticsum", "geometricsum", "arithmeticproduct"
        ]
    }
    
    /// Get function description
    static func getFunctionDescription(_ name: String) -> String {
        switch name.lowercased() {
        case "sec": return "Secant function: sec(x) = 1/cos(x)"
        case "csc": return "Cosecant function: csc(x) = 1/sin(x)"
        case "cot": return "Cotangent function: cot(x) = 1/tan(x)"
        case "asec": return "Inverse secant function"
        case "acsc": return "Inverse cosecant function"
        case "acot": return "Inverse cotangent function"
        case "sinh": return "Hyperbolic sine function"
        case "cosh": return "Hyperbolic cosine function"
        case "tanh": return "Hyperbolic tangent function"
        case "sech": return "Hyperbolic secant function"
        case "csch": return "Hyperbolic cosecant function"
        case "coth": return "Hyperbolic cotangent function"
        case "asinh": return "Inverse hyperbolic sine function"
        case "acosh": return "Inverse hyperbolic cosine function"
        case "atanh": return "Inverse hyperbolic tangent function"
        case "log2": return "Logarithm base 2"
        case "log10": return "Logarithm base 10"
        case "exp2": return "Exponential base 2: 2^x"
        case "exp10": return "Exponential base 10: 10^x"
        case "cbrt": return "Cube root function"
        case "factorial": return "Factorial function: n!"
        case "gamma": return "Gamma function: Γ(x)"
        case "binomial": return "Binomial coefficient: C(n,k)"
        case "permutation": return "Permutation: P(n,r)"
        case "gcd": return "Greatest common divisor"
        case "lcm": return "Least common multiple"
        case "random": return "Random number between 0 and 1"
        case "isprime": return "Check if number is prime"
        case "erf": return "Error function"
        case "erfc": return "Complementary error function"
        case "beta": return "Beta function"
        default: return "Advanced mathematical function"
        }
    }
}
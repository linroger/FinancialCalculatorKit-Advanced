//
//  YieldCurveTypes.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation

// MARK: - Shared Yield Curve Types

/// A point on the yield curve with maturity and associated rates
struct YieldCurvePoint: Identifiable, Codable {
    var id: UUID
    let maturity: Double
    let yield: Double
    let spotRate: Double
    let forwardRate: Double
    let discountFactor: Double

    init(id: UUID = UUID(), maturity: Double, yield: Double, spotRate: Double, forwardRate: Double, discountFactor: Double) {
        self.id = id
        self.maturity = maturity
        self.yield = yield
        self.spotRate = spotRate
        self.forwardRate = forwardRate
        self.discountFactor = discountFactor
    }
}

/// Type of yield curve
enum YieldCurveType: String, CaseIterable, Identifiable, Codable {
    case treasury = "treasury"
    case swap = "swap"
    case corporate = "corporate"
    case municipal = "municipal"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .treasury: return "Treasury Curve"
        case .swap: return "Swap Curve"
        case .corporate: return "Corporate Curve"
        case .municipal: return "Municipal Curve"
        }
    }
}

/// Interpolation method for yield curve
enum YieldCurveInterpolationMethod: String, CaseIterable, Identifiable, Codable {
    case linear = "linear"
    case cubic = "cubic"
    case nelson = "nelson"
    case svensson = "svensson"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .linear: return "Linear"
        case .cubic: return "Cubic Spline"
        case .nelson: return "Nelson-Siegel"
        case .svensson: return "Svensson"
        }
    }
}

/// Base protocol for yield curve functionality
protocol YieldCurveProtocol {
    var points: [YieldCurvePoint] { get }
    var curveType: YieldCurveType { get }
    var interpolationMethod: YieldCurveInterpolationMethod { get }
    
    func getYield(for maturity: Double) -> Double
    func getSpotRate(for maturity: Double) -> Double
    func getForwardRate(from t1: Double, to t2: Double) -> Double
}

// MARK: - Default Implementations

extension YieldCurveProtocol {
    func getYield(for maturity: Double) -> Double {
        guard !points.isEmpty else { return 0.05 }
        
        // Sort points once
        let sorted = points.sorted { $0.maturity < $1.maturity }
        
        // Handle edge cases
        if maturity <= sorted.first!.maturity {
            return sorted.first!.yield
        }
        
        if maturity >= sorted.last!.maturity {
            return sorted.last!.yield
        }
        
        // Interpolate based on selected method
        switch interpolationMethod {
        case .linear:
            return linearInterpolation(maturity: maturity, sortedPoints: sorted)
        case .cubic:
            return cubicSplineInterpolation(maturity: maturity, sortedPoints: sorted)
        case .nelson:
            return nelsonSiegelInterpolation(maturity: maturity, sortedPoints: sorted)
        case .svensson:
            return svenssonInterpolation(maturity: maturity, sortedPoints: sorted)
        }
    }
    
    private func linearInterpolation(maturity: Double, sortedPoints: [YieldCurvePoint]) -> Double {
        for i in 0..<(sortedPoints.count - 1) {
            let p1 = sortedPoints[i]
            let p2 = sortedPoints[i + 1]
            
            if maturity >= p1.maturity && maturity <= p2.maturity {
                let weight = (maturity - p1.maturity) / (p2.maturity - p1.maturity)
                return p1.yield + weight * (p2.yield - p1.yield)
            }
        }
        
        return 0.05 // Default fallback
    }
    
    func getSpotRate(for maturity: Double) -> Double {
        // Bootstrap spot rates from par yields
        return bootstrapSpotRate(maturity: maturity)
    }
    
    func getForwardRate(from t1: Double, to t2: Double) -> Double {
        guard t2 > t1 else { return 0.0 }
        
        let spot1 = getSpotRate(for: t1)
        let spot2 = getSpotRate(for: t2)
        
        // Correct forward rate formula: ((1 + r2)^t2 / (1 + r1)^t1)^(1/(t2-t1)) - 1
        let compoundFactor = pow(1 + spot2, t2) / pow(1 + spot1, t1)
        let forwardRate = pow(compoundFactor, 1.0 / (t2 - t1)) - 1
        
        return forwardRate
    }
}

// MARK: - Advanced Interpolation Methods

extension YieldCurveProtocol {
    
    // MARK: - Cubic Spline Interpolation
    
    private func cubicSplineInterpolation(maturity: Double, sortedPoints: [YieldCurvePoint]) -> Double {
        // Simplified cubic spline - for production use, implement full natural cubic spline
        let n = sortedPoints.count
        
        // Find the interval containing the maturity
        var i = 0
        for j in 0..<(n-1) {
            if maturity >= sortedPoints[j].maturity && maturity <= sortedPoints[j+1].maturity {
                i = j
                break
            }
        }
        
        if i == n - 1 { i = n - 2 }
        
        // Hermite cubic interpolation as approximation
        let x0 = sortedPoints[i].maturity
        let x1 = sortedPoints[i+1].maturity
        let y0 = sortedPoints[i].yield
        let y1 = sortedPoints[i+1].yield
        
        // Estimate derivatives using finite differences
        let m0: Double
        let m1: Double
        
        if i > 0 {
            m0 = (sortedPoints[i+1].yield - sortedPoints[i-1].yield) / 
                 (sortedPoints[i+1].maturity - sortedPoints[i-1].maturity)
        } else {
            m0 = (y1 - y0) / (x1 - x0)
        }
        
        if i < n - 2 {
            m1 = (sortedPoints[i+2].yield - sortedPoints[i].yield) / 
                 (sortedPoints[i+2].maturity - sortedPoints[i].maturity)
        } else {
            m1 = (y1 - y0) / (x1 - x0)
        }
        
        // Hermite basis functions
        let t = (maturity - x0) / (x1 - x0)
        let h00 = 2*t*t*t - 3*t*t + 1
        let h10 = t*t*t - 2*t*t + t
        let h01 = -2*t*t*t + 3*t*t
        let h11 = t*t*t - t*t
        
        return h00 * y0 + h10 * (x1 - x0) * m0 + h01 * y1 + h11 * (x1 - x0) * m1
    }
    
    // MARK: - Nelson-Siegel Model
    
    private func nelsonSiegelInterpolation(maturity: Double, sortedPoints: [YieldCurvePoint]) -> Double {
        // Nelson-Siegel model: y(m) = β0 + β1*(1-exp(-m/τ))/(m/τ) + β2*((1-exp(-m/τ))/(m/τ) - exp(-m/τ))
        
        // For simplicity, we'll fit using least squares approximation
        // In production, use proper optimization to fit parameters
        
        // Default parameters (these should be calibrated to the curve)
        let beta0 = 0.05  // Long-term rate
        let beta1 = -0.02 // Short-term component
        let beta2 = 0.01  // Medium-term component
        let tau = 2.0     // Decay parameter
        
        if maturity == 0 {
            return beta0 + beta1
        }
        
        let mOverTau = maturity / tau
        let expTerm = exp(-mOverTau)
        let factor1 = (1 - expTerm) / mOverTau
        let factor2 = factor1 - expTerm
        
        return beta0 + beta1 * factor1 + beta2 * factor2
    }
    
    // MARK: - Svensson Model
    
    private func svenssonInterpolation(maturity: Double, sortedPoints: [YieldCurvePoint]) -> Double {
        // Svensson model: Extended Nelson-Siegel with additional term
        // y(m) = β0 + β1*(1-exp(-m/τ1))/(m/τ1) + β2*((1-exp(-m/τ1))/(m/τ1) - exp(-m/τ1)) + β3*((1-exp(-m/τ2))/(m/τ2) - exp(-m/τ2))
        
        // Default parameters (these should be calibrated)
        let beta0 = 0.05  // Long-term rate
        let beta1 = -0.02 // Short-term component
        let beta2 = 0.01  // Medium-term component 1
        let beta3 = 0.005 // Medium-term component 2
        let tau1 = 2.0    // Decay parameter 1
        let tau2 = 5.0    // Decay parameter 2
        
        if maturity == 0 {
            return beta0 + beta1
        }
        
        let m1 = maturity / tau1
        let m2 = maturity / tau2
        let exp1 = exp(-m1)
        let exp2 = exp(-m2)
        
        let factor1 = (1 - exp1) / m1
        let factor2 = factor1 - exp1
        let factor3 = (1 - exp2) / m2 - exp2
        
        return beta0 + beta1 * factor1 + beta2 * factor2 + beta3 * factor3
    }
    
    // MARK: - Spot Rate Bootstrapping
    
    private func bootstrapSpotRate(maturity: Double) -> Double {
        guard !points.isEmpty else { return 0.05 }
        
        // Sort points by maturity
        let sorted = points.sorted { $0.maturity < $1.maturity }
        
        // For very short maturities, use the yield directly
        if maturity <= 0.5 {
            return getYield(for: maturity)
        }
        
        // Bootstrap spot rates iteratively
        var spotRates: [(maturity: Double, rate: Double)] = []
        
        // First point: spot rate equals yield for zero-coupon equivalent
        if let firstPoint = sorted.first {
            spotRates.append((maturity: firstPoint.maturity, rate: firstPoint.yield))
        }
        
        // Bootstrap subsequent spot rates
        for i in 1..<sorted.count {
            let currentPoint = sorted[i]
            if currentPoint.maturity <= maturity {
                let parYield = currentPoint.yield
                let T = currentPoint.maturity
                
                // Assuming semi-annual coupons
                let couponRate = parYield
                let periods = Int(T * 2)
                let couponPayment = couponRate / 2
                
                // Calculate PV of all coupon payments using previously bootstrapped spot rates
                var pvCoupons = 0.0
                for period in 1..<periods {
                    let t = Double(period) / 2.0
                    let spotForPeriod = interpolateSpotRate(at: t, from: spotRates)
                    pvCoupons += couponPayment / pow(1 + spotForPeriod, t)
                }
                
                // Solve for spot rate: 1 = pvCoupons + (1 + coupon/2) / (1 + spotRate)^T
                // (1 + spotRate)^T = (1 + coupon/2) / (1 - pvCoupons)
                let spotRate = pow((1 + couponPayment) / (1 - pvCoupons), 1.0/T) - 1
                
                spotRates.append((maturity: T, rate: spotRate))
            }
        }
        
        // Interpolate to get spot rate at requested maturity
        return interpolateSpotRate(at: maturity, from: spotRates)
    }
    
    private func interpolateSpotRate(at maturity: Double, from spotRates: [(maturity: Double, rate: Double)]) -> Double {
        guard !spotRates.isEmpty else { return 0.05 }
        
        // If exact match, return it
        if let exact = spotRates.first(where: { abs($0.maturity - maturity) < 0.001 }) {
            return exact.rate
        }
        
        // Find surrounding points
        let before = spotRates.filter { $0.maturity <= maturity }.last
        let after = spotRates.filter { $0.maturity > maturity }.first
        
        if let b = before, let a = after {
            // Linear interpolation between points
            let weight = (maturity - b.maturity) / (a.maturity - b.maturity)
            return b.rate + weight * (a.rate - b.rate)
        } else if let b = before {
            // Extrapolate from last point (flat forward)
            return b.rate
        } else if let a = after {
            // Use first point
            return a.rate
        }
        
        return 0.05 // Default
    }
}
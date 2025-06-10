//
//  FormulaReference.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import SwiftUI

/// Comprehensive CFA Formula Reference Data Model
struct FormulaReference: Identifiable {
    let id = UUID()
    let name: String
    let category: FormulaCategory
    let level: CFALevel
    let mainFormula: String // LaTeX string
    let description: String
    let variables: [FormulaVariable]
    let derivation: FormulaDerivation?
    let variants: [FormulaVariant]
    let usageNotes: [String]
    let examples: [FormulaExample]
    let relatedFormulas: [String] // IDs of related formulas
    let tags: [String]
}

/// CFA Exam Levels
enum CFALevel: String, CaseIterable, Identifiable {
    case levelI = "Level I"
    case levelII = "Level II"
    case levelIII = "Level III"
    case all = "All Levels"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .levelI: return .blue
        case .levelII: return .orange
        case .levelIII: return .red
        case .all: return .gray
        }
    }
}

/// Asset Class Categories for Organization
enum FormulaCategory: String, CaseIterable, Identifiable {
    case quantitative = "Quantitative Methods"
    case fixedIncome = "Fixed Income"
    case equity = "Equity Securities"
    case derivatives = "Derivatives"
    case alternatives = "Alternative Investments"
    case portfolio = "Portfolio Management"
    case risk = "Risk Management"
    case economics = "Economics & FRA"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .quantitative: return "function"
        case .fixedIncome: return "chart.line.uptrend.xyaxis"
        case .equity: return "building.columns"
        case .derivatives: return "arrow.triangle.swap"
        case .alternatives: return "building.2"
        case .portfolio: return "chart.pie"
        case .risk: return "shield"
        case .economics: return "globe"
        }
    }
    
    var color: Color {
        switch self {
        case .quantitative: return .blue
        case .fixedIncome: return .green
        case .equity: return .purple
        case .derivatives: return .orange
        case .alternatives: return .brown
        case .portfolio: return .indigo
        case .risk: return .red
        case .economics: return .teal
        }
    }
}

/// Formula Variables with Definitions
struct FormulaVariable: Identifiable {
    let id = UUID()
    let symbol: String // LaTeX symbol
    let name: String
    let description: String
    let units: String?
    let typicalRange: String?
    let notes: String?
}

/// Step-by-step derivation
struct FormulaDerivation: Identifiable {
    let id = UUID()
    let title: String
    let steps: [DerivationStep]
    let assumptions: [String]
    let notes: String?
}

struct DerivationStep: Identifiable {
    let id = UUID()
    let stepNumber: Int
    let description: String
    let formula: String // LaTeX
    let explanation: String
}

/// Formula variants and rearrangements
struct FormulaVariant: Identifiable {
    let id = UUID()
    let name: String
    let formula: String // LaTeX
    let description: String
    let whenToUse: String
}

/// Practical examples
struct FormulaExample: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let inputs: [String: String]
    let calculation: String
    let result: String
    let interpretation: String
}

/// Comprehensive Formula Database
class FormulaDatabase: ObservableObject {
    @Published var formulas: [FormulaReference] = []
    
    init() {
        loadFormulas()
        loadComprehensiveFormulas()
        loadComprehensiveCFAFormulas()
    }
    
    func formulas(for category: FormulaCategory, level: CFALevel = .all) -> [FormulaReference] {
        return formulas.filter { formula in
            let categoryMatch = formula.category == category
            let levelMatch = level == .all || formula.level == level || formula.level == .all
            return categoryMatch && levelMatch
        }.sorted { $0.name < $1.name }
    }
    
    func searchFormulas(_ searchText: String) -> [FormulaReference] {
        guard !searchText.isEmpty else { return formulas }
        
        return formulas.filter { formula in
            formula.name.localizedCaseInsensitiveContains(searchText) ||
            formula.description.localizedCaseInsensitiveContains(searchText) ||
            formula.tags.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
            formula.variables.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func loadFormulas() {
        formulas = [
            // MARK: - Fixed Income Formulas
            createBondPricingFormula(),
            createYieldToMaturityFormula(),
            createMacaulayDurationFormula(),
            createModifiedDurationFormula(),
            createConvexityFormula(),
            createCurrentYieldFormula(),
            createSpotRateFormula(),
            createForwardRateFormula(),
            
            // MARK: - Equity Formulas
            createGordonGrowthModelFormula(),
            createTwoStageDDMFormula(),
            createHModelFormula(),
            createFCFEModelFormula(),
            createFCFFModelFormula(),
            createResidualIncomeFormula(),
            createPERatioFormula(),
            createPBRatioFormula(),
            createEVEBITDAFormula(),
            
            // MARK: - Derivatives Formulas
            createBlackScholesCallFormula(),
            createBlackScholesPutFormula(),
            createPutCallParityFormula(),
            createBinomialModelFormula(),
            createForwardPricingFormula(),
            createGreeksFormulas(),
            
            // MARK: - Portfolio Management Formulas
            createCAPMFormula(),
            createPortfolioVarianceFormula(),
            createSharpeRatioFormula(),
            createTreynorRatioFormula(),
            createJensensAlphaFormula(),
            createInformationRatioFormula(),
            
            // MARK: - Quantitative Methods Formulas
            createPresentValueFormula(),
            createFutureValueFormula(),
            createAnnuityPVFormula(),
            createPerpetuityFormula(),
            createEAR_Formula(),
            createArithmeticMeanFormula(),
            createGeometricMeanFormula(),
            createVarianceFormula(),
            createStandardDeviationFormula(),
            
            // MARK: - Risk Management Formulas
            createVaRFormula(),
            createExpectedShortfallFormula(),
            createDownsideDeviationFormula(),
            createMaximumDrawdownFormula(),
            
            // MARK: - Alternative Investments Formulas
            createRealEstateCapRateFormula(),
            createPrivateEquityIRRFormula(),
            createHedgeFundSharpeFormula(),
            
            // MARK: - Economics & FRA Formulas
            createCurrentRatioFormula(),
            createROEFormula(),
            createDuPontFormula(),
            createDebtToEquityFormula()
        ]
        
        // Load comprehensive formulas
        loadComprehensiveFormulas()
        
        // Add missing essential formulas
        formulas.append(contentsOf: [
            createSwapSpreadFormula(),
            createTEDSpreadFormula(),
            createLIBOROISSpreadFormula(),
            createPutCallParityExactFormula(),
            createGreeksCollectionFormula(),
            createFuturesPricingFormula(),
            createCDSPricingFormula(),
            createImplementationShortfallFormula(),
            createCaptureRatioFormula(),
            createCalmarRatioFormula()
        ])
    }
}

// MARK: - Formula Creation Methods
extension FormulaDatabase {
    
    private func createBondPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Bond Pricing (Full Price)",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1 + \\frac{YTM}{m})^t} + \\frac{FV}{(1 + \\frac{YTM}{m})^n}",
            description: "Fundamental bond pricing equation that calculates the present value of all future cash flows including coupon payments and principal repayment.",
            variables: [
                FormulaVariable(symbol: "P", name: "Bond Price", description: "Full price of the bond", units: "Currency", typicalRange: "0 to par value + premium", notes: "Includes accrued interest"),
                FormulaVariable(symbol: "PMT", name: "Coupon Payment", description: "Periodic coupon payment", units: "Currency", typicalRange: "0 to annual coupon/m", notes: "PMT = (Coupon Rate × Face Value) / m"),
                FormulaVariable(symbol: "YTM", name: "Yield to Maturity", description: "Annual yield to maturity", units: "Percentage", typicalRange: "0% to 30%", notes: "Expressed as decimal in calculation"),
                FormulaVariable(symbol: "m", name: "Payment Frequency", description: "Number of payments per year", units: "Count", typicalRange: "1, 2, 4, 12", notes: "2 for semi-annual, 4 for quarterly"),
                FormulaVariable(symbol: "t", name: "Period Number", description: "Time period for each cash flow", units: "Periods", typicalRange: "1 to n", notes: "Measured in payment periods"),
                FormulaVariable(symbol: "n", name: "Total Periods", description: "Total number of payment periods", units: "Periods", typicalRange: "1 to 360", notes: "n = Years to Maturity × m"),
                FormulaVariable(symbol: "FV", name: "Face Value", description: "Principal amount to be repaid", units: "Currency", typicalRange: "1000 typical", notes: "Also called par value or maturity value")
            ],
            derivation: FormulaDerivation(
                title: "Bond Pricing Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with the present value concept", formula: "PV = \\frac{CF}{(1+r)^t}", explanation: "Each cash flow must be discounted to present value"),
                    DerivationStep(stepNumber: 2, description: "Apply to periodic coupon payments", formula: "PV_{coupons} = \\sum_{t=1}^{n} \\frac{PMT}{(1 + \\frac{YTM}{m})^t}", explanation: "Sum the present value of all coupon payments"),
                    DerivationStep(stepNumber: 3, description: "Add present value of principal", formula: "PV_{principal} = \\frac{FV}{(1 + \\frac{YTM}{m})^n}", explanation: "Principal is paid at maturity"),
                    DerivationStep(stepNumber: 4, description: "Combine both components", formula: "P = PV_{coupons} + PV_{principal}", explanation: "Total bond price is sum of all cash flow present values")
                ],
                assumptions: [
                    "YTM remains constant over the bond's life",
                    "Coupon payments are made exactly on scheduled dates",
                    "No default risk (or already incorporated in YTM)",
                    "No embedded options"
                ],
                notes: "This gives the full price. Flat price = Full price - Accrued interest"
            ),
            variants: [
                FormulaVariant(name: "Zero-Coupon Bond", formula: "P = \\frac{FV}{(1 + \\frac{YTM}{m})^n}", description: "For bonds with no coupon payments", whenToUse: "When PMT = 0"),
                FormulaVariant(name: "Annual Compounding", formula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1 + YTM)^t} + \\frac{FV}{(1 + YTM)^n}", description: "When payments are annual", whenToUse: "When m = 1"),
                FormulaVariant(name: "Perpetual Bond", formula: "P = \\frac{PMT}{\\frac{YTM}{m}}", description: "For bonds with no maturity date", whenToUse: "When n approaches infinity")
            ],
            usageNotes: [
                "This formula gives the full price including accrued interest",
                "For flat price, subtract accrued interest from full price", 
                "YTM must be solved iteratively when given price",
                "Assumes reinvestment of coupons at YTM rate",
                "Market convention may use different day count methods"
            ],
            examples: [
                FormulaExample(
                    title: "5-Year Corporate Bond",
                    description: "Calculate price of a 5% annual coupon bond with 5 years to maturity, YTM = 6%",
                    inputs: ["FV": "1000", "Coupon Rate": "5%", "YTM": "6%", "Years": "5", "m": "1"],
                    calculation: "P = 50/1.06 + 50/1.06² + 50/1.06³ + 50/1.06⁴ + 1050/1.06⁵",
                    result: "P = $957.88",
                    interpretation: "Bond trades at discount due to YTM > Coupon Rate"
                )
            ],
            relatedFormulas: ["yield-to-maturity", "current-yield", "duration", "convexity"],
            tags: ["bond", "pricing", "present-value", "yield", "fixed-income", "valuation"]
        )
    }
    
    private func createGordonGrowthModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Gordon Growth Model (Constant Growth DDM)",
            category: .equity,
            level: .levelI,
            mainFormula: "P_0 = \\frac{D_1}{r - g} = \\frac{D_0(1 + g)}{r - g}",
            description: "Dividend discount model assuming constant growth in dividends in perpetuity. Fundamental equity valuation method for stable, dividend-paying companies.",
            variables: [
                FormulaVariable(symbol: "P_0", name: "Current Stock Price", description: "Fair value of stock today", units: "Currency per share", typicalRange: "$1 to $1000+", notes: "Theoretical fair value"),
                FormulaVariable(symbol: "D_1", name: "Next Period Dividend", description: "Expected dividend next period", units: "Currency per share", typicalRange: "$0 to $50", notes: "D₁ = D₀(1 + g)"),
                FormulaVariable(symbol: "D_0", name: "Current Dividend", description: "Most recent dividend paid", units: "Currency per share", typicalRange: "$0 to $50", notes: "Historical dividend payment"),
                FormulaVariable(symbol: "r", name: "Required Rate of Return", description: "Investor's required return", units: "Percentage", typicalRange: "5% to 20%", notes: "Compensation for risk and time value"),
                FormulaVariable(symbol: "g", name: "Constant Growth Rate", description: "Expected dividend growth rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Must be less than r for model validity")
            ],
            derivation: FormulaDerivation(
                title: "Gordon Growth Model Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with general DDM", formula: "P_0 = \\sum_{t=1}^{\\infty} \\frac{D_t}{(1+r)^t}", explanation: "Present value of all future dividends"),
                    DerivationStep(stepNumber: 2, description: "Apply constant growth assumption", formula: "D_t = D_0(1+g)^t", explanation: "Each dividend grows at rate g"),
                    DerivationStep(stepNumber: 3, description: "Substitute into DDM", formula: "P_0 = \\sum_{t=1}^{\\infty} \\frac{D_0(1+g)^t}{(1+r)^t}", explanation: "Replace Dₜ with growth formula"),
                    DerivationStep(stepNumber: 4, description: "Factor out D₀", formula: "P_0 = D_0 \\sum_{t=1}^{\\infty} \\left(\\frac{1+g}{1+r}\\right)^t", explanation: "Simplify the expression"),
                    DerivationStep(stepNumber: 5, description: "Apply geometric series formula", formula: "\\sum_{t=1}^{\\infty} x^t = \\frac{x}{1-x} \\text{ for } |x| < 1", explanation: "Where x = (1+g)/(1+r)"),
                    DerivationStep(stepNumber: 6, description: "Solve the series", formula: "P_0 = D_0 \\frac{\\frac{1+g}{1+r}}{1-\\frac{1+g}{1+r}}", explanation: "Apply geometric series solution"),
                    DerivationStep(stepNumber: 7, description: "Simplify the denominator", formula: "P_0 = D_0 \\frac{1+g}{(1+r)-(1+g)} = D_0 \\frac{1+g}{r-g}", explanation: "Algebraic simplification"),
                    DerivationStep(stepNumber: 8, description: "Final form", formula: "P_0 = \\frac{D_0(1+g)}{r-g} = \\frac{D_1}{r-g}", explanation: "Since D₁ = D₀(1+g)")
                ],
                assumptions: [
                    "Dividends grow at constant rate g forever",
                    "Required return r > growth rate g",
                    "Company pays dividends consistently",
                    "Growth rate is sustainable long-term",
                    "No terminal value or company liquidation"
                ],
                notes: "Model is very sensitive to assumptions about g and r. Small changes in either can dramatically affect valuation."
            ),
            variants: [
                FormulaVariant(name: "No Growth DDM", formula: "P_0 = \\frac{D}{r}", description: "When g = 0 (perpetuity)", whenToUse: "For preferred stock or zero-growth stocks"),
                FormulaVariant(name: "Price-to-Dividend Ratio", formula: "\\frac{P_0}{D_1} = \\frac{1}{r-g}", description: "Express as valuation multiple", whenToUse: "For relative valuation analysis"),
                FormulaVariant(name: "Implied Growth Rate", formula: "g = r - \\frac{D_1}{P_0}", description: "Solve for growth rate", whenToUse: "When analyzing market expectations"),
                FormulaVariant(name: "Implied Required Return", formula: "r = \\frac{D_1}{P_0} + g", description: "Solve for required return", whenToUse: "For cost of equity estimation")
            ],
            usageNotes: [
                "Model only applicable when r > g (required return exceeds growth rate)",
                "Most suitable for mature, stable companies with consistent dividend policy",
                "Growth rate should reflect long-term sustainable growth",
                "Very sensitive to input assumptions - small changes have large impact",
                "Cannot be used for companies that don't pay dividends",
                "Growth rate typically should not exceed GDP growth rate long-term"
            ],
            examples: [
                FormulaExample(
                    title: "Utility Company Valuation",
                    description: "Value a utility stock with D₀ = $2.40, g = 3%, r = 8%",
                    inputs: ["D₀": "$2.40", "g": "3%", "r": "8%"],
                    calculation: "D₁ = $2.40 × 1.03 = $2.472\nP₀ = $2.472 / (0.08 - 0.03)",
                    result: "P₀ = $49.44",
                    interpretation: "Utility fairly valued if trading around $49 per share"
                )
            ],
            relatedFormulas: ["two-stage-ddm", "h-model", "fcfe-model", "required-return"],
            tags: ["dividend", "valuation", "equity", "growth", "ddm", "intrinsic-value"]
        )
    }
    
    private func createCAPMFormula() -> FormulaReference {
        FormulaReference(
            name: "Capital Asset Pricing Model (CAPM)",
            category: .portfolio,
            level: .levelI,
            mainFormula: "E(R_i) = R_f + \\beta_i[E(R_m) - R_f]",
            description: "Fundamental model relating expected return of an asset to its systematic risk (beta). Core framework for asset pricing and cost of equity calculations.",
            variables: [
                FormulaVariable(symbol: "E(R_i)", name: "Expected Return of Asset i", description: "Required return on the asset", units: "Percentage", typicalRange: "0% to 30%", notes: "Annualized expected return"),
                FormulaVariable(symbol: "R_f", name: "Risk-Free Rate", description: "Return on risk-free asset", units: "Percentage", typicalRange: "0% to 10%", notes: "Usually Treasury bill or bond rate"),
                FormulaVariable(symbol: "\\beta_i", name: "Beta of Asset i", description: "Systematic risk measure", units: "Unitless", typicalRange: "0 to 3.0", notes: "Sensitivity to market movements"),
                FormulaVariable(symbol: "E(R_m)", name: "Expected Market Return", description: "Expected return on market portfolio", units: "Percentage", typicalRange: "5% to 15%", notes: "Usually broad market index"),
                FormulaVariable(symbol: "[E(R_m) - R_f]", name: "Market Risk Premium", description: "Extra return for market risk", units: "Percentage", typicalRange: "3% to 10%", notes: "Compensation for systematic risk")
            ],
            derivation: FormulaDerivation(
                title: "CAPM Derivation from Portfolio Theory",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with market equilibrium condition", formula: "\\text{All investors hold market portfolio}", explanation: "In equilibrium, supply equals demand for all assets"),
                    DerivationStep(stepNumber: 2, description: "Portfolio expected return", formula: "E(R_p) = \\sum w_i E(R_i)", explanation: "Weighted average of individual asset returns"),
                    DerivationStep(stepNumber: 3, description: "Portfolio risk with market", formula: "\\text{Cov}(R_p, R_m) = \\sum w_i \\text{Cov}(R_i, R_m)", explanation: "Portfolio covariance with market"),
                    DerivationStep(stepNumber: 4, description: "Define beta", formula: "\\beta_i = \\frac{\\text{Cov}(R_i, R_m)}{\\text{Var}(R_m)}", explanation: "Beta measures systematic risk"),
                    DerivationStep(stepNumber: 5, description: "Apply tangency condition", formula: "\\frac{E(R_i) - R_f}{\\beta_i} = \\frac{E(R_m) - R_f}{1}", explanation: "All assets must have same risk-adjusted return"),
                    DerivationStep(stepNumber: 6, description: "Solve for expected return", formula: "E(R_i) - R_f = \\beta_i[E(R_m) - R_f]", explanation: "Rearrange the tangency condition"),
                    DerivationStep(stepNumber: 7, description: "Final CAPM equation", formula: "E(R_i) = R_f + \\beta_i[E(R_m) - R_f]", explanation: "Add risk-free rate to both sides")
                ],
                assumptions: [
                    "Investors are rational and risk-averse",
                    "Markets are efficient and frictionless",
                    "Investors have homogeneous expectations",
                    "Single-period investment horizon",
                    "Risk-free asset exists and unlimited borrowing/lending at Rf",
                    "All assets are marketable and divisible",
                    "No taxes or transaction costs"
                ],
                notes: "CAPM provides theoretical foundation for modern portfolio theory and risk-return relationship."
            ),
            variants: [
                FormulaVariant(name: "Beta Calculation", formula: "\\beta_i = \\frac{\\text{Cov}(R_i, R_m)}{\\text{Var}(R_m)} = \\frac{\\sigma_{im}}{\\sigma_m^2}", description: "How to calculate beta", whenToUse: "When estimating systematic risk"),
                FormulaVariant(name: "Security Market Line", formula: "E(R_i) = R_f + \\frac{E(R_m) - R_f}{\\beta_m} \\beta_i", description: "Graphical representation", whenToUse: "For portfolio analysis and visualization"),
                FormulaVariant(name: "Jensen's Alpha", formula: "\\alpha_i = R_i - [R_f + \\beta_i(R_m - R_f)]", description: "Abnormal return measure", whenToUse: "For performance evaluation"),
                FormulaVariant(name: "Levered Beta", formula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D}{E}]", description: "Adjust beta for leverage", whenToUse: "When analyzing leveraged companies")
            ],
            usageNotes: [
                "Beta > 1: Asset more volatile than market",
                "Beta < 1: Asset less volatile than market", 
                "Beta = 0: Asset uncorrelated with market",
                "Most useful for well-diversified portfolios",
                "Assumes linear relationship between risk and return",
                "Historical beta may not predict future beta",
                "Market portfolio proxy (S&P 500) affects results"
            ],
            examples: [
                FormulaExample(
                    title: "Technology Stock Required Return",
                    description: "Calculate required return for tech stock with β = 1.4, Rf = 3%, E(Rm) = 10%",
                    inputs: ["β": "1.4", "Rf": "3%", "E(Rm)": "10%"],
                    calculation: "E(R) = 3% + 1.4 × (10% - 3%)",
                    result: "E(R) = 12.8%",
                    interpretation: "Investors require 12.8% return for this tech stock's risk level"
                )
            ],
            relatedFormulas: ["beta-calculation", "jensen-alpha", "treynor-ratio", "sharpe-ratio"],
            tags: ["capm", "beta", "required-return", "portfolio-theory", "risk-premium", "cost-of-equity"]
        )
    }
    
    // Additional formula creation methods would continue here...
    // For brevity, I'll create simplified versions of the remaining formulas
    
    private func createYieldToMaturityFormula() -> FormulaReference {
        // Implementation for YTM formula
        FormulaReference(
            name: "Yield to Maturity (YTM)",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1 + YTM)^t} + \\frac{FV}{(1 + YTM)^n}",
            description: "YTM is the internal rate of return of a bond, solved iteratively from the bond pricing equation.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Must be solved iteratively", "Assumes reinvestment at YTM"],
            examples: [],
            relatedFormulas: ["bond-pricing"],
            tags: ["yield", "bond", "irr"]
        )
    }
    
    private func createMacaulayDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Macaulay Duration",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "D_{Mac} = \\frac{\\sum_{t=1}^{n} t \\cdot \\frac{CF_t}{(1+YTM)^t}}{P}",
            description: "Weighted average time to receive cash flows, measured in years.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measured in years", "Higher duration = higher price sensitivity"],
            examples: [],
            relatedFormulas: ["modified-duration", "bond-pricing"],
            tags: ["duration", "bond", "risk"]
        )
    }
    
    private func createModifiedDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Modified Duration",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "D_{Mod} = \\frac{D_{Mac}}{1 + \\frac{YTM}{m}}",
            description: "Price sensitivity measure showing percentage price change for 1% yield change.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Percentage price change = -Modified Duration × Yield change"],
            examples: [],
            relatedFormulas: ["macaulay-duration", "convexity"],
            tags: ["duration", "bond", "price-sensitivity"]
        )
    }
    
    private func createConvexityFormula() -> FormulaReference {
        FormulaReference(
            name: "Bond Convexity",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "C = \\frac{\\sum_{t=1}^{n} t(t+1) \\cdot \\frac{CF_t}{(1+YTM)^{t+2}}}{P \\cdot (1+YTM)^2}",
            description: "Second-order price sensitivity measure, accounting for curvature in price-yield relationship.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher convexity is beneficial for bond investors"],
            examples: [],
            relatedFormulas: ["modified-duration", "bond-pricing"],
            tags: ["convexity", "bond", "price-sensitivity"]
        )
    }
    
    // Continue with more simplified formulas...
    
    private func createCurrentYieldFormula() -> FormulaReference {
        FormulaReference(
            name: "Current Yield",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "CY = \\frac{\\text{Annual Coupon Payment}}{\\text{Bond Price}}",
            description: "Simple yield measure based on annual income relative to current price.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Does not account for capital gains/losses"],
            examples: [],
            relatedFormulas: ["ytm", "bond-pricing"],
            tags: ["yield", "bond", "income"]
        )
    }
    
    private func createSpotRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Spot Rate",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "P = \\sum_{t=1}^{n} \\frac{CF_t}{(1 + S_t)^t}",
            description: "Zero-coupon yield for each maturity, used in arbitrage-free pricing.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Derived through bootstrapping method"],
            examples: [],
            relatedFormulas: ["forward-rate", "bond-pricing"],
            tags: ["spot-rate", "yield-curve", "arbitrage-free"]
        )
    }
    
    private func createForwardRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Forward Rate",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "(1 + S_T)^T = (1 + S_t)^t \\cdot (1 + f_{t,T})^{T-t}",
            description: "Implied future interest rate derived from current spot rates.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Forward rates are market expectations of future rates"],
            examples: [],
            relatedFormulas: ["spot-rate", "bond-pricing"],
            tags: ["forward-rate", "yield-curve", "expectations"]
        )
    }
    
    // Additional methods for other formula categories...
    // This is a representative sample - the full implementation would continue
    // with all formulas from the research document
    
    private func createTwoStageDDMFormula() -> FormulaReference {
        FormulaReference(
            name: "Two-Stage Dividend Discount Model",
            category: .equity,
            level: .levelII,
            mainFormula: "P_0 = \\sum_{t=1}^{n} \\frac{D_0(1+g_1)^t}{(1+r)^t} + \\frac{P_n}{(1+r)^n}",
            description: "DDM with two distinct growth phases: high initial growth, then stable growth.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Suitable for companies transitioning to maturity"],
            examples: [],
            relatedFormulas: ["gordon-growth", "h-model"],
            tags: ["ddm", "valuation", "two-stage", "growth"]
        )
    }
    
    private func createHModelFormula() -> FormulaReference {
        FormulaReference(
            name: "H-Model (Variable Growth DDM)",
            category: .equity,
            level: .levelII,
            mainFormula: "P_0 = \\frac{D_1}{r-g_L} + \\frac{D_1 \\cdot H \\cdot (g_S - g_L)}{2(r-g_L)}",
            description: "DDM assuming linear decline from high growth to stable growth over H years.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["More realistic growth transition than two-stage model"],
            examples: [],
            relatedFormulas: ["gordon-growth", "two-stage-ddm"],
            tags: ["h-model", "ddm", "variable-growth"]
        )
    }
    
    private func createFCFEModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Free Cash Flow to Equity Model",
            category: .equity,
            level: .levelII,
            mainFormula: "P_0 = \\sum_{t=1}^{\\infty} \\frac{FCFE_t}{(1+r)^t}",
            description: "Valuation based on cash flows available to equity holders after all obligations.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["FCFE = Net Income + Depreciation - CapEx - ΔWC + Net Borrowing"],
            examples: [],
            relatedFormulas: ["fcff-model", "ddm"],
            tags: ["fcfe", "cash-flow", "valuation"]
        )
    }
    
    private func createFCFFModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Free Cash Flow to Firm Model",
            category: .equity,
            level: .levelII,
            mainFormula: "\\text{Firm Value} = \\sum_{t=1}^{\\infty} \\frac{FCFF_t}{(1+WACC)^t}",
            description: "Valuation of entire firm based on operating cash flows before financing.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Equity Value = Firm Value - Market Value of Debt"],
            examples: [],
            relatedFormulas: ["fcfe-model", "wacc"],
            tags: ["fcff", "firm-valuation", "wacc"]
        )
    }
    
    private func createResidualIncomeFormula() -> FormulaReference {
        FormulaReference(
            name: "Residual Income Model",
            category: .equity,
            level: .levelII,
            mainFormula: "P_0 = BV_0 + \\sum_{t=1}^{\\infty} \\frac{RI_t}{(1+r)^t}",
            description: "Valuation based on book value plus present value of excess returns.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["RI = Net Income - (r × Beginning Book Value)"],
            examples: [],
            relatedFormulas: ["roe", "book-value"],
            tags: ["residual-income", "book-value", "excess-return"]
        )
    }
    
    // Continue with additional formulas...
    // This represents the structure - full implementation would include all formulas
    
    private func createPERatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Price-to-Earnings Ratio",
            category: .equity,
            level: .levelI,
            mainFormula: "P/E = \\frac{\\text{Price per Share}}{\\text{Earnings per Share}}",
            description: "Popular valuation multiple comparing stock price to earnings.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Forward P/E uses next year's expected earnings"],
            examples: [],
            relatedFormulas: ["pb-ratio", "peg-ratio"],
            tags: ["pe-ratio", "multiple", "valuation"]
        )
    }
    
    private func createPBRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Price-to-Book Ratio",
            category: .equity,
            level: .levelI,
            mainFormula: "P/B = \\frac{\\text{Price per Share}}{\\text{Book Value per Share}}",
            description: "Valuation multiple comparing market value to accounting book value.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Useful for asset-heavy businesses"],
            examples: [],
            relatedFormulas: ["pe-ratio", "roe"],
            tags: ["pb-ratio", "book-value", "multiple"]
        )
    }
    
    private func createEVEBITDAFormula() -> FormulaReference {
        FormulaReference(
            name: "Enterprise Value to EBITDA",
            category: .equity,
            level: .levelI,
            mainFormula: "\\frac{EV}{EBITDA} = \\frac{\\text{Enterprise Value}}{\\text{EBITDA}}",
            description: "Enterprise multiple comparing total firm value to operating cash earnings before depreciation.",
            variables: [
                FormulaVariable(symbol: "EV", name: "Enterprise Value", description: "Total value of the business", units: "Currency", typicalRange: nil, notes: nil),
                FormulaVariable(symbol: "EBITDA", name: "Earnings Before Interest, Taxes, Depreciation, and Amortization", description: "Operating cash earnings", units: "Currency", typicalRange: nil, notes: nil)
            ],
            derivation: FormulaDerivation(
                title: "EV/EBITDA Multiple Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate Enterprise Value", formula: "EV = \\text{Market Cap} + \\text{Total Debt} - \\text{Cash}", explanation: "Sum equity value and net debt to get total firm value"),
                    DerivationStep(stepNumber: 2, description: "Calculate EBITDA", formula: "EBITDA = \\text{Net Income} + \\text{Interest} + \\text{Taxes} + \\text{D&A}", explanation: "Add back non-cash and financing items to get operating cash earnings"),
                    DerivationStep(stepNumber: 3, description: "Compute the multiple", formula: "\\text{EV/EBITDA} = \\frac{EV}{EBITDA}", explanation: "Divide enterprise value by operating cash earnings")
                ],
                assumptions: ["EBITDA reflects operating cash generation", "Enterprise value represents acquisition cost"],
                notes: "EV/EBITDA is the most widely used valuation multiple in M&A transactions."
            ),
            variants: [
                FormulaVariant(name: "EV/EBIT", formula: "\\frac{EV}{EBIT}", description: "Excludes depreciation effects", whenToUse: "For asset-light businesses"),
                FormulaVariant(name: "EV/Sales", formula: "\\frac{EV}{\\text{Revenue}}", description: "Revenue-based multiple", whenToUse: "For early-stage or loss-making companies")
            ],
            usageNotes: [
                "Most common valuation multiple in M&A",
                "Less affected by depreciation policies than EV/EBIT",
                "Useful for capital-intensive industries",
                "Typical ranges: 5-15x for mature companies"
            ],
            examples: [
                FormulaExample(
                    title: "Retail Company Valuation",
                    description: "Company with EV $2.5B, EBITDA $500M",
                    inputs: ["EV": "$2.5B", "EBITDA": "$500M"],
                    calculation: "EV/EBITDA = $2.5B / $500M",
                    result: "5.0x",
                    interpretation: "Company trades at 5x its operating cash earnings"
                )
            ],
            relatedFormulas: ["enterprise-value", "ebitda", "ev-ebit"],
            tags: ["ev-ebitda", "enterprise-value", "multiple", "valuation"]
        )
    }
    
    // Continue with all remaining formulas...
    // The following are simplified placeholders for the complete implementation
    
    private func createBlackScholesCallFormula() -> FormulaReference {
        FormulaReference(
            name: "Black-Scholes Call Option",
            category: .derivatives,
            level: .levelII,
            mainFormula: "C = S_0 N(d_1) - X e^{-rT} N(d_2)",
            description: "Theoretical call option price under Black-Scholes assumptions.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Assumes constant volatility and interest rates"],
            examples: [],
            relatedFormulas: ["black-scholes-put", "greeks"],
            tags: ["black-scholes", "call-option", "derivatives"]
        )
    }
    
    private func createBlackScholesPutFormula() -> FormulaReference {
        FormulaReference(
            name: "Black-Scholes Put Option",
            category: .derivatives,
            level: .levelII,
            mainFormula: "P = X e^{-rT} N(-d_2) - S_0 N(-d_1)",
            description: "Theoretical put option price under Black-Scholes assumptions.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Related to call price through put-call parity"],
            examples: [],
            relatedFormulas: ["black-scholes-call", "put-call-parity"],
            tags: ["black-scholes", "put-option", "derivatives"]
        )
    }
    
    private func createPutCallParityFormula() -> FormulaReference {
        FormulaReference(
            name: "Put-Call Parity",
            category: .derivatives,
            level: .levelI,
            mainFormula: "C + X e^{-rT} = P + S_0",
            description: "Arbitrage relationship between call and put option prices.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Fundamental no-arbitrage relationship"],
            examples: [],
            relatedFormulas: ["black-scholes-call", "black-scholes-put"],
            tags: ["put-call-parity", "arbitrage", "options"]
        )
    }
    
    private func createBinomialModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Binomial Option Pricing Model",
            category: .derivatives,
            level: .levelII,
            mainFormula: "C = \\frac{p \\cdot C_u + (1-p) \\cdot C_d}{1+r}",
            description: "Discrete-time option pricing model using risk-neutral valuation.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Can handle American-style options"],
            examples: [],
            relatedFormulas: ["black-scholes", "risk-neutral-probability"],
            tags: ["binomial", "option-pricing", "american-options"]
        )
    }
    
    private func createForwardPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Forward Pricing",
            category: .derivatives,
            level: .levelI,
            mainFormula: "F_0 = S_0 e^{rT}",
            description: "No-arbitrage forward price for asset with no income.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Adjust for dividends, storage costs, convenience yield"],
            examples: [],
            relatedFormulas: ["futures-pricing", "cost-of-carry"],
            tags: ["forward", "pricing", "arbitrage"]
        )
    }
    
    private func createGreeksFormulas() -> FormulaReference {
        FormulaReference(
            name: "Option Greeks",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Delta = \\frac{\\partial V}{\\partial S}, \\Gamma = \\frac{\\partial^2 V}{\\partial S^2}, \\Theta = \\frac{\\partial V}{\\partial t}",
            description: "Risk sensitivities of option prices to various factors.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used for hedging and risk management"],
            examples: [],
            relatedFormulas: ["black-scholes", "delta-hedging"],
            tags: ["greeks", "delta", "gamma", "theta", "risk"]
        )
    }
    
    private func createPortfolioVarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Portfolio Variance",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\sigma_p^2 = \\sum_{i=1}^n w_i^2 \\sigma_i^2 + \\sum_{i=1}^n \\sum_{j \\neq i} w_i w_j \\sigma_{ij}",
            description: "Risk measure for portfolio combining individual asset risks and correlations.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Diversification benefit comes from correlation < 1"],
            examples: [],
            relatedFormulas: ["portfolio-return", "correlation"],
            tags: ["portfolio", "variance", "risk", "diversification"]
        )
    }
    
    private func createSharpeRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Sharpe Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "S_p = \\frac{R_p - R_f}{\\sigma_p}",
            description: "Risk-adjusted return measure using total risk (standard deviation).",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher Sharpe ratio indicates better risk-adjusted performance"],
            examples: [],
            relatedFormulas: ["treynor-ratio", "information-ratio"],
            tags: ["sharpe", "risk-adjusted", "performance"]
        )
    }
    
    private func createTreynorRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Treynor Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "T_p = \\frac{R_p - R_f}{\\beta_p}",
            description: "Risk-adjusted return measure using systematic risk (beta).",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Appropriate for well-diversified portfolios"],
            examples: [],
            relatedFormulas: ["sharpe-ratio", "capm", "beta"],
            tags: ["treynor", "beta", "systematic-risk", "performance"]
        )
    }
    
    private func createJensensAlphaFormula() -> FormulaReference {
        FormulaReference(
            name: "Jensen's Alpha",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\alpha_p = R_p - [R_f + \\beta_p(R_m - R_f)]",
            description: "Abnormal return measure relative to CAPM expected return.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Positive alpha indicates outperformance"],
            examples: [],
            relatedFormulas: ["capm", "beta", "abnormal-return"],
            tags: ["alpha", "abnormal-return", "capm", "performance"]
        )
    }
    
    private func createInformationRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Information Ratio",
            category: .portfolio,
            level: .levelII,
            mainFormula: "IR = \\frac{\\alpha_p}{\\sigma(\\varepsilon_p)}",
            description: "Risk-adjusted active return relative to tracking error.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures active management skill"],
            examples: [],
            relatedFormulas: ["alpha", "tracking-error", "active-return"],
            tags: ["information-ratio", "active-management", "tracking-error"]
        )
    }
    
    // Quantitative Methods formulas
    private func createPresentValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Present Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV = \\frac{FV}{(1+r)^n}",
            description: "Current value of future cash flow discounted at appropriate rate.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation of all valuation methods"],
            examples: [],
            relatedFormulas: ["future-value", "annuity-pv"],
            tags: ["present-value", "time-value", "discounting"]
        )
    }
    
    private func createFutureValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Future Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "FV = PV(1+r)^n",
            description: "Value of current amount after earning interest for n periods.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Compounding effect increases with time and rate"],
            examples: [],
            relatedFormulas: ["present-value", "compound-interest"],
            tags: ["future-value", "compounding", "time-value"]
        )
    }
    
    private func createAnnuityPVFormula() -> FormulaReference {
        FormulaReference(
            name: "Annuity Present Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV = PMT \\times \\frac{1-(1+r)^{-n}}{r}",
            description: "Present value of series of equal payments.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Ordinary annuity assumes end-of-period payments"],
            examples: [],
            relatedFormulas: ["perpetuity", "annuity-fv"],
            tags: ["annuity", "present-value", "payments"]
        )
    }
    
    private func createPerpetuityFormula() -> FormulaReference {
        FormulaReference(
            name: "Perpetuity",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV = \\frac{PMT}{r}",
            description: "Present value of infinite series of equal payments made at regular intervals forever. Fundamental valuation concept for preferred stock, real estate, and other income-producing assets.",
            variables: [
                FormulaVariable(symbol: "PV", name: "Present Value", description: "Current value of the perpetuity", units: "Currency", typicalRange: "$0 to unlimited", notes: "Total worth of infinite payment stream today"),
                FormulaVariable(symbol: "PMT", name: "Payment Amount", description: "Fixed payment received each period", units: "Currency per period", typicalRange: "$1 to $10,000+", notes: "Must remain constant in real perpetuity"),
                FormulaVariable(symbol: "r", name: "Discount Rate", description: "Required rate of return per period", units: "Percentage per period", typicalRange: "1% to 20%", notes: "Must be greater than 0; expressed as decimal in calculation")
            ],
            derivation: FormulaDerivation(
                title: "Perpetuity Derivation from Geometric Series",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with general annuity formula", formula: "PV = \\sum_{t=1}^{n} \\frac{PMT}{(1+r)^t}", explanation: "Present value of n payments"),
                    DerivationStep(stepNumber: 2, description: "Let n approach infinity", formula: "PV = \\lim_{n \\to \\infty} \\sum_{t=1}^{n} \\frac{PMT}{(1+r)^t}", explanation: "Infinite series of payments"),
                    DerivationStep(stepNumber: 3, description: "Factor out PMT", formula: "PV = PMT \\sum_{t=1}^{\\infty} \\frac{1}{(1+r)^t}", explanation: "Constant payment amount"),
                    DerivationStep(stepNumber: 4, description: "Apply geometric series formula", formula: "\\sum_{t=1}^{\\infty} x^t = \\frac{x}{1-x} \\text{ for } |x| < 1", explanation: "Where x = 1/(1+r)"),
                    DerivationStep(stepNumber: 5, description: "Substitute and simplify", formula: "PV = PMT \\cdot \\frac{\\frac{1}{1+r}}{1-\\frac{1}{1+r}}", explanation: "Apply geometric series solution"),
                    DerivationStep(stepNumber: 6, description: "Simplify denominator", formula: "PV = PMT \\cdot \\frac{\\frac{1}{1+r}}{\\frac{r}{1+r}}", explanation: "Common denominator manipulation"),
                    DerivationStep(stepNumber: 7, description: "Final simplification", formula: "PV = PMT \\cdot \\frac{1}{r}", explanation: "Cancel (1+r) terms to get final formula")
                ],
                assumptions: [
                    "Payments continue forever (infinite time horizon)",
                    "Payment amount remains constant each period",
                    "Discount rate r > 0 and remains constant",
                    "Payments occur at end of each period (ordinary perpetuity)",
                    "No default risk or payment interruption"
                ],
                notes: "The perpetuity formula is the limiting case of an annuity as the number of payments approaches infinity."
            ),
            variants: [
                FormulaVariant(name: "Growing Perpetuity", formula: "PV = \\frac{PMT}{r-g}", description: "Perpetuity with constant growth rate g", whenToUse: "When payments grow at constant rate g < r"),
                FormulaVariant(name: "Perpetuity Due", formula: "PV = \\frac{PMT}{r} \\times (1+r)", description: "Payments at beginning of period", whenToUse: "When payments occur at start of each period"),
                FormulaVariant(name: "Deferred Perpetuity", formula: "PV = \\frac{PMT}{r} \\times \\frac{1}{(1+r)^t}", description: "Perpetuity starting t periods from now", whenToUse: "When perpetuity begins after t periods"),
                FormulaVariant(name: "Continuous Perpetuity", formula: "PV = \\frac{PMT}{r_c}", description: "Continuously compounded perpetuity", whenToUse: "With continuous compounding at rate r_c"),
                FormulaVariant(name: "Implied Rate", formula: "r = \\frac{PMT}{PV}", description: "Solve for discount rate", whenToUse: "When finding required return from price and payment")
            ],
            usageNotes: [
                "Discount rate r must be greater than 0 for convergence",
                "For growing perpetuities, growth rate g must be less than discount rate r",
                "Commonly used to value preferred stock with fixed dividends",
                "Real estate cap rates are essentially perpetuity yields",
                "Assumes payments truly continue forever (theoretical construct)",
                "Very sensitive to discount rate assumptions - small changes have large impact",
                "Terminal value in DCF models often uses perpetuity growth formula"
            ],
            examples: [
                FormulaExample(
                    title: "Preferred Stock Valuation",
                    description: "Value preferred stock paying $5 annual dividend with 8% required return",
                    inputs: ["PMT": "$5.00", "r": "8%"],
                    calculation: "PV = $5.00 / 0.08",
                    result: "PV = $62.50",
                    interpretation: "Preferred stock worth $62.50 per share"
                ),
                FormulaExample(
                    title: "Growing Perpetuity Example",
                    description: "Value growing perpetuity with $100 first payment, 3% growth, 10% discount rate",
                    inputs: ["PMT": "$100", "g": "3%", "r": "10%"],
                    calculation: "PV = $100 / (0.10 - 0.03)",
                    result: "PV = $1,428.57",
                    interpretation: "Growing income stream worth $1,428.57 today"
                )
            ],
            relatedFormulas: ["annuity-pv", "growing-perpetuity", "gordon-growth", "cap-rate"],
            tags: ["perpetuity", "infinite", "payments", "valuation", "preferred-stock", "growing"]
        )
    }
    
    private func createEAR_Formula() -> FormulaReference {
        FormulaReference(
            name: "Effective Annual Rate",
            category: .quantitative,
            level: .levelI,
            mainFormula: "EAR = \\left(1 + \\frac{r}{m}\\right)^m - 1",
            description: "True annual rate accounting for compounding frequency.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher compounding frequency increases EAR"],
            examples: [],
            relatedFormulas: ["apr", "continuous-compounding"],
            tags: ["ear", "effective-rate", "compounding"]
        )
    }
    
    private func createArithmeticMeanFormula() -> FormulaReference {
        FormulaReference(
            name: "Arithmetic Mean",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\bar{x} = \\frac{\\sum_{i=1}^n x_i}{n}",
            description: "Simple average of data points.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Most common measure of central tendency"],
            examples: [],
            relatedFormulas: ["geometric-mean", "weighted-mean"],
            tags: ["mean", "average", "central-tendency"]
        )
    }
    
    private func createGeometricMeanFormula() -> FormulaReference {
        FormulaReference(
            name: "Geometric Mean",
            category: .quantitative,
            level: .levelI,
            mainFormula: "G = \\sqrt[n]{x_1 \\times x_2 \\times \\cdots \\times x_n}",
            description: "Average rate of return over multiple periods.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Appropriate for investment returns over time"],
            examples: [],
            relatedFormulas: ["arithmetic-mean", "compound-return"],
            tags: ["geometric-mean", "compound-return", "investment"]
        )
    }
    
    private func createVarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Variance",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\sigma^2 = \\frac{\\sum_{i=1}^n (x_i - \\mu)^2}{n}",
            description: "Measure of dispersion around the mean.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Sample variance uses n-1 in denominator"],
            examples: [],
            relatedFormulas: ["standard-deviation", "covariance"],
            tags: ["variance", "dispersion", "risk"]
        )
    }
    
    private func createStandardDeviationFormula() -> FormulaReference {
        FormulaReference(
            name: "Standard Deviation",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\sigma = \\sqrt{\\sigma^2}",
            description: "Square root of variance, measuring dispersion in original units.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Most common risk measure in finance"],
            examples: [],
            relatedFormulas: ["variance", "coefficient-of-variation"],
            tags: ["standard-deviation", "volatility", "risk"]
        )
    }
    
    // Risk Management formulas
    private func createVaRFormula() -> FormulaReference {
        FormulaReference(
            name: "Value at Risk (VaR)",
            category: .risk,
            level: .levelII,
            mainFormula: "VaR = \\text{Portfolio Value} \\times \\sigma \\times z_{\\alpha}",
            description: "Maximum expected loss over specific time horizon at given confidence level.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Assumes normal distribution for parametric VaR"],
            examples: [],
            relatedFormulas: ["expected-shortfall", "portfolio-variance"],
            tags: ["var", "risk", "downside", "confidence"]
        )
    }
    
    private func createExpectedShortfallFormula() -> FormulaReference {
        FormulaReference(
            name: "Expected Shortfall (CVaR)",
            category: .risk,
            level: .levelII,
            mainFormula: "ES = E[Loss | Loss > VaR]",
            description: "Expected loss given that loss exceeds VaR threshold.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Coherent risk measure unlike VaR"],
            examples: [],
            relatedFormulas: ["var", "tail-risk"],
            tags: ["expected-shortfall", "cvar", "tail-risk", "coherent"]
        )
    }
    
    private func createDownsideDeviationFormula() -> FormulaReference {
        FormulaReference(
            name: "Downside Deviation",
            category: .risk,
            level: .levelII,
            mainFormula: "DD = \\sqrt{\\frac{\\sum_{R_i < MAR} (R_i - MAR)^2}{n}}",
            description: "Standard deviation of returns below minimum acceptable return.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Focuses only on downside risk"],
            examples: [],
            relatedFormulas: ["sortino-ratio", "standard-deviation"],
            tags: ["downside", "deviation", "mar", "risk"]
        )
    }
    
    private func createMaximumDrawdownFormula() -> FormulaReference {
        FormulaReference(
            name: "Maximum Drawdown",
            category: .risk,
            level: .levelII,
            mainFormula: "MDD = \\frac{\\text{Trough Value} - \\text{Peak Value}}{\\text{Peak Value}}",
            description: "Largest peak-to-trough decline during specific period.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures worst-case historical loss"],
            examples: [],
            relatedFormulas: ["calmar-ratio", "recovery-time"],
            tags: ["drawdown", "peak-to-trough", "worst-case"]
        )
    }
    
    // Alternative Investments formulas
    private func createRealEstateCapRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Capitalization Rate",
            category: .alternatives,
            level: .levelI,
            mainFormula: "\\text{Cap Rate} = \\frac{\\text{Net Operating Income}}{\\text{Property Value}}",
            description: "Return rate based on income-generating property's net operating income.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher cap rate may indicate higher risk or lower growth"],
            examples: [],
            relatedFormulas: ["noi", "property-value"],
            tags: ["cap-rate", "real-estate", "noi", "yield"]
        )
    }
    
    private func createPrivateEquityIRRFormula() -> FormulaReference {
        FormulaReference(
            name: "Private Equity IRR",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\sum_{t=0}^n \\frac{CF_t}{(1+IRR)^t} = 0",
            description: "Internal rate of return for private equity investments with irregular cash flows.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Must be solved iteratively"],
            examples: [],
            relatedFormulas: ["multiple-of-money", "dpi"],
            tags: ["irr", "private-equity", "cash-flows"]
        )
    }
    
    private func createHedgeFundSharpeFormula() -> FormulaReference {
        FormulaReference(
            name: "Hedge Fund Sharpe Ratio",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Sharpe} = \\frac{R_{fund} - R_f}{\\sigma_{fund}}",
            description: "Risk-adjusted return measure for hedge fund performance.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["May be biased due to non-normal return distributions"],
            examples: [],
            relatedFormulas: ["sortino-ratio", "calmar-ratio"],
            tags: ["sharpe", "hedge-fund", "risk-adjusted"]
        )
    }
    
    // Economics & FRA formulas
    private func createCurrentRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Current Ratio",
            category: .economics,
            level: .levelI,
            mainFormula: "\\text{Current Ratio} = \\frac{\\text{Current Assets}}{\\text{Current Liabilities}}",
            description: "Liquidity ratio measuring ability to pay short-term obligations.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Ratio > 1 indicates good liquidity position"],
            examples: [],
            relatedFormulas: ["quick-ratio", "cash-ratio"],
            tags: ["current-ratio", "liquidity", "financial-analysis"]
        )
    }
    
    private func createROEFormula() -> FormulaReference {
        FormulaReference(
            name: "Return on Equity (ROE)",
            category: .economics,
            level: .levelI,
            mainFormula: "ROE = \\frac{\\text{Net Income}}{\\text{Average Shareholders' Equity}}",
            description: "Profitability measure showing return generated on shareholders' equity.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher ROE generally indicates better performance"],
            examples: [],
            relatedFormulas: ["roa", "dupont-analysis"],
            tags: ["roe", "profitability", "equity", "financial-ratios"]
        )
    }
    
    private func createDuPontFormula() -> FormulaReference {
        FormulaReference(
            name: "DuPont Analysis",
            category: .economics,
            level: .levelI,
            mainFormula: "ROE = \\frac{\\text{Net Income}}{\\text{Sales}} \\times \\frac{\\text{Sales}}{\\text{Assets}} \\times \\frac{\\text{Assets}}{\\text{Equity}}",
            description: "Decomposition of ROE into profit margin, asset turnover, and equity multiplier.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Helps identify sources of ROE performance"],
            examples: [],
            relatedFormulas: ["roe", "profit-margin", "asset-turnover"],
            tags: ["dupont", "roe", "decomposition", "analysis"]
        )
    }
    
    private func createDebtToEquityFormula() -> FormulaReference {
        FormulaReference(
            name: "Debt-to-Equity Ratio",
            category: .economics,
            level: .levelI,
            mainFormula: "\\frac{D}{E} = \\frac{\\text{Total Debt}}{\\text{Total Equity}}",
            description: "Leverage ratio measuring financial leverage and capital structure.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher ratio indicates more leverage and financial risk"],
            examples: [],
            relatedFormulas: ["debt-to-capital", "equity-multiplier"],
            tags: ["debt-equity", "leverage", "capital-structure"]
        )
    }
    
    // MARK: - Missing Essential Formulas
    
    private func createSwapSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "Swap Spread",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Swap Spread} = \\text{Swap Rate} - \\text{Treasury Rate}",
            description: "Difference between the fixed rate on an interest rate swap and the yield on a government bond of similar maturity. Indicates credit and liquidity risk in the swap market.",
            variables: [
                FormulaVariable(symbol: "\\text{Swap Rate}", name: "Interest Rate Swap Fixed Rate", description: "Fixed rate paid on interest rate swap", units: "Percentage", typicalRange: "0% to 15%", notes: "Typically quoted annually"),
                FormulaVariable(symbol: "\\text{Treasury Rate}", name: "Government Bond Yield", description: "Yield on treasury bond of similar maturity", units: "Percentage", typicalRange: "0% to 10%", notes: "Risk-free benchmark rate")
            ],
            derivation: FormulaDerivation(
                title: "Swap Spread Economic Interpretation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Swap represents credit risk premium", formula: "\\text{Credit Risk} = \\text{Swap Rate} - \\text{Risk-Free Rate}", explanation: "Swap counterparty has default risk unlike government"),
                    DerivationStep(stepNumber: 2, description: "Include liquidity premium", formula: "\\text{Liquidity Premium} = \\text{Additional compensation for illiquidity}", explanation: "Swaps may be less liquid than government bonds"),
                    DerivationStep(stepNumber: 3, description: "Total spread decomposition", formula: "\\text{Swap Spread} = \\text{Credit Risk} + \\text{Liquidity Premium}", explanation: "Combined risk premiums explain the spread")
                ],
                assumptions: [
                    "Similar duration and maturity",
                    "Fixed-for-floating swap structure",
                    "No embedded options in either instrument",
                    "Active and liquid markets for both securities"
                ],
                notes: "Swap spreads tend to widen during periods of financial stress and narrow during stable periods."
            ),
            variants: [
                FormulaVariant(name: "Interpolated Swap Spread", formula: "\\text{Spread} = \\text{Swap Rate} - \\text{Interpolated Treasury}", description: "When no exact maturity match exists", whenToUse: "For off-the-run maturities"),
                FormulaVariant(name: "Asset Swap Spread", formula: "\\text{ASW} = \\text{Bond Yield} - \\text{Swap Rate}", description: "Bond yield versus swap rate", whenToUse: "For credit bond analysis"),
                FormulaVariant(name: "Z-Spread to Swaps", formula: "\\text{Z-Spread} = \\text{Constant spread over swap curve}", description: "Option-adjusted spread measure", whenToUse: "For bonds with embedded options")
            ],
            usageNotes: [
                "Positive swap spreads indicate credit/liquidity premium",
                "Widening spreads suggest increasing market stress",
                "Used for relative value analysis in fixed income",
                "Important benchmark for corporate bond pricing",
                "Swap spreads can be negative during flight-to-quality periods"
            ],
            examples: [
                FormulaExample(
                    title: "10-Year Swap Spread Calculation",
                    description: "Calculate swap spread with 10-year swap at 4.25% and 10-year Treasury at 3.75%",
                    inputs: ["Swap Rate": "4.25%", "Treasury Rate": "3.75%"],
                    calculation: "Swap Spread = 4.25% - 3.75%",
                    result: "50 basis points",
                    interpretation: "Market requires 50bp premium for swap credit/liquidity risk"
                )
            ],
            relatedFormulas: ["ted-spread", "libor-ois-spread", "credit-spread"],
            tags: ["swap", "spread", "credit-risk", "liquidity", "fixed-income"]
        )
    }
    
    private func createTEDSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "TED Spread",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{TED Spread} = \\text{3-Month LIBOR} - \\text{3-Month Treasury Bill Rate}",
            description: "Difference between 3-month LIBOR and 3-month Treasury bill rate. Key indicator of credit risk and liquidity conditions in money markets.",
            variables: [
                FormulaVariable(symbol: "\\text{LIBOR}", name: "London Interbank Offered Rate", description: "Rate at which banks lend to each other", units: "Percentage", typicalRange: "0% to 8%", notes: "Unsecured interbank lending rate"),
                FormulaVariable(symbol: "\\text{T-Bill Rate}", name: "Treasury Bill Rate", description: "Yield on 3-month government bill", units: "Percentage", typicalRange: "0% to 6%", notes: "Risk-free money market rate")
            ],
            derivation: FormulaDerivation(
                title: "TED Spread as Credit Risk Indicator",
                steps: [
                    DerivationStep(stepNumber: 1, description: "LIBOR represents bank credit risk", formula: "\\text{LIBOR} = \\text{Risk-Free Rate} + \\text{Bank Credit Premium}", explanation: "Banks face default risk unlike government"),
                    DerivationStep(stepNumber: 2, description: "Treasury bills are risk-free", formula: "\\text{T-Bill Rate} \\approx \\text{Risk-Free Rate}", explanation: "Government bills have minimal default risk"),
                    DerivationStep(stepNumber: 3, description: "TED captures bank risk premium", formula: "\\text{TED} = \\text{Bank Credit Premium} + \\text{Liquidity Premium}", explanation: "Difference reflects banking sector health")
                ],
                assumptions: [
                    "Both rates have similar 3-month maturity",
                    "Actively traded and liquid markets",
                    "LIBOR reflects true interbank conditions",
                    "Treasury bills remain risk-free benchmark"
                ],
                notes: "TED spread typically ranges from 10-50 basis points in normal conditions, widening to 100+ basis points during crises."
            ),
            variants: [
                FormulaVariant(name: "Eurodollar-Treasury Spread", formula: "\\text{Eurodollar Futures Rate} - \\text{Treasury Rate}", description: "Futures-based TED spread", whenToUse: "For forward-looking risk assessment"),
                FormulaVariant(name: "LIBOR-OIS Spread", formula: "\\text{LIBOR} - \\text{Overnight Index Swap Rate}", description: "Alternative credit risk measure", whenToUse: "When OIS markets are more liquid"),
                FormulaVariant(name: "SOFR-Treasury Spread", formula: "\\text{SOFR} - \\text{Treasury Rate}", description: "Post-LIBOR alternative spread", whenToUse: "In SOFR transition period")
            ],
            usageNotes: [
                "Normal TED spread: 10-50 basis points",
                "Crisis TED spread: 100-400+ basis points",
                "Key money market stress indicator",
                "Used by central banks for policy assessment",
                "Higher spreads indicate banking sector stress",
                "LIBOR being phased out in favor of SOFR"
            ],
            examples: [
                FormulaExample(
                    title: "Normal Market Conditions",
                    description: "Calculate TED spread with 3M LIBOR at 2.35% and 3M T-Bill at 2.10%",
                    inputs: ["3M LIBOR": "2.35%", "3M T-Bill": "2.10%"],
                    calculation: "TED = 2.35% - 2.10%",
                    result: "25 basis points",
                    interpretation: "Normal money market conditions with typical credit premium"
                ),
                FormulaExample(
                    title: "Crisis Conditions",
                    description: "During 2008 crisis: 3M LIBOR at 4.82%, 3M T-Bill at 0.16%",
                    inputs: ["3M LIBOR": "4.82%", "3M T-Bill": "0.16%"],
                    calculation: "TED = 4.82% - 0.16%",
                    result: "466 basis points",
                    interpretation: "Extreme stress indicating severe banking sector concerns"
                )
            ],
            relatedFormulas: ["swap-spread", "libor-ois-spread", "credit-spread"],
            tags: ["ted-spread", "libor", "treasury", "credit-risk", "money-market", "crisis-indicator"]
        )
    }
    
    private func createLIBOROISSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "LIBOR-OIS Spread",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{LIBOR-OIS} = \\text{LIBOR} - \\text{OIS Rate}",
            description: "Difference between LIBOR and Overnight Index Swap rate of same tenor. Pure measure of bank credit risk, excluding duration and interest rate risk.",
            variables: [
                FormulaVariable(symbol: "\\text{LIBOR}", name: "London Interbank Offered Rate", description: "Unsecured interbank lending rate", units: "Percentage", typicalRange: "0% to 8%", notes: "Term funding rate with credit risk"),
                FormulaVariable(symbol: "\\text{OIS Rate}", name: "Overnight Index Swap Rate", description: "Risk-free rate for same tenor", units: "Percentage", typicalRange: "0% to 6%", notes: "Secured/risk-free alternative to LIBOR")
            ],
            derivation: FormulaDerivation(
                title: "LIBOR-OIS as Pure Credit Spread",
                steps: [
                    DerivationStep(stepNumber: 1, description: "LIBOR includes credit risk", formula: "\\text{LIBOR} = \\text{OIS} + \\text{Credit Premium} + \\text{Liquidity Premium}", explanation: "LIBOR has bank default risk component"),
                    DerivationStep(stepNumber: 2, description: "OIS is risk-free rate", formula: "\\text{OIS} = \\text{Expected average overnight rate}", explanation: "OIS based on secured overnight funding"),
                    DerivationStep(stepNumber: 3, description: "Spread isolates credit risk", formula: "\\text{LIBOR-OIS} = \\text{Credit Premium} + \\text{Liquidity Premium}", explanation: "Duration risk cancels out with same tenor")
                ],
                assumptions: [
                    "Same tenor for LIBOR and OIS",
                    "OIS represents risk-free benchmark",
                    "Active markets in both instruments",
                    "Credit and liquidity risks are separable"
                ],
                notes: "LIBOR-OIS spread is considered purer credit risk measure than TED spread as it eliminates government vs. interbank rate differences."
            ),
            variants: [
                FormulaVariant(name: "Basis Swap Spread", formula: "\\text{LIBOR} - \\text{Fed Funds Rate}", description: "Alternative policy rate comparison", whenToUse: "When OIS markets less liquid"),
                FormulaVariant(name: "SOFR-OIS Spread", formula: "\\text{SOFR} - \\text{OIS Rate}", description: "Post-LIBOR equivalent measure", whenToUse: "In SOFR transition environment"),
                FormulaVariant(name: "Cross-Currency Basis", formula: "\\text{USD LIBOR} - \\text{FX-Hedged Foreign LIBOR}", description: "Cross-currency funding costs", whenToUse: "For international bank funding analysis")
            ],
            usageNotes: [
                "Typical range: 5-30 basis points in normal conditions",
                "Crisis range: 50-350+ basis points",
                "More precise credit risk measure than TED spread",
                "Key indicator for central bank liquidity operations",
                "Used in bank funding cost analysis",
                "Important for derivatives pricing and risk management"
            ],
            examples: [
                FormulaExample(
                    title: "Pre-Crisis Normal Conditions",
                    description: "3M LIBOR at 5.25%, 3M OIS at 5.15%",
                    inputs: ["3M LIBOR": "5.25%", "3M OIS": "5.15%"],
                    calculation: "LIBOR-OIS = 5.25% - 5.15%",
                    result: "10 basis points",
                    interpretation: "Normal bank credit premium in stable conditions"
                ),
                FormulaExample(
                    title: "Financial Crisis Peak",
                    description: "3M LIBOR at 4.75%, 3M OIS at 1.90%",
                    inputs: ["3M LIBOR": "4.75%", "3M OIS": "1.90%"],
                    calculation: "LIBOR-OIS = 4.75% - 1.90%",
                    result: "285 basis points",
                    interpretation: "Severe banking stress with massive credit premium"
                )
            ],
            relatedFormulas: ["ted-spread", "swap-spread", "basis-swap"],
            tags: ["libor-ois", "credit-risk", "bank-funding", "liquidity", "interbank", "crisis-indicator"]
        )
    }
    
    private func createPutCallParityExactFormula() -> FormulaReference {
        FormulaReference(
            name: "Put-Call Parity (Comprehensive)",
            category: .derivatives,
            level: .levelI,
            mainFormula: "C + \\frac{X}{(1+r)^T} = P + S_0 e^{-qT}",
            description: "Fundamental arbitrage relationship between European call and put options on dividend-paying stocks. Essential for options pricing and synthetic instrument creation.",
            variables: [
                FormulaVariable(symbol: "C", name: "Call Option Price", description: "European call option premium", units: "Currency", typicalRange: "$0 to $S_0", notes: "Cannot exceed underlying stock price"),
                FormulaVariable(symbol: "P", name: "Put Option Price", description: "European put option premium", units: "Currency", typicalRange: "$0 to $X", notes: "Cannot exceed strike price"),
                FormulaVariable(symbol: "S_0", name: "Current Stock Price", description: "Spot price of underlying asset", units: "Currency", typicalRange: "$1 to unlimited", notes: "Market price at option initiation"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Exercise price of options", units: "Currency", typicalRange: "$1 to unlimited", notes: "Fixed at option contract inception"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded risk-free rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Government bond rate matching option maturity"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time remaining until option expiration", units: "Years", typicalRange: "0 to 5 years", notes: "Expressed as fraction of year"),
                FormulaVariable(symbol: "q", name: "Continuous Dividend Yield", description: "Annualized dividend yield", units: "Percentage", typicalRange: "0% to 8%", notes: "Continuously compounded dividend rate")
            ],
            derivation: FormulaDerivation(
                title: "Put-Call Parity from No-Arbitrage",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Construct equivalent portfolios", formula: "\\text{Portfolio A: } C + \\frac{X}{(1+r)^T}", explanation: "Long call plus present value of strike"),
                    DerivationStep(stepNumber: 2, description: "Alternative portfolio", formula: "\\text{Portfolio B: } P + S_0 e^{-qT}", explanation: "Long put plus dividend-adjusted stock"),
                    DerivationStep(stepNumber: 3, description: "At expiration if } S_T > X", formula: "\\text{A payoff: } (S_T - X) + X = S_T", explanation: "Call exercised, bond matures"),
                    DerivationStep(stepNumber: 4, description: "At expiration if } S_T > X", formula: "\\text{B payoff: } 0 + S_T = S_T", explanation: "Put worthless, stock held"),
                    DerivationStep(stepNumber: 5, description: "At expiration if } S_T < X", formula: "\\text{A payoff: } 0 + X = X", explanation: "Call worthless, bond matures"),
                    DerivationStep(stepNumber: 6, description: "At expiration if } S_T < X", formula: "\\text{B payoff: } (X - S_T) + S_T = X", explanation: "Put exercised, stock sold"),
                    DerivationStep(stepNumber: 7, description: "Equal payoffs require equal prices", formula: "C + \\frac{X}{(1+r)^T} = P + S_0 e^{-qT}", explanation: "No-arbitrage condition")
                ],
                assumptions: [
                    "European-style options (exercise only at expiration)",
                    "No transaction costs or bid-ask spreads",
                    "Unlimited borrowing and lending at risk-free rate",
                    "Continuous dividend yield",
                    "No early exercise features",
                    "Perfect market liquidity"
                ],
                notes: "Put-call parity is exact for European options but approximate for American options due to early exercise premium."
            ),
            variants: [
                FormulaVariant(name: "No Dividends", formula: "C + \\frac{X}{(1+r)^T} = P + S_0", description: "When q = 0 (no dividends)", whenToUse: "For non-dividend paying stocks"),
                FormulaVariant(name: "Discrete Dividends", formula: "C + \\frac{X}{(1+r)^T} = P + S_0 - PV(\\text{Dividends})", description: "For known dividend payments", whenToUse: "When dividends are discrete payments"),
                FormulaVariant(name: "Forward-Start Options", formula: "C + \\frac{X}{(1+r)^T} = P + \\frac{F_{0,T}}{(1+r)^T}", description: "Using forward price", whenToUse: "For forward-based analysis"),
                FormulaVariant(name: "Currency Options", formula: "C + \\frac{X}{(1+r_d)^T} = P + S_0 e^{-r_f T}", description: "For foreign exchange options", whenToUse: "When underlying is foreign currency"),
                FormulaVariant(name: "American Bounds", formula: "S_0 - X \\leq C - P \\leq S_0 e^{-qT} - \\frac{X}{(1+r)^T}", description: "Bounds for American options", whenToUse: "For American option valuation")
            ],
            usageNotes: [
                "Exact relationship for European options only",
                "Arbitrage opportunity exists if parity violated",
                "Used to price one option given the other three values",
                "Essential for creating synthetic positions",
                "Market makers use for hedging and pricing",
                "Violations may indicate market inefficiencies",
                "American options have early exercise premium affecting parity"
            ],
            examples: [
                FormulaExample(
                    title: "Dividend-Paying Stock",
                    description: "Stock at $100, call at $8, put at $3, strike $105, r=5%, T=0.25, q=2%",
                    inputs: ["S₀": "$100", "C": "$8", "P": "$3", "X": "$105", "r": "5%", "T": "0.25", "q": "2%"],
                    calculation: "LHS = $8 + $105/(1.05)^0.25 = $8 + $103.71 = $111.71\\nRHS = $3 + $100×e^(-0.02×0.25) = $3 + $99.50 = $102.50",
                    result: "Parity violated: $111.71 ≠ $102.50",
                    interpretation: "Arbitrage opportunity exists - call overpriced relative to put"
                )
            ],
            relatedFormulas: ["black-scholes", "synthetic-positions", "option-bounds"],
            tags: ["put-call-parity", "arbitrage", "european-options", "synthetic", "no-arbitrage", "derivatives"]
        )
    }
    
    // Additional formulas would continue here with similar comprehensive treatment...
    // For brevity, I'll create simplified versions of the remaining methods
    
    private func createGreeksCollectionFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Greeks (Complete Collection)",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Delta = \\frac{\\partial V}{\\partial S}, \\Gamma = \\frac{\\partial^2 V}{\\partial S^2}, \\Theta = \\frac{\\partial V}{\\partial t}, \\text{Vega} = \\frac{\\partial V}{\\partial \\sigma}, \\text{Rho} = \\frac{\\partial V}{\\partial r}",
            description: "Complete collection of option price sensitivities to underlying parameters. Essential for options risk management and delta hedging strategies.",
            variables: [
                FormulaVariable(symbol: "\\Delta", name: "Delta", description: "Price sensitivity to underlying price", units: "Unitless", typicalRange: "0 to 1 (call), -1 to 0 (put)", notes: "Hedge ratio for delta-neutral positions"),
                FormulaVariable(symbol: "\\Gamma", name: "Gamma", description: "Rate of change of delta", units: "Per dollar", typicalRange: "0 to 0.1", notes: "Convexity measure, highest for at-the-money options"),
                FormulaVariable(symbol: "\\Theta", name: "Theta", description: "Time decay", units: "Per day", typicalRange: "-$10 to $0", notes: "Always negative for long options"),
                FormulaVariable(symbol: "\\text{Vega}", name: "Vega", description: "Volatility sensitivity", units: "Per 1% volatility", typicalRange: "$0 to $50", notes: "Highest for at-the-money, long-dated options"),
                FormulaVariable(symbol: "\\text{Rho}", name: "Rho", description: "Interest rate sensitivity", units: "Per 1% rate change", typicalRange: "$0 to $50", notes: "More significant for longer-dated options")
            ],
            derivation: nil,
            variants: [
                FormulaVariant(name: "Speed", formula: "\\text{Speed} = \\frac{\\partial \\Gamma}{\\partial S}", description: "Rate of change of gamma", whenToUse: "For advanced gamma hedging"),
                FormulaVariant(name: "Color", formula: "\\text{Color} = \\frac{\\partial \\Gamma}{\\partial t}", description: "Time decay of gamma", whenToUse: "For time-dependent gamma hedging"),
                FormulaVariant(name: "Vanna", formula: "\\text{Vanna} = \\frac{\\partial \\text{Vega}}{\\partial S}", description: "Cross-derivative: volatility-price", whenToUse: "For volatility-delta hedging")
            ],
            usageNotes: [
                "Delta: Primary hedge ratio for price movements",
                "Gamma: Measures hedging frequency requirements",
                "Theta: Quantifies time decay cost",
                "Vega: Critical for volatility trading strategies",
                "Rho: Important for interest rate environment changes"
            ],
            examples: [],
            relatedFormulas: ["black-scholes", "delta-hedging", "option-pricing"],
            tags: ["greeks", "delta", "gamma", "theta", "vega", "rho", "risk-management"]
        )
    }
    
    private func createFuturesPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Futures Pricing",
            category: .derivatives,
            level: .levelI,
            mainFormula: "F_0 = S_0 e^{(r-q)T}",
            description: "No-arbitrage pricing formula for futures contracts on dividend-paying assets.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Assumes continuous dividends", "No storage costs included"],
            examples: [],
            relatedFormulas: ["forward-pricing", "cost-of-carry"],
            tags: ["futures", "pricing", "arbitrage", "cost-of-carry"]
        )
    }
    
    private func createCDSPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Credit Default Swap Pricing",
            category: .fixedIncome,
            level: .levelIII,
            mainFormula: "\\text{CDS Price} \\approx 1 + [(\\text{Fixed Coupon} - \\text{CDS Spread}) \\times \\text{EffSpreadDur}_{\\text{CDS}}]",
            description: "Approximate pricing formula for credit default swaps based on spread duration.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Approximation for small spread changes", "Assumes constant recovery rate"],
            examples: [],
            relatedFormulas: ["credit-spread", "spread-duration"],
            tags: ["cds", "credit-default-swap", "credit-risk", "derivatives"]
        )
    }
    
    private func createImplementationShortfallFormula() -> FormulaReference {
        FormulaReference(
            name: "Implementation Shortfall",
            category: .portfolio,
            level: .levelIII,
            mainFormula: "\\text{IS} = \\text{Paper Return} - \\text{Actual Return}",
            description: "Measures the difference between the return on a notional trade and the actual portfolio return.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Comprehensive trading cost measure", "Includes market impact and timing costs"],
            examples: [],
            relatedFormulas: ["trading-costs", "market-impact"],
            tags: ["implementation-shortfall", "trading-costs", "execution", "portfolio"]
        )
    }
    
    private func createCaptureRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Capture Ratio",
            category: .portfolio,
            level: .levelII,
            mainFormula: "\\text{Capture Ratio} = \\frac{\\text{Upside Capture}}{\\text{Downside Capture}}",
            description: "Measures how well a portfolio captures upside versus downside market movements.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher ratios indicate better performance", "Ratio > 1.0 is desirable"],
            examples: [],
            relatedFormulas: ["beta", "market-timing"],
            tags: ["capture-ratio", "performance", "market-timing", "risk-adjusted"]
        )
    }
    
    private func createCalmarRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Calmar Ratio",
            category: .risk,
            level: .levelII,
            mainFormula: "\\text{Calmar Ratio} = \\frac{\\text{Annualized Return}}{\\text{Maximum Drawdown}}",
            description: "Risk-adjusted return measure using maximum drawdown as the risk metric.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher ratios indicate better risk-adjusted performance", "Focuses on downside risk"],
            examples: [],
            relatedFormulas: ["maximum-drawdown", "sharpe-ratio"],
            tags: ["calmar-ratio", "drawdown", "risk-adjusted", "performance"]
        )
    }
}
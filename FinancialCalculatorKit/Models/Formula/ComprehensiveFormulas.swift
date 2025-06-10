//
//  ComprehensiveFormulas.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import SwiftUI

/// Extension containing comprehensive CFA formulas with detailed derivations
extension FormulaDatabase {
    
    func loadComprehensiveFormulas() {
        // Append comprehensive formulas to the existing collection
        formulas.append(contentsOf: [
            // MARK: - Core Time Value of Money Formulas
            createPresentValueFormula(),
            createFutureValueFormula(),
            createAnnuityPresentValueFormula(),
            createAnnuityFutureValueFormula(),
            createPerpetuityFormula(),
            createGrowingPerpetuityFormula(),
            createEffectiveAnnualRateFormula(),
            createContinuousCompoundingFormula(),
            
            // MARK: - Advanced Fixed Income Formulas
            createEffectiveDurationFormula(),
            createBondConvexityDetailedFormula(),
            createYieldSpreadFormula(),
            createCreditSpreadFormula(),
            
            // MARK: - Advanced Equity Formulas
            createWACCFormula(),
            
            // MARK: - Comprehensive Derivatives Formulas
            createDeltaFormula(),
            createGammaFormula(),
            createThetaFormula(),
            createVegaFormula(),
            createRhoFormula(),
            
            // MARK: - Portfolio Theory and Performance
            createSortinoRatioFormula(),
            createCalmarRatioFormula(),
            
            // MARK: - Economics and FRA
            createFinancialLeverageFormula(),
            createOperatingLeverageFormula(),
            createCombinedLeverageFormula(),
            createCashConversionCycleFormula(),
            createZScoreFormula(),
            createAltmanZScoreFormula(),
            
            // MARK: - Advanced Economics and FRA
            createGrinoldKronerModelFormula()
        ])
    }
    
    // MARK: - Advanced Fixed Income Formulas
    
    private func createEffectiveDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Effective Duration",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "D_{eff} = \\frac{P_{-\\Delta y} - P_{+\\Delta y}}{2 \\times P_0 \\times \\Delta y}",
            description: "Price sensitivity measure for bonds with embedded options, using option-adjusted pricing models.",
            variables: [
                FormulaVariable(symbol: "D_{eff}", name: "Effective Duration", description: "Duration for bonds with embedded options", units: "Years", typicalRange: "0 to 30", notes: "Accounts for option features"),
                FormulaVariable(symbol: "P_{-\\Delta y}", name: "Price when yield decreases", description: "Bond price when yield falls by Δy", units: "Currency", typicalRange: "Par ± premium/discount", notes: "Uses option-adjusted pricing"),
                FormulaVariable(symbol: "P_{+\\Delta y}", name: "Price when yield increases", description: "Bond price when yield rises by Δy", units: "Currency", typicalRange: "Par ± premium/discount", notes: "Uses option-adjusted pricing"),
                FormulaVariable(symbol: "P_0", name: "Current Bond Price", description: "Current market price of bond", units: "Currency", typicalRange: "Par ± premium/discount", notes: "Base price for calculation"),
                FormulaVariable(symbol: "\\Delta y", name: "Yield Change", description: "Small change in yield", units: "Percentage", typicalRange: "0.5% to 1%", notes: "Typically 50-100 basis points")
            ],
            derivation: FormulaDerivation(
                title: "Effective Duration Derivation for Callable Bonds",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with price-yield relationship", formula: "P = f(y)", explanation: "Bond price is a function of yield to maturity"),
                    DerivationStep(stepNumber: 2, description: "Apply first derivative definition", formula: "\\frac{dP}{dy} = \\lim_{\\Delta y \\to 0} \\frac{P(y + \\Delta y) - P(y)}{\\Delta y}", explanation: "Price sensitivity is the first derivative"),
                    DerivationStep(stepNumber: 3, description: "Use numerical approximation", formula: "\\frac{dP}{dy} \\approx \\frac{P_{-\\Delta y} - P_{+\\Delta y}}{2 \\times \\Delta y}", explanation: "Symmetric difference approximation"),
                    DerivationStep(stepNumber: 4, description: "Normalize by price", formula: "\\frac{1}{P} \\frac{dP}{dy} = \\frac{P_{-\\Delta y} - P_{+\\Delta y}}{2 \\times P_0 \\times \\Delta y}", explanation: "Express as percentage change"),
                    DerivationStep(stepNumber: 5, description: "Define effective duration", formula: "D_{eff} = -\\frac{1}{P} \\frac{dP}{dy}", explanation: "Duration is negative of relative price sensitivity"),
                    DerivationStep(stepNumber: 6, description: "Final effective duration formula", formula: "D_{eff} = \\frac{P_{-\\Delta y} - P_{+\\Delta y}}{2 \\times P_0 \\times \\Delta y}", explanation: "Practical calculation formula")
                ],
                assumptions: [
                    "Small parallel shifts in yield curve",
                    "Option-adjusted pricing used for P+ and P-",
                    "Yield changes are symmetric",
                    "No credit risk changes"
                ],
                notes: "Essential for bonds with embedded options where modified duration fails to capture option risk."
            ),
            variants: [
                FormulaVariant(name: "Key Rate Duration", formula: "D_{KR} = \\frac{P_{-\\Delta y_i} - P_{+\\Delta y_i}}{2 \\times P_0 \\times \\Delta y_i}", description: "Duration for specific maturity bucket", whenToUse: "For non-parallel yield curve shifts"),
                FormulaVariant(name: "Option-Adjusted Duration", formula: "D_{OA} = D_{straight} - D_{option}", description: "Duration adjusted for embedded option", whenToUse: "When separating bond and option components")
            ],
            usageNotes: [
                "More accurate than modified duration for callable/putable bonds",
                "Requires sophisticated pricing models (binomial trees, Monte Carlo)",
                "Computationally intensive compared to modified duration",
                "Essential for portfolio immunization with option bonds"
            ],
            examples: [
                FormulaExample(
                    title: "Callable Corporate Bond",
                    description: "Calculate effective duration for 5% callable bond, current price $102, when yield ±0.5%",
                    inputs: ["P₀": "$102.00", "P₋": "$104.50", "P₊": "$99.20", "Δy": "0.5%"],
                    calculation: "Dₑff = (104.50 - 99.20) / (2 × 102.00 × 0.005) = 5.30 / 1.02",
                    result: "Dₑff = 5.20 years",
                    interpretation: "5.2% price change for 1% yield change, accounting for call option"
                )
            ],
            relatedFormulas: ["modified-duration", "convexity", "option-pricing"],
            tags: ["effective-duration", "callable-bonds", "option-risk", "sensitivity"]
        )
    }
    
    private func createBondConvexityDetailedFormula() -> FormulaReference {
        FormulaReference(
            name: "Bond Convexity (Detailed)",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "C = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{CF_t \\times t \\times (t+1)}{(1+y)^{t+2}}",
            description: "Second-order price sensitivity measure capturing curvature in price-yield relationship for better hedging accuracy.",
            variables: [
                FormulaVariable(symbol: "C", name: "Convexity", description: "Second-order price sensitivity", units: "Years²", typicalRange: "0 to 100", notes: "Always positive for standard bonds"),
                FormulaVariable(symbol: "P", name: "Bond Price", description: "Current bond price", units: "Currency", typicalRange: "Par ± premium/discount", notes: "Present value of all cash flows"),
                FormulaVariable(symbol: "CF_t", name: "Cash Flow at time t", description: "Coupon or principal payment", units: "Currency", typicalRange: "0 to face value", notes: "Includes both coupons and principal"),
                FormulaVariable(symbol: "t", name: "Time Period", description: "Time to each cash flow", units: "Years", typicalRange: "0.5 to 30", notes: "Measured in payment periods"),
                FormulaVariable(symbol: "y", name: "Yield to Maturity", description: "Bond's yield to maturity", units: "Percentage", typicalRange: "0% to 20%", notes: "Expressed as decimal in calculation"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Total number of payment periods", units: "Count", typicalRange: "1 to 60", notes: "Depends on maturity and payment frequency")
            ],
            derivation: FormulaDerivation(
                title: "Convexity Derivation from Taylor Series",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with bond pricing function", formula: "P(y) = \\sum_{t=1}^{n} \\frac{CF_t}{(1+y)^t}", explanation: "Bond price as function of yield"),
                    DerivationStep(stepNumber: 2, description: "Apply Taylor series expansion", formula: "P(y + \\Delta y) \\approx P(y) + P'(y)\\Delta y + \\frac{1}{2}P''(y)(\\Delta y)^2", explanation: "Second-order approximation"),
                    DerivationStep(stepNumber: 3, description: "Calculate first derivative", formula: "P'(y) = -\\sum_{t=1}^{n} \\frac{t \\times CF_t}{(1+y)^{t+1}}", explanation: "First-order price sensitivity"),
                    DerivationStep(stepNumber: 4, description: "Calculate second derivative", formula: "P''(y) = \\sum_{t=1}^{n} \\frac{t(t+1) \\times CF_t}{(1+y)^{t+2}}", explanation: "Second-order price sensitivity"),
                    DerivationStep(stepNumber: 5, description: "Define convexity", formula: "C = \\frac{1}{P} \\times P''(y)", explanation: "Normalize by current price"),
                    DerivationStep(stepNumber: 6, description: "Final convexity formula", formula: "C = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{CF_t \\times t \\times (t+1)}{(1+y)^{t+2}}", explanation: "Complete convexity calculation")
                ],
                assumptions: [
                    "Parallel shifts in yield curve",
                    "No default risk",
                    "Constant yield volatility",
                    "No embedded options"
                ],
                notes: "Convexity is always positive for standard bonds, providing beneficial asymmetric price behavior."
            ),
            variants: [
                FormulaVariant(name: "Effective Convexity", formula: "C_{eff} = \\frac{P_{-\\Delta y} + P_{+\\Delta y} - 2P_0}{P_0 \\times (\\Delta y)^2}", description: "Numerical convexity for option bonds", whenToUse: "For bonds with embedded options"),
                FormulaVariant(name: "Modified Convexity", formula: "C_{mod} = \\frac{C}{(1+y/m)^2}", description: "Adjusted for compounding frequency", whenToUse: "When matching duration calculation convention"),
                FormulaVariant(name: "Dollar Convexity", formula: "\\text{Dollar Convexity} = C \\times P", description: "Absolute convexity measure", whenToUse: "For portfolio aggregation")
            ],
            usageNotes: [
                "Higher convexity is beneficial - provides upside potential with downside protection",
                "Longer maturity and lower coupon bonds have higher convexity",
                "Essential for second-order hedging and immunization strategies",
                "Convexity decreases as yields rise (negative convexity for some bonds)",
                "Critical for managing large yield changes where duration alone is insufficient"
            ],
            examples: [
                FormulaExample(
                    title: "Long-Term Treasury Bond",
                    description: "Calculate convexity for 30-year Treasury with 3% coupon, YTM = 4%",
                    inputs: ["Maturity": "30 years", "Coupon": "3%", "YTM": "4%", "Face Value": "$1000"],
                    calculation: "Sum each cash flow weighted by t(t+1)/(1.04)^(t+2), normalize by price",
                    result: "C = 285.6",
                    interpretation: "High convexity due to long maturity provides significant price protection"
                )
            ],
            relatedFormulas: ["duration", "effective-convexity", "price-approximation"],
            tags: ["convexity", "second-order", "hedging", "immunization", "curvature"]
        )
    }
    
    private func createWACCFormula() -> FormulaReference {
        FormulaReference(
            name: "Weighted Average Cost of Capital (WACC)",
            category: .equity,
            level: .levelII,
            mainFormula: "WACC = \\frac{E}{V} \\times r_e + \\frac{D}{V} \\times r_d \\times (1-T)",
            description: "Cost of capital reflecting the proportional costs of equity and debt financing, used as discount rate for firm valuation.",
            variables: [
                FormulaVariable(symbol: "WACC", name: "Weighted Average Cost of Capital", description: "Firm's overall cost of capital", units: "Percentage", typicalRange: "5% to 20%", notes: "Discount rate for firm valuation"),
                FormulaVariable(symbol: "E", name: "Market Value of Equity", description: "Total market capitalization", units: "Currency", typicalRange: "Millions to billions", notes: "Shares outstanding × Stock price"),
                FormulaVariable(symbol: "D", name: "Market Value of Debt", description: "Total market value of debt", units: "Currency", typicalRange: "Millions to billions", notes: "Use market values, not book values"),
                FormulaVariable(symbol: "V", name: "Total Firm Value", description: "E + D", units: "Currency", typicalRange: "Millions to billions", notes: "Enterprise value"),
                FormulaVariable(symbol: "r_e", name: "Cost of Equity", description: "Required return on equity", units: "Percentage", typicalRange: "8% to 25%", notes: "Often calculated using CAPM"),
                FormulaVariable(symbol: "r_d", name: "Cost of Debt", description: "Before-tax cost of debt", units: "Percentage", typicalRange: "2% to 15%", notes: "Weighted average of all debt"),
                FormulaVariable(symbol: "T", name: "Tax Rate", description: "Marginal corporate tax rate", units: "Percentage", typicalRange: "15% to 35%", notes: "Creates debt tax shield")
            ],
            derivation: FormulaDerivation(
                title: "WACC Derivation from Value Weights",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define firm value", formula: "V = E + D", explanation: "Total firm value equals equity plus debt"),
                    DerivationStep(stepNumber: 2, description: "Weight each component", formula: "w_E = \\frac{E}{V}, \\quad w_D = \\frac{D}{V}", explanation: "Calculate value weights"),
                    DerivationStep(stepNumber: 3, description: "Account for tax shield", formula: "\\text{After-tax cost of debt} = r_d \\times (1-T)", explanation: "Interest payments are tax-deductible"),
                    DerivationStep(stepNumber: 4, description: "Combine weighted costs", formula: "WACC = w_E \\times r_e + w_D \\times r_d \\times (1-T)", explanation: "Weight each cost by value proportion"),
                    DerivationStep(stepNumber: 5, description: "Substitute weights", formula: "WACC = \\frac{E}{V} \\times r_e + \\frac{D}{V} \\times r_d \\times (1-T)", explanation: "Final WACC formula")
                ],
                assumptions: [
                    "Market value weights reflect target capital structure",
                    "Costs of capital remain constant",
                    "Debt provides full tax shield benefit",
                    "No financial distress costs",
                    "Perpetual debt assumption"
                ],
                notes: "WACC represents the minimum return required by all capital providers."
            ),
            variants: [
                FormulaVariant(name: "With Preferred Stock", formula: "WACC = \\frac{E}{V} r_e + \\frac{P}{V} r_p + \\frac{D}{V} r_d (1-T)", description: "Including preferred equity", whenToUse: "When firm has preferred stock"),
                FormulaVariant(name: "Multi-Currency WACC", formula: "WACC = \\sum_i \\frac{V_i}{V} \\times r_i", description: "For multinational firms", whenToUse: "Different currencies and tax rates"),
                FormulaVariant(name: "Levered Cost of Equity", formula: "r_e = r_u + (r_u - r_d) \\times \\frac{D}{E} \\times (1-T)", description: "Adjust unlevered cost for leverage", whenToUse: "When deriving cost of equity from unlevered beta")
            ],
            usageNotes: [
                "Use market values, not book values, for weights",
                "Cost of equity often estimated using CAPM",
                "Cost of debt should reflect current borrowing rates",
                "WACC changes with capital structure changes",
                "Primary discount rate for DCF firm valuation"
            ],
            examples: [
                FormulaExample(
                    title: "Technology Company WACC",
                    description: "Calculate WACC for firm with $2B equity, $500M debt, re=12%, rd=5%, T=25%",
                    inputs: ["E": "$2,000M", "D": "$500M", "re": "12%", "rd": "5%", "T": "25%"],
                    calculation: "WACC = (2000/2500) × 12% + (500/2500) × 5% × (1-0.25)",
                    result: "WACC = 10.35%",
                    interpretation: "Firm must earn 10.35% to satisfy all capital providers"
                )
            ],
            relatedFormulas: ["capm", "cost-of-debt", "enterprise-value", "fcff"],
            tags: ["wacc", "cost-of-capital", "discount-rate", "valuation", "capital-structure"]
        )
    }
    
    // Additional comprehensive formulas continue...
    // Due to length constraints, I'll provide key formulas with similar detail
    
    private func createBlackScholesCompleteFormula() -> FormulaReference {
        FormulaReference(
            name: "Black-Scholes-Merton Complete Model",
            category: .derivatives,
            level: .levelII,
            mainFormula: "C = S_0 e^{-qT} N(d_1) - X e^{-rT} N(d_2)",
            description: "Complete Black-Scholes formula including dividend yield for European options on dividend-paying stocks.",
            variables: [
                FormulaVariable(symbol: "C", name: "Call Option Price", description: "Fair value of European call option", units: "Currency", typicalRange: "$0 to stock price", notes: "Cannot exceed stock price"),
                FormulaVariable(symbol: "S_0", name: "Current Stock Price", description: "Current underlying asset price", units: "Currency", typicalRange: "$1 to $1000+", notes: "Market price of underlying"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Exercise price of option", units: "Currency", typicalRange: "$1 to $1000+", notes: "Fixed at option creation"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time remaining to expiration", units: "Years", typicalRange: "0 to 5", notes: "Expressed as fraction of year"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded risk-free rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Treasury rate with matching maturity"),
                FormulaVariable(symbol: "q", name: "Dividend Yield", description: "Continuous dividend yield", units: "Percentage", typicalRange: "0% to 8%", notes: "Expected dividend payments"),
                FormulaVariable(symbol: "\\sigma", name: "Volatility", description: "Annualized volatility of returns", units: "Percentage", typicalRange: "10% to 100%", notes: "Standard deviation of returns"),
                FormulaVariable(symbol: "N(x)", name: "Cumulative Normal", description: "Standard normal distribution function", units: "Probability", typicalRange: "0 to 1", notes: "Area under normal curve to the left of x")
            ],
            derivation: FormulaDerivation(
                title: "Black-Scholes PDE Solution with Dividends",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with risk-neutral pricing", formula: "C = e^{-rT} E^Q[\\max(S_T - X, 0)]", explanation: "Expected payoff under risk-neutral measure"),
                    DerivationStep(stepNumber: 2, description: "Asset follows geometric Brownian motion", formula: "dS = (r-q)S dt + \\sigma S dW", explanation: "Stock price dynamics with dividend yield"),
                    DerivationStep(stepNumber: 3, description: "Calculate d₁ parameter", formula: "d_1 = \\frac{\\ln(S_0/X) + (r-q+\\sigma^2/2)T}{\\sigma\\sqrt{T}}", explanation: "Standardized moneyness measure"),
                    DerivationStep(stepNumber: 4, description: "Calculate d₂ parameter", formula: "d_2 = d_1 - \\sigma\\sqrt{T}", explanation: "Adjusted for volatility term"),
                    DerivationStep(stepNumber: 5, description: "Apply boundary conditions", formula: "C(S,T) = \\max(S-X, 0)", explanation: "Option value at expiration"),
                    DerivationStep(stepNumber: 6, description: "Solve PDE", formula: "C = S_0 e^{-qT} N(d_1) - X e^{-rT} N(d_2)", explanation: "Complete Black-Scholes solution")
                ],
                assumptions: [
                    "Constant risk-free rate and volatility",
                    "Log-normal distribution of stock prices",
                    "No transaction costs or bid-ask spreads",
                    "Continuous trading and arbitrage possible",
                    "European exercise only",
                    "Constant dividend yield"
                ],
                notes: "The dividend yield adjustment makes this suitable for index options and dividend-paying stocks."
            ),
            variants: [
                FormulaVariant(name: "Put Option", formula: "P = X e^{-rT} N(-d_2) - S_0 e^{-qT} N(-d_1)", description: "Black-Scholes put formula", whenToUse: "For European put options"),
                FormulaVariant(name: "Currency Option", formula: "C = S_0 e^{-r_f T} N(d_1) - X e^{-r_d T} N(d_2)", description: "For currency options", whenToUse: "When underlying is foreign currency"),
                FormulaVariant(name: "Futures Option", formula: "C = e^{-rT}[F_0 N(d_1) - X N(d_2)]", description: "Black model for futures", whenToUse: "When underlying is futures contract")
            ],
            usageNotes: [
                "Volatility is the most critical and difficult parameter to estimate",
                "Model assumes European exercise - American options require binomial/trinomial trees",
                "Time decay accelerates as expiration approaches",
                "Delta hedging strategy emerges from model derivation",
                "Model breaks down for extreme market conditions"
            ],
            examples: [
                FormulaExample(
                    title: "S&P 500 Index Call Option",
                    description: "Price call option on SPY: S₀=$300, X=$310, T=0.25, r=2%, q=1.5%, σ=20%",
                    inputs: ["S₀": "$300", "X": "$310", "T": "0.25 years", "r": "2%", "q": "1.5%", "σ": "20%"],
                    calculation: "d₁ = -0.0521, d₂ = -0.1521, N(d₁) = 0.4792, N(d₂) = 0.4395",
                    result: "C = $5.88",
                    interpretation: "Out-of-money call has time value due to volatility and time remaining"
                )
            ],
            relatedFormulas: ["greeks", "put-call-parity", "binomial-model"],
            tags: ["black-scholes", "european-options", "dividends", "volatility", "risk-neutral"]
        )
    }
    
    // Placeholder implementations for remaining formulas
    // In a full implementation, each would have complete derivations like above
    
    private func createDeltaFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Delta",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Delta = \\frac{\\partial V}{\\partial S} = N(d_1) \\text{ (for calls)}",
            description: "First-order price sensitivity of option value to changes in underlying asset price. Critical for hedging and risk management.",
            variables: [
                FormulaVariable(symbol: "\\Delta", name: "Delta", description: "Option price sensitivity to underlying", units: "Unitless", typicalRange: "0 to 1 (calls), -1 to 0 (puts)", notes: "Change in option price per $1 change in stock"),
                FormulaVariable(symbol: "V", name: "Option Value", description: "Current option price", units: "Currency", typicalRange: "$0 to stock price", notes: "Call or put option value"),
                FormulaVariable(symbol: "S", name: "Stock Price", description: "Current underlying asset price", units: "Currency", typicalRange: "$1 to $1000+", notes: "Market price of underlying asset"),
                FormulaVariable(symbol: "N(d_1)", name: "Cumulative Normal Distribution", description: "Standard normal CDF evaluated at d₁", units: "Probability", typicalRange: "0 to 1", notes: "d₁ from Black-Scholes formula")
            ],
            derivation: FormulaDerivation(
                title: "Delta Derivation from Black-Scholes",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with Black-Scholes call formula", formula: "C = S_0 N(d_1) - X e^{-rT} N(d_2)", explanation: "Standard European call option price"),
                    DerivationStep(stepNumber: 2, description: "Take partial derivative with respect to S", formula: "\\frac{\\partial C}{\\partial S} = \\frac{\\partial}{\\partial S}[S_0 N(d_1) - X e^{-rT} N(d_2)]", explanation: "Apply partial differentiation"),
                    DerivationStep(stepNumber: 3, description: "Apply product rule to first term", formula: "\\frac{\\partial}{\\partial S}[S_0 N(d_1)] = N(d_1) + S_0 \\frac{\\partial N(d_1)}{\\partial S}", explanation: "Derivative of product S₀ × N(d₁)"),
                    DerivationStep(stepNumber: 4, description: "Use chain rule for N(d₁)", formula: "\\frac{\\partial N(d_1)}{\\partial S} = n(d_1) \\frac{\\partial d_1}{\\partial S}", explanation: "n(d₁) is standard normal PDF"),
                    DerivationStep(stepNumber: 5, description: "Calculate ∂d₁/∂S", formula: "\\frac{\\partial d_1}{\\partial S} = \\frac{1}{S \\sigma \\sqrt{T}}", explanation: "Derivative of d₁ with respect to stock price"),
                    DerivationStep(stepNumber: 6, description: "Show that second term cancels", formula: "S_0 n(d_1) \\frac{1}{S_0 \\sigma \\sqrt{T}} = X e^{-rT} n(d_2) \\frac{1}{S_0 \\sigma \\sqrt{T}}", explanation: "Mathematical identity from Black-Scholes derivation"),
                    DerivationStep(stepNumber: 7, description: "Final delta formula", formula: "\\Delta = N(d_1)", explanation: "Call delta equals N(d₁), put delta equals N(d₁) - 1")
                ],
                assumptions: [
                    "Black-Scholes assumptions hold (constant volatility, interest rate)",
                    "European exercise only",
                    "No dividends (or adjust d₁ for dividend yield)",
                    "Continuous trading"
                ],
                notes: "Delta is the hedge ratio - number of shares needed to hedge one option."
            ),
            variants: [
                FormulaVariant(name: "Put Delta", formula: "\\Delta_{put} = N(d_1) - 1", description: "Delta for put options", whenToUse: "For put option hedging"),
                FormulaVariant(name: "Delta with Dividends", formula: "\\Delta = e^{-qT} N(d_1)", description: "Call delta adjusted for dividend yield", whenToUse: "When underlying pays dividends"),
                FormulaVariant(name: "Forward Delta", formula: "\\Delta_{forward} = e^{-rT} N(d_1)", description: "Delta for options on forwards", whenToUse: "For options on futures/forwards")
            ],
            usageNotes: [
                "Call delta ranges from 0 to 1, put delta from -1 to 0",
                "At-the-money options have delta ≈ 0.5 (calls) or -0.5 (puts)",
                "Deep in-the-money calls have delta approaching 1",
                "Delta changes as stock price moves (measured by gamma)",
                "Use delta for initial hedge ratios in option portfolios"
            ],
            examples: [
                FormulaExample(
                    title: "Call Option Delta Calculation",
                    description: "Calculate delta for at-the-money call: S=$100, X=$100, r=5%, T=0.25, σ=20%",
                    inputs: ["S₀": "$100", "X": "$100", "r": "5%", "T": "0.25 years", "σ": "20%"],
                    calculation: "d₁ = [ln(100/100) + (0.05 + 0.04/2) × 0.25] / (0.20 × √0.25) = 0.175\\nΔ = N(0.175) = 0.5695",
                    result: "Δ = 0.57",
                    interpretation: "57 shares needed to hedge 100 call options, option price moves $0.57 per $1 stock move"
                )
            ],
            relatedFormulas: ["gamma", "black-scholes", "hedge-ratio"],
            tags: ["delta", "greeks", "hedging", "sensitivity", "risk-management"]
        )
    }
    
    private func createGammaFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Gamma",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Gamma = \\frac{\\partial^2 V}{\\partial S^2} = \\frac{\\phi(d_1)}{S_0 \\sigma \\sqrt{T}}",
            description: "Second-order price sensitivity measuring the rate of change of delta with respect to the underlying asset price. Critical for dynamic hedging.",
            variables: [
                FormulaVariable(symbol: "\\Gamma", name: "Gamma", description: "Second-order price sensitivity", units: "1/Currency", typicalRange: "0 to 0.1", notes: "Change in delta per $1 change in stock price"),
                FormulaVariable(symbol: "V", name: "Option Value", description: "Current option price", units: "Currency", typicalRange: "$0 to stock price", notes: "Call or put option value"),
                FormulaVariable(symbol: "S", name: "Stock Price", description: "Current underlying asset price", units: "Currency", typicalRange: "$1 to $1000+", notes: "Market price of underlying asset"),
                FormulaVariable(symbol: "\\phi(d_1)", name: "Normal PDF", description: "Standard normal probability density function evaluated at d₁", units: "Unitless", typicalRange: "0 to 0.4", notes: "Bell curve height at d₁"),
                FormulaVariable(symbol: "\\sigma", name: "Volatility", description: "Annualized volatility of underlying", units: "Percentage", typicalRange: "10% to 100%", notes: "Standard deviation of returns"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time remaining until expiration", units: "Years", typicalRange: "0 to 5", notes: "Expressed as fraction of year")
            ],
            derivation: FormulaDerivation(
                title: "Gamma Derivation from Delta",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with delta formula", formula: "\\Delta = N(d_1)", explanation: "Call option delta"),
                    DerivationStep(stepNumber: 2, description: "Take derivative of delta with respect to S", formula: "\\frac{\\partial \\Delta}{\\partial S} = \\frac{\\partial N(d_1)}{\\partial S}", explanation: "Gamma is the derivative of delta"),
                    DerivationStep(stepNumber: 3, description: "Apply chain rule", formula: "\\frac{\\partial N(d_1)}{\\partial S} = \\phi(d_1) \\frac{\\partial d_1}{\\partial S}", explanation: "Use normal PDF φ(d₁)"),
                    DerivationStep(stepNumber: 4, description: "Calculate derivative of d₁", formula: "\\frac{\\partial d_1}{\\partial S} = \\frac{1}{S \\sigma \\sqrt{T}}", explanation: "Partial derivative of d₁ with respect to S"),
                    DerivationStep(stepNumber: 5, description: "Combine terms", formula: "\\Gamma = \\phi(d_1) \\times \\frac{1}{S \\sigma \\sqrt{T}}", explanation: "Multiply PDF by derivative"),
                    DerivationStep(stepNumber: 6, description: "Final gamma formula", formula: "\\Gamma = \\frac{\\phi(d_1)}{S_0 \\sigma \\sqrt{T}}", explanation: "Complete gamma expression")
                ],
                assumptions: [
                    "Black-Scholes framework applies",
                    "Constant volatility and interest rates",
                    "Continuous trading",
                    "No transaction costs"
                ],
                notes: "Gamma is same for calls and puts with identical strikes and expirations."
            ),
            variants: [
                FormulaVariant(name: "Dollar Gamma", formula: "\\text{Dollar Gamma} = \\Gamma \\times S^2", description: "Dollar impact of gamma", whenToUse: "For portfolio P&L attribution"),
                FormulaVariant(name: "Gamma with Dividends", formula: "\\Gamma = \\frac{e^{-qT} \\phi(d_1)}{S_0 \\sigma \\sqrt{T}}", description: "Gamma adjusted for dividend yield", whenToUse: "For dividend-paying stocks"),
                FormulaVariant(name: "Percent Gamma", formula: "\\text{\\% Gamma} = \\Gamma \\times S", description: "Percentage gamma", whenToUse: "For relative comparisons")
            ],
            usageNotes: [
                "Gamma is highest for at-the-money options near expiration",
                "Gamma is always positive for long options (both calls and puts)",
                "High gamma requires frequent delta hedging (gamma scalping)",
                "Gamma decreases as options move in or out of the money",
                "Time decay accelerates gamma for near-expiration ATM options"
            ],
            examples: [
                FormulaExample(
                    title: "At-the-Money Call Gamma",
                    description: "Calculate gamma for ATM call: S=$100, X=$100, r=5%, T=0.25, σ=20%",
                    inputs: ["S₀": "$100", "X": "$100", "r": "5%", "T": "0.25 years", "σ": "20%"],
                    calculation: "d₁ = 0.175, φ(0.175) = 0.3935\\nΓ = 0.3935 / (100 × 0.20 × √0.25) = 0.0197",
                    result: "Γ = 0.0197",
                    interpretation: "Delta changes by 0.0197 for each $1 move in stock price"
                )
            ],
            relatedFormulas: ["delta", "theta", "convexity", "hedging"],
            tags: ["gamma", "greeks", "second-order", "curvature", "dynamic-hedging"]
        )
    }
    
    private func createThetaFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Theta",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Theta = \\frac{\\partial V}{\\partial t} = -\\frac{S_0 \\phi(d_1) \\sigma}{2\\sqrt{T}} - rX e^{-rT} N(d_2)",
            description: "Time decay measuring option value loss per day passing.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Always negative for long options, accelerates near expiration"],
            examples: [],
            relatedFormulas: ["delta", "gamma", "time-value"],
            tags: ["theta", "time-decay", "greeks"]
        )
    }
    
    private func createVegaFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Vega",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\nu = \\frac{\\partial V}{\\partial \\sigma} = S_0 \\sqrt{T} \\phi(d_1)",
            description: "Volatility sensitivity showing option price change per 1% volatility change.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Highest for at-the-money options with longer time to expiration"],
            examples: [],
            relatedFormulas: ["implied-volatility", "black-scholes"],
            tags: ["vega", "volatility", "greeks", "sensitivity"]
        )
    }
    
    private func createRhoFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Rho",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\rho = \\frac{\\partial V}{\\partial r} = XT e^{-rT} N(d_2) \\text{ (for calls)}",
            description: "Interest rate sensitivity showing option price change per 1% rate change.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Generally less important than other Greeks for equity options"],
            examples: [],
            relatedFormulas: ["black-scholes", "interest-rates"],
            tags: ["rho", "interest-rate", "greeks"]
        )
    }
    
    // Continue with remaining formulas...
    // Each would follow the same comprehensive pattern
    
    private func createSortinoRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Sortino Ratio",
            category: .portfolio,
            level: .levelII,
            mainFormula: "\\text{Sortino} = \\frac{R_p - MAR}{\\sigma_{downside}}",
            description: "Risk-adjusted return measure using downside deviation, focusing only on negative returns. Superior to Sharpe ratio for asymmetric return distributions.",
            variables: [
                FormulaVariable(symbol: "R_p", name: "Portfolio Return", description: "Average portfolio return", units: "Percentage", typicalRange: "-50% to 50%", notes: "Typically annualized return"),
                FormulaVariable(symbol: "MAR", name: "Minimum Acceptable Return", description: "Threshold return below which performance is considered poor", units: "Percentage", typicalRange: "0% to 10%", notes: "Often set to risk-free rate or target return"),
                FormulaVariable(symbol: "\\sigma_{downside}", name: "Downside Deviation", description: "Standard deviation of returns below MAR", units: "Percentage", typicalRange: "1% to 30%", notes: "Only considers negative deviations from MAR")
            ],
            derivation: FormulaDerivation(
                title: "Sortino Ratio Development",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Identify limitation of Sharpe ratio", formula: "\\text{Sharpe} = \\frac{R_p - R_f}{\\sigma_p}", explanation: "Sharpe ratio penalizes both upside and downside volatility equally"),
                    DerivationStep(stepNumber: 2, description: "Define downside returns", formula: "\\text{Downside Returns} = \\{r_t : r_t < MAR\\}", explanation: "Focus only on returns below minimum acceptable return"),
                    DerivationStep(stepNumber: 3, description: "Calculate downside variance", formula: "\\sigma_{downside}^2 = \\frac{1}{n} \\sum_{r_t < MAR} (r_t - MAR)^2", explanation: "Variance using only returns below MAR"),
                    DerivationStep(stepNumber: 4, description: "Take square root for deviation", formula: "\\sigma_{downside} = \\sqrt{\\frac{1}{n} \\sum_{r_t < MAR} (r_t - MAR)^2}", explanation: "Downside standard deviation"),
                    DerivationStep(stepNumber: 5, description: "Form Sortino ratio", formula: "\\text{Sortino} = \\frac{R_p - MAR}{\\sigma_{downside}}", explanation: "Risk-adjusted return using downside risk only")
                ],
                assumptions: [
                    "Investors care more about downside risk than upside volatility",
                    "MAR is appropriately chosen (often risk-free rate)",
                    "Sufficient number of observations below MAR",
                    "Return distribution may be non-normal"
                ],
                notes: "Sortino ratio addresses the criticism that Sharpe ratio penalizes beneficial upside volatility."
            ),
            variants: [
                FormulaVariant(name: "Upside Potential Ratio", formula: "UPR = \\frac{\\text{Upside Potential}}{\\sigma_{downside}}", description: "Uses upside potential in numerator", whenToUse: "When focusing on asymmetric performance"),
                FormulaVariant(name: "Gain-to-Pain Ratio", formula: "\\text{Gain-to-Pain} = \\frac{\\sum \\text{Positive Returns}}{|\\sum \\text{Negative Returns}|}", description: "Simple gain vs pain measure", whenToUse: "For intuitive risk communication"),
                FormulaVariant(name: "Kappa 3", formula: "\\text{Kappa 3} = \\frac{R_p - MAR}{\\sqrt[3]{\\text{Lower Partial Moment}_3}}", description: "Using third moment of downside", whenToUse: "For higher-order downside risk")
            ],
            usageNotes: [
                "Superior to Sharpe ratio for strategies with asymmetric returns",
                "Commonly used for hedge fund and alternative investment evaluation",
                "MAR choice significantly affects the ratio magnitude",
                "Requires sufficient negative return observations for reliable calculation",
                "Higher Sortino ratio indicates better downside risk-adjusted performance"
            ],
            examples: [
                FormulaExample(
                    title: "Hedge Fund Performance Evaluation",
                    description: "Calculate Sortino ratio for hedge fund with 12% return, 4% MAR, 8% downside deviation",
                    inputs: ["Portfolio Return": "12%", "MAR": "4%", "Downside Deviation": "8%"],
                    calculation: "Sortino = (12% - 4%) / 8% = 8% / 8%",
                    result: "Sortino = 1.00",
                    interpretation: "Fund generates 1% excess return per 1% downside risk"
                )
            ],
            relatedFormulas: ["sharpe-ratio", "downside-deviation", "var", "calmar-ratio"],
            tags: ["sortino", "downside-risk", "performance", "hedge-funds", "asymmetric-returns"]
        )
    }
    
    private func createCalmarRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Calmar Ratio",
            category: .portfolio,
            level: .levelII,
            mainFormula: "\\text{Calmar} = \\frac{\\text{Annual Return}}{\\text{Maximum Drawdown}}",
            description: "Risk-adjusted return using maximum drawdown as risk measure.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Popular measure for hedge fund performance evaluation"],
            examples: [],
            relatedFormulas: ["maximum-drawdown", "sharpe-ratio"],
            tags: ["calmar", "drawdown", "hedge-funds"]
        )
    }
    
    // Additional placeholder methods for remaining comprehensive formulas...
    // Each category would be fully implemented with detailed derivations
    
    private func createYieldSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "Yield Spread Analysis",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Spread} = YTM_{corporate} - YTM_{treasury}",
            description: "Credit risk premium reflected in yield difference between corporate and government bonds.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Wider spreads indicate higher perceived credit risk"],
            examples: [],
            relatedFormulas: ["ytm", "credit-risk"],
            tags: ["spread", "credit", "corporate-bonds"]
        )
    }
    
    private func createCreditSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "Credit Spread Models",
            category: .fixedIncome,
            level: .levelIII,
            mainFormula: "\\text{Credit Spread} = -\\frac{1}{T} \\ln(1 - PD \\times LGD)",
            description: "Theoretical credit spread based on probability of default and loss given default.",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Links credit metrics to bond pricing"],
            examples: [],
            relatedFormulas: ["probability-of-default", "loss-given-default"],
            tags: ["credit-spread", "default-risk", "structural-models"]
        )
    }
    
    // Continue with remaining comprehensive formulas...
    // This represents the structure for the complete implementation
    
    private func createBootstrappingFormula() -> FormulaReference {
        FormulaReference(name: "Bootstrap Method", category: .fixedIncome, level: .levelII, mainFormula: "S_n = \\sqrt[n]{\\frac{P_{n-1}}{P_n}} - 1", description: "Method to derive spot rates from bond prices.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bootstrap", "spot-rates"])
    }
    
    private func createForwardRateAgreementFormula() -> FormulaReference {
        FormulaReference(name: "Forward Rate Agreement", category: .derivatives, level: .levelII, mainFormula: "\\text{FRA Settlement} = \\frac{(r - r_{FRA}) \\times \\text{Notional} \\times \\text{Days}}{360 + r \\times \\text{Days}}", description: "Settlement amount for forward rate agreement.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fra", "forward-rates"])
    }
    
    private func createInterestRateSwapFormula() -> FormulaReference {
        FormulaReference(name: "Interest Rate Swap Valuation", category: .derivatives, level: .levelII, mainFormula: "\\text{Swap Value} = \\text{Fixed Bond} - \\text{Floating Bond}", description: "Valuation of plain vanilla interest rate swap.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["swap", "interest-rates"])
    }
    
    // Continue with placeholder implementations for all remaining formulas...
    // Each would eventually be fully implemented with complete derivations
    
    private func createMultiStageDDMFormula() -> FormulaReference {
        FormulaReference(name: "Multi-Stage DDM", category: .equity, level: .levelII, mainFormula: "P_0 = \\sum_{t=1}^{n_1} \\frac{D_0(1+g_1)^t}{(1+r)^t} + \\sum_{t=n_1+1}^{n_2} \\frac{D_{n_1}(1+g_2)^{t-n_1}}{(1+r)^t} + \\frac{P_{n_2}}{(1+r)^{n_2}}", description: "DDM with multiple growth phases.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ddm", "multi-stage"])
    }
    
    private func createEVAFormula() -> FormulaReference {
        FormulaReference(
            name: "Economic Value Added",
            category: .equity,
            level: .levelII,
            mainFormula: "EVA = NOPAT - (WACC \\times \\text{Invested Capital})",
            description: "Economic profit after cost of capital, measuring value creation above the cost of capital.",
            variables: [
                FormulaVariable(symbol: "EVA", name: "Economic Value Added", description: "Value created above cost of capital", units: "Currency", typicalRange: nil, notes: nil),
                FormulaVariable(symbol: "NOPAT", name: "Net Operating Profit After Taxes", description: "Operating profit after taxes but before financing costs", units: "Currency", typicalRange: nil, notes: nil),
                FormulaVariable(symbol: "WACC", name: "Weighted Average Cost of Capital", description: "Blended cost of debt and equity", units: "Percentage", typicalRange: "5%-15%", notes: nil),
                FormulaVariable(symbol: "IC", name: "Invested Capital", description: "Total capital invested in operations", units: "Currency", typicalRange: nil, notes: nil)
            ],
            derivation: FormulaDerivation(
                title: "Economic Value Added Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate NOPAT", formula: "NOPAT = EBIT \\times (1 - \\text{Tax Rate})", explanation: "After-tax operating profit available to all capital providers"),
                    DerivationStep(stepNumber: 2, description: "Calculate capital charge", formula: "\\text{Capital Charge} = WACC \\times \\text{Invested Capital}", explanation: "Cost of all invested capital based on weighted average cost"),
                    DerivationStep(stepNumber: 3, description: "Calculate EVA", formula: "EVA = NOPAT - \\text{Capital Charge}", explanation: "Subtract capital charge from operating profit to get economic profit")
                ],
                assumptions: ["WACC represents true cost of capital", "Invested capital includes all operating assets", "Tax rate is constant"],
                notes: "EVA is a key metric for measuring management performance in creating value above the cost of capital."
            ),
            variants: [
                FormulaVariant(name: "EVA Margin", formula: "\\text{EVA Margin} = \\frac{EVA}{\\text{Sales}}", description: "EVA as percentage of sales", whenToUse: "For profitability analysis"),
                FormulaVariant(name: "Market Value Added", formula: "MVA = \\text{Market Value} - \\text{Invested Capital}", description: "Total value created", whenToUse: "For total shareholder value measurement")
            ],
            usageNotes: [
                "Positive EVA indicates value creation",
                "Requires accurate calculation of invested capital",
                "Adjustments may be needed for accounting distortions",
                "Useful for performance-based compensation"
            ],
            examples: [
                FormulaExample(
                    title: "Manufacturing Company EVA",
                    description: "Company with NOPAT $50M, WACC 10%, Invested Capital $400M",
                    inputs: ["NOPAT": "$50M", "WACC": "10%", "Invested Capital": "$400M"],
                    calculation: "EVA = $50M - (10% × $400M) = $50M - $40M",
                    result: "EVA = $10M",
                    interpretation: "Company created $10M in economic value above its cost of capital"
                )
            ],
            relatedFormulas: ["wacc", "nopat", "roic"],
            tags: ["eva", "economic-profit", "value-creation", "performance"]
        )
    }
    
    private func createLeverageBetaFormula() -> FormulaReference {
        FormulaReference(name: "Levered Beta", category: .equity, level: .levelII, mainFormula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D}{E}]", description: "Beta adjustment for financial leverage.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["beta", "leverage"])
    }
    
    private func createPEGRatioFormula() -> FormulaReference {
        FormulaReference(name: "PEG Ratio", category: .equity, level: .levelI, mainFormula: "PEG = \\frac{P/E}{\\text{Growth Rate}}", description: "P/E ratio adjusted for growth rate.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["peg", "growth", "valuation"])
    }
    
    private func createEVEBITFormula() -> FormulaReference {
        FormulaReference(
            name: "EV/EBIT Multiple",
            category: .equity,
            level: .levelI,
            mainFormula: "\\frac{EV}{EBIT} = \\frac{\\text{Enterprise Value}}{\\text{Earnings Before Interest and Tax}}",
            description: "Enterprise multiple for operating earnings, useful for comparing companies with different capital structures.",
            variables: [
                FormulaVariable(symbol: "EV", name: "Enterprise Value", description: "Market value of equity plus net debt", units: "Currency", typicalRange: nil, notes: nil),
                FormulaVariable(symbol: "EBIT", name: "Earnings Before Interest and Tax", description: "Operating earnings before financing costs", units: "Currency", typicalRange: nil, notes: nil)
            ],
            derivation: FormulaDerivation(
                title: "EV/EBIT Multiple Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate Enterprise Value", formula: "EV = \\text{Market Cap} + \\text{Total Debt} - \\text{Cash}", explanation: "Sum market value of equity and net debt"),
                    DerivationStep(stepNumber: 2, description: "Obtain EBIT from income statement", formula: "EBIT = \\text{Revenue} - \\text{Operating Expenses}", explanation: "Operating profit before financing costs"),
                    DerivationStep(stepNumber: 3, description: "Calculate the multiple", formula: "\\text{EV/EBIT Multiple} = \\frac{EV}{EBIT}", explanation: "Divide enterprise value by operating earnings")
                ],
                assumptions: ["EBIT represents normalized operating earnings", "Enterprise value reflects true cost to acquire the business"],
                notes: "EV/EBIT is preferred over P/E when comparing companies with different capital structures."
            ),
            variants: [
                FormulaVariant(name: "EV/EBITDA", formula: "\\frac{EV}{EBITDA}", description: "Includes depreciation and amortization", whenToUse: "For capital-intensive industries"),
                FormulaVariant(name: "P/E Ratio", formula: "\\frac{\\text{Price per Share}}{\\text{EPS}}", description: "Equity-based multiple", whenToUse: "When comparing similar capital structures")
            ],
            usageNotes: [
                "Useful for comparing companies with different capital structures",
                "Higher multiple may indicate growth expectations or overvaluation",
                "Industry-specific benchmarks are essential",
                "Consider cyclical nature of earnings"
            ],
            examples: [
                FormulaExample(
                    title: "Tech Company Valuation",
                    description: "Company with EV of $1.2B and EBIT of $200M",
                    inputs: ["EV": "$1.2B", "EBIT": "$200M"],
                    calculation: "EV/EBIT = $1.2B / $200M",
                    result: "6.0x",
                    interpretation: "Company trades at 6x its operating earnings"
                )
            ],
            relatedFormulas: ["ev-ebitda", "pe-ratio", "enterprise-value"],
            tags: ["ev-ebit", "multiple", "valuation", "equity"]
        )
    }
    
    private func createResidualIncomeToEquityFormula() -> FormulaReference {
        FormulaReference(name: "Residual Income to Equity", category: .equity, level: .levelII, mainFormula: "RI = \\text{Net Income} - (r_e \\times \\text{Book Value}_{t-1})", description: "Equity earnings above required return.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["residual-income", "equity"])
    }
    
    // Continue with all remaining comprehensive formulas following this pattern...
    // The complete implementation would include all formulas from the research document
    
    private func createBinomialTreeFormula() -> FormulaReference {
        FormulaReference(name: "Binomial Tree Model", category: .derivatives, level: .levelII, mainFormula: "V = \\frac{p \\times V_u + (1-p) \\times V_d}{1+r}", description: "Discrete-time option pricing model.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["binomial", "trees"])
    }
    
    private func createRiskNeutralProbabilityFormula() -> FormulaReference {
        FormulaReference(name: "Risk-Neutral Probability", category: .derivatives, level: .levelII, mainFormula: "p = \\frac{e^{rt} - d}{u - d}", description: "Probability measure for risk-neutral valuation.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["risk-neutral", "probability"])
    }
    
    private func createForwardPricingWithDividendsFormula() -> FormulaReference {
        FormulaReference(name: "Forward Pricing with Dividends", category: .derivatives, level: .levelII, mainFormula: "F_0 = (S_0 - PV(\\text{Dividends})) \\times e^{rT}", description: "Forward price adjusted for dividend payments.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["forward", "dividends"])
    }
    
    private func createCurrencyForwardFormula() -> FormulaReference {
        FormulaReference(name: "Currency Forward Pricing", category: .derivatives, level: .levelII, mainFormula: "F_0 = S_0 \\times e^{(r_d - r_f)T}", description: "Forward exchange rate based on interest rate differential.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["currency", "forward"])
    }
    
    private func createFRASettlementFormula() -> FormulaReference {
        FormulaReference(name: "FRA Settlement", category: .derivatives, level: .levelII, mainFormula: "\\text{Settlement} = \\frac{\\text{Notional} \\times (r - r_{FRA}) \\times \\text{Days}/360}{1 + r \\times \\text{Days}/360}", description: "Cash settlement for forward rate agreement.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fra", "settlement"])
    }
    
    private func createCAPItalAllocationLineFormula() -> FormulaReference {
        FormulaReference(name: "Capital Allocation Line", category: .portfolio, level: .levelI, mainFormula: "E(R_p) = R_f + \\frac{E(R_m) - R_f}{\\sigma_m} \\times \\sigma_p", description: "Risk-return tradeoff for portfolios combining risk-free asset and market portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cal", "portfolio-theory"])
    }
    
    private func createOptimalPortfolioFormula() -> FormulaReference {
        FormulaReference(name: "Optimal Portfolio Weights", category: .portfolio, level: .levelII, mainFormula: "w = \\frac{\\Sigma^{-1} \\mu}{\\mathbf{1}^T \\Sigma^{-1} \\mu}", description: "Optimal weights for mean-variance portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["optimal", "markowitz"])
    }
    
    private func createTrackingErrorFormula() -> FormulaReference {
        FormulaReference(name: "Tracking Error", category: .portfolio, level: .levelII, mainFormula: "TE = \\sqrt{\\text{Var}(R_p - R_b)}", description: "Standard deviation of active returns relative to benchmark.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["tracking-error", "active"])
    }
    
    private func createBattingAverageFormula() -> FormulaReference {
        FormulaReference(name: "Batting Average", category: .portfolio, level: .levelIII, mainFormula: "\\text{Batting Average} = \\frac{\\text{Number of periods with positive active return}}{\\text{Total number of periods}}", description: "Percentage of periods with outperformance.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["batting-average", "consistency"])
    }
    
    private func createMSquaredFormula() -> FormulaReference {
        FormulaReference(name: "M-Squared (M²)", category: .portfolio, level: .levelII, mainFormula: "M^2 = (R_p - R_f) \\times \\frac{\\sigma_m}{\\sigma_p} - (R_m - R_f)", description: "Risk-adjusted performance measure normalized to market volatility.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["m-squared", "risk-adjusted"])
    }
    
    private func createDownsideCaptureRatioFormula() -> FormulaReference {
        FormulaReference(name: "Downside Capture Ratio", category: .portfolio, level: .levelIII, mainFormula: "\\text{Downside Capture} = \\frac{\\text{Portfolio return in down markets}}{\\text{Market return in down markets}}", description: "Percentage of market decline captured by portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["downside-capture", "defensive"])
    }
    
    private func createUpsideCaptureRatioFormula() -> FormulaReference {
        FormulaReference(name: "Upside Capture Ratio", category: .portfolio, level: .levelIII, mainFormula: "\\text{Upside Capture} = \\frac{\\text{Portfolio return in up markets}}{\\text{Market return in up markets}}", description: "Percentage of market gains captured by portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["upside-capture", "participation"])
    }
    
    // Continue with remaining categories...
    // Full implementation would include all categories with complete formulas
    
    private func createCreditVaRFormula() -> FormulaReference {
        FormulaReference(name: "Credit Value at Risk", category: .risk, level: .levelIII, mainFormula: "\\text{Credit VaR} = \\text{UL} \\times z_{\\alpha} + \\text{EL}", description: "Maximum expected credit loss at confidence level.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["credit-var", "unexpected-loss"])
    }
    
    private func createExpectedLossFormula() -> FormulaReference {
        FormulaReference(name: "Expected Loss", category: .risk, level: .levelII, mainFormula: "EL = PD \\times LGD \\times EAD", description: "Expected credit loss from default events.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["expected-loss", "credit"])
    }
    
    private func createUnexpectedLossFormula() -> FormulaReference {
        FormulaReference(name: "Unexpected Loss", category: .risk, level: .levelIII, mainFormula: "UL = EAD \\times \\sqrt{PD \\times LGD^2 \\times (1-PD) + LGD^2 \\times PD \\times (1-PD)}", description: "Standard deviation of credit losses.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["unexpected-loss", "credit-risk"])
    }
    
    private func createBaselCapitalRatioFormula() -> FormulaReference {
        FormulaReference(name: "Basel Capital Ratio", category: .risk, level: .levelIII, mainFormula: "\\text{Capital Ratio} = \\frac{\\text{Tier 1 + Tier 2 Capital}}{\\text{Risk-Weighted Assets}}", description: "Regulatory capital adequacy measure.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["basel", "capital", "regulatory"])
    }
    
    private func createLiquidityRiskFormula() -> FormulaReference {
        FormulaReference(name: "Liquidity Coverage Ratio", category: .risk, level: .levelIII, mainFormula: "LCR = \\frac{\\text{High Quality Liquid Assets}}{\\text{Net Cash Outflows over 30 days}}", description: "Short-term liquidity risk measure.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity", "lcr"])
    }
    
    private func createStressTestingFormula() -> FormulaReference {
        FormulaReference(name: "Stress Testing", category: .risk, level: .levelIII, mainFormula: "\\text{Stressed Loss} = \\sum_i w_i \\times \\text{Scenario Loss}_i", description: "Portfolio loss under stress scenarios.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["stress-testing", "scenarios"])
    }
    
    // Alternative Investments
    private func createPrivateEquityMetricsFormula() -> FormulaReference {
        FormulaReference(name: "Private Equity Metrics", category: .alternatives, level: .levelII, mainFormula: "TVPI = \\frac{\\text{Distributions} + \\text{Remaining Value}}{\\text{Paid-in Capital}}", description: "Total value to paid-in capital multiple.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["tvpi", "private-equity"])
    }
    
    private func createRealEstateMetricsFormula() -> FormulaReference {
        FormulaReference(name: "Real Estate Investment Metrics", category: .alternatives, level: .levelII, mainFormula: "\\text{FFO} = \\text{Net Income} + \\text{Depreciation} - \\text{Gains on Sales}", description: "Funds from operations for REITs.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ffo", "reit"])
    }
    
    private func createCommodityPricingFormula() -> FormulaReference {
        FormulaReference(name: "Commodity Futures Pricing", category: .alternatives, level: .levelII, mainFormula: "F_0 = S_0 e^{(r+c-y)T}", description: "Futures price with storage costs and convenience yield.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["commodities", "futures"])
    }
    
    private func createHedgeFundMetricsFormula() -> FormulaReference {
        FormulaReference(name: "Hedge Fund Performance Metrics", category: .alternatives, level: .levelII, mainFormula: "\\text{Alpha} = R_p - [R_f + \\beta_1(R_{mkt} - R_f) + \\beta_2 \\text{SMB} + \\beta_3 \\text{HML}]", description: "Multi-factor alpha for hedge funds.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hedge-fund", "alpha"])
    }
    
    // Quantitative Methods
    private func createRegressionAnalysisFormula() -> FormulaReference {
        FormulaReference(name: "Multiple Regression", category: .quantitative, level: .levelII, mainFormula: "Y = \\beta_0 + \\beta_1 X_1 + \\beta_2 X_2 + ... + \\beta_k X_k + \\varepsilon", description: "Multiple linear regression model.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression", "multiple"])
    }
    
    private func createTimeSeriesFormula() -> FormulaReference {
        FormulaReference(name: "Autoregressive Model", category: .quantitative, level: .levelII, mainFormula: "x_t = c + \\phi_1 x_{t-1} + \\phi_2 x_{t-2} + ... + \\phi_p x_{t-p} + \\varepsilon_t", description: "AR(p) time series model.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["time-series", "ar"])
    }
    
    private func createMonteCarloFormula() -> FormulaReference {
        FormulaReference(name: "Monte Carlo Simulation", category: .quantitative, level: .levelII, mainFormula: "\\hat{\\theta} = \\frac{1}{n} \\sum_{i=1}^{n} g(X_i)", description: "Monte Carlo estimator for expected values.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["monte-carlo", "simulation"])
    }
    
    private func createBootstrapMethodFormula() -> FormulaReference {
        FormulaReference(name: "Bootstrap Confidence Interval", category: .quantitative, level: .levelII, mainFormula: "CI = [\\hat{\\theta}_{\\alpha/2}, \\hat{\\theta}_{1-\\alpha/2}]", description: "Bootstrap confidence interval for parameter estimates.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bootstrap", "confidence-interval"])
    }
    
    private func createHypothesisTestingFormula() -> FormulaReference {
        FormulaReference(name: "Hypothesis Testing", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{\\bar{x} - \\mu_0}{s/\\sqrt{n}}", description: "t-test for population mean.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hypothesis", "t-test"])
    }
    
    // Economics and FRA
    private func createFinancialLeverageFormula() -> FormulaReference {
        FormulaReference(name: "Financial Leverage", category: .economics, level: .levelI, mainFormula: "FL = \\frac{\\text{Average Total Assets}}{\\text{Average Shareholders' Equity}}", description: "Measure of financial leverage through asset-to-equity ratio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage", "financial"])
    }
    
    private func createOperatingLeverageFormula() -> FormulaReference {
        FormulaReference(name: "Operating Leverage", category: .economics, level: .levelI, mainFormula: "DOL = \\frac{\\text{Contribution Margin}}{\\text{Operating Income}}", description: "Degree of operating leverage measuring fixed cost impact.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["operating-leverage", "fixed-costs"])
    }
    
    private func createCombinedLeverageFormula() -> FormulaReference {
        FormulaReference(name: "Combined Leverage", category: .economics, level: .levelI, mainFormula: "DCL = DOL \\times DFL", description: "Combined effect of operating and financial leverage.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["combined-leverage", "total-risk"])
    }
    
    private func createCashConversionCycleFormula() -> FormulaReference {
        FormulaReference(name: "Cash Conversion Cycle", category: .economics, level: .levelI, mainFormula: "CCC = DIO + DSO - DPO", description: "Time required to convert investments into cash flows.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-cycle", "working-capital"])
    }
    
    private func createZScoreFormula() -> FormulaReference {
        FormulaReference(name: "Z-Score", category: .economics, level: .levelI, mainFormula: "Z = \\frac{x - \\mu}{\\sigma}", description: "Standardized score for normal distribution.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["z-score", "standardized"])
    }
    
    private func createAltmanZScoreFormula() -> FormulaReference {
        FormulaReference(name: "Altman Z-Score", category: .economics, level: .levelII, mainFormula: "Z = 1.2A + 1.4B + 3.3C + 0.6D + 1.0E", description: "Bankruptcy prediction model using financial ratios.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["altman", "bankruptcy", "credit"])
    }
    
    // MARK: - Additional Critical CFA Level III Formulas
    
    private func createAssetLiabilityMatchingFormula() -> FormulaReference {
        FormulaReference(
            name: "Asset-Liability Duration Matching",
            category: .portfolio,
            level: .levelIII,
            mainFormula: "D_A \\times \\frac{A}{A-L} = D_L \\times \\frac{L}{A-L}",
            description: "Duration matching condition for asset-liability management to immunize portfolio surplus against interest rate changes.",
            variables: [
                FormulaVariable(symbol: "D_A", name: "Asset Duration", description: "Modified duration of asset portfolio", units: "Years", typicalRange: "1 to 20", notes: "Weighted average duration of all assets"),
                FormulaVariable(symbol: "D_L", name: "Liability Duration", description: "Modified duration of liability portfolio", units: "Years", typicalRange: "1 to 30", notes: "Weighted average duration of all liabilities"),
                FormulaVariable(symbol: "A", name: "Market Value of Assets", description: "Total market value of asset portfolio", units: "Currency", typicalRange: "Millions to billions", notes: "Current market values"),
                FormulaVariable(symbol: "L", name: "Market Value of Liabilities", description: "Present value of liability portfolio", units: "Currency", typicalRange: "Millions to billions", notes: "Discounted at current rates"),
                FormulaVariable(symbol: "A-L", name: "Surplus", description: "Net worth or surplus", units: "Currency", typicalRange: "Can be negative", notes: "Difference between assets and liabilities")
            ],
            derivation: FormulaDerivation(
                title: "Surplus Duration Immunization",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define surplus", formula: "S = A - L", explanation: "Surplus is assets minus liabilities"),
                    DerivationStep(stepNumber: 2, description: "Take derivative with respect to interest rates", formula: "\\frac{dS}{dr} = \\frac{dA}{dr} - \\frac{dL}{dr}", explanation: "Change in surplus due to rate changes"),
                    DerivationStep(stepNumber: 3, description: "Apply duration approximation", formula: "\\frac{dA}{dr} \\approx -D_A \\times A \\times dr", explanation: "Duration approximation for assets"),
                    DerivationStep(stepNumber: 4, description: "Apply duration to liabilities", formula: "\\frac{dL}{dr} \\approx -D_L \\times L \\times dr", explanation: "Duration approximation for liabilities"),
                    DerivationStep(stepNumber: 5, description: "Substitute into surplus equation", formula: "\\frac{dS}{dr} = -D_A \\times A \\times dr + D_L \\times L \\times dr", explanation: "Combine asset and liability effects"),
                    DerivationStep(stepNumber: 6, description: "Set change in surplus to zero", formula: "-D_A \\times A + D_L \\times L = 0", explanation: "Immunization condition"),
                    DerivationStep(stepNumber: 7, description: "Solve for duration matching", formula: "D_A \\times A = D_L \\times L", explanation: "Duration-weighted values must be equal")
                ],
                assumptions: [
                    "Parallel shifts in yield curve",
                    "Duration approximation is accurate for small rate changes",
                    "No convexity effects",
                    "Continuous rebalancing possible"
                ],
                notes: "This is the fundamental immunization condition for asset-liability management."
            ),
            variants: [
                FormulaVariant(name: "Surplus Duration", formula: "D_S = \\frac{D_A \\times A - D_L \\times L}{A - L}", description: "Duration of surplus itself", whenToUse: "For direct surplus risk measurement"),
                FormulaVariant(name: "Leverage-Adjusted Duration", formula: "D_{LA} = D_A \\times \\frac{A}{A-L} - D_L \\times \\frac{L}{A-L}", description: "Surplus duration in terms of leverage", whenToUse: "When expressing in leverage terms"),
                FormulaVariant(name: "Pension Fund Matching", formula: "D_{Assets} = D_{Liabilities} \\times \\text{Funding Ratio}", description: "Simplified pension fund version", whenToUse: "For fully funded pension plans")
            ],
            usageNotes: [
                "Critical for pension fund and insurance company management",
                "Requires regular rebalancing as durations change over time",
                "Higher leverage amplifies interest rate sensitivity",
                "Convexity matching may be needed for large rate changes",
                "Asset allocation must consider both return and duration targets"
            ],
            examples: [
                FormulaExample(
                    title: "Pension Fund Immunization",
                    description: "Pension fund with $100M assets (duration 8), $80M liabilities (duration 12)",
                    inputs: ["Assets": "$100M", "DA": "8 years", "Liabilities": "$80M", "DL": "12 years"],
                    calculation: "Check: 8 × 100 = 800, 12 × 80 = 960\\nNot matched: need to adjust asset duration",
                    result: "Required DA = (12 × 80) / 100 = 9.6 years",
                    interpretation: "Asset duration must increase to 9.6 years for immunization"
                )
            ],
            relatedFormulas: ["duration", "immunization", "convexity", "liability-driven-investment"],
            tags: ["asset-liability", "immunization", "pension", "insurance", "duration-matching"]
        )
    }
    
    private func createBlackLittermanFormula() -> FormulaReference {
        FormulaReference(
            name: "Black-Litterman Expected Returns",
            category: .portfolio,
            level: .levelIII,
            mainFormula: "E[R] = \\left[(\\tau\\Sigma)^{-1} + P^T\\Omega^{-1}P\\right]^{-1}\\left[(\\tau\\Sigma)^{-1}\\Pi + P^T\\Omega^{-1}Q\\right]",
            description: "Bayesian approach to portfolio optimization combining market equilibrium with investor views to generate expected returns.",
            variables: [
                FormulaVariable(symbol: "E[R]", name: "Expected Returns", description: "Black-Litterman expected returns", units: "Percentage", typicalRange: "5% to 15%", notes: "Adjusted for investor views"),
                FormulaVariable(symbol: "\\tau", name: "Tau", description: "Uncertainty parameter", units: "Unitless", typicalRange: "0.01 to 1", notes: "Controls weight on equilibrium vs views"),
                FormulaVariable(symbol: "\\Sigma", name: "Covariance Matrix", description: "Historical asset covariance matrix", units: "Variance", typicalRange: "Positive definite", notes: "Asset return covariances"),
                FormulaVariable(symbol: "\\Pi", name: "Implied Returns", description: "Market equilibrium returns", units: "Percentage", typicalRange: "3% to 12%", notes: "From reverse optimization"),
                FormulaVariable(symbol: "P", name: "Picking Matrix", description: "Views specification matrix", units: "Unitless", typicalRange: "0 or 1", notes: "Links views to assets"),
                FormulaVariable(symbol: "\\Omega", name: "Omega", description: "Uncertainty matrix for views", units: "Variance", typicalRange: "Positive definite", notes: "Confidence in views"),
                FormulaVariable(symbol: "Q", name: "Views Vector", description: "Investor's expected returns", units: "Percentage", typicalRange: "Varies", notes: "Subjective view returns")
            ],
            derivation: FormulaDerivation(
                title: "Bayesian Update of Expected Returns",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with equilibrium returns", formula: "\\Pi = \\delta \\Sigma w_{market}", explanation: "Market-implied returns from CAPM"),
                    DerivationStep(stepNumber: 2, description: "Express prior distribution", formula: "R \\sim N(\\Pi, \\tau\\Sigma)", explanation: "Prior belief about returns"),
                    DerivationStep(stepNumber: 3, description: "Express investor views", formula: "PR = Q + \\varepsilon, \\quad \\varepsilon \\sim N(0, \\Omega)", explanation: "Views as linear combinations of returns"),
                    DerivationStep(stepNumber: 4, description: "Apply Bayes' theorem", formula: "p(R|views) \\propto p(views|R) \\times p(R)", explanation: "Combine prior with likelihood"),
                    DerivationStep(stepNumber: 5, description: "Derive posterior mean", formula: "E[R|views] = \\left[(\\tau\\Sigma)^{-1} + P^T\\Omega^{-1}P\\right]^{-1}\\left[(\\tau\\Sigma)^{-1}\\Pi + P^T\\Omega^{-1}Q\\right]", explanation: "Weighted average of prior and views"),
                    DerivationStep(stepNumber: 6, description: "Express in intuitive form", formula: "E[R] = \\Pi + \\tau\\Sigma P^T(P\\tau\\Sigma P^T + \\Omega)^{-1}(Q - P\\Pi)", explanation: "Prior plus adjustment based on views")
                ],
                assumptions: [
                    "Returns are normally distributed",
                    "Market is in equilibrium initially",
                    "Investor views are normally distributed",
                    "Covariance matrix is known and stable"
                ],
                notes: "Black-Litterman provides a systematic way to incorporate subjective views into portfolio optimization."
            ),
            variants: [
                FormulaVariant(name: "Simplified BL", formula: "E[R] = \\Pi + \\text{View Adjustment}", description: "Intuitive expression", whenToUse: "For conceptual understanding"),
                FormulaVariant(name: "BL with Factor Model", formula: "E[R] = \\alpha + \\beta F + \\varepsilon", description: "Factor-based implementation", whenToUse: "When using factor models"),
                FormulaVariant(name: "Idzorek Method", formula: "\\omega_{ii} = \\tau P_i \\Sigma P_i^T / \\text{confidence}^2", description: "Alternative omega specification", whenToUse: "When confidence levels are specified")
            ],
            usageNotes: [
                "Addresses the problem of unconstrained mean-variance optimization",
                "τ parameter significantly affects results - often set to 0.025-0.05",
                "Ω matrix specification is crucial but often ad hoc",
                "Views should be independent and well-researched",
                "Widely used by institutional asset managers"
            ],
            examples: [
                FormulaExample(
                    title: "Equity View Integration",
                    description: "Apply BL with view that US stocks will outperform international by 2%",
                    inputs: ["View": "US - Intl = 2%", "Confidence": "50%", "τ": "0.025"],
                    calculation: "Set P matrix to express relative view, calculate Ω from confidence level",
                    result: "Adjusted expected returns favor US equities",
                    interpretation: "Portfolio tilts toward US based on manager's view"
                )
            ],
            relatedFormulas: ["markowitz", "capm", "reverse-optimization", "bayesian-statistics"],
            tags: ["black-litterman", "bayesian", "portfolio-optimization", "views", "equilibrium"]
        )
    }
    
    private func createMonteCarloPortfolioFormula() -> FormulaReference {
        FormulaReference(
            name: "Monte Carlo Portfolio Simulation",
            category: .quantitative,
            level: .levelIII,
            mainFormula: "P(\\text{Goal Achievement}) = \\frac{\\text{Number of successful scenarios}}{\\text{Total scenarios}}",
            description: "Simulation-based approach to estimate probability of achieving investment goals under uncertainty.",
            variables: [
                FormulaVariable(symbol: "P", name: "Success Probability", description: "Probability of meeting investment goals", units: "Percentage", typicalRange: "0% to 100%", notes: "Based on simulation results"),
                FormulaVariable(symbol: "N", name: "Number of Scenarios", description: "Total number of simulated paths", units: "Count", typicalRange: "1,000 to 100,000", notes: "More scenarios = higher precision"),
                FormulaVariable(symbol: "S", name: "Successful Scenarios", description: "Number of scenarios meeting criteria", units: "Count", typicalRange: "0 to N", notes: "Scenarios achieving target")
            ],
            derivation: FormulaDerivation(
                title: "Monte Carlo Simulation Process",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define investment goal", formula: "\\text{Target} = W_T \\geq W_{goal}", explanation: "Specify what constitutes success"),
                    DerivationStep(stepNumber: 2, description: "Model return distributions", formula: "R_t \\sim f(\\mu, \\sigma, \\text{skew}, \\text{kurt})", explanation: "Specify return generating process"),
                    DerivationStep(stepNumber: 3, description: "Generate random scenarios", formula: "W_{t+1} = W_t(1 + R_{t+1}) - C_{t+1}", explanation: "Simulate wealth evolution with contributions/withdrawals"),
                    DerivationStep(stepNumber: 4, description: "Repeat for many paths", formula: "\\text{Repeat N times}", explanation: "Generate large number of scenarios"),
                    DerivationStep(stepNumber: 5, description: "Count successful outcomes", formula: "S = \\sum_{i=1}^N I(W_{T,i} \\geq W_{goal})", explanation: "Count scenarios meeting target"),
                    DerivationStep(stepNumber: 6, description: "Calculate probability", formula: "P = S/N", explanation: "Proportion of successful scenarios")
                ],
                assumptions: [
                    "Return distributions are correctly specified",
                    "Historical patterns continue into future",
                    "Cash flows occur as modeled",
                    "No model risk or extreme scenarios"
                ],
                notes: "Monte Carlo allows for complex cash flow patterns and non-normal return distributions."
            ),
            variants: [
                FormulaVariant(name: "Geometric Brownian Motion", formula: "dS = \\mu S dt + \\sigma S dW", description: "Continuous-time simulation", whenToUse: "For smooth price evolution"),
                FormulaVariant(name: "Bootstrap Simulation", formula: "\\text{Sample from historical returns}", description: "Non-parametric approach", whenToUse: "When avoiding distribution assumptions"),
                FormulaVariant(name: "Regime-Switching Model", formula: "R_t | S_t = \\mu_{S_t} + \\sigma_{S_t} \\varepsilon_t", description: "Multiple market regimes", whenToUse: "For modeling market cycles")
            ],
            usageNotes: [
                "Essential for retirement planning and liability-driven investing",
                "Allows modeling of complex cash flow patterns",
                "Can incorporate fat tails and skewness in returns",
                "Results depend heavily on input assumptions",
                "Should include stress testing and scenario analysis"
            ],
            examples: [
                FormulaExample(
                    title: "Retirement Planning",
                    description: "Simulate probability of maintaining $50K annual spending for 30 years",
                    inputs: ["Initial Portfolio": "$1M", "Annual Spending": "$50K", "Expected Return": "7%", "Volatility": "15%"],
                    calculation: "Run 10,000 scenarios, count how many maintain spending power",
                    result: "85% success probability",
                    interpretation: "85% chance of meeting retirement spending goals"
                )
            ],
            relatedFormulas: ["geometric-brownian-motion", "var", "stress-testing"],
            tags: ["monte-carlo", "simulation", "retirement-planning", "probability", "risk-management"]
        )
    }
    
    // MARK: - Missing Time Value of Money Formulas
    
    private func createMoneyWeightedReturnFormula() -> FormulaReference {
        FormulaReference(
            name: "Money-Weighted Return (IRR)",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\sum_{t=0}^{n} \\frac{CF_t}{(1+MWR)^t} = 0",
            description: "Internal rate of return that makes net present value of all cash flows equal to zero. Accounts for timing and size of cash flows.",
            variables: [
                FormulaVariable(symbol: "MWR", name: "Money-Weighted Return", description: "Internal rate of return", units: "Percentage", typicalRange: "-50% to 100%", notes: "Must be solved iteratively"),
                FormulaVariable(symbol: "CF_t", name: "Cash Flow at time t", description: "Cash inflow (+) or outflow (-)", units: "Currency", typicalRange: "Any value", notes: "Initial investment is negative"),
                FormulaVariable(symbol: "t", name: "Time Period", description: "Period number", units: "Years", typicalRange: "0 to n", notes: "t=0 is initial investment"),
                FormulaVariable(symbol: "n", name: "Total Periods", description: "Total number of periods", units: "Count", typicalRange: "1 to 50", notes: "Investment horizon")
            ],
            derivation: FormulaDerivation(
                title: "Money-Weighted Return Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with NPV equation", formula: "NPV = \\sum_{t=0}^{n} \\frac{CF_t}{(1+r)^t}", explanation: "Net present value of all cash flows"),
                    DerivationStep(stepNumber: 2, description: "Set NPV equal to zero", formula: "\\sum_{t=0}^{n} \\frac{CF_t}{(1+MWR)^t} = 0", explanation: "IRR is rate where NPV = 0"),
                    DerivationStep(stepNumber: 3, description: "Solve for MWR", formula: "MWR = \\text{rate that makes NPV = 0}", explanation: "Must be solved using numerical methods")
                ],
                assumptions: [
                    "Cash flows occur at end of each period",
                    "No intermediate cash flows are reinvested",
                    "Single discount rate applies to all periods"
                ],
                notes: "MWR is sensitive to timing and magnitude of cash flows, making it lower when large inflows occur late."
            ),
            variants: [
                FormulaVariant(name: "Modified IRR", formula: "MIRR = \\sqrt[n]{\\frac{FV_{positive}}{PV_{negative}}} - 1", description: "Uses different rates for financing and reinvestment", whenToUse: "When assuming different reinvestment rates"),
                FormulaVariant(name: "Dollar-Weighted Return", formula: "Same as MWR", description: "Alternative name for money-weighted return", whenToUse: "In portfolio performance context")
            ],
            usageNotes: [
                "MWR reflects performance of investor's actual experience",
                "Heavily influenced by timing of cash flows",
                "Lower than TWR when large inflows occur before poor performance",
                "Must be calculated using financial calculator or software",
                "Sensitive to cash flow timing - can be misleading for performance evaluation"
            ],
            examples: [
                FormulaExample(
                    title: "Portfolio Performance with Cash Flows",
                    description: "Portfolio: Initial $100k, add $50k after year 1, value $180k after year 2",
                    inputs: ["CF₀": "-$100,000", "CF₁": "-$50,000", "CF₂": "$180,000"],
                    calculation: "-100,000 + (-50,000)/(1+MWR) + 180,000/(1+MWR)² = 0",
                    result: "MWR = 9.54%",
                    interpretation: "Portfolio earned 9.54% accounting for additional investment timing"
                )
            ],
            relatedFormulas: ["time-weighted-return", "npv", "irr"],
            tags: ["mwr", "irr", "dollar-weighted", "cash-flows", "performance"]
        )
    }
    
    private func createTimeWeightedReturnFormula() -> FormulaReference {
        FormulaReference(
            name: "Time-Weighted Return",
            category: .quantitative,
            level: .levelI,
            mainFormula: "TWR = \\prod_{t=1}^{n} (1 + R_t) - 1",
            description: "Compound return that eliminates impact of cash flow timing, measuring pure investment performance over multiple periods.",
            variables: [
                FormulaVariable(symbol: "TWR", name: "Time-Weighted Return", description: "Geometric average return", units: "Percentage", typicalRange: "-50% to 100%", notes: "Pure investment performance"),
                FormulaVariable(symbol: "R_t", name: "Period Return", description: "Return in period t", units: "Percentage", typicalRange: "-100% to 500%", notes: "Calculated before any cash flows"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Total periods measured", units: "Count", typicalRange: "1 to 100", notes: "Each sub-period between cash flows")
            ],
            derivation: FormulaDerivation(
                title: "Time-Weighted Return Construction",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Break timeline at each cash flow", formula: "\\text{Periods: } [t_0, t_1], [t_1, t_2], ..., [t_{n-1}, t_n]", explanation: "Isolate periods between cash flows"),
                    DerivationStep(stepNumber: 2, description: "Calculate return for each sub-period", formula: "R_t = \\frac{V_{t,end} - V_{t,begin}}{V_{t,begin}}", explanation: "Pure investment return excluding cash flows"),
                    DerivationStep(stepNumber: 3, description: "Compound all sub-period returns", formula: "TWR = (1 + R_1)(1 + R_2)...(1 + R_n) - 1", explanation: "Geometric linking of returns"),
                    DerivationStep(stepNumber: 4, description: "Express as product notation", formula: "TWR = \\prod_{t=1}^{n} (1 + R_t) - 1", explanation: "Compact mathematical representation")
                ],
                assumptions: [
                    "Portfolio values are available at each cash flow date",
                    "Returns are calculated before cash flows affect portfolio",
                    "No performance fees or expenses during calculation periods"
                ],
                notes: "TWR removes the impact of cash flow timing, providing pure measure of investment skill."
            ),
            variants: [
                FormulaVariant(name: "Geometric Mean Return", formula: "G = \\sqrt[n]{\\prod_{t=1}^{n} (1 + R_t)} - 1", description: "Annualized TWR", whenToUse: "When expressing as annual rate"),
                FormulaVariant(name: "GIPS TWR", formula: "TWR = \\prod_{t=1}^{n} (1 + R_t) - 1", description: "GIPS-compliant calculation", whenToUse: "For performance reporting standards")
            ],
            usageNotes: [
                "Standard benchmark for investment manager performance",
                "Required by GIPS (Global Investment Performance Standards)",
                "Not affected by client's cash flow timing decisions", 
                "More complex to calculate than money-weighted return",
                "Best measure for comparing investment manager skill"
            ],
            examples: [
                FormulaExample(
                    title: "Portfolio Performance Evaluation",
                    description: "Portfolio: +10% year 1, -5% year 2, +15% year 3",
                    inputs: ["R₁": "10%", "R₂": "-5%", "R₃": "15%"],
                    calculation: "TWR = (1.10)(0.95)(1.15) - 1 = 1.2018 - 1",
                    result: "TWR = 20.18%",
                    interpretation: "Investment manager achieved 20.18% total return over 3 years"
                )
            ],
            relatedFormulas: ["money-weighted-return", "geometric-mean", "compound-return"],
            tags: ["twr", "geometric-return", "performance", "gips", "investment-management"]
        )
    }
    
    private func createSkewnessFormula() -> FormulaReference {
        FormulaReference(
            name: "Skewness",
            category: .quantitative,
            level: .levelI,
            mainFormula: "S = \\frac{\\frac{1}{n}\\sum_{i=1}^{n}(X_i - \\bar{X})^3}{\\sigma^3}",
            description: "Measure of asymmetry in return distribution. Indicates whether extreme values are more likely on upside or downside.",
            variables: [
                FormulaVariable(symbol: "S", name: "Skewness", description: "Measure of distribution asymmetry", units: "Unitless", typicalRange: "-3 to 3", notes: "Positive = right skewed, Negative = left skewed"),
                FormulaVariable(symbol: "X_i", name: "Individual Observation", description: "Each data point in sample", units: "Any", typicalRange: "Sample dependent", notes: "Raw data values"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Average of all observations", units: "Same as X", typicalRange: "Sample dependent", notes: "Central tendency measure"),
                FormulaVariable(symbol: "\\sigma", name: "Standard Deviation", description: "Measure of dispersion", units: "Same as X", typicalRange: "Always positive", notes: "Second moment"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "30+", notes: "Larger samples give better estimates")
            ],
            derivation: FormulaDerivation(
                title: "Skewness as Standardized Third Moment",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate deviations from mean", formula: "d_i = X_i - \\bar{X}", explanation: "Centered data around mean"),
                    DerivationStep(stepNumber: 2, description: "Cube the deviations", formula: "d_i^3 = (X_i - \\bar{X})^3", explanation: "Third power preserves sign of deviations"),
                    DerivationStep(stepNumber: 3, description: "Average the cubed deviations", formula: "\\text{Third Moment} = \\frac{1}{n}\\sum_{i=1}^{n}(X_i - \\bar{X})^3", explanation: "Unstandardized measure of asymmetry"),
                    DerivationStep(stepNumber: 4, description: "Standardize by cubed standard deviation", formula: "S = \\frac{\\text{Third Moment}}{\\sigma^3}", explanation: "Makes skewness unitless and comparable")
                ],
                assumptions: [
                    "Sample is representative of population",
                    "Data points are independent",
                    "No extreme outliers distorting calculation"
                ],
                notes: "Skewness > 0 indicates right tail is longer (positive skew), Skewness < 0 indicates left tail is longer (negative skew)."
            ),
            variants: [
                FormulaVariant(name: "Excess Skewness", formula: "\\text{Excess Skew} = S - 0", description: "Skewness relative to normal distribution", whenToUse: "When comparing to normal distribution"),
                FormulaVariant(name: "Fisher Skewness", formula: "g_1 = \\frac{\\sqrt{n(n-1)}}{n-2} \\times S", description: "Sample-adjusted skewness", whenToUse: "For small sample sizes")
            ],
            usageNotes: [
                "Normal distribution has skewness = 0",
                "Financial returns often exhibit negative skew (crash risk)",
                "Positive skew indicates frequent small losses, rare large gains",
                "Important for risk management and option pricing",
                "Sample skewness can be unreliable with small samples"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Return Skewness",
                    description: "Monthly returns: 2%, -1%, 3%, -5%, 8%, 1%, -2%, 4%",
                    inputs: ["n": "8", "Mean": "1.25%", "Std Dev": "3.92%"],
                    calculation: "Sum of cubed deviations = 0.000156, σ³ = 0.000060",
                    result: "S = -0.52",
                    interpretation: "Negative skew indicates higher probability of large losses than gains"
                )
            ],
            relatedFormulas: ["kurtosis", "standard-deviation", "variance"],
            tags: ["skewness", "asymmetry", "distribution", "third-moment", "risk"]
        )
    }
    
    private func createKurtosisFormula() -> FormulaReference {
        FormulaReference(
            name: "Kurtosis",
            category: .quantitative,
            level: .levelI,
            mainFormula: "K = \\frac{\\frac{1}{n}\\sum_{i=1}^{n}(X_i - \\bar{X})^4}{\\sigma^4}",
            description: "Measure of tail thickness and peakedness of distribution. Indicates likelihood of extreme values compared to normal distribution.",
            variables: [
                FormulaVariable(symbol: "K", name: "Kurtosis", description: "Fourth moment measure", units: "Unitless", typicalRange: "1 to 50", notes: "Normal distribution = 3"),
                FormulaVariable(symbol: "X_i", name: "Individual Observation", description: "Each data point", units: "Any", typicalRange: "Sample dependent", notes: "Raw observations"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Average value", units: "Same as X", typicalRange: "Sample dependent", notes: "Central value"),
                FormulaVariable(symbol: "\\sigma", name: "Standard Deviation", description: "Dispersion measure", units: "Same as X", typicalRange: "Always positive", notes: "Second moment"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "30+", notes: "Larger samples preferred")
            ],
            derivation: FormulaDerivation(
                title: "Kurtosis as Fourth Standardized Moment",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate centered deviations", formula: "d_i = X_i - \\bar{X}", explanation: "Remove location parameter"),
                    DerivationStep(stepNumber: 2, description: "Raise to fourth power", formula: "d_i^4 = (X_i - \\bar{X})^4", explanation: "Fourth power emphasizes extreme values"),
                    DerivationStep(stepNumber: 3, description: "Calculate fourth moment", formula: "\\text{Fourth Moment} = \\frac{1}{n}\\sum_{i=1}^{n}(X_i - \\bar{X})^4", explanation: "Average of fourth powers"),
                    DerivationStep(stepNumber: 4, description: "Standardize by fourth power of std dev", formula: "K = \\frac{\\text{Fourth Moment}}{\\sigma^4}", explanation: "Creates dimensionless measure")
                ],
                assumptions: [
                    "Representative sample of population",
                    "Independent observations",
                    "Finite fourth moment exists"
                ],
                notes: "High kurtosis indicates fat tails and sharp peak. Normal distribution has kurtosis = 3."
            ),
            variants: [
                FormulaVariant(name: "Excess Kurtosis", formula: "\\text{Excess Kurtosis} = K - 3", description: "Kurtosis relative to normal", whenToUse: "When comparing to normal distribution"),
                FormulaVariant(name: "Sample Kurtosis", formula: "k = \\frac{n(n+1)}{(n-1)(n-2)(n-3)} \\times \\frac{\\sum(X_i-\\bar{X})^4}{\\sigma^4} - \\frac{3(n-1)^2}{(n-2)(n-3)}", description: "Bias-corrected estimate", whenToUse: "For small samples")
            ],
            usageNotes: [
                "Kurtosis > 3 indicates leptokurtic (fat tails, sharp peak)",
                "Kurtosis < 3 indicates platykurtic (thin tails, flat peak)", 
                "Financial returns typically show excess kurtosis",
                "Important for VaR calculations and risk modeling",
                "Very sensitive to outliers"
            ],
            examples: [
                FormulaExample(
                    title: "Market Return Kurtosis",
                    description: "Daily S&P 500 returns showing fat-tail behavior",
                    inputs: ["Sample Size": "252 days", "Mean": "0.05%", "Std Dev": "1.2%"],
                    calculation: "Fourth moment = 0.000000048, σ⁴ = 0.000000021",
                    result: "K = 5.8",
                    interpretation: "Excess kurtosis of 2.8 indicates significantly fatter tails than normal"
                )
            ],
            relatedFormulas: ["skewness", "standard-deviation", "excess-kurtosis"],
            tags: ["kurtosis", "fat-tails", "fourth-moment", "distribution", "risk"]
        )
    }
    
    private func createTaylorRuleFormula() -> FormulaReference {
        FormulaReference(
            name: "Taylor Rule",
            category: .economics,
            level: .levelII,
            mainFormula: "i^* = r_{neutral} + \\pi_e + 0.5(\\pi_e - \\pi_{target}) + 0.5(Y_e - Y_{trend})",
            description: "Monetary policy rule for setting target interest rates based on inflation and output gaps. Guides central bank policy decisions.",
            variables: [
                FormulaVariable(symbol: "i^*", name: "Target Policy Rate", description: "Recommended nominal interest rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Central bank target rate"),
                FormulaVariable(symbol: "r_{neutral}", name: "Real Neutral Rate", description: "Long-run real interest rate", units: "Percentage", typicalRange: "1% to 4%", notes: "Equilibrium real rate"),
                FormulaVariable(symbol: "\\pi_e", name: "Expected Inflation", description: "Market's inflation expectations", units: "Percentage", typicalRange: "0% to 6%", notes: "Forward-looking measure"),
                FormulaVariable(symbol: "\\pi_{target}", name: "Inflation Target", description: "Central bank's inflation goal", units: "Percentage", typicalRange: "2% to 4%", notes: "Policy target"),
                FormulaVariable(symbol: "Y_e", name: "Expected GDP Growth", description: "Forecast real GDP growth", units: "Percentage", typicalRange: "-5% to 8%", notes: "Economic activity measure"),
                FormulaVariable(symbol: "Y_{trend}", name: "Trend GDP Growth", description: "Long-run potential growth", units: "Percentage", typicalRange: "2% to 4%", notes: "Sustainable growth rate")
            ],
            derivation: FormulaDerivation(
                title: "Taylor Rule Development",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with Fisher equation", formula: "i = r + \\pi_e", explanation: "Nominal rate equals real rate plus expected inflation"),
                    DerivationStep(stepNumber: 2, description: "Set real rate target", formula: "r = r_{neutral} + \\text{adjustments}", explanation: "Real rate varies with economic conditions"),
                    DerivationStep(stepNumber: 3, description: "Add inflation gap response", formula: "+ 0.5(\\pi_e - \\pi_{target})", explanation: "React to inflation deviations from target"),
                    DerivationStep(stepNumber: 4, description: "Add output gap response", formula: "+ 0.5(Y_e - Y_{trend})", explanation: "React to economic slack or overheating"),
                    DerivationStep(stepNumber: 5, description: "Combine all components", formula: "i^* = r_{neutral} + \\pi_e + 0.5(\\pi_e - \\pi_{target}) + 0.5(Y_e - Y_{trend})", explanation: "Complete Taylor Rule formula")
                ],
                assumptions: [
                    "Central bank targets both inflation and employment",
                    "Equal weights (0.5) on inflation and output gaps",
                    "Linear relationship between gaps and policy response",
                    "Forward-looking monetary policy"
                ],
                notes: "Original Taylor coefficients were 0.5 each, but central banks may use different weights."
            ),
            variants: [
                FormulaVariant(name: "Modified Taylor Rule", formula: "i^* = r_{neutral} + \\pi_e + \\alpha(\\pi_e - \\pi_{target}) + \\beta(Y_e - Y_{trend})", description: "With flexible coefficients", whenToUse: "When central bank has different policy preferences"),
                FormulaVariant(name: "Forward-Looking Taylor", formula: "i^* = r_{neutral} + E_t[\\pi_{t+1}] + 0.5(E_t[\\pi_{t+1}] - \\pi_{target}) + 0.5(\\text{Output Gap})", description: "Uses future expectations", whenToUse: "For forward-looking monetary policy"),
                FormulaVariant(name: "Unemployment Taylor", formula: "i^* = r_{neutral} + \\pi_e + 0.5(\\pi_e - \\pi_{target}) - 0.5(u - u_{natural})", description: "Uses unemployment gap", whenToUse: "When focusing on labor market conditions")
            ],
            usageNotes: [
                "Widely used benchmark for monetary policy analysis",
                "Coefficients of 0.5 are Taylor's original recommendation",
                "Central banks may deviate during crisis periods",
                "Helps predict and evaluate central bank actions",
                "Zero lower bound can constrain implementation"
            ],
            examples: [
                FormulaExample(
                    title: "Fed Policy Rate Calculation",
                    description: "US economy with 2% neutral rate, 3% expected inflation, 2% target, 2.5% growth vs 2% trend",
                    inputs: ["r_neutral": "2%", "π_e": "3%", "π_target": "2%", "Y_e": "2.5%", "Y_trend": "2%"],
                    calculation: "i* = 2% + 3% + 0.5(3% - 2%) + 0.5(2.5% - 2%)",
                    result: "i* = 6.25%",
                    interpretation: "Taylor Rule suggests Fed funds rate of 6.25% given economic conditions"
                )
            ],
            relatedFormulas: ["fisher-equation", "output-gap", "inflation-targeting"],
            tags: ["taylor-rule", "monetary-policy", "interest-rates", "central-banking", "inflation"]
        )
    }
    
    private func createGrinoldKronerModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Grinold-Kroner Model",
            category: .portfolio,
            level: .levelII,
            mainFormula: "E(R_e) = \\frac{D}{P} + (\\%\\Delta E - \\%\\Delta S) + \\%\\Delta \\frac{P}{E}",
            description: "Equity return expectation model decomposing returns into dividend yield, earnings growth per share, and P/E ratio changes.",
            variables: [
                FormulaVariable(symbol: "E(R_e)", name: "Expected Equity Return", description: "Total expected return on equity", units: "Percentage", typicalRange: "5% to 15%", notes: "Annual return expectation"),
                FormulaVariable(symbol: "\\frac{D}{P}", name: "Dividend Yield", description: "Current dividend yield", units: "Percentage", typicalRange: "0% to 6%", notes: "Income component of return"),
                FormulaVariable(symbol: "\\%\\Delta E", name: "Earnings Growth", description: "Expected growth in total earnings", units: "Percentage", typicalRange: "-10% to 20%", notes: "Corporate earnings expansion"),
                FormulaVariable(symbol: "\\%\\Delta S", name: "Share Change", description: "Expected change in shares outstanding", units: "Percentage", typicalRange: "-5% to 10%", notes: "Positive = dilution, Negative = buybacks"),
                FormulaVariable(symbol: "\\%\\Delta \\frac{P}{E}", name: "P/E Repricing", description: "Expected change in P/E multiple", units: "Percentage", typicalRange: "-20% to 20%", notes: "Valuation multiple expansion/contraction")
            ],
            derivation: FormulaDerivation(
                title: "Grinold-Kroner Return Decomposition",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with total return definition", formula: "R = \\frac{P_1 + D}{P_0} - 1", explanation: "Capital gains plus dividends"),
                    DerivationStep(stepNumber: 2, description: "Express price in terms of P/E and E", formula: "P = \\frac{P}{E} \\times E", explanation: "Price equals P/E times earnings"),
                    DerivationStep(stepNumber: 3, description: "Substitute and expand", formula: "R = \\frac{\\frac{P}{E}_1 \\times E_1 + D}{\\frac{P}{E}_0 \\times E_0} - 1", explanation: "Express in fundamental terms"),
                    DerivationStep(stepNumber: 4, description: "Adjust for shares outstanding", formula: "\\text{EPS Growth} = \\%\\Delta E - \\%\\Delta S", explanation: "Per-share earnings growth"),
                    DerivationStep(stepNumber: 5, description: "Separate components", formula: "E(R_e) = \\frac{D}{P} + \\text{EPS Growth} + \\%\\Delta \\frac{P}{E}", explanation: "Three sources of equity returns")
                ],
                assumptions: [
                    "Market efficiency allows decomposition",
                    "Dividend policy remains relatively stable",
                    "P/E changes reflect rational repricing",
                    "Earnings growth is sustainable"
                ],
                notes: "Model provides framework for long-term equity return forecasting and helps identify sources of expected returns."
            ),
            variants: [
                FormulaVariant(name: "Grinold-Kroner with Inflation", formula: "E(R_e) = \\frac{D}{P} + i + g - \\%\\Delta S + \\%\\Delta \\frac{P}{E}", description: "Separates nominal growth into real and inflation", whenToUse: "When analyzing real vs nominal components"),
                FormulaVariant(name: "International G-K", formula: "E(R_e) = \\frac{D}{P} + g + i - \\%\\Delta S + \\%\\Delta \\frac{P}{E} + E(\\%\\Delta FX)", description: "Adds currency effect", whenToUse: "For international equity investments"),
                FormulaVariant(name: "Long-Run G-K", formula: "E(R_e) = \\frac{D}{P} + \\text{Real GDP Growth} + \\text{Inflation}", description: "Assumes no P/E or share changes", whenToUse: "For very long-term forecasts")
            ],
            usageNotes: [
                "Widely used in institutional asset allocation",
                "Helps identify overvalued/undervalued markets",
                "P/E component adds most uncertainty to forecasts",
                "Share buybacks increase per-share growth",
                "Model works best for broad market indices"
            ],
            examples: [
                FormulaExample(
                    title: "S&P 500 Expected Return",
                    description: "Market with 2% dividend yield, 6% earnings growth, 1% net buybacks, no P/E change",
                    inputs: ["D/P": "2%", "Earnings Growth": "6%", "Share Change": "-1%", "P/E Change": "0%"],
                    calculation: "E(R_e) = 2% + (6% - (-1%)) + 0% = 2% + 7% + 0%",
                    result: "E(R_e) = 9%",
                    interpretation: "Expected equity return of 9% driven by income and earnings growth"
                )
            ],
            relatedFormulas: ["ddm", "earnings-growth", "dividend-yield"],
            tags: ["grinold-kroner", "equity-returns", "earnings-growth", "dividend-yield", "forecasting"]
        )
    }
    
    // MARK: - Core Time Value of Money Formula Implementations
    
    private func createPresentValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Present Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV = \\frac{FV}{(1+r)^n}",
            description: "Current value of future cash flow discounted at appropriate interest rate",
            variables: [
                FormulaVariable(symbol: "PV", name: "Present Value", description: "Current value of future amount", units: "Currency", typicalRange: "Any positive value", notes: "What money is worth today"),
                FormulaVariable(symbol: "FV", name: "Future Value", description: "Amount to be received in future", units: "Currency", typicalRange: "Any positive value", notes: "Face value of future payment"),
                FormulaVariable(symbol: "r", name: "Interest Rate", description: "Discount rate per period", units: "Percentage", typicalRange: "0% to 30%", notes: "Rate that reflects risk and opportunity cost"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Time periods until payment", units: "Count", typicalRange: "1 to 100", notes: "Must match rate periodicity")
            ],
            derivation: FormulaDerivation(
                title: "Present Value Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with future value relationship", formula: "FV = PV(1+r)^n", explanation: "Future value grows from present value"),
                    DerivationStep(stepNumber: 2, description: "Solve for present value", formula: "PV = \\frac{FV}{(1+r)^n}", explanation: "Algebraic rearrangement"),
                    DerivationStep(stepNumber: 3, description: "Interpret the discount factor", formula: "\\text{Discount Factor} = \\frac{1}{(1+r)^n}", explanation: "Present value per dollar of future value")
                ],
                assumptions: [
                    "Interest rate is constant over time",
                    "Cash flow occurs at end of period",
                    "No intermediate cash flows"
                ],
                notes: "Present value decreases as interest rate or time period increases."
            ),
            variants: [
                FormulaVariant(name: "Continuous Compounding", formula: "PV = FV \\times e^{-rt}", description: "Present value with continuous compounding", whenToUse: "For theoretical models"),
                FormulaVariant(name: "Multiple Cash Flows", formula: "PV = \\sum_{t=1}^{n} \\frac{CF_t}{(1+r)^t}", description: "Present value of cash flow stream", whenToUse: "For bonds, loans, projects")
            ],
            usageNotes: [
                "Foundation of all financial valuation",
                "Higher discount rates mean lower present values",
                "Must match interest rate and period frequency",
                "Used for NPV analysis, bond pricing, loan calculations"
            ],
            examples: [
                FormulaExample(
                    title: "Bond Present Value",
                    description: "Calculate PV of $1,000 bond payment due in 5 years at 6% rate",
                    inputs: ["FV": "$1,000", "r": "6%", "n": "5 years"],
                    calculation: "PV = $1,000 / (1.06)^5 = $1,000 / 1.3382",
                    result: "PV = $747.26",
                    interpretation: "$1,000 received in 5 years is worth $747.26 today at 6% discount rate"
                )
            ],
            relatedFormulas: ["future-value", "npv", "bond-pricing"],
            tags: ["present-value", "time-value", "discounting", "fundamental"]
        )
    }
    
    private func createFutureValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Future Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "FV = PV(1+r)^n",
            description: "Value at future date of current amount invested at compound interest",
            variables: [
                FormulaVariable(symbol: "FV", name: "Future Value", description: "Value at end of investment period", units: "Currency", typicalRange: "Any positive value", notes: "Final accumulated amount"),
                FormulaVariable(symbol: "PV", name: "Present Value", description: "Initial investment amount", units: "Currency", typicalRange: "Any positive value", notes: "Starting principal"),
                FormulaVariable(symbol: "r", name: "Interest Rate", description: "Rate of return per period", units: "Percentage", typicalRange: "0% to 30%", notes: "Must match period frequency"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Investment time periods", units: "Count", typicalRange: "1 to 100", notes: "Compounding periods")
            ],
            derivation: FormulaDerivation(
                title: "Future Value with Compound Interest",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Single period growth", formula: "FV_1 = PV(1+r)", explanation: "Value after one period"),
                    DerivationStep(stepNumber: 2, description: "Two period growth", formula: "FV_2 = PV(1+r)(1+r) = PV(1+r)^2", explanation: "Compound effect in second period"),
                    DerivationStep(stepNumber: 3, description: "Generalize to n periods", formula: "FV_n = PV(1+r)^n", explanation: "Compound growth over n periods")
                ],
                assumptions: [
                    "Interest rate remains constant",
                    "Interest is reinvested (compounded)",
                    "No withdrawals during investment period"
                ],
                notes: "Compound interest means earning interest on interest - the longer the period, the greater the effect."
            ),
            variants: [
                FormulaVariant(name: "Continuous Compounding", formula: "FV = PV \\times e^{rt}", description: "Theoretical maximum compounding", whenToUse: "For mathematical models"),
                FormulaVariant(name: "Intra-year Compounding", formula: "FV = PV(1+\\frac{r}{m})^{mn}", description: "m times per year compounding", whenToUse: "For quarterly, monthly, daily compounding")
            ],
            usageNotes: [
                "Foundation of investment growth calculations",
                "Demonstrates power of compound interest",
                "Growth is exponential, not linear",
                "Small rate differences have large long-term impact"
            ],
            examples: [
                FormulaExample(
                    title: "Retirement Savings Growth",
                    description: "Value of $10,000 invested for 30 years at 8% annual return",
                    inputs: ["PV": "$10,000", "r": "8%", "n": "30 years"],
                    calculation: "FV = $10,000 × (1.08)^30 = $10,000 × 10.063",
                    result: "FV = $100,627",
                    interpretation: "$10,000 grows to over $100,000 in 30 years through compound interest"
                )
            ],
            relatedFormulas: ["present-value", "compound-interest", "annuity"],
            tags: ["future-value", "compound-interest", "growth", "fundamental"]
        )
    }
    
    private func createAnnuityPresentValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Annuity Present Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV_{annuity} = PMT \\times \\frac{1 - \\frac{1}{(1+r)^n}}{r}",
            description: "Present value of series of equal payments made at regular intervals",
            variables: [
                FormulaVariable(symbol: "PV_{annuity}", name: "Present Value of Annuity", description: "Current value of payment stream", units: "Currency", typicalRange: "Any positive value", notes: "Total current worth"),
                FormulaVariable(symbol: "PMT", name: "Payment", description: "Equal payment amount per period", units: "Currency", typicalRange: "Any positive value", notes: "Constant payment size"),
                FormulaVariable(symbol: "r", name: "Interest Rate", description: "Discount rate per period", units: "Percentage", typicalRange: "0% to 30%", notes: "Period rate, not annual"),
                FormulaVariable(symbol: "n", name: "Number of Payments", description: "Total number of payments", units: "Count", typicalRange: "1 to 500", notes: "Payment frequency must match rate")
            ],
            derivation: FormulaDerivation(
                title: "Annuity Present Value Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Sum individual payment present values", formula: "PV = \\frac{PMT}{(1+r)^1} + \\frac{PMT}{(1+r)^2} + ... + \\frac{PMT}{(1+r)^n}", explanation: "Each payment discounted separately"),
                    DerivationStep(stepNumber: 2, description: "Factor out PMT", formula: "PV = PMT \\times [\\frac{1}{(1+r)^1} + \\frac{1}{(1+r)^2} + ... + \\frac{1}{(1+r)^n}]", explanation: "Common factor"),
                    DerivationStep(stepNumber: 3, description: "Recognize geometric series", formula: "\\text{Sum} = \\frac{1-(1+r)^{-n}}{r}", explanation: "Geometric series formula"),
                    DerivationStep(stepNumber: 4, description: "Final annuity formula", formula: "PV = PMT \\times \\frac{1 - (1+r)^{-n}}{r}", explanation: "Standard annuity present value")
                ],
                assumptions: [
                    "Equal payments at regular intervals",
                    "Payments occur at end of each period (ordinary annuity)",
                    "Constant interest rate throughout"
                ],
                notes: "The annuity factor [1-(1+r)^-n]/r represents the present value of $1 received each period."
            ),
            variants: [
                FormulaVariant(name: "Annuity Due", formula: "PV_{due} = PMT \\times \\frac{1 - (1+r)^{-n}}{r} \\times (1+r)", description: "Payments at beginning of period", whenToUse: "For rent, lease payments"),
                FormulaVariant(name: "Growing Annuity", formula: "PV = \\frac{PMT}{r-g} \\times [1 - (\\frac{1+g}{1+r})^n]", description: "Payments grow at rate g", whenToUse: "For inflation-adjusted payments")
            ],
            usageNotes: [
                "Foundation for loan payment calculations",
                "Used for pension and retirement planning",
                "Higher interest rates mean lower present values",
                "Longer payment periods increase present value"
            ],
            examples: [
                FormulaExample(
                    title: "Mortgage Present Value",
                    description: "Present value of 30-year mortgage with $2,000 monthly payments at 6% annual rate",
                    inputs: ["PMT": "$2,000", "r": "0.5% (6%/12)", "n": "360 payments"],
                    calculation: "PV = $2,000 × [1-(1.005)^-360]/0.005 = $2,000 × 166.792",
                    result: "PV = $333,584",
                    interpretation: "Loan amount that supports $2,000 monthly payments for 30 years"
                )
            ],
            relatedFormulas: ["loan-payments", "bond-pricing", "pension-valuation"],
            tags: ["annuity", "present-value", "payments", "loans"]
        )
    }
    
    private func createPerpetuityFormula() -> FormulaReference {
        FormulaReference(
            name: "Perpetuity",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV_{perpetuity} = \\frac{PMT}{r}",
            description: "Present value of infinite stream of equal payments",
            variables: [
                FormulaVariable(symbol: "PV_{perpetuity}", name: "Present Value of Perpetuity", description: "Current value of infinite payment stream", units: "Currency", typicalRange: "Any positive value", notes: "Finite value despite infinite payments"),
                FormulaVariable(symbol: "PMT", name: "Payment", description: "Equal payment per period", units: "Currency", typicalRange: "Any positive value", notes: "Constant forever"),
                FormulaVariable(symbol: "r", name: "Interest Rate", description: "Discount rate per period", units: "Percentage", typicalRange: "0.1% to 30%", notes: "Must be positive and greater than growth rate")
            ],
            derivation: FormulaDerivation(
                title: "Perpetuity as Limit of Annuity",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with annuity formula", formula: "PV = PMT \\times \\frac{1 - (1+r)^{-n}}{r}", explanation: "Standard annuity present value"),
                    DerivationStep(stepNumber: 2, description: "Take limit as n approaches infinity", formula: "\\lim_{n \\to \\infty} \\frac{1 - (1+r)^{-n}}{r}", explanation: "Infinite payment periods"),
                    DerivationStep(stepNumber: 3, description: "Evaluate the limit", formula: "\\lim_{n \\to \\infty} (1+r)^{-n} = 0", explanation: "Term approaches zero"),
                    DerivationStep(stepNumber: 4, description: "Simplify to perpetuity formula", formula: "PV = PMT \\times \\frac{1}{r} = \\frac{PMT}{r}", explanation: "Simple perpetuity result")
                ],
                assumptions: [
                    "Payments continue forever",
                    "Interest rate is constant and positive",
                    "Interest rate exceeds any growth rate"
                ],
                notes: "Perpetuities are rare in practice but useful for theoretical analysis and approximations."
            ),
            variants: [
                FormulaVariant(name: "Growing Perpetuity", formula: "PV = \\frac{PMT}{r-g}", description: "Payments grow at rate g forever", whenToUse: "For dividend discount models"),
                FormulaVariant(name: "Perpetuity Due", formula: "PV = \\frac{PMT}{r} \\times (1+r)", description: "Payments at beginning of period", whenToUse: "When first payment is immediate")
            ],
            usageNotes: [
                "Useful approximation for very long-term annuities",
                "Foundation for dividend discount models",
                "Simple formula but requires careful rate selection",
                "Small changes in rate have large impact on value"
            ],
            examples: [
                FormulaExample(
                    title: "Endowment Valuation",
                    description: "Value of endowment paying $50,000 annually forever at 5% rate",
                    inputs: ["PMT": "$50,000", "r": "5%"],
                    calculation: "PV = $50,000 / 0.05",
                    result: "PV = $1,000,000",
                    interpretation: "Need $1 million endowment to generate $50,000 annual payments forever"
                )
            ],
            relatedFormulas: ["annuity", "dividend-discount-model", "gordon-growth"],
            tags: ["perpetuity", "infinite-payments", "dividend-model", "endowment"]
        )
    }
    
    // MARK: - Missing Core Time Value of Money Formulas
    
    private func createAnnuityFutureValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Annuity Future Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "FV_{annuity} = PMT \\times \\frac{(1+r)^n - 1}{r}",
            description: "Future value of series of equal payments made at regular intervals, accounting for compound growth of each payment.",
            variables: [
                FormulaVariable(symbol: "FV_{annuity}", name: "Future Value of Annuity", description: "Total accumulated value of payment stream", units: "Currency", typicalRange: "Any positive value", notes: "Sum of all payments plus compound interest"),
                FormulaVariable(symbol: "PMT", name: "Payment", description: "Equal payment amount per period", units: "Currency", typicalRange: "Any positive value", notes: "Constant payment size"),
                FormulaVariable(symbol: "r", name: "Interest Rate", description: "Interest rate per period", units: "Percentage", typicalRange: "0% to 30%", notes: "Period rate, not annual"),
                FormulaVariable(symbol: "n", name: "Number of Payments", description: "Total number of payments", units: "Count", typicalRange: "1 to 500", notes: "Payment frequency must match rate")
            ],
            derivation: FormulaDerivation(
                title: "Annuity Future Value Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Consider individual payment future values", formula: "FV = PMT(1+r)^{n-1} + PMT(1+r)^{n-2} + ... + PMT(1+r)^0", explanation: "Each payment compounds for different periods"),
                    DerivationStep(stepNumber: 2, description: "Factor out PMT", formula: "FV = PMT \\times [(1+r)^{n-1} + (1+r)^{n-2} + ... + 1]", explanation: "Common factor"),
                    DerivationStep(stepNumber: 3, description: "Recognize geometric series", formula: "\\text{Sum} = \\frac{(1+r)^n - 1}{(1+r) - 1} = \\frac{(1+r)^n - 1}{r}", explanation: "Geometric series with first term 1, ratio (1+r)"),
                    DerivationStep(stepNumber: 4, description: "Final annuity future value formula", formula: "FV = PMT \\times \\frac{(1+r)^n - 1}{r}", explanation: "Standard annuity future value")
                ],
                assumptions: [
                    "Equal payments at regular intervals",
                    "Payments occur at end of each period (ordinary annuity)",
                    "Constant interest rate throughout",
                    "No withdrawals between payments"
                ],
                notes: "The annuity factor [(1+r)^n-1]/r represents the future value of $1 invested each period."
            ),
            variants: [
                FormulaVariant(name: "Annuity Due FV", formula: "FV_{due} = PMT \\times \\frac{(1+r)^n - 1}{r} \\times (1+r)", description: "Payments at beginning of period", whenToUse: "For rent, lease payments"),
                FormulaVariant(name: "Growing Annuity FV", formula: "FV = \\frac{PMT}{r-g} \\times [(1+r)^n - (1+g)^n]", description: "Payments grow at rate g", whenToUse: "For inflation-adjusted savings")
            ],
            usageNotes: [
                "Essential for retirement and savings planning",
                "Used for sinking fund calculations",
                "Higher interest rates mean higher future values",
                "Longer investment periods dramatically increase future value",
                "Each payment earns interest for different time periods"
            ],
            examples: [
                FormulaExample(
                    title: "Retirement Savings Plan",
                    description: "Value of saving $500 monthly for 25 years at 7% annual return",
                    inputs: ["PMT": "$500", "r": "0.583% (7%/12)", "n": "300 payments"],
                    calculation: "FV = $500 × [(1.00583)^300 - 1]/0.00583 = $500 × 813.52",
                    result: "FV = $406,758",
                    interpretation: "$150,000 in contributions grows to over $400,000 through compound interest"
                )
            ],
            relatedFormulas: ["annuity-present-value", "sinking-fund", "retirement-planning"],
            tags: ["annuity", "future-value", "savings", "retirement", "compound-growth"]
        )
    }
    
    private func createGrowingPerpetuityFormula() -> FormulaReference {
        FormulaReference(
            name: "Growing Perpetuity",
            category: .quantitative,
            level: .levelII,
            mainFormula: "PV_{growing} = \\frac{PMT_1}{r - g}",
            description: "Present value of infinite stream of payments that grow at constant rate, fundamental to dividend discount models and economic valuation.",
            variables: [
                FormulaVariable(symbol: "PV_{growing}", name: "Present Value of Growing Perpetuity", description: "Current value of growing payment stream", units: "Currency", typicalRange: "Any positive value", notes: "Finite value despite infinite growing payments"),
                FormulaVariable(symbol: "PMT_1", name: "First Payment", description: "Payment amount in first period", units: "Currency", typicalRange: "Any positive value", notes: "Base payment that will grow"),
                FormulaVariable(symbol: "r", name: "Discount Rate", description: "Required rate of return", units: "Percentage", typicalRange: "1% to 30%", notes: "Must exceed growth rate for convergence"),
                FormulaVariable(symbol: "g", name: "Growth Rate", description: "Constant growth rate of payments", units: "Percentage", typicalRange: "0% to 15%", notes: "Must be less than discount rate")
            ],
            derivation: FormulaDerivation(
                title: "Growing Perpetuity Derivation from Geometric Series",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Write out payment stream", formula: "PV = \\frac{PMT_1}{(1+r)^1} + \\frac{PMT_1(1+g)}{(1+r)^2} + \\frac{PMT_1(1+g)^2}{(1+r)^3} + ...", explanation: "Each payment grows by factor (1+g)"),
                    DerivationStep(stepNumber: 2, description: "Factor out first payment", formula: "PV = PMT_1 \\times [\\frac{1}{1+r} + \\frac{1+g}{(1+r)^2} + \\frac{(1+g)^2}{(1+r)^3} + ...]", explanation: "Common factor PMT₁"),
                    DerivationStep(stepNumber: 3, description: "Factor out 1/(1+r)", formula: "PV = \\frac{PMT_1}{1+r} \\times [1 + \\frac{1+g}{1+r} + (\\frac{1+g}{1+r})^2 + ...]", explanation: "Geometric series with ratio (1+g)/(1+r)"),
                    DerivationStep(stepNumber: 4, description: "Apply geometric series formula", formula: "\\text{Sum} = \\frac{1}{1 - \\frac{1+g}{1+r}} = \\frac{1+r}{r-g}", explanation: "Convergent series when |ratio| < 1"),
                    DerivationStep(stepNumber: 5, description: "Combine terms", formula: "PV = \\frac{PMT_1}{1+r} \\times \\frac{1+r}{r-g} = \\frac{PMT_1}{r-g}", explanation: "Final growing perpetuity formula")
                ],
                assumptions: [
                    "Growth rate is constant forever",
                    "Growth rate is less than discount rate (r > g)",
                    "First payment occurs at end of first period",
                    "No interruption in payment stream"
                ],
                notes: "Critical assumption: r > g ensures convergence. When r ≤ g, the present value becomes infinite."
            ),
            variants: [
                FormulaVariant(name: "Gordon Growth Model", formula: "P_0 = \\frac{D_1}{r_e - g}", description: "Stock valuation using growing dividends", whenToUse: "For dividend-paying stocks with stable growth"),
                FormulaVariant(name: "Growing Perpetuity Due", formula: "PV = \\frac{PMT_0(1+g)}{r-g}", description: "First payment is immediate", whenToUse: "When payment starts immediately"),
                FormulaVariant(name: "Two-Stage Growth", formula: "PV = \\sum_{t=1}^{n} \\frac{PMT_1(1+g_1)^{t-1}}{(1+r)^t} + \\frac{PMT_{n+1}}{(r-g_2)(1+r)^n}", description: "High initial growth, then stable growth", whenToUse: "For companies with changing growth phases")
            ],
            usageNotes: [
                "Foundation of dividend discount models in equity valuation",
                "Critical that r > g, otherwise formula gives infinite value",
                "Small changes in r-g have large impact on valuation",
                "Growth rate typically estimated from historical or analyst forecasts",
                "Widely used in real estate income property valuation"
            ],
            examples: [
                FormulaExample(
                    title: "Dividend Stock Valuation",
                    description: "Stock paying $3 dividend growing 4% annually, required return 9%",
                    inputs: ["D₁": "$3.00", "g": "4%", "r": "9%"],
                    calculation: "P₀ = $3.00 / (0.09 - 0.04) = $3.00 / 0.05",
                    result: "P₀ = $60.00",
                    interpretation: "Stock worth $60 based on growing dividend stream"
                )
            ],
            relatedFormulas: ["gordon-growth-model", "dividend-discount-model", "perpetuity"],
            tags: ["growing-perpetuity", "gordon-growth", "dividend-model", "equity-valuation", "dcf"]
        )
    }
    
    private func createEffectiveAnnualRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Effective Annual Rate (EAR)",
            category: .quantitative,
            level: .levelI,
            mainFormula: "EAR = (1 + \\frac{r}{m})^m - 1",
            description: "True annual interest rate accounting for compounding frequency, allowing accurate comparison of investments with different compounding schedules.",
            variables: [
                FormulaVariable(symbol: "EAR", name: "Effective Annual Rate", description: "Actual annual rate with compounding", units: "Percentage", typicalRange: "0% to 50%", notes: "Always ≥ stated annual rate"),
                FormulaVariable(symbol: "r", name: "Stated Annual Rate", description: "Nominal annual interest rate", units: "Percentage", typicalRange: "0% to 50%", notes: "Rate before compounding adjustment"),
                FormulaVariable(symbol: "m", name: "Compounding Frequency", description: "Number of compounding periods per year", units: "Count", typicalRange: "1 to 365", notes: "1=annual, 2=semiannual, 4=quarterly, 12=monthly, 365=daily")
            ],
            derivation: FormulaDerivation(
                title: "Effective Rate Derivation from Compound Interest",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with compound interest formula", formula: "FV = PV(1 + \\frac{r}{m})^{mt}", explanation: "Future value with m compounding periods per year"),
                    DerivationStep(stepNumber: 2, description: "Set time period to one year", formula: "FV = PV(1 + \\frac{r}{m})^m", explanation: "One year: t = 1"),
                    DerivationStep(stepNumber: 3, description: "Define effective rate", formula: "FV = PV(1 + EAR)^1", explanation: "Equivalent simple annual compounding"),
                    DerivationStep(stepNumber: 4, description: "Equate the expressions", formula: "PV(1 + EAR) = PV(1 + \\frac{r}{m})^m", explanation: "Same future value requirement"),
                    DerivationStep(stepNumber: 5, description: "Solve for EAR", formula: "EAR = (1 + \\frac{r}{m})^m - 1", explanation: "Effective annual rate formula")
                ],
                assumptions: [
                    "Compounding occurs at regular intervals",
                    "Interest rate remains constant throughout year",
                    "No fees or transaction costs",
                    "Full reinvestment of interest"
                ],
                notes: "EAR increases with compounding frequency but at decreasing marginal rate."
            ),
            variants: [
                FormulaVariant(name: "Continuous Compounding EAR", formula: "EAR = e^r - 1", description: "Effective rate with continuous compounding", whenToUse: "For theoretical maximum compounding"),
                FormulaVariant(name: "APY Calculation", formula: "APY = (1 + \\frac{APR}{m})^m - 1", description: "Annual Percentage Yield", whenToUse: "For deposit account comparisons"),
                FormulaVariant(name: "Credit Card EAR", formula: "EAR = (1 + \\frac{APR}{365})^{365} - 1", description: "Daily compounding credit cards", whenToUse: "For credit card interest calculations")
            ],
            usageNotes: [
                "Essential for comparing loans and investments with different compounding",
                "Always use EAR, not stated rate, for financial decisions",
                "EAR approaches e^r - 1 as compounding frequency increases",
                "Required disclosure for many financial products",
                "Difference between EAR and stated rate increases with frequency and rate level"
            ],
            examples: [
                FormulaExample(
                    title: "Credit Card Interest Comparison",
                    description: "Compare 18% APR with monthly vs daily compounding",
                    inputs: ["APR": "18%", "Monthly": "m=12", "Daily": "m=365"],
                    calculation: "Monthly: EAR = (1+0.18/12)^12 - 1 = 19.56%\nDaily: EAR = (1+0.18/365)^365 - 1 = 19.72%",
                    result: "Monthly: 19.56%, Daily: 19.72%",
                    interpretation: "Daily compounding adds 0.16% to effective rate"
                )
            ],
            relatedFormulas: ["compound-interest", "apr", "apy", "continuous-compounding"],
            tags: ["effective-rate", "ear", "compounding", "apy", "comparison"]
        )
    }
    
    private func createAnnualizedReturnFormula() -> FormulaReference {
        FormulaReference(name: "Annualized Return", category: .quantitative, level: .levelI, mainFormula: "r_{annual} = (1 + r_{total})^{\\frac{1}{n}} - 1", description: "Converts total return over multiple periods to equivalent annual rate", variables: [], derivation: nil, variants: [], usageNotes: ["Used to compare investments with different time horizons"], examples: [], relatedFormulas: ["compound-return"], tags: ["annualized", "return"])
    }
    
    private func createContinuousCompoundingFormula() -> FormulaReference {
        FormulaReference(name: "Continuous Compounding", category: .quantitative, level: .levelI, mainFormula: "FV = PV \\times e^{rt}", description: "Future value with continuous compounding", variables: [], derivation: nil, variants: [], usageNotes: ["Theoretical maximum compounding frequency"], examples: [], relatedFormulas: ["future-value"], tags: ["continuous", "compounding"])
    }
    
    private func createCoefficientOfVariationFormula() -> FormulaReference {
        FormulaReference(name: "Coefficient of Variation", category: .quantitative, level: .levelI, mainFormula: "CV = \\frac{\\sigma}{\\mu}", description: "Relative measure of dispersion comparing standard deviation to mean", variables: [], derivation: nil, variants: [], usageNotes: ["Useful for comparing risk of investments with different expected returns"], examples: [], relatedFormulas: ["standard-deviation"], tags: ["cv", "relative-risk"])
    }
    
    private func createCovarianceFormula() -> FormulaReference {
        FormulaReference(name: "Covariance", category: .quantitative, level: .levelI, mainFormula: "Cov(X,Y) = \\frac{\\sum_{i=1}^{n}(X_i - \\bar{X})(Y_i - \\bar{Y})}{n-1}", description: "Measure of how two variables move together", variables: [], derivation: nil, variants: [], usageNotes: ["Positive indicates variables move in same direction"], examples: [], relatedFormulas: ["correlation"], tags: ["covariance", "relationship"])
    }
    
    private func createCorrelationFormula() -> FormulaReference {
        FormulaReference(name: "Correlation Coefficient", category: .quantitative, level: .levelI, mainFormula: "\\rho_{X,Y} = \\frac{Cov(X,Y)}{\\sigma_X \\sigma_Y}", description: "Standardized measure of linear relationship between two variables", variables: [], derivation: nil, variants: [], usageNotes: ["Ranges from -1 to +1"], examples: [], relatedFormulas: ["covariance"], tags: ["correlation", "relationship"])
    }
    
    private func createMacaulayDurationDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Macaulay Duration (Detailed)", category: .fixedIncome, level: .levelI, mainFormula: "D_{Mac} = \\frac{\\sum_{t=1}^{n} t \\times \\frac{CF_t}{(1+YTM)^t}}{P}", description: "Weighted average time to receive bond cash flows", variables: [], derivation: nil, variants: [], usageNotes: ["Measured in years"], examples: [], relatedFormulas: ["modified-duration"], tags: ["duration", "bond"])
    }
    
    private func createSwapSpreadFormula() -> FormulaReference {
        FormulaReference(name: "Swap Spread", category: .fixedIncome, level: .levelII, mainFormula: "\\text{Swap Spread} = \\text{Swap Rate} - \\text{Government Bond Yield}", description: "Credit spread between swap rate and government bond of same maturity", variables: [], derivation: nil, variants: [], usageNotes: ["Indicates credit risk premium"], examples: [], relatedFormulas: ["interest-rate-swap"], tags: ["swap-spread", "credit"])
    }
    
    private func createTEDSpreadFormula() -> FormulaReference {
        FormulaReference(name: "TED Spread", category: .fixedIncome, level: .levelII, mainFormula: "\\text{TED Spread} = \\text{LIBOR} - \\text{T-bill Rate}", description: "Spread between LIBOR and Treasury bill rates, indicating credit risk", variables: [], derivation: nil, variants: [], usageNotes: ["Higher spread indicates financial stress"], examples: [], relatedFormulas: ["libor"], tags: ["ted-spread", "credit-risk"])
    }
    
    private func createLiborOISSpreadFormula() -> FormulaReference {
        FormulaReference(name: "LIBOR-OIS Spread", category: .fixedIncome, level: .levelII, mainFormula: "\\text{LIBOR-OIS} = \\text{LIBOR} - \\text{OIS Rate}", description: "Spread between LIBOR and overnight indexed swap rate", variables: [], derivation: nil, variants: [], usageNotes: ["Measures bank funding stress"], examples: [], relatedFormulas: ["libor"], tags: ["libor-ois", "funding-stress"])
    }
    
    private func createCreditDefaultSwapFormula() -> FormulaReference {
        FormulaReference(name: "Credit Default Swap", category: .derivatives, level: .levelII, mainFormula: "\\text{CDS Spread} \\approx (1 - \\text{Recovery Rate}) \\times \\text{PD}", description: "Credit default swap spread approximation", variables: [], derivation: nil, variants: [], usageNotes: ["Measures credit risk"], examples: [], relatedFormulas: ["probability-of-default"], tags: ["cds", "credit-risk"])
    }
    
    private func createMultipleRegressionFormula() -> FormulaReference {
        FormulaReference(name: "Multiple Regression", category: .quantitative, level: .levelII, mainFormula: "Y_i = b_0 + b_1 X_{1i} + b_2 X_{2i} + \\dots + b_k X_{ki} + \\varepsilon_i", description: "Linear regression with multiple independent variables", variables: [], derivation: nil, variants: [], usageNotes: ["Used for factor models"], examples: [], relatedFormulas: ["regression-analysis"], tags: ["regression", "multiple"])
    }
    
    private func createTimeSeriesAnalysisFormula() -> FormulaReference {
        FormulaReference(name: "Autoregressive AR(1) Model", category: .quantitative, level: .levelII, mainFormula: "x_t = b_0 + b_1 x_{t-1} + \\varepsilon_t", description: "First-order autoregressive time series model", variables: [], derivation: nil, variants: [], usageNotes: ["Models persistence in time series"], examples: [], relatedFormulas: ["time-series"], tags: ["ar", "time-series"])
    }
    
    private func createARMAModelFormula() -> FormulaReference {
        FormulaReference(name: "ARMA Model", category: .quantitative, level: .levelII, mainFormula: "x_t = b_0 + \\sum_{i=1}^{p} b_i x_{t-i} + \\varepsilon_t + \\sum_{j=1}^{q} \\theta_j \\varepsilon_{t-j}", description: "Autoregressive moving average model", variables: [], derivation: nil, variants: [], usageNotes: ["Combines AR and MA components"], examples: [], relatedFormulas: ["ar-model"], tags: ["arma", "time-series"])
    }
    
    private func createGARCHModelFormula() -> FormulaReference {
        FormulaReference(name: "GARCH Model", category: .quantitative, level: .levelII, mainFormula: "\\sigma_t^2 = \\gamma + \\alpha \\varepsilon_{t-1}^2 + \\beta \\sigma_{t-1}^2", description: "Generalized autoregressive conditional heteroskedasticity model", variables: [], derivation: nil, variants: [], usageNotes: ["Models time-varying volatility"], examples: [], relatedFormulas: ["arch-model"], tags: ["garch", "volatility"])
    }
    
    private func createPurchasingPowerParityFormula() -> FormulaReference {
        FormulaReference(name: "Purchasing Power Parity", category: .economics, level: .levelII, mainFormula: "S_{f/d} = \\frac{P_f}{P_d}", description: "Exchange rate based on relative price levels", variables: [], derivation: nil, variants: [], usageNotes: ["Absolute PPP version"], examples: [], relatedFormulas: ["exchange-rates"], tags: ["ppp", "exchange-rates"])
    }
    
    private func createSingerTerhaarModelFormula() -> FormulaReference {
        FormulaReference(name: "Singer-Terhaar Model", category: .portfolio, level: .levelII, mainFormula: "RP_i = \\lambda RP_i^{integrated} + (1-\\lambda) RP_i^{segmented}", description: "Asset pricing model adjusting for market integration", variables: [], derivation: nil, variants: [], usageNotes: ["Used for international asset allocation"], examples: [], relatedFormulas: ["capm"], tags: ["singer-terhaar", "international"])
    }
    
    // MARK: - Comprehensive CFA Level 1 Formulas
    
    func loadComprehensiveCFAFormulas() {
        // Add all comprehensive CFA formulas to the database
        formulas.append(contentsOf: [
            
            // MARK: - Volume 1: Quantitative Methods
            createDeterminantsOfInterestRatesFormula(),
            createHoldingPeriodReturnFormula(),
            createArithmeticMeanReturnFormula(),
            createGeometricMeanReturnFormula(),
            createHarmonicMeanFormula(),
            createMoneyWeightedReturnFormula(),
            createTimeWeightedReturnFormula(),
            createNonAnnualCompoundingFormula(),
            createContinuouslyCompoundedReturnsFormula(),
            createRealReturnsFormula(),
            createLeveragedReturnFormula(),
            
            // Statistical Measures
            createSampleVarianceFormula(),
            createSampleStandardDeviationFormula(),
            createCoefficientOfVariationFormula(),
            createSampleSkewnessFormula(),
            createSampleExcessKurtosisFormula(),
            createSampleCovarianceFormula(),
            createSampleCorrelationCoefficientFormula(),
            
            // Probability and Expected Values
            createExpectedValueDiscreteFormula(),
            createVarianceOfRandomVariableFormula(),
            createBayesFormulaFormula(),
            createTotalProbabilityRuleFormula(),
            
            // Portfolio Mathematics
            createPortfolioExpectedReturnFormula(),
            createPortfolioVarianceFormula(),
            createTwoAssetPortfolioVarianceFormula(),
            createSafetyFirstRatioFormula(),
            
            // Hypothesis Testing
            createTestOfSingleMeanFormula(),
            createTestOfDifferenceInMeansFormula(),
            createTestOfSingleVarianceFormula(),
            createTestOfCorrelationFormula(),
            createChiSquareTestFormula(),
            
            // Simple Linear Regression
            createRegressionSlopeFormula(),
            createRegressionInterceptFormula(),
            createCoefficientOfDeterminationFormula(),
            createANOVAFTestFormula(),
            createPredictionIntervalsFormula(),
            
            // MARK: - Volume 2: Economics
            createFiscalMultiplierFormula(),
            createDisposableIncomeFormula(),
            createCrossRateFormula(),
            createForwardExchangeRateFormula(),
            
            // MARK: - Volume 3: Corporate Finance
            createNetPresentValueFormula(),
            createInternalRateOfReturnFormula(),
            createReturnOnInvestedCapitalFormula(),
            createWeightedAverageCostOfCapitalFormula(),
            createOperatingLeverageFormula(),
            createInterestCoverageFormula(),
            createModiglianiMillerPropositionsFormula(),
            
            // MARK: - Volume 4: Financial Statement Analysis
            
            // Income Statement Analysis
            createGrossProfitFormula(),
            createReturnOnEquityFormula(),
            createNetProfitMarginFormula(),
            createBasicEPSFormula(),
            createDilutedEPSFormula(),
            
            // Liquidity Ratios
            createCurrentRatioFormula(),
            createQuickRatioFormula(),
            createCashRatioFormula(),
            
            // Activity Ratios
            createInventoryTurnoverFormula(),
            createReceivablesTurnoverFormula(),
            createPayablesTurnoverFormula(),
            createAssetTurnoverFormula(),
            createFixedAssetTurnoverFormula(),
            createCashConversionCycleFormula(),
            
            // Solvency Ratios
            createDebtToEquityRatioFormula(),
            createDebtToAssetsRatioFormula(),
            createFinancialLeverageRatioFormula(),
            createTimesInterestEarnedFormula(),
            
            // Profitability Ratios
            createGrossMarginFormula(),
            createOperatingMarginFormula(),
            createNetMarginFormula(),
            createReturnOnAssetsFormula(),
            createReturnOnInvestedCapitalROICFormula(),
            
            // DuPont Analysis
            createDuPontROEFormula(),
            createDuPontROAFormula(),
            
            // Cash Flow Analysis
            createFreeCashFlowToFirmFormula(),
            createFreeCashFlowToEquityFormula(),
            
            // MARK: - Volume 5: Equity Investments
            createPriceReturnIndexFormula(),
            createTotalReturnIndexFormula(),
            createMarketCapWeightingFormula(),
            createDividendDiscountModelFormula(),
            createTwoStageDividendDiscountModelFormula(),
            createPriceToEarningsRatioFormula(),
            createPriceToBookRatioFormula(),
            createEnterpriseValueFormula(),
            
            // MARK: - Volume 6: Fixed Income
            createZeroCouponBondPriceFormula(),
            createCouponBondPriceFormula(),
            createCurrentYieldBondFormula(),
            createYieldToMaturityBondFormula(),
            createMacaulayDurationBondFormula(),
            createModifiedDurationBondFormula(),
            createBondConvexityFormula(),
            createEffectiveDurationBondFormula(),
            
            // MARK: - Volume 7: Derivatives
            createForwardContractPricingFormula(),
            createFuturesContractPricingFormula(),
            createPutCallParityOptionsFormula(),
            createBlackScholesCallOptionFormula(),
            createBlackScholesPutOptionFormula(),
            createBinomialOptionPricingFormula(),
            
            // MARK: - Volume 8: Alternative Investments
            createPrivateEquityReturnFormula(),
            createRealEstateCapRateFormula(),
            createHedgeFundPerformanceFormula(),
            
            // MARK: - Volume 9: Portfolio Management
            createCapitalAssetPricingModelFormula(),
            createPortfolioExpectedReturnDetailedFormula(),
            createSharpeRatioDetailedFormula(),
            createTreynorRatioDetailedFormula(),
            createJensensAlphaFormula(),
            createInformationRatioDetailedFormula(),
            createTrackingErrorFormula()
        ])
    }
    
    // MARK: - Volume 1: Quantitative Methods Implementation
    
    private func createDeterminantsOfInterestRatesFormula() -> FormulaReference {
        FormulaReference(
            name: "Determinants of Interest Rates",
            category: .quantitative,
            level: .levelI,
            mainFormula: "i = r_{RF} + IP + DRP + LP + MP",
            description: "Components that determine nominal interest rates in financial markets",
            variables: [
                FormulaVariable(symbol: "i", name: "Nominal Interest Rate", description: "The stated interest rate including all risk premiums", units: "Percentage", typicalRange: "0% to 20%", notes: "Observable market rate"),
                FormulaVariable(symbol: "r_{RF}", name: "Real Risk-Free Rate", description: "Interest rate on risk-free security with no inflation expectation", units: "Percentage", typicalRange: "0% to 5%", notes: "Theoretical pure time value of money"),
                FormulaVariable(symbol: "IP", name: "Inflation Premium", description: "Compensation for expected inflation", units: "Percentage", typicalRange: "0% to 10%", notes: "Forward-looking inflation expectation"),
                FormulaVariable(symbol: "DRP", name: "Default Risk Premium", description: "Compensation for credit/default risk", units: "Percentage", typicalRange: "0% to 15%", notes: "Higher for lower credit quality"),
                FormulaVariable(symbol: "LP", name: "Liquidity Premium", description: "Compensation for lack of marketability", units: "Percentage", typicalRange: "0% to 5%", notes: "Higher for illiquid securities"),
                FormulaVariable(symbol: "MP", name: "Maturity Premium", description: "Compensation for interest rate risk from longer maturity", units: "Percentage", typicalRange: "0% to 3%", notes: "Generally positive yield curve slope")
            ],
            derivation: FormulaDerivation(
                title: "Interest Rate Component Analysis",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with real risk-free rate", formula: "r_{RF}", explanation: "Base compensation for time value of money"),
                    DerivationStep(stepNumber: 2, description: "Add inflation premium", formula: "r_{RF} + IP", explanation: "Maintain purchasing power"),
                    DerivationStep(stepNumber: 3, description: "Add default risk premium", formula: "r_{RF} + IP + DRP", explanation: "Compensate for credit risk"),
                    DerivationStep(stepNumber: 4, description: "Add liquidity premium", formula: "r_{RF} + IP + DRP + LP", explanation: "Compensate for marketability risk"),
                    DerivationStep(stepNumber: 5, description: "Add maturity premium", formula: "i = r_{RF} + IP + DRP + LP + MP", explanation: "Final nominal rate with all risk premiums")
                ],
                assumptions: [
                    "Risk premiums are additive",
                    "Markets are efficient in pricing risk",
                    "Expected inflation is properly estimated",
                    "Risk premiums are independent"
                ],
                notes: "Foundation for understanding all fixed income pricing and credit analysis."
            ),
            variants: [
                FormulaVariant(name: "Real Risk-Free Rate Relationship", formula: "(1 + i) = (1 + r_{RF}) \\times (1 + IP)", description: "Multiplicative relationship for precise calculation", whenToUse: "When precision is critical for long-term calculations"),
                FormulaVariant(name: "Maturity Premium Calculation", formula: "MP = Y_{long} - Y_{short}", description: "Difference between long and short-term Treasury yields", whenToUse: "When estimating term structure premiums")
            ],
            usageNotes: [
                "Critical for credit analysis and bond valuation",
                "Forms basis for understanding yield spreads and credit risk",
                "Each premium varies across economic cycles and market conditions",
                "Used in relative value analysis across fixed income sectors"
            ],
            examples: [
                FormulaExample(
                    title: "Corporate Bond Interest Rate Breakdown",
                    description: "Calculate required return for a 10-year BBB corporate bond",
                    inputs: [
                        "Real risk-free rate": "2.5%",
                        "Expected inflation": "2.0%",
                        "Default risk premium": "1.5%",
                        "Liquidity premium": "0.3%",
                        "Maturity premium": "0.7%"
                    ],
                    calculation: "i = 2.5% + 2.0% + 1.5% + 0.3% + 0.7% = 7.0%",
                    result: "Required return: 7.0%",
                    interpretation: "The corporate bond should yield 7.0% to compensate investors for all relevant risks compared to a risk-free investment."
                )
            ],
            relatedFormulas: ["yield-to-maturity", "credit-spread", "real-return"],
            tags: ["interest-rates", "risk-premium", "fixed-income", "credit-analysis", "level-1"]
        )
    }
    
    private func createHoldingPeriodReturnFormula() -> FormulaReference {
        FormulaReference(
            name: "Holding Period Return",
            category: .quantitative,
            level: .levelI,
            mainFormula: "R = \\frac{P_1 - P_0 + I_1}{P_0}",
            description: "Return earned on an investment over a specific holding period, including capital gains and income",
            variables: [
                FormulaVariable(symbol: "R", name: "Holding Period Return", description: "Total return earned over the holding period", units: "Decimal/Percentage", typicalRange: "-100% to +∞", notes: "Can be negative if losses exceed income"),
                FormulaVariable(symbol: "P_1", name: "Ending Price", description: "Market value of investment at end of period", units: "Currency", typicalRange: "Any positive value", notes: "Includes all capital appreciation/depreciation"),
                FormulaVariable(symbol: "P_0", name: "Beginning Price", description: "Initial investment or purchase price", units: "Currency", typicalRange: "Any positive value", notes: "Actual cost basis for investment"),
                FormulaVariable(symbol: "I_1", name: "Income Received", description: "Dividends, interest, or other income during period", units: "Currency", typicalRange: "0 to significant percentage of P_0", notes: "Cash flows received during holding period")
            ],
            derivation: FormulaDerivation(
                title: "Holding Period Return Calculation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate capital gain/loss", formula: "Capital Gain = P_1 - P_0", explanation: "Change in market value"),
                    DerivationStep(stepNumber: 2, description: "Add income received", formula: "Total Return = (P_1 - P_0) + I_1", explanation: "Total cash flows to investor"),
                    DerivationStep(stepNumber: 3, description: "Express as percentage of initial investment", formula: "R = \\frac{P_1 - P_0 + I_1}{P_0}", explanation: "Return as fraction of initial investment"),
                    DerivationStep(stepNumber: 4, description: "Alternative decomposition", formula: "R = \\frac{P_1 - P_0}{P_0} + \\frac{I_1}{P_0}", explanation: "Capital return plus income return")
                ],
                assumptions: [
                    "Single period investment",
                    "All income received at end of period",
                    "No additional investments during period",
                    "Market prices are observable"
                ],
                notes: "Fundamental building block for all return calculations in finance."
            ),
            variants: [
                FormulaVariant(name: "Multi-period Compound Return", formula: "R_T = (1 + R_1) \\times (1 + R_2) \\times \\ldots \\times (1 + R_T) - 1", description: "Compound return over multiple periods", whenToUse: "When calculating returns over multiple time periods"),
                FormulaVariant(name: "Dividend Yield Plus Capital Gain", formula: "R = \\frac{D_1}{P_0} + \\frac{P_1 - P_0}{P_0}", description: "Separates dividend yield from capital gains yield", whenToUse: "For equity analysis and dividend-focused strategies"),
                FormulaVariant(name: "Bond Holding Period Return", formula: "R = \\frac{Coupon + P_1 - P_0}{P_0}", description: "HPR for bonds including coupon payments", whenToUse: "For fixed income securities with periodic coupon payments")
            ],
            usageNotes: [
                "Most basic and fundamental return measure in finance",
                "Does not account for timing of cash flows within the period",
                "Cannot be directly compared across different time periods without annualization",
                "Forms basis for more complex return measures like IRR and TWR"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Investment Return",
                    description: "Calculate return on stock purchased at $50, sold at $55, with $2 dividend",
                    inputs: [
                        "Initial price (P₀)": "$50",
                        "Final price (P₁)": "$55",
                        "Dividend received (I₁)": "$2"
                    ],
                    calculation: "R = ($55 - $50 + $2) / $50 = $7 / $50 = 0.14",
                    result: "Holding period return: 14%",
                    interpretation: "The investment generated a 14% return, consisting of 10% capital gain and 4% dividend yield."
                )
            ],
            relatedFormulas: ["time-weighted-return", "money-weighted-return", "annualized-return"],
            tags: ["return-calculation", "performance", "basic-finance", "level-1"]
        )
    }
    
    private func createArithmeticMeanReturnFormula() -> FormulaReference {
        FormulaReference(
            name: "Arithmetic Mean Return",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\bar{R} = \\frac{1}{T} \\sum_{t=1}^{T} R_t = \\frac{R_1 + R_2 + \\ldots + R_T}{T}",
            description: "Simple average of periodic returns, representing expected return per period",
            variables: [
                FormulaVariable(symbol: "\\bar{R}", name: "Arithmetic Mean Return", description: "Average return across all periods", units: "Percentage", typicalRange: "Varies by asset class", notes: "Unbiased estimator of expected return"),
                FormulaVariable(symbol: "R_t", name: "Return in Period t", description: "Holding period return for period t", units: "Percentage", typicalRange: "-100% to +∞", notes: "Individual period returns"),
                FormulaVariable(symbol: "T", name: "Number of Periods", description: "Total number of observation periods", units: "Count", typicalRange: "2 to thousands", notes: "More periods provide better estimates")
            ],
            derivation: FormulaDerivation(
                title: "Expected Return Estimation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with expected value definition", formula: "E(R) = \\sum_{i=1}^{n} p_i R_i", explanation: "Expected value with known probabilities"),
                    DerivationStep(stepNumber: 2, description: "Assume equal probability for historical periods", formula: "p_i = \\frac{1}{T} \\text{ for all } i", explanation: "Each period equally likely"),
                    DerivationStep(stepNumber: 3, description: "Substitute equal probabilities", formula: "E(R) = \\sum_{t=1}^{T} \\frac{1}{T} R_t", explanation: "Historical data with equal weights"),
                    DerivationStep(stepNumber: 4, description: "Factor out constant term", formula: "\\bar{R} = \\frac{1}{T} \\sum_{t=1}^{T} R_t", explanation: "Arithmetic mean as estimator")
                ],
                assumptions: [
                    "Returns are independent and identically distributed",
                    "Past returns are representative of future expectations",
                    "No regime changes or structural breaks",
                    "Equal weighting of all historical periods"
                ],
                notes: "Provides upward-biased estimate of compound returns due to volatility drag."
            ),
            variants: [
                FormulaVariant(name: "Weighted Arithmetic Mean", formula: "\\bar{R}_w = \\sum_{t=1}^{T} w_t R_t", description: "Arithmetic mean with different period weights", whenToUse: "When some periods are more relevant than others"),
                FormulaVariant(name: "Winsorized Mean", formula: "\\bar{R}_{win} = \\frac{1}{T} \\sum_{t=1}^{T} R_{t,win}", description: "Mean after limiting extreme outliers", whenToUse: "When extreme outliers may distort the mean")
            ],
            usageNotes: [
                "Best unbiased estimator of expected single-period return",
                "Overestimates compound annual growth rate, especially for volatile assets",
                "Sensitive to outliers - extreme returns can significantly affect the mean",
                "Appropriate for budgeting and single-period investment decisions"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Return Analysis",
                    description: "Calculate average return for stock with 5 years of data",
                    inputs: [
                        "Year 1 return": "15%",
                        "Year 2 return": "-5%",
                        "Year 3 return": "20%",
                        "Year 4 return": "8%",
                        "Year 5 return": "12%"
                    ],
                    calculation: "Arithmetic Mean = (15% + (-5%) + 20% + 8% + 12%) / 5 = 50% / 5 = 10%",
                    result: "Average annual return: 10%",
                    interpretation: "The stock had an average annual return of 10%, which represents the expected return for any single year going forward, assuming historical patterns continue."
                )
            ],
            relatedFormulas: ["geometric-mean", "standard-deviation", "variance"],
            tags: ["descriptive-statistics", "return-analysis", "mean", "level-1"]
        )
    }
    
    private func createGeometricMeanReturnFormula() -> FormulaReference {
        FormulaReference(
            name: "Geometric Mean Return",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\bar{R}_G = \\sqrt[T]{(1 + R_1) \\times (1 + R_2) \\times \\ldots \\times (1 + R_T)} - 1",
            description: "Compound annual growth rate representing the constant return that would produce the same terminal value",
            variables: [
                FormulaVariable(symbol: "\\bar{R}_G", name: "Geometric Mean Return", description: "Compound annual return rate", units: "Percentage", typicalRange: "Usually lower than arithmetic mean", notes: "True compound annual growth rate"),
                FormulaVariable(symbol: "R_t", name: "Return in Period t", description: "Holding period return for period t", units: "Percentage", typicalRange: "-100% to +∞", notes: "Individual period returns"),
                FormulaVariable(symbol: "T", name: "Number of Periods", description: "Total number of observation periods", units: "Count", typicalRange: "2 to thousands", notes: "Time horizon for compounding")
            ],
            derivation: FormulaDerivation(
                title: "Compound Annual Growth Rate Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Terminal value calculation", formula: "FV = PV \\times (1 + R_1) \\times (1 + R_2) \\times \\ldots \\times (1 + R_T)", explanation: "Future value after T periods"),
                    DerivationStep(stepNumber: 2, description: "Solve for constant growth rate", formula: "FV = PV \\times (1 + \\bar{R}_G)^T", explanation: "Equivalent compound return"),
                    DerivationStep(stepNumber: 3, description: "Set equal and solve", formula: "(1 + \\bar{R}_G)^T = \\prod_{t=1}^{T} (1 + R_t)", explanation: "Equate terminal values"),
                    DerivationStep(stepNumber: 4, description: "Take T-th root", formula: "1 + \\bar{R}_G = \\sqrt[T]{\\prod_{t=1}^{T} (1 + R_t)}", explanation: "Extract compound rate"),
                    DerivationStep(stepNumber: 5, description: "Final geometric mean", formula: "\\bar{R}_G = \\sqrt[T]{\\prod_{t=1}^{T} (1 + R_t)} - 1", explanation: "Geometric mean return")
                ],
                assumptions: [
                    "Reinvestment of all returns at the geometric mean rate",
                    "No additional cash flows during periods",
                    "Returns are multiplicatively linked",
                    "Terminal value is the investment objective"
                ],
                notes: "Always less than or equal to arithmetic mean due to volatility drag effect."
            ),
            variants: [
                FormulaVariant(name: "Logarithmic Form", formula: "\\bar{R}_G = \\exp\\left(\\frac{1}{T}\\sum_{t=1}^{T} \\ln(1 + R_t)\\right) - 1", description: "Geometric mean using natural logarithms", whenToUse: "For computational efficiency with large datasets"),
                FormulaVariant(name: "Annualized Geometric Return", formula: "R_{annual} = (1 + R_{total})^{\\frac{1}{years}} - 1", description: "Annualized version for multi-year periods", whenToUse: "When comparing investments over different time horizons")
            ],
            usageNotes: [
                "Best measure for compound annual growth rate and long-term performance",
                "Lower than arithmetic mean when returns are volatile (volatility drag)",
                "Appropriate for wealth accumulation and buy-and-hold strategies",
                "Cannot handle negative compound returns (e.g., if portfolio goes to zero)"
            ],
            examples: [
                FormulaExample(
                    title: "Investment Growth Analysis",
                    description: "Calculate compound annual return for investment over 3 years",
                    inputs: [
                        "Year 1 return": "20%",
                        "Year 2 return": "-10%",
                        "Year 3 return": "15%"
                    ],
                    calculation: "RG = [(1.20) × (0.90) × (1.15)]^(1/3) - 1 = [1.242]^(1/3) - 1 = 7.5%",
                    result: "Geometric mean return: 7.5%",
                    interpretation: "Despite volatile returns, the investment grew at a compound annual rate of 7.5%, which is the true rate that captures the wealth creation over the period."
                )
            ],
            relatedFormulas: ["arithmetic-mean", "volatility-drag", "compound-return"],
            tags: ["geometric-mean", "compound-return", "performance", "level-1"]
        )
    }
    
    private func createHarmonicMeanFormula() -> FormulaReference {
        FormulaReference(
            name: "Harmonic Mean",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\bar{X}_H = \\frac{n}{\\sum_{i=1}^{n} \\frac{1}{X_i}}",
            description: "Average of reciprocals, used for rates and ratios",
            variables: [
                FormulaVariable(symbol: "\\bar{X}_H", name: "Harmonic Mean", description: "Harmonic average of the dataset", units: "Same as X_i", typicalRange: "Positive values only", notes: "Always ≤ geometric mean ≤ arithmetic mean"),
                FormulaVariable(symbol: "X_i", name: "Individual Values", description: "Individual observations in the dataset", units: "Any positive unit", typicalRange: "> 0", notes: "Must be positive for harmonic mean to be meaningful"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "2 to thousands", notes: "All observations must be positive")
            ],
            derivation: FormulaDerivation(
                title: "Harmonic Mean for Rates and Ratios",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with arithmetic mean of reciprocals", formula: "\\frac{1}{\\bar{X}_H} = \\frac{1}{n}\\sum_{i=1}^{n} \\frac{1}{X_i}", explanation: "Average of inverse values"),
                    DerivationStep(stepNumber: 2, description: "Take reciprocal to get harmonic mean", formula: "\\bar{X}_H = \\frac{1}{\\frac{1}{n}\\sum_{i=1}^{n} \\frac{1}{X_i}}", explanation: "Invert the mean of reciprocals"),
                    DerivationStep(stepNumber: 3, description: "Simplify expression", formula: "\\bar{X}_H = \\frac{n}{\\sum_{i=1}^{n} \\frac{1}{X_i}}", explanation: "Final harmonic mean formula")
                ],
                assumptions: [
                    "All values must be positive",
                    "Appropriate for averaging rates, ratios, or prices",
                    "Used when dealing with time-based or efficiency measures",
                    "Lower bound for arithmetic and geometric means"
                ],
                notes: "Particularly useful for averaging P/E ratios, yields, or other rate measures."
            ),
            variants: [
                FormulaVariant(name: "Weighted Harmonic Mean", formula: "\\bar{X}_{H,w} = \\frac{\\sum w_i}{\\sum \\frac{w_i}{X_i}}", description: "Harmonic mean with weights", whenToUse: "When observations have different importance or frequencies"),
                FormulaVariant(name: "Portfolio P/E Harmonic Mean", formula: "P/E_{portfolio} = \\frac{\\sum w_i}{\\sum \\frac{w_i}{P/E_i}}", description: "Weighted harmonic mean for portfolio P/E ratios", whenToUse: "For calculating portfolio-level valuation metrics")
            ],
            usageNotes: [
                "Appropriate for averaging rates, ratios, and prices",
                "Gives less weight to extreme high values compared to arithmetic mean",
                "Commonly used for P/E ratios, yields, and price-based metrics",
                "Cannot be computed if any value is zero or negative"
            ],
            examples: [
                FormulaExample(
                    title: "Portfolio P/E Ratio Calculation",
                    description: "Calculate portfolio P/E using harmonic mean for three stocks",
                    inputs: [
                        "Stock A P/E": "15.0",
                        "Stock B P/E": "25.0", 
                        "Stock C P/E": "10.0"
                    ],
                    calculation: "Harmonic Mean P/E = 3 / (1/15 + 1/25 + 1/10) = 3 / (0.0667 + 0.04 + 0.10) = 3 / 0.2067 = 14.5",
                    result: "Portfolio P/E ratio: 14.5",
                    interpretation: "The harmonic mean P/E of 14.5 is more conservative than the arithmetic mean (16.7), giving less weight to the high P/E stock."
                )
            ],
            relatedFormulas: ["arithmetic-mean", "geometric-mean", "weighted-average"],
            tags: ["harmonic-mean", "ratios", "valuation", "level-1"]
        )
    }
    
    // MARK: - Statistical Measures Implementation
    
    private func createSampleVarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Variance",
            category: .quantitative,
            level: .levelI,
            mainFormula: "s^2 = \\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}",
            description: "Measure of the dispersion of sample data around the sample mean",
            variables: [
                FormulaVariable(symbol: "s^2", name: "Sample Variance", description: "Unbiased estimator of population variance", units: "Squared units of X", typicalRange: "≥ 0", notes: "Uses n-1 degrees of freedom"),
                FormulaVariable(symbol: "X_i", name: "Individual Observations", description: "Individual data points in the sample", units: "Any unit", typicalRange: "Any value", notes: "Sample data points"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Arithmetic mean of the sample", units: "Same as X", typicalRange: "Any value", notes: "Average of all observations"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations in the sample", units: "Count", typicalRange: "≥ 2", notes: "Need at least 2 observations")
            ],
            derivation: FormulaDerivation(
                title: "Unbiased Variance Estimation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with population variance definition", formula: "\\sigma^2 = E[(X - \\mu)^2]", explanation: "Expected squared deviation from mean"),
                    DerivationStep(stepNumber: 2, description: "Use sample mean as estimator", formula: "\\sum_{i=1}^{n} (X_i - \\bar{X})^2", explanation: "Sum of squared deviations from sample mean"),
                    DerivationStep(stepNumber: 3, description: "Apply Bessel's correction", formula: "s^2 = \\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}", explanation: "Divide by n-1 for unbiased estimate"),
                    DerivationStep(stepNumber: 4, description: "Loss of one degree of freedom", formula: "df = n - 1", explanation: "Sample mean constraint reduces degrees of freedom")
                ],
                assumptions: [
                    "Sample is representative of population",
                    "Observations are independent",
                    "No systematic bias in sampling",
                    "Finite population variance exists"
                ],
                notes: "Bessel's correction (n-1) provides unbiased estimator of population variance."
            ),
            variants: [
                FormulaVariant(name: "Population Variance", formula: "\\sigma^2 = \\frac{\\sum_{i=1}^{N} (X_i - \\mu)^2}{N}", description: "Population variance when all data is available", whenToUse: "When working with entire population, not a sample"),
                FormulaVariant(name: "Computational Formula", formula: "s^2 = \\frac{\\sum X_i^2 - \\frac{(\\sum X_i)^2}{n}}{n-1}", description: "Alternative formula for easier computation", whenToUse: "For hand calculations or computational efficiency")
            ],
            usageNotes: [
                "Foundation for standard deviation, confidence intervals, and hypothesis tests",
                "Sensitive to outliers - consider robust alternatives for skewed data",
                "Units are squared compared to original data",
                "Always non-negative; zero only when all values are identical"
            ],
            examples: [
                FormulaExample(
                    title: "Return Variance Calculation",
                    description: "Calculate variance of stock returns over 5 years",
                    inputs: [
                        "Returns": "12%, 8%, -5%, 15%, 10%",
                        "Sample mean": "8%",
                        "Sample size": "5"
                    ],
                    calculation: "s² = [(12-8)² + (8-8)² + (-5-8)² + (15-8)² + (10-8)²] / (5-1) = [16 + 0 + 169 + 49 + 4] / 4 = 59.5",
                    result: "Sample variance: 59.5 (percentage points)²",
                    interpretation: "The stock returns have a variance of 59.5, indicating moderate volatility around the 8% average return."
                )
            ],
            relatedFormulas: ["standard-deviation", "coefficient-variation", "confidence-intervals"],
            tags: ["variance", "dispersion", "risk", "statistics", "level-1"]
        )
    }
    
    private func createSampleStandardDeviationFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Standard Deviation", 
            category: .quantitative,
            level: .levelI,
            mainFormula: "s = \\sqrt{\\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}}",
            description: "Square root of sample variance, measuring dispersion in original units",
            variables: [
                FormulaVariable(symbol: "s", name: "Sample Standard Deviation", description: "Standard measure of dispersion", units: "Same as X", typicalRange: "≥ 0", notes: "Square root of variance"),
                FormulaVariable(symbol: "X_i", name: "Individual Observations", description: "Individual data points in the sample", units: "Any unit", typicalRange: "Any value", notes: "Sample data points"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Arithmetic mean of the sample", units: "Same as X", typicalRange: "Any value", notes: "Central tendency measure"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "≥ 2", notes: "Degrees of freedom = n-1")
            ],
            derivation: FormulaDerivation(
                title: "Standard Deviation from Variance",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with sample variance", formula: "s^2 = \\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}", explanation: "Unbiased variance estimator"),
                    DerivationStep(stepNumber: 2, description: "Take square root", formula: "s = \\sqrt{s^2}", explanation: "Return to original units"),
                    DerivationStep(stepNumber: 3, description: "Final formula", formula: "s = \\sqrt{\\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}}", explanation: "Standard deviation in original units")
                ],
                assumptions: [
                    "Same assumptions as sample variance",
                    "Meaningful for symmetric or near-symmetric distributions",
                    "Approximately 68% of data within 1 standard deviation for normal distributions",
                    "Linear transformation preserves relative standard deviation"
                ],
                notes: "Most commonly used measure of dispersion due to intuitive units and statistical properties."
            ),
            variants: [
                FormulaVariant(name: "Population Standard Deviation", formula: "\\sigma = \\sqrt{\\frac{\\sum_{i=1}^{N} (X_i - \\mu)^2}{N}}", description: "Population standard deviation", whenToUse: "When data represents entire population"),
                FormulaVariant(name: "Annualized Volatility", formula: "\\sigma_{annual} = \\sigma_{period} \\times \\sqrt{periods per year}", description: "Annualized standard deviation for financial returns", whenToUse: "Converting periodic volatility to annual terms")
            ],
            usageNotes: [
                "Primary measure of volatility in finance",
                "Used in risk management, portfolio optimization, and option pricing",
                "Basis for Value at Risk (VaR) calculations",
                "Key input for Sharpe ratio and other risk-adjusted performance measures"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Volatility Calculation",
                    description: "Calculate annual volatility from monthly returns",
                    inputs: [
                        "Monthly std dev": "4.2%",
                        "Periods per year": "12"
                    ],
                    calculation: "Annual volatility = 4.2% × √12 = 4.2% × 3.464 = 14.5%",
                    result: "Annualized volatility: 14.5%",
                    interpretation: "The stock has an annual volatility of 14.5%, indicating moderate risk with approximately 68% of annual returns expected within ±14.5% of the mean."
                )
            ],
            relatedFormulas: ["variance", "volatility", "value-at-risk", "sharpe-ratio"],
            tags: ["standard-deviation", "volatility", "risk", "dispersion", "level-1"]
        )
    }
    
    private func createSampleSkewnessFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Skewness",
            category: .quantitative,
            level: .levelI,
            mainFormula: "Skewness = \\frac{\\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^3}{s^3}",
            description: "Measure of asymmetry in the distribution of data around the mean",
            variables: [
                FormulaVariable(symbol: "Skewness", name: "Skewness Coefficient", description: "Measure of distributional asymmetry", units: "Dimensionless", typicalRange: "-∞ to +∞", notes: "0 = symmetric, >0 = right-skewed, <0 = left-skewed"),
                FormulaVariable(symbol: "X_i", name: "Individual Observations", description: "Data points in the sample", units: "Any unit", typicalRange: "Any value", notes: "Sample observations"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Average of sample observations", units: "Same as X", typicalRange: "Any value", notes: "Central tendency measure"),
                FormulaVariable(symbol: "s", name: "Sample Standard Deviation", description: "Measure of dispersion", units: "Same as X", typicalRange: "> 0", notes: "Used for standardization"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "≥ 3", notes: "Need minimum 3 observations")
            ],
            derivation: FormulaDerivation(
                title: "Third Moment Standardization",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate third central moment", formula: "m_3 = \\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^3", explanation: "Average of cubed deviations"),
                    DerivationStep(stepNumber: 2, description: "Standardize by cubed standard deviation", formula: "Skewness = \\frac{m_3}{s^3}", explanation: "Scale-invariant measure"),
                    DerivationStep(stepNumber: 3, description: "Final skewness formula", formula: "Skewness = \\frac{\\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^3}{s^3}", explanation: "Dimensionless asymmetry measure")
                ],
                assumptions: [
                    "Sample is representative of population",
                    "Standard deviation is positive (non-constant data)",
                    "Meaningful for continuous distributions",
                    "Interpretation assumes unimodal distribution"
                ],
                notes: "Critical for understanding tail risk and distribution shape in financial returns."
            ),
            variants: [
                FormulaVariant(name: "Adjusted Sample Skewness", formula: "Skew_{adj} = \\frac{n}{(n-1)(n-2)} \\times Skewness", description: "Bias-corrected skewness for small samples", whenToUse: "When sample size is small (n < 30)"),
                FormulaVariant(name: "Pearson's Skewness", formula: "Skew_P = \\frac{3(\\bar{X} - Median)}{s}", description: "Alternative skewness measure using median", whenToUse: "For heavily skewed or non-normal distributions")
            ],
            usageNotes: [
                "Positive skewness indicates right tail (higher probability of extreme positive values)",
                "Negative skewness indicates left tail (higher probability of extreme negative values)", 
                "Critical for risk management and option pricing",
                "Normal distribution has skewness = 0"
            ],
            examples: [
                FormulaExample(
                    title: "Return Distribution Analysis",
                    description: "Analyze skewness of hedge fund returns",
                    inputs: [
                        "Monthly returns": "2%, 1%, -8%, 4%, 3%, 6%, -2%, 5%",
                        "Sample mean": "1.375%",
                        "Standard deviation": "4.27%"
                    ],
                    calculation: "Calculate cubed deviations, sum, and divide by s³",
                    result: "Skewness: -0.85",
                    interpretation: "Negative skewness of -0.85 indicates left tail risk - higher probability of large negative returns than large positive returns."
                )
            ],
            relatedFormulas: ["kurtosis", "normal-distribution", "value-at-risk"],
            tags: ["skewness", "asymmetry", "distribution", "tail-risk", "level-1"]
        )
    }
    
    private func createSampleExcessKurtosisFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Excess Kurtosis",
            category: .quantitative,
            level: .levelI,
            mainFormula: "K_E = \\frac{\\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^4}{s^4} - 3",
            description: "Measure of tail heaviness relative to normal distribution (kurtosis minus 3)",
            variables: [
                FormulaVariable(symbol: "K_E", name: "Excess Kurtosis", description: "Tail heaviness relative to normal distribution", units: "Dimensionless", typicalRange: "-2 to +∞", notes: "0 = normal, >0 = fat tails, <0 = thin tails"),
                FormulaVariable(symbol: "X_i", name: "Individual Observations", description: "Sample data points", units: "Any unit", typicalRange: "Any value", notes: "Individual observations"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Sample average", units: "Same as X", typicalRange: "Any value", notes: "Central tendency"),
                FormulaVariable(symbol: "s", name: "Sample Standard Deviation", description: "Sample dispersion measure", units: "Same as X", typicalRange: "> 0", notes: "For standardization"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "≥ 4", notes: "Minimum for kurtosis calculation")
            ],
            derivation: FormulaDerivation(
                title: "Fourth Moment Analysis",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate fourth central moment", formula: "m_4 = \\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^4", explanation: "Average of fourth powers of deviations"),
                    DerivationStep(stepNumber: 2, description: "Calculate kurtosis", formula: "Kurtosis = \\frac{m_4}{s^4}", explanation: "Standardized fourth moment"),
                    DerivationStep(stepNumber: 3, description: "Calculate excess kurtosis", formula: "K_E = Kurtosis - 3", explanation: "Subtract normal distribution kurtosis"),
                    DerivationStep(stepNumber: 4, description: "Final formula", formula: "K_E = \\frac{\\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^4}{s^4} - 3", explanation: "Excess kurtosis formula")
                ],
                assumptions: [
                    "Sample represents population distribution",
                    "Fourth moment exists and is finite",
                    "Standard deviation is positive",
                    "Used for assessing tail risk"
                ],
                notes: "Essential for understanding extreme value probability and tail risk in financial markets."
            ),
            variants: [
                FormulaVariant(name: "Sample Kurtosis (without excess)", formula: "Kurt = \\frac{\\frac{1}{n}\\sum_{i=1}^{n} (X_i - \\bar{X})^4}{s^4}", description: "Raw kurtosis before subtracting 3", whenToUse: "When comparing to theoretical distributions"),
                FormulaVariant(name: "Bias-Corrected Excess Kurtosis", formula: "K_{E,adj} = \\frac{n-1}{(n-2)(n-3)}[(n+1)K_E + 6]", description: "Small sample correction", whenToUse: "For small samples (n < 30)")
            ],
            usageNotes: [
                "Positive excess kurtosis indicates fat tails (higher crash risk)",
                "Negative excess kurtosis indicates thin tails (lower extreme event probability)",
                "Critical for risk management and stress testing",
                "Normal distribution has excess kurtosis = 0"
            ],
            examples: [
                FormulaExample(
                    title: "Market Crash Risk Analysis",
                    description: "Analyze tail risk in stock market returns",
                    inputs: [
                        "Daily returns sample": "Large dataset",
                        "Calculated kurtosis": "5.2",
                        "Normal kurtosis": "3.0"
                    ],
                    calculation: "Excess kurtosis = 5.2 - 3.0 = 2.2",
                    result: "Excess kurtosis: 2.2",
                    interpretation: "Positive excess kurtosis of 2.2 indicates fat tails - higher probability of extreme market moves (crashes and rallies) than predicted by normal distribution."
                )
            ],
            relatedFormulas: ["skewness", "normal-distribution", "value-at-risk", "tail-risk"],
            tags: ["kurtosis", "tail-risk", "fat-tails", "extreme-values", "level-1"]
        )
    }
    
    private func createSampleCovarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Covariance",
            category: .quantitative,
            level: .levelI,
            mainFormula: "s_{XY} = \\frac{1}{n-1} \\sum_{i=1}^{n} (X_i - \\bar{X})(Y_i - \\bar{Y})",
            description: "Measure of how two variables move together, indicating the direction of linear relationship",
            variables: [
                FormulaVariable(symbol: "s_{XY}", name: "Sample Covariance", description: "Measure of joint variability between X and Y", units: "Product of X and Y units", typicalRange: "-∞ to +∞", notes: "Positive = move together, negative = move opposite"),
                FormulaVariable(symbol: "X_i, Y_i", name: "Paired Observations", description: "Corresponding data points for variables X and Y", units: "Respective variable units", typicalRange: "Any values", notes: "Must have equal number of observations"),
                FormulaVariable(symbol: "\\bar{X}, \\bar{Y}", name: "Sample Means", description: "Arithmetic means of X and Y samples", units: "Respective variable units", typicalRange: "Any values", notes: "Central tendency measures"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of paired observations", units: "Count", typicalRange: "≥ 2", notes: "Uses n-1 for unbiased estimation")
            ],
            derivation: FormulaDerivation(
                title: "Joint Variability Measurement",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define population covariance", formula: "\\sigma_{XY} = E[(X - \\mu_X)(Y - \\mu_Y)]", explanation: "Expected value of product of deviations"),
                    DerivationStep(stepNumber: 2, description: "Sample estimator with means", formula: "\\sum_{i=1}^{n} (X_i - \\bar{X})(Y_i - \\bar{Y})", explanation: "Sum of products of deviations from sample means"),
                    DerivationStep(stepNumber: 3, description: "Apply degrees of freedom correction", formula: "s_{XY} = \\frac{1}{n-1} \\sum_{i=1}^{n} (X_i - \\bar{X})(Y_i - \\bar{Y})", explanation: "Unbiased sample covariance estimator"),
                    DerivationStep(stepNumber: 4, description: "Interpretation of sign", formula: "s_{XY} > 0 \\Rightarrow \\text{positive relationship}", explanation: "Positive covariance indicates variables tend to move together")
                ],
                assumptions: [
                    "Paired observations are available for both variables",
                    "Linear relationship between variables",
                    "Observations are independent",
                    "Sample is representative of population"
                ],
                notes: "Foundation for correlation coefficient and portfolio risk analysis."
            ),
            variants: [
                FormulaVariant(name: "Population Covariance", formula: "\\sigma_{XY} = \\frac{1}{N} \\sum_{i=1}^{N} (X_i - \\mu_X)(Y_i - \\mu_Y)", description: "Population covariance when all data is available", whenToUse: "When working with entire population"),
                FormulaVariant(name: "Computational Formula", formula: "s_{XY} = \\frac{\\sum X_i Y_i - \\frac{\\sum X_i \\sum Y_i}{n}}{n-1}", description: "Alternative formula for easier computation", whenToUse: "For computational efficiency")
            ],
            usageNotes: [
                "Units make interpretation difficult - use correlation for standardized measure",
                "Essential for portfolio risk calculation and diversification analysis",
                "Zero covariance indicates no linear relationship (but may have nonlinear relationship)",
                "Sensitive to outliers and extreme values"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Return Covariance",
                    description: "Calculate covariance between two stock returns",
                    inputs: [
                        "Stock A returns": "10%, 5%, 15%, 8%",
                        "Stock B returns": "12%, 3%, 18%, 7%",
                        "Sample size": "4"
                    ],
                    calculation: "Calculate deviations from means, multiply pairs, sum and divide by n-1",
                    result: "Covariance: 0.00275 (or 27.5 squared percentage points)",
                    interpretation: "Positive covariance indicates the stocks tend to move in the same direction, useful for portfolio diversification analysis."
                )
            ],
            relatedFormulas: ["correlation", "portfolio-variance", "beta"],
            tags: ["covariance", "relationship", "portfolio", "diversification", "level-1"]
        )
    }
    
    private func createSampleCorrelationCoefficientFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Correlation Coefficient",
            category: .quantitative,
            level: .levelI,
            mainFormula: "r_{XY} = \\frac{s_{XY}}{s_X s_Y}",
            description: "Standardized measure of linear relationship strength between two variables",
            variables: [
                FormulaVariable(symbol: "r_{XY}", name: "Sample Correlation Coefficient", description: "Standardized measure of linear association", units: "Dimensionless", typicalRange: "-1 to +1", notes: "±1 = perfect linear relationship, 0 = no linear relationship"),
                FormulaVariable(symbol: "s_{XY}", name: "Sample Covariance", description: "Measure of joint variability", units: "Product of X and Y units", typicalRange: "-∞ to +∞", notes: "Numerator of correlation"),
                FormulaVariable(symbol: "s_X, s_Y", name: "Sample Standard Deviations", description: "Individual standard deviations of X and Y", units: "Respective variable units", typicalRange: "> 0", notes: "Used for standardization")
            ],
            derivation: FormulaDerivation(
                title: "Standardized Covariance",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with covariance", formula: "s_{XY} = \\frac{1}{n-1} \\sum_{i=1}^{n} (X_i - \\bar{X})(Y_i - \\bar{Y})", explanation: "Unstandardized measure of joint variability"),
                    DerivationStep(stepNumber: 2, description: "Standardize by individual standard deviations", formula: "r_{XY} = \\frac{s_{XY}}{s_X \\cdot s_Y}", explanation: "Remove scale effects"),
                    DerivationStep(stepNumber: 3, description: "Alternative computational formula", formula: "r_{XY} = \\frac{\\sum (X_i - \\bar{X})(Y_i - \\bar{Y})}{\\sqrt{\\sum (X_i - \\bar{X})^2 \\sum (Y_i - \\bar{Y})^2}}", explanation: "Direct calculation from deviations"),
                    DerivationStep(stepNumber: 4, description: "Range interpretation", formula: "-1 \\leq r_{XY} \\leq +1", explanation: "Bounded standardized measure")
                ],
                assumptions: [
                    "Linear relationship between variables",
                    "Both variables have positive variance",
                    "Paired observations are available",
                    "No extreme outliers distorting the relationship"
                ],
                notes: "Gold standard for measuring linear association strength between variables."
            ),
            variants: [
                FormulaVariant(name: "Pearson Product-Moment Correlation", formula: "r = \\frac{\\sum (X_i - \\bar{X})(Y_i - \\bar{Y})}{\\sqrt{\\sum (X_i - \\bar{X})^2 \\sum (Y_i - \\bar{Y})^2}}", description: "Full formula without separate covariance calculation", whenToUse: "For direct computation from raw data"),
                FormulaVariant(name: "Population Correlation", formula: "\\rho_{XY} = \\frac{\\sigma_{XY}}{\\sigma_X \\sigma_Y}", description: "Population correlation coefficient", whenToUse: "When working with entire population data")
            ],
            usageNotes: [
                "Measures only linear relationships - may miss nonlinear associations",
                "Critical for portfolio diversification and risk management",
                "Used in beta calculation for CAPM model",
                "R-squared in regression equals squared correlation coefficient"
            ],
            examples: [
                FormulaExample(
                    title: "Portfolio Diversification Analysis",
                    description: "Calculate correlation between two stocks for diversification benefits",
                    inputs: [
                        "Stock covariance": "0.00275",
                        "Stock A std dev": "6.8%",
                        "Stock B std dev": "7.2%"
                    ],
                    calculation: "r = 0.00275 / (0.068 × 0.072) = 0.00275 / 0.004896 = 0.562",
                    result: "Correlation coefficient: 0.562",
                    interpretation: "Moderate positive correlation of 0.562 indicates the stocks move together about 56% of the time, providing some but not optimal diversification benefits."
                )
            ],
            relatedFormulas: ["covariance", "beta", "r-squared", "portfolio-risk"],
            tags: ["correlation", "linear-relationship", "standardized", "diversification", "level-1"]
        )
    }
    
    // MARK: - Probability and Expected Values Implementation
    
    private func createExpectedValueDiscreteFormula() -> FormulaReference {
        FormulaReference(
            name: "Expected Value of Discrete Random Variable",
            category: .quantitative,
            level: .levelI,
            mainFormula: "E(X) = \\sum_{i=1}^{n} P(X_i) \\cdot X_i",
            description: "Probability-weighted average of all possible outcomes for a discrete random variable",
            variables: [
                FormulaVariable(symbol: "E(X)", name: "Expected Value", description: "Probability-weighted mean of the random variable", units: "Same as X", typicalRange: "Any value", notes: "Also denoted as μ"),
                FormulaVariable(symbol: "X_i", name: "Possible Outcomes", description: "All possible values the random variable can take", units: "Any unit", typicalRange: "Discrete values", notes: "Mutually exclusive outcomes"),
                FormulaVariable(symbol: "P(X_i)", name: "Probabilities", description: "Probability of each outcome occurring", units: "Probability", typicalRange: "0 to 1", notes: "Must sum to 1"),
                FormulaVariable(symbol: "n", name: "Number of Outcomes", description: "Total number of possible outcomes", units: "Count", typicalRange: "1 to many", notes: "Finite for discrete variables")
            ],
            derivation: FormulaDerivation(
                title: "Probability-Weighted Average",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define random variable", formula: "X \\text{ can take values } X_1, X_2, \\ldots, X_n", explanation: "Discrete set of possible outcomes"),
                    DerivationStep(stepNumber: 2, description: "Assign probabilities", formula: "P(X = X_i) = p_i \\text{ where } \\sum p_i = 1", explanation: "Probability distribution over outcomes"),
                    DerivationStep(stepNumber: 3, description: "Weight outcomes by probability", formula: "E(X) = \\sum_{i=1}^{n} p_i \\cdot X_i", explanation: "Probability-weighted sum"),
                    DerivationStep(stepNumber: 4, description: "Interpretation", formula: "E(X) = \\text{long-run average outcome}", explanation: "Central tendency of distribution")
                ],
                assumptions: [
                    "All possible outcomes are known",
                    "Probabilities are accurately assigned",
                    "Outcomes are mutually exclusive and exhaustive",
                    "Expected value exists (finite)"
                ],
                notes: "Foundation for decision-making under uncertainty and risk analysis."
            ),
            variants: [
                FormulaVariant(name: "Continuous Expected Value", formula: "E(X) = \\int_{-\\infty}^{\\infty} x \\cdot f(x) dx", description: "Expected value for continuous distributions", whenToUse: "When dealing with continuous random variables"),
                FormulaVariant(name: "Conditional Expected Value", formula: "E(X|Y) = \\sum_{i} X_i \\cdot P(X_i|Y)", description: "Expected value given information", whenToUse: "When additional information affects probabilities")
            ],
            usageNotes: [
                "Represents fair value or equilibrium price in financial markets",
                "Used for valuing uncertain cash flows and investment returns",
                "May not equal any actual possible outcome",
                "Linear operator: E(aX + bY) = aE(X) + bE(Y)"
            ],
            examples: [
                FormulaExample(
                    title: "Investment Return Analysis",
                    description: "Calculate expected return for a risky investment",
                    inputs: [
                        "Bull market": "Probability 30%, Return 25%",
                        "Normal market": "Probability 50%, Return 10%", 
                        "Bear market": "Probability 20%, Return -15%"
                    ],
                    calculation: "E(R) = 0.30(25%) + 0.50(10%) + 0.20(-15%) = 7.5% + 5% - 3% = 9.5%",
                    result: "Expected return: 9.5%",
                    interpretation: "The investment has an expected return of 9.5%, representing the probability-weighted average across all market scenarios."
                )
            ],
            relatedFormulas: ["variance", "portfolio-return", "risk-premium"],
            tags: ["expected-value", "probability", "uncertainty", "decision-making", "level-1"]
        )
    }
    
    private func createVarianceOfRandomVariableFormula() -> FormulaReference {
        FormulaReference(
            name: "Variance of Random Variable",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\sigma^2(X) = E[X - E(X)]^2 = \\sum_{i=1}^{n} P(X_i)[X_i - E(X)]^2",
            description: "Expected value of squared deviations from the mean, measuring dispersion of outcomes",
            variables: [
                FormulaVariable(symbol: "\\sigma^2(X)", name: "Variance", description: "Expected squared deviation from mean", units: "Squared units of X", typicalRange: "≥ 0", notes: "Measure of risk or uncertainty"),
                FormulaVariable(symbol: "X_i", name: "Possible Outcomes", description: "All possible values of the random variable", units: "Any unit", typicalRange: "Discrete values", notes: "Random variable realizations"),
                FormulaVariable(symbol: "P(X_i)", name: "Probabilities", description: "Probability of each outcome", units: "Probability", typicalRange: "0 to 1", notes: "Must sum to 1"),
                FormulaVariable(symbol: "E(X)", name: "Expected Value", description: "Mean of the distribution", units: "Same as X", typicalRange: "Any value", notes: "Center of distribution")
            ],
            derivation: FormulaDerivation(
                title: "Expected Squared Deviation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define variance conceptually", formula: "\\sigma^2(X) = E[(X - \\mu)^2]", explanation: "Expected value of squared deviations"),
                    DerivationStep(stepNumber: 2, description: "Expand for discrete case", formula: "\\sigma^2(X) = \\sum_{i=1}^{n} P(X_i) \\cdot [X_i - E(X)]^2", explanation: "Probability-weighted squared deviations"),
                    DerivationStep(stepNumber: 3, description: "Alternative computational formula", formula: "\\sigma^2(X) = E(X^2) - [E(X)]^2", explanation: "Often easier for calculation"),
                    DerivationStep(stepNumber: 4, description: "Interpretation", formula: "\\sigma(X) = \\sqrt{\\sigma^2(X)}", explanation: "Standard deviation in original units")
                ],
                assumptions: [
                    "Variance exists and is finite",
                    "Probabilities are correctly specified",
                    "All possible outcomes are included",
                    "Independence assumptions for portfolio applications"
                ],
                notes: "Primary measure of risk in finance, used for portfolio optimization and option pricing."
            ),
            variants: [
                FormulaVariant(name: "Computational Formula", formula: "\\sigma^2(X) = E(X^2) - [E(X)]^2", description: "Alternative calculation method", whenToUse: "When direct calculation of E(X²) is easier"),
                FormulaVariant(name: "Portfolio Variance", formula: "\\sigma^2(R_p) = \\sum w_i^2 \\sigma_i^2 + \\sum \\sum w_i w_j \\sigma_{ij}", description: "Variance for portfolio of assets", whenToUse: "For portfolio risk analysis")
            ],
            usageNotes: [
                "Fundamental measure of investment risk and uncertainty",
                "Used in mean-variance optimization and CAPM",
                "Standard deviation (square root) more intuitive as it's in original units",
                "Key input for Value at Risk and option pricing models"
            ],
            examples: [
                FormulaExample(
                    title: "Investment Risk Calculation",
                    description: "Calculate variance for the previous investment example",
                    inputs: [
                        "Expected return": "9.5%",
                        "Bull market": "Prob 30%, Return 25%",
                        "Normal market": "Prob 50%, Return 10%",
                        "Bear market": "Prob 20%, Return -15%"
                    ],
                    calculation: "σ² = 0.30(25-9.5)² + 0.50(10-9.5)² + 0.20(-15-9.5)² = 0.30(240.25) + 0.50(0.25) + 0.20(600.25) = 192.3",
                    result: "Variance: 192.3 (percentage points)², Standard deviation: 13.9%",
                    interpretation: "The investment has significant risk with a standard deviation of 13.9%, indicating substantial variability around the 9.5% expected return."
                )
            ],
            relatedFormulas: ["standard-deviation", "portfolio-risk", "value-at-risk"],
            tags: ["variance", "risk", "uncertainty", "dispersion", "level-1"]
        )
    }
    
    private func createBayesFormulaFormula() -> FormulaReference {
        FormulaReference(
            name: "Bayes' Formula",
            category: .quantitative,
            level: .levelI,
            mainFormula: "P(A|B) = \\frac{P(B|A) \\cdot P(A)}{P(B)}",
            description: "Updates probability of an event based on new information or evidence",
            variables: [
                FormulaVariable(symbol: "P(A|B)", name: "Posterior Probability", description: "Probability of A given evidence B", units: "Probability", typicalRange: "0 to 1", notes: "Updated probability after evidence"),
                FormulaVariable(symbol: "P(B|A)", name: "Likelihood", description: "Probability of observing B given A is true", units: "Probability", typicalRange: "0 to 1", notes: "Strength of evidence"),
                FormulaVariable(symbol: "P(A)", name: "Prior Probability", description: "Initial probability of A before evidence", units: "Probability", typicalRange: "0 to 1", notes: "Base rate or initial belief"),
                FormulaVariable(symbol: "P(B)", name: "Marginal Probability", description: "Total probability of observing evidence B", units: "Probability", typicalRange: "0 to 1", notes: "Normalizing factor")
            ],
            derivation: FormulaDerivation(
                title: "Conditional Probability Reversal",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with conditional probability", formula: "P(A|B) = \\frac{P(A \\cap B)}{P(B)}", explanation: "Definition of conditional probability"),
                    DerivationStep(stepNumber: 2, description: "Use symmetric joint probability", formula: "P(A \\cap B) = P(B \\cap A) = P(B|A) \\cdot P(A)", explanation: "Joint probability equals reverse conditional"),
                    DerivationStep(stepNumber: 3, description: "Substitute into formula", formula: "P(A|B) = \\frac{P(B|A) \\cdot P(A)}{P(B)}", explanation: "Bayes' formula"),
                    DerivationStep(stepNumber: 4, description: "Interpretation", formula: "\\text{Posterior} = \\frac{\\text{Likelihood} \\times \\text{Prior}}{\\text{Evidence}}", explanation: "Bayesian updating framework")
                ],
                assumptions: [
                    "Prior probabilities are meaningful and available",
                    "Likelihood function is correctly specified",
                    "Events are well-defined and measurable",
                    "All relevant information is incorporated"
                ],
                notes: "Foundation for Bayesian statistics and decision-making under uncertainty."
            ),
            variants: [
                FormulaVariant(name: "Multiple Hypotheses", formula: "P(A_i|B) = \\frac{P(B|A_i) \\cdot P(A_i)}{\\sum_j P(B|A_j) \\cdot P(A_j)}", description: "Bayes' formula with multiple competing hypotheses", whenToUse: "When choosing among several alternatives"),
                FormulaVariant(name: "Odds Form", formula: "\\frac{P(A|B)}{P(A^c|B)} = \\frac{P(B|A)}{P(B|A^c)} \\cdot \\frac{P(A)}{P(A^c)}", description: "Bayes' formula in odds ratio form", whenToUse: "When working with odds rather than probabilities")
            ],
            usageNotes: [
                "Essential for credit risk modeling and default probability updates",
                "Used in algorithmic trading for signal processing",
                "Foundation for machine learning and artificial intelligence",
                "Critical for updating investment views based on new market information"
            ],
            examples: [
                FormulaExample(
                    title: "Credit Risk Update",
                    description: "Update default probability after receiving credit rating downgrade",
                    inputs: [
                        "Prior default probability": "2%",
                        "Probability of downgrade given default": "80%",
                        "Overall probability of downgrade": "15%"
                    ],
                    calculation: "P(Default|Downgrade) = (0.80 × 0.02) / 0.15 = 0.016 / 0.15 = 10.67%",
                    result: "Updated default probability: 10.67%",
                    interpretation: "The credit downgrade significantly increases the estimated default probability from 2% to 10.67%, reflecting the informational content of the rating change."
                )
            ],
            relatedFormulas: ["conditional-probability", "total-probability", "decision-theory"],
            tags: ["bayes", "probability", "updating", "information", "level-1"]
        )
    }
    
    private func createTotalProbabilityRuleFormula() -> FormulaReference {
        FormulaReference(
            name: "Total Probability Rule for Expected Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "E(X) = E(X|S_1)P(S_1) + E(X|S_2)P(S_2) + \\ldots + E(X|S_n)P(S_n)",
            description: "Calculates expected value by conditioning on mutually exclusive and exhaustive scenarios",
            variables: [
                FormulaVariable(symbol: "E(X)", name: "Unconditional Expected Value", description: "Overall expected value across all scenarios", units: "Same as X", typicalRange: "Any value", notes: "Weighted average of conditional expectations"),
                FormulaVariable(symbol: "E(X|S_i)", name: "Conditional Expected Value", description: "Expected value given scenario S_i occurs", units: "Same as X", typicalRange: "Any value", notes: "Scenario-specific expectation"),
                FormulaVariable(symbol: "P(S_i)", name: "Scenario Probabilities", description: "Probability of each scenario occurring", units: "Probability", typicalRange: "0 to 1", notes: "Must sum to 1"),
                FormulaVariable(symbol: "S_i", name: "Scenarios", description: "Mutually exclusive and exhaustive states", units: "Categorical", typicalRange: "Discrete states", notes: "Complete partition of sample space")
            ],
            derivation: FormulaDerivation(
                title: "Scenario-Based Expected Value",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define mutually exclusive scenarios", formula: "S_1, S_2, \\ldots, S_n \\text{ where } \\bigcup S_i = \\Omega", explanation: "Complete partition of sample space"),
                    DerivationStep(stepNumber: 2, description: "Apply law of total expectation", formula: "E(X) = \\sum_{i=1}^{n} E(X|S_i) \\cdot P(S_i)", explanation: "Weight conditional expectations by scenario probabilities"),
                    DerivationStep(stepNumber: 3, description: "Verify probabilities sum to one", formula: "\\sum_{i=1}^{n} P(S_i) = 1", explanation: "Scenarios are exhaustive"),
                    DerivationStep(stepNumber: 4, description: "Economic interpretation", formula: "E(X) = \\text{probability-weighted scenario outcomes}", explanation: "Expected value across economic states")
                ],
                assumptions: [
                    "Scenarios are mutually exclusive (cannot occur simultaneously)",
                    "Scenarios are exhaustive (cover all possibilities)",
                    "Conditional expectations can be reliably estimated",
                    "Scenario probabilities are meaningful and stable"
                ],
                notes: "Widely used in finance for scenario analysis and stress testing."
            ),
            variants: [
                FormulaVariant(name: "Two-Scenario Model", formula: "E(X) = E(X|Good) \\cdot P(Good) + E(X|Bad) \\cdot P(Bad)", description: "Simplified binary scenario model", whenToUse: "For basic good/bad economic scenario analysis"),
                FormulaVariant(name: "Continuous Conditioning", formula: "E(X) = \\int E(X|Y=y) \\cdot f_Y(y) dy", description: "Continuous version using density function", whenToUse: "When conditioning variable is continuous")
            ],
            usageNotes: [
                "Foundation for scenario analysis in investment valuation",
                "Used in stress testing and Monte Carlo simulation",
                "Essential for economic capital calculations",
                "Basis for decision trees and real options analysis"
            ],
            examples: [
                FormulaExample(
                    title: "Economic Scenario Analysis",
                    description: "Calculate expected GDP growth across economic scenarios",
                    inputs: [
                        "Recession": "Probability 20%, GDP growth -2%",
                        "Normal growth": "Probability 60%, GDP growth 2.5%",
                        "Strong growth": "Probability 20%, GDP growth 5%"
                    ],
                    calculation: "E(GDP) = 0.20(-2%) + 0.60(2.5%) + 0.20(5%) = -0.4% + 1.5% + 1.0% = 2.1%",
                    result: "Expected GDP growth: 2.1%",
                    interpretation: "Across all economic scenarios, the expected GDP growth is 2.1%, incorporating the probability-weighted outcomes from recession, normal, and strong growth environments."
                )
            ],
            relatedFormulas: ["conditional-expectation", "scenario-analysis", "decision-trees"],
            tags: ["total-probability", "scenarios", "conditional", "economic-analysis", "level-1"]
        )
    }
    
    // MARK: - Portfolio Mathematics Implementation
    
    private func createPortfolioExpectedReturnFormula() -> FormulaReference {
        FormulaReference(
            name: "Portfolio Expected Return",
            category: .portfolio,
            level: .levelI,
            mainFormula: "E(R_P) = w_1 E(R_1) + w_2 E(R_2) + \\ldots + w_n E(R_n)",
            description: "Weighted average of individual asset expected returns in a portfolio",
            variables: [
                FormulaVariable(symbol: "E(R_P)", name: "Portfolio Expected Return", description: "Expected return of the portfolio", units: "Percentage", typicalRange: "Any value", notes: "Linear combination of asset returns"),
                FormulaVariable(symbol: "w_i", name: "Asset Weights", description: "Proportion of portfolio invested in asset i", units: "Decimal", typicalRange: "0 to 1", notes: "Must sum to 1"),
                FormulaVariable(symbol: "E(R_i)", name: "Asset Expected Returns", description: "Expected return of individual assets", units: "Percentage", typicalRange: "Any value", notes: "Individual asset return expectations")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Portfolio return is linear in weights", "Diversification affects risk but not expected return"],
            examples: [],
            relatedFormulas: ["portfolio-variance", "capm"],
            tags: ["portfolio", "expected-return", "weights", "level-1"]
        )
    }
    
    private func createPortfolioVarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Portfolio Variance",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\sigma^2(R_P) = \\sum_{i=1}^n \\sum_{j=1}^n w_i w_j Cov(R_i, R_j)",
            description: "Total risk of portfolio considering individual risks and correlations",
            variables: [
                FormulaVariable(symbol: "\\sigma^2(R_P)", name: "Portfolio Variance", description: "Total portfolio risk", units: "Squared percentage", typicalRange: "≥ 0", notes: "Includes diversification effects"),
                FormulaVariable(symbol: "w_i, w_j", name: "Asset Weights", description: "Portfolio weights for assets i and j", units: "Decimal", typicalRange: "0 to 1", notes: "Sum to 1 across all assets"),
                FormulaVariable(symbol: "Cov(R_i, R_j)", name: "Covariance", description: "Covariance between assets i and j", units: "Squared percentage", typicalRange: "Any value", notes: "Diagonal terms are variances")
            ],
            derivation: nil,
            variants: [
                FormulaVariant(name: "Two-Asset Portfolio", formula: "\\sigma^2_P = w_1^2\\sigma_1^2 + w_2^2\\sigma_2^2 + 2w_1w_2\\sigma_{12}", description: "Simplified two-asset case", whenToUse: "For basic portfolio risk calculations")
            ],
            usageNotes: ["Diversification reduces portfolio risk", "Correlation is key to risk reduction"],
            examples: [],
            relatedFormulas: ["covariance", "correlation", "diversification"],
            tags: ["portfolio", "variance", "risk", "diversification", "level-1"]
        )
    }
    
    private func createTwoAssetPortfolioVarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Two-Asset Portfolio Variance",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\sigma^2_P = w_1^2\\sigma_1^2 + w_2^2\\sigma_2^2 + 2w_1w_2\\sigma_{12}",
            description: "Portfolio variance for a two-asset portfolio showing diversification benefits",
            variables: [
                FormulaVariable(symbol: "\\sigma^2_P", name: "Portfolio Variance", description: "Total portfolio risk", units: "Squared percentage", typicalRange: "≥ 0", notes: "Always less than weighted average of individual variances"),
                FormulaVariable(symbol: "w_1, w_2", name: "Asset Weights", description: "Portfolio weights (w₁ + w₂ = 1)", units: "Decimal", typicalRange: "0 to 1", notes: "Investment proportions"),
                FormulaVariable(symbol: "\\sigma_1^2, \\sigma_2^2", name: "Individual Variances", description: "Risk of individual assets", units: "Squared percentage", typicalRange: "≥ 0", notes: "Individual asset risks"),
                FormulaVariable(symbol: "\\sigma_{12}", name: "Covariance", description: "Covariance between the two assets", units: "Squared percentage", typicalRange: "Any value", notes: "Key to diversification benefit")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Demonstrates power of diversification", "Negative correlation provides maximum risk reduction"],
            examples: [],
            relatedFormulas: ["correlation", "minimum-variance", "efficient-frontier"],
            tags: ["two-asset", "portfolio", "variance", "diversification", "level-1"]
        )
    }
    
    private func createSafetyFirstRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Safety-First Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "SFRatio = \\frac{E(R_P) - R_L}{\\sigma_P}",
            description: "Risk measure focusing on probability of falling below a threshold return",
            variables: [
                FormulaVariable(symbol: "SFRatio", name: "Safety-First Ratio", description: "Number of standard deviations above threshold", units: "Dimensionless", typicalRange: "Any value", notes: "Higher is better"),
                FormulaVariable(symbol: "E(R_P)", name: "Expected Portfolio Return", description: "Expected return of the portfolio", units: "Percentage", typicalRange: "Any value", notes: "Mean of return distribution"),
                FormulaVariable(symbol: "R_L", name: "Threshold Return", description: "Minimum acceptable return level", units: "Percentage", typicalRange: "Any value", notes: "Investor's disaster level"),
                FormulaVariable(symbol: "\\sigma_P", name: "Portfolio Standard Deviation", description: "Portfolio risk", units: "Percentage", typicalRange: "> 0", notes: "Portfolio volatility")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Maximizing this ratio minimizes shortfall probability", "Related to Value at Risk concepts"],
            examples: [],
            relatedFormulas: ["shortfall-risk", "value-at-risk", "sharpe-ratio"],
            tags: ["safety-first", "downside-risk", "threshold", "level-1"]
        )
    }
    
    // MARK: - Essential Corporate Finance and Economics Formulas
    
    private func createNetPresentValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Net Present Value (NPV)",
            category: .economics,
            level: .levelI,
            mainFormula: "NPV = \\sum_{t=0}^{T} \\frac{CF_t}{(1+r)^t}",
            description: "Present value of all cash flows minus initial investment",
            variables: [
                FormulaVariable(symbol: "NPV", name: "Net Present Value", description: "Value added by the project", units: "Currency", typicalRange: "Any value", notes: "Accept if NPV > 0"),
                FormulaVariable(symbol: "CF_t", name: "Cash Flow at Time t", description: "Net cash flow in period t", units: "Currency", typicalRange: "Any value", notes: "Usually negative at t=0"),
                FormulaVariable(symbol: "r", name: "Discount Rate", description: "Required rate of return", units: "Percentage", typicalRange: "> 0", notes: "Cost of capital"),
                FormulaVariable(symbol: "T", name: "Project Life", description: "Number of periods", units: "Time periods", typicalRange: "1 to many", notes: "Investment horizon")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Gold standard for investment decisions", "Additive property for portfolio of projects"],
            examples: [],
            relatedFormulas: ["irr", "payback-period", "profitability-index"],
            tags: ["npv", "capital-budgeting", "valuation", "level-1"]
        )
    }
    
    // MARK: - Placeholder implementations for remaining functions to avoid compilation errors
    
    private func createNonAnnualCompoundingFormula() -> FormulaReference {
        FormulaReference(name: "Non-Annual Compounding", category: .quantitative, level: .levelI, mainFormula: "PV = FV_N \\left( 1 + \\frac{R_S}{m} \\right)^{-mN}", description: "Present value with non-annual compounding", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["compounding", "time-value"])
    }
    
    private func createContinuouslyCompoundedReturnsFormula() -> FormulaReference {
        FormulaReference(name: "Continuously Compounded Returns", category: .quantitative, level: .levelI, mainFormula: "r_{0,T} = \\ln\\left(\\frac{P_t}{P_0}\\right)", description: "Logarithmic returns with continuous compounding", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["continuous", "returns"])
    }
    
    private func createRealReturnsFormula() -> FormulaReference {
        FormulaReference(name: "Real Returns", category: .quantitative, level: .levelI, mainFormula: "\\text{Real Return} = \\frac{1 + \\text{Nominal Return}}{1 + \\text{Inflation Rate}} - 1", description: "Inflation-adjusted returns", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["real-returns", "inflation"])
    }
    
    private func createLeveragedReturnFormula() -> FormulaReference {
        FormulaReference(name: "Leveraged Return", category: .quantitative, level: .levelI, mainFormula: "R_L = R_P + \\frac{V_B}{V_E}(R_P - r_D)", description: "Return on leveraged portfolio", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage", "debt"])
    }
    
    private func createTestOfSingleMeanFormula() -> FormulaReference {
        FormulaReference(name: "Test of Single Mean", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{\\bar{X} - \\mu_0}{s / \\sqrt{n}}", description: "Hypothesis test for population mean", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hypothesis-test", "t-test"])
    }
    
    private func createTestOfDifferenceInMeansFormula() -> FormulaReference {
        FormulaReference(name: "Test of Difference in Means", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{(\\bar{X}_1 - \\bar{X}_2) - (\\mu_1 - \\mu_2)}{s_p\\sqrt{\\frac{1}{n_1} + \\frac{1}{n_2}}}", description: "Test for difference between two means", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["two-sample", "t-test"])
    }
    
    private func createTestOfSingleVarianceFormula() -> FormulaReference {
        FormulaReference(name: "Test of Single Variance", category: .quantitative, level: .levelI, mainFormula: "\\chi^2 = \\frac{(n-1)s^2}{\\sigma_0^2}", description: "Chi-square test for population variance", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["chi-square", "variance"])
    }
    
    private func createTestOfCorrelationFormula() -> FormulaReference {
        FormulaReference(name: "Test of Correlation", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{r\\sqrt{n-2}}{\\sqrt{1-r^2}}", description: "Test for significant correlation", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["correlation", "significance"])
    }
    
    private func createChiSquareTestFormula() -> FormulaReference {
        FormulaReference(name: "Chi-Square Test of Independence", category: .quantitative, level: .levelI, mainFormula: "\\chi^{2} = \\sum_{i=1}^{m} \\frac{(O_{ij} - E_{ij})^{2}}{E_{ij}}", description: "Test for independence in contingency tables", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["chi-square", "independence"])
    }
    
    private func createRegressionSlopeFormula() -> FormulaReference {
        FormulaReference(name: "Regression Slope Coefficient", category: .quantitative, level: .levelI, mainFormula: "\\hat{b}_1 = \\frac{\\sum_{i=1}^{n} (Y_i - \\bar{Y})(X_i - \\bar{X})}{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}", description: "Slope coefficient in simple linear regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression", "slope"])
    }
    
    private func createRegressionInterceptFormula() -> FormulaReference {
        FormulaReference(name: "Regression Intercept", category: .quantitative, level: .levelI, mainFormula: "\\hat{b}_0 = \\bar{Y} - \\hat{b}_1\\bar{X}", description: "Intercept in simple linear regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression", "intercept"])
    }
    
    private func createCoefficientOfDeterminationFormula() -> FormulaReference {
        FormulaReference(name: "Coefficient of Determination", category: .quantitative, level: .levelI, mainFormula: "R^2 = \\frac{SSR}{SST} = 1 - \\frac{SSE}{SST}", description: "Proportion of variance explained by regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["r-squared", "goodness-of-fit"])
    }
    
    private func createANOVAFTestFormula() -> FormulaReference {
        FormulaReference(name: "ANOVA F-Test", category: .quantitative, level: .levelI, mainFormula: "F = \\frac{MSR}{MSE}", description: "F-test for overall regression significance", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["f-test", "anova"])
    }
    
    private func createPredictionIntervalsFormula() -> FormulaReference {
        FormulaReference(name: "Prediction Intervals", category: .quantitative, level: .levelI, mainFormula: "\\hat{Y}_f \\pm t_{\\alpha/2} \\times s_f", description: "Confidence interval for individual predictions", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["prediction", "confidence"])
    }
    
    // Continue with more essential formulas...
    private func createFiscalMultiplierFormula() -> FormulaReference {
        FormulaReference(name: "Fiscal Multiplier", category: .economics, level: .levelI, mainFormula: "\\text{Fiscal Multiplier} = \\frac{1}{1 - c(1 - t)}", description: "Effect of fiscal policy on GDP", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fiscal", "multiplier"])
    }
    
    private func createDisposableIncomeFormula() -> FormulaReference {
        FormulaReference(name: "Disposable Income", category: .economics, level: .levelI, mainFormula: "YD = Y - NT = (1 - t)Y", description: "After-tax income available for consumption", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["income", "taxes"])
    }
    
    private func createCrossRateFormula() -> FormulaReference {
        FormulaReference(name: "Cross Exchange Rate", category: .economics, level: .levelI, mainFormula: "\\frac{A}{B} = \\frac{A/C}{B/C}", description: "Exchange rate between two currencies", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fx", "cross-rate"])
    }
    
    private func createForwardExchangeRateFormula() -> FormulaReference {
        FormulaReference(name: "Forward Exchange Rate", category: .economics, level: .levelI, mainFormula: "F_{A/B} = S_{A/B} \\times \\left[\\frac{1 + r_A \\times T}{1 + r_B \\times T}\\right]", description: "Forward rate based on interest rate differential", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["forward", "fx"])
    }
    
    // Add remaining placeholder implementations for all declared functions...
    // [Continue with all other functions to avoid compilation errors]
    
    // MARK: - Simplified implementations for remaining functions
    private func createInternalRateOfReturnFormula() -> FormulaReference {
        FormulaReference(name: "Internal Rate of Return", category: .economics, level: .levelI, mainFormula: "\\sum_{t=0}^{T} \\frac{CF_t}{(1 + IRR)^t} = 0", description: "Discount rate that makes NPV equal to zero", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["irr", "capital-budgeting"])
    }
    
    private func createReturnOnInvestedCapitalFormula() -> FormulaReference {
        FormulaReference(name: "Return on Invested Capital", category: .economics, level: .levelI, mainFormula: "ROIC = \\frac{\\text{After-tax operating profit}}{\\text{Average invested capital}}", description: "Profitability measure for invested capital", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["roic", "profitability"])
    }
    
    private func createWeightedAverageCostOfCapitalFormula() -> FormulaReference {
        FormulaReference(name: "Weighted Average Cost of Capital", category: .economics, level: .levelI, mainFormula: "WACC = w_d r_d (1-t) + w_e r_e", description: "Blended cost of debt and equity financing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["wacc", "cost-of-capital"])
    }
    
    private func createInterestCoverageFormula() -> FormulaReference {
        FormulaReference(name: "Interest Coverage Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Interest Coverage} = \\frac{\\text{EBIT}}{\\text{Interest Expense}}", description: "Ability to service debt obligations", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["coverage", "solvency"])
    }
    
    private func createModiglianiMillerPropositionsFormula() -> FormulaReference {
        FormulaReference(name: "Modigliani-Miller Propositions", category: .economics, level: .levelII, mainFormula: "V_L = V_U + tD", description: "Capital structure irrelevance with taxes", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["mm", "capital-structure"])
    }
    
    // Add all remaining function implementations with basic structures to avoid compilation errors
    // [This would continue for all remaining declared functions...]
    
    // For now, I'll add the essential ones and implement a basic structure for others
    // [The remaining functions would follow the same pattern]
}

// MARK: - Add all remaining placeholder implementations to prevent compilation errors
extension FormulaDatabase {
    
    // Add minimal implementations for all remaining declared functions
    // This ensures the app compiles while we continue adding comprehensive formulas
    
    private func createGrossProfitFormula() -> FormulaReference {
        FormulaReference(name: "Gross Profit", category: .economics, level: .levelI, mainFormula: "\\text{Gross Profit} = \\text{Revenue} - \\text{COGS}", description: "Profit before operating expenses", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["gross-profit"])
    }
    
    private func createReturnOnEquityFormula() -> FormulaReference {
        FormulaReference(name: "Return on Equity", category: .economics, level: .levelI, mainFormula: "ROE = \\frac{\\text{Net Income}}{\\text{Average Shareholders' Equity}}", description: "Profitability relative to shareholders' equity", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["roe"])
    }
    
    private func createNetProfitMarginFormula() -> FormulaReference {
        FormulaReference(name: "Net Profit Margin", category: .economics, level: .levelI, mainFormula: "\\text{Net Profit Margin} = \\frac{\\text{Net Income}}{\\text{Revenue}}", description: "Net income as percentage of revenue", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["margin"])
    }
    
    private func createBasicEPSFormula() -> FormulaReference {
        FormulaReference(name: "Basic Earnings Per Share", category: .economics, level: .levelI, mainFormula: "\\text{Basic EPS} = \\frac{\\text{Net Income} - \\text{Preferred Dividends}}{\\text{Weighted Average Shares Outstanding}}", description: "Earnings available to common shareholders per share", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["eps"])
    }
    
    private func createDilutedEPSFormula() -> FormulaReference {
        FormulaReference(name: "Diluted Earnings Per Share", category: .economics, level: .levelI, mainFormula: "\\text{Diluted EPS} = \\frac{\\text{Adjusted Net Income}}{\\text{Diluted Shares Outstanding}}", description: "EPS assuming conversion of all dilutive securities", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["diluted-eps"])
    }
    
    // Add minimal implementations for all remaining functions...
    
    private func createCurrentRatioFormula() -> FormulaReference {
        FormulaReference(name: "Current Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Current Ratio} = \\frac{\\text{Current Assets}}{\\text{Current Liabilities}}", description: "Short-term liquidity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity"])
    }
    
    private func createQuickRatioFormula() -> FormulaReference {
        FormulaReference(name: "Quick Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Quick Ratio} = \\frac{\\text{Cash + Securities + Receivables}}{\\text{Current Liabilities}}", description: "Acid-test liquidity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity"])
    }
    
    private func createCashRatioFormula() -> FormulaReference {
        FormulaReference(name: "Cash Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Cash Ratio} = \\frac{\\text{Cash + Marketable Securities}}{\\text{Current Liabilities}}", description: "Most conservative liquidity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity"])
    }
    
    private func createInventoryTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Inventory Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Inventory Turnover} = \\frac{\\text{COGS}}{\\text{Average Inventory}}", description: "Efficiency of inventory management", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    private func createReceivablesTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Receivables Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Receivables Turnover} = \\frac{\\text{Revenue}}{\\text{Average Receivables}}", description: "Efficiency of credit collection", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    private func createPayablesTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Payables Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Payables Turnover} = \\frac{\\text{COGS}}{\\text{Average Payables}}", description: "Payment frequency to suppliers", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    private func createAssetTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Asset Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Asset Turnover} = \\frac{\\text{Revenue}}{\\text{Average Total Assets}}", description: "Efficiency of asset utilization", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    private func createFixedAssetTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Fixed Asset Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Fixed Asset Turnover} = \\frac{\\text{Revenue}}{\\text{Average Net PP&E}}", description: "Efficiency of fixed asset utilization", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    private func createDebtToEquityRatioFormula() -> FormulaReference {
        FormulaReference(name: "Debt-to-Equity Ratio", category: .economics, level: .levelI, mainFormula: "\\text{D/E} = \\frac{\\text{Total Debt}}{\\text{Total Equity}}", description: "Financial leverage measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    private func createDebtToAssetsRatioFormula() -> FormulaReference {
        FormulaReference(name: "Debt-to-Assets Ratio", category: .economics, level: .levelI, mainFormula: "\\text{D/A} = \\frac{\\text{Total Debt}}{\\text{Total Assets}}", description: "Asset financing structure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    private func createFinancialLeverageRatioFormula() -> FormulaReference {
        FormulaReference(name: "Financial Leverage", category: .economics, level: .levelI, mainFormula: "\\text{Financial Leverage} = \\frac{\\text{Total Assets}}{\\text{Total Equity}}", description: "Equity multiplier", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    private func createTimesInterestEarnedFormula() -> FormulaReference {
        FormulaReference(name: "Times Interest Earned", category: .economics, level: .levelI, mainFormula: "\\text{TIE} = \\frac{\\text{EBIT}}{\\text{Interest Expense}}", description: "Interest coverage ability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["coverage"])
    }
    
    private func createGrossMarginFormula() -> FormulaReference {
        FormulaReference(name: "Gross Margin", category: .economics, level: .levelI, mainFormula: "\\text{Gross Margin} = \\frac{\\text{Gross Profit}}{\\text{Revenue}}", description: "Gross profitability measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    private func createOperatingMarginFormula() -> FormulaReference {
        FormulaReference(name: "Operating Margin", category: .economics, level: .levelI, mainFormula: "\\text{Operating Margin} = \\frac{\\text{Operating Income}}{\\text{Revenue}}", description: "Operating profitability measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    private func createNetMarginFormula() -> FormulaReference {
        FormulaReference(name: "Net Margin", category: .economics, level: .levelI, mainFormula: "\\text{Net Margin} = \\frac{\\text{Net Income}}{\\text{Revenue}}", description: "Bottom-line profitability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    private func createReturnOnAssetsFormula() -> FormulaReference {
        FormulaReference(name: "Return on Assets", category: .economics, level: .levelI, mainFormula: "\\text{ROA} = \\frac{\\text{Net Income}}{\\text{Average Total Assets}}", description: "Asset efficiency profitability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    private func createReturnOnInvestedCapitalROICFormula() -> FormulaReference {
        FormulaReference(name: "Return on Invested Capital (ROIC)", category: .economics, level: .levelI, mainFormula: "\\text{ROIC} = \\frac{\\text{NOPAT}}{\\text{Invested Capital}}", description: "Capital efficiency measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["roic"])
    }
    
    private func createDuPontROEFormula() -> FormulaReference {
        FormulaReference(name: "DuPont ROE", category: .economics, level: .levelI, mainFormula: "\\text{ROE} = \\text{Net Margin} \\times \\text{Asset Turnover} \\times \\text{Equity Multiplier}", description: "Three-factor ROE decomposition", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["dupont"])
    }
    
    private func createDuPontROAFormula() -> FormulaReference {
        FormulaReference(name: "DuPont ROA", category: .economics, level: .levelI, mainFormula: "\\text{ROA} = \\text{Net Margin} \\times \\text{Asset Turnover}", description: "Two-factor ROA decomposition", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["dupont"])
    }
    
    private func createFreeCashFlowToFirmFormula() -> FormulaReference {
        FormulaReference(name: "Free Cash Flow to Firm", category: .economics, level: .levelI, mainFormula: "\\text{FCFF} = \\text{CFO} + \\text{Interest}(1-t) - \\text{FCInv}", description: "Cash available to all investors", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-flow"])
    }
    
    private func createFreeCashFlowToEquityFormula() -> FormulaReference {
        FormulaReference(name: "Free Cash Flow to Equity", category: .economics, level: .levelI, mainFormula: "\\text{FCFE} = \\text{FCFF} - \\text{Interest}(1-t) + \\text{Net Borrowing}", description: "Cash available to equity holders", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-flow"])
    }
    
    private func createPriceReturnIndexFormula() -> FormulaReference {
        FormulaReference(name: "Price Return Index", category: .equity, level: .levelI, mainFormula: "V_{PRI} = \\frac{\\sum_{i=1}^{N} n_i P_i}{D}", description: "Index reflecting only price changes", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["index"])
    }
    
    private func createTotalReturnIndexFormula() -> FormulaReference {
        FormulaReference(name: "Total Return Index", category: .equity, level: .levelI, mainFormula: "TR_I = \\frac{V_{PRI1} - V_{PRI0} + Inc_I}{V_{PRI0}}", description: "Index including dividends and income", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["index"])
    }
    
    private func createMarketCapWeightingFormula() -> FormulaReference {
        FormulaReference(name: "Market Cap Weighting", category: .equity, level: .levelI, mainFormula: "w_i = \\frac{Q_i P_i}{\\sum_{j=1}^{N} Q_j P_j}", description: "Market capitalization-based index weighting", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["weighting"])
    }
    
    private func createDividendDiscountModelFormula() -> FormulaReference {
        FormulaReference(name: "Dividend Discount Model", category: .equity, level: .levelI, mainFormula: "P_0 = \\frac{D_1}{r-g}", description: "Gordon growth model for equity valuation", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ddm"])
    }
    
    private func createTwoStageDividendDiscountModelFormula() -> FormulaReference {
        FormulaReference(name: "Two-Stage DDM", category: .equity, level: .levelI, mainFormula: "P_0 = \\sum_{t=1}^{n} \\frac{D_0(1+g_s)^t}{(1+r)^t} + \\frac{P_n}{(1+r)^n}", description: "DDM with two growth phases", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ddm"])
    }
    
    private func createPriceToEarningsRatioFormula() -> FormulaReference {
        FormulaReference(name: "Price-to-Earnings Ratio", category: .equity, level: .levelI, mainFormula: "P/E = \\frac{\\text{Price per Share}}{\\text{Earnings per Share}}", description: "Valuation multiple based on earnings", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["valuation"])
    }
    
    private func createPriceToBookRatioFormula() -> FormulaReference {
        FormulaReference(name: "Price-to-Book Ratio", category: .equity, level: .levelI, mainFormula: "P/B = \\frac{\\text{Market Price per Share}}{\\text{Book Value per Share}}", description: "Valuation relative to book value", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["valuation"])
    }
    
    private func createEnterpriseValueFormula() -> FormulaReference {
        FormulaReference(name: "Enterprise Value", category: .equity, level: .levelI, mainFormula: "EV = \\text{Market Cap} + \\text{Total Debt} - \\text{Cash}", description: "Total firm value measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["valuation"])
    }
    
    // Fixed Income
    private func createZeroCouponBondPriceFormula() -> FormulaReference {
        FormulaReference(name: "Zero-Coupon Bond Price", category: .fixedIncome, level: .levelI, mainFormula: "P = \\frac{FV}{(1+r)^n}", description: "Present value of zero-coupon bond", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bond-pricing"])
    }
    
    private func createCouponBondPriceFormula() -> FormulaReference {
        FormulaReference(name: "Coupon Bond Price", category: .fixedIncome, level: .levelI, mainFormula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1+r)^t} + \\frac{FV}{(1+r)^n}", description: "Present value of coupon-paying bond", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bond-pricing"])
    }
    
    private func createCurrentYieldBondFormula() -> FormulaReference {
        FormulaReference(name: "Current Yield", category: .fixedIncome, level: .levelI, mainFormula: "\\text{Current Yield} = \\frac{\\text{Annual Coupon}}{\\text{Bond Price}}", description: "Annual coupon as percentage of price", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["yield"])
    }
    
    private func createYieldToMaturityBondFormula() -> FormulaReference {
        FormulaReference(name: "Yield to Maturity", category: .fixedIncome, level: .levelI, mainFormula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1+YTM)^t} + \\frac{FV}{(1+YTM)^n}", description: "Internal rate of return for bonds", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["yield"])
    }
    
    private func createMacaulayDurationBondFormula() -> FormulaReference {
        FormulaReference(name: "Macaulay Duration", category: .fixedIncome, level: .levelI, mainFormula: "D_{Mac} = \\frac{\\sum_{t=1}^{n} t \\times \\frac{CF_t}{(1+r)^t}}{P}", description: "Weighted average time to cash flows", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["duration"])
    }
    
    private func createModifiedDurationBondFormula() -> FormulaReference {
        FormulaReference(name: "Modified Duration", category: .fixedIncome, level: .levelI, mainFormula: "D_{Mod} = \\frac{D_{Mac}}{1+r}", description: "Price sensitivity to yield changes", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["duration"])
    }
    
    private func createBondConvexityFormula() -> FormulaReference {
        FormulaReference(name: "Bond Convexity", category: .fixedIncome, level: .levelI, mainFormula: "Convexity = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{CF_t \\times t(t+1)}{(1+r)^{t+2}}", description: "Second-order price sensitivity", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["convexity"])
    }
    
    private func createEffectiveDurationBondFormula() -> FormulaReference {
        FormulaReference(name: "Effective Duration", category: .fixedIncome, level: .levelII, mainFormula: "D_{eff} = \\frac{P_{-\\Delta y} - P_{+\\Delta y}}{2 \\times P_0 \\times \\Delta y}", description: "Duration for bonds with embedded options", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["duration"])
    }
    
    // Derivatives
    private func createForwardContractPricingFormula() -> FormulaReference {
        FormulaReference(name: "Forward Contract Pricing", category: .derivatives, level: .levelI, mainFormula: "F_0 = S_0 e^{rT}", description: "No-arbitrage forward price", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["forwards"])
    }
    
    private func createFuturesContractPricingFormula() -> FormulaReference {
        FormulaReference(name: "Futures Contract Pricing", category: .derivatives, level: .levelI, mainFormula: "F_0 = S_0 e^{(r-q)T}", description: "Futures price with convenience yield", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["futures"])
    }
    
    private func createPutCallParityOptionsFormula() -> FormulaReference {
        FormulaReference(name: "Put-Call Parity", category: .derivatives, level: .levelI, mainFormula: "C + Ke^{-rT} = P + S_0", description: "No-arbitrage relationship for options", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["options"])
    }
    
    private func createBlackScholesCallOptionFormula() -> FormulaReference {
        FormulaReference(name: "Black-Scholes Call Option", category: .derivatives, level: .levelII, mainFormula: "C = S_0 N(d_1) - Ke^{-rT} N(d_2)", description: "European call option pricing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["black-scholes"])
    }
    
    private func createBlackScholesPutOptionFormula() -> FormulaReference {
        FormulaReference(name: "Black-Scholes Put Option", category: .derivatives, level: .levelII, mainFormula: "P = Ke^{-rT} N(-d_2) - S_0 N(-d_1)", description: "European put option pricing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["black-scholes"])
    }
    
    private func createBinomialOptionPricingFormula() -> FormulaReference {
        FormulaReference(name: "Binomial Option Pricing", category: .derivatives, level: .levelI, mainFormula: "V_0 = \\frac{pV_u + (1-p)V_d}{1+r}", description: "One-period binomial model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["binomial"])
    }
    
    // Alternative Investments
    private func createPrivateEquityReturnFormula() -> FormulaReference {
        FormulaReference(name: "Private Equity Returns", category: .alternatives, level: .levelI, mainFormula: "IRR = \\text{Rate that makes NPV of cash flows = 0}", description: "Private equity performance measurement", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["private-equity"])
    }
    
    private func createRealEstateCapRateFormula() -> FormulaReference {
        FormulaReference(name: "Capitalization Rate", category: .alternatives, level: .levelI, mainFormula: "\\text{Cap Rate} = \\frac{\\text{NOI}}{\\text{Property Value}}", description: "Real estate yield measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["real-estate"])
    }
    
    private func createHedgeFundPerformanceFormula() -> FormulaReference {
        FormulaReference(name: "Hedge Fund Performance", category: .alternatives, level: .levelI, mainFormula: "\\text{Net Return} = \\text{Gross Return} - \\text{Management Fee} - \\text{Incentive Fee}", description: "Hedge fund return calculation", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hedge-funds"])
    }
    
    // Portfolio Management
    private func createCapitalAssetPricingModelFormula() -> FormulaReference {
        FormulaReference(name: "Capital Asset Pricing Model", category: .portfolio, level: .levelI, mainFormula: "E(R_i) = R_f + \\beta_i [E(R_m) - R_f]", description: "Expected return based on systematic risk", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["capm"])
    }
    
    private func createPortfolioExpectedReturnDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Portfolio Expected Return (Detailed)", category: .portfolio, level: .levelI, mainFormula: "E(R_P) = \\sum_{i=1}^{n} w_i E(R_i)", description: "Detailed portfolio expected return", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["portfolio"])
    }
    
    private func createSharpeRatioDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Sharpe Ratio", category: .portfolio, level: .levelI, mainFormula: "\\text{Sharpe} = \\frac{E(R_p) - R_f}{\\sigma_p}", description: "Risk-adjusted performance measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["sharpe"])
    }
    
    private func createTreynorRatioDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Treynor Ratio", category: .portfolio, level: .levelI, mainFormula: "\\text{Treynor} = \\frac{E(R_p) - R_f}{\\beta_p}", description: "Return per unit of systematic risk", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["treynor"])
    }
    
    private func createJensensAlphaFormula() -> FormulaReference {
        FormulaReference(name: "Jensen's Alpha", category: .portfolio, level: .levelI, mainFormula: "\\alpha = R_p - [R_f + \\beta_p(R_m - R_f)]", description: "Risk-adjusted excess return", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["alpha"])
    }
    
    private func createInformationRatioDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Information Ratio", category: .portfolio, level: .levelI, mainFormula: "\\text{IR} = \\frac{\\text{Active Return}}{\\text{Tracking Error}}", description: "Active management skill measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["information-ratio"])
    }
}


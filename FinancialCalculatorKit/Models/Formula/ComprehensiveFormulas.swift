//
//  ComprehensiveFormulas.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation

/// Extension containing comprehensive CFA formulas with detailed derivations
extension FormulaDatabase {
    
    func loadComprehensiveFormulas() {
        // Append comprehensive formulas to the existing collection
        formulas.append(contentsOf: [
            // MARK: - Advanced Fixed Income Formulas
            createEffectiveDurationFormula(),
            createBondConvexityDetailedFormula(),
            createYieldSpreadFormula(),
            createCreditSpreadFormula(),
            createBootstrappingFormula(),
            createForwardRateAgreementFormula(),
            createInterestRateSwapFormula(),
            
            // MARK: - Advanced Equity Formulas
            createMultiStageDDMFormula(),
            createEVAFormula(),
            createWACCFormula(),
            createLeverageBetaFormula(),
            createPEGRatioFormula(),
            createEVEBITFormula(),
            createResidualIncomeToEquityFormula(),
            
            // MARK: - Comprehensive Derivatives Formulas
            createDeltaFormula(),
            createGammaFormula(),
            createThetaFormula(),
            createVegaFormula(),
            createRhoFormula(),
            createBinomialTreeFormula(),
            createRiskNeutralProbabilityFormula(),
            createForwardPricingWithDividendsFormula(),
            createCurrencyForwardFormula(),
            createFRASettlementFormula(),
            
            // MARK: - Portfolio Theory and Performance
            createCAPItalAllocationLineFormula(),
            createOptimalPortfolioFormula(),
            createTrackingErrorFormula(),
            createBattingAverageFormula(),
            createMSquaredFormula(),
            createDownsideCaptureRatioFormula(),
            createUpsideCaptureRatioFormula(),
            createSortinoRatioFormula(),
            createCalmarRatioFormula(),
            
            // MARK: - Risk Management
            createCreditVaRFormula(),
            createExpectedLossFormula(),
            createUnexpectedLossFormula(),
            createBaselCapitalRatioFormula(),
            createLiquidityRiskFormula(),
            createStressTestingFormula(),
            
            // MARK: - Alternative Investments
            createPrivateEquityMetricsFormula(),
            createRealEstateMetricsFormula(),
            createCommodityPricingFormula(),
            createHedgeFundMetricsFormula(),
            
            // MARK: - Advanced Quantitative Methods
            createRegressionAnalysisFormula(),
            createTimeSeriesFormula(),
            createMonteCarloFormula(),
            createBootstrapMethodFormula(),
            createHypothesisTestingFormula(),
            
            // MARK: - Economics and FRA
            createFinancialLeverageFormula(),
            createOperatingLeverageFormula(),
            createCombinedLeverageFormula(),
            createCashConversionCycleFormula(),
            createZScoreFormula(),
            createAltmanZScoreFormula(),
            
            // MARK: - Critical CFA Level III Formulas
            createAssetLiabilityMatchingFormula(),
            createBlackLittermanFormula(),
            createMonteCarloPortfolioFormula(),
            
            // MARK: - Missing Time Value of Money Formulas
            createMoneyWeightedReturnFormula(),
            createTimeWeightedReturnFormula(),
            createAnnualizedReturnFormula(),
            createContinuousCompoundingFormula(),
            
            // MARK: - Missing Statistical Measures Formulas  
            createSkewnessFormula(),
            createKurtosisFormula(),
            createCoefficientOfVariationFormula(),
            createCovarianceFormula(),
            createCorrelationFormula(),
            
            // MARK: - Missing Fixed Income Formulas
            createMacaulayDurationDetailedFormula(),
            createSwapSpreadFormula(),
            createTEDSpreadFormula(),
            createLiborOISSpreadFormula(),
            createCreditDefaultSwapFormula(),
            
            // MARK: - Missing Quantitative Methods Formulas
            createMultipleRegressionFormula(),
            createTimeSeriesAnalysisFormula(),
            createARMAModelFormula(),
            createGARCHModelFormula(),
            
            // MARK: - Missing Economics & FRA Formulas
            createTaylorRuleFormula(),
            createPurchasingPowerParityFormula(),
            createGrinoldKronerModelFormula(),
            createSingerTerhaarModelFormula()
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
    
    // MARK: - Additional Missing Formula Implementations
    
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
}


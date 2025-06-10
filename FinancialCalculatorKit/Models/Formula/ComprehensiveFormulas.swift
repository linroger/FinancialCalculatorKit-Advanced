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
            createNetPresentValueFormula(),
            createPresentValueFormula(),
            createFutureValueFormula(),
            createAnnuityPresentValueFormula(),
            createAnnuityFutureValueFormula(),
            createPerpetuityFormula(),
            createGrowingPerpetuityFormula(),
            createEffectiveAnnualRateFormula(),
            createContinuousCompoundingFormula(),
            createLoanAmortizationFormula(),
            
            // MARK: - Advanced Fixed Income Formulas
            createEffectiveDurationFormula(),
            createBondConvexityDetailedFormula(),
            createYieldSpreadFormula(),
            createCreditSpreadFormula(),
            
            // MARK: - Advanced Equity Formulas
            createWACCFormula(),
            
            // MARK: - Financial Ratios - Profitability
            createROEFormula(),
            createROAFormula(),
            createROICFormula(),
            createNetProfitMarginFormula(),
            createGrossProfitMarginFormula(),
            createOperatingProfitMarginFormula(),
            createEBITDAMarginFormula(),
            
            // MARK: - Financial Ratios - Efficiency
            createAssetTurnoverFormula(),
            createInventoryTurnoverFormula(),
            createReceivablesTurnoverFormula(),
            createPayablesTurnoverFormula(),
            createWorkingCapitalTurnoverFormula(),
            createFixedAssetTurnoverFormula(),
            
            // MARK: - Financial Ratios - Leverage
            createDebtToEquityFormula(),
            createDebtToAssetsFormula(),
            createTimesInterestEarnedFormula(),
            createEBITDACoverageFormula(),
            createFinancialLeverageRatioFormula(),
            createCapitalizationRatioFormula(),
            
            // MARK: - Financial Ratios - Liquidity
            createCurrentRatioFormula(),
            createQuickRatioFormula(),
            createCashRatioFormula(),
            createOperatingCashFlowRatioFormula(),
            
            // MARK: - DuPont Analysis Framework
            createDuPontROEFormula(),
            createDuPontROEExtendedFormula(),
            createDuPontROAFormula(),
            createEquityMultiplierFormula(),
            
            // MARK: - Equity Risk Models
            //createBetaCalculationFormula(),
            createUnleveredBetaFormula(),
            createLeveredBetaFormula(),
            createAdjustedBetaFormula(),
            createCAPMExtendedFormula(),
            createFamaFrenchFormula(),
            
            // MARK: - Growth Analysis
            createSustainableGrowthRateFormula(),
            createInternalGrowthRateFormula(),
            createPLOWBACKRatioFormula(),
            createRetentionRatioFormula(),
            
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
            createGrinoldKronerModelFormula(),
            
            // MARK: - Advanced Quantitative Methods
            // Time Series Analysis
            createAdvancedARModel(),
            createARMAModelDetailed(),
            createARIMAModelDetailed(),
            createCointegrationTestFormula(),
            createAugmentedDickeyFullerTestFormula(),
            createPhillipsPerronTestFormula(),
            createJohansenCointegrationTestFormula(),
            createGrangerCausalityTestFormula(),
            createVARModelFormula(),
            createVECMModelFormula(),
            
            // Linear Regression Diagnostics
            createMultipleRegressionDetailedFormula(),
            createRSquaredAdjustedFormula(),
            createFTestRegressionFormula(),
            createTTestRegressionFormula(),
            createBreuschPaganTestFormula(),
            createDurbinWatsonTestFormula(),
            createVarianceInflationFactorFormula(),
            createCookDistanceFormula(),
            createLeverageStatisticFormula(),
            createStudentizedResidualsFormula(),
            createWhiteTestFormula(),
            createJarqueBeraTestFormula(),
            createRamseyRESETTestFormula(),
            
            // Advanced Simulation Methods
            createMonteCarloDetailedFormula(),
            createVarianceReductionTechniquesFormula(),
            createImportanceSamplingFormula(),
            createControlVariatesFormula(),
            createAntitheticVariatesFormula(),
            createStratifiedSamplingFormula(),
            createBootstrapDetailedFormula(),
            createJackknifeEstimatorFormula(),
            createScenarioAnalysisFormula(),
            createStressTesting(),
            
            // Machine Learning & Big Data
            createCrossValidationFormula(),
            createKFoldCrossValidationFormula(),
            createBiasVarianceTradeoffFormula(),
            createRegularizationFormula(),
            createRidgeRegressionFormula(),
            createLassoRegressionFormula(),
            createElasticNetFormula(),
            createRandomForestFormula(),
            createSupportVectorMachineFormula(),
            createNeuralNetworkFormula(),
            createBackpropagationFormula(),
            createPrincipalComponentAnalysisFormula(),
            createKMeansClusteringFormula(),
            createNaiveBayesFormula(),
            createLogisticRegressionDetailedFormula(),
            createDecisionTreeFormula(),
            createEnsembleMethodsFormula(),
            createBaggingFormula(),
            createBoostingFormula(),
            createOverfittingPreventionFormula()
        ])
    }

    // MARK: - Net Present Value (NPV)
    func createNetPresentValueFormula() -> FormulaReference {
        return FormulaReference(
            name: "Net Present Value (NPV)",
            category: .quantitative,
            level: .levelI,
            mainFormula: "NPV = \\sum_{t=1}^{n} \\frac{CF_t}{(1+r)^t} - C_0",
            description: "Calculates the present value of a series of future cash flows, discounted at a specified rate, minus the initial investment.",
            variables: [
                FormulaVariable(symbol: "NPV", name: "Net Present Value", description: "The value of a project in today's dollars.", units: "Currency", typicalRange: "Any", notes: "Positive NPV indicates a profitable investment."),
                FormulaVariable(symbol: "CF_t", name: "Cash Flow at time t", description: "The cash flow for a specific period.", units: "Currency", typicalRange: "Any", notes: "Can be positive or negative."),
                FormulaVariable(symbol: "r", name: "Discount Rate", description: "The rate of return required for the investment.", units: "Percentage", typicalRange: "0-20%", notes: "Often the WACC."),
                FormulaVariable(symbol: "t", name: "Time Period", description: "The period in which the cash flow occurs.", units: "Years", typicalRange: "1-n", notes: nil),
                FormulaVariable(symbol: "C_0", name: "Initial Investment", description: "The initial cost of the investment.", units: "Currency", typicalRange: "Any", notes: "A cash outflow at time 0.")
            ],
            derivation: FormulaDerivation(
                title: "Derivation of NPV",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with the present value of a single cash flow.", formula: "PV = \\frac{CF_t}{(1+r)^t}", explanation: "The value today of a future cash flow."),
                    DerivationStep(stepNumber: 2, description: "Sum the present values of all future cash flows.", formula: "PV_{total} = \\sum_{t=1}^{n} \\frac{CF_t}{(1+r)^t}", explanation: "The total present value of all expected future cash flows."),
                    DerivationStep(stepNumber: 3, description: "Subtract the initial investment.", formula: "NPV = PV_{total} - C_0", explanation: "The net value of the investment.")
                ],
                assumptions: ["The discount rate is constant over the life of the project.", "Cash flows occur at the end of each period."],
                notes: "NPV is a core concept in corporate finance and is used to make investment decisions."
            ),
            variants: [
                FormulaVariant(name: "NPV with Terminal Value", formula: "NPV = \\sum_{t=1}^{n} \\frac{CF_t}{(1+r)^t} + \\frac{TV}{(1+r)^n} - C_0", description: "Includes a terminal value for projects with an indefinite life.", whenToUse: "For projects with a long or indefinite life.")
            ],
            usageNotes: ["A positive NPV indicates that the projected earnings generated by a project or investment (in present dollars) exceeds the anticipated costs (also in present dollars).", "Generally, an investment with a positive NPV will be a profitable one and one with a negative NPV will result in a net loss."],
            examples: [
                FormulaExample(
                    title: "NPV of a Project",
                    description: "A project costs $100,000 and is expected to generate cash flows of $30,000, $40,000, and $50,000 over the next three years. The discount rate is 10%.",
                    inputs: ["C_0": "$100,000", "CF_1": "$30,000", "CF_2": "$40,000", "CF_3": "$50,000", "r": "10%"],
                    calculation: "NPV = (30000/1.1) + (40000/1.1^2) + (50000/1.1^3) - 100000",
                    result: "NPV = $27,272.73 + $33,057.85 + $37,565.74 - $100,000 = -$2,103.68",
                    interpretation: "The project has a negative NPV, so it is not a good investment."
                )
            ],
            relatedFormulas: ["irr", "payback-period"],
            tags: ["npv", "dcf", "valuation", "capital-budgeting"]
        )
    }

    // MARK: - Loan Amortization
    func createLoanAmortizationFormula() -> FormulaReference {
        return FormulaReference(
            name: "Loan Amortization",
            category: .quantitative,
            level: .levelI,
            mainFormula: "P = L \\frac{c(1+c)^n}{(1+c)^n - 1}",
            description: "Calculates the periodic payment amount for a loan, based on the loan amount, interest rate, and number of payments.",
            variables: [
                FormulaVariable(symbol: "P", name: "Periodic Payment", description: "The fixed payment amount for each period.", units: "Currency", typicalRange: "Any", notes: nil),
                FormulaVariable(symbol: "L", name: "Loan Amount", description: "The principal amount of the loan.", units: "Currency", typicalRange: "Any", notes: nil),
                FormulaVariable(symbol: "c", name: "Interest Rate per Period", description: "The interest rate for each payment period.", units: "Percentage", typicalRange: "0-5%", notes: "Calculated as annual rate / number of payments per year."),
                FormulaVariable(symbol: "n", name: "Number of Payments", description: "The total number of payments over the life of the loan.", units: "Count", typicalRange: "1-360", notes: nil)
            ],
            derivation: FormulaDerivation(
                title: "Derivation of the Loan Amortization Formula",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with the formula for the present value of an ordinary annuity.", formula: "PV = P \\frac{1 - (1+c)^{-n}}{c}", explanation: "The loan amount is the present value of all future payments."),
                    DerivationStep(stepNumber: 2, description: "Substitute L for PV.", formula: "L = P \\frac{1 - (1+c)^{-n}}{c}", explanation: "The loan amount is the present value of the annuity of payments."),
                    DerivationStep(stepNumber: 3, description: "Solve for P.", formula: "P = L \\frac{c}{1 - (1+c)^{-n}}", explanation: "Isolate the periodic payment."),
                    DerivationStep(stepNumber: 4, description: "Multiply the numerator and denominator by (1+c)^n.", formula: "P = L \\frac{c(1+c)^n}{(1+c)^n - 1}", explanation: "Simplify the expression to its final form.")
                ],
                assumptions: ["The interest rate remains constant for the life of the loan.", "Payments are made at the end of each period."],
                notes: "This formula is fundamental to understanding loans, mortgages, and other forms of debt."
            ),
            variants: [],
            usageNotes: ["This formula can be used to create an amortization schedule, which shows the breakdown of each payment into principal and interest over the life of the loan."],
            examples: [
                FormulaExample(
                    title: "Mortgage Payment",
                    description: "Calculate the monthly payment for a $300,000 mortgage with a 30-year term and a 4% annual interest rate.",
                    inputs: ["L": "$300,000", "Annual Rate": "4%", "n": "360 (30 years * 12 months)"],
                    calculation: "c = 0.04 / 12 = 0.00333...\nP = 300000 * (0.00333 * (1.00333)^360) / ((1.00333)^360 - 1)",
                    result: "P = $1,432.25",
                    interpretation: "The monthly mortgage payment is $1,432.25."
                )
            ],
            relatedFormulas: ["present-value-annuity", "future-value-annuity"],
            tags: ["amortization", "loan", "mortgage", "debt"]
        )
    }


    
    // MARK: - Advanced Fixed Income Formulas
    
    func createEffectiveDurationFormula() -> FormulaReference {
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
    
    func createBondConvexityDetailedFormula() -> FormulaReference {
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
    
    func createWACCFormula() -> FormulaReference {
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
    
    func createBlackScholesCompleteFormula() -> FormulaReference {
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
    
    func createDeltaFormula() -> FormulaReference {
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
    
    func createGammaFormula() -> FormulaReference {
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
    
    func createThetaFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Theta",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Theta = \\frac{\\partial V}{\\partial t} = -\\frac{S_0 \\phi(d_1) \\sigma}{2\\sqrt{T}} - rX e^{-rT} N(d_2)",
            description: "Time decay measuring option value loss per day passing. Critical for understanding time value erosion.",
            variables: [
                FormulaVariable(symbol: "\\Theta", name: "Theta", description: "Time decay rate of option value", units: "Currency/Day", typicalRange: "-$0.50 to $0", notes: "Negative for long options, positive for short options"),
                FormulaVariable(symbol: "V", name: "Option Value", description: "Current option price", units: "Currency", typicalRange: "$0 to stock price", notes: "Call or put option value"),
                FormulaVariable(symbol: "t", name: "Time", description: "Time variable", units: "Years", typicalRange: "0 to 5", notes: "Time to expiration"),
                FormulaVariable(symbol: "S_0", name: "Stock Price", description: "Current underlying asset price", units: "Currency", typicalRange: "$1 to $1000+", notes: "Market price of underlying"),
                FormulaVariable(symbol: "\\phi(d_1)", name: "Normal PDF", description: "Standard normal probability density function at d₁", units: "Unitless", typicalRange: "0 to 0.4", notes: "Bell curve height at d₁"),
                FormulaVariable(symbol: "\\sigma", name: "Volatility", description: "Annualized volatility", units: "Percentage", typicalRange: "10% to 100%", notes: "Standard deviation of returns"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time remaining until expiration", units: "Years", typicalRange: "0 to 5", notes: "Expressed as fraction of year"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Risk-free interest rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Treasury rate with matching maturity"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Exercise price of option", units: "Currency", typicalRange: "$1 to $1000+", notes: "Fixed at option creation"),
                FormulaVariable(symbol: "N(d_2)", name: "Cumulative Normal at d₂", description: "Standard normal CDF evaluated at d₂", units: "Probability", typicalRange: "0 to 1", notes: "Risk-neutral probability of exercise")
            ],
            derivation: FormulaDerivation(
                title: "Theta Derivation from Black-Scholes PDE",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with Black-Scholes call formula", formula: "C = S_0 N(d_1) - X e^{-rT} N(d_2)", explanation: "Standard European call option price"),
                    DerivationStep(stepNumber: 2, description: "Take partial derivative with respect to time", formula: "\\frac{\\partial C}{\\partial t} = \\frac{\\partial}{\\partial t}[S_0 N(d_1) - X e^{-rT} N(d_2)]", explanation: "Apply partial differentiation to time variable"),
                    DerivationStep(stepNumber: 3, description: "Apply chain rule to first term", formula: "\\frac{\\partial}{\\partial t}[S_0 N(d_1)] = S_0 \\phi(d_1) \\frac{\\partial d_1}{\\partial t}", explanation: "Use normal PDF for derivative of CDF"),
                    DerivationStep(stepNumber: 4, description: "Calculate ∂d₁/∂t", formula: "\\frac{\\partial d_1}{\\partial t} = -\\frac{\\sigma}{2\\sqrt{T}}", explanation: "Derivative of d₁ with respect to time"),
                    DerivationStep(stepNumber: 5, description: "Apply derivative to second term", formula: "\\frac{\\partial}{\\partial t}[X e^{-rT} N(d_2)] = rX e^{-rT} N(d_2) + X e^{-rT} \\phi(d_2) \\frac{\\partial d_2}{\\partial t}", explanation: "Product rule and chain rule"),
                    DerivationStep(stepNumber: 6, description: "Use put-call parity relationship", formula: "S_0 \\phi(d_1) = X e^{-rT} \\phi(d_2)", explanation: "Mathematical identity from Black-Scholes derivation"),
                    DerivationStep(stepNumber: 7, description: "Final theta formula", formula: "\\Theta = -\\frac{S_0 \\phi(d_1) \\sigma}{2\\sqrt{T}} - rX e^{-rT} N(d_2)", explanation: "Complete time decay expression")
                ],
                assumptions: [
                    "Black-Scholes assumptions hold",
                    "European exercise only",
                    "Constant volatility and interest rate",
                    "No dividends"
                ],
                notes: "Theta is always negative for long options, representing time value decay."
            ),
            variants: [
                FormulaVariant(name: "Put Theta", formula: "\\Theta_{put} = -\\frac{S_0 \\phi(d_1) \\sigma}{2\\sqrt{T}} + rX e^{-rT} N(-d_2)", description: "Theta for put options", whenToUse: "For put option time decay analysis"),
                FormulaVariant(name: "Theta per Calendar Day", formula: "\\Theta_{daily} = \\Theta / 365", description: "Daily time decay", whenToUse: "For daily P&L attribution"),
                FormulaVariant(name: "Theta with Dividends", formula: "\\Theta = -\\frac{S_0 e^{-qT} \\phi(d_1) \\sigma}{2\\sqrt{T}} - rX e^{-rT} N(d_2) + qS_0 e^{-qT} N(d_1)", description: "Theta adjusted for dividend yield", whenToUse: "For dividend-paying stocks")
            ],
            usageNotes: [
                "Always negative for long options, accelerates near expiration",
                "Theta is highest (most negative) for at-the-money options near expiration",
                "Time decay accelerates exponentially as expiration approaches",
                "Options with longer time to expiration have lower absolute theta",
                "Critical for theta decay strategies and calendar spreads"
            ],
            examples: [
                FormulaExample(
                    title: "At-the-Money Call Theta",
                    description: "Calculate theta for ATM call: S=$100, X=$100, r=5%, T=0.25, σ=20%",
                    inputs: ["S₀": "$100", "X": "$100", "r": "5%", "T": "0.25 years", "σ": "20%"],
                    calculation: "d₁ = 0.175, φ(0.175) = 0.3935, N(d₂) = 0.4325\nΘ = -100 × 0.3935 × 0.20 / (2 × √0.25) - 0.05 × 100 × e^(-0.05×0.25) × 0.4325\nΘ = -7.87 - 2.14 = -10.01 per year",
                    result: "Θ = -$10.01 per year (-$0.027 per day)",
                    interpretation: "Option loses $0.027 per day due to time decay"
                )
            ],
            relatedFormulas: ["delta", "gamma", "time-value", "black-scholes"],
            tags: ["theta", "time-decay", "greeks", "options"]
        )
    }
    
    func createVegaFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Vega",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\nu = \\frac{\\partial V}{\\partial \\sigma} = S_0 \\sqrt{T} \\phi(d_1)",
            description: "Volatility sensitivity showing option price change per 1% volatility change. Essential for volatility trading strategies.",
            variables: [
                FormulaVariable(symbol: "\\nu", name: "Vega", description: "Volatility sensitivity of option price", units: "Currency/%", typicalRange: "$0 to $40", notes: "Change in option price per 1% volatility change"),
                FormulaVariable(symbol: "V", name: "Option Value", description: "Current option price", units: "Currency", typicalRange: "$0 to stock price", notes: "Call or put option value"),
                FormulaVariable(symbol: "\\sigma", name: "Volatility", description: "Implied volatility of underlying asset", units: "Percentage", typicalRange: "10% to 100%", notes: "Standard deviation of returns"),
                FormulaVariable(symbol: "S_0", name: "Stock Price", description: "Current underlying asset price", units: "Currency", typicalRange: "$1 to $1000+", notes: "Market price of underlying"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time remaining until expiration", units: "Years", typicalRange: "0 to 5", notes: "Expressed as fraction of year"),
                FormulaVariable(symbol: "\\phi(d_1)", name: "Normal PDF at d₁", description: "Standard normal probability density function evaluated at d₁", units: "Unitless", typicalRange: "0 to 0.4", notes: "Bell curve height at d₁ from Black-Scholes")
            ],
            derivation: FormulaDerivation(
                title: "Vega Derivation from Black-Scholes",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with Black-Scholes call formula", formula: "C = S_0 N(d_1) - X e^{-rT} N(d_2)", explanation: "Standard European call option price"),
                    DerivationStep(stepNumber: 2, description: "Express d₁ and d₂ in terms of volatility", formula: "d_1 = \\frac{\\ln(S_0/X) + (r + \\sigma^2/2)T}{\\sigma\\sqrt{T}}, \\quad d_2 = d_1 - \\sigma\\sqrt{T}", explanation: "Both parameters depend on volatility"),
                    DerivationStep(stepNumber: 3, description: "Take partial derivative with respect to volatility", formula: "\\frac{\\partial C}{\\partial \\sigma} = S_0 \\frac{\\partial N(d_1)}{\\partial \\sigma} - X e^{-rT} \\frac{\\partial N(d_2)}{\\partial \\sigma}", explanation: "Apply chain rule to both terms"),
                    DerivationStep(stepNumber: 4, description: "Apply chain rule to normal CDFs", formula: "\\frac{\\partial N(d_1)}{\\partial \\sigma} = \\phi(d_1) \\frac{\\partial d_1}{\\partial \\sigma}", explanation: "Use normal PDF for derivative of CDF"),
                    DerivationStep(stepNumber: 5, description: "Calculate ∂d₁/∂σ", formula: "\\frac{\\partial d_1}{\\partial \\sigma} = \\frac{\\sqrt{T}}{2} - \\frac{\\ln(S_0/X) + (r + \\sigma^2/2)T}{\\sigma^2\\sqrt{T}}", explanation: "Partial derivative of d₁ with respect to volatility"),
                    DerivationStep(stepNumber: 6, description: "Use Black-Scholes identity", formula: "S_0 \\phi(d_1) = X e^{-rT} \\phi(d_2)", explanation: "Mathematical relationship from option pricing theory"),
                    DerivationStep(stepNumber: 7, description: "Simplify to final vega formula", formula: "\\nu = S_0 \\sqrt{T} \\phi(d_1)", explanation: "Complete volatility sensitivity expression")
                ],
                assumptions: [
                    "Black-Scholes framework applies",
                    "Constant volatility assumption (paradox for vega)",
                    "European exercise only",
                    "No transaction costs",
                    "Continuous trading"
                ],
                notes: "Vega is same for calls and puts with identical strikes and expirations."
            ),
            variants: [
                FormulaVariant(name: "Vega with Dividends", formula: "\\nu = S_0 e^{-qT} \\sqrt{T} \\phi(d_1)", description: "Vega adjusted for dividend yield", whenToUse: "For dividend-paying stocks"),
                FormulaVariant(name: "Dollar Vega", formula: "\\text{Dollar Vega} = \\nu \\times \\text{Number of Contracts} \\times 100", description: "Portfolio vega in dollar terms", whenToUse: "For portfolio risk management"),
                FormulaVariant(name: "Vega Percentage", formula: "\\text{Vega \\%} = \\frac{\\nu}{V} \\times 100", description: "Vega as percentage of option price", whenToUse: "For relative volatility sensitivity comparison"),
                FormulaVariant(name: "Volga (Vega Convexity)", formula: "\\text{Volga} = \\frac{\\partial^2 V}{\\partial \\sigma^2}", description: "Second-order volatility sensitivity", whenToUse: "For advanced volatility risk management")
            ],
            usageNotes: [
                "Highest for at-the-money options with longer time to expiration",
                "Vega decreases as options move in or out of the money",
                "Time decay reduces vega as expiration approaches",
                "Critical for volatility trading strategies (long/short volatility)",
                "Same for calls and puts with identical parameters",
                "Vega decreases as volatility increases (volga effect)"
            ],
            examples: [
                FormulaExample(
                    title: "At-the-Money Call Vega",
                    description: "Calculate vega for ATM call: S=$100, X=$100, r=5%, T=0.25, σ=20%",
                    inputs: ["S₀": "$100", "X": "$100", "r": "5%", "T": "0.25 years", "σ": "20%"],
                    calculation: "d₁ = [ln(100/100) + (0.05 + 0.04/2) × 0.25] / (0.20 × √0.25) = 0.175\nφ(0.175) = 0.3935\nν = 100 × √0.25 × 0.3935 = 100 × 0.5 × 0.3935",
                    result: "ν = $19.68",
                    interpretation: "Option price increases by $19.68 for each 1% increase in volatility"
                ),
                FormulaExample(
                    title: "Long-Term vs Short-Term Vega",
                    description: "Compare vega for 3-month vs 1-month ATM options",
                    inputs: ["3-month T": "0.25", "1-month T": "0.083", "Other params": "Same"],
                    calculation: "Vega₃ₘ = S₀ × √0.25 × φ(d₁) vs Vega₁ₘ = S₀ × √0.083 × φ(d₁)",
                    result: "Vega₃ₘ = 1.73 × Vega₁ₘ",
                    interpretation: "Longer-term options have significantly higher vega exposure"
                )
            ],
            relatedFormulas: ["implied-volatility", "black-scholes", "gamma", "volga"],
            tags: ["vega", "volatility", "greeks", "sensitivity", "risk-management"]
        )
    }
    
    func createRhoFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Rho",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\rho = \\frac{\\partial V}{\\partial r} = XT e^{-rT} N(d_2) \\text{ (for calls)}",
            description: "Interest rate sensitivity showing option price change per 1% rate change. Important for long-term options and rate-sensitive strategies.",
            variables: [
                FormulaVariable(symbol: "\\rho", name: "Rho", description: "Interest rate sensitivity of option price", units: "Currency/%", typicalRange: "$0 to $50", notes: "Change in option price per 1% interest rate change"),
                FormulaVariable(symbol: "V", name: "Option Value", description: "Current option price", units: "Currency", typicalRange: "$0 to stock price", notes: "Call or put option value"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded risk-free interest rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Treasury rate with matching maturity"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Exercise price of option", units: "Currency", typicalRange: "$1 to $1000+", notes: "Fixed at option creation"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time remaining until expiration", units: "Years", typicalRange: "0 to 5", notes: "Expressed as fraction of year"),
                FormulaVariable(symbol: "N(d_2)", name: "Cumulative Normal at d₂", description: "Standard normal CDF evaluated at d₂", units: "Probability", typicalRange: "0 to 1", notes: "Risk-neutral probability of exercise")
            ],
            derivation: FormulaDerivation(
                title: "Rho Derivation from Black-Scholes",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with Black-Scholes call formula", formula: "C = S_0 N(d_1) - X e^{-rT} N(d_2)", explanation: "Standard European call option price"),
                    DerivationStep(stepNumber: 2, description: "Express d₁ and d₂ in terms of interest rate", formula: "d_1 = \\frac{\\ln(S_0/X) + (r + \\sigma^2/2)T}{\\sigma\\sqrt{T}}, \\quad d_2 = d_1 - \\sigma\\sqrt{T}", explanation: "d₁ depends on r, d₂ depends on d₁"),
                    DerivationStep(stepNumber: 3, description: "Take partial derivative with respect to r", formula: "\\frac{\\partial C}{\\partial r} = S_0 \\frac{\\partial N(d_1)}{\\partial r} - \\frac{\\partial}{\\partial r}[X e^{-rT} N(d_2)]", explanation: "Apply differentiation to both terms"),
                    DerivationStep(stepNumber: 4, description: "Apply product rule to second term", formula: "\\frac{\\partial}{\\partial r}[X e^{-rT} N(d_2)] = -XT e^{-rT} N(d_2) + X e^{-rT} \\frac{\\partial N(d_2)}{\\partial r}", explanation: "Product rule for exponential and CDF"),
                    DerivationStep(stepNumber: 5, description: "Calculate derivatives of normal CDFs", formula: "\\frac{\\partial N(d_1)}{\\partial r} = \\phi(d_1) \\frac{T}{\\sigma\\sqrt{T}}, \\quad \\frac{\\partial N(d_2)}{\\partial r} = \\phi(d_2) \\frac{T}{\\sigma\\sqrt{T}}", explanation: "Chain rule with normal PDF"),
                    DerivationStep(stepNumber: 6, description: "Use Black-Scholes identity", formula: "S_0 \\phi(d_1) = X e^{-rT} \\phi(d_2)", explanation: "Relationship from option pricing theory"),
                    DerivationStep(stepNumber: 7, description: "Simplify to final rho formula", formula: "\\rho = XT e^{-rT} N(d_2)", explanation: "Terms cancel due to Black-Scholes identity")
                ],
                assumptions: [
                    "Black-Scholes framework applies",
                    "Constant interest rate (paradox for rho)",
                    "European exercise only",
                    "No dividends",
                    "Parallel shifts in yield curve"
                ],
                notes: "Rho is positive for calls and negative for puts, reflecting present value effects."
            ),
            variants: [
                FormulaVariant(name: "Put Rho", formula: "\\rho_{put} = -XT e^{-rT} N(-d_2)", description: "Rho for put options", whenToUse: "For put option interest rate sensitivity"),
                FormulaVariant(name: "Rho with Dividends", formula: "\\rho = XT e^{-rT} N(d_2) \\text{ (call)}, \\quad \\rho_{div} = -qS_0 T e^{-qT} N(d_1)", description: "Separate rho for dividend yield changes", whenToUse: "For dividend-paying stocks"),
                FormulaVariant(name: "Dollar Rho", formula: "\\text{Dollar Rho} = \\rho \\times \\text{Number of Contracts} \\times 100", description: "Portfolio rho in dollar terms", whenToUse: "For portfolio interest rate risk"),
                FormulaVariant(name: "Rho-Rho (Convexity)", formula: "\\text{Rho-Rho} = \\frac{\\partial^2 V}{\\partial r^2}", description: "Second-order interest rate sensitivity", whenToUse: "For large rate changes")
            ],
            usageNotes: [
                "Generally less important than other Greeks for equity options",
                "More significant for long-term options (LEAPS)",
                "Important for currency options and interest rate derivatives",
                "Positive for calls, negative for puts",
                "Increases with time to expiration and strike price",
                "Higher for in-the-money options"
            ],
            examples: [
                FormulaExample(
                    title: "Long-Term Call Option Rho",
                    description: "Calculate rho for 2-year call: S=$100, X=$110, r=3%, T=2, σ=25%",
                    inputs: ["S₀": "$100", "X": "$110", "r": "3%", "T": "2 years", "σ": "25%"],
                    calculation: "d₂ = [ln(100/110) + (0.03 - 0.0625/2) × 2] / (0.25 × √2) = -0.133\nN(-0.133) = 0.447\nρ = 110 × 2 × e^(-0.03×2) × 0.447",
                    result: "ρ = $92.16",
                    interpretation: "Option price increases by $92.16 for each 1% increase in interest rates"
                ),
                FormulaExample(
                    title: "Short-Term vs Long-Term Rho",
                    description: "Compare rho sensitivity for 1-month vs 2-year options",
                    inputs: ["Short T": "0.083", "Long T": "2.0", "Same strike/vol": "ATM"],
                    calculation: "Rho ∝ T, so 2-year option has ~24x the rho of 1-month option",
                    result: "Long-term options much more rate-sensitive",
                    interpretation: "Interest rate sensitivity increases dramatically with time to expiration"
                )
            ],
            relatedFormulas: ["black-scholes", "interest-rates", "duration", "convexity"],
            tags: ["rho", "interest-rate", "greeks", "sensitivity", "long-term-options"]
        )
    }
    
    // Continue with remaining formulas...
    // Each would follow the same comprehensive pattern
    
    func createSortinoRatioFormula() -> FormulaReference {
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
    
    func createCalmarRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Calmar Ratio",
            category: .portfolio,
            level: .levelII,
            mainFormula: "\\text{Calmar} = \\frac{\\text{Annual Return}}{\\text{Maximum Drawdown}}",
            description: "Risk-adjusted return using maximum drawdown as risk measure. Particularly valuable for evaluating downside risk management.",
            variables: [
                FormulaVariable(symbol: "\\text{Calmar}", name: "Calmar Ratio", description: "Risk-adjusted performance measure", units: "Unitless", typicalRange: "0 to 5+", notes: "Higher values indicate better risk-adjusted performance"),
                FormulaVariable(symbol: "\\text{Annual Return}", name: "Annualized Return", description: "Compound annual growth rate", units: "Percentage", typicalRange: "-50% to 50%", notes: "Geometric mean of returns over the period"),
                FormulaVariable(symbol: "\\text{Maximum Drawdown}", name: "Maximum Drawdown", description: "Largest peak-to-trough decline", units: "Percentage", typicalRange: "0% to 100%", notes: "Worst loss from any high-water mark")
            ],
            derivation: FormulaDerivation(
                title: "Calmar Ratio Development",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Identify need for downside risk measure", formula: "\\text{Traditional metrics focus on volatility}", explanation: "Standard deviation treats upside and downside volatility equally"),
                    DerivationStep(stepNumber: 2, description: "Define maximum drawdown", formula: "MDD = \\max_{t} \\left[ \\frac{\\text{Peak}_t - \\text{Trough}_{t,T}}{\\text{Peak}_t} \\right]", explanation: "Maximum percentage loss from any historical peak"),
                    DerivationStep(stepNumber: 3, description: "Calculate annualized return", formula: "r_{annual} = \\left( \\frac{\\text{Ending Value}}{\\text{Starting Value}} \\right)^{\\frac{1}{T}} - 1", explanation: "Compound annual growth rate over period T"),
                    DerivationStep(stepNumber: 4, description: "Form Calmar ratio", formula: "\\text{Calmar} = \\frac{r_{annual}}{MDD}", explanation: "Return per unit of maximum drawdown risk")
                ],
                assumptions: [
                    "Maximum drawdown accurately represents downside risk",
                    "Sufficient historical data for meaningful MDD calculation",
                    "Past drawdowns predict future risk",
                    "Return pattern is somewhat consistent"
                ],
                notes: "Named after Terry W. Young's California Managed Account Report newsletter."
            ),
            variants: [
                FormulaVariant(name: "Modified Calmar Ratio", formula: "\\text{Modified Calmar} = \\frac{\\text{Excess Return}}{\\text{Maximum Drawdown}}", description: "Uses excess return over risk-free rate", whenToUse: "For better risk-adjusted comparison"),
                FormulaVariant(name: "Sterling Ratio", formula: "\\text{Sterling} = \\frac{\\text{Annual Return}}{\\text{Average Drawdown}}", description: "Uses average of largest drawdowns", whenToUse: "For less conservative risk assessment"),
                FormulaVariant(name: "Burke Ratio", formula: "\\text{Burke} = \\frac{\\text{Excess Return}}{\\sqrt{\\sum \\text{Drawdowns}^2}}", description: "Uses square root of sum of squared drawdowns", whenToUse: "To consider all drawdowns, not just maximum")
            ],
            usageNotes: [
                "Popular measure for hedge fund performance evaluation",
                "Higher Calmar ratios indicate better downside risk management",
                "Particularly useful for strategies with non-normal return distributions",
                "More intuitive than Sharpe ratio for investors focused on capital preservation",
                "Should be used with other metrics for comprehensive evaluation",
                "Sensitive to the time period analyzed"
            ],
            examples: [
                FormulaExample(
                    title: "Hedge Fund Performance Analysis",
                    description: "Calculate Calmar ratio for hedge fund with 12% annual return and 8% max drawdown",
                    inputs: ["Annual Return": "12%", "Maximum Drawdown": "8%"],
                    calculation: "Calmar = 12% / 8% = 1.50",
                    result: "Calmar Ratio = 1.50",
                    interpretation: "Fund generates 1.50% annual return per 1% of maximum drawdown risk"
                ),
                FormulaExample(
                    title: "Comparison of Two Strategies",
                    description: "Strategy A: 15% return, 12% drawdown vs Strategy B: 10% return, 5% drawdown",
                    inputs: ["A: Return/DD": "15%/12%", "B: Return/DD": "10%/5%"],
                    calculation: "Calmar A = 15%/12% = 1.25\nCalmar B = 10%/5% = 2.00",
                    result: "Strategy B has superior Calmar ratio (2.00 vs 1.25)",
                    interpretation: "Strategy B provides better risk-adjusted returns despite lower absolute returns"
                )
            ],
            relatedFormulas: ["maximum-drawdown", "sharpe-ratio", "sortino-ratio", "sterling-ratio"],
            tags: ["calmar", "drawdown", "hedge-funds", "risk-adjusted", "downside-risk"]
        )
    }
    
    // Additional placeholder methods for remaining comprehensive formulas...
    // Each category would be fully implemented with detailed derivations
    
    func createYieldSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "Yield Spread Analysis",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Spread} = YTM_{corporate} - YTM_{treasury}",
            description: "Credit risk premium reflected in yield difference between corporate and government bonds. Essential for credit analysis and relative value assessment.",
            variables: [
                FormulaVariable(symbol: "\\text{Spread}", name: "Yield Spread", description: "Credit risk premium", units: "Basis Points", typicalRange: "50 to 1000+ bps", notes: "Compensation for credit risk, liquidity risk, and other factors"),
                FormulaVariable(symbol: "YTM_{corporate}", name: "Corporate Bond YTM", description: "Yield to maturity of corporate bond", units: "Percentage", typicalRange: "2% to 15%", notes: "Includes credit risk premium"),
                FormulaVariable(symbol: "YTM_{treasury}", name: "Treasury Bond YTM", description: "Yield to maturity of government bond", units: "Percentage", typicalRange: "0% to 8%", notes: "Risk-free rate benchmark")
            ],
            derivation: FormulaDerivation(
                title: "Yield Spread Decomposition",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with bond pricing relationship", formula: "P_{corporate} = \\sum \\frac{CF_t}{(1 + r_{treasury} + s)^t}", explanation: "Corporate bond price includes spread s over treasury rate"),
                    DerivationStep(stepNumber: 2, description: "Compare to treasury pricing", formula: "P_{treasury} = \\sum \\frac{CF_t}{(1 + r_{treasury})^t}", explanation: "Treasury bond priced at risk-free rate"),
                    DerivationStep(stepNumber: 3, description: "Define spread as difference", formula: "\\text{Credit Spread} = r_{corporate} - r_{treasury}", explanation: "Spread captures additional risk premium"),
                    DerivationStep(stepNumber: 4, description: "Decompose spread components", formula: "\\text{Total Spread} = \\text{Credit Risk} + \\text{Liquidity} + \\text{Option} + \\text{Tax}", explanation: "Multiple risk factors contribute to spread")
                ],
                assumptions: [
                    "Bonds have similar maturity and structure",
                    "Treasury bonds are truly risk-free",
                    "Markets are efficient in pricing credit risk",
                    "No embedded options (or adjusted for)"
                ],
                notes: "Spreads widen during credit stress and tighten during benign credit environments."
            ),
            variants: [
                FormulaVariant(name: "Option-Adjusted Spread (OAS)", formula: "OAS = \\text{Spread} - \\text{Option Cost}", description: "Spread after removing embedded option value", whenToUse: "For bonds with embedded options (callable, putable)"),
                FormulaVariant(name: "Z-Spread", formula: "\\text{Z-Spread is added to each spot rate}", description: "Static spread over entire yield curve", whenToUse: "For more accurate spread measurement"),
                FormulaVariant(name: "Interpolated Spread (I-Spread)", formula: "I\\text{-Spread} = \\text{YTM} - \\text{Interpolated Treasury}", description: "Spread over interpolated treasury curve", whenToUse: "When exact maturity treasury doesn't exist"),
                FormulaVariant(name: "Asset Swap Spread", formula: "\\text{ASW Spread} = \\text{Bond Yield} - \\text{LIBOR}", description: "Spread over floating rate benchmark", whenToUse: "For floating rate comparisons")
            ],
            usageNotes: [
                "Wider spreads indicate higher perceived credit risk",
                "Spreads are cyclical - tighten in good times, widen in stress",
                "Different spread measures can give different results",
                "Industry and rating comparisons are essential for context",
                "Liquidity premium can be significant portion of spread",
                "Consider duration matching when comparing spreads"
            ],
            examples: [
                FormulaExample(
                    title: "Investment Grade Corporate Bond",
                    description: "5-year A-rated corporate bond: YTM 4.5%, comparable treasury: YTM 2.8%",
                    inputs: ["Corporate YTM": "4.5%", "Treasury YTM": "2.8%"],
                    calculation: "Spread = 4.5% - 2.8% = 1.7% = 170 basis points",
                    result: "Credit Spread = 170 bps",
                    interpretation: "Investors demand 170 bps premium for credit risk over risk-free rate"
                ),
                FormulaExample(
                    title: "High Yield Bond Spread",
                    description: "BB-rated bond: YTM 8.2%, 10-year treasury: YTM 3.0%",
                    inputs: ["HY YTM": "8.2%", "Treasury YTM": "3.0%"],
                    calculation: "Spread = 8.2% - 3.0% = 5.2% = 520 basis points",
                    result: "Credit Spread = 520 bps",
                    interpretation: "Significant credit risk premium reflects higher default probability"
                )
            ],
            relatedFormulas: ["ytm", "credit-risk", "oas", "z-spread"],
            tags: ["spread", "credit", "corporate-bonds", "risk-premium"]
        )
    }
    
    func createCreditSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "Credit Spread Models",
            category: .fixedIncome,
            level: .levelIII,
            mainFormula: "\\text{Credit Spread} = -\\frac{1}{T} \\ln(1 - PD \\times LGD)",
            description: "Theoretical credit spread based on probability of default and loss given default. Foundation for structural and reduced-form credit models.",
            variables: [
                FormulaVariable(symbol: "\\text{Credit Spread}", name: "Credit Spread", description: "Yield premium for credit risk", units: "Basis Points", typicalRange: "10 to 2000+ bps", notes: "Compensation for expected credit losses"),
                FormulaVariable(symbol: "T", name: "Time to Maturity", description: "Bond maturity period", units: "Years", typicalRange: "0.25 to 30", notes: "Time horizon for default probability"),
                FormulaVariable(symbol: "PD", name: "Probability of Default", description: "Likelihood of default over period T", units: "Percentage", typicalRange: "0% to 100%", notes: "Cumulative default probability"),
                FormulaVariable(symbol: "LGD", name: "Loss Given Default", description: "Percentage loss if default occurs", units: "Percentage", typicalRange: "20% to 90%", notes: "1 - Recovery Rate")
            ],
            derivation: FormulaDerivation(
                title: "Credit Spread from Expected Loss",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define bond value with default risk", formula: "P = E[\\text{Future Cash Flows}] / (1 + r + s)^T", explanation: "Bond price includes credit spread s"),
                    DerivationStep(stepNumber: 2, description: "Express expected cash flows", formula: "E[CF] = CF \\times [1 - PD + PD \\times (1 - LGD)]", explanation: "Weighted by default and recovery scenarios"),
                    DerivationStep(stepNumber: 3, description: "Simplify expected cash flows", formula: "E[CF] = CF \\times (1 - PD \\times LGD)", explanation: "Expected recovery reduces expected loss"),
                    DerivationStep(stepNumber: 4, description: "Set bond price equal to risk-free bond", formula: "\\frac{CF \\times (1 - PD \\times LGD)}{(1 + r + s)^T} = \\frac{CF}{(1 + r)^T}", explanation: "Credit spread compensates for expected loss"),
                    DerivationStep(stepNumber: 5, description: "Solve for credit spread", formula: "(1 + r + s)^T = \\frac{1 + r}{1 - PD \\times LGD}", explanation: "Rearrange to isolate spread"),
                    DerivationStep(stepNumber: 6, description: "Approximate for small spreads", formula: "s \\approx -\\frac{1}{T} \\ln(1 - PD \\times LGD)", explanation: "Taylor expansion for tractable formula")
                ],
                assumptions: [
                    "Default occurs at maturity (simplification)",
                    "Constant default probability and recovery rate",
                    "No correlation between default and interest rates",
                    "Perfect markets with no liquidity premium"
                ],
                notes: "This simplified model forms basis for more sophisticated structural and reduced-form models."
            ),
            variants: [
                FormulaVariant(name: "Merton Model", formula: "PD = N\\left(-\\frac{\\ln(V/F) + (\\mu - \\sigma^2/2)T}{\\sigma\\sqrt{T}}\\right)", description: "Structural model linking firm value to default", whenToUse: "When firm value and volatility are observable"),
                FormulaVariant(name: "Reduced-Form Model", formula: "PD(t) = 1 - e^{-\\lambda t}", description: "Hazard rate model with intensity λ", whenToUse: "For market-implied default probabilities"),
                FormulaVariant(name: "Credit Triangle", formula: "\\text{Expected Loss} = PD \\times LGD \\times EAD", description: "Includes exposure at default", whenToUse: "For loan portfolio analysis"),
                FormulaVariant(name: "Credit Spread with Recovery", formula: "s = \\frac{PD \\times LGD}{1 - PD \\times LGD}", description: "Simplified annual spread approximation", whenToUse: "For quick credit spread estimates")
            ],
            usageNotes: [
                "Links credit metrics to bond pricing",
                "Actual spreads often exceed theoretical due to liquidity and other premiums",
                "Recovery rates vary significantly by industry and capital structure",
                "Default probabilities are typically estimated from credit ratings or CDS prices",
                "Model assumes default only at maturity - reality is more complex",
                "Useful for relative value analysis and credit derivative pricing"
            ],
            examples: [
                FormulaExample(
                    title: "Investment Grade Corporate Bond",
                    description: "5-year bond with 2% default probability and 40% loss given default",
                    inputs: ["T": "5 years", "PD": "2%", "LGD": "40%"],
                    calculation: "Credit Spread = -ln(1 - 0.02 × 0.40) / 5 = -ln(0.992) / 5 = 0.008 / 5",
                    result: "Credit Spread = 0.16% or 16 basis points",
                    interpretation: "Theoretical spread compensates for 0.8% expected loss over 5 years"
                ),
                FormulaExample(
                    title: "High Yield Bond Analysis",
                    description: "3-year bond with 15% default probability and 60% loss given default",
                    inputs: ["T": "3 years", "PD": "15%", "LGD": "60%"],
                    calculation: "Credit Spread = -ln(1 - 0.15 × 0.60) / 3 = -ln(0.91) / 3 = 0.094 / 3",
                    result: "Credit Spread = 3.14% or 314 basis points",
                    interpretation: "Higher default risk requires substantial credit spread compensation"
                )
            ],
            relatedFormulas: ["probability-of-default", "loss-given-default", "merton-model", "cds-pricing"],
            tags: ["credit-spread", "default-risk", "structural-models", "reduced-form"]
        )
    }
    
    // Continue with remaining comprehensive formulas...
    // This represents the structure for the complete implementation
    
    func createBootstrappingFormula() -> FormulaReference {
        FormulaReference(name: "Bootstrap Method", category: .fixedIncome, level: .levelII, mainFormula: "S_n = \\sqrt[n]{\\frac{P_{n-1}}{P_n}} - 1", description: "Method to derive spot rates from bond prices.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bootstrap", "spot-rates"])
    }
    
    func createForwardRateAgreementFormula() -> FormulaReference {
        FormulaReference(name: "Forward Rate Agreement", category: .derivatives, level: .levelII, mainFormula: "\\text{FRA Settlement} = \\frac{(r - r_{FRA}) \\times \\text{Notional} \\times \\text{Days}}{360 + r \\times \\text{Days}}", description: "Settlement amount for forward rate agreement.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fra", "forward-rates"])
    }
    
    func createInterestRateSwapFormula() -> FormulaReference {
        FormulaReference(name: "Interest Rate Swap Valuation", category: .derivatives, level: .levelII, mainFormula: "\\text{Swap Value} = \\text{Fixed Bond} - \\text{Floating Bond}", description: "Valuation of plain vanilla interest rate swap.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["swap", "interest-rates"])
    }
    
    // Continue with placeholder implementations for all remaining formulas...
    // Each would eventually be fully implemented with complete derivations
    
    func createMultiStageDDMFormula() -> FormulaReference {
        FormulaReference(name: "Multi-Stage DDM", category: .equity, level: .levelII, mainFormula: "P_0 = \\sum_{t=1}^{n_1} \\frac{D_0(1+g_1)^t}{(1+r)^t} + \\sum_{t=n_1+1}^{n_2} \\frac{D_{n_1}(1+g_2)^{t-n_1}}{(1+r)^t} + \\frac{P_{n_2}}{(1+r)^{n_2}}", description: "DDM with multiple growth phases.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ddm", "multi-stage"])
    }
    
    func createEVAFormula() -> FormulaReference {
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
    
    func createLeverageBetaFormula() -> FormulaReference {
        FormulaReference(
            name: "Levered Beta",
            category: .equity,
            level: .levelII,
            mainFormula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D}{E}]",
            description: "Beta adjustment for financial leverage. Reflects how financial leverage amplifies systematic risk.",
            variables: [
                FormulaVariable(symbol: "\\beta_L", name: "Levered Beta", description: "Beta with financial leverage effect", units: "Unitless", typicalRange: "0 to 3+", notes: "Systematic risk including leverage impact"),
                FormulaVariable(symbol: "\\beta_U", name: "Unlevered Beta", description: "Beta without leverage (asset beta)", units: "Unitless", typicalRange: "0 to 2", notes: "Systematic risk of underlying business"),
                FormulaVariable(symbol: "T", name: "Tax Rate", description: "Marginal corporate tax rate", units: "Percentage", typicalRange: "15% to 35%", notes: "Provides debt tax shield"),
                FormulaVariable(symbol: "D", name: "Market Value of Debt", description: "Total market value of debt", units: "Currency", typicalRange: "Millions to billions", notes: "Should use market values"),
                FormulaVariable(symbol: "E", name: "Market Value of Equity", description: "Total market capitalization", units: "Currency", typicalRange: "Millions to billions", notes: "Shares outstanding × Stock price")
            ],
            derivation: FormulaDerivation(
                title: "Levered Beta from Hamada Equation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with unlevered beta relationship", formula: "\\beta_U = \\beta_L \\left[ \\frac{E}{E + D(1-T)} \\right]", explanation: "Asset beta removes leverage effect"),
                    DerivationStep(stepNumber: 2, description: "Rearrange for levered beta", formula: "\\beta_L = \\beta_U \\left[ \\frac{E + D(1-T)}{E} \\right]", explanation: "Solve for levered beta"),
                    DerivationStep(stepNumber: 3, description: "Simplify the expression", formula: "\\beta_L = \\beta_U \\left[ 1 + \\frac{D(1-T)}{E} \\right]", explanation: "Factor out the equity term"),
                    DerivationStep(stepNumber: 4, description: "Final Hamada equation", formula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D}{E}]", explanation: "Standard form of levered beta formula")
                ],
                assumptions: [
                    "Debt beta is zero (risk-free debt)",
                    "Tax shields are perpetual",
                    "No financial distress costs",
                    "Markets are efficient"
                ],
                notes: "This formula captures how financial leverage amplifies systematic risk."
            ),
            variants: [
                FormulaVariant(name: "Hamada Equation (Traditional)", formula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D}{E}]", description: "Standard Hamada formula", whenToUse: "For most corporate finance applications"),
                FormulaVariant(name: "Harris-Pringle Adjustment", formula: "\\beta_L = \\beta_U[1 + \\frac{D}{E}]", description: "Without tax adjustment", whenToUse: "When debt tax benefits are uncertain"),
                FormulaVariant(name: "With Risky Debt", formula: "\\beta_L = \\beta_U + (\\beta_U - \\beta_D)(1-T)\\frac{D}{E}", description: "Includes debt beta", whenToUse: "When debt has significant credit risk"),
                FormulaVariant(name: "Book Value Version", formula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D_{book}}{E_{book}}]", description: "Using book values", whenToUse: "When market values are unavailable")
            ],
            usageNotes: [
                "Higher leverage increases systematic risk (beta)",
                "Tax shield reduces the leverage effect on beta",
                "Use market values for D and E when available",
                "Essential for WACC calculations and peer comparisons",
                "Useful for capital structure analysis",
                "Beta increases more than proportionally with leverage"
            ],
            examples: [
                FormulaExample(
                    title: "Utility Company Beta Adjustment",
                    description: "Utility with unlevered beta 0.6, D/E ratio 0.4, tax rate 25%",
                    inputs: ["βᵤ": "0.6", "D/E": "0.4", "T": "25%"],
                    calculation: "βₗ = 0.6 × [1 + (1-0.25) × 0.4] = 0.6 × [1 + 0.75 × 0.4] = 0.6 × 1.3",
                    result: "βₗ = 0.78",
                    interpretation: "Leverage increases systematic risk from 0.6 to 0.78"
                ),
                FormulaExample(
                    title: "Tech Company Capital Structure Change",
                    description: "If tech company (βᵤ = 1.2) increases D/E from 0.2 to 0.6, T = 30%",
                    inputs: ["βᵤ": "1.2", "D/E₁": "0.2", "D/E₂": "0.6", "T": "30%"],
                    calculation: "βₗ₁ = 1.2[1 + 0.7×0.2] = 1.37\nβₗ₂ = 1.2[1 + 0.7×0.6] = 1.70",
                    result: "Beta increases from 1.37 to 1.70",
                    interpretation: "Higher leverage significantly increases systematic risk"
                )
            ],
            relatedFormulas: ["wacc", "capm", "unlevered-beta", "cost-of-equity"],
            tags: ["beta", "leverage", "systematic-risk", "hamada", "capital-structure"]
        )
    }
    
    func createPEGRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "PEG Ratio",
            category: .equity,
            level: .levelI,
            mainFormula: "PEG = \\frac{P/E}{\\text{Growth Rate}}",
            description: "P/E ratio adjusted for growth rate. Provides growth-adjusted valuation metric.",
            variables: [
                FormulaVariable(symbol: "PEG", name: "PEG Ratio", description: "Price/Earnings to Growth ratio", units: "Unitless", typicalRange: "0.5 to 3.0", notes: "Values around 1.0 suggest fair valuation"),
                FormulaVariable(symbol: "P/E", name: "Price-to-Earnings Ratio", description: "Current stock price divided by earnings per share", units: "Multiple", typicalRange: "5 to 50+", notes: "Traditional valuation multiple"),
                FormulaVariable(symbol: "\\text{Growth Rate}", name: "Expected Growth Rate", description: "Projected annual earnings growth rate", units: "Percentage", typicalRange: "0% to 50%", notes: "Usually 3-5 year expected growth")
            ],
            derivation: FormulaDerivation(
                title: "PEG Ratio Development",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Identify P/E ratio limitation", formula: "P/E = \\frac{\\text{Price per Share}}{\\text{EPS}}", explanation: "P/E doesn't account for growth differences"),
                    DerivationStep(stepNumber: 2, description: "Recognize growth impact on valuation", formula: "\\text{Higher growth justifies higher P/E}", explanation: "Fast-growing companies deserve premium valuations"),
                    DerivationStep(stepNumber: 3, description: "Normalize P/E by growth rate", formula: "\\text{Growth-adjusted P/E} = \\frac{P/E}{\\text{Growth Rate}}", explanation: "Scale P/E by expected growth"),
                    DerivationStep(stepNumber: 4, description: "Define PEG ratio", formula: "PEG = \\frac{P/E}{\\text{Growth Rate}}", explanation: "Final PEG ratio formula")
                ],
                assumptions: [
                    "Growth rate projections are reliable",
                    "Growth rate is sustainable",
                    "P/E ratio is based on normalized earnings",
                    "Linear relationship between growth and valuation"
                ],
                notes: "Originally popularized by Peter Lynch for stock valuation."
            ),
            variants: [
                FormulaVariant(name: "Forward PEG", formula: "PEG = \\frac{\\text{Forward P/E}}{\\text{Growth Rate}}", description: "Uses forward-looking P/E ratio", whenToUse: "For more relevant current valuation"),
                FormulaVariant(name: "PEGY Ratio", formula: "PEGY = \\frac{P/E}{\\text{Growth Rate} + \\text{Dividend Yield}}", description: "Includes dividend yield", whenToUse: "For dividend-paying stocks"),
                FormulaVariant(name: "Industry-Adjusted PEG", formula: "\\text{Relative PEG} = \\frac{\\text{Stock PEG}}{\\text{Industry Average PEG}}", description: "Normalized to industry", whenToUse: "For peer comparisons"),
                FormulaVariant(name: "5-Year PEG", formula: "PEG_5 = \\frac{P/E}{\\text{5-Year CAGR}}", description: "Uses longer-term growth", whenToUse: "For cyclical companies")
            ],
            usageNotes: [
                "PEG < 1.0 may indicate undervaluation relative to growth",
                "PEG > 1.0 may suggest overvaluation relative to growth",
                "Most useful for growth stocks with predictable earnings",
                "Quality of growth (sustainability, profitability) matters",
                "Not suitable for companies with negative or zero growth",
                "Should be compared within similar industries"
            ],
            examples: [
                FormulaExample(
                    title: "Technology Growth Stock",
                    description: "Stock trading at P/E of 25x with expected 20% earnings growth",
                    inputs: ["P/E Ratio": "25.0", "Growth Rate": "20%"],
                    calculation: "PEG = 25.0 / 20.0 = 1.25",
                    result: "PEG = 1.25",
                    interpretation: "Slightly expensive relative to growth, but reasonable for quality growth"
                ),
                FormulaExample(
                    title: "Value vs Growth Comparison",
                    description: "Value stock: P/E 12, growth 8% vs Growth stock: P/E 30, growth 25%",
                    inputs: ["Value P/E/G": "12/8", "Growth P/E/G": "30/25"],
                    calculation: "Value PEG = 12/8 = 1.50\nGrowth PEG = 30/25 = 1.20",
                    result: "Growth stock has better PEG (1.20 vs 1.50)",
                    interpretation: "Despite higher P/E, growth stock offers better value per unit of growth"
                )
            ],
            relatedFormulas: ["pe-ratio", "growth-rate", "dividend-discount-model", "dcf"],
            tags: ["peg", "growth", "valuation", "peter-lynch", "relative-valuation"]
        )
    }
    
    func createEVEBITFormula() -> FormulaReference {
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
    
    func createResidualIncomeToEquityFormula() -> FormulaReference {
        FormulaReference(
            name: "Residual Income to Equity",
            category: .equity,
            level: .levelII,
            mainFormula: "RI = \\text{Net Income} - (r_e \\times \\text{Book Value}_{t-1})",
            description: "Equity earnings above required return. Measures value creation for shareholders after cost of equity.",
            variables: [
                FormulaVariable(symbol: "RI", name: "Residual Income", description: "Economic profit to equity holders", units: "Currency", typicalRange: "Can be positive or negative", notes: "Value created above required return"),
                FormulaVariable(symbol: "\\text{Net Income}", name: "Net Income", description: "After-tax earnings available to shareholders", units: "Currency", typicalRange: "Millions to billions", notes: "Bottom line profit from income statement"),
                FormulaVariable(symbol: "r_e", name: "Required Return on Equity", description: "Cost of equity capital", units: "Percentage", typicalRange: "8% to 20%", notes: "Often calculated using CAPM"),
                FormulaVariable(symbol: "\\text{Book Value}_{t-1}", name: "Beginning Book Value", description: "Shareholders' equity at start of period", units: "Currency", typicalRange: "Millions to billions", notes: "Invested equity capital base")
            ],
            derivation: FormulaDerivation(
                title: "Residual Income Model Development",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define economic profit concept", formula: "\\text{Economic Profit} = \\text{Accounting Profit} - \\text{Opportunity Cost}", explanation: "True profit accounts for all capital costs"),
                    DerivationStep(stepNumber: 2, description: "Calculate equity capital charge", formula: "\\text{Equity Charge} = r_e \\times \\text{Book Value}_{t-1}", explanation: "Cost of equity capital employed"),
                    DerivationStep(stepNumber: 3, description: "Define residual income", formula: "RI = \\text{Net Income} - \\text{Equity Charge}", explanation: "Earnings above equity cost"),
                    DerivationStep(stepNumber: 4, description: "Final residual income formula", formula: "RI = \\text{Net Income} - (r_e \\times \\text{Book Value}_{t-1})", explanation: "Complete residual income calculation")
                ],
                assumptions: [
                    "Net income accurately reflects economic performance",
                    "Book value approximates economic value of equity",
                    "Required return on equity is correctly estimated",
                    "Clean surplus accounting (no direct equity adjustments)"
                ],
                notes: "Residual income provides foundation for equity valuation models."
            ),
            variants: [
                FormulaVariant(name: "Residual Income Valuation", formula: "V_0 = BV_0 + \\sum_{t=1}^{\\infty} \\frac{RI_t}{(1+r_e)^t}", description: "Present value of residual income stream", whenToUse: "For equity valuation"),
                FormulaVariant(name: "Economic Value Added (EVA)", formula: "EVA = NOPAT - (WACC \\times \\text{Invested Capital})", description: "Firm-level economic profit", whenToUse: "For total firm performance"),
                FormulaVariant(name: "Normalized Residual Income", formula: "\\text{RI Margin} = \\frac{RI}{\\text{Book Value}_{t-1}}", description: "RI as percentage of equity", whenToUse: "For cross-company comparison"),
                FormulaVariant(name: "Market Value Added", formula: "MVA = \\text{Market Value} - \\text{Book Value}", description: "Total value created", whenToUse: "For cumulative value assessment")
            ],
            usageNotes: [
                "Positive RI indicates value creation for shareholders",
                "Superior to ROE for performance measurement",
                "Useful for management incentive compensation",
                "Can be projected for valuation purposes",
                "Sensitive to accounting policies and book value accuracy",
                "Most meaningful when compared across time or peers"
            ],
            examples: [
                FormulaExample(
                    title: "Retail Company Analysis",
                    description: "Company with $100M net income, 12% cost of equity, $800M beginning book value",
                    inputs: ["Net Income": "$100M", "rₑ": "12%", "BVₜ‑₁": "$800M"],
                    calculation: "RI = $100M - (12% × $800M) = $100M - $96M",
                    result: "RI = $4M",
                    interpretation: "Company created $4M in economic value above required return"
                ),
                FormulaExample(
                    title: "High Growth vs Mature Company",
                    description: "Growth: NI $50M, rₑ 15%, BV $200M vs Mature: NI $120M, rₑ 10%, BV $1B",
                    inputs: ["Growth RI": "50-30=20", "Mature RI": "120-100=20"],
                    calculation: "Growth RI = $50M - (15% × $200M) = $20M\nMature RI = $120M - (10% × $1B) = $20M",
                    result: "Both create equal economic value ($20M)",
                    interpretation: "Different business models can create equivalent shareholder value"
                )
            ],
            relatedFormulas: ["roe", "capm", "eva", "book-value", "equity-valuation"],
            tags: ["residual-income", "equity", "economic-profit", "value-creation", "performance"]
        )
    }
    
    // Continue with all remaining comprehensive formulas following this pattern...
    // The complete implementation would include all formulas from the research document
    
    func createBinomialTreeFormula() -> FormulaReference {
        FormulaReference(
            name: "Binomial Tree Model",
            category: .derivatives,
            level: .levelII,
            mainFormula: "V = \\frac{p \\times V_u + (1-p) \\times V_d}{1+r}",
            description: "Discrete-time option pricing model. Flexible framework for pricing American and European options.",
            variables: [
                FormulaVariable(symbol: "V", name: "Option Value", description: "Current option price", units: "Currency", typicalRange: "$0 to stock price", notes: "Present value of expected payoff"),
                FormulaVariable(symbol: "p", name: "Risk-Neutral Probability", description: "Probability of up movement in risk-neutral world", units: "Probability", typicalRange: "0 to 1", notes: "Not actual probability"),
                FormulaVariable(symbol: "V_u", name: "Option Value if Up", description: "Option value if stock moves up", units: "Currency", typicalRange: "$0 to max payoff", notes: "Value in up state"),
                FormulaVariable(symbol: "V_d", name: "Option Value if Down", description: "Option value if stock moves down", units: "Currency", typicalRange: "$0 to max payoff", notes: "Value in down state"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "One-period risk-free rate", units: "Percentage", typicalRange: "0% to 10%", notes: "Per time step rate")
            ],
            derivation: FormulaDerivation(
                title: "Binomial Option Pricing via Risk-Neutral Valuation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define stock price movements", formula: "S_u = S_0 \\times u, \\quad S_d = S_0 \\times d", explanation: "Stock can move up by factor u or down by factor d"),
                    DerivationStep(stepNumber: 2, description: "Create risk-free portfolio", formula: "\\Pi = \\Delta S - V", explanation: "Portfolio of Δ shares and short one option"),
                    DerivationStep(stepNumber: 3, description: "Set portfolio values equal in both states", formula: "\\Delta S_u - V_u = \\Delta S_d - V_d", explanation: "Risk-free portfolio has same payoff up or down"),
                    DerivationStep(stepNumber: 4, description: "Solve for hedge ratio", formula: "\\Delta = \\frac{V_u - V_d}{S_u - S_d}", explanation: "Number of shares needed to hedge option"),
                    DerivationStep(stepNumber: 5, description: "Calculate risk-neutral probability", formula: "p = \\frac{1+r-d}{u-d}", explanation: "Probability that makes expected return equal risk-free rate"),
                    DerivationStep(stepNumber: 6, description: "Apply risk-neutral valuation", formula: "V = \\frac{p \\times V_u + (1-p) \\times V_d}{1+r}", explanation: "Expected payoff discounted at risk-free rate")
                ],
                assumptions: [
                    "Stock follows multiplicative binomial process",
                    "Constant risk-free rate per period",
                    "No dividends during the period",
                    "No transaction costs or bid-ask spreads",
                    "Continuous trading possible"
                ],
                notes: "Converges to Black-Scholes as number of periods approaches infinity."
            ),
            variants: [
                FormulaVariant(name: "American Option", formula: "V = \\max\\left(\\text{Exercise Value}, \\frac{pV_u + (1-p)V_d}{1+r}\\right)", description: "Can exercise early", whenToUse: "For American-style options"),
                FormulaVariant(name: "Multi-Period Tree", formula: "V_0 = \\frac{1}{(1+r)^n} \\sum_{j=0}^{n} \\binom{n}{j} p^j (1-p)^{n-j} V_j", description: "n-period binomial model", whenToUse: "For greater accuracy"),
                FormulaVariant(name: "Cox-Ross-Rubinstein", formula: "u = e^{\\sigma\\sqrt{\\Delta t}}, \\quad d = e^{-\\sigma\\sqrt{\\Delta t}}", description: "Volatility-based parameters", whenToUse: "To match Black-Scholes volatility"),
                FormulaVariant(name: "Jarrow-Rudd", formula: "u = e^{(r-\\sigma^2/2)\\Delta t + \\sigma\\sqrt{\\Delta t}}", description: "Alternative parameterization", whenToUse: "For better convergence properties")
            ],
            usageNotes: [
                "More flexible than Black-Scholes for American options",
                "Can handle discrete dividends and varying volatility",
                "Computational time increases exponentially with periods",
                "Recombining tree reduces computational complexity",
                "Useful for path-dependent options",
                "Provides intuitive understanding of option pricing"
            ],
            examples: [
                FormulaExample(
                    title: "One-Period European Call",
                    description: "S₀=$100, X=$105, u=1.1, d=0.9, r=5%",
                    inputs: ["S₀": "$100", "X": "$105", "u": "1.1", "d": "0.9", "r": "5%"],
                    calculation: "Su=$110, Sd=$90\nVu=max(110-105,0)=$5, Vd=max(90-105,0)=$0\np=(1.05-0.9)/(1.1-0.9)=0.75\nV=(0.75×5+0.25×0)/1.05",
                    result: "V = $3.57",
                    interpretation: "Call option worth $3.57 using binomial model"
                ),
                FormulaExample(
                    title: "American Put Option",
                    description: "Check early exercise at each node",
                    inputs: ["Same parameters": "X=$105", "Option type": "American put"],
                    calculation: "At each node: V = max(Exercise Value, Continuation Value)",
                    result: "Early exercise may be optimal",
                    interpretation: "American options may have higher value due to early exercise feature"
                )
            ],
            relatedFormulas: ["black-scholes", "risk-neutral-probability", "delta-hedging", "american-options"],
            tags: ["binomial", "trees", "american-options", "discrete-time", "risk-neutral"]
        )
    }
    
    func createRiskNeutralProbabilityFormula() -> FormulaReference {
        FormulaReference(name: "Risk-Neutral Probability", category: .derivatives, level: .levelII, mainFormula: "p = \\frac{e^{rt} - d}{u - d}", description: "Probability measure for risk-neutral valuation.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["risk-neutral", "probability"])
    }
    
    func createForwardPricingWithDividendsFormula() -> FormulaReference {
        FormulaReference(name: "Forward Pricing with Dividends", category: .derivatives, level: .levelII, mainFormula: "F_0 = (S_0 - PV(\\text{Dividends})) \\times e^{rT}", description: "Forward price adjusted for dividend payments.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["forward", "dividends"])
    }
    
    func createCurrencyForwardFormula() -> FormulaReference {
        FormulaReference(name: "Currency Forward Pricing", category: .derivatives, level: .levelII, mainFormula: "F_0 = S_0 \\times e^{(r_d - r_f)T}", description: "Forward exchange rate based on interest rate differential.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["currency", "forward"])
    }
    
    func createFRASettlementFormula() -> FormulaReference {
        FormulaReference(name: "FRA Settlement", category: .derivatives, level: .levelII, mainFormula: "\\text{Settlement} = \\frac{\\text{Notional} \\times (r - r_{FRA}) \\times \\text{Days}/360}{1 + r \\times \\text{Days}/360}", description: "Cash settlement for forward rate agreement.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fra", "settlement"])
    }
    
    func createCAPItalAllocationLineFormula() -> FormulaReference {
        FormulaReference(name: "Capital Allocation Line", category: .portfolio, level: .levelI, mainFormula: "E(R_p) = R_f + \\frac{E(R_m) - R_f}{\\sigma_m} \\times \\sigma_p", description: "Risk-return tradeoff for portfolios combining risk-free asset and market portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cal", "portfolio-theory"])
    }
    
    func createOptimalPortfolioFormula() -> FormulaReference {
        FormulaReference(name: "Optimal Portfolio Weights", category: .portfolio, level: .levelII, mainFormula: "w = \\frac{\\Sigma^{-1} \\mu}{\\mathbf{1}^T \\Sigma^{-1} \\mu}", description: "Optimal weights for mean-variance portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["optimal", "markowitz"])
    }
    
    func createTrackingErrorFormula() -> FormulaReference {
        FormulaReference(name: "Tracking Error", category: .portfolio, level: .levelII, mainFormula: "TE = \\sqrt{\\text{Var}(R_p - R_b)}", description: "Standard deviation of active returns relative to benchmark.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["tracking-error", "active"])
    }
    
    func createBattingAverageFormula() -> FormulaReference {
        FormulaReference(name: "Batting Average", category: .portfolio, level: .levelIII, mainFormula: "\\text{Batting Average} = \\frac{\\text{Number of periods with positive active return}}{\\text{Total number of periods}}", description: "Percentage of periods with outperformance.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["batting-average", "consistency"])
    }
    
    func createMSquaredFormula() -> FormulaReference {
        FormulaReference(name: "M-Squared (M²)", category: .portfolio, level: .levelII, mainFormula: "M^2 = (R_p - R_f) \\times \\frac{\\sigma_m}{\\sigma_p} - (R_m - R_f)", description: "Risk-adjusted performance measure normalized to market volatility.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["m-squared", "risk-adjusted"])
    }
    
    func createDownsideCaptureRatioFormula() -> FormulaReference {
        FormulaReference(name: "Downside Capture Ratio", category: .portfolio, level: .levelIII, mainFormula: "\\text{Downside Capture} = \\frac{\\text{Portfolio return in down markets}}{\\text{Market return in down markets}}", description: "Percentage of market decline captured by portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["downside-capture", "defensive"])
    }
    
    func createUpsideCaptureRatioFormula() -> FormulaReference {
        FormulaReference(name: "Upside Capture Ratio", category: .portfolio, level: .levelIII, mainFormula: "\\text{Upside Capture} = \\frac{\\text{Portfolio return in up markets}}{\\text{Market return in up markets}}", description: "Percentage of market gains captured by portfolio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["upside-capture", "participation"])
    }
    
    // Continue with remaining categories...
    // Full implementation would include all categories with complete formulas
    
    func createCreditVaRFormula() -> FormulaReference {
        FormulaReference(name: "Credit Value at Risk", category: .risk, level: .levelIII, mainFormula: "\\text{Credit VaR} = \\text{UL} \\times z_{\\alpha} + \\text{EL}", description: "Maximum expected credit loss at confidence level.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["credit-var", "unexpected-loss"])
    }
    
    func createExpectedLossFormula() -> FormulaReference {
        FormulaReference(name: "Expected Loss", category: .risk, level: .levelII, mainFormula: "EL = PD \\times LGD \\times EAD", description: "Expected credit loss from default events.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["expected-loss", "credit"])
    }
    
    func createUnexpectedLossFormula() -> FormulaReference {
        FormulaReference(name: "Unexpected Loss", category: .risk, level: .levelIII, mainFormula: "UL = EAD \\times \\sqrt{PD \\times LGD^2 \\times (1-PD) + LGD^2 \\times PD \\times (1-PD)}", description: "Standard deviation of credit losses.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["unexpected-loss", "credit-risk"])
    }
    
    func createBaselCapitalRatioFormula() -> FormulaReference {
        FormulaReference(name: "Basel Capital Ratio", category: .risk, level: .levelIII, mainFormula: "\\text{Capital Ratio} = \\frac{\\text{Tier 1 + Tier 2 Capital}}{\\text{Risk-Weighted Assets}}", description: "Regulatory capital adequacy measure.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["basel", "capital", "regulatory"])
    }
    
    func createLiquidityRiskFormula() -> FormulaReference {
        FormulaReference(name: "Liquidity Coverage Ratio", category: .risk, level: .levelIII, mainFormula: "LCR = \\frac{\\text{High Quality Liquid Assets}}{\\text{Net Cash Outflows over 30 days}}", description: "Short-term liquidity risk measure.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity", "lcr"])
    }
    
    func createStressTestingFormula() -> FormulaReference {
        FormulaReference(name: "Stress Testing", category: .risk, level: .levelIII, mainFormula: "\\text{Stressed Loss} = \\sum_i w_i \\times \\text{Scenario Loss}_i", description: "Portfolio loss under stress scenarios.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["stress-testing", "scenarios"])
    }
    
    // Alternative Investments
    func createPrivateEquityMetricsFormula() -> FormulaReference {
        FormulaReference(name: "Private Equity Metrics", category: .alternatives, level: .levelII, mainFormula: "TVPI = \\frac{\\text{Distributions} + \\text{Remaining Value}}{\\text{Paid-in Capital}}", description: "Total value to paid-in capital multiple.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["tvpi", "private-equity"])
    }
    
    func createRealEstateMetricsFormula() -> FormulaReference {
        FormulaReference(name: "Real Estate Investment Metrics", category: .alternatives, level: .levelII, mainFormula: "\\text{FFO} = \\text{Net Income} + \\text{Depreciation} - \\text{Gains on Sales}", description: "Funds from operations for REITs.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ffo", "reit"])
    }
    
    func createCommodityPricingFormula() -> FormulaReference {
        FormulaReference(name: "Commodity Futures Pricing", category: .alternatives, level: .levelII, mainFormula: "F_0 = S_0 e^{(r+c-y)T}", description: "Futures price with storage costs and convenience yield.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["commodities", "futures"])
    }
    
    func createHedgeFundMetricsFormula() -> FormulaReference {
        FormulaReference(name: "Hedge Fund Performance Metrics", category: .alternatives, level: .levelII, mainFormula: "\\text{Alpha} = R_p - [R_f + \\beta_1(R_{mkt} - R_f) + \\beta_2 \\text{SMB} + \\beta_3 \\text{HML}]", description: "Multi-factor alpha for hedge funds.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hedge-fund", "alpha"])
    }
    
    // Quantitative Methods
    func createRegressionAnalysisFormula() -> FormulaReference {
        FormulaReference(name: "Multiple Regression", category: .quantitative, level: .levelII, mainFormula: "Y = \\beta_0 + \\beta_1 X_1 + \\beta_2 X_2 + ... + \\beta_k X_k + \\varepsilon", description: "Multiple linear regression model.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression", "multiple"])
    }
    
    func createTimeSeriesFormula() -> FormulaReference {
        FormulaReference(name: "Autoregressive Model", category: .quantitative, level: .levelII, mainFormula: "x_t = c + \\phi_1 x_{t-1} + \\phi_2 x_{t-2} + ... + \\phi_p x_{t-p} + \\varepsilon_t", description: "AR(p) time series model.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["time-series", "ar"])
    }
    
    func createMonteCarloFormula() -> FormulaReference {
        FormulaReference(name: "Monte Carlo Simulation", category: .quantitative, level: .levelII, mainFormula: "\\hat{\\theta} = \\frac{1}{n} \\sum_{i=1}^{n} g(X_i)", description: "Monte Carlo estimator for expected values.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["monte-carlo", "simulation"])
    }
    
    func createBootstrapMethodFormula() -> FormulaReference {
        FormulaReference(name: "Bootstrap Confidence Interval", category: .quantitative, level: .levelII, mainFormula: "CI = [\\hat{\\theta}_{\\alpha/2}, \\hat{\\theta}_{1-\\alpha/2}]", description: "Bootstrap confidence interval for parameter estimates.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bootstrap", "confidence-interval"])
    }
    
    func createHypothesisTestingFormula() -> FormulaReference {
        FormulaReference(name: "Hypothesis Testing", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{\\bar{x} - \\mu_0}{s/\\sqrt{n}}", description: "t-test for population mean.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hypothesis", "t-test"])
    }
    
    // Economics and FRA
    func createFinancialLeverageFormula() -> FormulaReference {
        FormulaReference(name: "Financial Leverage", category: .economics, level: .levelI, mainFormula: "FL = \\frac{\\text{Average Total Assets}}{\\text{Average Shareholders' Equity}}", description: "Measure of financial leverage through asset-to-equity ratio.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage", "financial"])
    }
    
    func createOperatingLeverageFormula() -> FormulaReference {
        FormulaReference(name: "Operating Leverage", category: .economics, level: .levelI, mainFormula: "DOL = \\frac{\\text{Contribution Margin}}{\\text{Operating Income}}", description: "Degree of operating leverage measuring fixed cost impact.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["operating-leverage", "fixed-costs"])
    }
    
    func createCombinedLeverageFormula() -> FormulaReference {
        FormulaReference(name: "Combined Leverage", category: .economics, level: .levelI, mainFormula: "DCL = DOL \\times DFL", description: "Combined effect of operating and financial leverage.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["combined-leverage", "total-risk"])
    }
    
    func createCashConversionCycleFormula() -> FormulaReference {
        FormulaReference(name: "Cash Conversion Cycle", category: .economics, level: .levelI, mainFormula: "CCC = DIO + DSO - DPO", description: "Time required to convert investments into cash flows.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-cycle", "working-capital"])
    }
    
    func createZScoreFormula() -> FormulaReference {
        FormulaReference(name: "Z-Score", category: .economics, level: .levelI, mainFormula: "Z = \\frac{x - \\mu}{\\sigma}", description: "Standardized score for normal distribution.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["z-score", "standardized"])
    }
    
    func createAltmanZScoreFormula() -> FormulaReference {
        FormulaReference(name: "Altman Z-Score", category: .economics, level: .levelII, mainFormula: "Z = 1.2A + 1.4B + 3.3C + 0.6D + 1.0E", description: "Bankruptcy prediction model using financial ratios.", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["altman", "bankruptcy", "credit"])
    }
    
    // MARK: - Additional Critical CFA Level III Formulas
    
    func createAssetLiabilityMatchingFormula() -> FormulaReference {
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
    
    func createBlackLittermanFormula() -> FormulaReference {
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
    
    func createMonteCarloPortfolioFormula() -> FormulaReference {
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
    
    func createMoneyWeightedReturnFormula() -> FormulaReference {
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
    
    func createTimeWeightedReturnFormula() -> FormulaReference {
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
    
    func createSkewnessFormula() -> FormulaReference {
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
    
    func createKurtosisFormula() -> FormulaReference {
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
    
    func createTaylorRuleFormula() -> FormulaReference {
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
    
    func createGrinoldKronerModelFormula() -> FormulaReference {
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
    
    func createPresentValueFormula() -> FormulaReference {
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
    
    func createFutureValueFormula() -> FormulaReference {
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
    
    func createAnnuityPresentValueFormula() -> FormulaReference {
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
    
    func createPerpetuityFormula() -> FormulaReference {
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
    
    func createAnnuityFutureValueFormula() -> FormulaReference {
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
    
    func createGrowingPerpetuityFormula() -> FormulaReference {
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
    
    func createEffectiveAnnualRateFormula() -> FormulaReference {
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
    
    func createAnnualizedReturnFormula() -> FormulaReference {
        FormulaReference(name: "Annualized Return", category: .quantitative, level: .levelI, mainFormula: "r_{annual} = (1 + r_{total})^{\\frac{1}{n}} - 1", description: "Converts total return over multiple periods to equivalent annual rate", variables: [], derivation: nil, variants: [], usageNotes: ["Used to compare investments with different time horizons"], examples: [], relatedFormulas: ["compound-return"], tags: ["annualized", "return"])
    }
    
    func createContinuousCompoundingFormula() -> FormulaReference {
        FormulaReference(
            name: "Continuous Compounding",
            category: .quantitative,
            level: .levelI,
            mainFormula: "FV = PV \\times e^{rt}",
            description: "Future value calculation when interest is compounded continuously",
            variables: [
                FormulaVariable(
                    symbol: "FV",
                    name: "Future Value",
                    description: "Value of investment after continuous compounding",
                    units: "Currency",
                    typicalRange: "Any positive value",
                    notes: "Result of exponential growth with continuous compounding"
                ),
                FormulaVariable(
                    symbol: "PV",
                    name: "Present Value",
                    description: "Initial investment or principal amount",
                    units: "Currency",
                    typicalRange: "Any positive value",
                    notes: "Starting amount before compounding"
                ),
                FormulaVariable(
                    symbol: "e",
                    name: "Euler's Number",
                    description: "Mathematical constant approximately equal to 2.71828",
                    units: "Dimensionless",
                    typicalRange: "2.71828...",
                    notes: "Base of natural logarithm, fundamental to exponential growth"
                ),
                FormulaVariable(
                    symbol: "r",
                    name: "Annual Interest Rate",
                    description: "Nominal annual interest rate expressed as decimal",
                    units: "Decimal (e.g., 0.05 for 5%)",
                    typicalRange: "0.01 to 0.20 for most investments",
                    notes: "Must be expressed as decimal, not percentage"
                ),
                FormulaVariable(
                    symbol: "t",
                    name: "Time Period",
                    description: "Number of years for the investment",
                    units: "Years",
                    typicalRange: "Any positive value",
                    notes: "Can be fractional (e.g., 0.5 for 6 months)"
                )
            ],
            derivation: FormulaDerivation(
                title: "Continuous Compounding Derivation",
                steps: [
                    DerivationStep(
                        stepNumber: 1,
                        description: "Start with discrete compounding formula",
                        formula: "FV = PV(1 + \\frac{r}{m})^{mt}",
                        explanation: "Where m is the number of compounding periods per year"
                    ),
                    DerivationStep(
                        stepNumber: 2,
                        description: "Take the limit as m approaches infinity",
                        formula: "\\lim_{m \\to \\infty} PV(1 + \\frac{r}{m})^{mt}",
                        explanation: "Continuous compounding means infinite compounding frequency"
                    ),
                    DerivationStep(
                        stepNumber: 3,
                        description: "Apply the definition of e",
                        formula: "\\lim_{n \\to \\infty} (1 + \\frac{1}{n})^n = e",
                        explanation: "This fundamental limit defines Euler's number"
                    ),
                    DerivationStep(
                        stepNumber: 4,
                        description: "Substitute and simplify",
                        formula: "FV = PV \\times e^{rt}",
                        explanation: "The final continuous compounding formula"
                    )
                ],
                assumptions: [
                    "Interest rate remains constant over the entire period",
                    "No additional deposits or withdrawals during the period",
                    "Interest is compounded continuously (infinite frequency)"
                ],
                notes: "Continuous compounding represents the theoretical maximum return for a given interest rate"
            ),
            variants: [
                FormulaVariant(
                    name: "Continuous Present Value",
                    formula: "PV = FV \\times e^{-rt}",
                    description: "Present value calculation with continuous discounting",
                    whenToUse: "When discounting future cash flows with continuous compounding assumption"
                ),
                FormulaVariant(
                    name: "Continuous Annual Rate",
                    formula: "r = \\frac{\\ln(\\frac{FV}{PV})}{t}",
                    description: "Solving for the continuous interest rate",
                    whenToUse: "When determining the required rate for continuous compounding"
                ),
                FormulaVariant(
                    name: "Continuous Time Period",
                    formula: "t = \\frac{\\ln(\\frac{FV}{PV})}{r}",
                    description: "Solving for the time period with continuous compounding",
                    whenToUse: "When determining how long continuous compounding takes to reach a target"
                )
            ],
            usageNotes: [
                "Represents the theoretical maximum compounding frequency",
                "Provides only slightly higher returns than daily compounding for most practical rates",
                "Commonly used in theoretical finance models and option pricing",
                "The natural logarithm (ln) is used when solving for r or t",
                "Most useful for academic understanding rather than practical investing",
                "Banks rarely offer true continuous compounding in practice"
            ],
            examples: [
                FormulaExample(
                    title: "Continuous vs Annual Compounding",
                    description: "Compare $10,000 invested at 8% for 5 years with different compounding frequencies",
                    inputs: [
                        "PV": "$10,000",
                        "r": "8% (0.08)",
                        "t": "5 years"
                    ],
                    calculation: "FV = $10,000 × e^(0.08 × 5) = $10,000 × e^0.4 = $10,000 × 1.4918 = $14,918.25",
                    result: "$14,918.25",
                    interpretation: "Continuous compounding yields $14,918.25 vs $14,693.28 with annual compounding - only $224.97 difference"
                ),
                FormulaExample(
                    title: "Finding Required Continuous Rate",
                    description: "What continuous rate is needed to double $5,000 in 10 years?",
                    inputs: [
                        "PV": "$5,000",
                        "FV": "$10,000",
                        "t": "10 years"
                    ],
                    calculation: "r = ln(10,000/5,000) ÷ 10 = ln(2) ÷ 10 = 0.6931 ÷ 10 = 0.06931",
                    result: "6.931% continuous rate",
                    interpretation: "A 6.931% continuous rate will double the investment in exactly 10 years"
                )
            ],
            relatedFormulas: ["future-value", "present-value", "effective-annual-rate"],
            tags: ["continuous", "compounding", "exponential", "euler", "theoretical"]
        )
    }
    
    func createCoefficientOfVariationFormula() -> FormulaReference {
        FormulaReference(
            name: "Coefficient of Variation",
            category: .quantitative,
            level: .levelI,
            mainFormula: "CV = \\frac{\\sigma}{\\mu}",
            description: "Relative measure of dispersion comparing standard deviation to mean, used for risk-adjusted return comparison",
            variables: [
                FormulaVariable(
                    symbol: "CV",
                    name: "Coefficient of Variation",
                    description: "Standardized measure of dispersion expressed as ratio",
                    units: "Dimensionless (ratio)",
                    typicalRange: "0 to 2.0 for most investments",
                    notes: "Lower values indicate less relative risk per unit of return"
                ),
                FormulaVariable(
                    symbol: "\\sigma",
                    name: "Standard Deviation",
                    description: "Measure of absolute risk or volatility",
                    units: "Same as mean (%, $, etc.)",
                    typicalRange: "0.05 to 0.30 for stock returns",
                    notes: "Represents absolute risk regardless of return level"
                ),
                FormulaVariable(
                    symbol: "\\mu",
                    name: "Mean (Expected Return)",
                    description: "Average or expected value of the distribution",
                    units: "% for returns, $ for values",
                    typicalRange: "0.03 to 0.15 for stock returns",
                    notes: "Must be positive for meaningful CV calculation"
                )
            ],
            derivation: FormulaDerivation(
                title: "Coefficient of Variation Purpose",
                steps: [
                    DerivationStep(
                        stepNumber: 1,
                        description: "Standard deviation measures absolute risk",
                        formula: "\\sigma = \\sqrt{\\frac{\\sum(X_i - \\mu)^2}{n}}",
                        explanation: "Absolute measure dependent on scale of returns"
                    ),
                    DerivationStep(
                        stepNumber: 2,
                        description: "Need scale-independent risk measure",
                        formula: "\\text{Relative Risk} = \\frac{\\text{Absolute Risk}}{\\text{Expected Return}}",
                        explanation: "Normalize by dividing by expected return"
                    ),
                    DerivationStep(
                        stepNumber: 3,
                        description: "Coefficient of variation formula",
                        formula: "CV = \\frac{\\sigma}{\\mu}",
                        explanation: "Risk per unit of expected return"
                    )
                ],
                assumptions: [
                    "Mean (expected return) must be positive",
                    "Returns are measured over the same time period",
                    "Data represents comparable investment opportunities"
                ],
                notes: "Lower CV indicates better risk-adjusted returns"
            ),
            variants: [
                FormulaVariant(
                    name: "CV as Percentage",
                    formula: "CV\\% = \\frac{\\sigma}{\\mu} \\times 100\\%",
                    description: "Coefficient of variation expressed as percentage",
                    whenToUse: "For easier interpretation and comparison"
                ),
                FormulaVariant(
                    name: "Sample CV",
                    formula: "CV = \\frac{s}{\\bar{X}}",
                    description: "CV using sample standard deviation and sample mean",
                    whenToUse: "When working with historical sample data"
                )
            ],
            usageNotes: [
                "Lower CV indicates better risk-adjusted investment opportunity",
                "Only meaningful when comparing investments with positive expected returns",
                "Essential for comparing investments with different return scales",
                "Widely used in portfolio optimization and asset allocation",
                "Key metric in CFA Institute risk-return analysis",
                "Helps identify efficient investments (low risk per unit return)"
            ],
            examples: [
                FormulaExample(
                    title: "Comparing Two Investment Options",
                    description: "Compare Stock A vs Stock B using coefficient of variation",
                    inputs: [
                        "Stock A": "μ = 12%, σ = 18%",
                        "Stock B": "μ = 8%, σ = 10%"
                    ],
                    calculation: "CV_A = 18%/12% = 1.50, CV_B = 10%/8% = 1.25",
                    result: "Stock A CV = 1.50, Stock B CV = 1.25",
                    interpretation: "Stock B has better risk-adjusted returns (lower CV) despite lower absolute returns"
                ),
                FormulaExample(
                    title: "Portfolio Manager Selection",
                    description: "Evaluate fund managers based on risk-adjusted performance",
                    inputs: [
                        "Manager 1": "Return = 15%, Volatility = 20%",
                        "Manager 2": "Return = 10%, Volatility = 8%"
                    ],
                    calculation: "CV₁ = 20%/15% = 1.33, CV₂ = 8%/10% = 0.80",
                    result: "Manager 1 CV = 1.33, Manager 2 CV = 0.80",
                    interpretation: "Manager 2 provides superior risk-adjusted returns with 0.80 units of risk per unit return"
                )
            ],
            relatedFormulas: ["standard-deviation", "sharpe-ratio", "mean"],
            tags: ["cv", "relative-risk", "risk-adjusted", "portfolio-analysis", "cfa-level-i"]
        )
    }
    
    func createCovarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Covariance",
            category: .quantitative,
            level: .levelI,
            mainFormula: "Cov(X,Y) = \\frac{\\sum_{i=1}^{n}(X_i - \\bar{X})(Y_i - \\bar{Y})}{n-1}",
            description: "Statistical measure of how two variables move together, fundamental to portfolio theory and diversification",
            variables: [
                FormulaVariable(
                    symbol: "Cov(X,Y)",
                    name: "Covariance",
                    description: "Measure of linear relationship between variables X and Y",
                    units: "Product of variable units (e.g., %² for returns)",
                    typicalRange: "-∞ to +∞",
                    notes: "Positive = move together, Negative = move opposite, Zero = no linear relationship"
                ),
                FormulaVariable(
                    symbol: "X_i, Y_i",
                    name: "Paired Observations",
                    description: "Individual data points for variables X and Y at time i",
                    units: "Depends on variables (%, $, etc.)",
                    typicalRange: "Any real values",
                    notes: "Must have same number of observations for both variables"
                ),
                FormulaVariable(
                    symbol: "\\bar{X}, \\bar{Y}",
                    name: "Sample Means",
                    description: "Average values of variables X and Y respectively",
                    units: "Same as original variables",
                    typicalRange: "Any real values",
                    notes: "Calculated as sum of observations divided by n"
                ),
                FormulaVariable(
                    symbol: "n",
                    name: "Sample Size",
                    description: "Number of paired observations",
                    units: "Count",
                    typicalRange: "n ≥ 2 (practically n ≥ 30)",
                    notes: "Larger samples provide more reliable covariance estimates"
                )
            ],
            derivation: FormulaDerivation(
                title: "Covariance Derivation",
                steps: [
                    DerivationStep(
                        stepNumber: 1,
                        description: "Measure deviation from means",
                        formula: "(X_i - \\bar{X}) \\text{ and } (Y_i - \\bar{Y})",
                        explanation: "How much each observation differs from its variable's mean"
                    ),
                    DerivationStep(
                        stepNumber: 2,
                        description: "Multiply deviations for each pair",
                        formula: "(X_i - \\bar{X})(Y_i - \\bar{Y})",
                        explanation: "Positive when both above/below means, negative when opposite"
                    ),
                    DerivationStep(
                        stepNumber: 3,
                        description: "Sum all products",
                        formula: "\\sum_{i=1}^{n}(X_i - \\bar{X})(Y_i - \\bar{Y})",
                        explanation: "Total measure of joint variation"
                    ),
                    DerivationStep(
                        stepNumber: 4,
                        description: "Divide by degrees of freedom",
                        formula: "Cov(X,Y) = \\frac{\\sum_{i=1}^{n}(X_i - \\bar{X})(Y_i - \\bar{Y})}{n-1}",
                        explanation: "Sample covariance using n-1 for unbiased estimation"
                    )
                ],
                assumptions: [
                    "Data represents paired observations over same time periods",
                    "Variables have meaningful numerical relationship",
                    "Sample is representative of population"
                ],
                notes: "Population covariance uses n instead of n-1 in denominator"
            ),
            variants: [
                FormulaVariant(
                    name: "Population Covariance",
                    formula: "\\sigma_{XY} = \\frac{\\sum_{i=1}^{n}(X_i - \\mu_X)(Y_i - \\mu_Y)}{n}",
                    description: "Covariance when data represents entire population",
                    whenToUse: "When working with complete population data, not a sample"
                ),
                FormulaVariant(
                    name: "Alternative Formula",
                    formula: "Cov(X,Y) = \\frac{\\sum XY - \\frac{\\sum X \\sum Y}{n}}{n-1}",
                    description: "Computational formula avoiding repeated mean calculations",
                    whenToUse: "For easier calculation with raw data"
                ),
                FormulaVariant(
                    name: "Expected Value Form",
                    formula: "Cov(X,Y) = E[(X - E[X])(Y - E[Y])]",
                    description: "Theoretical definition using expected values",
                    whenToUse: "In theoretical derivations and proofs"
                )
            ],
            usageNotes: [
                "Foundation of modern portfolio theory and diversification benefits",
                "Positive covariance: assets move in same direction (reduces diversification)",
                "Negative covariance: assets move opposite (enhances diversification)",
                "Zero covariance: no linear relationship (neutral for diversification)",
                "Scale-dependent measure (units matter for interpretation)",
                "Essential input for portfolio variance and correlation calculations"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Returns Covariance",
                    description: "Calculate covariance between Stock A and Stock B monthly returns",
                    inputs: [
                        "Month 1": "Stock A: 2%, Stock B: 1%",
                        "Month 2": "Stock A: -1%, Stock B: 3%",
                        "Month 3": "Stock A: 4%, Stock B: 2%",
                        "Mean A": "1.67%, Mean B: 2.00%"
                    ],
                    calculation: "Cov = [(2-1.67)(1-2) + (-1-1.67)(3-2) + (4-1.67)(2-2)] / (3-1) = [0.33×(-1) + (-2.67)×1 + 2.33×0] / 2 = -3.00 / 2 = -1.50",
                    result: "Covariance = -1.50 (%²)",
                    interpretation: "Negative covariance suggests stocks tend to move in opposite directions, providing diversification benefits"
                ),
                FormulaExample(
                    title: "Portfolio Construction Application",
                    description: "Using covariance to assess diversification potential between two assets",
                    inputs: [
                        "Asset 1 σ": "15%",
                        "Asset 2 σ": "20%",
                        "Covariance": "-30 (%²)"
                    ],
                    calculation: "Correlation = Cov / (σ₁ × σ₂) = -30 / (15 × 20) = -30 / 300 = -0.10",
                    result: "Correlation = -0.10",
                    interpretation: "Weak negative correlation provides modest diversification benefits in portfolio construction"
                )
            ],
            relatedFormulas: ["correlation", "portfolio-variance", "standard-deviation"],
            tags: ["covariance", "portfolio-theory", "diversification", "risk-management", "cfa-level-i"]
        )
    }
    
    func createCorrelationFormula() -> FormulaReference {
        FormulaReference(
            name: "Correlation Coefficient",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\rho_{X,Y} = \\frac{Cov(X,Y)}{\\sigma_X \\sigma_Y}",
            description: "Standardized measure of linear relationship between two variables, essential for portfolio diversification analysis",
            variables: [
                FormulaVariable(
                    symbol: "\\rho_{X,Y}",
                    name: "Correlation Coefficient",
                    description: "Standardized measure of linear relationship between X and Y",
                    units: "Dimensionless",
                    typicalRange: "-1.0 to +1.0",
                    notes: "+1 = perfect positive, -1 = perfect negative, 0 = no linear relationship"
                ),
                FormulaVariable(
                    symbol: "Cov(X,Y)",
                    name: "Covariance",
                    description: "Raw measure of how variables X and Y move together",
                    units: "Product of variable units",
                    typicalRange: "-∞ to +∞",
                    notes: "Scale-dependent measure that gets standardized by correlation"
                ),
                FormulaVariable(
                    symbol: "\\sigma_X",
                    name: "Standard Deviation of X",
                    description: "Measure of variability in variable X",
                    units: "Same as variable X",
                    typicalRange: "Always positive",
                    notes: "Square root of variance, measures spread of X values"
                ),
                FormulaVariable(
                    symbol: "\\sigma_Y",
                    name: "Standard Deviation of Y",
                    description: "Measure of variability in variable Y",
                    units: "Same as variable Y",
                    typicalRange: "Always positive",
                    notes: "Square root of variance, measures spread of Y values"
                )
            ],
            derivation: FormulaDerivation(
                title: "Correlation Standardization",
                steps: [
                    DerivationStep(
                        stepNumber: 1,
                        description: "Start with covariance formula",
                        formula: "Cov(X,Y) = \\frac{\\sum_{i=1}^{n}(X_i - \\bar{X})(Y_i - \\bar{Y})}{n-1}",
                        explanation: "Raw measure of joint variability"
                    ),
                    DerivationStep(
                        stepNumber: 2,
                        description: "Problem: covariance is scale-dependent",
                        formula: "\\text{Units of } Cov(X,Y) = \\text{Units of X} \\times \\text{Units of Y}",
                        explanation: "Cannot compare covariances of different variable pairs"
                    ),
                    DerivationStep(
                        stepNumber: 3,
                        description: "Standardize by dividing by standard deviations",
                        formula: "\\rho_{X,Y} = \\frac{Cov(X,Y)}{\\sigma_X \\sigma_Y}",
                        explanation: "Creates dimensionless measure bounded by -1 and +1"
                    ),
                    DerivationStep(
                        stepNumber: 4,
                        description: "Alternative form using deviations",
                        formula: "\\rho_{X,Y} = \\frac{\\sum(X_i - \\bar{X})(Y_i - \\bar{Y})}{\\sqrt{\\sum(X_i - \\bar{X})^2 \\sum(Y_i - \\bar{Y})^2}}",
                        explanation: "Direct calculation without separate covariance step"
                    )
                ],
                assumptions: [
                    "Linear relationship between variables",
                    "Both standard deviations are positive (non-zero)",
                    "Data represents meaningful paired observations"
                ],
                notes: "Correlation measures only linear relationships; non-linear associations may not be detected"
            ),
            variants: [
                FormulaVariant(
                    name: "Pearson Product-Moment Correlation",
                    formula: "r = \\frac{\\sum(X_i - \\bar{X})(Y_i - \\bar{Y})}{\\sqrt{\\sum(X_i - \\bar{X})^2} \\sqrt{\\sum(Y_i - \\bar{Y})^2}}",
                    description: "Sample correlation coefficient calculated directly from data",
                    whenToUse: "Most common form for sample data analysis"
                ),
                FormulaVariant(
                    name: "Population Correlation",
                    formula: "\\rho = \\frac{\\sigma_{XY}}{\\sigma_X \\sigma_Y}",
                    description: "Population correlation using population parameters",
                    whenToUse: "When working with complete population data"
                ),
                FormulaVariant(
                    name: "Computational Formula",
                    formula: "r = \\frac{n\\sum XY - \\sum X \\sum Y}{\\sqrt{[n\\sum X^2 - (\\sum X)^2][n\\sum Y^2 - (\\sum Y)^2]}}",
                    description: "Formula avoiding mean calculations for computational efficiency",
                    whenToUse: "For hand calculations or programming implementations"
                )
            ],
            usageNotes: [
                "Perfect positive correlation (+1): variables move in perfect unison",
                "Perfect negative correlation (-1): variables move in perfect opposition",
                "Zero correlation (0): no linear relationship (but non-linear relationships may exist)",
                "Strong correlation: |ρ| > 0.7, Moderate: 0.3 < |ρ| < 0.7, Weak: |ρ| < 0.3",
                "Essential for portfolio diversification: lower correlation = better diversification",
                "Key input for calculating portfolio risk and optimal asset allocation",
                "Does not imply causation - correlation ≠ causation"
            ],
            examples: [
                FormulaExample(
                    title: "Portfolio Diversification Analysis",
                    description: "Calculate correlation between two stocks for diversification assessment",
                    inputs: [
                        "Stock A σ": "20%",
                        "Stock B σ": "25%",
                        "Covariance": "200 (%²)"
                    ],
                    calculation: "ρ = Cov(A,B) / (σ_A × σ_B) = 200 / (20 × 25) = 200 / 500 = 0.40",
                    result: "Correlation = 0.40",
                    interpretation: "Moderate positive correlation provides some diversification benefits, but stocks move together 40% of the time"
                ),
                FormulaExample(
                    title: "Hedge Effectiveness",
                    description: "Evaluate hedging relationship between stock and its options",
                    inputs: [
                        "Stock returns σ": "30%",
                        "Option returns σ": "150%",
                        "Covariance": "-3600 (%²)"
                    ],
                    calculation: "ρ = -3600 / (30 × 150) = -3600 / 4500 = -0.80",
                    result: "Correlation = -0.80",
                    interpretation: "Strong negative correlation indicates options provide effective hedge against stock price movements"
                ),
                FormulaExample(
                    title: "Market Relationship Analysis",
                    description: "Analyze relationship between individual stock and market index",
                    inputs: [
                        "Stock XYZ σ": "35%",
                        "S&P 500 σ": "15%",
                        "Covariance": "420 (%²)"
                    ],
                    calculation: "ρ = 420 / (35 × 15) = 420 / 525 = 0.80",
                    result: "Correlation = 0.80",
                    interpretation: "High positive correlation suggests stock closely follows market movements (high systematic risk)"
                )
            ],
            relatedFormulas: ["covariance", "beta", "portfolio-variance", "sharpe-ratio"],
            tags: ["correlation", "diversification", "portfolio-theory", "risk-management", "cfa-level-i"]
        )
    }
    
    func createMacaulayDurationDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Macaulay Duration (Detailed)", category: .fixedIncome, level: .levelI, mainFormula: "D_{Mac} = \\frac{\\sum_{t=1}^{n} t \\times \\frac{CF_t}{(1+YTM)^t}}{P}", description: "Weighted average time to receive bond cash flows", variables: [], derivation: nil, variants: [], usageNotes: ["Measured in years"], examples: [], relatedFormulas: ["modified-duration"], tags: ["duration", "bond"])
    }
    
    func createSwapSpreadFormula() -> FormulaReference {
        FormulaReference(name: "Swap Spread", category: .fixedIncome, level: .levelII, mainFormula: "\\text{Swap Spread} = \\text{Swap Rate} - \\text{Government Bond Yield}", description: "Credit spread between swap rate and government bond of same maturity", variables: [], derivation: nil, variants: [], usageNotes: ["Indicates credit risk premium"], examples: [], relatedFormulas: ["interest-rate-swap"], tags: ["swap-spread", "credit"])
    }
    
    func createTEDSpreadFormula() -> FormulaReference {
        FormulaReference(name: "TED Spread", category: .fixedIncome, level: .levelII, mainFormula: "\\text{TED Spread} = \\text{LIBOR} - \\text{T-bill Rate}", description: "Spread between LIBOR and Treasury bill rates, indicating credit risk", variables: [], derivation: nil, variants: [], usageNotes: ["Higher spread indicates financial stress"], examples: [], relatedFormulas: ["libor"], tags: ["ted-spread", "credit-risk"])
    }
    
    func createLiborOISSpreadFormula() -> FormulaReference {
        FormulaReference(name: "LIBOR-OIS Spread", category: .fixedIncome, level: .levelII, mainFormula: "\\text{LIBOR-OIS} = \\text{LIBOR} - \\text{OIS Rate}", description: "Spread between LIBOR and overnight indexed swap rate", variables: [], derivation: nil, variants: [], usageNotes: ["Measures bank funding stress"], examples: [], relatedFormulas: ["libor"], tags: ["libor-ois", "funding-stress"])
    }
    
    func createCreditDefaultSwapFormula() -> FormulaReference {
        FormulaReference(name: "Credit Default Swap", category: .derivatives, level: .levelII, mainFormula: "\\text{CDS Spread} \\approx (1 - \\text{Recovery Rate}) \\times \\text{PD}", description: "Credit default swap spread approximation", variables: [], derivation: nil, variants: [], usageNotes: ["Measures credit risk"], examples: [], relatedFormulas: ["probability-of-default"], tags: ["cds", "credit-risk"])
    }
    
    func createMultipleRegressionFormula() -> FormulaReference {
        FormulaReference(name: "Multiple Regression", category: .quantitative, level: .levelII, mainFormula: "Y_i = b_0 + b_1 X_{1i} + b_2 X_{2i} + \\dots + b_k X_{ki} + \\varepsilon_i", description: "Linear regression with multiple independent variables", variables: [], derivation: nil, variants: [], usageNotes: ["Used for factor models"], examples: [], relatedFormulas: ["regression-analysis"], tags: ["regression", "multiple"])
    }
    
    func createTimeSeriesAnalysisFormula() -> FormulaReference {
        FormulaReference(name: "Autoregressive AR(1) Model", category: .quantitative, level: .levelII, mainFormula: "x_t = b_0 + b_1 x_{t-1} + \\varepsilon_t", description: "First-order autoregressive time series model", variables: [], derivation: nil, variants: [], usageNotes: ["Models persistence in time series"], examples: [], relatedFormulas: ["time-series"], tags: ["ar", "time-series"])
    }
    
    func createARMAModelFormula() -> FormulaReference {
        FormulaReference(name: "ARMA Model", category: .quantitative, level: .levelII, mainFormula: "x_t = b_0 + \\sum_{i=1}^{p} b_i x_{t-i} + \\varepsilon_t + \\sum_{j=1}^{q} \\theta_j \\varepsilon_{t-j}", description: "Autoregressive moving average model", variables: [], derivation: nil, variants: [], usageNotes: ["Combines AR and MA components"], examples: [], relatedFormulas: ["ar-model"], tags: ["arma", "time-series"])
    }
    
    func createGARCHModelFormula() -> FormulaReference {
        FormulaReference(name: "GARCH Model", category: .quantitative, level: .levelII, mainFormula: "\\sigma_t^2 = \\gamma + \\alpha \\varepsilon_{t-1}^2 + \\beta \\sigma_{t-1}^2", description: "Generalized autoregressive conditional heteroskedasticity model", variables: [], derivation: nil, variants: [], usageNotes: ["Models time-varying volatility"], examples: [], relatedFormulas: ["arch-model"], tags: ["garch", "volatility"])
    }
    
    func createPurchasingPowerParityFormula() -> FormulaReference {
        FormulaReference(name: "Purchasing Power Parity", category: .economics, level: .levelII, mainFormula: "S_{f/d} = \\frac{P_f}{P_d}", description: "Exchange rate based on relative price levels", variables: [], derivation: nil, variants: [], usageNotes: ["Absolute PPP version"], examples: [], relatedFormulas: ["exchange-rates"], tags: ["ppp", "exchange-rates"])
    }
    
    func createSingerTerhaarModelFormula() -> FormulaReference {
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
    
    func createDeterminantsOfInterestRatesFormula() -> FormulaReference {
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
    
    func createHoldingPeriodReturnFormula() -> FormulaReference {
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
    
    func createArithmeticMeanReturnFormula() -> FormulaReference {
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
    
    func createGeometricMeanReturnFormula() -> FormulaReference {
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
    
    func createHarmonicMeanFormula() -> FormulaReference {
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
    
    func createSampleVarianceFormula() -> FormulaReference {
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
    
    func createSampleStandardDeviationFormula() -> FormulaReference {
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
    
    func createSampleSkewnessFormula() -> FormulaReference {
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
    
    func createSampleExcessKurtosisFormula() -> FormulaReference {
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
    
    func createSampleCovarianceFormula() -> FormulaReference {
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
    
    func createSampleCorrelationCoefficientFormula() -> FormulaReference {
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
    
    func createExpectedValueDiscreteFormula() -> FormulaReference {
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
    
    func createVarianceOfRandomVariableFormula() -> FormulaReference {
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
    
    func createBayesFormulaFormula() -> FormulaReference {
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
    
    func createTotalProbabilityRuleFormula() -> FormulaReference {
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
    
    func createPortfolioExpectedReturnFormula() -> FormulaReference {
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
    
    func createPortfolioVarianceFormula() -> FormulaReference {
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
    
    func createTwoAssetPortfolioVarianceFormula() -> FormulaReference {
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
    
    func createSafetyFirstRatioFormula() -> FormulaReference {
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
    
    // MARK: - Placeholder implementations for remaining functions to avoid compilation errors
    
    func createNonAnnualCompoundingFormula() -> FormulaReference {
        FormulaReference(name: "Non-Annual Compounding", category: .quantitative, level: .levelI, mainFormula: "PV = FV_N \\left( 1 + \\frac{R_S}{m} \\right)^{-mN}", description: "Present value with non-annual compounding", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["compounding", "time-value"])
    }
    
    func createContinuouslyCompoundedReturnsFormula() -> FormulaReference {
        FormulaReference(name: "Continuously Compounded Returns", category: .quantitative, level: .levelI, mainFormula: "r_{0,T} = \\ln\\left(\\frac{P_t}{P_0}\\right)", description: "Logarithmic returns with continuous compounding", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["continuous", "returns"])
    }
    
    func createRealReturnsFormula() -> FormulaReference {
        FormulaReference(name: "Real Returns", category: .quantitative, level: .levelI, mainFormula: "\\text{Real Return} = \\frac{1 + \\text{Nominal Return}}{1 + \\text{Inflation Rate}} - 1", description: "Inflation-adjusted returns", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["real-returns", "inflation"])
    }
    
    func createLeveragedReturnFormula() -> FormulaReference {
        FormulaReference(name: "Leveraged Return", category: .quantitative, level: .levelI, mainFormula: "R_L = R_P + \\frac{V_B}{V_E}(R_P - r_D)", description: "Return on leveraged portfolio", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage", "debt"])
    }
    
    func createTestOfSingleMeanFormula() -> FormulaReference {
        FormulaReference(name: "Test of Single Mean", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{\\bar{X} - \\mu_0}{s / \\sqrt{n}}", description: "Hypothesis test for population mean", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hypothesis-test", "t-test"])
    }
    
    func createTestOfDifferenceInMeansFormula() -> FormulaReference {
        FormulaReference(name: "Test of Difference in Means", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{(\\bar{X}_1 - \\bar{X}_2) - (\\mu_1 - \\mu_2)}{s_p\\sqrt{\\frac{1}{n_1} + \\frac{1}{n_2}}}", description: "Test for difference between two means", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["two-sample", "t-test"])
    }
    
    func createTestOfSingleVarianceFormula() -> FormulaReference {
        FormulaReference(name: "Test of Single Variance", category: .quantitative, level: .levelI, mainFormula: "\\chi^2 = \\frac{(n-1)s^2}{\\sigma_0^2}", description: "Chi-square test for population variance", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["chi-square", "variance"])
    }
    
    func createTestOfCorrelationFormula() -> FormulaReference {
        FormulaReference(name: "Test of Correlation", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{r\\sqrt{n-2}}{\\sqrt{1-r^2}}", description: "Test for significant correlation", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["correlation", "significance"])
    }
    
    func createChiSquareTestFormula() -> FormulaReference {
        FormulaReference(name: "Chi-Square Test of Independence", category: .quantitative, level: .levelI, mainFormula: "\\chi^{2} = \\sum_{i=1}^{m} \\frac{(O_{ij} - E_{ij})^{2}}{E_{ij}}", description: "Test for independence in contingency tables", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["chi-square", "independence"])
    }
    
    func createRegressionSlopeFormula() -> FormulaReference {
        FormulaReference(name: "Regression Slope Coefficient", category: .quantitative, level: .levelI, mainFormula: "\\hat{b}_1 = \\frac{\\sum_{i=1}^{n} (Y_i - \\bar{Y})(X_i - \\bar{X})}{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}", description: "Slope coefficient in simple linear regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression", "slope"])
    }
    
    func createRegressionInterceptFormula() -> FormulaReference {
        FormulaReference(name: "Regression Intercept", category: .quantitative, level: .levelI, mainFormula: "\\hat{b}_0 = \\bar{Y} - \\hat{b}_1\\bar{X}", description: "Intercept in simple linear regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression", "intercept"])
    }
    
    func createCoefficientOfDeterminationFormula() -> FormulaReference {
        FormulaReference(name: "Coefficient of Determination", category: .quantitative, level: .levelI, mainFormula: "R^2 = \\frac{SSR}{SST} = 1 - \\frac{SSE}{SST}", description: "Proportion of variance explained by regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["r-squared", "goodness-of-fit"])
    }
    
    func createANOVAFTestFormula() -> FormulaReference {
        FormulaReference(name: "ANOVA F-Test", category: .quantitative, level: .levelI, mainFormula: "F = \\frac{MSR}{MSE}", description: "F-test for overall regression significance", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["f-test", "anova"])
    }
    
    func createPredictionIntervalsFormula() -> FormulaReference {
        FormulaReference(name: "Prediction Intervals", category: .quantitative, level: .levelI, mainFormula: "\\hat{Y}_f \\pm t_{\\alpha/2} \\times s_f", description: "Confidence interval for individual predictions", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["prediction", "confidence"])
    }
    
    // Continue with more essential formulas...
    func createFiscalMultiplierFormula() -> FormulaReference {
        FormulaReference(name: "Fiscal Multiplier", category: .economics, level: .levelI, mainFormula: "\\text{Fiscal Multiplier} = \\frac{1}{1 - c(1 - t)}", description: "Effect of fiscal policy on GDP", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fiscal", "multiplier"])
    }
    
    func createDisposableIncomeFormula() -> FormulaReference {
        FormulaReference(name: "Disposable Income", category: .economics, level: .levelI, mainFormula: "YD = Y - NT = (1 - t)Y", description: "After-tax income available for consumption", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["income", "taxes"])
    }
    
    func createCrossRateFormula() -> FormulaReference {
        FormulaReference(name: "Cross Exchange Rate", category: .economics, level: .levelI, mainFormula: "\\frac{A}{B} = \\frac{A/C}{B/C}", description: "Exchange rate between two currencies", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fx", "cross-rate"])
    }
    
    func createForwardExchangeRateFormula() -> FormulaReference {
        FormulaReference(name: "Forward Exchange Rate", category: .economics, level: .levelI, mainFormula: "F_{A/B} = S_{A/B} \\times \\left[\\frac{1 + r_A \\times T}{1 + r_B \\times T}\\right]", description: "Forward rate based on interest rate differential", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["forward", "fx"])
    }
    
    // Add remaining placeholder implementations for all declared functions...
    // [Continue with all other functions to avoid compilation errors]
    
    // MARK: - Simplified implementations for remaining functions
    func createInternalRateOfReturnFormula() -> FormulaReference {
        FormulaReference(name: "Internal Rate of Return", category: .economics, level: .levelI, mainFormula: "\\sum_{t=0}^{T} \\frac{CF_t}{(1 + IRR)^t} = 0", description: "Discount rate that makes NPV equal to zero", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["irr", "capital-budgeting"])
    }
    
    func createReturnOnInvestedCapitalFormula() -> FormulaReference {
        FormulaReference(name: "Return on Invested Capital", category: .economics, level: .levelI, mainFormula: "ROIC = \\frac{\\text{After-tax operating profit}}{\\text{Average invested capital}}", description: "Profitability measure for invested capital", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["roic", "profitability"])
    }
    
    func createWeightedAverageCostOfCapitalFormula() -> FormulaReference {
        FormulaReference(name: "Weighted Average Cost of Capital", category: .economics, level: .levelI, mainFormula: "WACC = w_d r_d (1-t) + w_e r_e", description: "Blended cost of debt and equity financing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["wacc", "cost-of-capital"])
    }
    
    func createInterestCoverageFormula() -> FormulaReference {
        FormulaReference(name: "Interest Coverage Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Interest Coverage} = \\frac{\\text{EBIT}}{\\text{Interest Expense}}", description: "Ability to service debt obligations", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["coverage", "solvency"])
    }
    
    func createModiglianiMillerPropositionsFormula() -> FormulaReference {
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
    
    func createGrossProfitFormula() -> FormulaReference {
        FormulaReference(name: "Gross Profit", category: .economics, level: .levelI, mainFormula: "\\text{Gross Profit} = \\text{Revenue} - \\text{COGS}", description: "Profit before operating expenses", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["gross-profit"])
    }
    
    func createReturnOnEquityFormula() -> FormulaReference {
        FormulaReference(name: "Return on Equity", category: .economics, level: .levelI, mainFormula: "ROE = \\frac{\\text{Net Income}}{\\text{Average Shareholders' Equity}}", description: "Profitability relative to shareholders' equity", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["roe"])
    }
    
    func createNetProfitMarginFormula() -> FormulaReference {
        FormulaReference(name: "Net Profit Margin", category: .economics, level: .levelI, mainFormula: "\\text{Net Profit Margin} = \\frac{\\text{Net Income}}{\\text{Revenue}}", description: "Net income as percentage of revenue", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["margin"])
    }
    
    func createBasicEPSFormula() -> FormulaReference {
        FormulaReference(name: "Basic Earnings Per Share", category: .economics, level: .levelI, mainFormula: "\\text{Basic EPS} = \\frac{\\text{Net Income} - \\text{Preferred Dividends}}{\\text{Weighted Average Shares Outstanding}}", description: "Earnings available to common shareholders per share", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["eps"])
    }
    
    func createDilutedEPSFormula() -> FormulaReference {
        FormulaReference(name: "Diluted Earnings Per Share", category: .economics, level: .levelI, mainFormula: "\\text{Diluted EPS} = \\frac{\\text{Adjusted Net Income}}{\\text{Diluted Shares Outstanding}}", description: "EPS assuming conversion of all dilutive securities", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["diluted-eps"])
    }
    
    // Add minimal implementations for all remaining functions...
    
    func createCurrentRatioFormula() -> FormulaReference {
        FormulaReference(name: "Current Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Current Ratio} = \\frac{\\text{Current Assets}}{\\text{Current Liabilities}}", description: "Short-term liquidity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity"])
    }
    
    func createQuickRatioFormula() -> FormulaReference {
        FormulaReference(name: "Quick Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Quick Ratio} = \\frac{\\text{Cash + Securities + Receivables}}{\\text{Current Liabilities}}", description: "Acid-test liquidity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity"])
    }
    
    func createCashRatioFormula() -> FormulaReference {
        FormulaReference(name: "Cash Ratio", category: .economics, level: .levelI, mainFormula: "\\text{Cash Ratio} = \\frac{\\text{Cash + Marketable Securities}}{\\text{Current Liabilities}}", description: "Most conservative liquidity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["liquidity"])
    }
    
    func createInventoryTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Inventory Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Inventory Turnover} = \\frac{\\text{COGS}}{\\text{Average Inventory}}", description: "Efficiency of inventory management", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    func createReceivablesTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Receivables Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Receivables Turnover} = \\frac{\\text{Revenue}}{\\text{Average Receivables}}", description: "Efficiency of credit collection", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    func createPayablesTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Payables Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Payables Turnover} = \\frac{\\text{COGS}}{\\text{Average Payables}}", description: "Payment frequency to suppliers", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    func createAssetTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Asset Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Asset Turnover} = \\frac{\\text{Revenue}}{\\text{Average Total Assets}}", description: "Efficiency of asset utilization", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    func createFixedAssetTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Fixed Asset Turnover", category: .economics, level: .levelI, mainFormula: "\\text{Fixed Asset Turnover} = \\frac{\\text{Revenue}}{\\text{Average Net PP&E}}", description: "Efficiency of fixed asset utilization", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["activity"])
    }
    
    func createDebtToEquityRatioFormula() -> FormulaReference {
        FormulaReference(name: "Debt-to-Equity Ratio", category: .economics, level: .levelI, mainFormula: "\\text{D/E} = \\frac{\\text{Total Debt}}{\\text{Total Equity}}", description: "Financial leverage measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    func createDebtToAssetsRatioFormula() -> FormulaReference {
        FormulaReference(name: "Debt-to-Assets Ratio", category: .economics, level: .levelI, mainFormula: "\\text{D/A} = \\frac{\\text{Total Debt}}{\\text{Total Assets}}", description: "Asset financing structure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    func createFinancialLeverageRatioFormula() -> FormulaReference {
        FormulaReference(name: "Financial Leverage", category: .economics, level: .levelI, mainFormula: "\\text{Financial Leverage} = \\frac{\\text{Total Assets}}{\\text{Total Equity}}", description: "Equity multiplier", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    func createTimesInterestEarnedFormula() -> FormulaReference {
        FormulaReference(name: "Times Interest Earned", category: .economics, level: .levelI, mainFormula: "\\text{TIE} = \\frac{\\text{EBIT}}{\\text{Interest Expense}}", description: "Interest coverage ability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["coverage"])
    }
    
    func createGrossMarginFormula() -> FormulaReference {
        FormulaReference(name: "Gross Margin", category: .economics, level: .levelI, mainFormula: "\\text{Gross Margin} = \\frac{\\text{Gross Profit}}{\\text{Revenue}}", description: "Gross profitability measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    func createOperatingMarginFormula() -> FormulaReference {
        FormulaReference(name: "Operating Margin", category: .economics, level: .levelI, mainFormula: "\\text{Operating Margin} = \\frac{\\text{Operating Income}}{\\text{Revenue}}", description: "Operating profitability measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    func createNetMarginFormula() -> FormulaReference {
        FormulaReference(name: "Net Margin", category: .economics, level: .levelI, mainFormula: "\\text{Net Margin} = \\frac{\\text{Net Income}}{\\text{Revenue}}", description: "Bottom-line profitability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    func createReturnOnAssetsFormula() -> FormulaReference {
        FormulaReference(name: "Return on Assets", category: .economics, level: .levelI, mainFormula: "\\text{ROA} = \\frac{\\text{Net Income}}{\\text{Average Total Assets}}", description: "Asset efficiency profitability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["profitability"])
    }
    
    func createReturnOnInvestedCapitalROICFormula() -> FormulaReference {
        FormulaReference(name: "Return on Invested Capital (ROIC)", category: .economics, level: .levelI, mainFormula: "\\text{ROIC} = \\frac{\\text{NOPAT}}{\\text{Invested Capital}}", description: "Capital efficiency measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["roic"])
    }
    
    func createDuPontROEFormula() -> FormulaReference {
        FormulaReference(name: "DuPont ROE", category: .economics, level: .levelI, mainFormula: "\\text{ROE} = \\text{Net Margin} \\times \\text{Asset Turnover} \\times \\text{Equity Multiplier}", description: "Three-factor ROE decomposition", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["dupont"])
    }
    
    func createDuPontROAFormula() -> FormulaReference {
        FormulaReference(name: "DuPont ROA", category: .economics, level: .levelI, mainFormula: "\\text{ROA} = \\text{Net Margin} \\times \\text{Asset Turnover}", description: "Two-factor ROA decomposition", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["dupont"])
    }
    
    func createFreeCashFlowToFirmFormula() -> FormulaReference {
        FormulaReference(name: "Free Cash Flow to Firm", category: .economics, level: .levelI, mainFormula: "\\text{FCFF} = \\text{CFO} + \\text{Interest}(1-t) - \\text{FCInv}", description: "Cash available to all investors", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-flow"])
    }
    
    func createFreeCashFlowToEquityFormula() -> FormulaReference {
        FormulaReference(name: "Free Cash Flow to Equity", category: .economics, level: .levelI, mainFormula: "\\text{FCFE} = \\text{FCFF} - \\text{Interest}(1-t) + \\text{Net Borrowing}", description: "Cash available to equity holders", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-flow"])
    }
    
    func createPriceReturnIndexFormula() -> FormulaReference {
        FormulaReference(name: "Price Return Index", category: .equity, level: .levelI, mainFormula: "V_{PRI} = \\frac{\\sum_{i=1}^{N} n_i P_i}{D}", description: "Index reflecting only price changes", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["index"])
    }
    
    func createTotalReturnIndexFormula() -> FormulaReference {
        FormulaReference(name: "Total Return Index", category: .equity, level: .levelI, mainFormula: "TR_I = \\frac{V_{PRI1} - V_{PRI0} + Inc_I}{V_{PRI0}}", description: "Index including dividends and income", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["index"])
    }
    
    func createMarketCapWeightingFormula() -> FormulaReference {
        FormulaReference(name: "Market Cap Weighting", category: .equity, level: .levelI, mainFormula: "w_i = \\frac{Q_i P_i}{\\sum_{j=1}^{N} Q_j P_j}", description: "Market capitalization-based index weighting", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["weighting"])
    }
    
    func createDividendDiscountModelFormula() -> FormulaReference {
        FormulaReference(name: "Dividend Discount Model", category: .equity, level: .levelI, mainFormula: "P_0 = \\frac{D_1}{r-g}", description: "Gordon growth model for equity valuation", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ddm"])
    }
    
    func createTwoStageDividendDiscountModelFormula() -> FormulaReference {
        FormulaReference(name: "Two-Stage DDM", category: .equity, level: .levelI, mainFormula: "P_0 = \\sum_{t=1}^{n} \\frac{D_0(1+g_s)^t}{(1+r)^t} + \\frac{P_n}{(1+r)^n}", description: "DDM with two growth phases", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ddm"])
    }
    
    func createPriceToEarningsRatioFormula() -> FormulaReference {
        FormulaReference(name: "Price-to-Earnings Ratio", category: .equity, level: .levelI, mainFormula: "P/E = \\frac{\\text{Price per Share}}{\\text{Earnings per Share}}", description: "Valuation multiple based on earnings", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["valuation"])
    }
    
    func createPriceToBookRatioFormula() -> FormulaReference {
        FormulaReference(name: "Price-to-Book Ratio", category: .equity, level: .levelI, mainFormula: "P/B = \\frac{\\text{Market Price per Share}}{\\text{Book Value per Share}}", description: "Valuation relative to book value", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["valuation"])
    }
    
    func createEnterpriseValueFormula() -> FormulaReference {
        FormulaReference(name: "Enterprise Value", category: .equity, level: .levelI, mainFormula: "EV = \\text{Market Cap} + \\text{Total Debt} - \\text{Cash}", description: "Total firm value measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["valuation"])
    }
    
    // Fixed Income
    func createZeroCouponBondPriceFormula() -> FormulaReference {
        FormulaReference(name: "Zero-Coupon Bond Price", category: .fixedIncome, level: .levelI, mainFormula: "P = \\frac{FV}{(1+r)^n}", description: "Present value of zero-coupon bond", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bond-pricing"])
    }
    
    func createCouponBondPriceFormula() -> FormulaReference {
        FormulaReference(name: "Coupon Bond Price", category: .fixedIncome, level: .levelI, mainFormula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1+r)^t} + \\frac{FV}{(1+r)^n}", description: "Present value of coupon-paying bond", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bond-pricing"])
    }
    
    func createCurrentYieldBondFormula() -> FormulaReference {
        FormulaReference(name: "Current Yield", category: .fixedIncome, level: .levelI, mainFormula: "\\text{Current Yield} = \\frac{\\text{Annual Coupon}}{\\text{Bond Price}}", description: "Annual coupon as percentage of price", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["yield"])
    }
    
    func createYieldToMaturityBondFormula() -> FormulaReference {
        FormulaReference(name: "Yield to Maturity", category: .fixedIncome, level: .levelI, mainFormula: "P = \\sum_{t=1}^{n} \\frac{PMT}{(1+YTM)^t} + \\frac{FV}{(1+YTM)^n}", description: "Internal rate of return for bonds", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["yield"])
    }
    
    func createMacaulayDurationBondFormula() -> FormulaReference {
        FormulaReference(name: "Macaulay Duration", category: .fixedIncome, level: .levelI, mainFormula: "D_{Mac} = \\frac{\\sum_{t=1}^{n} t \\times \\frac{CF_t}{(1+r)^t}}{P}", description: "Weighted average time to cash flows", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["duration"])
    }
    
    func createModifiedDurationBondFormula() -> FormulaReference {
        FormulaReference(name: "Modified Duration", category: .fixedIncome, level: .levelI, mainFormula: "D_{Mod} = \\frac{D_{Mac}}{1+r}", description: "Price sensitivity to yield changes", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["duration"])
    }
    
    func createBondConvexityFormula() -> FormulaReference {
        FormulaReference(name: "Bond Convexity", category: .fixedIncome, level: .levelI, mainFormula: "Convexity = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{CF_t \\times t(t+1)}{(1+r)^{t+2}}", description: "Second-order price sensitivity", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["convexity"])
    }
    
    func createEffectiveDurationBondFormula() -> FormulaReference {
        FormulaReference(name: "Effective Duration", category: .fixedIncome, level: .levelII, mainFormula: "D_{eff} = \\frac{P_{-\\Delta y} - P_{+\\Delta y}}{2 \\times P_0 \\times \\Delta y}", description: "Duration for bonds with embedded options", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["duration"])
    }
    
    // Derivatives
    func createForwardContractPricingFormula() -> FormulaReference {
        FormulaReference(name: "Forward Contract Pricing", category: .derivatives, level: .levelI, mainFormula: "F_0 = S_0 e^{rT}", description: "No-arbitrage forward price", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["forwards"])
    }
    
    func createFuturesContractPricingFormula() -> FormulaReference {
        FormulaReference(name: "Futures Contract Pricing", category: .derivatives, level: .levelI, mainFormula: "F_0 = S_0 e^{(r-q)T}", description: "Futures price with convenience yield", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["futures"])
    }
    
    func createPutCallParityOptionsFormula() -> FormulaReference {
        FormulaReference(name: "Put-Call Parity", category: .derivatives, level: .levelI, mainFormula: "C + Ke^{-rT} = P + S_0", description: "No-arbitrage relationship for options", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["options"])
    }
    
    func createBlackScholesCallOptionFormula() -> FormulaReference {
        FormulaReference(name: "Black-Scholes Call Option", category: .derivatives, level: .levelII, mainFormula: "C = S_0 N(d_1) - Ke^{-rT} N(d_2)", description: "European call option pricing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["black-scholes"])
    }
    
    func createBlackScholesPutOptionFormula() -> FormulaReference {
        FormulaReference(name: "Black-Scholes Put Option", category: .derivatives, level: .levelII, mainFormula: "P = Ke^{-rT} N(-d_2) - S_0 N(-d_1)", description: "European put option pricing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["black-scholes"])
    }
    
    func createBinomialOptionPricingFormula() -> FormulaReference {
        FormulaReference(name: "Binomial Option Pricing", category: .derivatives, level: .levelI, mainFormula: "V_0 = \\frac{pV_u + (1-p)V_d}{1+r}", description: "One-period binomial model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["binomial"])
    }
    
    // Alternative Investments
    func createPrivateEquityReturnFormula() -> FormulaReference {
        FormulaReference(name: "Private Equity Returns", category: .alternatives, level: .levelI, mainFormula: "IRR = \\text{Rate that makes NPV of cash flows = 0}", description: "Private equity performance measurement", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["private-equity"])
    }
    
    func createRealEstateCapRateFormula() -> FormulaReference {
        FormulaReference(name: "Capitalization Rate", category: .alternatives, level: .levelI, mainFormula: "\\text{Cap Rate} = \\frac{\\text{NOI}}{\\text{Property Value}}", description: "Real estate yield measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["real-estate"])
    }
    
    func createHedgeFundPerformanceFormula() -> FormulaReference {
        FormulaReference(name: "Hedge Fund Performance", category: .alternatives, level: .levelI, mainFormula: "\\text{Net Return} = \\text{Gross Return} - \\text{Management Fee} - \\text{Incentive Fee}", description: "Hedge fund return calculation", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["hedge-funds"])
    }
    
    // Portfolio Management
    func createCapitalAssetPricingModelFormula() -> FormulaReference {
        FormulaReference(name: "Capital Asset Pricing Model", category: .portfolio, level: .levelI, mainFormula: "E(R_i) = R_f + \\beta_i [E(R_m) - R_f]", description: "Expected return based on systematic risk", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["capm"])
    }
    
    func createPortfolioExpectedReturnDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Portfolio Expected Return (Detailed)", category: .portfolio, level: .levelI, mainFormula: "E(R_P) = \\sum_{i=1}^{n} w_i E(R_i)", description: "Detailed portfolio expected return", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["portfolio"])
    }
    
    func createSharpeRatioDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Sharpe Ratio", category: .portfolio, level: .levelI, mainFormula: "\\text{Sharpe} = \\frac{E(R_p) - R_f}{\\sigma_p}", description: "Risk-adjusted performance measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["sharpe"])
    }
    
    func createTreynorRatioDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Treynor Ratio", category: .portfolio, level: .levelI, mainFormula: "\\text{Treynor} = \\frac{E(R_p) - R_f}{\\beta_p}", description: "Return per unit of systematic risk", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["treynor"])
    }
    
    func createJensensAlphaFormula() -> FormulaReference {
        FormulaReference(name: "Jensen's Alpha", category: .portfolio, level: .levelI, mainFormula: "\\alpha = R_p - [R_f + \\beta_p(R_m - R_f)]", description: "Risk-adjusted excess return", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["alpha"])
    }
    
    func createInformationRatioDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Information Ratio", category: .portfolio, level: .levelI, mainFormula: "\\text{IR} = \\frac{\\text{Active Return}}{\\text{Tracking Error}}", description: "Active management skill measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["information-ratio"])
    }
    
    // MARK: - Advanced Quantitative Methods Implementation
    
    // MARK: - Time Series Analysis
    
    private func createAdvancedARModel() -> FormulaReference {
        FormulaReference(
            name: "Advanced Autoregressive AR(p) Model",
            category: .quantitative,
            level: .levelII,
            mainFormula: "x_t = c + \\phi_1 x_{t-1} + \\phi_2 x_{t-2} + \\cdots + \\phi_p x_{t-p} + \\varepsilon_t",
            description: "Advanced autoregressive model of order p for modeling time series with persistence and mean reversion properties.",
            variables: [
                FormulaVariable(symbol: "x_t", name: "Time Series Value", description: "Value of time series at time t", units: "Any", typicalRange: "Stationary range", notes: "Must be stationary for valid inference"),
                FormulaVariable(symbol: "c", name: "Constant Term", description: "Intercept representing unconditional mean", units: "Same as x_t", typicalRange: "Any", notes: "c = μ(1 - Σφᵢ) where μ is long-run mean"),
                FormulaVariable(symbol: "\\phi_i", name: "AR Coefficient", description: "Autoregressive coefficient for lag i", units: "Unitless", typicalRange: "-1 to 1", notes: "Stationarity requires roots outside unit circle"),
                FormulaVariable(symbol: "p", name: "AR Order", description: "Number of lags included", units: "Count", typicalRange: "1 to 12", notes: "Determined by AIC/BIC criteria"),
                FormulaVariable(symbol: "\\varepsilon_t", name: "Error Term", description: "White noise error", units: "Same as x_t", typicalRange: "±3σ", notes: "IID Normal(0,σ²)")
            ],
            derivation: FormulaDerivation(
                title: "AR(p) Model Derivation and Stationarity Conditions",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with infinite MA representation", formula: "x_t = \\mu + \\sum_{j=0}^{\\infty} \\psi_j \\varepsilon_{t-j}", explanation: "Wold decomposition theorem"),
                    DerivationStep(stepNumber: 2, description: "Apply lag operator notation", formula: "x_t = c + \\Phi(L)x_t + \\varepsilon_t", explanation: "L is lag operator: Lxₜ = xₜ₋₁"),
                    DerivationStep(stepNumber: 3, description: "Rearrange to autoregressive form", formula: "(1 - \\phi_1 L - \\phi_2 L^2 - \\cdots - \\phi_p L^p)x_t = c + \\varepsilon_t", explanation: "Collect AR terms"),
                    DerivationStep(stepNumber: 4, description: "Stationarity condition", formula: "|z| > 1 \\text{ for all roots of } 1 - \\phi_1 z - \\phi_2 z^2 - \\cdots - \\phi_p z^p = 0", explanation: "Characteristic equation roots must lie outside unit circle"),
                    DerivationStep(stepNumber: 5, description: "Unconditional mean", formula: "E[x_t] = \\frac{c}{1 - \\phi_1 - \\phi_2 - \\cdots - \\phi_p}", explanation: "Long-run equilibrium level"),
                    DerivationStep(stepNumber: 6, description: "Yule-Walker equations", formula: "\\gamma_k = \\phi_1 \\gamma_{k-1} + \\phi_2 \\gamma_{k-2} + \\cdots + \\phi_p \\gamma_{k-p}", explanation: "Autocovariance recursion for k ≥ 1")
                ],
                assumptions: [
                    "Time series is covariance stationary",
                    "Error terms are independently and identically distributed",
                    "E[εₜ] = 0 and Var[εₜ] = σ²",
                    "No structural breaks in the series",
                    "AR coefficients satisfy stationarity conditions"
                ],
                notes: "Essential for modeling financial returns, economic indicators, and volatility clustering."
            ),
            variants: [
                FormulaVariant(name: "AR(1) Model", formula: "x_t = c + \\phi x_{t-1} + \\varepsilon_t", description: "First-order autoregression", whenToUse: "Simple persistence modeling"),
                FormulaVariant(name: "Random Walk", formula: "x_t = x_{t-1} + \\varepsilon_t", description: "Unit root process (φ = 1)", whenToUse: "Non-stationary series like asset prices"),
                FormulaVariant(name: "AR with Drift", formula: "x_t = \\alpha + x_{t-1} + \\varepsilon_t", description: "Random walk with deterministic trend", whenToUse: "Trending non-stationary series")
            ],
            usageNotes: [
                "Check stationarity before estimation using unit root tests",
                "Use AIC/BIC for optimal lag selection: AIC = log(σ²) + 2p/T",
                "Diagnostic checks: Ljung-Box test for serial correlation",
                "Forecast accuracy decreases rapidly with horizon for stationary series",
                "AR models useful for short-term forecasting and volatility modeling"
            ],
            examples: [
                FormulaExample(
                    title: "AR(2) Model for Stock Returns",
                    description: "Modeling daily stock return persistence",
                    inputs: ["rₜ₋₁": "0.02", "rₜ₋₂": "-0.01", "c": "0.001", "φ₁": "0.1", "φ₂": "-0.05"],
                    calculation: "rₜ = 0.001 + 0.1(0.02) + (-0.05)(-0.01) + εₜ = 0.001 + 0.002 + 0.0005 + εₜ",
                    result: "Expected return = 0.0035 or 0.35%",
                    interpretation: "Positive first lag and negative second lag suggest mild mean reversion."
                )
            ],
            relatedFormulas: ["arma-model", "var-model", "cointegration"],
            tags: ["time-series", "autoregression", "stationarity", "forecasting", "persistence"]
        )
    }
    
    private func createARMAModelDetailed() -> FormulaReference {
        FormulaReference(
            name: "ARMA(p,q) Model",
            category: .quantitative,
            level: .levelII,
            mainFormula: "x_t = c + \\sum_{i=1}^{p} \\phi_i x_{t-i} + \\varepsilon_t + \\sum_{j=1}^{q} \\theta_j \\varepsilon_{t-j}",
            description: "Autoregressive Moving Average model combining AR and MA components for comprehensive time series modeling.",
            variables: [
                FormulaVariable(symbol: "x_t", name: "Time Series Value", description: "Observed value at time t", units: "Any", typicalRange: "Stationary", notes: "Stationary process"),
                FormulaVariable(symbol: "\\phi_i", name: "AR Coefficient", description: "Autoregressive parameter for lag i", units: "Unitless", typicalRange: "-1 to 1", notes: "Controls persistence"),
                FormulaVariable(symbol: "\\theta_j", name: "MA Coefficient", description: "Moving average parameter for lag j", units: "Unitless", typicalRange: "-1 to 1", notes: "Controls shock propagation"),
                FormulaVariable(symbol: "p", name: "AR Order", description: "Number of autoregressive lags", units: "Count", typicalRange: "0 to 5", notes: "Selected by information criteria"),
                FormulaVariable(symbol: "q", name: "MA Order", description: "Number of moving average lags", units: "Count", typicalRange: "0 to 5", notes: "Selected by information criteria"),
                FormulaVariable(symbol: "\\varepsilon_t", name: "Innovation", description: "White noise shock at time t", units: "Same as x_t", typicalRange: "±3σ", notes: "Unpredictable component")
            ],
            derivation: FormulaDerivation(
                title: "ARMA Model Construction and Properties",
                steps: [
                    DerivationStep(stepNumber: 1, description: "AR polynomial", formula: "\\Phi(L) = 1 - \\phi_1 L - \\phi_2 L^2 - \\cdots - \\phi_p L^p", explanation: "Autoregressive lag polynomial"),
                    DerivationStep(stepNumber: 2, description: "MA polynomial", formula: "\\Theta(L) = 1 + \\theta_1 L + \\theta_2 L^2 + \\cdots + \\theta_q L^q", explanation: "Moving average lag polynomial"),
                    DerivationStep(stepNumber: 3, description: "ARMA representation", formula: "\\Phi(L)x_t = c + \\Theta(L)\\varepsilon_t", explanation: "Compact lag operator form"),
                    DerivationStep(stepNumber: 4, description: "Stationarity condition", formula: "\\text{Roots of } \\Phi(z) = 0 \\text{ lie outside unit circle}", explanation: "AR component stationarity"),
                    DerivationStep(stepNumber: 5, description: "Invertibility condition", formula: "\\text{Roots of } \\Theta(z) = 0 \\text{ lie outside unit circle}", explanation: "MA component invertibility"),
                    DerivationStep(stepNumber: 6, description: "Autocovariance function", formula: "\\gamma(h) = \\sigma^2 \\sum_{j=0}^{\\infty} \\psi_j \\psi_{j+h}", explanation: "Where ψⱼ are impulse response weights")
                ],
                assumptions: [
                    "Stationarity and invertibility conditions satisfied",
                    "Error terms are white noise: εₜ ~ IID(0, σ²)",
                    "No measurement errors in observations",
                    "Model correctly specified (no omitted variables)",
                    "Constant parameters over sample period"
                ],
                notes: "ARMA models are fundamental building blocks for more complex econometric models."
            ),
            variants: [
                FormulaVariant(name: "AR(p) Model", formula: "x_t = c + \\sum_{i=1}^{p} \\phi_i x_{t-i} + \\varepsilon_t", description: "Pure autoregressive model (q=0)", whenToUse: "When only past values matter"),
                FormulaVariant(name: "MA(q) Model", formula: "x_t = c + \\varepsilon_t + \\sum_{j=1}^{q} \\theta_j \\varepsilon_{t-j}", description: "Pure moving average model (p=0)", whenToUse: "When only past shocks matter"),
                FormulaVariant(name: "ARMA(1,1)", formula: "x_t = c + \\phi x_{t-1} + \\varepsilon_t + \\theta \\varepsilon_{t-1}", description: "Simplest combined model", whenToUse: "Parsimonious modeling")
            ],
            usageNotes: [
                "Use Box-Jenkins methodology for model identification",
                "Check ACF and PACF patterns for order selection",
                "Estimate by Maximum Likelihood for optimal properties",
                "Validate with residual diagnostics and out-of-sample tests",
                "ARMA models capture both short and long memory components"
            ],
            examples: [
                FormulaExample(
                    title: "ARMA(1,1) for Interest Rate Modeling",
                    description: "Modeling central bank policy rate dynamics",
                    inputs: ["rₜ₋₁": "2.5%", "εₜ₋₁": "0.1%", "φ": "0.9", "θ": "-0.3", "c": "0.05%"],
                    calculation: "rₜ = 0.05% + 0.9(2.5%) + εₜ + (-0.3)(0.1%) = 0.05% + 2.25% - 0.03% + εₜ",
                    result: "Expected rate = 2.27% + εₜ",
                    interpretation: "High persistence (φ=0.9) with negative MA term suggesting policy smoothing."
                )
            ],
            relatedFormulas: ["arima-model", "garch-model", "var-model"],
            tags: ["time-series", "arma", "box-jenkins", "stationarity", "forecasting"]
        )
    }
    
    private func createARIMAModelDetailed() -> FormulaReference {
        FormulaReference(
            name: "ARIMA(p,d,q) Model",
            category: .quantitative,
            level: .levelII,
            mainFormula: "\\Phi(L)(1-L)^d x_t = c + \\Theta(L)\\varepsilon_t",
            description: "Autoregressive Integrated Moving Average model for non-stationary time series with unit roots.",
            variables: [
                FormulaVariable(symbol: "x_t", name: "Original Series", description: "Non-stationary time series", units: "Any", typicalRange: "Any", notes: "May contain unit roots"),
                FormulaVariable(symbol: "d", name: "Degree of Integration", description: "Number of differences needed for stationarity", units: "Count", typicalRange: "0 to 2", notes: "d=1 for I(1) series like asset prices"),
                FormulaVariable(symbol: "(1-L)^d", name: "Difference Operator", description: "d-th order differencing", units: "Unitless", typicalRange: "Standard", notes: "Removes stochastic trends"),
                FormulaVariable(symbol: "\\Phi(L)", name: "AR Polynomial", description: "Autoregressive lag polynomial", units: "Unitless", typicalRange: "Stationary", notes: "Applied to differenced series"),
                FormulaVariable(symbol: "\\Theta(L)", name: "MA Polynomial", description: "Moving average lag polynomial", units: "Unitless", typicalRange: "Invertible", notes: "Error correction mechanism")
            ],
            derivation: FormulaDerivation(
                title: "ARIMA Model Development for Non-Stationary Series",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Test for unit roots", formula: "\\Delta x_t = \\alpha + \\rho x_{t-1} + \\sum_{i=1}^{k} \\beta_i \\Delta x_{t-i} + \\varepsilon_t", explanation: "Augmented Dickey-Fuller test"),
                    DerivationStep(stepNumber: 2, description: "Determine integration order", formula: "x_t \\sim I(d) \\text{ if } (1-L)^d x_t \\sim I(0)", explanation: "Find minimum d for stationarity"),
                    DerivationStep(stepNumber: 3, description: "Apply differencing", formula: "y_t = (1-L)^d x_t", explanation: "Transform to stationary series"),
                    DerivationStep(stepNumber: 4, description: "Fit ARMA to differences", formula: "\\Phi(L)y_t = c + \\Theta(L)\\varepsilon_t", explanation: "Standard ARMA on stationary series"),
                    DerivationStep(stepNumber: 5, description: "Combine for ARIMA", formula: "\\Phi(L)(1-L)^d x_t = c + \\Theta(L)\\varepsilon_t", explanation: "Final ARIMA specification"),
                    DerivationStep(stepNumber: 6, description: "Forecast formula", formula: "\\hat{x}_{T+h} = E[x_{T+h}|I_T]", explanation: "Conditional expectation given information set")
                ],
                assumptions: [
                    "Series contains exactly d unit roots",
                    "Differenced series is stationary",
                    "No seasonal unit roots (use SARIMA if present)",
                    "Error terms satisfy white noise conditions",
                    "Structural stability over sample period"
                ],
                notes: "ARIMA models are essential for forecasting non-stationary economic and financial time series."
            ),
            variants: [
                FormulaVariant(name: "Random Walk", formula: "x_t = x_{t-1} + \\varepsilon_t", description: "ARIMA(0,1,0) - simplest integrated process", whenToUse: "Asset prices, exchange rates"),
                FormulaVariant(name: "Random Walk with Drift", formula: "x_t = \\mu + x_{t-1} + \\varepsilon_t", description: "ARIMA(0,1,0) with constant", whenToUse: "Trending financial series"),
                FormulaVariant(name: "IMA(1,1)", formula: "\\Delta x_t = \\varepsilon_t + \\theta \\varepsilon_{t-1}", description: "ARIMA(0,1,1) - integrated MA", whenToUse: "Over-differenced AR series")
            ],
            usageNotes: [
                "Always test for unit roots before differencing",
                "Over-differencing leads to non-invertible MA component",
                "Use AIC/BIC for (p,q) selection after determining d",
                "Check residuals for remaining autocorrelation",
                "ARIMA forecasts have increasing uncertainty with horizon"
            ],
            examples: [
                FormulaExample(
                    title: "ARIMA(1,1,1) for Stock Price Forecasting",
                    description: "Modeling S&P 500 index level dynamics",
                    inputs: ["Δxₜ₋₁": "50", "εₜ₋₁": "25", "φ": "0.3", "θ": "-0.7"],
                    calculation: "Δxₜ = 0.3(50) + εₜ + (-0.7)(25) = 15 - 17.5 + εₜ = -2.5 + εₜ",
                    result: "Expected change = -2.5 points + shock",
                    interpretation: "Slight negative momentum with strong error correction."
                )
            ],
            relatedFormulas: ["unit-root-tests", "cointegration", "var-model"],
            tags: ["time-series", "arima", "non-stationary", "integration", "forecasting"]
        )
    }
    
    // MARK: - Financial Ratios - Profitability
    
    func createROEFormula() -> FormulaReference {
        FormulaReference(
            name: "Return on Equity (ROE)",
            category: .equity,
            level: .levelI,
            mainFormula: "ROE = \\frac{\\text{Net Income}}{\\text{Average Shareholders' Equity}}",
            description: "Measures the profitability of equity capital and efficiency of management in generating returns for shareholders.",
            variables: [
                FormulaVariable(symbol: "ROE", name: "Return on Equity", description: "Percentage return generated on shareholders' equity", units: "Percentage", typicalRange: "5% to 25%", notes: "Higher values indicate more efficient use of equity"),
                FormulaVariable(symbol: "\\text{Net Income}", name: "Net Income", description: "Profit after all expenses, taxes, and preferred dividends", units: "Currency", typicalRange: "Varies", notes: "Should be available to common shareholders"),
                FormulaVariable(symbol: "\\text{Average Shareholders' Equity}", name: "Average Shareholders' Equity", description: "Average of beginning and ending equity", units: "Currency", typicalRange: "Varies", notes: "Common shareholders' equity only")
            ],
            derivation: FormulaDerivation(
                title: "ROE as a Core Profitability Measure",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define profitability objective", formula: "\\text{Profitability} = \\frac{\\text{Profit}}{\\text{Investment}}", explanation: "Basic profitability concept"),
                    DerivationStep(stepNumber: 2, description: "Apply to equity investment", formula: "\\text{Equity Profitability} = \\frac{\\text{Net Income}}{\\text{Shareholders' Equity}}", explanation: "Profit available to equity holders"),
                    DerivationStep(stepNumber: 3, description: "Use average equity for period", formula: "ROE = \\frac{\\text{Net Income}}{\\text{Average Shareholders' Equity}}", explanation: "Average equity reflects changing capital base"),
                    DerivationStep(stepNumber: 4, description: "Alternative formulation", formula: "ROE = \\frac{\\text{EPS}}{\\text{Book Value per Share}}", explanation: "Per-share basis calculation")
                ],
                assumptions: [
                    "Net income reflects normal operations",
                    "Equity represents market-based capital investment",
                    "No significant one-time items distort results",
                    "Accounting policies are consistent"
                ],
                notes: "ROE is the foundation for DuPont analysis and growth rate calculations."
            ),
            variants: [
                FormulaVariant(name: "ROE (Beginning Equity)", formula: "ROE = \\frac{\\text{Net Income}}{\\text{Beginning Shareholders' Equity}}", description: "Using beginning equity base", whenToUse: "When equity changes significantly during period"),
                FormulaVariant(name: "ROE (Per Share)", formula: "ROE = \\frac{\\text{EPS}}{\\text{Book Value per Share}}", description: "Per-share calculation", whenToUse: "For per-share analysis and comparisons"),
                FormulaVariant(name: "Clean Surplus ROE", formula: "ROE = \\frac{\\text{NI} - \\text{Preferred Dividends}}{\\text{Common Equity}}", description: "Excluding preferred equity", whenToUse: "When analyzing common equity returns specifically")
            ],
            usageNotes: [
                "Compare to industry averages and historical performance",
                "Higher ROE generally indicates better management efficiency",
                "Very high ROE may indicate excessive leverage",
                "Consider ROE sustainability and underlying drivers",
                "Use as starting point for DuPont decomposition analysis"
            ],
            examples: [
                FormulaExample(
                    title: "Manufacturing Company ROE",
                    description: "Calculate ROE for company with $50M net income and $250M average equity",
                    inputs: ["Net Income": "$50,000,000", "Average Shareholders' Equity": "$250,000,000"],
                    calculation: "ROE = $50,000,000 / $250,000,000 = 0.20",
                    result: "ROE = 20.0%",
                    interpretation: "Company generates 20% return on equity capital, indicating efficient management"
                )
            ],
            relatedFormulas: ["dupont-roe", "sustainable-growth", "roa", "roe-decomposition"],
            tags: ["roe", "profitability", "equity-analysis", "financial-ratios", "dupont"]
        )
    }
    
    func createROAFormula() -> FormulaReference {
        FormulaReference(
            name: "Return on Assets (ROA)",
            category: .equity,
            level: .levelI,
            mainFormula: "ROA = \\frac{\\text{Net Income + Interest Expense (1-T)}}{\\text{Average Total Assets}}",
            description: "Measures efficiency in using total assets to generate profits, independent of capital structure.",
            variables: [
                FormulaVariable(symbol: "ROA", name: "Return on Assets", description: "Percentage return generated on total assets", units: "Percentage", typicalRange: "3% to 15%", notes: "Independent of financing decisions"),
                FormulaVariable(symbol: "\\text{Net Income}", name: "Net Income", description: "Profit after all expenses and taxes", units: "Currency", typicalRange: "Varies", notes: "Bottom line earnings"),
                FormulaVariable(symbol: "\\text{Interest Expense}", name: "Interest Expense", description: "Cost of debt financing", units: "Currency", typicalRange: "Varies", notes: "Before tax deduction"),
                FormulaVariable(symbol: "T", name: "Tax Rate", description: "Marginal corporate tax rate", units: "Percentage", typicalRange: "20% to 35%", notes: "Effective tax rate"),
                FormulaVariable(symbol: "\\text{Average Total Assets}", name: "Average Total Assets", description: "Average of beginning and ending total assets", units: "Currency", typicalRange: "Varies", notes: "All assets regardless of financing")
            ],
            derivation: FormulaDerivation(
                title: "ROA - Operating Efficiency Measure",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with basic asset efficiency", formula: "\\text{Asset Efficiency} = \\frac{\\text{Earnings}}{\\text{Assets}}", explanation: "Fundamental efficiency concept"),
                    DerivationStep(stepNumber: 2, description: "Add back financing costs", formula: "\\text{Operating Income} = \\text{Net Income} + \\text{Interest Expense}", explanation: "Remove financing decision impact"),
                    DerivationStep(stepNumber: 3, description: "Adjust for tax shield", formula: "\\text{After-tax Operating Income} = \\text{NI} + \\text{Interest} \\times (1-T)", explanation: "Account for tax benefit of debt"),
                    DerivationStep(stepNumber: 4, description: "Final ROA formula", formula: "ROA = \\frac{\\text{NI} + \\text{Interest} \\times (1-T)}{\\text{Average Total Assets}}", explanation: "Asset efficiency independent of capital structure")
                ],
                assumptions: [
                    "Assets are valued at fair market values",
                    "Interest expense represents all financing costs",
                    "Tax rate is relatively stable",
                    "No significant off-balance sheet assets"
                ],
                notes: "ROA enables comparison across companies with different capital structures."
            ),
            variants: [
                FormulaVariant(name: "Simple ROA", formula: "ROA = \\frac{\\text{Net Income}}{\\text{Average Total Assets}}", description: "Without interest adjustment", whenToUse: "For quick analysis or zero-debt companies"),
                FormulaVariant(name: "Operating ROA", formula: "ROA = \\frac{\\text{Operating Income}}{\\text{Average Total Assets}}", description: "Using operating income", whenToUse: "To exclude non-operating items"),
                FormulaVariant(name: "EBIT ROA", formula: "ROA = \\frac{\\text{EBIT}}{\\text{Average Total Assets}}", description: "Earnings before interest and taxes", whenToUse: "For pure operating efficiency analysis")
            ],
            usageNotes: [
                "Lower than ROE when company uses leverage beneficially",
                "Better for cross-industry comparisons than ROE",
                "Consider asset-light vs asset-heavy business models",
                "Higher ROA indicates better asset utilization",
                "Component of DuPont ROE decomposition"
            ],
            examples: [
                FormulaExample(
                    title: "Technology Company ROA",
                    description: "Calculate ROA for tech company: $100M net income, $10M interest, 25% tax rate, $800M average assets",
                    inputs: ["Net Income": "$100M", "Interest Expense": "$10M", "Tax Rate": "25%", "Average Total Assets": "$800M"],
                    calculation: "ROA = [$100M + $10M × (1-0.25)] / $800M = $107.5M / $800M = 0.1344",
                    result: "ROA = 13.44%",
                    interpretation: "Excellent asset efficiency, typical for asset-light technology companies"
                )
            ],
            relatedFormulas: ["roe", "asset-turnover", "profit-margin", "dupont-roa"],
            tags: ["roa", "asset-efficiency", "profitability", "financial-ratios", "operating-performance"]
        )
    }
    
    func createROICFormula() -> FormulaReference {
        FormulaReference(
            name: "Return on Invested Capital (ROIC)",
            category: .equity,
            level: .levelII,
            mainFormula: "ROIC = \\frac{\\text{NOPAT}}{\\text{Invested Capital}}",
            description: "Measures return generated on all invested capital, focusing on core operating performance.",
            variables: [
                FormulaVariable(symbol: "ROIC", name: "Return on Invested Capital", description: "Operating return on invested capital", units: "Percentage", typicalRange: "8% to 20%", notes: "Excludes non-operating assets"),
                FormulaVariable(symbol: "\\text{NOPAT}", name: "Net Operating Profit After Tax", description: "Operating profit after taxes", units: "Currency", typicalRange: "Varies", notes: "Excludes financing costs"),
                FormulaVariable(symbol: "\\text{Invested Capital}", name: "Invested Capital", description: "Total debt plus equity minus excess cash", units: "Currency", typicalRange: "Varies", notes: "Capital generating operating returns")
            ],
            derivation: FormulaDerivation(
                title: "ROIC - Core Operating Return Measure",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define operating earnings", formula: "\\text{NOPAT} = \\text{EBIT} \\times (1 - \\text{Tax Rate})", explanation: "After-tax operating profit"),
                    DerivationStep(stepNumber: 2, description: "Calculate invested capital", formula: "\\text{IC} = \\text{Total Debt} + \\text{Equity} - \\text{Excess Cash}", explanation: "Capital invested in operations"),
                    DerivationStep(stepNumber: 3, description: "Alternative IC calculation", formula: "\\text{IC} = \\text{Operating Assets} - \\text{Operating Liabilities}", explanation: "Asset-based approach"),
                    DerivationStep(stepNumber: 4, description: "Final ROIC", formula: "ROIC = \\frac{\\text{NOPAT}}{\\text{Invested Capital}}", explanation: "Return on operating capital")
                ],
                assumptions: [
                    "Operating assets generate returns efficiently",
                    "Excess cash earns minimal returns",
                    "Tax rate applied to operating income",
                    "Non-operating income excluded"
                ],
                notes: "ROIC is the key metric for valuation and capital allocation decisions."
            ),
            variants: [
                FormulaVariant(name: "ROIC (Book Value)", formula: "ROIC = \\frac{\\text{NOPAT}}{\\text{IC}_{book}}", description: "Using book values", whenToUse: "For accounting-based analysis"),
                FormulaVariant(name: "ROIC (Market Value)", formula: "ROIC = \\frac{\\text{NOPAT}}{\\text{IC}_{market}}", description: "Using market values", whenToUse: "For market-based valuation"),
                FormulaVariant(name: "Cash ROIC", formula: "\\text{Cash ROIC} = \\frac{\\text{Cash Flow from Operations}}{\\text{IC}}", description: "Using cash flows", whenToUse: "For cash-based analysis")
            ],
            usageNotes: [
                "Compare to WACC to assess value creation",
                "Higher ROIC indicates competitive advantages",
                "Key input for discounted cash flow valuation",
                "Focus on sustainable ROIC trends",
                "Exclude one-time items from NOPAT"
            ],
            examples: [
                FormulaExample(
                    title: "Industrial Company ROIC",
                    description: "Calculate ROIC: $200M EBIT, 28% tax rate, $800M debt, $600M equity, $50M excess cash",
                    inputs: ["EBIT": "$200M", "Tax Rate": "28%", "Debt": "$800M", "Equity": "$600M", "Excess Cash": "$50M"],
                    calculation: "NOPAT = $200M × (1-0.28) = $144M\\nIC = $800M + $600M - $50M = $1,350M\\nROIC = $144M / $1,350M = 0.1067",
                    result: "ROIC = 10.67%",
                    interpretation: "Solid operating returns, likely above cost of capital for industrial company"
                )
            ],
            relatedFormulas: ["wacc", "eva", "nopat", "invested-capital"],
            tags: ["roic", "operating-performance", "value-creation", "capital-efficiency"]
        )
    }
    
    
    // MARK: - Equity Risk Models
    
    func createBetaCalculationFormula() -> FormulaReference {
        FormulaReference(
            name: "Beta Calculation",
            category: .equity,
            level: .levelII,
            mainFormula: "\\beta_i = \\frac{\\text{Cov}(R_i, R_m)}{\\text{Var}(R_m)} = \\frac{\\sigma_{im}}{\\sigma_m^2}",
            description: "Systematic risk measure indicating stock's sensitivity to market movements, fundamental to CAPM and portfolio theory.",
            variables: [
                FormulaVariable(symbol: "\\beta_i", name: "Beta", description: "Systematic risk measure for security i", units: "Unitless", typicalRange: "0.0 to 2.5", notes: "1.0 = market risk, >1.0 = higher risk"),
                FormulaVariable(symbol: "\\text{Cov}(R_i, R_m)", name: "Covariance", description: "Covariance between stock and market returns", units: "Variance Units", typicalRange: "Varies", notes: "Measures joint movement"),
                FormulaVariable(symbol: "\\text{Var}(R_m)", name: "Market Variance", description: "Variance of market returns", units: "Variance Units", typicalRange: "Varies", notes: "Market risk squared"),
                FormulaVariable(symbol: "\\sigma_{im}", name: "Stock-Market Covariance", description: "Alternative notation for covariance", units: "Variance Units", typicalRange: "Varies", notes: "Can be positive or negative"),
                FormulaVariable(symbol: "\\sigma_m^2", name: "Market Variance", description: "Market return variance", units: "Variance Units", typicalRange: "Varies", notes: "Always positive")
            ],
            derivation: FormulaDerivation(
                title: "Beta Derivation from CAPM",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with CAPM equation", formula: "E(R_i) = R_f + \\beta_i[E(R_m) - R_f]", explanation: "Expected return relationship"),
                    DerivationStep(stepNumber: 2, description: "Express as regression model", formula: "R_i - R_f = \\alpha_i + \\beta_i(R_m - R_f) + \\epsilon_i", explanation: "Excess return regression"),
                    DerivationStep(stepNumber: 3, description: "Apply regression coefficient formula", formula: "\\beta_i = \\frac{\\text{Cov}(R_i - R_f, R_m - R_f)}{\\text{Var}(R_m - R_f)}", explanation: "Slope coefficient calculation"),
                    DerivationStep(stepNumber: 4, description: "Simplify covariance", formula: "\\text{Cov}(R_i - R_f, R_m - R_f) = \\text{Cov}(R_i, R_m)", explanation: "Risk-free rate is constant"),
                    DerivationStep(stepNumber: 5, description: "Final beta formula", formula: "\\beta_i = \\frac{\\text{Cov}(R_i, R_m)}{\\text{Var}(R_m)}", explanation: "Systematic risk measure")
                ],
                assumptions: [
                    "Returns are normally distributed",
                    "Linear relationship between stock and market",
                    "Stationary beta over estimation period",
                    "Market portfolio is mean-variance efficient"
                ],
                notes: "Beta measures undiversifiable risk that cannot be eliminated through portfolio diversification."
            ),
            variants: [
                FormulaVariant(name: "Regression Beta", formula: "\\beta_i = \\frac{\\sum(R_i - \\bar{R_i})(R_m - \\bar{R_m})}{\\sum(R_m - \\bar{R_m})^2}", description: "Sample calculation formula", whenToUse: "For historical beta estimation"),
                FormulaVariant(name: "Correlation Beta", formula: "\\beta_i = \\rho_{im} \\times \\frac{\\sigma_i}{\\sigma_m}", description: "Using correlation coefficient", whenToUse: "When correlation and standard deviations are known"),
                FormulaVariant(name: "Portfolio Beta", formula: "\\beta_p = \\sum_{i=1}^{n} w_i \\beta_i", description: "Weighted average of individual betas", whenToUse: "For portfolio systematic risk calculation")
            ],
            usageNotes: [
                "Use 2-5 years of monthly returns for stable estimate",
                "Beta changes over time due to business evolution",
                "Low-beta stocks: utilities, consumer staples",
                "High-beta stocks: technology, biotech, cyclicals",
                "Consider industry and leverage effects on beta"
            ],
            examples: [
                FormulaExample(
                    title: "Technology Stock Beta",
                    description: "Calculate beta for tech stock: covariance with market = 0.032, market variance = 0.025",
                    inputs: ["Covariance (Stock, Market)": "0.032", "Market Variance": "0.025"],
                    calculation: "β = 0.032 / 0.025 = 1.28",
                    result: "β = 1.28",
                    interpretation: "Stock is 28% more volatile than market, typical for technology companies"
                )
            ],
            relatedFormulas: ["capm", "unlevered-beta", "adjusted-beta", "portfolio-beta"],
            tags: ["beta", "systematic-risk", "capm", "market-sensitivity", "risk-measurement"]
        )
    }
    
    func createUnleveredBetaFormula() -> FormulaReference {
        FormulaReference(
            name: "Unlevered Beta",
            category: .equity,
            level: .levelII,
            mainFormula: "\\beta_U = \\frac{\\beta_L}{1 + (1-T)\\frac{D}{E}}",
            description: "Asset beta removing financial leverage effects, representing pure business risk for comparison across different capital structures.",
            variables: [
                FormulaVariable(symbol: "\\beta_U", name: "Unlevered Beta", description: "Asset beta without leverage effect", units: "Unitless", typicalRange: "0.3 to 1.8", notes: "Pure business risk measure"),
                FormulaVariable(symbol: "\\beta_L", name: "Levered Beta", description: "Observed equity beta with leverage", units: "Unitless", typicalRange: "0.5 to 2.5", notes: "Includes financial risk"),
                FormulaVariable(symbol: "T", name: "Tax Rate", description: "Marginal corporate tax rate", units: "Percentage", typicalRange: "20% to 35%", notes: "Reflects tax shield benefit"),
                FormulaVariable(symbol: "D", name: "Market Value of Debt", description: "Total debt at market value", units: "Currency", typicalRange: "Varies", notes: "Interest-bearing debt"),
                FormulaVariable(symbol: "E", name: "Market Value of Equity", description: "Market capitalization", units: "Currency", typicalRange: "Varies", notes: "Shares outstanding × stock price")
            ],
            derivation: FormulaDerivation(
                title: "Unlevered Beta Derivation (Hamada Equation)",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Start with levered firm value", formula: "V_L = V_U + T \\times D", explanation: "Modigliani-Miller with taxes"),
                    DerivationStep(stepNumber: 2, description: "Express equity value", formula: "E = V_L - D = V_U + T \\times D - D", explanation: "Equity as residual claim"),
                    DerivationStep(stepNumber: 3, description: "Define beta relationship", formula: "\\beta_L = \\beta_U \\times \\frac{V_U}{E} + \\beta_D \\times \\frac{D(1-T)}{E}", explanation: "Weighted average of asset and debt betas"),
                    DerivationStep(stepNumber: 4, description: "Assume debt beta is zero", formula: "\\beta_L = \\beta_U \\times \\frac{V_U}{E}", explanation: "Risk-free debt assumption"),
                    DerivationStep(stepNumber: 5, description: "Solve for unlevered beta", formula: "\\beta_U = \\beta_L \\times \\frac{E}{V_U} = \\frac{\\beta_L}{1 + (1-T)\\frac{D}{E}}", explanation: "Hamada equation")
                ],
                assumptions: [
                    "Debt beta equals zero (risk-free debt)",
                    "Tax shields are certain and permanent",
                    "Market values used for debt and equity",
                    "Constant capital structure policy"
                ],
                notes: "Enables comparison of business risk across companies with different leverage levels."
            ),
            variants: [
                FormulaVariant(name: "Harris-Pringle", formula: "\\beta_U = \\frac{\\beta_L}{1 + \\frac{D}{E}}", description: "Without tax adjustment", whenToUse: "When assuming debt has market risk"),
                FormulaVariant(name: "Fernandez", formula: "\\beta_U = \\beta_L - (\\beta_L - \\beta_D) \\times \\frac{D(1-T)}{E}", description: "With explicit debt beta", whenToUse: "When debt has systematic risk")
            ],
            usageNotes: [
                "Essential for comparable company analysis",
                "Use when analyzing acquisition targets",
                "Required for cost of equity in different capital structures",
                "Industry average unlevered betas more stable",
                "Consider debt risk when beta_D ≠ 0"
            ],
            examples: [
                FormulaExample(
                    title: "Utility Company Unlevered Beta",
                    description: "Remove leverage effect: levered beta = 0.8, D/E = 0.6, tax rate = 25%",
                    inputs: ["Levered Beta": "0.8", "Debt/Equity": "0.6", "Tax Rate": "25%"],
                    calculation: "βᵤ = 0.8 / [1 + (1-0.25) × 0.6] = 0.8 / 1.45 = 0.552",
                    result: "βᵤ = 0.55",
                    interpretation: "Pure business risk is moderate, financial leverage increased observed beta"
                )
            ],
            relatedFormulas: ["levered-beta", "beta", "capm", "wacc"],
            tags: ["unlevered-beta", "business-risk", "hamada", "leverage-adjustment", "comparable-analysis"]
        )
    }
    
    func createLeveredBetaFormula() -> FormulaReference {
        FormulaReference(
            name: "Levered Beta (Re-levering)",
            category: .equity,
            level: .levelII,
            mainFormula: "\\beta_L = \\beta_U[1 + (1-T)\\frac{D}{E}]",
            description: "Adjusts unlevered beta for target capital structure to reflect combined business and financial risk.",
            variables: [
                FormulaVariable(symbol: "\\beta_L", name: "Levered Beta", description: "Equity beta with financial leverage", units: "Unitless", typicalRange: "0.5 to 2.5", notes: "Includes business and financial risk"),
                FormulaVariable(symbol: "\\beta_U", name: "Unlevered Beta", description: "Asset beta without leverage", units: "Unitless", typicalRange: "0.3 to 1.8", notes: "Pure business risk"),
                FormulaVariable(symbol: "T", name: "Tax Rate", description: "Marginal corporate tax rate", units: "Percentage", typicalRange: "20% to 35%", notes: "Tax shield effect"),
                FormulaVariable(symbol: "D", name: "Target Debt Value", description: "Desired debt level", units: "Currency", typicalRange: "Varies", notes: "Market value of target debt"),
                FormulaVariable(symbol: "E", name: "Target Equity Value", description: "Desired equity level", units: "Currency", typicalRange: "Varies", notes: "Market value of target equity")
            ],
            derivation: nil,
            variants: [
                FormulaVariant(name: "Industry Average Re-levering", formula: "\\beta_L = \\beta_{U,industry}[1 + (1-T)\\frac{D}{E}_{target}]", description: "Using industry unlevered beta", whenToUse: "When company data is limited")
            ],
            usageNotes: [
                "Essential for WACC calculations with target structure",
                "Use in valuation when applying peer analysis",
                "Higher leverage increases equity beta systematically",
                "Consider debt capacity constraints",
                "Monitor for optimal capital structure"
            ],
            examples: [
                FormulaExample(
                    title: "Manufacturing Company Re-levering",
                    description: "Calculate target beta: unlevered beta = 1.1, target D/E = 0.4, tax rate = 28%",
                    inputs: ["Unlevered Beta": "1.1", "Target D/E": "0.4", "Tax Rate": "28%"],
                    calculation: "βₗ = 1.1 × [1 + (1-0.28) × 0.4] = 1.1 × 1.288 = 1.417",
                    result: "βₗ = 1.42",
                    interpretation: "Target leverage increases systematic risk by 29% above unlevered level"
                )
            ],
            relatedFormulas: ["unlevered-beta", "wacc", "cost-of-equity", "capital-structure"],
            tags: ["levered-beta", "re-levering", "financial-risk", "target-structure", "dcf-valuation"]
        )
    }
    
    // MARK: - Growth Analysis
    
    func createSustainableGrowthRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Sustainable Growth Rate",
            category: .equity,
            level: .levelII,
            mainFormula: "g = ROE \\times \\text{Retention Ratio} = ROE \\times (1 - \\text{Payout Ratio})",
            description: "Maximum growth rate achievable without external equity financing, maintaining current capital structure and profitability.",
            variables: [
                FormulaVariable(symbol: "g", name: "Sustainable Growth Rate", description: "Maximum internal growth rate", units: "Percentage", typicalRange: "3% to 15%", notes: "Without external equity"),
                FormulaVariable(symbol: "ROE", name: "Return on Equity", description: "Net income per dollar of equity", units: "Percentage", typicalRange: "8% to 25%", notes: "Profitability measure"),
                FormulaVariable(symbol: "\\text{Retention Ratio}", name: "Retention Ratio", description: "Proportion of earnings retained", units: "Percentage", typicalRange: "0% to 100%", notes: "1 minus payout ratio"),
                FormulaVariable(symbol: "\\text{Payout Ratio}", name: "Dividend Payout Ratio", description: "Proportion of earnings paid as dividends", units: "Percentage", typicalRange: "0% to 80%", notes: "Dividends per share / EPS")
            ],
            derivation: FormulaDerivation(
                title: "Sustainable Growth Rate Derivation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Define growth requirement", formula: "\\text{Growth} = \\frac{\\Delta \\text{Equity}}{\\text{Equity}}", explanation: "Equity growth drives asset growth"),
                    DerivationStep(stepNumber: 2, description: "Source of equity growth", formula: "\\Delta \\text{Equity} = \\text{Retained Earnings}", explanation: "Only internal equity source"),
                    DerivationStep(stepNumber: 3, description: "Express retained earnings", formula: "\\text{Retained Earnings} = \\text{Net Income} \\times (1 - \\text{Payout Ratio})", explanation: "Earnings not paid as dividends"),
                    DerivationStep(stepNumber: 4, description: "Substitute into growth formula", formula: "g = \\frac{\\text{NI} \\times (1 - \\text{Payout})}{\\text{Equity}}", explanation: "Internal growth formula"),
                    DerivationStep(stepNumber: 5, description: "Recognize ROE", formula: "g = \\frac{\\text{NI}}{\\text{Equity}} \\times (1 - \\text{Payout}) = ROE \\times \\text{Retention}", explanation: "Final sustainable growth formula")
                ],
                assumptions: [
                    "Constant capital structure (D/E ratio)",
                    "No external equity issuance",
                    "Constant ROE and dividend policy",
                    "All debt capacity is utilized proportionally"
                ],
                notes: "Fundamental constraint for corporate planning and valuation modeling."
            ),
            variants: [
                FormulaVariant(name: "DuPont SGR", formula: "g = \\text{Profit Margin} \\times \\text{Asset Turnover} \\times \\text{Equity Multiplier} \\times \\text{Retention}", description: "Using DuPont components", whenToUse: "For detailed driver analysis")
            ],
            usageNotes: [
                "Key planning tool for management and analysts",
                "Growth above SGR requires external financing or policy changes",
                "Lower payout ratios enable higher sustainable growth",
                "Must consider practical constraints and market conditions",
                "Compare to actual growth for financing needs assessment"
            ],
            examples: [
                FormulaExample(
                    title: "Technology Startup SGR",
                    description: "Calculate SGR for company with 18% ROE and 25% payout ratio",
                    inputs: ["ROE": "18%", "Payout Ratio": "25%"],
                    calculation: "g = 18% × (1 - 25%) = 18% × 75% = 13.5%",
                    result: "SGR = 13.5%",
                    interpretation: "Company can grow 13.5% annually without external equity, typical for profitable tech firm"
                )
            ],
            relatedFormulas: ["roe", "internal-growth", "retention-ratio", "external-financing"],
            tags: ["sustainable-growth", "internal-financing", "planning", "capital-structure"]
        )
    }
    
    // MARK: - Missing Function Implementations (Basic versions to fix compilation errors)
    
    func createGrossProfitMarginFormula() -> FormulaReference {
        FormulaReference(name: "Gross Profit Margin", category: .equity, level: .levelI, mainFormula: "\\text{GPM} = \\frac{\\text{Gross Profit}}{\\text{Revenue}}", description: "Basic operational profitability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["gross-margin"])
    }
    
    func createOperatingProfitMarginFormula() -> FormulaReference {
        FormulaReference(name: "Operating Profit Margin", category: .equity, level: .levelI, mainFormula: "\\text{OPM} = \\frac{\\text{Operating Income}}{\\text{Revenue}}", description: "Core operational efficiency", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["operating-margin"])
    }
    
    func createEBITDAMarginFormula() -> FormulaReference {
        FormulaReference(name: "EBITDA Margin", category: .equity, level: .levelI, mainFormula: "\\text{EBITDA Margin} = \\frac{\\text{EBITDA}}{\\text{Revenue}}", description: "Cash generation efficiency", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ebitda-margin"])
    }
    
    func createWorkingCapitalTurnoverFormula() -> FormulaReference {
        FormulaReference(name: "Working Capital Turnover", category: .equity, level: .levelI, mainFormula: "\\text{WC Turnover} = \\frac{\\text{Sales}}{\\text{Working Capital}}", description: "Working capital efficiency", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["working-capital"])
    }
    
    func createDebtToEquityFormula() -> FormulaReference {
        FormulaReference(name: "Debt-to-Equity", category: .equity, level: .levelI, mainFormula: "\\text{D/E} = \\frac{\\text{Total Debt}}{\\text{Total Equity}}", description: "Financial leverage measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["debt-ratios"])
    }
    
    func createDebtToAssetsFormula() -> FormulaReference {
        FormulaReference(name: "Debt-to-Assets", category: .equity, level: .levelI, mainFormula: "\\text{D/A} = \\frac{\\text{Total Debt}}{\\text{Total Assets}}", description: "Asset financing structure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["debt-ratios"])
    }
    
    func createEBITDACoverageFormula() -> FormulaReference {
        FormulaReference(name: "EBITDA Coverage", category: .equity, level: .levelI, mainFormula: "\\text{EBITDA Coverage} = \\frac{\\text{EBITDA}}{\\text{Interest Expense}}", description: "Debt service capability", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["coverage-ratios"])
    }
    
    func createCapitalizationRatioFormula() -> FormulaReference {
        FormulaReference(name: "Capitalization Ratio", category: .equity, level: .levelI, mainFormula: "\\text{Cap Ratio} = \\frac{\\text{Long-term Debt}}{\\text{Long-term Debt + Equity}}", description: "Long-term financing structure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["capitalization"])
    }
    
    func createOperatingCashFlowRatioFormula() -> FormulaReference {
        FormulaReference(name: "Operating Cash Flow Ratio", category: .equity, level: .levelI, mainFormula: "\\text{OCF Ratio} = \\frac{\\text{Operating Cash Flow}}{\\text{Current Liabilities}}", description: "Liquidity from operations", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cash-flow"])
    }
    
    func createDuPontROEExtendedFormula() -> FormulaReference {
        FormulaReference(name: "Extended DuPont ROE", category: .equity, level: .levelII, mainFormula: "\\text{ROE} = \\frac{\\text{EBIT}}{\\text{Sales}} \\times \\frac{\\text{Sales}}{\\text{Assets}} \\times \\frac{\\text{Assets}}{\\text{Equity}} \\times \\frac{\\text{EBT}}{\\text{EBIT}} \\times \\frac{\\text{NI}}{\\text{EBT}}", description: "Five-factor ROE decomposition", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["dupont"])
    }
    
    func createEquityMultiplierFormula() -> FormulaReference {
        FormulaReference(name: "Equity Multiplier", category: .equity, level: .levelI, mainFormula: "\\text{EM} = \\frac{\\text{Total Assets}}{\\text{Total Equity}}", description: "Financial leverage measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    func createAdjustedBetaFormula() -> FormulaReference {
        FormulaReference(name: "Adjusted Beta", category: .equity, level: .levelII, mainFormula: "\\beta_{adj} = 0.67 \\times \\beta_{raw} + 0.33 \\times 1.0", description: "Blum adjustment for beta", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["beta"])
    }
    
    func createCAPMExtendedFormula() -> FormulaReference {
        FormulaReference(name: "CAPM Extended", category: .equity, level: .levelII, mainFormula: "E(R_i) = R_f + \\beta_i[E(R_m) - R_f] + \\text{adjustments}", description: "Extended CAPM with adjustments", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["capm"])
    }
    
    func createFamaFrenchFormula() -> FormulaReference {
        FormulaReference(name: "Fama-French Three-Factor", category: .equity, level: .levelII, mainFormula: "E(R_i) = R_f + \\beta_i[E(R_m) - R_f] + s_i \\times SMB + h_i \\times HML", description: "Three-factor asset pricing model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["fama-french"])
    }
    
    func createInternalGrowthRateFormula() -> FormulaReference {
        FormulaReference(name: "Internal Growth Rate", category: .equity, level: .levelI, mainFormula: "g_{internal} = \\frac{ROA \\times b}{1 - ROA \\times b}", description: "Growth without external financing", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["growth"])
    }
    
    func createPLOWBACKRatioFormula() -> FormulaReference {
        FormulaReference(name: "Plowback Ratio", category: .equity, level: .levelI, mainFormula: "\\text{Plowback} = 1 - \\text{Payout Ratio}", description: "Earnings retention ratio", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["retention"])
    }
    
    func createRetentionRatioFormula() -> FormulaReference {
        FormulaReference(name: "Retention Ratio", category: .equity, level: .levelI, mainFormula: "b = \\frac{\\text{Retained Earnings}}{\\text{Net Income}}", description: "Proportion of earnings retained", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["retention"])
    }
    
    // Add basic implementations for all advanced quantitative functions
    func createCointegrationTestFormula() -> FormulaReference {
        FormulaReference(name: "Cointegration Test", category: .quantitative, level: .levelII, mainFormula: "\\text{Cointegration Test}", description: "Long-run equilibrium relationship test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cointegration"])
    }
    
    func createAugmentedDickeyFullerTestFormula() -> FormulaReference {
        FormulaReference(name: "Augmented Dickey-Fuller Test", category: .quantitative, level: .levelII, mainFormula: "\\Delta y_t = \\alpha + \\beta t + \\gamma y_{t-1} + \\delta_1 \\Delta y_{t-1} + \\cdots + \\delta_p \\Delta y_{t-p} + \\epsilon_t", description: "Unit root test for stationarity", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["stationarity"])
    }
    
    func createPhillipsPerronTestFormula() -> FormulaReference {
        FormulaReference(name: "Phillips-Perron Test", category: .quantitative, level: .levelII, mainFormula: "\\text{PP Test}", description: "Alternative unit root test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["unit-root"])
    }
    
    // MARK: - Missing Alternative Investment Formulas
    
    // Digital Assets & Cryptocurrency
    func createMetcalfesLawFormula() -> FormulaReference {
        FormulaReference(
            name: "Metcalfe's Law for Network Valuation",
            category: .alternatives,
            level: .levelII,
            mainFormula: "V \\propto n^2",
            description: "Network value proportional to square of number of users",
            variables: [
                FormulaVariable(symbol: "V", name: "Network Value", description: "Total value of network", units: "Currency", typicalRange: "Varies", notes: "Increases quadratically with users"),
                FormulaVariable(symbol: "n", name: "Number of Users", description: "Active network participants", units: "Count", typicalRange: "1 to millions", notes: "Active daily/monthly users")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Used for cryptocurrency and network valuation"],
            examples: [],
            relatedFormulas: ["network-effects"],
            tags: ["metcalfe", "network-valuation", "cryptocurrency"]
        )
    }
    
    func createNVTRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Network Value to Transactions (NVT) Ratio",
            category: .alternatives,
            level: .levelII,
            mainFormula: "NVT = \\frac{\\text{Market Cap}}{\\text{Daily Transaction Volume}}",
            description: "Cryptocurrency valuation metric similar to P/E ratio",
            variables: [
                FormulaVariable(symbol: "NVT", name: "NVT Ratio", description: "Network value to transactions ratio", units: "Days", typicalRange: "10 to 100", notes: "Lower values suggest undervaluation"),
                FormulaVariable(symbol: "\\text{Market Cap}", name: "Market Capitalization", description: "Total value of cryptocurrency", units: "Currency", typicalRange: "Varies", notes: "Price × circulating supply"),
                FormulaVariable(symbol: "\\text{Daily Transaction Volume}", name: "Transaction Volume", description: "Daily on-chain transaction value", units: "Currency/Day", typicalRange: "Varies", notes: "Economic activity measure")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["High NVT suggests overvaluation relative to utility"],
            examples: [],
            relatedFormulas: ["cryptocurrency-metrics"],
            tags: ["nvt", "cryptocurrency", "valuation-ratio"]
        )
    }
    
    func createTokenVelocityFormula() -> FormulaReference {
        FormulaReference(
            name: "Token Velocity",
            category: .alternatives,
            level: .levelII,
            mainFormula: "V = \\frac{PQ}{M}",
            description: "Speed at which tokens change hands in economic activity",
            variables: [
                FormulaVariable(symbol: "V", name: "Velocity", description: "Token velocity", units: "1/Time", typicalRange: "1 to 50", notes: "Higher velocity reduces token value"),
                FormulaVariable(symbol: "P", name: "Price Level", description: "Average price of goods/services", units: "Currency", typicalRange: "Varies", notes: "Denominated in token units"),
                FormulaVariable(symbol: "Q", name: "Quantity of Transactions", description: "Number of transactions", units: "Count", typicalRange: "Varies", notes: "Economic activity volume"),
                FormulaVariable(symbol: "M", name: "Money Supply", description: "Token supply", units: "Tokens", typicalRange: "Varies", notes: "Circulating token count")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Based on quantity theory of money"],
            examples: [],
            relatedFormulas: ["quantity-theory-money"],
            tags: ["token-velocity", "cryptocurrency", "monetary-theory"]
        )
    }
    
    // Infrastructure Investments
    func createRegulatedAssetBaseFormula() -> FormulaReference {
        FormulaReference(
            name: "Regulated Asset Base (RAB)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "RAB = \\text{Initial Investment} + \\text{Additions} - \\text{Depreciation} \\pm \\text{Indexation}",
            description: "Value of assets for regulated utility pricing",
            variables: [
                FormulaVariable(symbol: "RAB", name: "Regulated Asset Base", description: "Asset value for regulatory purposes", units: "Currency", typicalRange: "Millions to billions", notes: "Basis for allowed returns"),
                FormulaVariable(symbol: "\\text{Initial Investment}", name: "Initial Investment", description: "Original asset investment", units: "Currency", typicalRange: "Varies", notes: "Historical cost basis"),
                FormulaVariable(symbol: "\\text{Additions}", name: "Capital Additions", description: "New capital investments", units: "Currency", typicalRange: "Varies", notes: "Regulatory approved additions"),
                FormulaVariable(symbol: "\\text{Depreciation}", name: "Depreciation", description: "Accumulated depreciation", units: "Currency", typicalRange: "Varies", notes: "Regulatory depreciation schedule"),
                FormulaVariable(symbol: "\\text{Indexation}", name: "Indexation", description: "Inflation adjustments", units: "Currency", typicalRange: "Varies", notes: "RPI/CPI adjustments")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in utility regulation for rate setting"],
            examples: [],
            relatedFormulas: ["wacc", "utility-regulation"],
            tags: ["rab", "infrastructure", "regulation", "utilities"]
        )
    }
    
    func createInfrastructureDCFFormula() -> FormulaReference {
        FormulaReference(
            name: "Infrastructure DCF Valuation",
            category: .alternatives,
            level: .levelII,
            mainFormula: "V = \\sum_{t=1}^{n} \\frac{FCF_t}{(1+WACC)^t} + \\frac{TV}{(1+WACC)^n}",
            description: "Discounted cash flow valuation for infrastructure assets",
            variables: [
                FormulaVariable(symbol: "V", name: "Asset Value", description: "Present value of infrastructure asset", units: "Currency", typicalRange: "Millions to billions", notes: "Total enterprise value"),
                FormulaVariable(symbol: "FCF_t", name: "Free Cash Flow", description: "Annual free cash flow", units: "Currency", typicalRange: "Varies", notes: "Regulatory/contracted cash flows"),
                FormulaVariable(symbol: "WACC", name: "Weighted Average Cost of Capital", description: "Discount rate", units: "Percentage", typicalRange: "3% to 12%", notes: "Infrastructure-specific risk premium"),
                FormulaVariable(symbol: "TV", name: "Terminal Value", description: "Value beyond forecast period", units: "Currency", typicalRange: "Varies", notes: "Often majority of value"),
                FormulaVariable(symbol: "n", name: "Forecast Period", description: "Explicit forecast years", units: "Years", typicalRange: "10 to 30 years", notes: "Asset/concession life")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Long-term stable cash flows typical for infrastructure"],
            examples: [],
            relatedFormulas: ["dcf", "wacc", "terminal-value"],
            tags: ["infrastructure", "dcf", "valuation", "long-term-assets"]
        )
    }
    
    // Natural Resources
    func createOilGasReservesNPVFormula() -> FormulaReference {
        FormulaReference(
            name: "Oil & Gas Reserves NPV",
            category: .alternatives,
            level: .levelII,
            mainFormula: "NPV = \\sum_{t=1}^{n} \\frac{(P_t \\times Q_t - C_t) \\times (1-T)}{(1+r)^t} - I_0",
            description: "Net present value of oil and gas reserves",
            variables: [
                FormulaVariable(symbol: "NPV", name: "Net Present Value", description: "Value of reserves", units: "Currency", typicalRange: "Millions to billions", notes: "After-tax present value"),
                FormulaVariable(symbol: "P_t", name: "Commodity Price", description: "Oil/gas price in year t", units: "Currency/Unit", typicalRange: "$40-150/barrel", notes: "Forward curve prices"),
                FormulaVariable(symbol: "Q_t", name: "Production Quantity", description: "Annual production volume", units: "Barrels/MCF", typicalRange: "Varies", notes: "Decline curve based"),
                FormulaVariable(symbol: "C_t", name: "Operating Costs", description: "Annual operating costs", units: "Currency", typicalRange: "Varies", notes: "Lifting costs, transport, etc."),
                FormulaVariable(symbol: "T", name: "Tax Rate", description: "Effective tax rate", units: "Percentage", typicalRange: "20% to 70%", notes: "Includes royalties and taxes"),
                FormulaVariable(symbol: "r", name: "Discount Rate", description: "Risk-adjusted discount rate", units: "Percentage", typicalRange: "8% to 15%", notes: "Reflects commodity risk"),
                FormulaVariable(symbol: "I_0", name: "Initial Investment", description: "Development capex", units: "Currency", typicalRange: "Millions to billions", notes: "Drilling and facility costs")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Highly sensitive to commodity price assumptions"],
            examples: [],
            relatedFormulas: ["npv", "commodity-pricing"],
            tags: ["oil-gas", "reserves", "npv", "natural-resources"]
        )
    }
    
    func createDepletionAccountingFormula() -> FormulaReference {
        FormulaReference(
            name: "Depletion Accounting",
            category: .alternatives,
            level: .levelI,
            mainFormula: "\\text{Depletion Expense} = \\frac{\\text{Cost of Resource}}{\\text{Total Estimated Units}} \\times \\text{Units Extracted}",
            description: "Allocation of natural resource costs over extraction period",
            variables: [
                FormulaVariable(symbol: "\\text{Depletion Expense}", name: "Depletion Expense", description: "Annual depletion charge", units: "Currency", typicalRange: "Varies", notes: "Reduces book value of reserves"),
                FormulaVariable(symbol: "\\text{Cost of Resource}", name: "Resource Cost", description: "Total acquisition and development cost", units: "Currency", typicalRange: "Millions to billions", notes: "Capitalizable costs"),
                FormulaVariable(symbol: "\\text{Total Estimated Units}", name: "Total Reserves", description: "Proven reserves at acquisition", units: "Physical Units", typicalRange: "Varies", notes: "Proven and probable reserves"),
                FormulaVariable(symbol: "\\text{Units Extracted}", name: "Annual Production", description: "Units produced in current period", units: "Physical Units", typicalRange: "Varies", notes: "Actual production volume")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Similar to depreciation but for natural resources"],
            examples: [],
            relatedFormulas: ["depreciation", "resource-accounting"],
            tags: ["depletion", "natural-resources", "accounting", "extraction"]
        )
    }
    
    // Fund-of-Funds Complex Structures
    func createFundOfFundsFeesFormula() -> FormulaReference {
        FormulaReference(
            name: "Fund-of-Funds Fee Structure",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Total Fees} = \\text{Base Mgmt Fee} + \\text{Underlying Fees} + \\text{Performance Fees}",
            description: "Layered fee structure in fund-of-funds investments",
            variables: [
                FormulaVariable(symbol: "\\text{Total Fees}", name: "Total Fees", description: "All-in investor fees", units: "Percentage", typicalRange: "2% to 6%", notes: "Can be quite high due to layering"),
                FormulaVariable(symbol: "\\text{Base Mgmt Fee}", name: "Management Fee", description: "Fund-of-funds management fee", units: "Percentage", typicalRange: "1% to 2%", notes: "Applied to committed capital"),
                FormulaVariable(symbol: "\\text{Underlying Fees}", name: "Underlying Fees", description: "Fees of underlying funds", units: "Percentage", typicalRange: "1% to 3%", notes: "Weighted average of underlying"),
                FormulaVariable(symbol: "\\text{Performance Fees}", name: "Performance Fees", description: "Carried interest and incentive fees", units: "Percentage", typicalRange: "10% to 30%", notes: "On excess returns")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Fee layering can significantly reduce net returns"],
            examples: [],
            relatedFormulas: ["hedge-fund-fees", "private-equity-fees"],
            tags: ["fund-of-funds", "fees", "layering", "alternative-investments"]
        )
    }
    
    func createSidePocketProvisionFormula() -> FormulaReference {
        FormulaReference(
            name: "Side Pocket Provision",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Side Pocket Value} = \\text{Illiquid Asset Value} - \\text{Valuation Discount}",
            description: "Separate accounting for illiquid assets in hedge funds",
            variables: [
                FormulaVariable(symbol: "\\text{Side Pocket Value}", name: "Side Pocket Value", description: "Value of segregated illiquid assets", units: "Currency", typicalRange: "Varies", notes: "Separate from main fund NAV"),
                FormulaVariable(symbol: "\\text{Illiquid Asset Value}", name: "Asset Value", description: "Mark-to-model or cost value", units: "Currency", typicalRange: "Varies", notes: "Often difficult to value"),
                FormulaVariable(symbol: "\\text{Valuation Discount}", name: "Illiquidity Discount", description: "Discount for lack of liquidity", units: "Currency", typicalRange: "10% to 50%", notes: "Risk adjustment for illiquidity")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Used during market stress when assets become illiquid"],
            examples: [],
            relatedFormulas: ["hedge-fund-valuation", "illiquidity-premium"],
            tags: ["side-pocket", "illiquid", "hedge-funds", "valuation"]
        )
    }
    
    func createJohansenCointegrationTestFormula() -> FormulaReference {
        FormulaReference(name: "Johansen Cointegration Test", category: .quantitative, level: .levelII, mainFormula: "\\text{Johansen Test}", description: "Vector cointegration test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["cointegration"])
    }
    
    // MARK: - Basic Bond Pricing and Yield Formulas
    
    func createBondPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Bond Pricing",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "P = \\sum_{t=1}^{n} \\frac{C}{(1+r)^t} + \\frac{M}{(1+r)^n}",
            description: "Present value of bond's cash flows",
            variables: [
                FormulaVariable(symbol: "P", name: "Bond Price", description: "Present value of bond", units: "Currency", typicalRange: "$800-$1200", notes: "Par value typically $1000"),
                FormulaVariable(symbol: "C", name: "Coupon Payment", description: "Periodic interest payment", units: "Currency", typicalRange: "$10-$100", notes: "Coupon rate × face value"),
                FormulaVariable(symbol: "r", name: "Yield to Maturity", description: "Required rate of return", units: "Percentage", typicalRange: "1%-10%", notes: "Market interest rate"),
                FormulaVariable(symbol: "M", name: "Maturity Value", description: "Face value at maturity", units: "Currency", typicalRange: "$1000", notes: "Principal repayment"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Time to maturity", units: "Periods", typicalRange: "1-60", notes: "Coupon payment periods")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Basic DCF valuation of fixed income securities"],
            examples: [],
            relatedFormulas: ["ytm", "duration", "convexity"],
            tags: ["bond-pricing", "fixed-income", "dcf"]
        )
    }
    
    func createYieldToMaturityFormula() -> FormulaReference {
        FormulaReference(
            name: "Yield to Maturity (YTM)",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "P = \\sum_{t=1}^{n} \\frac{C}{(1+YTM)^t} + \\frac{M}{(1+YTM)^n}",
            description: "Internal rate of return of bond investment",
            variables: [
                FormulaVariable(symbol: "YTM", name: "Yield to Maturity", description: "IRR of bond investment", units: "Percentage", typicalRange: "1%-10%", notes: "Solved iteratively"),
                FormulaVariable(symbol: "P", name: "Current Price", description: "Market price of bond", units: "Currency", typicalRange: "$800-$1200", notes: "Current market value"),
                FormulaVariable(symbol: "C", name: "Coupon Payment", description: "Periodic interest payment", units: "Currency", typicalRange: "$10-$100", notes: "Fixed cash flow"),
                FormulaVariable(symbol: "M", name: "Face Value", description: "Principal at maturity", units: "Currency", typicalRange: "$1000", notes: "Maturity payment"),
                FormulaVariable(symbol: "n", name: "Periods to Maturity", description: "Time until maturity", units: "Periods", typicalRange: "1-60", notes: "Remaining coupon periods")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Must be solved numerically or by trial and error"],
            examples: [],
            relatedFormulas: ["bond-pricing", "current-yield"],
            tags: ["ytm", "bond-yield", "irr"]
        )
    }
    
    func createCurrentYieldFormula() -> FormulaReference {
        FormulaReference(
            name: "Current Yield",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "\\text{Current Yield} = \\frac{\\text{Annual Coupon Payment}}{\\text{Current Market Price}}",
            description: "Simple yield measure based on current price",
            variables: [
                FormulaVariable(symbol: "\\text{Current Yield}", name: "Current Yield", description: "Annual return based on current price", units: "Percentage", typicalRange: "1%-8%", notes: "Ignores capital gains/losses"),
                FormulaVariable(symbol: "\\text{Annual Coupon Payment}", name: "Annual Coupon", description: "Total annual interest payment", units: "Currency", typicalRange: "$20-$100", notes: "Fixed annual payment"),
                FormulaVariable(symbol: "\\text{Current Market Price}", name: "Market Price", description: "Current trading price of bond", units: "Currency", typicalRange: "$800-$1200", notes: "Market value")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Simplistic measure that ignores time value of money"],
            examples: [],
            relatedFormulas: ["ytm", "bond-pricing"],
            tags: ["current-yield", "bond-yield", "simple-yield"]
        )
    }
    
    func createMacaulayDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Macaulay Duration",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "D_{Mac} = \\frac{\\sum_{t=1}^{n} \\frac{t \\cdot CF_t}{(1+r)^t}}{P}",
            description: "Weighted average time to receive bond's cash flows",
            variables: [
                FormulaVariable(symbol: "D_{Mac}", name: "Macaulay Duration", description: "Weighted average maturity", units: "Years", typicalRange: "0.5-30", notes: "Interest rate sensitivity measure"),
                FormulaVariable(symbol: "t", name: "Time Period", description: "Time until cash flow", units: "Periods", typicalRange: "1-60", notes: "Cash flow timing"),
                FormulaVariable(symbol: "CF_t", name: "Cash Flow", description: "Cash flow at time t", units: "Currency", typicalRange: "Varies", notes: "Coupon or principal payment"),
                FormulaVariable(symbol: "r", name: "Yield", description: "Yield to maturity", units: "Percentage", typicalRange: "1%-10%", notes: "Discount rate"),
                FormulaVariable(symbol: "P", name: "Bond Price", description: "Present value of bond", units: "Currency", typicalRange: "$800-$1200", notes: "Current market price")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures average time to receive cash flows"],
            examples: [],
            relatedFormulas: ["modified-duration", "convexity"],
            tags: ["macaulay-duration", "duration", "interest-rate-risk"]
        )
    }
    
    func createModifiedDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Modified Duration",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "D_{Mod} = \\frac{D_{Mac}}{1+r}",
            description: "Price sensitivity of bond to yield changes",
            variables: [
                FormulaVariable(symbol: "D_{Mod}", name: "Modified Duration", description: "Price sensitivity measure", units: "Percentage", typicalRange: "0.5-25", notes: "% price change per 1% yield change"),
                FormulaVariable(symbol: "D_{Mac}", name: "Macaulay Duration", description: "Weighted average maturity", units: "Years", typicalRange: "0.5-30", notes: "Time-weighted cash flows"),
                FormulaVariable(symbol: "r", name: "Yield to Maturity", description: "Current yield", units: "Percentage", typicalRange: "1%-10%", notes: "Market discount rate")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Approximates price change for small yield changes"],
            examples: [],
            relatedFormulas: ["macaulay-duration", "convexity"],
            tags: ["modified-duration", "price-sensitivity", "interest-rate-risk"]
        )
    }
    
    func createConvexityFormula() -> FormulaReference {
        FormulaReference(
            name: "Bond Convexity",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "\\text{Convexity} = \\frac{1}{P} \\sum_{t=1}^{n} \\frac{CF_t \\cdot t \\cdot (t+1)}{(1+r)^{t+2}}",
            description: "Second-order price sensitivity to yield changes",
            variables: [
                FormulaVariable(symbol: "\\text{Convexity}", name: "Convexity", description: "Curvature of price-yield relationship", units: "Years²", typicalRange: "1-500", notes: "Higher for longer maturity bonds"),
                FormulaVariable(symbol: "P", name: "Bond Price", description: "Current market price", units: "Currency", typicalRange: "$800-$1200", notes: "Present value"),
                FormulaVariable(symbol: "CF_t", name: "Cash Flow", description: "Cash flow at time t", units: "Currency", typicalRange: "Varies", notes: "Coupon or principal"),
                FormulaVariable(symbol: "t", name: "Time Period", description: "Time until cash flow", units: "Periods", typicalRange: "1-60", notes: "Cash flow timing"),
                FormulaVariable(symbol: "r", name: "Yield", description: "Yield to maturity", units: "Percentage", typicalRange: "1%-10%", notes: "Discount rate")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Improves duration-based price estimates"],
            examples: [],
            relatedFormulas: ["modified-duration", "bond-pricing"],
            tags: ["convexity", "price-sensitivity", "second-order"]
        )
    }
    
    // MARK: - Basic Equity Valuation Formulas
    
    func createGordonGrowthModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Gordon Growth Model (Dividend Discount Model)",
            category: .equity,
            level: .levelI,
            mainFormula: "P_0 = \\frac{D_1}{r - g}",
            description: "Present value of stock with constant dividend growth",
            variables: [
                FormulaVariable(symbol: "P_0", name: "Current Stock Price", description: "Intrinsic value of stock", units: "Currency", typicalRange: "$10-$500", notes: "Fair value estimate"),
                FormulaVariable(symbol: "D_1", name: "Next Year's Dividend", description: "Expected dividend next period", units: "Currency", typicalRange: "$0.50-$10", notes: "Growing at rate g"),
                FormulaVariable(symbol: "r", name: "Required Return", description: "Cost of equity capital", units: "Percentage", typicalRange: "8%-15%", notes: "Risk-adjusted discount rate"),
                FormulaVariable(symbol: "g", name: "Growth Rate", description: "Constant dividend growth rate", units: "Percentage", typicalRange: "2%-8%", notes: "Must be less than r")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Only valid when g < r and growth is perpetual"],
            examples: [],
            relatedFormulas: ["capm", "two-stage-ddm"],
            tags: ["gordon-growth", "ddm", "equity-valuation"]
        )
    }
    
    func createTwoStageDDMFormula() -> FormulaReference {
        FormulaReference(
            name: "Two-Stage Dividend Discount Model",
            category: .equity,
            level: .levelI,
            mainFormula: "P_0 = \\sum_{t=1}^{n} \\frac{D_0(1+g_1)^t}{(1+r)^t} + \\frac{D_{n+1}}{(r-g_2)(1+r)^n}",
            description: "DDM with two distinct growth phases",
            variables: [
                FormulaVariable(symbol: "P_0", name: "Current Stock Price", description: "Present value of stock", units: "Currency", typicalRange: "$10-$500", notes: "Sum of both growth phases"),
                FormulaVariable(symbol: "D_0", name: "Current Dividend", description: "Most recent dividend payment", units: "Currency", typicalRange: "$0.50-$10", notes: "Base for growth projections"),
                FormulaVariable(symbol: "g_1", name: "High Growth Rate", description: "Initial growth rate", units: "Percentage", typicalRange: "10%-25%", notes: "Unsustainable high growth"),
                FormulaVariable(symbol: "g_2", name: "Stable Growth Rate", description: "Long-term growth rate", units: "Percentage", typicalRange: "2%-6%", notes: "Sustainable growth rate"),
                FormulaVariable(symbol: "r", name: "Required Return", description: "Cost of equity", units: "Percentage", typicalRange: "8%-15%", notes: "Risk-adjusted discount rate"),
                FormulaVariable(symbol: "n", name: "High Growth Period", description: "Years of high growth", units: "Years", typicalRange: "3-10", notes: "Transition period")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["More realistic for growth companies"],
            examples: [],
            relatedFormulas: ["gordon-growth", "h-model"],
            tags: ["two-stage-ddm", "growth-phases", "equity-valuation"]
        )
    }
    
    func createPERatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Price-to-Earnings (P/E) Ratio",
            category: .equity,
            level: .levelI,
            mainFormula: "P/E = \\frac{\\text{Price per Share}}{\\text{Earnings per Share}}",
            description: "Market valuation multiple based on earnings",
            variables: [
                FormulaVariable(symbol: "P/E", name: "P/E Ratio", description: "Price-earnings multiple", units: "Multiple", typicalRange: "5-50", notes: "Higher for growth companies"),
                FormulaVariable(symbol: "\\text{Price per Share}", name: "Stock Price", description: "Current market price", units: "Currency", typicalRange: "$10-$500", notes: "Market value per share"),
                FormulaVariable(symbol: "\\text{Earnings per Share}", name: "EPS", description: "Net income per share", units: "Currency", typicalRange: "$0.50-$20", notes: "Annual or TTM earnings")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Common valuation multiple for comparison"],
            examples: [],
            relatedFormulas: ["pb-ratio", "peg-ratio"],
            tags: ["pe-ratio", "valuation-multiple", "earnings"]
        )
    }
    
    func createPBRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Price-to-Book (P/B) Ratio",
            category: .equity,
            level: .levelI,
            mainFormula: "P/B = \\frac{\\text{Price per Share}}{\\text{Book Value per Share}}",
            description: "Market value relative to accounting book value",
            variables: [
                FormulaVariable(symbol: "P/B", name: "P/B Ratio", description: "Price-to-book multiple", units: "Multiple", typicalRange: "0.5-10", notes: "Below 1 suggests undervaluation"),
                FormulaVariable(symbol: "\\text{Price per Share}", name: "Stock Price", description: "Current market price", units: "Currency", typicalRange: "$10-$500", notes: "Market value per share"),
                FormulaVariable(symbol: "\\text{Book Value per Share}", name: "BVPS", description: "Shareholders' equity per share", units: "Currency", typicalRange: "$5-$100", notes: "Accounting value per share")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Useful for asset-heavy businesses"],
            examples: [],
            relatedFormulas: ["pe-ratio", "roe"],
            tags: ["pb-ratio", "book-value", "valuation-multiple"]
        )
    }
    
    func createGrangerCausalityTestFormula() -> FormulaReference {
        FormulaReference(name: "Granger Causality Test", category: .quantitative, level: .levelII, mainFormula: "\\text{Granger Test}", description: "Causal relationship test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["causality"])
    }
    
    // MARK: - Portfolio and Risk Management Formulas
    
    func createCAPMFormula() -> FormulaReference {
        FormulaReference(
            name: "Capital Asset Pricing Model (CAPM)",
            category: .portfolio,
            level: .levelI,
            mainFormula: "E(R_i) = R_f + \\beta_i [E(R_m) - R_f]",
            description: "Expected return based on systematic risk",
            variables: [
                FormulaVariable(symbol: "E(R_i)", name: "Expected Return", description: "Expected return on asset i", units: "Percentage", typicalRange: "5%-20%", notes: "Risk-adjusted expected return"),
                FormulaVariable(symbol: "R_f", name: "Risk-Free Rate", description: "Return on risk-free asset", units: "Percentage", typicalRange: "1%-5%", notes: "Treasury bill rate"),
                FormulaVariable(symbol: "\\beta_i", name: "Beta", description: "Systematic risk measure", units: "Coefficient", typicalRange: "0.5-2.0", notes: "Market sensitivity"),
                FormulaVariable(symbol: "E(R_m)", name: "Market Return", description: "Expected market return", units: "Percentage", typicalRange: "8%-12%", notes: "Market portfolio return"),
                FormulaVariable(symbol: "[E(R_m) - R_f]", name: "Market Risk Premium", description: "Excess return over risk-free rate", units: "Percentage", typicalRange: "4%-8%", notes: "Compensation for market risk")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation of modern portfolio theory"],
            examples: [],
            relatedFormulas: ["beta", "sharpe-ratio"],
            tags: ["capm", "expected-return", "systematic-risk"]
        )
    }
    
    func createSharpeRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Sharpe Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "S_p = \\frac{E(R_p) - R_f}{\\sigma_p}",
            description: "Risk-adjusted return measure",
            variables: [
                FormulaVariable(symbol: "S_p", name: "Sharpe Ratio", description: "Risk-adjusted return", units: "Ratio", typicalRange: "0.5-3.0", notes: "Higher values indicate better risk-adjusted returns"),
                FormulaVariable(symbol: "E(R_p)", name: "Expected Portfolio Return", description: "Expected return of portfolio", units: "Percentage", typicalRange: "5%-15%", notes: "Mean return"),
                FormulaVariable(symbol: "R_f", name: "Risk-Free Rate", description: "Return on risk-free asset", units: "Percentage", typicalRange: "1%-5%", notes: "Benchmark return"),
                FormulaVariable(symbol: "\\sigma_p", name: "Portfolio Standard Deviation", description: "Volatility of portfolio returns", units: "Percentage", typicalRange: "5%-25%", notes: "Total risk measure")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Higher Sharpe ratio indicates better risk-adjusted performance"],
            examples: [],
            relatedFormulas: ["treynor-ratio", "information-ratio"],
            tags: ["sharpe-ratio", "risk-adjusted", "performance"]
        )
    }
    
    func createTreynorRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Treynor Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "T_p = \\frac{E(R_p) - R_f}{\\beta_p}",
            description: "Risk-adjusted return per unit of systematic risk",
            variables: [
                FormulaVariable(symbol: "T_p", name: "Treynor Ratio", description: "Return per unit of systematic risk", units: "Percentage", typicalRange: "2%-10%", notes: "Higher values indicate better performance"),
                FormulaVariable(symbol: "E(R_p)", name: "Expected Portfolio Return", description: "Expected return of portfolio", units: "Percentage", typicalRange: "5%-15%", notes: "Mean return"),
                FormulaVariable(symbol: "R_f", name: "Risk-Free Rate", description: "Return on risk-free asset", units: "Percentage", typicalRange: "1%-5%", notes: "Benchmark return"),
                FormulaVariable(symbol: "\\beta_p", name: "Portfolio Beta", description: "Systematic risk of portfolio", units: "Coefficient", typicalRange: "0.5-2.0", notes: "Market sensitivity")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Useful when portfolio is well-diversified"],
            examples: [],
            relatedFormulas: ["sharpe-ratio", "capm"],
            tags: ["treynor-ratio", "systematic-risk", "performance"]
        )
    }
    
    func createInformationRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Information Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "IR = \\frac{E(R_p) - E(R_b)}{\\sigma(R_p - R_b)}",
            description: "Active return per unit of active risk",
            variables: [
                FormulaVariable(symbol: "IR", name: "Information Ratio", description: "Active risk-adjusted return", units: "Ratio", typicalRange: "0.2-1.0", notes: "Measures active management skill"),
                FormulaVariable(symbol: "E(R_p)", name: "Portfolio Return", description: "Expected portfolio return", units: "Percentage", typicalRange: "5%-15%", notes: "Active portfolio return"),
                FormulaVariable(symbol: "E(R_b)", name: "Benchmark Return", description: "Expected benchmark return", units: "Percentage", typicalRange: "5%-12%", notes: "Passive benchmark return"),
                FormulaVariable(symbol: "\\sigma(R_p - R_b)", name: "Tracking Error", description: "Standard deviation of active returns", units: "Percentage", typicalRange: "1%-5%", notes: "Active risk measure")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures consistency of active management"],
            examples: [],
            relatedFormulas: ["sharpe-ratio", "tracking-error"],
            tags: ["information-ratio", "active-management", "tracking-error"]
        )
    }
    
    func createVaRFormula() -> FormulaReference {
        FormulaReference(
            name: "Value at Risk (VaR)",
            category: .risk,
            level: .levelI,
            mainFormula: "VaR_{\\alpha} = -W \\cdot Z_{\\alpha} \\cdot \\sigma \\cdot \\sqrt{\\Delta t}",
            description: "Maximum expected loss at given confidence level",
            variables: [
                FormulaVariable(symbol: "VaR_{\\alpha}", name: "Value at Risk", description: "Maximum loss at α confidence", units: "Currency", typicalRange: "$1K-$1M", notes: "Depends on portfolio size"),
                FormulaVariable(symbol: "W", name: "Portfolio Value", description: "Current value of portfolio", units: "Currency", typicalRange: "$1K-$1B", notes: "Market value"),
                FormulaVariable(symbol: "Z_{\\alpha}", name: "Critical Value", description: "Standard normal critical value", units: "Standard Deviations", typicalRange: "1.65-2.58", notes: "1.65 for 95%, 2.33 for 99%"),
                FormulaVariable(symbol: "\\sigma", name: "Portfolio Volatility", description: "Standard deviation of returns", units: "Percentage", typicalRange: "5%-30%", notes: "Historical or implied volatility"),
                FormulaVariable(symbol: "\\sqrt{\\Delta t}", name: "Time Factor", description: "Square root of time horizon", units: "√Time", typicalRange: "√1 to √252", notes: "Daily to annual scaling")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Assumes normal distribution of returns"],
            examples: [],
            relatedFormulas: ["expected-shortfall", "conditional-var"],
            tags: ["var", "risk-management", "downside-risk"]
        )
    }
    
    func createExpectedShortfallFormula() -> FormulaReference {
        FormulaReference(
            name: "Expected Shortfall (Conditional VaR)",
            category: .risk,
            level: .levelII,
            mainFormula: "ES_{\\alpha} = E[L | L > VaR_{\\alpha}]",
            description: "Expected loss given that loss exceeds VaR",
            variables: [
                FormulaVariable(symbol: "ES_{\\alpha}", name: "Expected Shortfall", description: "Conditional expected loss", units: "Currency", typicalRange: "$1K-$1M", notes: "Always greater than VaR"),
                FormulaVariable(symbol: "E[L | L > VaR_{\\alpha}]", name: "Conditional Expectation", description: "Expected loss beyond VaR", units: "Currency", typicalRange: "1.1-1.5× VaR", notes: "Tail risk measure"),
                FormulaVariable(symbol: "L", name: "Loss", description: "Portfolio loss", units: "Currency", typicalRange: "Varies", notes: "Negative of return"),
                FormulaVariable(symbol: "VaR_{\\alpha}", name: "Value at Risk", description: "VaR threshold", units: "Currency", typicalRange: "$1K-$1M", notes: "Quantile of loss distribution")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Coherent risk measure, captures tail risk"],
            examples: [],
            relatedFormulas: ["var", "tail-risk"],
            tags: ["expected-shortfall", "conditional-var", "tail-risk"]
        )
    }
    
    func createMaximumDrawdownFormula() -> FormulaReference {
        FormulaReference(
            name: "Maximum Drawdown",
            category: .risk,
            level: .levelI,
            mainFormula: "MDD = \\max_{t \\in (0,T)} \\left[ \\max_{\\tau \\in (0,t)} P_{\\tau} - P_t \\right]",
            description: "Largest peak-to-trough decline in portfolio value",
            variables: [
                FormulaVariable(symbol: "MDD", name: "Maximum Drawdown", description: "Largest portfolio decline", units: "Percentage", typicalRange: "5%-50%", notes: "Measures worst historical loss"),
                FormulaVariable(symbol: "P_{\\tau}", name: "Peak Value", description: "Highest portfolio value up to time τ", units: "Currency", typicalRange: "Varies", notes: "Running maximum"),
                FormulaVariable(symbol: "P_t", name: "Current Value", description: "Portfolio value at time t", units: "Currency", typicalRange: "Varies", notes: "After decline from peak"),
                FormulaVariable(symbol: "T", name: "Observation Period", description: "Total time period analyzed", units: "Time", typicalRange: "1-10 years", notes: "Historical analysis period")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Important for understanding portfolio risk"],
            examples: [],
            relatedFormulas: ["calmar-ratio", "recovery-time"],
            tags: ["maximum-drawdown", "downside-risk", "peak-to-trough"]
        )
    }
    
    // MARK: - Basic Statistical Formulas
    
    func createArithmeticMeanFormula() -> FormulaReference {
        FormulaReference(
            name: "Arithmetic Mean",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\bar{X} = \\frac{1}{n} \\sum_{i=1}^{n} X_i",
            description: "Simple average of data values",
            variables: [
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Average of sample observations", units: "Same as X", typicalRange: "Varies", notes: "Central tendency measure"),
                FormulaVariable(symbol: "X_i", name: "Observation", description: "Individual data value", units: "Varies", typicalRange: "Varies", notes: "Sample data point"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "5-1000+", notes: "Larger samples more reliable")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Most common measure of central tendency"],
            examples: [],
            relatedFormulas: ["geometric-mean", "standard-deviation"],
            tags: ["arithmetic-mean", "central-tendency", "statistics"]
        )
    }
    
    func createGeometricMeanFormula() -> FormulaReference {
        FormulaReference(
            name: "Geometric Mean",
            category: .quantitative,
            level: .levelI,
            mainFormula: "G = \\sqrt[n]{\\prod_{i=1}^{n} X_i} = \\left(\\prod_{i=1}^{n} X_i\\right)^{\\frac{1}{n}}",
            description: "Average rate of growth over multiple periods",
            variables: [
                FormulaVariable(symbol: "G", name: "Geometric Mean", description: "Compound average growth rate", units: "Percentage", typicalRange: "Varies", notes: "Always ≤ arithmetic mean"),
                FormulaVariable(symbol: "X_i", name: "Growth Factor", description: "1 + growth rate for period i", units: "Ratio", typicalRange: "0.8-1.3", notes: "1.10 = 10% growth"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Number of time periods", units: "Count", typicalRange: "2-50", notes: "Compounding periods"),
                FormulaVariable(symbol: "\\prod", name: "Product", description: "Multiplication of all values", units: "Varies", typicalRange: "Varies", notes: "Compound growth")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Appropriate for rates of change and ratios"],
            examples: [],
            relatedFormulas: ["arithmetic-mean", "compound-returns"],
            tags: ["geometric-mean", "compound-growth", "time-series"]
        )
    }
    
    func createStandardDeviationFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Standard Deviation",
            category: .quantitative,
            level: .levelI,
            mainFormula: "s = \\sqrt{\\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}}",
            description: "Measure of dispersion around the mean",
            variables: [
                FormulaVariable(symbol: "s", name: "Sample Standard Deviation", description: "Measure of variability", units: "Same as X", typicalRange: "Varies", notes: "Square root of variance"),
                FormulaVariable(symbol: "X_i", name: "Observation", description: "Individual data value", units: "Varies", typicalRange: "Varies", notes: "Sample data point"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Average of observations", units: "Same as X", typicalRange: "Varies", notes: "Central value"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "5-1000+", notes: "Use n-1 for sample")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Most common measure of dispersion"],
            examples: [],
            relatedFormulas: ["variance", "coefficient-of-variation"],
            tags: ["standard-deviation", "dispersion", "volatility"]
        )
    }
    
    func createVarianceFormula() -> FormulaReference {
        FormulaReference(
            name: "Sample Variance",
            category: .quantitative,
            level: .levelI,
            mainFormula: "s^2 = \\frac{\\sum_{i=1}^{n} (X_i - \\bar{X})^2}{n-1}",
            description: "Average squared deviation from the mean",
            variables: [
                FormulaVariable(symbol: "s^2", name: "Sample Variance", description: "Squared measure of variability", units: "X² units", typicalRange: "Varies", notes: "Always non-negative"),
                FormulaVariable(symbol: "X_i", name: "Observation", description: "Individual data value", units: "Varies", typicalRange: "Varies", notes: "Sample data point"),
                FormulaVariable(symbol: "\\bar{X}", name: "Sample Mean", description: "Average of observations", units: "Same as X", typicalRange: "Varies", notes: "Central value"),
                FormulaVariable(symbol: "n", name: "Sample Size", description: "Number of observations", units: "Count", typicalRange: "5-1000+", notes: "Use n-1 for unbiased estimate")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation for many statistical measures"],
            examples: [],
            relatedFormulas: ["standard-deviation", "coefficient-of-variation"],
            tags: ["variance", "dispersion", "risk-measure"]
        )
    }
    
    func createVARModelFormula() -> FormulaReference {
        FormulaReference(name: "Vector Autoregression", category: .quantitative, level: .levelII, mainFormula: "\\mathbf{y}_t = \\mathbf{A}_1 \\mathbf{y}_{t-1} + \\cdots + \\mathbf{A}_p \\mathbf{y}_{t-p} + \\mathbf{u}_t", description: "Vector autoregression model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["var"])
    }
    
    // MARK: - Options and Derivatives Formulas
    
    func createBlackScholesCallFormula() -> FormulaReference {
        FormulaReference(
            name: "Black-Scholes Call Option",
            category: .derivatives,
            level: .levelII,
            mainFormula: "C = S_0 e^{-qT} N(d_1) - X e^{-rT} N(d_2)",
            description: "Fair value of European call option",
            variables: [
                FormulaVariable(symbol: "C", name: "Call Option Price", description: "Present value of call option", units: "Currency", typicalRange: "$0.10-$50", notes: "Intrinsic + time value"),
                FormulaVariable(symbol: "S_0", name: "Current Stock Price", description: "Current price of underlying", units: "Currency", typicalRange: "$10-$500", notes: "Spot price"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Exercise price of option", units: "Currency", typicalRange: "$10-$500", notes: "Fixed exercise price"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded rate", units: "Percentage", typicalRange: "1%-8%", notes: "Government bond rate"),
                FormulaVariable(symbol: "q", name: "Dividend Yield", description: "Continuous dividend yield", units: "Percentage", typicalRange: "0%-5%", notes: "Annual dividend yield"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time until option expires", units: "Years", typicalRange: "0.01-2", notes: "Remaining option life"),
                FormulaVariable(symbol: "N(d)", name: "Cumulative Normal", description: "Standard normal CDF", units: "Probability", typicalRange: "0-1", notes: "Risk-neutral probability")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Assumes constant volatility and interest rates"],
            examples: [],
            relatedFormulas: ["black-scholes-put", "greeks", "binomial-model"],
            tags: ["black-scholes", "call-option", "european-option"]
        )
    }
    
    func createBlackScholesPutFormula() -> FormulaReference {
        FormulaReference(
            name: "Black-Scholes Put Option",
            category: .derivatives,
            level: .levelII,
            mainFormula: "P = X e^{-rT} N(-d_2) - S_0 e^{-qT} N(-d_1)",
            description: "Fair value of European put option",
            variables: [
                FormulaVariable(symbol: "P", name: "Put Option Price", description: "Present value of put option", units: "Currency", typicalRange: "$0.10-$50", notes: "Intrinsic + time value"),
                FormulaVariable(symbol: "S_0", name: "Current Stock Price", description: "Current price of underlying", units: "Currency", typicalRange: "$10-$500", notes: "Spot price"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Exercise price of option", units: "Currency", typicalRange: "$10-$500", notes: "Fixed exercise price"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded rate", units: "Percentage", typicalRange: "1%-8%", notes: "Government bond rate"),
                FormulaVariable(symbol: "q", name: "Dividend Yield", description: "Continuous dividend yield", units: "Percentage", typicalRange: "0%-5%", notes: "Annual dividend yield"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Time until option expires", units: "Years", typicalRange: "0.01-2", notes: "Remaining option life"),
                FormulaVariable(symbol: "N(-d)", name: "Cumulative Normal", description: "Standard normal CDF", units: "Probability", typicalRange: "0-1", notes: "Complement probability")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["European exercise only, no early exercise"],
            examples: [],
            relatedFormulas: ["black-scholes-call", "put-call-parity"],
            tags: ["black-scholes", "put-option", "european-option"]
        )
    }
    
    func createPutCallParityFormula() -> FormulaReference {
        FormulaReference(
            name: "Put-Call Parity",
            category: .derivatives,
            level: .levelI,
            mainFormula: "C + \\frac{X}{e^{rT}} = P + S_0",
            description: "Arbitrage relationship between puts and calls",
            variables: [
                FormulaVariable(symbol: "C", name: "Call Option Price", description: "European call option value", units: "Currency", typicalRange: "$0.10-$50", notes: "Current call price"),
                FormulaVariable(symbol: "P", name: "Put Option Price", description: "European put option value", units: "Currency", typicalRange: "$0.10-$50", notes: "Current put price"),
                FormulaVariable(symbol: "S_0", name: "Current Stock Price", description: "Current price of underlying", units: "Currency", typicalRange: "$10-$500", notes: "Spot price"),
                FormulaVariable(symbol: "X", name: "Strike Price", description: "Common exercise price", units: "Currency", typicalRange: "$10-$500", notes: "Same for both options"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded rate", units: "Percentage", typicalRange: "1%-8%", notes: "Government bond rate"),
                FormulaVariable(symbol: "T", name: "Time to Expiration", description: "Common expiration time", units: "Years", typicalRange: "0.01-2", notes: "Same for both options")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Only applies to European options"],
            examples: [],
            relatedFormulas: ["black-scholes-call", "black-scholes-put"],
            tags: ["put-call-parity", "arbitrage", "european-options"]
        )
    }
    
    func createBinomialModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Binomial Option Pricing Model",
            category: .derivatives,
            level: .levelII,
            mainFormula: "C = \\frac{\\pi C_u + (1-\\pi) C_d}{1+r}",
            description: "Discrete-time option pricing model",
            variables: [
                FormulaVariable(symbol: "C", name: "Option Value", description: "Current option value", units: "Currency", typicalRange: "$0.10-$50", notes: "Weighted average of future values"),
                FormulaVariable(symbol: "C_u", name: "Up State Value", description: "Option value if stock goes up", units: "Currency", typicalRange: "$0-$100", notes: "Max(S_u - X, 0) for calls"),
                FormulaVariable(symbol: "C_d", name: "Down State Value", description: "Option value if stock goes down", units: "Currency", typicalRange: "$0-$100", notes: "Max(S_d - X, 0) for calls"),
                FormulaVariable(symbol: "\\pi", name: "Risk-Neutral Probability", description: "Probability of up movement", units: "Probability", typicalRange: "0.3-0.7", notes: "π = (e^rΔt - d)/(u - d)"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Period risk-free rate", units: "Percentage", typicalRange: "1%-8%", notes: "Per period rate"),
                FormulaVariable(symbol: "u", name: "Up Factor", description: "Stock price up multiplier", units: "Ratio", typicalRange: "1.1-1.5", notes: "S_u = S_0 × u"),
                FormulaVariable(symbol: "d", name: "Down Factor", description: "Stock price down multiplier", units: "Ratio", typicalRange: "0.7-0.9", notes: "S_d = S_0 × d")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Can handle American options with early exercise"],
            examples: [],
            relatedFormulas: ["black-scholes", "american-options"],
            tags: ["binomial-model", "discrete-time", "american-options"]
        )
    }
    
    func createFuturesPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Futures Pricing",
            category: .derivatives,
            level: .levelI,
            mainFormula: "F_0 = S_0 e^{(r-q)T}",
            description: "Fair value of futures contract",
            variables: [
                FormulaVariable(symbol: "F_0", name: "Futures Price", description: "Fair futures price at initiation", units: "Currency", typicalRange: "Near spot price", notes: "No-arbitrage price"),
                FormulaVariable(symbol: "S_0", name: "Current Spot Price", description: "Current price of underlying", units: "Currency", typicalRange: "$10-$500", notes: "Market price today"),
                FormulaVariable(symbol: "r", name: "Risk-Free Rate", description: "Continuously compounded rate", units: "Percentage", typicalRange: "1%-8%", notes: "Government bond rate"),
                FormulaVariable(symbol: "q", name: "Convenience Yield", description: "Benefit of holding physical asset", units: "Percentage", typicalRange: "0%-5%", notes: "Storage costs minus benefits"),
                FormulaVariable(symbol: "T", name: "Time to Maturity", description: "Time until futures delivery", units: "Years", typicalRange: "0.01-2", notes: "Contract maturity")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Daily marking-to-market differentiates from forwards"],
            examples: [],
            relatedFormulas: ["forward-pricing", "cost-of-carry"],
            tags: ["futures-pricing", "no-arbitrage", "cost-of-carry"]
        )
    }
    
    // MARK: - Advanced Fixed Income Formulas
    
    func createSpotRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Spot Rate (Zero-Coupon Rate)",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "P = \\frac{M}{(1+s_n)^n}",
            description: "Interest rate for zero-coupon bond",
            variables: [
                FormulaVariable(symbol: "P", name: "Bond Price", description: "Current price of zero-coupon bond", units: "Currency", typicalRange: "$300-$950", notes: "Always below par for positive rates"),
                FormulaVariable(symbol: "M", name: "Maturity Value", description: "Face value at maturity", units: "Currency", typicalRange: "$1000", notes: "Par value"),
                FormulaVariable(symbol: "s_n", name: "Spot Rate", description: "Zero-coupon rate for maturity n", units: "Percentage", typicalRange: "1%-10%", notes: "Pure interest rate"),
                FormulaVariable(symbol: "n", name: "Time to Maturity", description: "Years until maturity", units: "Years", typicalRange: "0.25-30", notes: "Time periods")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation for yield curve construction"],
            examples: [],
            relatedFormulas: ["forward-rate", "yield-curve"],
            tags: ["spot-rate", "zero-coupon", "yield-curve"]
        )
    }
    
    func createForwardRateFormula() -> FormulaReference {
        FormulaReference(
            name: "Forward Interest Rate",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "f_{t,T} = \\frac{(1+s_T)^T}{(1+s_t)^t} - 1",
            description: "Expected future short-term interest rate",
            variables: [
                FormulaVariable(symbol: "f_{t,T}", name: "Forward Rate", description: "Rate from time t to T", units: "Percentage", typicalRange: "1%-12%", notes: "Implied future rate"),
                FormulaVariable(symbol: "s_T", name: "Long-term Spot Rate", description: "Spot rate for longer maturity", units: "Percentage", typicalRange: "2%-8%", notes: "Current long rate"),
                FormulaVariable(symbol: "s_t", name: "Short-term Spot Rate", description: "Spot rate for shorter maturity", units: "Percentage", typicalRange: "1%-6%", notes: "Current short rate"),
                FormulaVariable(symbol: "T", name: "Long Maturity", description: "Longer time period", units: "Years", typicalRange: "2-30", notes: "End of forward period"),
                FormulaVariable(symbol: "t", name: "Short Maturity", description: "Shorter time period", units: "Years", typicalRange: "0.25-10", notes: "Start of forward period")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Derived from no-arbitrage conditions"],
            examples: [],
            relatedFormulas: ["spot-rate", "expectations-theory"],
            tags: ["forward-rate", "expectations", "yield-curve"]
        )
    }
    
    func createParYieldFormula() -> FormulaReference {
        FormulaReference(
            name: "Par Yield (Par Rate)",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "\\text{Par Yield} = \\frac{1 - \\frac{1}{(1+s_n)^n}}{\\sum_{t=1}^{n} \\frac{1}{(1+s_t)^t}}",
            description: "Coupon rate that makes bond trade at par",
            variables: [
                FormulaVariable(symbol: "\\text{Par Yield}", name: "Par Yield", description: "Coupon rate for par bond", units: "Percentage", typicalRange: "1%-8%", notes: "Makes bond price = 100"),
                FormulaVariable(symbol: "s_t", name: "Spot Rate", description: "Zero-coupon rate for period t", units: "Percentage", typicalRange: "1%-10%", notes: "Discount rate for period t"),
                FormulaVariable(symbol: "s_n", name: "Terminal Spot Rate", description: "Spot rate for final maturity", units: "Percentage", typicalRange: "2%-8%", notes: "Discount rate for principal"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Bond maturity in periods", units: "Periods", typicalRange: "2-60", notes: "Coupon payment periods")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in yield curve construction"],
            examples: [],
            relatedFormulas: ["spot-rate", "yield-curve"],
            tags: ["par-yield", "par-rate", "yield-curve"]
        )
    }
    
    // MARK: - Real Estate Investment Formulas
    
    func createDirectCapitalizationFormula() -> FormulaReference {
        FormulaReference(
            name: "Direct Capitalization Method",
            category: .alternatives,
            level: .levelI,
            mainFormula: "V = \\frac{NOI}{Cap\\,Rate}",
            description: "Real estate valuation using cap rates",
            variables: [
                FormulaVariable(symbol: "V", name: "Property Value", description: "Estimated value of property", units: "Currency", typicalRange: "$100K-$100M", notes: "Market value estimate"),
                FormulaVariable(symbol: "NOI", name: "Net Operating Income", description: "Annual net operating income", units: "Currency", typicalRange: "$10K-$10M", notes: "After operating expenses"),
                FormulaVariable(symbol: "Cap\\,Rate", name: "Capitalization Rate", description: "Market cap rate for property type", units: "Percentage", typicalRange: "3%-12%", notes: "Risk-adjusted return rate")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Quick valuation method for income properties"],
            examples: [],
            relatedFormulas: ["dcf", "noi"],
            tags: ["cap-rate", "real-estate", "income-approach"]
        )
    }
    
    func createNOIFormula() -> FormulaReference {
        FormulaReference(
            name: "Net Operating Income (NOI)",
            category: .alternatives,
            level: .levelI,
            mainFormula: "NOI = \\text{Rental Income} - \\text{Operating Expenses}",
            description: "Income after operating expenses but before financing",
            variables: [
                FormulaVariable(symbol: "NOI", name: "Net Operating Income", description: "Operating income after expenses", units: "Currency", typicalRange: "$10K-$10M", notes: "Before debt service"),
                FormulaVariable(symbol: "\\text{Rental Income}", name: "Gross Rental Income", description: "Total rental receipts", units: "Currency", typicalRange: "$20K-$20M", notes: "Effective gross income"),
                FormulaVariable(symbol: "\\text{Operating Expenses}", name: "Operating Expenses", description: "Property operating costs", units: "Currency", typicalRange: "$5K-$5M", notes: "Excludes debt service and taxes")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation for most real estate valuation methods"],
            examples: [],
            relatedFormulas: ["cap-rate", "dcf"],
            tags: ["noi", "real-estate", "operating-income"]
        )
    }
    
    func createVECMModelFormula() -> FormulaReference {
        FormulaReference(name: "Vector Error Correction Model", category: .quantitative, level: .levelII, mainFormula: "\\text{VECM}", description: "Error correction model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["vecm"])
    }
    
    // MARK: - Remaining Critical CFA Formulas
    
    func createNormalDistributionFormula() -> FormulaReference {
        FormulaReference(
            name: "Normal Distribution",
            category: .quantitative,
            level: .levelI,
            mainFormula: "f(x) = \\frac{1}{\\sigma\\sqrt{2\\pi}} e^{-\\frac{(x-\\mu)^2}{2\\sigma^2}}",
            description: "Probability density function of normal distribution, fundamental to statistical inference and risk modeling",
            variables: [
                FormulaVariable(
                    symbol: "f(x)",
                    name: "Probability Density",
                    description: "Height of the normal curve at value x",
                    units: "Density (probability per unit)",
                    typicalRange: "0 to maximum at μ",
                    notes: "Not a probability itself, but used to calculate probabilities over intervals"
                ),
                FormulaVariable(
                    symbol: "x",
                    name: "Random Variable",
                    description: "Value for which we calculate the probability density",
                    units: "Same as distribution (returns, prices, etc.)",
                    typicalRange: "-∞ to +∞",
                    notes: "Can take any real value in a normal distribution"
                ),
                FormulaVariable(
                    symbol: "\\mu",
                    name: "Population Mean",
                    description: "Center of the normal distribution",
                    units: "Same as random variable",
                    typicalRange: "Any real number",
                    notes: "Determines location of the distribution peak"
                ),
                FormulaVariable(
                    symbol: "\\sigma",
                    name: "Population Standard Deviation",
                    description: "Measure of spread in the normal distribution",
                    units: "Same as random variable",
                    typicalRange: "Always positive",
                    notes: "Determines width of the distribution curve"
                ),
                FormulaVariable(
                    symbol: "\\pi",
                    name: "Pi",
                    description: "Mathematical constant approximately 3.14159",
                    units: "Dimensionless",
                    typicalRange: "3.14159...",
                    notes: "Appears in the normalization constant"
                ),
                FormulaVariable(
                    symbol: "e",
                    name: "Euler's Number",
                    description: "Mathematical constant approximately 2.71828",
                    units: "Dimensionless",
                    typicalRange: "2.71828...",
                    notes: "Base of natural logarithm in the exponential function"
                )
            ],
            derivation: FormulaDerivation(
                title: "Normal Distribution Properties",
                steps: [
                    DerivationStep(
                        stepNumber: 1,
                        description: "Normalization requirement",
                        formula: "\\int_{-\\infty}^{\\infty} f(x) dx = 1",
                        explanation: "Total area under the curve must equal 1 (certainty)"
                    ),
                    DerivationStep(
                        stepNumber: 2,
                        description: "Symmetric bell curve centered at μ",
                        formula: "f(\\mu + a) = f(\\mu - a)",
                        explanation: "Distribution is symmetric around the mean"
                    ),
                    DerivationStep(
                        stepNumber: 3,
                        description: "68-95-99.7 rule",
                        formula: "P(\\mu - \\sigma < X < \\mu + \\sigma) \\approx 0.68",
                        explanation: "About 68% of values lie within 1 standard deviation of mean"
                    ),
                    DerivationStep(
                        stepNumber: 4,
                        description: "Standard normal transformation",
                        formula: "Z = \\frac{X - \\mu}{\\sigma} \\sim N(0,1)",
                        explanation: "Any normal distribution can be standardized"
                    )
                ],
                assumptions: [
                    "Data follows a continuous distribution",
                    "Distribution is symmetric around the mean",
                    "Tails extend to infinity in both directions"
                ],
                notes: "The normal distribution is completely characterized by its mean and standard deviation"
            ),
            variants: [
                FormulaVariant(
                    name: "Standard Normal Distribution",
                    formula: "f(z) = \\frac{1}{\\sqrt{2\\pi}} e^{-\\frac{z^2}{2}}",
                    description: "Normal distribution with μ = 0 and σ = 1",
                    whenToUse: "For standardized calculations and z-score applications"
                ),
                FormulaVariant(
                    name: "Cumulative Distribution Function",
                    formula: "F(x) = P(X \\leq x) = \\int_{-\\infty}^{x} f(t) dt",
                    description: "Probability that X is less than or equal to x",
                    whenToUse: "For calculating actual probabilities over ranges"
                ),
                FormulaVariant(
                    name: "Z-Score Transformation",
                    formula: "Z = \\frac{X - \\mu}{\\sigma}",
                    description: "Standardization formula for normal variables",
                    whenToUse: "Converting to standard normal for table lookup"
                )
            ],
            usageNotes: [
                "Foundation of statistical inference and hypothesis testing",
                "Central Limit Theorem ensures sample means are approximately normal",
                "Used extensively in portfolio theory for modeling asset returns",
                "Key assumption in many CFA Level I statistical tests",
                "Probability calculations require integration (use tables or technology)",
                "68-95-99.7 rule applies to all normal distributions"
            ],
            examples: [
                FormulaExample(
                    title: "Stock Return Distribution",
                    description: "Annual stock returns follow normal distribution with μ = 8% and σ = 15%",
                    inputs: [
                        "Mean return (μ)": "8%",
                        "Standard deviation (σ)": "15%",
                        "Find f(x) at": "x = 8% (the mean)"
                    ],
                    calculation: "f(8%) = (1/(15%×√(2π))) × e^(-((8%-8%)²)/(2×(15%)²)) = (1/(15%×√(2π))) × e^0 = 1/(15%×√(2π)) ≈ 2.66",
                    result: "f(8%) ≈ 2.66 density units",
                    interpretation: "Highest probability density occurs at the mean return of 8%"
                ),
                FormulaExample(
                    title: "Risk Assessment Application",
                    description: "Using normal distribution to assess probability of losses",
                    inputs: [
                        "Portfolio return μ": "10%",
                        "Portfolio volatility σ": "20%",
                        "Loss threshold": "0% return"
                    ],
                    calculation: "Z = (0% - 10%)/20% = -0.50. P(X < 0%) = P(Z < -0.50) ≈ 0.31",
                    result: "Probability of loss ≈ 31%",
                    interpretation: "About 31% chance of negative returns given normal distribution assumption"
                )
            ],
            relatedFormulas: ["central-limit-theorem", "confidence-interval", "hypothesis-testing"],
            tags: ["normal-distribution", "probability", "statistics", "risk-modeling", "cfa-level-i"]
        )
    }
    
    func createTDistributionFormula() -> FormulaReference {
        FormulaReference(
            name: "t-Distribution",
            category: .quantitative,
            level: .levelI,
            mainFormula: "t = \\frac{\\bar{X} - \\mu}{s/\\sqrt{n}}",
            description: "Student's t-distribution for small samples",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used when population standard deviation is unknown"],
            examples: [],
            relatedFormulas: ["confidence-interval", "hypothesis-testing"],
            tags: ["t-distribution", "small-sample", "statistics"]
        )
    }
    
    func createChiSquaredDistributionFormula() -> FormulaReference {
        FormulaReference(
            name: "Chi-Squared Distribution",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\chi^2 = \\sum_{i=1}^{n} \\frac{(O_i - E_i)^2}{E_i}",
            description: "Test statistic for goodness of fit",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Tests independence and goodness of fit"],
            examples: [],
            relatedFormulas: ["goodness-of-fit", "independence-test"],
            tags: ["chi-squared", "hypothesis-testing", "goodness-of-fit"]
        )
    }
    
    func createFDistributionFormula() -> FormulaReference {
        FormulaReference(
            name: "F-Distribution",
            category: .quantitative,
            level: .levelI,
            mainFormula: "F = \\frac{s_1^2}{s_2^2}",
            description: "Ratio of two sample variances",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Tests equality of variances"],
            examples: [],
            relatedFormulas: ["anova", "variance-test"],
            tags: ["f-distribution", "variance-ratio", "hypothesis-testing"]
        )
    }
    
    func createConfidenceIntervalFormula() -> FormulaReference {
        FormulaReference(
            name: "Confidence Interval",
            category: .quantitative,
            level: .levelI,
            mainFormula: "CI = \\bar{X} \\pm Z_{\\alpha/2} \\cdot \\frac{\\sigma}{\\sqrt{n}}",
            description: "Interval estimate for population parameter",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Provides range of plausible values"],
            examples: [],
            relatedFormulas: ["normal-distribution", "t-distribution"],
            tags: ["confidence-interval", "interval-estimation", "statistics"]
        )
    }
    
    func createOneSampleTTestFormula() -> FormulaReference {
        FormulaReference(
            name: "One-Sample t-Test",
            category: .quantitative,
            level: .levelI,
            mainFormula: "t = \\frac{\\bar{X} - \\mu_0}{s/\\sqrt{n}}",
            description: "Test if sample mean differs from hypothesized value",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Tests population mean with unknown variance"],
            examples: [],
            relatedFormulas: ["t-distribution", "hypothesis-testing"],
            tags: ["one-sample-t-test", "hypothesis-testing", "mean-test"]
        )
    }
    
    func createTwoSampleTTestFormula() -> FormulaReference {
        FormulaReference(
            name: "Two-Sample t-Test",
            category: .quantitative,
            level: .levelI,
            mainFormula: "t = \\frac{\\bar{X}_1 - \\bar{X}_2}{s_p\\sqrt{\\frac{1}{n_1} + \\frac{1}{n_2}}}",
            description: "Test if two sample means are significantly different",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Compares means of two independent samples"],
            examples: [],
            relatedFormulas: ["pooled-variance", "hypothesis-testing"],
            tags: ["two-sample-t-test", "mean-comparison", "hypothesis-testing"]
        )
    }
    
    func createChiSquaredTestFormula() -> FormulaReference {
        FormulaReference(
            name: "Chi-Squared Test",
            category: .quantitative,
            level: .levelI,
            mainFormula: "\\chi^2 = \\sum \\frac{(O - E)^2}{E}",
            description: "Test for independence or goodness of fit",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Tests categorical data relationships"],
            examples: [],
            relatedFormulas: ["chi-squared-distribution", "contingency-table"],
            tags: ["chi-squared-test", "independence", "categorical-data"]
        )
    }
    
    func createAPTFormula() -> FormulaReference {
        FormulaReference(
            name: "Arbitrage Pricing Theory (APT)",
            category: .portfolio,
            level: .levelII,
            mainFormula: "E(R_i) = \\lambda_0 + \\lambda_1 b_{i1} + \\lambda_2 b_{i2} + \\cdots + \\lambda_k b_{ik}",
            description: "Multi-factor model for expected returns",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Extension of CAPM with multiple risk factors"],
            examples: [],
            relatedFormulas: ["capm", "multi-factor-model"],
            tags: ["apt", "multi-factor", "expected-return"]
        )
    }
    
    func createEfficientFrontierFormula() -> FormulaReference {
        FormulaReference(
            name: "Efficient Frontier",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\min \\sigma_p^2 = w^T \\Sigma w \\text{ subject to } w^T \\mu = \\mu_p",
            description: "Set of optimal portfolios for each risk level",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation of modern portfolio theory"],
            examples: [],
            relatedFormulas: ["markowitz", "portfolio-optimization"],
            tags: ["efficient-frontier", "portfolio-theory", "optimization"]
        )
    }
    
    func createTwoFundSeparationFormula() -> FormulaReference {
        FormulaReference(
            name: "Two-Fund Separation Theorem",
            category: .portfolio,
            level: .levelII,
            mainFormula: "w_p = \\alpha w_A + (1-\\alpha) w_B",
            description: "Any efficient portfolio is combination of two efficient portfolios",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Fundamental result in portfolio theory"],
            examples: [],
            relatedFormulas: ["efficient-frontier", "portfolio-theory"],
            tags: ["two-fund-separation", "portfolio-theory", "efficiency"]
        )
    }
    
    func createRiskBudgetingFormula() -> FormulaReference {
        FormulaReference(
            name: "Risk Budgeting",
            category: .portfolio,
            level: .levelII,
            mainFormula: "RC_i = w_i \\frac{\\partial \\sigma_p}{\\partial w_i}",
            description: "Risk contribution of each asset to portfolio risk",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in risk parity strategies"],
            examples: [],
            relatedFormulas: ["risk-parity", "portfolio-risk"],
            tags: ["risk-budgeting", "risk-contribution", "portfolio-management"]
        )
    }
    
    func createDownsideDeviationFormula() -> FormulaReference {
        FormulaReference(
            name: "Downside Deviation",
            category: .risk,
            level: .levelI,
            mainFormula: "DD = \\sqrt{\\frac{\\sum_{R_i < MAR} (R_i - MAR)^2}{n}}",
            description: "Volatility of negative returns relative to target",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Focuses on downside risk only"],
            examples: [],
            relatedFormulas: ["sortino-ratio", "mar"],
            tags: ["downside-deviation", "downside-risk", "target-return"]
        )
    }
    
    func createCaptureRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Capture Ratio",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\text{Up Capture} = \\frac{\\text{Portfolio Up Return}}{\\text{Benchmark Up Return}}",
            description: "Portfolio's participation in market movements",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures directional performance"],
            examples: [],
            relatedFormulas: ["beta", "tracking-error"],
            tags: ["capture-ratio", "up-capture", "down-capture"]
        )
    }
    
    func createActiveShareFormula() -> FormulaReference {
        FormulaReference(
            name: "Active Share",
            category: .portfolio,
            level: .levelI,
            mainFormula: "\\text{Active Share} = \\frac{1}{2} \\sum_{i=1}^{n} |w_{p,i} - w_{b,i}|",
            description: "Percentage of portfolio differing from benchmark",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures portfolio differentiation"],
            examples: [],
            relatedFormulas: ["tracking-error", "active-management"],
            tags: ["active-share", "active-management", "benchmark-deviation"]
        )
    }
    
    func createImplementationShortfallFormula() -> FormulaReference {
        FormulaReference(
            name: "Implementation Shortfall",
            category: .portfolio,
            level: .levelII,
            mainFormula: "IS = \\text{Paper Portfolio Return} - \\text{Actual Portfolio Return}",
            description: "Cost of implementing investment decisions",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures total trading costs"],
            examples: [],
            relatedFormulas: ["market-impact", "trading-costs"],
            tags: ["implementation-shortfall", "trading-costs", "execution"]
        )
    }
    
    func createResidualIncomeFormula() -> FormulaReference {
        FormulaReference(
            name: "Residual Income Model",
            category: .equity,
            level: .levelII,
            mainFormula: "V_0 = B_0 + \\sum_{t=1}^{\\infty} \\frac{RI_t}{(1+r)^t}",
            description: "Valuation using economic profit",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Economic value added approach"],
            examples: [],
            relatedFormulas: ["eva", "book-value"],
            tags: ["residual-income", "economic-profit", "valuation"]
        )
    }
    
    func createFCFEModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Free Cash Flow to Equity Model",
            category: .equity,
            level: .levelII,
            mainFormula: "V_0 = \\sum_{t=1}^{\\infty} \\frac{FCFE_t}{(1+r)^t}",
            description: "Equity valuation using free cash flows",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Direct equity cash flow approach"],
            examples: [],
            relatedFormulas: ["fcf", "dcf"],
            tags: ["fcfe", "free-cash-flow", "equity-valuation"]
        )
    }
    
    func createFCFFModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Free Cash Flow to Firm Model",
            category: .equity,
            level: .levelII,
            mainFormula: "V_{firm} = \\sum_{t=1}^{\\infty} \\frac{FCFF_t}{(1+WACC)^t}",
            description: "Firm valuation using total free cash flows",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Enterprise value approach"],
            examples: [],
            relatedFormulas: ["wacc", "enterprise-value"],
            tags: ["fcff", "free-cash-flow", "firm-valuation"]
        )
    }
    
    func createHModelFormula() -> FormulaReference {
        FormulaReference(
            name: "H-Model (Two-Stage Growth)",
            category: .equity,
            level: .levelII,
            mainFormula: "P_0 = \\frac{D_1}{r-g_L} + \\frac{D_1 \\cdot H \\cdot (g_S - g_L)}{(r-g_L)^2}",
            description: "DDM with declining growth transition",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Smooth transition between growth phases"],
            examples: [],
            relatedFormulas: ["two-stage-ddm", "gordon-growth"],
            tags: ["h-model", "growth-transition", "ddm"]
        )
    }
    
    func createEVEBITDAFormula() -> FormulaReference {
        FormulaReference(
            name: "EV/EBITDA Multiple",
            category: .equity,
            level: .levelI,
            mainFormula: "\\text{EV/EBITDA} = \\frac{\\text{Enterprise Value}}{\\text{EBITDA}}",
            description: "Enterprise valuation multiple",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Excludes capital structure differences"],
            examples: [],
            relatedFormulas: ["enterprise-value", "ebitda"],
            tags: ["ev-ebitda", "valuation-multiple", "enterprise-value"]
        )
    }
    
    func createDuPontFormula() -> FormulaReference {
        FormulaReference(
            name: "DuPont Analysis",
            category: .equity,
            level: .levelI,
            mainFormula: "ROE = \\frac{\\text{Net Income}}{\\text{Sales}} \\times \\frac{\\text{Sales}}{\\text{Assets}} \\times \\frac{\\text{Assets}}{\\text{Equity}}",
            description: "Decomposition of return on equity",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Identifies sources of profitability"],
            examples: [],
            relatedFormulas: ["roe", "profit-margin", "asset-turnover"],
            tags: ["dupont", "roe-decomposition", "profitability-analysis"]
        )
    }
    
    func createMultipleRegressionDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Multiple Regression", category: .quantitative, level: .levelI, mainFormula: "y = \\beta_0 + \\beta_1 x_1 + \\beta_2 x_2 + \\cdots + \\beta_k x_k + \\epsilon", description: "Multiple regression model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regression"])
    }
    
    // MARK: - Additional Critical CFA Formulas
    
    func createPutCallParityExactFormula() -> FormulaReference {
        FormulaReference(
            name: "Put-Call Parity (Exact)",
            category: .derivatives,
            level: .levelI,
            mainFormula: "C + X e^{-rT} = P + S_0 e^{-qT}",
            description: "Exact arbitrage relationship with dividends",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Includes dividend adjustments"],
            examples: [],
            relatedFormulas: ["put-call-parity", "arbitrage"],
            tags: ["put-call-parity", "arbitrage", "dividends"]
        )
    }
    
    func createGreeksCollectionFormula() -> FormulaReference {
        FormulaReference(
            name: "Option Greeks Collection",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\Delta, \\Gamma, \\Theta, \\text{Vega}, \\text{Rho}",
            description: "Complete set of option risk sensitivities",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Essential for options risk management"],
            examples: [],
            relatedFormulas: ["black-scholes", "delta-hedging"],
            tags: ["greeks", "option-sensitivities", "risk-management"]
        )
    }
    
    func createBarrierOptionsFormula() -> FormulaReference {
        FormulaReference(
            name: "Barrier Options",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Barrier Option Value} = f(S, K, B, r, \\sigma, T)",
            description: "Options with path-dependent payoffs",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Knock-in and knock-out features"],
            examples: [],
            relatedFormulas: ["exotic-options", "path-dependent"],
            tags: ["barrier-options", "exotic-options", "path-dependent"]
        )
    }
    
    func createCDSPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Credit Default Swap Pricing",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{CDS Spread} = \\frac{\\text{Expected Loss}}{\\text{RPV01}}",
            description: "Credit protection pricing model",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Credit risk transfer instrument"],
            examples: [],
            relatedFormulas: ["credit-risk", "default-probability"],
            tags: ["cds", "credit-derivatives", "default-risk"]
        )
    }
    
    func createInterestRateSwapValuationFormula() -> FormulaReference {
        FormulaReference(
            name: "Interest Rate Swap Valuation",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Swap Value} = \\text{Fixed Leg PV} - \\text{Floating Leg PV}",
            description: "Mark-to-market value of interest rate swap",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Interest rate risk management"],
            examples: [],
            relatedFormulas: ["present-value", "yield-curve"],
            tags: ["interest-rate-swap", "fixed-income", "valuation"]
        )
    }
    
    func createCurrencySwapFormula() -> FormulaReference {
        FormulaReference(
            name: "Currency Swap",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Currency Swap Value} = S_0 \\cdot PV_{foreign} - PV_{domestic}",
            description: "Multi-currency swap valuation",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Currency and interest rate risk management"],
            examples: [],
            relatedFormulas: ["fx-forward", "interest-rate-swap"],
            tags: ["currency-swap", "fx-derivatives", "multi-currency"]
        )
    }
    
    func createOptimalHedgeRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Optimal Hedge Ratio",
            category: .derivatives,
            level: .levelII,
            mainFormula: "h^* = \\rho \\frac{\\sigma_S}{\\sigma_F}",
            description: "Minimum variance hedge ratio",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Risk minimization through hedging"],
            examples: [],
            relatedFormulas: ["correlation", "variance-minimization"],
            tags: ["hedge-ratio", "risk-management", "hedging"]
        )
    }
    
    func createDeltaHedgingFormula() -> FormulaReference {
        FormulaReference(
            name: "Delta Hedging",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Hedge Shares} = -\\Delta \\times \\text{Options Held}",
            description: "Delta-neutral portfolio construction",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Dynamic hedging strategy"],
            examples: [],
            relatedFormulas: ["delta", "portfolio-insurance"],
            tags: ["delta-hedging", "dynamic-hedging", "risk-neutral"]
        )
    }
    
    func createSpotRateBootstrappingFormula() -> FormulaReference {
        FormulaReference(
            name: "Spot Rate Bootstrapping",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "s_n = \\left(\\frac{\\text{Par Value}}{\\text{Bond Price} - \\sum \\text{PV of Coupons}}\\right)^{1/n} - 1",
            description: "Construction of zero-coupon yield curve",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Sequential extraction of spot rates"],
            examples: [],
            relatedFormulas: ["spot-rate", "yield-curve"],
            tags: ["bootstrapping", "spot-rates", "yield-curve"]
        )
    }
    
    func createYieldCurveConstructionFormula() -> FormulaReference {
        FormulaReference(
            name: "Yield Curve Construction",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Yield Curve} = f(\\text{Bootstrapping, Interpolation, Smoothing})",
            description: "Complete yield curve methodology",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation for bond pricing"],
            examples: [],
            relatedFormulas: ["bootstrapping", "interpolation"],
            tags: ["yield-curve", "term-structure", "fixed-income"]
        )
    }
    
    func createForwardRateNoArbitrageFormula() -> FormulaReference {
        FormulaReference(
            name: "Forward Rate (No-Arbitrage)",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "(1+s_T)^T = (1+s_t)^t \\times (1+f_{t,T})^{T-t}",
            description: "No-arbitrage forward rate relationship",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Pure expectations theory"],
            examples: [],
            relatedFormulas: ["spot-rate", "arbitrage-free"],
            tags: ["forward-rate", "no-arbitrage", "expectations"]
        )
    }
    
    func createOptionAdjustedSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "Option-Adjusted Spread (OAS)",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{OAS} = \\text{Z-spread} - \\text{Option Value}",
            description: "Credit spread after removing embedded option value",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Callable and putable bond analysis"],
            examples: [],
            relatedFormulas: ["z-spread", "embedded-options"],
            tags: ["oas", "embedded-options", "credit-spread"]
        )
    }
    
    func createBondConvexityAdjustedFormula() -> FormulaReference {
        FormulaReference(
            name: "Convexity-Adjusted Bond Price",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "\\Delta P = -D_{mod} \\cdot \\Delta y + \\frac{1}{2} C \\cdot (\\Delta y)^2",
            description: "Second-order bond price approximation",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Improves duration estimates for large yield changes"],
            examples: [],
            relatedFormulas: ["modified-duration", "convexity"],
            tags: ["convexity-adjustment", "bond-pricing", "yield-sensitivity"]
        )
    }
    
    func createKeyRateDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Key Rate Duration",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "KRD_i = -\\frac{1}{P} \\frac{\\Delta P}{\\Delta r_i}",
            description: "Price sensitivity to specific maturity rates",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Risk management for yield curve shifts"],
            examples: [],
            relatedFormulas: ["duration", "yield-curve-risk"],
            tags: ["key-rate-duration", "yield-curve-risk", "interest-rate-risk"]
        )
    }
    
    func createMoneyDurationFormula() -> FormulaReference {
        FormulaReference(
            name: "Money Duration",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "\\text{Money Duration} = D_{mod} \\times P \\times 0.01",
            description: "Dollar change in bond value per 1bp yield change",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Practical risk measure in dollar terms"],
            examples: [],
            relatedFormulas: ["modified-duration", "dv01"],
            tags: ["money-duration", "dollar-duration", "interest-rate-risk"]
        )
    }
    
    func createDurationMatchingFormula() -> FormulaReference {
        FormulaReference(
            name: "Duration Matching",
            category: .fixedIncome,
            level: .levelI,
            mainFormula: "D_{portfolio} = \\sum w_i D_i = D_{liability}",
            description: "Immunization strategy using duration",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Asset-liability matching technique"],
            examples: [],
            relatedFormulas: ["immunization", "asset-liability-management"],
            tags: ["duration-matching", "immunization", "alm"]
        )
    }
    
    func createAbsolutePPPFormula() -> FormulaReference {
        FormulaReference(
            name: "Absolute Purchasing Power Parity",
            category: .economics,
            level: .levelI,
            mainFormula: "S = \\frac{P_{domestic}}{P_{foreign}}",
            description: "Exchange rate based on price level comparison",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Long-run exchange rate determination"],
            examples: [],
            relatedFormulas: ["relative-ppp", "exchange-rates"],
            tags: ["absolute-ppp", "exchange-rates", "price-levels"]
        )
    }
    
    func createRelativePPPFormula() -> FormulaReference {
        FormulaReference(
            name: "Relative Purchasing Power Parity",
            category: .economics,
            level: .levelI,
            mainFormula: "\\frac{S_1}{S_0} = \\frac{1 + \\pi_{domestic}}{1 + \\pi_{foreign}}",
            description: "Exchange rate changes based on inflation differentials",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Short to medium-term exchange rate forecasting"],
            examples: [],
            relatedFormulas: ["absolute-ppp", "fisher-effect"],
            tags: ["relative-ppp", "inflation", "exchange-rates"]
        )
    }
    
    func createInternationalFisherEffectFormula() -> FormulaReference {
        FormulaReference(
            name: "International Fisher Effect",
            category: .economics,
            level: .levelI,
            mainFormula: "\\frac{S_1}{S_0} = \\frac{1 + r_{domestic}}{1 + r_{foreign}}",
            description: "Exchange rate changes based on interest rate differentials",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Links exchange rates to interest rates"],
            examples: [],
            relatedFormulas: ["fisher-effect", "uncovered-interest-parity"],
            tags: ["international-fisher-effect", "exchange-rates", "interest-rates"]
        )
    }
    
    func createCobbDouglasProductionFormula() -> FormulaReference {
        FormulaReference(
            name: "Cobb-Douglas Production Function",
            category: .economics,
            level: .levelI,
            mainFormula: "Y = A K^{\\alpha} L^{\\beta}",
            description: "Neoclassical production function",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Models output as function of inputs"],
            examples: [],
            relatedFormulas: ["growth-accounting", "productivity"],
            tags: ["cobb-douglas", "production-function", "economic-growth"]
        )
    }
    
    func createGrowthAccountingFormula() -> FormulaReference {
        FormulaReference(
            name: "Growth Accounting Equation",
            category: .economics,
            level: .levelI,
            mainFormula: "\\frac{\\Delta Y}{Y} = \\frac{\\Delta A}{A} + \\alpha \\frac{\\Delta K}{K} + \\beta \\frac{\\Delta L}{L}",
            description: "Decomposition of economic growth",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Identifies sources of growth"],
            examples: [],
            relatedFormulas: ["solow-model", "productivity"],
            tags: ["growth-accounting", "economic-growth", "productivity"]
        )
    }
    
    func createEndogenousGrowthModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Endogenous Growth Model",
            category: .economics,
            level: .levelII,
            mainFormula: "g = s \\cdot A - \\delta",
            description: "Growth model with endogenous technological progress",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Long-run growth theory"],
            examples: [],
            relatedFormulas: ["solow-model", "human-capital"],
            tags: ["endogenous-growth", "technological-progress", "long-run-growth"]
        )
    }
    
    func createContangoBackwardationBasicFormula() -> FormulaReference {
        FormulaReference(
            name: "Contango and Backwardation (Basic)",
            category: .derivatives,
            level: .levelI,
            mainFormula: "\\text{Contango: } F_0 > S_0, \\text{ Backwardation: } F_0 < S_0",
            description: "Futures curve shape relative to spot prices",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Commodity futures market structure"],
            examples: [],
            relatedFormulas: ["futures-pricing", "cost-of-carry"],
            tags: ["contango", "backwardation", "futures-curve"]
        )
    }
    
    func createConvenienceYieldFormula() -> FormulaReference {
        FormulaReference(
            name: "Convenience Yield",
            category: .derivatives,
            level: .levelI,
            mainFormula: "c = r + u - \\frac{\\ln(F_0/S_0)}{T}",
            description: "Benefit from holding physical commodity",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Explains backwardation in commodity markets"],
            examples: [],
            relatedFormulas: ["cost-of-carry", "storage-costs"],
            tags: ["convenience-yield", "commodity-markets", "storage"]
        )
    }
    
    func createStorageCostFormula() -> FormulaReference {
        FormulaReference(
            name: "Storage Cost Model",
            category: .derivatives,
            level: .levelI,
            mainFormula: "F_0 = S_0 e^{(r+u-c)T}",
            description: "Futures pricing with storage costs and convenience yield",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Complete commodity futures pricing"],
            examples: [],
            relatedFormulas: ["convenience-yield", "cost-of-carry"],
            tags: ["storage-costs", "commodity-futures", "cost-of-carry"]
        )
    }
    
    func createRSquaredAdjustedFormula() -> FormulaReference {
        FormulaReference(name: "Adjusted R-Squared", category: .quantitative, level: .levelI, mainFormula: "R_{adj}^2 = 1 - \\frac{(1-R^2)(n-1)}{n-k-1}", description: "Adjusted coefficient of determination", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["r-squared"])
    }
    
    func createFTestRegressionFormula() -> FormulaReference {
        FormulaReference(name: "F-Test for Regression", category: .quantitative, level: .levelI, mainFormula: "F = \\frac{MSR}{MSE}", description: "Overall regression significance test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["f-test"])
    }
    
    func createTTestRegressionFormula() -> FormulaReference {
        FormulaReference(name: "t-Test for Regression", category: .quantitative, level: .levelI, mainFormula: "t = \\frac{\\hat{\\beta} - \\beta_0}{SE(\\hat{\\beta})}", description: "Coefficient significance test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["t-test"])
    }
    
    func createBreuschPaganTestFormula() -> FormulaReference {
        FormulaReference(name: "Breusch-Pagan Test", category: .quantitative, level: .levelII, mainFormula: "\\text{BP Test}", description: "Heteroscedasticity test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["heteroscedasticity"])
    }
    
    func createDurbinWatsonTestFormula() -> FormulaReference {
        FormulaReference(name: "Durbin-Watson Test", category: .quantitative, level: .levelII, mainFormula: "DW = \\frac{\\sum_{t=2}^n (e_t - e_{t-1})^2}{\\sum_{t=1}^n e_t^2}", description: "Serial correlation test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["autocorrelation"])
    }
    
    func createVarianceInflationFactorFormula() -> FormulaReference {
        FormulaReference(name: "Variance Inflation Factor", category: .quantitative, level: .levelII, mainFormula: "VIF_j = \\frac{1}{1 - R_j^2}", description: "Multicollinearity measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["multicollinearity"])
    }
    
    func createCookDistanceFormula() -> FormulaReference {
        FormulaReference(name: "Cook's Distance", category: .quantitative, level: .levelII, mainFormula: "D_i = \\frac{e_i^2}{p \\times MSE} \\times \\frac{h_{ii}}{(1-h_{ii})^2}", description: "Influential observation measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["diagnostics"])
    }
    
    func createLeverageStatisticFormula() -> FormulaReference {
        FormulaReference(name: "Leverage Statistic", category: .quantitative, level: .levelII, mainFormula: "h_{ii} = x_i^T(X^TX)^{-1}x_i", description: "Leverage measure", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["leverage"])
    }
    
    func createStudentizedResidualsFormula() -> FormulaReference {
        FormulaReference(name: "Studentized Residuals", category: .quantitative, level: .levelII, mainFormula: "t_i = \\frac{e_i}{s_{(i)}\\sqrt{1-h_{ii}}}", description: "Standardized residuals", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["residuals"])
    }
    
    func createWhiteTestFormula() -> FormulaReference {
        FormulaReference(name: "White Test", category: .quantitative, level: .levelII, mainFormula: "\\text{White Test}", description: "Heteroscedasticity test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["heteroscedasticity"])
    }
    
    func createJarqueBeraTestFormula() -> FormulaReference {
        FormulaReference(name: "Jarque-Bera Test", category: .quantitative, level: .levelII, mainFormula: "JB = \\frac{n}{6}(S^2 + \\frac{(K-3)^2}{4})", description: "Normality test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["normality"])
    }
    
    func createRamseyRESETTestFormula() -> FormulaReference {
        FormulaReference(name: "Ramsey RESET Test", category: .quantitative, level: .levelII, mainFormula: "\\text{RESET Test}", description: "Specification test", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["specification"])
    }
    
    // Add remaining missing functions with basic implementations
    func createMonteCarloDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Monte Carlo Simulation", category: .quantitative, level: .levelII, mainFormula: "\\text{Monte Carlo}", description: "Simulation method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["simulation"])
    }
    
    func createVarianceReductionTechniquesFormula() -> FormulaReference {
        FormulaReference(name: "Variance Reduction", category: .quantitative, level: .levelII, mainFormula: "\\text{Variance Reduction}", description: "Simulation efficiency techniques", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["simulation"])
    }
    
    func createImportanceSamplingFormula() -> FormulaReference {
        FormulaReference(name: "Importance Sampling", category: .quantitative, level: .levelII, mainFormula: "\\text{Importance Sampling}", description: "Sampling technique", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["sampling"])
    }
    
    func createControlVariatesFormula() -> FormulaReference {
        FormulaReference(name: "Control Variates", category: .quantitative, level: .levelII, mainFormula: "\\text{Control Variates}", description: "Variance reduction method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["variance-reduction"])
    }
    
    func createAntitheticVariatesFormula() -> FormulaReference {
        FormulaReference(name: "Antithetic Variates", category: .quantitative, level: .levelII, mainFormula: "\\text{Antithetic Variates}", description: "Variance reduction technique", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["variance-reduction"])
    }
    
    func createStratifiedSamplingFormula() -> FormulaReference {
        FormulaReference(name: "Stratified Sampling", category: .quantitative, level: .levelII, mainFormula: "\\text{Stratified Sampling}", description: "Sampling strategy", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["sampling"])
    }
    
    func createBootstrapDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Bootstrap Method", category: .quantitative, level: .levelII, mainFormula: "\\text{Bootstrap}", description: "Resampling method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bootstrap"])
    }
    
    func createJackknifeEstimatorFormula() -> FormulaReference {
        FormulaReference(name: "Jackknife Estimator", category: .quantitative, level: .levelII, mainFormula: "\\text{Jackknife}", description: "Bias reduction estimator", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["jackknife"])
    }
    
    func createScenarioAnalysisFormula() -> FormulaReference {
        FormulaReference(name: "Scenario Analysis", category: .quantitative, level: .levelI, mainFormula: "\\text{Scenario Analysis}", description: "Scenario planning method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["scenario"])
    }
    
    private func createStressTesting() -> FormulaReference {
        FormulaReference(name: "Stress Testing", category: .risk, level: .levelII, mainFormula: "\\text{Stress Test}", description: "Risk assessment method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["stress-test"])
    }
    
    // Add all remaining ML and advanced functions
    func createCrossValidationFormula() -> FormulaReference {
        FormulaReference(name: "Cross Validation", category: .quantitative, level: .levelII, mainFormula: "\\text{Cross Validation}", description: "Model validation technique", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["validation"])
    }
    
    func createKFoldCrossValidationFormula() -> FormulaReference {
        FormulaReference(name: "K-Fold Cross Validation", category: .quantitative, level: .levelII, mainFormula: "\\text{K-Fold CV}", description: "K-fold validation method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["k-fold"])
    }
    
    func createBiasVarianceTradeoffFormula() -> FormulaReference {
        FormulaReference(name: "Bias-Variance Tradeoff", category: .quantitative, level: .levelII, mainFormula: "\\text{Error} = \\text{Bias}^2 + \\text{Variance} + \\text{Noise}", description: "Model complexity tradeoff", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bias-variance"])
    }
    
    func createRegularizationFormula() -> FormulaReference {
        FormulaReference(name: "Regularization", category: .quantitative, level: .levelII, mainFormula: "\\text{Regularization}", description: "Overfitting prevention", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["regularization"])
    }
    
    func createRidgeRegressionFormula() -> FormulaReference {
        FormulaReference(name: "Ridge Regression", category: .quantitative, level: .levelII, mainFormula: "\\text{Ridge}", description: "L2 regularized regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ridge"])
    }
    
    func createLassoRegressionFormula() -> FormulaReference {
        FormulaReference(name: "Lasso Regression", category: .quantitative, level: .levelII, mainFormula: "\\text{Lasso}", description: "L1 regularized regression", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["lasso"])
    }
    
    func createElasticNetFormula() -> FormulaReference {
        FormulaReference(name: "Elastic Net", category: .quantitative, level: .levelII, mainFormula: "\\text{Elastic Net}", description: "Combined L1/L2 regularization", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["elastic-net"])
    }
    
    func createRandomForestFormula() -> FormulaReference {
        FormulaReference(name: "Random Forest", category: .quantitative, level: .levelII, mainFormula: "\\text{Random Forest}", description: "Ensemble tree method", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["random-forest"])
    }
    
    func createSupportVectorMachineFormula() -> FormulaReference {
        FormulaReference(name: "Support Vector Machine", category: .quantitative, level: .levelII, mainFormula: "\\text{SVM}", description: "Maximum margin classifier", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["svm"])
    }
    
    func createNeuralNetworkFormula() -> FormulaReference {
        FormulaReference(name: "Neural Network", category: .quantitative, level: .levelII, mainFormula: "\\text{Neural Network}", description: "Artificial neural network", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["neural-network"])
    }
    
    func createBackpropagationFormula() -> FormulaReference {
        FormulaReference(name: "Backpropagation", category: .quantitative, level: .levelII, mainFormula: "\\text{Backpropagation}", description: "Neural network training", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["backpropagation"])
    }
    
    func createPrincipalComponentAnalysisFormula() -> FormulaReference {
        FormulaReference(name: "Principal Component Analysis", category: .quantitative, level: .levelII, mainFormula: "\\text{PCA}", description: "Dimensionality reduction", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["pca"])
    }
    
    func createKMeansClusteringFormula() -> FormulaReference {
        FormulaReference(name: "K-Means Clustering", category: .quantitative, level: .levelII, mainFormula: "\\text{K-Means}", description: "Clustering algorithm", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["k-means"])
    }
    
    func createNaiveBayesFormula() -> FormulaReference {
        FormulaReference(name: "Naive Bayes", category: .quantitative, level: .levelII, mainFormula: "P(A|B) = \\frac{P(B|A)P(A)}{P(B)}", description: "Bayesian classifier", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["naive-bayes"])
    }
    
    func createLogisticRegressionDetailedFormula() -> FormulaReference {
        FormulaReference(name: "Logistic Regression", category: .quantitative, level: .levelII, mainFormula: "\\text{Logit}(p) = \\ln\\left(\\frac{p}{1-p}\\right) = \\beta_0 + \\beta_1 x", description: "Binary classification model", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["logistic"])
    }
    
    func createDecisionTreeFormula() -> FormulaReference {
        FormulaReference(name: "Decision Tree", category: .quantitative, level: .levelII, mainFormula: "\\text{Decision Tree}", description: "Tree-based classifier", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["decision-tree"])
    }
    
    func createEnsembleMethodsFormula() -> FormulaReference {
        FormulaReference(name: "Ensemble Methods", category: .quantitative, level: .levelII, mainFormula: "\\text{Ensemble}", description: "Multiple model combination", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["ensemble"])
    }
    
    func createBaggingFormula() -> FormulaReference {
        FormulaReference(name: "Bagging", category: .quantitative, level: .levelII, mainFormula: "\\text{Bagging}", description: "Bootstrap aggregating", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["bagging"])
    }
    
    func createBoostingFormula() -> FormulaReference {
        FormulaReference(name: "Boosting", category: .quantitative, level: .levelII, mainFormula: "\\text{Boosting}", description: "Sequential learning", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["boosting"])
    }
    
    func createOverfittingPreventionFormula() -> FormulaReference {
        FormulaReference(name: "Overfitting Prevention", category: .quantitative, level: .levelII, mainFormula: "\\text{Overfitting Prevention}", description: "Model generalization techniques", variables: [], derivation: nil, variants: [], usageNotes: [], examples: [], relatedFormulas: [], tags: ["overfitting"])
    }
    
    // MARK: - Additional Missing CFA Formulas
    
    func createProbabilityOfDefaultFormula() -> FormulaReference {
        FormulaReference(
            name: "Probability of Default (PD)",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "PD = 1 - e^{-\\lambda t}",
            description: "Probability that a borrower will default within a given time period",
            variables: [
                FormulaVariable(symbol: "PD", name: "Probability of Default", description: "Default probability", units: "Probability", typicalRange: "0 to 1", notes: "Higher values indicate higher default risk"),
                FormulaVariable(symbol: "λ", name: "Default Intensity", description: "Hazard rate", units: "Rate", typicalRange: "0+", notes: "Constant default rate"),
                FormulaVariable(symbol: "t", name: "Time Period", description: "Time horizon", units: "Years", typicalRange: "0+", notes: "Evaluation period")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in credit risk assessment", "Foundation for pricing credit derivatives"],
            examples: [],
            relatedFormulas: ["expected-loss", "credit-var"],
            tags: ["probability-default", "credit-risk", "fixed-income"]
        )
    }
    
    func createCreditSpreadDecompositionFormula() -> FormulaReference {
        FormulaReference(
            name: "Credit Spread Decomposition",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Credit Spread} = \\text{Expected Loss} + \\text{Risk Premium} + \\text{Liquidity Premium}",
            description: "Components of credit spread over risk-free rate",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Helps understand credit spread drivers"],
            examples: [],
            relatedFormulas: ["credit-spread", "expected-loss"],
            tags: ["credit-spread", "decomposition", "fixed-income"]
        )
    }
    
    func createCurveRiskFormula() -> FormulaReference {
        FormulaReference(
            name: "Yield Curve Risk",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Curve Risk} = \\sum_{i} KRD_i \\times \\Delta r_i",
            description: "Risk from non-parallel yield curve shifts",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Captures curve steepening/flattening risk"],
            examples: [],
            relatedFormulas: ["key-rate-duration", "yield-curve"],
            tags: ["curve-risk", "yield-curve", "fixed-income"]
        )
    }
    
    func createNegativeConvexityFormula() -> FormulaReference {
        FormulaReference(
            name: "Negative Convexity",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{Negative Convexity} = \\text{Callable Bond Convexity}",
            description: "Convexity characteristic of callable bonds",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Common in mortgage-backed securities"],
            examples: [],
            relatedFormulas: ["callable-bonds", "convexity"],
            tags: ["negative-convexity", "callable-bonds", "fixed-income"]
        )
    }
    
    func createMortgageBackedSecurityFormula() -> FormulaReference {
        FormulaReference(
            name: "Mortgage-Backed Security Pricing",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{MBS Price} = \\sum_{t=1}^{n} \\frac{CF_t}{(1+r)^t}",
            description: "Pricing of mortgage-backed securities",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Includes prepayment risk modeling"],
            examples: [],
            relatedFormulas: ["prepayment-model", "negative-convexity"],
            tags: ["mbs", "mortgage-backed", "securitization"]
        )
    }
    
    func createAssetBackedSecurityFormula() -> FormulaReference {
        FormulaReference(
            name: "Asset-Backed Security Pricing",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{ABS Price} = \\frac{\\text{Expected Cash Flows}}{\\text{Discount Rate}}",
            description: "Pricing of asset-backed securities",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Depends on underlying asset performance"],
            examples: [],
            relatedFormulas: ["credit-enhancement", "subordination"],
            tags: ["abs", "asset-backed", "securitization"]
        )
    }
    
    func createPrepaymentModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Prepayment Model",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{CPR} = f(\\text{Interest Rates}, \\text{Seasonality}, \\text{Burnout})",
            description: "Model for mortgage prepayment rates",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in MBS valuation"],
            examples: [],
            relatedFormulas: ["psa-model", "mbs-pricing"],
            tags: ["prepayment", "cpr", "mortgage"]
        )
    }
    
    func createCDOPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Collateralized Debt Obligation Pricing",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{CDO Tranche Value} = \\text{Expected Cash Flows} \\times \\text{Risk Adjustment}",
            description: "Pricing of CDO tranches",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Highly dependent on correlation assumptions"],
            examples: [],
            relatedFormulas: ["correlation-model", "default-probability"],
            tags: ["cdo", "collateralized-debt", "structured"]
        )
    }
    
    func createWACWAMFormula() -> FormulaReference {
        FormulaReference(
            name: "Weighted Average Coupon and Maturity (WAC/WAM)",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "WAC = \\frac{\\sum (\\text{Balance}_i \\times \\text{Coupon}_i)}{\\sum \\text{Balance}_i}",
            description: "Weighted average characteristics of mortgage pools",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in MBS analysis"],
            examples: [],
            relatedFormulas: ["mbs-pricing", "prepayment-model"],
            tags: ["wac", "wam", "mortgage", "weighted-average"]
        )
    }
    
    func createPRATModelFormula() -> FormulaReference {
        FormulaReference(
            name: "PRAT Model (Sustainable Growth)",
            category: .equity,
            level: .levelI,
            mainFormula: "g = P \\times R \\times A \\times T",
            description: "Profit margin, retention, asset turnover, leverage model",
            variables: [
                FormulaVariable(symbol: "P", name: "Profit Margin", description: "Net profit margin", units: "Ratio", typicalRange: "0-1", notes: "Net income / Sales"),
                FormulaVariable(symbol: "R", name: "Retention Ratio", description: "Earnings retained", units: "Ratio", typicalRange: "0-1", notes: "1 - Payout ratio"),
                FormulaVariable(symbol: "A", name: "Asset Turnover", description: "Sales efficiency", units: "Ratio", typicalRange: "0+", notes: "Sales / Assets"),
                FormulaVariable(symbol: "T", name: "Total Asset/Equity", description: "Financial leverage", units: "Ratio", typicalRange: "1+", notes: "Assets / Equity")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Analyzes sustainable growth components"],
            examples: [],
            relatedFormulas: ["sustainable-growth", "dupont-analysis"],
            tags: ["prat", "sustainable-growth", "equity"]
        )
    }
    
    func createForwardPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Forward Contract Pricing",
            category: .derivatives,
            level: .levelI,
            mainFormula: "F_0 = S_0 \\times e^{(r-\\delta)T}",
            description: "Theoretical forward price for asset with dividend yield",
            variables: [
                FormulaVariable(symbol: "F₀", name: "Forward Price", description: "Current forward price", units: "Currency", typicalRange: "0+", notes: "Price agreed today for future delivery"),
                FormulaVariable(symbol: "S₀", name: "Spot Price", description: "Current spot price", units: "Currency", typicalRange: "0+", notes: "Current market price"),
                FormulaVariable(symbol: "r", name: "Risk-free Rate", description: "Continuous risk-free rate", units: "Rate", typicalRange: "0+", notes: "Continuous compounding"),
                FormulaVariable(symbol: "δ", name: "Dividend Yield", description: "Continuous dividend yield", units: "Rate", typicalRange: "0+", notes: "Continuous dividend rate"),
                FormulaVariable(symbol: "T", name: "Time to Maturity", description: "Time to expiration", units: "Years", typicalRange: "0+", notes: "Time until contract expires")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation for derivatives pricing", "Assumes no arbitrage"],
            examples: [],
            relatedFormulas: ["futures-pricing", "cost-of-carry"],
            tags: ["forward", "derivatives", "no-arbitrage"]
        )
    }
    
    func createGreeksFormulas() -> FormulaReference {
        FormulaReference(
            name: "Option Greeks Collection",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Greeks: } \\Delta, \\Gamma, \\Theta, \\text{Vega}, \\Rho",
            description: "Collection of option sensitivity measures",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used for options risk management"],
            examples: [],
            relatedFormulas: ["delta", "gamma", "theta", "vega", "rho"],
            tags: ["greeks", "options", "risk-management"]
        )
    }
    
    func createHestonModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Heston Stochastic Volatility Model",
            category: .derivatives,
            level: .levelIII,
            mainFormula: "dS_t = rS_t dt + \\sqrt{v_t}S_t dW_1",
            description: "Stochastic volatility model for option pricing",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Advanced model with stochastic volatility"],
            examples: [],
            relatedFormulas: ["black-scholes", "stochastic-volatility"],
            tags: ["heston", "stochastic", "volatility", "advanced"]
        )
    }
    
    func createSABRModelFormula() -> FormulaReference {
        FormulaReference(
            name: "SABR Model",
            category: .derivatives,
            level: .levelIII,
            mainFormula: "dF_t = \\alpha F_t^\\beta dW_1",
            description: "Stochastic Alpha Beta Rho model for volatility",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used for interest rate derivatives"],
            examples: [],
            relatedFormulas: ["stochastic-volatility", "volatility-smile"],
            tags: ["sabr", "stochastic", "interest-rates"]
        )
    }
    
    func createJumpDiffusionModelFormula() -> FormulaReference {
        FormulaReference(
            name: "Jump Diffusion Model",
            category: .derivatives,
            level: .levelIII,
            mainFormula: "dS_t = \\mu S_t dt + \\sigma S_t dW_t + S_t dJ_t",
            description: "Option pricing with jump components",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Captures sudden price movements"],
            examples: [],
            relatedFormulas: ["merton-jump", "poisson-process"],
            tags: ["jump-diffusion", "merton", "derivatives"]
        )
    }
    
    func createVolatilityTradingFormula() -> FormulaReference {
        FormulaReference(
            name: "Volatility Trading Strategies",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{P&L} = \\Gamma \\times \\frac{1}{2} \\times (\\Delta S)^2",
            description: "Profit/loss from volatility trading",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Used in volatility arbitrage"],
            examples: [],
            relatedFormulas: ["gamma", "delta-hedging"],
            tags: ["volatility", "trading", "arbitrage"]
        )
    }
    
    func createOptionsSpreadStrategiesFormula() -> FormulaReference {
        FormulaReference(
            name: "Options Spread Strategies",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Spread P&L} = (S_T - K_1) - (S_T - K_2)",
            description: "Profit/loss from options spread strategies",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Includes bull/bear spreads, butterflies, condors"],
            examples: [],
            relatedFormulas: ["call-spread", "put-spread"],
            tags: ["spreads", "strategies", "options"]
        )
    }
    
    func createBrinsonAttributionFormula() -> FormulaReference {
        FormulaReference(
            name: "Brinson Performance Attribution",
            category: .portfolio,
            level: .levelII,
            mainFormula: "\\text{Total Return} = \\text{Asset Allocation} + \\text{Security Selection} + \\text{Interaction}",
            description: "Performance attribution methodology",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Decomposes portfolio performance"],
            examples: [],
            relatedFormulas: ["performance-attribution", "active-return"],
            tags: ["brinson", "attribution", "performance"]
        )
    }
    
    func createBrinsonHoodBeeblowerFormula() -> FormulaReference {
        FormulaReference(
            name: "Brinson-Hood-Beebower Attribution",
            category: .portfolio,
            level: .levelII,
            mainFormula: "R_p - R_b = \\sum w_i(R_i - R_{bi}) + \\sum (w_i - w_{bi})R_{bi}",
            description: "Enhanced attribution analysis methodology",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Extended Brinson model"],
            examples: [],
            relatedFormulas: ["brinson-attribution", "performance-decomposition"],
            tags: ["brinson-hood-beebower", "attribution", "performance"]
        )
    }
    
    func createFamaFrenchThreeFactorFormula() -> FormulaReference {
        FormulaReference(
            name: "Fama-French Three-Factor Model",
            category: .portfolio,
            level: .levelII,
            mainFormula: "R_i - R_f = \\alpha + \\beta(R_m - R_f) + s \\cdot SMB + h \\cdot HML + \\epsilon_i",
            description: "Three-factor asset pricing model",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Includes size and value factors"],
            examples: [],
            relatedFormulas: ["capm", "fama-french-five-factor"],
            tags: ["fama-french", "three-factor", "asset-pricing"]
        )
    }
    
    func createFamaFrenchFiveFactorFormula() -> FormulaReference {
        FormulaReference(
            name: "Fama-French Five-Factor Model",
            category: .portfolio,
            level: .levelIII,
            mainFormula: "R_i - R_f = \\alpha + \\beta(R_m - R_f) + s \\cdot SMB + h \\cdot HML + r \\cdot RMW + c \\cdot CMA + \\epsilon_i",
            description: "Five-factor asset pricing model",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Adds profitability and investment factors"],
            examples: [],
            relatedFormulas: ["fama-french-three-factor", "asset-pricing"],
            tags: ["fama-french", "five-factor", "asset-pricing"]
        )
    }
    
    func createAnnuityPVFormula() -> FormulaReference {
        FormulaReference(
            name: "Annuity Present Value",
            category: .quantitative,
            level: .levelI,
            mainFormula: "PV = PMT \\times \\frac{1 - (1 + r)^{-n}}{r}",
            description: "Present value of ordinary annuity",
            variables: [
                FormulaVariable(symbol: "PV", name: "Present Value", description: "Current value", units: "Currency", typicalRange: "0+", notes: "Worth today"),
                FormulaVariable(symbol: "PMT", name: "Payment", description: "Periodic payment", units: "Currency", typicalRange: "Any", notes: "Regular payment amount"),
                FormulaVariable(symbol: "r", name: "Interest Rate", description: "Periodic rate", units: "Rate", typicalRange: "0+", notes: "Per period"),
                FormulaVariable(symbol: "n", name: "Number of Periods", description: "Payment periods", units: "Count", typicalRange: "1+", notes: "Total payments")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Foundation for many financial calculations"],
            examples: [],
            relatedFormulas: ["future-value-annuity", "perpetuity"],
            tags: ["annuity", "present-value", "time-value"]
        )
    }
    
    func createEAR_Formula() -> FormulaReference {
        FormulaReference(
            name: "Effective Annual Rate (EAR)",
            category: .quantitative,
            level: .levelI,
            mainFormula: "EAR = (1 + \\frac{r}{m})^m - 1",
            description: "Effective annual rate with compounding",
            variables: [
                FormulaVariable(symbol: "EAR", name: "Effective Annual Rate", description: "True annual rate", units: "Rate", typicalRange: "0+", notes: "Accounts for compounding"),
                FormulaVariable(symbol: "r", name: "Nominal Rate", description: "Stated annual rate", units: "Rate", typicalRange: "0+", notes: "Annual percentage rate"),
                FormulaVariable(symbol: "m", name: "Compounding Frequency", description: "Compounding periods per year", units: "Count", typicalRange: "1+", notes: "1=annual, 4=quarterly, 12=monthly")
            ],
            derivation: nil,
            variants: [],
            usageNotes: ["Used to compare different compounding frequencies"],
            examples: [],
            relatedFormulas: ["apr", "continuous-compounding"],
            tags: ["ear", "effective-rate", "compounding"]
        )
    }
    
    func createPrivateEquityIRRFormula() -> FormulaReference {
        FormulaReference(
            name: "Private Equity Internal Rate of Return",
            category: .alternatives,
            level: .levelII,
            mainFormula: "NPV = \\sum_{t=0}^{n} \\frac{CF_t}{(1+IRR)^t} = 0",
            description: "Internal rate of return for private equity investments",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Key performance metric for PE funds"],
            examples: [],
            relatedFormulas: ["tvpi", "dpi", "moic"],
            tags: ["private-equity", "irr", "performance"]
        )
    }
    
    func createTVPIFormula() -> FormulaReference {
        FormulaReference(
            name: "Total Value to Paid-In (TVPI)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "TVPI = \\frac{\\text{Distributions} + \\text{Residual Value}}{\\text{Paid-In Capital}}",
            description: "Total value multiple for private equity",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures total return multiple"],
            examples: [],
            relatedFormulas: ["dpi", "rvpi", "moic"],
            tags: ["tvpi", "private-equity", "multiple"]
        )
    }
    
    func createDPIFormula() -> FormulaReference {
        FormulaReference(
            name: "Distributions to Paid-In (DPI)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "DPI = \\frac{\\text{Cumulative Distributions}}{\\text{Paid-In Capital}}",
            description: "Cash-on-cash return for private equity",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures realized returns"],
            examples: [],
            relatedFormulas: ["tvpi", "rvpi", "irr"],
            tags: ["dpi", "private-equity", "cash-return"]
        )
    }
    
    func createRVPIFormula() -> FormulaReference {
        FormulaReference(
            name: "Residual Value to Paid-In (RVPI)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "RVPI = \\frac{\\text{Residual Value}}{\\text{Paid-In Capital}}",
            description: "Unrealized value multiple for private equity",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures unrealized returns"],
            examples: [],
            relatedFormulas: ["tvpi", "dpi", "nav"],
            tags: ["rvpi", "private-equity", "unrealized"]
        )
    }
    
    func createMOICFormula() -> FormulaReference {
        FormulaReference(
            name: "Multiple of Invested Capital (MOIC)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "MOIC = \\frac{\\text{Total Value}}{\\text{Total Investment}}",
            description: "Multiple of invested capital for private equity",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Similar to TVPI, measures total return multiple"],
            examples: [],
            relatedFormulas: ["tvpi", "irr", "dpi"],
            tags: ["moic", "private-equity", "multiple"]
        )
    }
    
    func createPMEFormula() -> FormulaReference {
        FormulaReference(
            name: "Public Market Equivalent (PME)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "PME = \\frac{\\sum \\frac{\\text{Distributions}_t}{(1+r_{\\text{index}})^t}}{\\sum \\frac{\\text{Contributions}_t}{(1+r_{\\text{index}})^t}}",
            description: "Comparison of private equity returns to public market",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Benchmarks PE performance against public markets"],
            examples: [],
            relatedFormulas: ["irr", "tvpi", "benchmark-comparison"],
            tags: ["pme", "private-equity", "benchmark"]
        )
    }
    
    func createCarriedInterestFormula() -> FormulaReference {
        FormulaReference(
            name: "Carried Interest",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Carry} = \\text{Carry Rate} \\times \\max(0, \\text{Total Distributions} - \\text{Hurdle Amount})",
            description: "Performance fee for private equity general partners",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Typically 20% of profits above hurdle rate"],
            examples: [],
            relatedFormulas: ["hurdle-rate", "management-fee"],
            tags: ["carry", "private-equity", "fees"]
        )
    }
    
    func createManagementFeeFormula() -> FormulaReference {
        FormulaReference(
            name: "Management Fee",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Management Fee} = \\text{Fee Rate} \\times \\text{Committed Capital}",
            description: "Annual fee for private equity fund management",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Typically 2% of committed capital"],
            examples: [],
            relatedFormulas: ["carried-interest", "net-returns"],
            tags: ["management-fee", "private-equity", "fees"]
        )
    }
    
    func createHedgeFundPerformanceFeeFormula() -> FormulaReference {
        FormulaReference(
            name: "Hedge Fund Performance Fee",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Performance Fee} = \\text{Fee Rate} \\times \\max(0, \\text{Net Return} - \\text{Hurdle Rate})",
            description: "Performance-based fee for hedge funds",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Typically 20% of profits above hurdle rate"],
            examples: [],
            relatedFormulas: ["high-water-mark", "management-fee"],
            tags: ["performance-fee", "hedge-fund", "fees"]
        )
    }
    
    func createHighWaterMarkFormula() -> FormulaReference {
        FormulaReference(
            name: "High Water Mark",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{HWM}_t = \\max(\\text{HWM}_{t-1}, \\text{NAV}_t)",
            description: "Highest net asset value achieved by hedge fund",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Prevents charging performance fees on previous losses"],
            examples: [],
            relatedFormulas: ["performance-fee", "nav"],
            tags: ["high-water-mark", "hedge-fund", "nav"]
        )
    }
    
    func createHedgeFundSharpeFormula() -> FormulaReference {
        FormulaReference(
            name: "Hedge Fund Sharpe Ratio",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Sharpe} = \\frac{R_p - R_f}{\\sigma_p}",
            description: "Risk-adjusted return measure for hedge funds",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Accounts for hedge fund specific risk characteristics"],
            examples: [],
            relatedFormulas: ["sharpe-ratio", "sortino-ratio"],
            tags: ["sharpe-ratio", "hedge-fund", "risk-adjusted"]
        )
    }
    
    func createHedgeFundManagementFeeFormula() -> FormulaReference {
        FormulaReference(
            name: "Hedge Fund Management Fee",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Management Fee} = \\text{Fee Rate} \\times \\text{AUM}",
            description: "Annual management fee for hedge funds",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Typically 2% of assets under management"],
            examples: [],
            relatedFormulas: ["performance-fee", "aum"],
            tags: ["management-fee", "hedge-fund", "aum"]
        )
    }
    
    func createFFOFormula() -> FormulaReference {
        FormulaReference(
            name: "Funds From Operations (FFO)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "FFO = \\text{Net Income} + \\text{Depreciation} + \\text{Amortization} - \\text{Gains on Sale}",
            description: "Key REIT performance metric",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Standard metric for REIT valuation"],
            examples: [],
            relatedFormulas: ["affo", "noi", "cap-rate"],
            tags: ["ffo", "reit", "real-estate"]
        )
    }
    
    func createAFFOFormula() -> FormulaReference {
        FormulaReference(
            name: "Adjusted Funds From Operations (AFFO)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "AFFO = FFO - \\text{Recurring Capital Expenditures}",
            description: "REIT cash flow available for distribution",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["More conservative than FFO"],
            examples: [],
            relatedFormulas: ["ffo", "capex", "distributions"],
            tags: ["affo", "reit", "cash-flow"]
        )
    }
    
    func createRealEstateDCFFormula() -> FormulaReference {
        FormulaReference(
            name: "Real Estate DCF Valuation",
            category: .alternatives,
            level: .levelII,
            mainFormula: "PV = \\sum_{t=1}^{n} \\frac{NOI_t}{(1+r)^t} + \\frac{\\text{Terminal Value}}{(1+r)^n}",
            description: "Discounted cash flow valuation for real estate",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Standard method for real estate valuation"],
            examples: [],
            relatedFormulas: ["noi", "cap-rate", "terminal-value"],
            tags: ["dcf", "real-estate", "valuation"]
        )
    }
    
    func createLoanToValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Loan-to-Value Ratio (LTV)",
            category: .alternatives,
            level: .levelI,
            mainFormula: "LTV = \\frac{\\text{Loan Amount}}{\\text{Property Value}}",
            description: "Leverage ratio for real estate financing",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Key metric for real estate lending"],
            examples: [],
            relatedFormulas: ["debt-service-coverage", "cap-rate"],
            tags: ["ltv", "leverage", "real-estate"]
        )
    }
    
    func createDebtServiceCoverageFormula() -> FormulaReference {
        FormulaReference(
            name: "Debt Service Coverage Ratio (DSCR)",
            category: .alternatives,
            level: .levelII,
            mainFormula: "DSCR = \\frac{\\text{Net Operating Income}}{\\text{Total Debt Service}}",
            description: "Ability to service debt obligations",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Key lending criterion for real estate"],
            examples: [],
            relatedFormulas: ["noi", "ltv", "interest-coverage"],
            tags: ["dscr", "debt-service", "real-estate"]
        )
    }
    
    func createRealEstateTerminalValueFormula() -> FormulaReference {
        FormulaReference(
            name: "Real Estate Terminal Value",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Terminal Value} = \\frac{\\text{Final Year NOI} \\times (1+g)}{\\text{Cap Rate}}",
            description: "Exit value in real estate DCF models",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Assumes perpetual growth in NOI"],
            examples: [],
            relatedFormulas: ["cap-rate", "noi", "dcf"],
            tags: ["terminal-value", "real-estate", "exit-value"]
        )
    }
    
    func createCommodityFuturesPricingFormula() -> FormulaReference {
        FormulaReference(
            name: "Commodity Futures Pricing",
            category: .derivatives,
            level: .levelII,
            mainFormula: "F_0 = (S_0 + \\text{Storage}) \\times e^{rT} - \\text{Convenience Yield}",
            description: "Pricing model for commodity futures",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Includes storage costs and convenience yield"],
            examples: [],
            relatedFormulas: ["storage-cost", "convenience-yield"],
            tags: ["commodities", "futures", "storage"]
        )
    }
    
    func createContangoBackwardationFormula() -> FormulaReference {
        FormulaReference(
            name: "Contango and Backwardation",
            category: .derivatives,
            level: .levelII,
            mainFormula: "\\text{Contango: } F > S, \\text{ Backwardation: } F < S",
            description: "Futures curve shape analysis",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Indicates supply/demand dynamics"],
            examples: [],
            relatedFormulas: ["commodity-futures", "term-structure"],
            tags: ["contango", "backwardation", "futures-curve"]
        )
    }
    
    func createExAntePPPFormula() -> FormulaReference {
        FormulaReference(
            name: "Ex-Ante Purchasing Power Parity",
            category: .economics,
            level: .levelII,
            mainFormula: "E[S_{t+1}] = S_t \\times \\frac{1 + E[\\pi_d]}{1 + E[\\pi_f]}",
            description: "Expected exchange rate based on inflation expectations",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Forward-looking PPP relationship"],
            examples: [],
            relatedFormulas: ["absolute-ppp", "relative-ppp"],
            tags: ["ex-ante-ppp", "exchange-rates", "inflation"]
        )
    }
    
    func createLIBOROISSpreadFormula() -> FormulaReference {
        FormulaReference(
            name: "LIBOR-OIS Spread",
            category: .fixedIncome,
            level: .levelII,
            mainFormula: "\\text{LIBOR-OIS Spread} = \\text{LIBOR Rate} - \\text{OIS Rate}",
            description: "Credit risk indicator in money markets",
            variables: [],
            derivation: nil,
            variants: [],
            usageNotes: ["Measures banking sector stress"],
            examples: [],
            relatedFormulas: ["ted-spread", "credit-risk"],
            tags: ["libor-ois", "credit-risk", "money-markets"]
        )
    }
    
}

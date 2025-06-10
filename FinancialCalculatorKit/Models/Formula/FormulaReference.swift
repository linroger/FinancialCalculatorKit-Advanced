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
            createMoneyDurationFormula(),
            createCurrentYieldFormula(),
            createSpotRateFormula(),
            createForwardRateFormula(),
            
            // MARK: - Advanced Fixed Income: Term Structure
            createSpotRateBootstrappingFormula(),
            createForwardRateNoArbitrageFormula(),
            createYieldCurveConstructionFormula(),
            createParYieldFormula(),
            
            // MARK: - Advanced Fixed Income: Credit Risk
            createCreditSpreadFormula(),
            createProbabilityOfDefaultFormula(),
            createExpectedLossFormula(),
            createCreditVaRFormula(),
            createCreditSpreadDecompositionFormula(),
            
            // MARK: - Advanced Fixed Income: Advanced Duration
            createKeyRateDurationFormula(),
            createEffectiveDurationFormula(),
            createDurationMatchingFormula(),
            createCurveRiskFormula(),
            
            // MARK: - Advanced Fixed Income: Option-Adjusted Analysis
            createOptionAdjustedSpreadFormula(),
            createBondConvexityAdjustedFormula(),
            createNegativeConvexityFormula(),
            
            // MARK: - Advanced Fixed Income: Securitization
            createMortgageBackedSecurityFormula(),
            createAssetBackedSecurityFormula(),
            createPrepaymentModelFormula(),
            createCDOPricingFormula(),
            createWACWAMFormula(),
            
            // MARK: - Equity Formulas
            createGordonGrowthModelFormula(),
            createTwoStageDDMFormula(),
            createHModelFormula(),
            createFCFEModelFormula(),
            createFCFFModelFormula(),
            createResidualIncomeFormula(),
            createPRATModelFormula(),
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
            
            // MARK: - Advanced Options Models
            createHestonModelFormula(),
            createSABRModelFormula(),
            createJumpDiffusionModelFormula(),
            
            // MARK: - Options Trading Strategies & Applications
            createDeltaHedgingFormula(),
            createVolatilityTradingFormula(),
            createOptionsSpreadStrategiesFormula(),
            
            // MARK: - Portfolio Management Formulas
            createCAPMFormula(),
            createPortfolioVarianceFormula(),
            createSharpeRatioFormula(),
            createTreynorRatioFormula(),
            createJensensAlphaFormula(),
            createInformationRatioFormula(),
            createBrinsonAttributionFormula(),
            createBrinsonHoodBeeblowerFormula(),
            createTimeWeightedReturnFormula(),
            createMoneyWeightedReturnFormula(),
            createTrackingErrorFormula(),
            createActiveShareFormula(),
            createTwoFundSeparationFormula(),
            createEfficientFrontierFormula(),
            createFamaFrenchThreeFactorFormula(),
            createFamaFrenchFiveFactorFormula(),
            createAPTFormula(),
            createRiskBudgetingFormula(),
            createBetaCalculationFormula(),
            
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
            createSkewnessFormula(),
            createKurtosisFormula(),
            createCovarianceFormula(),
            createCorrelationFormula(),
            createCoefficientOfVariationFormula(),
            createNormalDistributionFormula(),
            createTDistributionFormula(),
            createChiSquaredDistributionFormula(),
            createFDistributionFormula(),
            createOneSampleTTestFormula(),
            createTwoSampleTTestFormula(),
            createChiSquaredTestFormula(),
            createConfidenceIntervalFormula(),
            
            // MARK: - Risk Management Formulas
            createVaRFormula(),
            createExpectedShortfallFormula(),
            createDownsideDeviationFormula(),
            createMaximumDrawdownFormula(),
            
            // MARK: - Alternative Investments Formulas
            // Private Equity Formulas
            createPrivateEquityIRRFormula(),
            createTVPIFormula(),
            createDPIFormula(),
            createRVPIFormula(),
            createMOICFormula(),
            createPMEFormula(),
            createCarriedInterestFormula(),
            createManagementFeeFormula(),
            
            // Hedge Fund Formulas
            createHedgeFundPerformanceFeeFormula(),
            createHighWaterMarkFormula(),
            createHedgeFundSharpeFormula(),
            createSortinoRatioFormula(),
            createHedgeFundManagementFeeFormula(),
            
            // Real Estate Formulas
            createRealEstateCapRateFormula(),
            createNOIFormula(),
            createFFOFormula(),
            createAFFOFormula(),
            createRealEstateDCFFormula(),
            createDirectCapitalizationFormula(),
            createLoanToValueFormula(),
            createDebtServiceCoverageFormula(),
            createRealEstateTerminalValueFormula(),
            
            // Commodity Formulas
            createCommodityFuturesPricingFormula(),
            createStorageCostFormula(),
            createConvenienceYieldFormula(),
            createContangoBackwardationFormula(),
            
            // Advanced Alternative Investments Formulas
            // Digital Assets & Cryptocurrency
            createMetcalfesLawFormula(),
            createNVTRatioFormula(),
            createTokenVelocityFormula(),
            
            // Infrastructure Investments
            createRegulatedAssetBaseFormula(),
            createInfrastructureDCFFormula(),
            
            // Natural Resources
            createOilGasReservesNPVFormula(),
            createDepletionAccountingFormula(),
            
            // Fund-of-Funds Complex Structures
            createFundOfFundsFeesFormula(),
            createSidePocketProvisionFormula(),
            
            // MARK: - Economics & FRA Formulas
            createCurrentRatioFormula(),
            createROEFormula(),
            createDuPontFormula(),
            createDebtToEquityFormula(),
            
            // MARK: - Macroeconomic Formulas
            createAbsolutePPPFormula(),
            createRelativePPPFormula(),
            createExAntePPPFormula(),
            createInternationalFisherEffectFormula(),
            createForwardExchangeRateFormula(),
            createGrinoldKronerModelFormula(),
            createCobbDouglasProductionFormula(),
            createGrowthAccountingFormula(),
            createEndogenousGrowthModelFormula(),
            createFiscalMultiplierFormula()
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
            createInterestRateSwapValuationFormula(),
            createCurrencySwapFormula(),
            createOptimalHedgeRatioFormula(),
            createBarrierOptionsFormula(),
            createImplementationShortfallFormula(),
            createCaptureRatioFormula(),
            createCalmarRatioFormula()
        ])
    }
}


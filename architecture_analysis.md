# FinancialCalculatorKit Architecture Analysis

## Overview
FinancialCalculatorKit is a comprehensive macOS SwiftUI application for financial calculations, designed for macOS 15+ using Swift 6 and SwiftUI. The application features a wide range of financial calculators, from basic time value of money to advanced derivatives pricing.

## Current State and Architecture

### 1. Technology Stack
- **Platform**: macOS 15+ 
- **Language**: Swift 6
- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **Key Dependencies**:
  - LaTeXSwiftUI (1.5.0+) - Mathematical formula rendering
  - Swift Numerics - Advanced mathematical operations
  - MathParser (3.7.3+) - Expression parsing for scientific calculator

### 2. Application Structure

#### Entry Point
- `FinancialCalculatorKitApp.swift` - Main app entry with ModelContainer configuration
- Supports multiple windows including a "Compact Calculator" mode
- Registers custom transformers for data persistence

#### Main UI Structure
- **NavigationSplitView** layout with sidebar and detail views
- **Sidebar**: 
  - Formula Reference section
  - Calculator types (23 different calculators)
  - Recent calculations
- **Detail View**: Dynamic calculator views based on selection

### 3. Calculator Types (23 Total)

#### Basic Financial
1. **Time Value of Money** - PV, FV, PMT calculations
2. **Loan Calculator** - Amortization schedules
3. **Mortgage Calculator** - Specialized loan calculations
4. **Future Value Calculator** - Interactive charts with CSV export
5. **Depreciation** - Various depreciation methods

#### Investment Analysis
6. **Investment Analysis** - NPV, IRR, MIRR calculations
7. **Equity Valuation** - DDM, DCF, multiples analysis
8. **Portfolio Optimization** - Modern portfolio theory
9. **Risk Management** - VaR, CVaR, Monte Carlo simulation

#### Fixed Income
10. **Bond Calculator** - Pricing, yield, duration, convexity, DV01, PVBP
11. **Fixed Income Analytics** - Advanced bond analysis

#### Derivatives
12. **Options Calculator** - Black-Scholes with Greeks
13. **Options Strategies** - Complex option strategies
14. **Forwards Pricing** - Forward contract valuation
15. **Futures Pricing** - Futures contract analysis
16. **Swaps Pricing** - Interest rate, currency, commodity swaps

#### Market Data & Analysis
17. **Ticker History** - Stock price history charts
18. **FRED Economic Data** - Federal Reserve economic data
19. **Currency Exchange** - Real-time currency conversion

#### Utility Calculators
20. **Scientific Calculator** - Advanced with LaTeX display
21. **Math Expression** - Expression evaluator
22. **Unit Conversion** - Various unit conversions
23. **Alternative Investments** - PE, hedge funds, REITs

### 4. Data Models

#### Persistence Models (SwiftData)
- `FinancialCalculation` - Base calculation model
- `TimeValueCalculation`
- `LoanCalculation`
- `BondCalculation`
- `InvestmentCalculation`
- `DepreciationCalculation`

#### Supporting Enums
- `CalculationType` - All 23 calculator types
- `Currency` - Currency definitions
- `PaymentFrequency` - Payment period options

#### Formula Reference System
- `FormulaReference` - Comprehensive formula documentation
- `FormulaCategory` - Organization by topic
- `CFALevel` - CFA exam level classification
- `FormulaVariable`, `FormulaVariant`, `FormulaExample` - Supporting types

### 5. Services Layer

- `CalculationEngine` - Core financial calculations
- `FinancialCalculator` - Financial calculation utilities
- `FREDService` - Federal Reserve data API
- `ExchangeRateService` - Currency exchange rates
- `CurrencyConversionService` - Currency conversions
- `TickerHistoryService` - Stock data retrieval
- `CSVHelper` - CSV export functionality

### 6. View Models

- `MainViewModel` - Main application state management
  - User preferences
  - Calculation management
  - Navigation state
  - Error handling

### 7. Key Features

#### Scientific Calculator
- Full scientific functions (trig, log, exp, etc.)
- LaTeX expression display
- Multiple display modes (decimal, scientific, engineering, fraction)
- Angle modes (degrees, radians, gradians)
- Memory functions
- Calculation history

#### Bond Calculator
- Price/yield calculations
- Duration (Macaulay and Modified)
- Convexity analysis
- DV01 and PVBP risk metrics
- Cash flow analysis
- Sensitivity charts

#### Options Calculator
- Black-Scholes pricing
- Greeks calculation (Delta, Gamma, Theta, Vega, Rho)
- Greeks analysis view
- Volatility surface visualization
- Multiple option types support

#### Data Visualization
- SwiftCharts integration
- Interactive charts for:
  - Cash flows
  - Sensitivity analysis
  - Price/yield relationships
  - Historical data

### 8. UI/UX Design

#### Styling
- Custom `FinancialGroupBoxStyle`
- Consistent color scheme
- Responsive layouts adapting to window size
- Professional financial application aesthetic

#### User Experience
- Tooltips and help system
- Calculation history
- Save/load calculations
- Export capabilities (CSV, potentially PDF)
- Keyboard shortcuts

### 9. Implementation Status

#### Fully Implemented
- Scientific Calculator with LaTeX
- Bond Calculator with analytics
- Options Calculator with Greeks
- Swaps Calculator
- Currency Converter
- Ticker History viewer
- Formula Reference system
- Main navigation structure

#### Partially Implemented
- Some calculators may have placeholder views
- Export functionality varies by calculator

#### TODO Items (from TODO.md)
- [ ] Expand calculation engine (NPV, IRR, amortization)
- [ ] Persist user data with SwiftData
- [ ] Provide unit tests and UI tests
- [ ] Polish the UI and add more tooltips
- [ ] Document advanced usage in README
- [ ] Update changelog with each milestone

### 10. Architecture Strengths

1. **Modular Design** - Each calculator is self-contained
2. **Type Safety** - Strong typing with Swift enums
3. **Modern SwiftUI** - Latest SwiftUI features and patterns
4. **Professional Features** - Advanced financial calculations
5. **Extensibility** - Easy to add new calculators

### 11. Areas for Enhancement

1. **Testing** - No unit or UI tests currently
2. **Documentation** - Limited inline documentation
3. **Error Handling** - Could be more comprehensive
4. **Performance** - Large calculations might benefit from optimization
5. **Accessibility** - macOS accessibility features could be enhanced

## Summary

FinancialCalculatorKit is a well-architected, professional-grade financial calculator application for macOS. It successfully implements a wide range of financial calculations with a clean, modular architecture. The use of modern Swift and SwiftUI patterns makes it maintainable and extensible. The application is particularly strong in derivatives pricing (options, bonds, swaps) and includes advanced features like LaTeX formula rendering and comprehensive financial analytics.
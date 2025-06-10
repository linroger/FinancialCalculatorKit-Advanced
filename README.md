# FinancialCalculatorKit

A comprehensive, feature-rich financial calculator app for macOS built with SwiftUI and SwiftCharts. This advanced financial toolkit combines professional-grade calculations with an intuitive native macOS interface, perfect for CFA candidates, finance professionals, and students.

## Features

### Core Financial Calculations
- **Time Value of Money (TVM)**
  - Present Value (PV) and Future Value (FV) calculations
  - Payment (PMT) and Interest Rate solving
  - Number of periods calculation
  - Support for ordinary and due annuities
  - LaTeX formula rendering for educational clarity

- **Loan and Mortgage Calculations**
  - Monthly payment calculation with amortization schedules
  - Total interest calculations and principal vs interest breakdown
  - Multiple payment frequency support (monthly, quarterly, annual)
  - Interactive amortization charts

- **Bond Calculations**
  - Bond pricing and yield to maturity calculations
  - Current yield, duration, and convexity analysis
  - Accrued interest calculations
  - Price sensitivity analysis

- **Investment Analysis**
  - Net Present Value (NPV) and Internal Rate of Return (IRR)
  - Modified Internal Rate of Return (MIRR)
  - Payback period and profitability index
  - Cash flow analysis with interactive charts

- **Options Pricing**
  - Black-Scholes model implementation
  - Complete Greeks analysis (Delta, Gamma, Theta, Vega, Rho)
  - Implied volatility calculations
  - Risk analysis and scenario modeling
  - Volatility surface visualization

- **Advanced Mathematical Functions**
  - Expression parser and evaluator with financial functions
  - Custom variable support and calculation history
  - LaTeX rendering for complex mathematical formulas
  - Statistical functions and analysis tools

- **Market Data Integration**
  - Stock ticker history charts using real-time data
  - Currency conversion with live exchange rates
  - Historical data visualization and analysis
  - CSV import/export for custom datasets

- **Depreciation Calculations**
  - Straight-line depreciation
  - Declining balance method
  - MACRS depreciation schedules
  - Custom depreciation scenarios

### Technical Features
- **Native macOS Experience**
  - Built with SwiftUI for macOS 15+ with Apple Silicon optimization
  - Follows Apple Human Interface Guidelines
  - Three-column NavigationSplitView layout
  - Full keyboard navigation and accessibility support

- **Advanced UI/UX**
  - Interactive Swift Charts visualizations
  - LaTeX formula rendering with LaTeXSwiftUI
  - Professional calculation result displays
  - Context menus, drag-and-drop, and native shortcuts
  - Dark/Light mode support with automatic switching

- **Data Management**
  - SwiftData for robust local persistence
  - Calculation history with favorites and search
  - Export capabilities (CSV, Excel, PDF)
  - Import/export for analysis and backup

- **Mathematical Excellence**
  - Swift Numerics for high-precision calculations
  - Math expression parser for complex formulas
  - Custom financial function library
  - Validated calculation engines with error handling

## Technical Stack

- **Framework**: SwiftUI for macOS 15+
- **Data**: SwiftData with custom ValueTransformers
- **Charts**: Swift Charts for data visualization
- **Mathematics**: swift-numerics, swift-math-parser
- **LaTeX**: LaTeXSwiftUI for formula rendering
- **Architecture**: MVVM with @Observable framework
- **Testing**: XCTest with UI testing support

## Building and Running

### Requirements
- Xcode 16+
- macOS 15+ (deployment target)
- Swift 6.0+

### Setup
```bash
# Clone the repository
git clone https://github.com/linroger/FinancialCalculatorKit-Advanced.git
cd FinancialCalculatorKit-Advanced

# Open in Xcode
open FinancialCalculatorKit.xcodeproj

# Or build from command line
swift build
```

### Testing
```bash
# Run unit tests
swift test

# Run UI tests
xcodebuild -project FinancialCalculatorKit.xcodeproj -scheme FinancialCalculatorKit test
```

## Features in Detail

### Calculator Types Available
1. **Time Value of Money** - Complete TVM solver with LaTeX formulas
2. **Loan Calculator** - Payment schedules and amortization analysis
3. **Bond Calculator** - Pricing, yield, and sensitivity analysis
4. **Investment Analysis** - NPV, IRR, and performance metrics
5. **Options Calculator** - Black-Scholes with Greeks analysis
6. **Math Expression** - Advanced expression evaluator
7. **Depreciation** - Multiple depreciation methods
8. **Currency Exchange** - Live rates and conversions
9. **Unit Converter** - International unit conversions

### Key Differentiators
- **LaTeX Rendering**: Beautiful mathematical formulas for educational clarity
- **Professional Interface**: Native macOS design with advanced navigation
- **Comprehensive Coverage**: From basic TVM to advanced options pricing
- **Data Persistence**: Save and organize calculation history
- **Export Capabilities**: Professional reporting and data export
- **Real-time Data**: Live market data integration

## Contributing

Pull requests are welcome! Please:
1. Update `CHANGELOG.md` with your changes
2. Follow SwiftUI and Swift 6 best practices
3. Include tests for new functionality
4. Maintain compatibility with macOS 15+

## License

Copyright © 2025 Roger Lin. All rights reserved.
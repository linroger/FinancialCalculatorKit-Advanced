# Changelog

All notable changes to FinancialCalculatorKit will be documented in this file.

## [Unreleased]

### Added
- Comprehensive financial calculator app with advanced features
- Project architecture documentation and README
- Core financial calculation models (FinancialCalculation, TimeValueCalculation, LoanCalculation, etc.)
- Advanced Options Calculator with Black-Scholes pricing and Greeks analysis
- LaTeX formula rendering using LaTeXSwiftUI for educational clarity
- Professional macOS UI with NavigationSplitView three-column layout
- SwiftData integration with custom ValueTransformers for complex data types
- Future value calculator with interactive charts and CSV export
- Ticker history viewer with real-time data from external APIs
- Currency converter with live exchange rates
- Mathematical expression parser and evaluator
- Depreciation calculator with multiple calculation methods
- Interactive charts and data visualizations using SwiftCharts
- Comprehensive help system and tooltips
- Preferences management with user customization options
- Import/Export functionality for calculations and data

### Enhanced Features from Previous Version
- Integrated market data features (ticker history, currency conversion)
- Combined simple calculators with advanced financial modeling
- Added CSV export capabilities for all calculator types
- Enhanced chart visualizations with Swift Charts
- Improved data persistence with SwiftData

### Changed
- Enhanced MainViewModel with @Observable framework for better state management
- Improved input field components with validation and user experience
- Updated UI styling to follow Apple Human Interface Guidelines
- Migrated from basic template to comprehensive financial toolkit
- Integrated external APIs for real-time market data

### Fixed
- SwiftData model container initialization and registration issues
- Navigation binding problems preventing proper view switching
- Text field formatting issues causing poor user experience
- LaTeX formula rendering integration and display problems
- Compilation errors and build issues across all platforms
- Merge conflicts between different feature branches

## [1.0.0] - 2025-01-XX

### Added
- Initial Xcode project creation with SwiftUI template
- Basic SwiftData template structure
- Project configuration for macOS target
- Future value calculator with chart visualization
- Ticker history viewer with external data integration
- Currency converter with live exchange rates
- CSV export functionality
- Architecture documentation and project setup

### Technical Foundation
- SwiftUI for native macOS interface
- SwiftData for local data persistence
- Swift Charts for data visualization
- LaTeXSwiftUI for mathematical formula rendering
- External API integration for market data
- Target: macOS 15.0+, Swift 6.0+
# FinancialCalculatorKit Testing Guide

## Overview

This guide provides comprehensive testing instructions for the enhanced FinancialCalculatorKit application. Since the development environment doesn't support direct Xcode builds, this guide will help you test the implementation locally to ensure all features work correctly.

## Prerequisites

1. **Xcode 16 Beta or later** (supports Swift 6 and latest SwiftUI features)
2. **macOS 15 (Sequoia) or later** for optimal compatibility
3. **LaTeXSwiftUI package** (should be automatically resolved)

## Build and Initial Testing

### Step 1: Open and Build the Project

1. Open `FinancialCalculatorKit.xcodeproj` in Xcode
2. Ensure the target is set to your Mac
3. Build the project (⌘+B) to verify compilation
4. Run the application (⌘+R) to launch

### Step 2: Verify Navigation Structure

✅ **Test Navigation Split View**
- Confirm the 3-panel layout appears correctly
- Verify sidebar shows all calculator types including new ones:
  - Advanced Scientific Calculator
  - Derivatives Analytics
  - All existing calculators

✅ **Test Calculator Type Integration**
- Click through each calculator type in the sidebar
- Verify proper navigation and view transitions
- Confirm no crashes when switching between calculators

## Feature-Specific Testing

### Advanced Scientific Calculator Testing

#### Basic Functionality
1. **Navigate to Advanced Scientific Calculator**
   - Select from sidebar
   - Verify the interface loads with custom keyboard

2. **Test Expression Entry**
   ```
   Test inputs:
   - Basic: 2 + 3 * 4
   - Variables: a = 5; b = 3; a + b
   - Functions: sin(π/2), sqrt(16), log(100)
   - Complex: (2 + 3i) * (4 - 2i)
   ```

3. **Test LaTeX Rendering**
   - Enter mathematical expressions
   - Verify live LaTeX preview updates
   - Test complex expressions with fractions, integrals, summations

4. **Test Variable System**
   - Create variables: `x = 10`, `y = 20`
   - Use in expressions: `x^2 + y^2`
   - Verify persistence across sessions

5. **Test Custom Keyboard**
   - Switch between all 8 keyboard layouts
   - Test specialized function buttons
   - Verify Greek letter input

6. **Test Equation Documents**
   - Save equations to documents
   - Load saved equations
   - Verify document persistence with SwiftData

#### Advanced Features
7. **Auto-Complete Testing**
   - Start typing function names
   - Verify suggestions appear
   - Test completion functionality

8. **Export Functionality**
   - Test PDF export
   - Test LaTeX export
   - Test plain text export

### Bond Calculator Testing

#### Basic Bond Pricing
1. **Navigate to Advanced Bond Calculator**
   - Verify 3-panel professional layout

2. **Test Different Bond Types**
   ```
   Test cases:
   - Treasury Bond: Face=$1000, Coupon=3%, Maturity=10yr
   - Corporate Bond: Face=$1000, Coupon=5%, Rating=BBB
   - Municipal Bond: Face=$1000, Coupon=4%, Tax-exempt
   - TIPS: Face=$1000, Coupon=2%, Inflation-protected
   ```

3. **Test Credit Risk Analysis**
   - Change credit ratings (AAA to D)
   - Verify credit spread calculations
   - Test default probability updates

4. **Test Yield Curve Integration**
   - Switch between interpolation methods
   - Verify spot rate calculations
   - Test forward rate derivations

#### Advanced Bond Features
5. **OAS Analysis Testing**
   - Test callable bonds
   - Test putable bonds
   - Verify OAS calculations with embedded options

6. **Monte Carlo Simulation**
   - Run simulations with different parameters
   - Verify convergence and results
   - Test path visualization

7. **Scenario Analysis**
   - Test parallel yield curve shifts
   - Test non-parallel shifts
   - Verify stress test results

### Options Calculator Testing

#### Basic Options Pricing
1. **Navigate to Advanced Options Calculator**
   - Verify 8-tab analytics interface

2. **Test Option Types**
   ```
   Test configurations:
   - European Call: S=$100, K=$105, T=0.25, r=5%, σ=20%
   - American Put: S=$95, K=$100, T=0.5, r=5%, σ25%
   - Asian Option: Averaging period, different averaging types
   - Barrier Option: Up-and-out, down-and-in barriers
   ```

3. **Test Pricing Models**
   - Black-Scholes-Merton
   - Binomial Trees
   - Monte Carlo
   - Heston Stochastic Volatility
   - SABR Model
   - Jump-Diffusion

#### Advanced Options Features
4. **Greeks Analysis**
   - Verify first-order Greeks (Delta, Vega, Theta, Rho)
   - Test second-order Greeks (Gamma, Vanna, Volga)
   - Test third-order Greeks (Speed, Zomma, Ultima)

5. **Strategy Analysis**
   - Test basic strategies (long call, short put)
   - Test spreads (bull call, bear put, butterflies)
   - Test complex strategies (iron condors, calendar spreads)
   - Verify payoff diagrams

6. **Risk Management**
   - Test VaR calculations
   - Test Expected Shortfall
   - Verify hedging recommendations

7. **Volatility Analysis**
   - Test volatility surface generation
   - Test implied volatility calculations
   - Verify volatility smile/skew modeling

### Derivatives Analytics Testing

#### Cross-Instrument Analysis
1. **Navigate to Derivatives Analytics**
   - Verify comprehensive analytics platform

2. **Test Instrument Selection**
   - Select multiple derivative types
   - Test cross-instrument comparisons
   - Verify pricing consistency

3. **Test Analysis Types**
   - Pricing Analysis: Compare fair values
   - Risk Metrics: Portfolio-level risk measures
   - Sensitivity Analysis: Parameter stress testing
   - Correlation Analysis: Cross-instrument correlations

#### Portfolio and Risk Management
4. **Portfolio Analysis**
   - Build multi-instrument portfolios
   - Test risk attribution
   - Verify portfolio optimization

5. **Stress Testing**
   - Run market crash scenarios
   - Test volatility spike scenarios
   - Test interest rate shock scenarios
   - Verify custom scenario definition

6. **Hedging Optimization**
   - Test delta-neutral hedging
   - Test gamma-neutral strategies
   - Test vega hedging
   - Verify multi-objective optimization

## Performance Testing

### Memory and CPU Usage
1. **Monitor Resource Usage**
   - Open Activity Monitor
   - Watch memory usage during calculations
   - Verify no memory leaks during extended use

2. **Large Dataset Testing**
   - Test with large bond portfolios
   - Test extensive option strategy combinations
   - Test Monte Carlo with high iteration counts

3. **Concurrent Operations**
   - Run multiple calculations simultaneously
   - Test calculation cancellation
   - Verify UI responsiveness

## User Interface Testing

### Responsive Design
1. **Window Resizing**
   - Test minimum window sizes
   - Verify layout adaptation
   - Test split view column resizing

2. **Accessibility**
   - Test VoiceOver navigation
   - Verify keyboard shortcuts
   - Test contrast and font scaling

3. **Visual Design**
   - Verify consistent styling across all calculators
   - Test dark/light mode switching
   - Verify proper chart rendering

## Data Persistence Testing

### SwiftData Integration
1. **Equation Documents**
   - Save complex equations
   - Restart application
   - Verify equations persist correctly

2. **Variable Storage**
   - Create variable sets
   - Test persistence across sessions
   - Verify variable scope handling

3. **Calculation History**
   - Perform multiple calculations
   - Verify history tracking
   - Test search functionality

## Error Handling Testing

### Input Validation
1. **Invalid Inputs**
   - Test negative prices where inappropriate
   - Test extreme parameter values
   - Test malformed expressions

2. **Edge Cases**
   - Test zero volatility
   - Test very short/long expirations
   - Test extreme strike prices

3. **Recovery Mechanisms**
   - Test calculation cancellation
   - Test error message clarity
   - Verify graceful degradation

## Export and Sharing Testing

### Export Functionality
1. **Report Generation**
   - Test comprehensive report exports
   - Verify PDF generation
   - Test chart export quality

2. **Data Export**
   - Test CSV data export
   - Test calculation result sharing
   - Verify export file integrity

## Integration Testing

### Cross-Calculator Integration
1. **Data Sharing**
   - Test parameter sharing between calculators
   - Verify consistent market data usage
   - Test calculation result integration

2. **Navigation Flow**
   - Test seamless transitions
   - Verify state preservation
   - Test bookmark functionality

## Validation Against Known Results

### Mathematical Accuracy
1. **Black-Scholes Verification**
   ```
   Test Case: European Call
   S = $100, K = $100, T = 1, r = 5%, σ = 20%
   Expected: ~$10.45
   ```

2. **Bond Pricing Verification**
   ```
   Test Case: 5-year Treasury
   Face = $1000, Coupon = 3%, YTM = 4%
   Expected: ~$955.35
   ```

3. **Greeks Verification**
   - Compare calculated Greeks with analytical solutions
   - Verify put-call parity relationships
   - Test option strategy payoffs

## Troubleshooting Common Issues

### Build Issues
- **Swift 6 Compatibility**: Ensure Xcode 16+ is used
- **Package Dependencies**: Clean and rebuild if LaTeXSwiftUI fails to resolve
- **Target Settings**: Verify macOS 15+ deployment target

### Runtime Issues
- **Memory Warnings**: Reduce Monte Carlo iterations if memory issues occur
- **Chart Rendering**: Verify sufficient graphics memory for complex visualizations
- **SwiftData Issues**: Reset Core Data if persistence problems occur

### Performance Issues
- **Slow Calculations**: Check for infinite loops in iterative methods
- **UI Freezing**: Verify calculations run on background threads
- **Chart Updates**: Ensure chart data updates efficiently

## Success Criteria

The implementation should be considered successful if:

✅ All calculators load without crashes
✅ Mathematical calculations produce accurate results
✅ Charts and visualizations render correctly
✅ Data persistence works reliably
✅ UI remains responsive during calculations
✅ Export functionality works properly
✅ Error handling is graceful and informative
✅ Performance is acceptable for typical use cases

## Reporting Issues

If you encounter any issues during testing:

1. **Document the Issue**
   - Exact steps to reproduce
   - Expected vs. actual behavior
   - Screenshots if applicable

2. **Check Console Output**
   - Look for error messages in Xcode console
   - Note any deprecation warnings

3. **Performance Issues**
   - Use Instruments to profile memory/CPU usage
   - Identify specific bottlenecks

The FinancialCalculatorKit has been extensively implemented with professional-grade features. This testing guide ensures all components work together seamlessly to provide a Wolfram Alpha-level financial calculation experience.
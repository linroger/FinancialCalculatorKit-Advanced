# CFA Formula Reference Research - Comprehensive Catalog

## Research Objective
Create a comprehensive formula reference covering ALL formulas from CFA Level I, II, and III examinations, organized by asset class with complete derivations, variants, and usage notes.

## Organization Structure

### Asset Class Taxonomy
1. **Quantitative Methods & Statistics**
2. **Fixed Income Securities** 
3. **Equity Securities**
4. **Derivatives**
5. **Alternative Investments**
6. **Portfolio Management & Asset Allocation**
7. **Risk Management**
8. **Economics & Financial Statement Analysis**

---

## 1. QUANTITATIVE METHODS & STATISTICS

### Time Value of Money (Level I Foundation)

#### Present Value Formulas
- **Single Cash Flow PV**: `PV = FV / (1 + r)^n`
- **Ordinary Annuity PV**: `PV = PMT × [(1 - (1 + r)^(-n)) / r]`
- **Annuity Due PV**: `PV = PMT × [(1 - (1 + r)^(-n)) / r] × (1 + r)`
- **Perpetuity PV**: `PV = PMT / r`
- **Growing Perpetuity PV**: `PV = PMT / (r - g)`
- **Growing Annuity PV**: `PV = PMT × [(1 - ((1 + g)/(1 + r))^n) / (r - g)]`

#### Future Value Formulas
- **Single Cash Flow FV**: `FV = PV × (1 + r)^n`
- **Ordinary Annuity FV**: `FV = PMT × [((1 + r)^n - 1) / r]`
- **Annuity Due FV**: `FV = PMT × [((1 + r)^n - 1) / r] × (1 + r)`

#### Interest Rate Calculations
- **Effective Annual Rate**: `EAR = (1 + r/m)^m - 1`
- **Continuous Compounding**: `FV = PV × e^(rt)`
- **Real Interest Rate**: `(1 + nominal) = (1 + real) × (1 + inflation)`

### Statistical Measures (Level I & II)

#### Central Tendency
- **Arithmetic Mean**: `μ = Σxi / n`
- **Geometric Mean**: `G = (x1 × x2 × ... × xn)^(1/n)`
- **Harmonic Mean**: `H = n / Σ(1/xi)`
- **Weighted Mean**: `X̄w = Σ(wi × xi) / Σwi`

#### Dispersion Measures
- **Population Variance**: `σ² = Σ(xi - μ)² / N`
- **Sample Variance**: `s² = Σ(xi - x̄)² / (n-1)`
- **Standard Deviation**: `σ = √σ²`
- **Coefficient of Variation**: `CV = σ / μ`
- **Range**: `Range = Maximum - Minimum`
- **Mean Absolute Deviation**: `MAD = Σ|xi - μ| / n`

#### Probability Distributions
- **Binomial**: `P(X = x) = C(n,x) × p^x × (1-p)^(n-x)`
- **Normal Distribution**: `f(x) = (1/(σ√(2π))) × e^(-(x-μ)²/(2σ²))`
- **Lognormal**: `ln(S) ~ N(μ, σ²)`
- **Chi-Square**: `χ² = Σ((Oi - Ei)² / Ei)`
- **Student's t**: `t = (x̄ - μ) / (s/√n)`
- **F-distribution**: `F = s1²/s2²`

### Regression Analysis (Level II)

#### Simple Linear Regression
- **Regression Equation**: `Yi = b0 + b1Xi + εi`
- **Slope Coefficient**: `b1 = Σ((Xi - X̄)(Yi - Ȳ)) / Σ(Xi - X̄)²`
- **Intercept**: `b0 = Ȳ - b1X̄`
- **R-squared**: `R² = SSR/SST = 1 - SSE/SST`
- **Standard Error of Estimate**: `SEE = √(SSE/(n-2))`

#### Multiple Regression
- **Multiple R-squared**: `R² = 1 - (RSS/TSS)`
- **Adjusted R-squared**: `R²adj = 1 - ((1-R²)(n-1)/(n-k-1))`
- **F-statistic**: `F = (R²/k) / ((1-R²)/(n-k-1))`

### Time Series Analysis (Level II)
- **Random Walk**: `xt = xt-1 + εt`
- **AR(1) Model**: `xt = b0 + b1xt-1 + εt`
- **Mean Reversion**: `xt = μ + φ(xt-1 - μ) + εt`

---

## 2. FIXED INCOME SECURITIES

### Bond Pricing Fundamentals (Level I & II)

#### Basic Bond Pricing
- **Bond Price**: `P = Σ(CFt / (1 + r)^t) + M / (1 + r)^n`
- **Full Price**: `PV = Σ(PMT / (1 + YTM/m)^t) + FV / (1 + YTM/m)^n`
- **Flat Price**: `Flat Price = Full Price - Accrued Interest`
- **Accrued Interest**: `AI = (t/T) × (Annual Coupon / m)`

#### Yield Measures
- **Current Yield**: `CY = Annual Coupon / Bond Price`
- **Yield to Maturity**: Solved iteratively from pricing equation
- **Yield to Call**: `YTC` using call price and call date
- **Yield to Worst**: `YTW = min(YTM, YTC)`

#### Bond Price Relationships
- **Spot Rate Pricing**: `P = Σ(CFt / (1 + St)^t)`
- **Forward Rate**: `(1 + Sf)^f = (1 + Sl)^l / (1 + Ss)^s`
- **Bootstrap Method**: Iterative spot rate derivation

### Duration and Convexity (Level I & II)

#### Macaulay Duration
- **Formula**: `MacDur = Σ[t × (CFt / (1 + YTM)^t)] / Bond Price`
- **Approximation**: `MacDur ≈ (1 + YTM)/YTM - (1 + YTM + n(c - YTM))/(c[(1 + YTM)^n - 1] + YTM)`

#### Modified Duration
- **Formula**: `ModDur = MacDur / (1 + YTM/m)`
- **Price Sensitivity**: `%ΔP ≈ -ModDur × ΔYTM`

#### Effective Duration
- **Formula**: `EffDur = (P- - P+) / (2 × P0 × Δy)`
- **For Bonds with Options**: Uses option-adjusted pricing

#### Convexity
- **Formula**: `Convexity = Σ[t(t+1) × CFt / (1 + YTM)^(t+2)] / (P × (1 + YTM)²)`
- **Price Change**: `%ΔP ≈ -ModDur × ΔYTM + 0.5 × Convexity × (ΔYTM)²`

### Credit Analysis (Level II)

#### Credit Risk Measures
- **Probability of Default**: `PD = 1 - e^(-λt)`
- **Loss Given Default**: `LGD = 1 - Recovery Rate`
- **Expected Loss**: `EL = PD × LGD × EAD`
- **Credit VaR**: `CVaR = EL + √(Variance)`

#### Credit Spreads
- **Z-Spread**: Constant spread over spot curve
- **Option-Adjusted Spread**: `OAS = Z-Spread - Option Value`
- **Asset Swap Spread**: Spread over LIBOR

### Term Structure Models (Level II & III)

#### Spot and Forward Rates
- **Forward Rate Formula**: `f(t,T) = [S(T) × T - S(t) × t] / (T - t)`
- **Implied Forward**: `(1 + f1,1) = (1 + s2)² / (1 + s1)`

#### Yield Curve Models
- **Nelson-Siegel**: `y(τ) = β0 + β1((1-e^(-τ/λ))/τ/λ) + β2(((1-e^(-τ/λ))/τ/λ) - e^(-τ/λ))`
- **Vasicek Model**: `dr = α(θ - r)dt + σdW`
- **Cox-Ingersoll-Ross**: `dr = α(θ - r)dt + σ√r dW`

---

## 3. EQUITY SECURITIES

### Equity Valuation Models (Level I & II)

#### Dividend Discount Models
- **Gordon Growth Model**: `P0 = D1 / (r - g)`
- **Two-Stage DDM**: `P0 = Σ(Dt / (1 + r)^t) + (Pn / (1 + r)^n)`
- **H-Model**: `P0 = D1 × [((1 + gL)/(r - gL)) + ((H/2) × (gS - gL)/(r - gL))]`
- **Variable Growth DDM**: Multi-stage with different growth rates

#### Free Cash Flow Models
- **FCFE Model**: `P0 = Σ(FCFEt / (1 + r)^t)`
- **FCFF Model**: `Firm Value = Σ(FCFFt / (1 + WACC)^t)`
- **FCFE Calculation**: `FCFE = NI + Dep - FCInv - WCInv + Net Borrowing`
- **FCFF Calculation**: `FCFF = CFO + Int(1 - T) - FCInv`

#### Residual Income Models
- **Residual Income**: `RI = NI - (r × BVt-1)`
- **RI Valuation**: `P0 = BV0 + Σ(RIt / (1 + r)^t)`

### Relative Valuation (Level I & II)

#### Price Multiples
- **P/E Ratio**: `P/E = Price per Share / EPS`
- **P/B Ratio**: `P/B = Price per Share / Book Value per Share`
- **P/S Ratio**: `P/S = Price per Share / Sales per Share`
- **P/CF Ratio**: `P/CF = Price per Share / Cash Flow per Share`

#### Enterprise Value Multiples
- **EV/EBITDA**: `EV/EBITDA = Enterprise Value / EBITDA`
- **EV/Sales**: `EV/Sales = Enterprise Value / Revenue`
- **Enterprise Value**: `EV = Market Cap + Total Debt - Cash`

### Industry Analysis (Level II)

#### Porter's Five Forces Framework
- Industry rivalry intensity
- Threat of new entrants
- Threat of substitutes
- Bargaining power of suppliers
- Bargaining power of buyers

---

## 4. DERIVATIVES

### Forward and Futures Pricing (Level I & II)

#### Forward Pricing
- **Forward Price (No Income)**: `F0 = S0 × e^(rT)`
- **Forward Price (Known Income)**: `F0 = (S0 - I) × e^(rT)`
- **Forward Price (Yield)**: `F0 = S0 × e^((r-q)T)`
- **Currency Forward**: `F0 = S0 × e^((rdc-rfc)T)`

#### Futures Pricing
- **Stock Index Futures**: `F0 = S0 × e^((r-δ)T)`
- **Bond Futures**: Uses conversion factor methodology
- **Currency Futures**: Similar to forwards with daily settlement

### Options Pricing (Level II)

#### Black-Scholes Model
- **Call Option**: `C = S0N(d1) - Xe^(-rT)N(d2)`
- **Put Option**: `P = Xe^(-rT)N(-d2) - S0N(-d1)`
- **d1**: `d1 = [ln(S0/X) + (r + σ²/2)T] / (σ√T)`
- **d2**: `d2 = d1 - σ√T`

#### Put-Call Parity
- **European Options**: `C + Xe^(-rT) = P + S0`
- **With Dividends**: `C + Xe^(-rT) = P + S0e^(-qT)`

#### Binomial Model
- **Up Factor**: `u = e^(σ√Δt)`
- **Down Factor**: `d = 1/u = e^(-σ√Δt)`
- **Risk-Neutral Probability**: `p = (e^(rΔt) - d) / (u - d)`

#### Greeks
- **Delta**: `Δ = ∂V/∂S`
- **Gamma**: `Γ = ∂²V/∂S²`
- **Theta**: `Θ = ∂V/∂t`
- **Vega**: `ν = ∂V/∂σ`
- **Rho**: `ρ = ∂V/∂r`

### Swaps (Level II)

#### Interest Rate Swaps
- **Swap Value**: `Value = Bond_fixed - Bond_floating`
- **Swap Rate**: Rate that makes initial swap value zero
- **Forward Rate Agreement**: `FRA Settlement = Notional × [(Rate - FRA Rate) × Days/360] / [1 + (Rate × Days/360)]`

#### Currency Swaps
- **Initial Exchange**: At spot rate
- **Periodic Exchanges**: Interest payments in respective currencies
- **Final Exchange**: Principal repayment

---

## 5. ALTERNATIVE INVESTMENTS

### Real Estate (Level I & II)

#### Real Estate Valuation
- **Net Operating Income**: `NOI = Gross Income - Operating Expenses`
- **Capitalization Rate**: `Cap Rate = NOI / Property Value`
- **Direct Capitalization**: `Value = NOI / Cap Rate`

#### Real Estate Returns
- **Total Return**: `Total Return = (Income + Capital Appreciation) / Initial Investment`
- **Appraisal-Based Index**: Uses appraisal values
- **Transaction-Based Index**: Uses actual transaction prices

### Private Equity (Level II & III)

#### Private Equity Metrics
- **IRR Calculation**: Iterative solution to NPV = 0
- **Multiple of Money**: `MoM = Total Distributions / Total Contributions`
- **DPI (Distributions to Paid-In)**: `DPI = Cumulative Distributions / Cumulative Contributions`
- **RVPI (Residual Value to Paid-In)**: `RVPI = Residual Value / Cumulative Contributions`
- **TVPI (Total Value to Paid-In)**: `TVPI = DPI + RVPI`

### Hedge Funds (Level II & III)

#### Hedge Fund Metrics
- **Sharpe Ratio**: `Sharpe = (Rp - Rf) / σp`
- **Sortino Ratio**: `Sortino = (Rp - Rf) / σdownside`
- **Maximum Drawdown**: Largest peak-to-trough decline
- **Calmar Ratio**: `Calmar = Annual Return / Maximum Drawdown`

### Commodities (Level I & II)

#### Commodity Pricing
- **Storage Costs**: `F0 = (S0 + Storage) × e^(rT)`
- **Convenience Yield**: `F0 = S0 × e^((r+c-y)T)`
- **Commodity Indices**: Various weighting methodologies

---

## 6. PORTFOLIO MANAGEMENT & ASSET ALLOCATION

### Portfolio Theory (Level I & II)

#### Markowitz Portfolio Theory
- **Portfolio Return**: `E(Rp) = Σwi × E(Ri)`
- **Portfolio Variance**: `σp² = Σwi²σi² + ΣΣwiwjσij`
- **Two-Asset Portfolio**: `σp² = w1²σ1² + w2²σ2² + 2w1w2σ12`
- **Correlation**: `ρ12 = σ12 / (σ1 × σ2)`

#### Capital Asset Pricing Model
- **CAPM**: `E(Ri) = Rf + βi[E(Rm) - Rf]`
- **Beta**: `β = Cov(Ri,Rm) / Var(Rm)`
- **Security Market Line**: `E(Ri) = Rf + βi × (E(Rm) - Rf)`

#### Multi-Factor Models
- **Arbitrage Pricing Theory**: `E(Ri) = Rf + βi1λ1 + βi2λ2 + ... + βikλk`
- **Fama-French 3-Factor**: `R = Rf + β(Rm-Rf) + sSMB + hHML`
- **Fama-French 5-Factor**: Adds profitability and investment factors

### Performance Measurement (Level III)

#### Risk-Adjusted Returns
- **Jensen's Alpha**: `αp = Rp - [Rf + βp(Rm - Rf)]`
- **Treynor Ratio**: `Treynor = (Rp - Rf) / βp`
- **Information Ratio**: `IR = αp / σ(εp)`
- **M²**: `M² = Rf + (Rp - Rf) × (σm / σp)`

#### Attribution Analysis
- **Asset Allocation Effect**: `Σ(wpi - wbi) × Rbi`
- **Security Selection Effect**: `Σwbi × (Rpi - Rbi)`
- **Interaction Effect**: `Σ(wpi - wbi) × (Rpi - Rbi)`

---

## 7. RISK MANAGEMENT

### Value at Risk (Level II & III)

#### VaR Methodologies
- **Parametric VaR**: `VaR = Portfolio Value × σ × Z-score`
- **Historical Simulation**: Based on historical returns
- **Monte Carlo VaR**: Simulation-based approach

#### Expected Shortfall
- **Expected Shortfall**: `ES = E[Loss | Loss > VaR]`
- **Coherent Risk Measure**: Satisfies subadditivity

### Risk Measures (Level II & III)

#### Downside Risk
- **Downside Deviation**: `σdownside = √(Σ(Ri - MAR)² / n)` for Ri < MAR
- **Maximum Drawdown**: Peak-to-trough decline
- **VaR**: Value at Risk at confidence level

#### Credit Risk
- **Expected Loss**: `EL = PD × LGD × EAD`
- **Unexpected Loss**: `UL = EAD × √((σPD × LGD)² + (σLGD × PD)²)`
- **Credit VaR**: `CVaR = UL × Z-score + EL`

---

## 8. ECONOMICS & FINANCIAL STATEMENT ANALYSIS

### Financial Ratios (Level I)

#### Liquidity Ratios
- **Current Ratio**: `Current Assets / Current Liabilities`
- **Quick Ratio**: `(Current Assets - Inventory) / Current Liabilities`
- **Cash Ratio**: `Cash + Marketable Securities / Current Liabilities`

#### Activity Ratios
- **Inventory Turnover**: `COGS / Average Inventory`
- **Receivables Turnover**: `Net Sales / Average Accounts Receivable`
- **Total Asset Turnover**: `Net Sales / Average Total Assets`

#### Leverage Ratios
- **Debt-to-Equity**: `Total Debt / Total Equity`
- **Debt-to-Capital**: `Total Debt / (Total Debt + Total Equity)`
- **Interest Coverage**: `EBIT / Interest Expense`

#### Profitability Ratios
- **Gross Profit Margin**: `Gross Profit / Net Sales`
- **Operating Profit Margin**: `Operating Income / Net Sales`
- **Net Profit Margin**: `Net Income / Net Sales`
- **ROA**: `Net Income / Average Total Assets`
- **ROE**: `Net Income / Average Shareholders' Equity`

### DuPont Analysis
- **Traditional DuPont**: `ROE = Net Profit Margin × Asset Turnover × Equity Multiplier`
- **Extended DuPont**: `ROE = Tax Burden × Interest Burden × EBIT Margin × Asset Turnover × Equity Multiplier`

### Economic Indicators
- **GDP Components**: `GDP = C + I + G + (X - M)`
- **GDP Deflator**: `(Nominal GDP / Real GDP) × 100`
- **Inflation Rate**: `(CPIt - CPIt-1) / CPIt-1 × 100`

### Currency and Exchange Rates
- **Purchasing Power Parity**: `S1/S0 = (1 + Inflation_foreign) / (1 + Inflation_domestic)`
- **Interest Rate Parity**: `F/S = (1 + r_foreign) / (1 + r_domestic)`
- **Real Exchange Rate**: `Real Rate = Nominal Rate × (Foreign Price Level / Domestic Price Level)`

---

## IMPLEMENTATION NOTES

### LaTeX Rendering Requirements
- Complex mathematical expressions with fractions, superscripts, subscripts
- Greek letters (α, β, γ, δ, σ, μ, etc.)
- Mathematical operators (∑, ∫, ∂, etc.)
- Matrix notation for portfolio optimization
- Function notation with proper formatting

### Derivation Requirements
- Step-by-step mathematical derivations
- Algebraic manipulations shown clearly
- Assumptions and conditions stated
- Alternative forms and rearrangements

### Variable Definition Requirements
- Comprehensive variable glossary
- Units and typical ranges
- Data sources and calculation methods
- Practical usage notes and limitations

### Cross-References
- Related formulas linked
- Prerequisites and dependencies
- Application contexts
- Level-specific variations

This research document serves as the foundation for implementing the comprehensive CFA formula reference system.
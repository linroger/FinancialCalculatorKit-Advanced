    // MARK: - Advanced Alternative Investments Formulas
    
    // Digital Assets & Cryptocurrency
    private func createMetcalfesLawFormula() -> FormulaReference {
        FormulaReference(
            name: "Metcalfe's Law for Network Valuation",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "V = k \\times n^2",
            description: "Network value proportional to square of active users. Applied to cryptocurrency and blockchain network valuation based on network effects.",
            variables: [
                FormulaVariable(symbol: "V", name: "Network Value", description: "Total network valuation", units: "Currency units", typicalRange: "Variable", notes: "Market cap for cryptocurrencies"),
                FormulaVariable(symbol: "k", name: "Value per Connection", description: "Proportionality constant", units: "Currency per connection²", typicalRange: "Asset-specific", notes: "Derived from regression analysis"),
                FormulaVariable(symbol: "n", name: "Active Users", description: "Number of active network participants", units: "Count", typicalRange: "1 to billions", notes: "Daily/monthly active addresses")
            ],
            derivation: FormulaDerivation(
                title: "Network Effects in Digital Assets",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Network connections scale quadratically", formula: "\\text{Connections} = \\frac{n(n-1)}{2} \\approx \\frac{n^2}{2}", explanation: "Each user can connect to (n-1) others"),
                    DerivationStep(stepNumber: 2, description: "Value per connection is constant", formula: "\\text{Value per Connection} = k", explanation: "Assumes uniform utility from connections"),
                    DerivationStep(stepNumber: 3, description: "Total network value", formula: "V = k \\times \\frac{n^2}{2} \\propto n^2", explanation: "Network value grows with square of users")
                ],
                assumptions: [
                    "All users have equal network value contribution",
                    "Network effects dominate other value drivers", 
                    "No congestion or scaling limitations",
                    "Constant marginal utility per connection"
                ],
                notes: "Originally developed for telecommunications networks, adapted for blockchain network valuation."
            ),
            variants: [
                FormulaVariant(name: "Modified Metcalfe's Law", formula: "V = k \\times n^{1.5}", description: "Empirically adjusted exponent", whenToUse: "When quadratic relationship doesn't fit data"),
                FormulaVariant(name: "NVT Ratio Integration", formula: "\\text{NVT} = \\frac{\\text{Market Cap}}{\\text{Transaction Volume}}", description: "Network Value to Transactions ratio", whenToUse: "For cryptocurrency fundamental analysis"),
                FormulaVariant(name: "Active Address Model", formula: "V = k \\times (\\text{Active Addresses})^2", description: "Using blockchain active addresses", whenToUse: "For on-chain analysis")
            ],
            usageNotes: [
                "Works best for cryptocurrencies with payment/transfer utility",
                "May overestimate value during network growth phases",
                "Should be combined with other valuation methods",
                "Requires careful definition of 'active users'",
                "More applicable to utility tokens than store-of-value assets"
            ],
            examples: [
                FormulaExample(
                    title: "Bitcoin Network Valuation",
                    description: "Using daily active addresses to estimate network value",
                    inputs: ["Active Addresses": "800,000", "k factor": "$2.50"],
                    calculation: "V = $2.50 × (800,000)² = $2.50 × 6.4×10¹¹",
                    result: "$1.6 trillion network value",
                    interpretation: "Theoretical valuation based purely on network effects"
                )
            ],
            relatedFormulas: ["nvt-ratio", "network-density", "digital-asset-dcf"],
            tags: ["metcalfe", "network-effects", "cryptocurrency", "digital-assets", "blockchain", "valuation", "cfa-level-3"]
        )
    }
    
    private func createNVTRatioFormula() -> FormulaReference {
        FormulaReference(
            name: "Network Value to Transactions (NVT) Ratio",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "\\text{NVT} = \\frac{\\text{Market Capitalization}}{\\text{Daily Transaction Volume}}",
            description: "Cryptocurrency valuation metric analogous to P/E ratio. Measures network value relative to transactional utility.",
            variables: [
                FormulaVariable(symbol: "\\text{Market Cap}", name: "Market Capitalization", description: "Total value of cryptocurrency", units: "Currency units", typicalRange: "$1M to $1T+", notes: "Circulating supply × price"),
                FormulaVariable(symbol: "\\text{Daily Volume}", name: "Daily Transaction Volume", description: "Value of transactions processed daily", units: "Currency units", typicalRange: "Variable", notes: "On-chain transaction value")
            ],
            derivation: FormulaDerivation(
                title: "NVT as Digital Asset P/E Equivalent",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Transaction volume represents network utility", formula: "\\text{Utility} \\propto \\text{Transaction Volume}", explanation: "Higher volume indicates more network usage"),
                    DerivationStep(stepNumber: 2, description: "Network value should relate to utility", formula: "\\frac{\\text{Market Cap}}{\\text{Transaction Volume}} = \\text{Valuation Multiple}", explanation: "Similar to price-to-earnings concept"),
                    DerivationStep(stepNumber: 3, description: "Lower NVT suggests undervaluation", formula: "\\text{Low NVT} \\rightarrow \\text{High utility per dollar of value}", explanation: "Network processes more value relative to its market cap")
                ],
                assumptions: [
                    "Transaction volume reflects actual economic utility",
                    "Market cap represents fair network valuation",
                    "No artificial transaction volume inflation",
                    "Consistent transaction patterns over time"
                ],
                notes: "NVT analysis should use 90-day moving averages to smooth volatility and account for transaction patterns."
            ),
            variants: [
                FormulaVariant(name: "NVT Signal", formula: "\\text{NVT Signal} = \\frac{\\text{Market Cap}}{\\text{90-day MA Transaction Volume}}", description: "Smoothed version using moving average", whenToUse: "For trend analysis and volatility reduction"),
                FormulaVariant(name: "NVTS (Adjusted)", formula: "\\text{NVTS} = \\frac{\\text{Market Cap}}{\\text{Velocity-Adjusted Volume}}", description: "Adjusted for token velocity", whenToUse: "When token velocity varies significantly"),
                FormulaVariant(name: "NVT Revenue", formula: "\\text{NVTR} = \\frac{\\text{Market Cap}}{\\text{Network Revenue}}", description: "Using fee revenue instead of volume", whenToUse: "For fee-generating networks")
            ],
            usageNotes: [
                "NVT > 100 may indicate overvaluation",
                "NVT < 20 may indicate undervaluation",
                "Best used for payment/utility cryptocurrencies",
                "Less meaningful for store-of-value assets",
                "Should compare within similar cryptocurrency categories"
            ],
            examples: [
                FormulaExample(
                    title: "Ethereum NVT Analysis",
                    description: "Calculating NVT ratio for network valuation assessment",
                    inputs: ["Market Cap": "$400 billion", "Daily Transaction Volume": "$10 billion"],
                    calculation: "NVT = $400B ÷ $10B = 40",
                    result: "NVT ratio of 40",
                    interpretation: "Network cap is 40x daily transaction volume - within reasonable range"
                )
            ],
            relatedFormulas: ["metcalfe-law", "token-velocity", "digital-asset-dcf"],
            tags: ["nvt", "cryptocurrency", "valuation", "digital-assets", "transaction-volume", "blockchain", "cfa-level-3"]
        )
    }
    
    private func createTokenVelocityFormula() -> FormulaReference {
        FormulaReference(
            name: "Token Velocity",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "V = \\frac{\\text{Transaction Volume}}{\\text{Average Token Holdings}}",
            description: "Measures how frequently tokens change hands. High velocity can indicate limited store-of-value properties and potential price pressure.",
            variables: [
                FormulaVariable(symbol: "V", name: "Token Velocity", description: "Frequency of token turnover", units: "Turnover rate", typicalRange: "0.1 to 100+", notes: "Higher values indicate frequent trading"),
                FormulaVariable(symbol: "\\text{Transaction Volume}", name: "Total Transaction Volume", description: "Value of all token transactions", units: "Currency units", typicalRange: "Variable", notes: "Over specific time period"),
                FormulaVariable(symbol: "\\text{Average Holdings}", name: "Average Token Holdings", description: "Average market value of tokens held", units: "Currency units", typicalRange: "Variable", notes: "Market cap represents total holdings")
            ],
            derivation: FormulaDerivation(
                title: "Equation of Exchange for Digital Assets",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Monetary equation of exchange", formula: "MV = PQ", explanation: "Money supply × velocity = price × quantity"),
                    DerivationStep(stepNumber: 2, description: "Token equivalent", formula: "\\text{Token Supply} \\times V = \\text{Transaction Volume}", explanation: "Applied to cryptocurrency economics"),
                    DerivationStep(stepNumber: 3, description: "Velocity calculation", formula: "V = \\frac{\\text{Transaction Volume}}{\\text{Token Supply} \\times \\text{Price}}", explanation: "Rearranged to solve for velocity")
                ],
                assumptions: [
                    "Tokens serve as medium of exchange",
                    "Transaction volume captures all economic activity",
                    "Token supply is known and fixed",
                    "No hoarding effects distort velocity"
                ],
                notes: "High velocity can be problematic for token valuations as it suggests tokens aren't held long-term."
            ),
            variants: [
                FormulaVariant(name: "Network Velocity", formula: "V_{net} = \\frac{\\text{On-chain Volume}}{\\text{Circulating Supply Value}}", description: "Using only on-chain transactions", whenToUse: "For pure protocol analysis"),
                FormulaVariant(name: "Economic Velocity", formula: "V_{econ} = \\frac{\\text{GDP-equivalent Activity}}{\\text{Market Cap}}", description: "Economic activity measure", whenToUse: "For utility token valuation"),
                FormulaVariant(name: "Staking-Adjusted Velocity", formula: "V_{adj} = \\frac{\\text{Transaction Volume}}{\\text{Non-staked Token Value}}", description: "Excluding staked tokens from velocity", whenToUse: "For proof-of-stake networks")
            ],
            usageNotes: [
                "Lower velocity generally better for token value",
                "Payment tokens tend to have higher velocity",
                "Store-of-value tokens should have lower velocity",
                "Staking mechanisms can reduce effective velocity",
                "High velocity can indicate sell pressure"
            ],
            examples: [
                FormulaExample(
                    title: "Utility Token Velocity",
                    description: "Calculate velocity for governance token",
                    inputs: ["Annual Transaction Volume": "$50 billion", "Market Cap": "$5 billion"],
                    calculation: "V = $50B ÷ $5B = 10",
                    result: "Token velocity of 10",
                    interpretation: "Each token turns over 10 times per year - relatively high velocity"
                )
            ],
            relatedFormulas: ["nvt-ratio", "token-economics", "staking-yield"],
            tags: ["velocity", "token-economics", "cryptocurrency", "digital-assets", "monetary-theory", "cfa-level-3"]
        )
    }
    
    // Infrastructure Investment Formulas
    private func createRegulatedAssetBaseFormula() -> FormulaReference {
        FormulaReference(
            name: "Regulated Asset Base (RAB) Valuation",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "\\text{RAB Value} = \\sum_{t=1}^{n} \\frac{\\text{RAB}_t \\times \\text{WACC}_{allowed}}{(1 + \\text{WACC}_{equity})^t}",
            description: "Valuation method for regulated infrastructure assets based on regulatory asset base and allowed returns. Used for utilities, pipelines, and regulated networks.",
            variables: [
                FormulaVariable(symbol: "\\text{RAB}_t", name: "Regulated Asset Base", description: "Regulatory book value of assets in period t", units: "Currency units", typicalRange: "$100M to $50B+", notes: "Set by regulatory authority"),
                FormulaVariable(symbol: "\\text{WACC}_{allowed}", name: "Allowed Return", description: "Regulator-permitted return on assets", units: "Percentage", typicalRange: "4% to 8%", notes: "Usually real return, inflation-adjusted"),
                FormulaVariable(symbol: "\\text{WACC}_{equity}", name: "Market WACC", description: "Market-based discount rate", units: "Percentage", typicalRange: "6% to 12%", notes: "Reflects market risk perception")
            ],
            derivation: FormulaDerivation(
                title: "DCF for Regulated Infrastructure",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Regulatory cash flows", formula: "\\text{CF}_t = \\text{RAB}_t \\times \\text{Allowed Return}", explanation: "Regulators permit specific returns on asset base"),
                    DerivationStep(stepNumber: 2, description: "Present value calculation", formula: "\\text{PV} = \\sum \\frac{\\text{CF}_t}{(1 + r)^t}", explanation: "Standard DCF discounting"),
                    DerivationStep(stepNumber: 3, description: "RAB indexation", formula: "\\text{RAB}_{t+1} = \\text{RAB}_t \\times (1 + \\text{Inflation}) + \\text{Capex}_t - \\text{Depreciation}_t", explanation: "RAB grows with inflation and investment")
                ],
                assumptions: [
                    "Regulator maintains consistent allowed returns",
                    "RAB indexation mechanism remains stable",
                    "No regulatory risk or policy changes",
                    "Infrastructure assets have indefinite life"
                ],
                notes: "RAB valuation provides floor value for regulated infrastructure but market value can trade at premium/discount."
            ),
            variants: [
                FormulaVariant(name: "Real RAB Valuation", formula: "\\text{Value} = \\frac{\\text{RAB} \\times \\text{Real Return}}{\\text{Real Discount Rate}}", description: "Using real returns and discount rates", whenToUse: "When inflation indexation is explicit"),
                FormulaVariant(name: "RAB Multiple", formula: "\\text{Multiple} = \\frac{\\text{Enterprise Value}}{\\text{RAB}}", description: "Market value relative to RAB", whenToUse: "For comparative valuation"),
                FormulaVariant(name: "Regulatory Equity Value", formula: "\\text{Equity Value} = \\text{RAB Value} - \\text{Net Debt}", description: "Equity value after debt", whenToUse: "For equity investment analysis")
            ],
            usageNotes: [
                "RAB multiples typically range from 0.8x to 1.4x",
                "Premium to RAB reflects regulatory stability and growth",
                "Discount to RAB indicates regulatory risk concerns",
                "Works best for established regulated utilities",
                "Consider regulatory review periods and reset risk"
            ],
            examples: [
                FormulaExample(
                    title: "UK Water Utility Valuation",
                    description: "Value regulated water company using RAB approach",
                    inputs: ["RAB": "£2.5 billion", "Allowed Real Return": "4.2%", "Market Discount Rate": "6.5%"],
                    calculation: "Value = £2.5B × 4.2% ÷ 6.5% = £1.62B",
                    result: "Enterprise value of £1.62 billion",
                    interpretation: "Trading at 0.65x RAB indicates potential regulatory concerns"
                )
            ],
            relatedFormulas: ["infrastructure-dcf", "utility-dividend-model", "capex-indexation"],
            tags: ["rab", "infrastructure", "regulated-utilities", "dcf", "regulatory-finance", "cfa-level-3"]
        )
    }
    
    private func createInfrastructureDCFFormula() -> FormulaReference {
        FormulaReference(
            name: "Infrastructure DCF Model",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "\\text{NPV} = \\sum_{t=1}^{n} \\frac{\\text{EBITDA}_t - \\text{Tax}_t - \\text{Capex}_t}{(1 + \\text{WACC})^t} + \\frac{\\text{Terminal Value}}{(1 + \\text{WACC})^n}",
            description: "Specialized DCF model for infrastructure investments accounting for long asset lives, inflation indexation, and regulated/contracted cash flows.",
            variables: [
                FormulaVariable(symbol: "\\text{EBITDA}_t", name: "Operating Cash Flow", description: "Earnings before interest, tax, depreciation", units: "Currency units", typicalRange: "Variable", notes: "Often inflation-indexed"),
                FormulaVariable(symbol: "\\text{Tax}_t", name: "Tax Payments", description: "Corporate tax on operating profits", units: "Currency units", typicalRange: "15-35% of profits", notes: "May include tax depreciation benefits"),
                FormulaVariable(symbol: "\\text{Capex}_t", name: "Capital Expenditure", description: "Maintenance and growth capital", units: "Currency units", typicalRange: "1-5% of asset value", notes: "Critical for long-lived assets"),
                FormulaVariable(symbol: "\\text{WACC}", name: "Weighted Average Cost of Capital", description: "Blended cost of debt and equity", units: "Percentage", typicalRange: "5% to 10%", notes: "Lower than corporate average due to stability")
            ],
            derivation: FormulaDerivation(
                title: "Long-Duration Infrastructure Valuation",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Free cash flow calculation", formula: "\\text{FCF} = \\text{EBITDA} - \\text{Tax} - \\text{Maintenance Capex}", explanation: "Available cash after required investments"),
                    DerivationStep(stepNumber: 2, description: "Inflation adjustment", formula: "\\text{FCF}_{t+1} = \\text{FCF}_t \\times (1 + \\text{Inflation})", explanation: "Many infrastructure cash flows are inflation-linked"),
                    DerivationStep(stepNumber: 3, description: "Terminal value", formula: "\\text{TV} = \\frac{\\text{FCF}_{n+1}}{\\text{WACC} - g}", explanation: "Perpetual value given long asset lives")
                ],
                assumptions: [
                    "Stable regulatory environment",
                    "Predictable inflation-linked revenues",
                    "Long-term contracts or regulated pricing",
                    "Maintenance capex preserves asset value"
                ],
                notes: "Infrastructure DCF often uses real terms to handle inflation more transparently."
            ),
            variants: [
                FormulaVariant(name: "Real Terms DCF", formula: "\\text{NPV} = \\sum \\frac{\\text{Real FCF}_t}{(1 + \\text{Real WACC})^t}", description: "Using real cash flows and discount rates", whenToUse: "When inflation indexation is explicit"),
                FormulaVariant(name: "Contract-by-Contract Model", formula: "\\text{NPV} = \\sum \\text{PV of Individual Contracts}", description: "Valuing each revenue contract separately", whenToUse: "For complex multi-contract assets"),
                FormulaVariant(name: "Availability-Based Model", formula: "\\text{Revenue} = \\text{Availability} \\times \\text{Service Fee}", description: "For availability-based infrastructure", whenToUse: "PPP and PFI projects")
            ],
            usageNotes: [
                "Use lower discount rates than typical corporates (5-8%)",
                "Model explicit inflation linkage mechanisms",
                "Consider regulatory reset periods and risks",
                "Account for asset replacement cycles",
                "Terminal values often 50-70% of total value"
            ],
            examples: [
                FormulaExample(
                    title: "Toll Road Valuation",
                    description: "25-year concession with inflation-linked tolls",
                    inputs: ["Year 1 EBITDA": "€50M", "Inflation": "2%", "WACC": "6%", "Terminal Growth": "2%"],
                    calculation: "NPV = PV of 25-year growing annuity + Terminal Value",
                    result: "€1.2 billion enterprise value",
                    interpretation: "Long-duration cash flows create substantial value"
                )
            ],
            relatedFormulas: ["rab-valuation", "yield-model", "concession-valuation"],
            tags: ["infrastructure", "dcf", "inflation-indexation", "long-duration", "regulated-assets", "cfa-level-3"]
        )
    }
    
    // Natural Resources Formulas  
    private func createOilGasReservesNPVFormula() -> FormulaReference {
        FormulaReference(
            name: "Oil & Gas Reserves NPV",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "\\text{NPV} = \\sum_{t=1}^{n} \\frac{(P_t - C_t) \\times Q_t - Capex_t}{(1 + r)^t} - I_0",
            description: "Net present value of oil and gas reserves considering commodity prices, production costs, decline rates, and development capital requirements.",
            variables: [
                FormulaVariable(symbol: "P_t", name: "Commodity Price", description: "Oil or gas price in period t", units: "$/barrel or $/mcf", typicalRange: "$20-150/bbl", notes: "Highly volatile, use long-term forecasts"),
                FormulaVariable(symbol: "C_t", name: "Operating Cost", description: "Per-unit operating cost", units: "$/barrel or $/mcf", typicalRange: "$10-80/bbl", notes: "Includes lifting costs, transport, royalties"),
                FormulaVariable(symbol: "Q_t", name: "Production Volume", description: "Production in period t", units: "Barrels or mcf", typicalRange: "Variable", notes: "Follows decline curve"),
                FormulaVariable(symbol: "r", name: "Discount Rate", description: "Risk-adjusted discount rate", units: "Percentage", typicalRange: "8% to 15%", notes: "Reflects commodity price risk"),
                FormulaVariable(symbol: "I_0", name: "Initial Investment", description: "Development capex", units: "Currency units", typicalRange: "$1M to $50B+", notes: "Drilling, facilities, pipeline costs")
            ],
            derivation: FormulaDerivation(
                title: "Commodity Asset Valuation Framework",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Annual cash flow", formula: "\\text{CF}_t = (P_t - C_t) \\times Q_t - \\text{Capex}_t", explanation: "Net revenue minus operating and capital costs"),
                    DerivationStep(stepNumber: 2, description: "Production decline", formula: "Q_t = Q_0 \\times e^{-d \\times t}", explanation: "Exponential decline in production"),
                    DerivationStep(stepNumber: 3, description: "Reserve life", formula: "n = \\frac{\\ln(Q_0 / Q_{economic})}{d}", explanation: "Project life until uneconomic production")
                ],
                assumptions: [
                    "Reserves estimates are accurate (P50/P90)",
                    "Production follows predictable decline curve",
                    "Commodity prices follow long-term forecasts",
                    "Operating costs remain stable in real terms"
                ],
                notes: "Use P90 reserves for conservative valuation, P50 for expected case. Consider abandonment costs at end of life."
            ),
            variants: [
                FormulaVariant(name: "Real Options Valuation", formula: "\\text{Value} = \\text{Base NPV} + \\text{Option Values}", description: "Including expansion and abandonment options", whenToUse: "For volatile commodity environments"),
                FormulaVariant(name: "Risk-Adjusted NPV", formula: "\\text{rNPV} = \\text{Probability} \\times \\text{NPV}", description: "Geological risk adjustment", whenToUse: "For exploration and development projects"),
                FormulaVariant(name: "NAV per Share", formula: "\\text{NAV/Share} = \\frac{\\sum \\text{Asset NPVs} - \\text{Net Debt}}{\\text{Shares Outstanding}}", description: "Equity value per share", whenToUse: "For public E&P company valuation")
            ],
            usageNotes: [
                "Use flat or slightly declining real commodity prices",
                "Higher discount rates for exploration vs. production assets",
                "Consider fiscal regime changes and government take",
                "Model abandonment and decommissioning costs",
                "Include option value for undeveloped reserves"
            ],
            examples: [
                FormulaExample(
                    title: "Offshore Oil Field Valuation",
                    description: "Value proven reserves with 15-year production life",
                    inputs: ["Oil Price": "$70/bbl", "Operating Cost": "$25/bbl", "Initial Production": "50,000 bpd", "Decline Rate": "8%/year", "Discount Rate": "12%"],
                    calculation: "NPV = Σ[(70-25) × 50,000 × 365 × e^(-0.08×t)] / (1.12)^t",
                    result: "$890 million NPV",
                    interpretation: "Positive NPV suggests economically viable project"
                )
            ],
            relatedFormulas: ["depletion-accounting", "commodity-derivatives", "resource-multiple"],
            tags: ["oil-gas", "reserves", "commodity-valuation", "natural-resources", "dcf", "energy", "cfa-level-3"]
        )
    }
    
    private func createDepletionAccountingFormula() -> FormulaReference {
        FormulaReference(
            name: "Depletion Accounting",
            category: .alternatives,
            level: .levelII,
            mainFormula: "\\text{Depletion Rate} = \\frac{\\text{Acquisition Cost}}{\\text{Total Recoverable Reserves}}",
            description: "Systematic allocation of natural resource asset costs based on extraction volumes. Critical for understanding true economics of resource extraction businesses.",
            variables: [
                FormulaVariable(symbol: "\\text{Acquisition Cost}", name: "Total Asset Cost", description: "Historical cost of acquiring reserves", units: "Currency units", typicalRange: "Variable", notes: "Includes exploration, development, acquisition costs"),
                FormulaVariable(symbol: "\\text{Recoverable Reserves}", name: "Proven Reserves", description: "Economically recoverable resource volumes", units: "Barrels, tons, mcf", typicalRange: "Variable", notes: "Based on current prices and technology"),
                FormulaVariable(symbol: "\\text{Annual Depletion}", name: "Period Depletion", description: "Depletion expense for period", units: "Currency units", typicalRange: "Variable", notes: "Depletion rate × production volume")
            ],
            derivation: FormulaDerivation(
                title: "Natural Resource Asset Amortization",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Calculate unit depletion rate", formula: "\\text{Rate} = \\frac{\\text{Book Value}}{\\text{Remaining Reserves}}", explanation: "Cost per unit of resource extracted"),
                    DerivationStep(stepNumber: 2, description: "Annual depletion expense", formula: "\\text{Depletion} = \\text{Rate} \\times \\text{Production Volume}", explanation: "Allocate cost based on extraction"),
                    DerivationStep(stepNumber: 3, description: "Remaining book value", formula: "\\text{Book Value}_{t+1} = \\text{Book Value}_t - \\text{Depletion}_t + \\text{New Investment}", explanation: "Asset book value reduction")
                ],
                assumptions: [
                    "Reserve estimates are reliable and stable",
                    "Production follows straight-line or units-of-production method",
                    "No impairment of remaining reserves",
                    "Economic viability remains constant"
                ],
                notes: "Depletion differs from depreciation as it's based on actual resource extraction rather than time passage."
            ),
            variants: [
                FormulaVariant(name: "Percentage Depletion", formula: "\\text{Depletion} = \\text{Gross Income} \\times \\text{Depletion Percentage}", description: "Tax-based depletion method", whenToUse: "For US tax calculations"),
                FormulaVariant(name: "Units of Production", formula: "\\text{Depletion} = \\frac{\\text{Current Production}}{\\text{Total Reserves}} \\times \\text{Asset Cost}", description: "Most common method", whenToUse: "For financial reporting"),
                FormulaVariant(name: "Discovery Value Depletion", formula: "\\text{Rate} = \\frac{\\text{Discovery Value}}{\\text{Reserves Added}}", description: "Based on discovery costs", whenToUse: "For exploration companies")
            ],
            usageNotes: [
                "Must update reserve estimates regularly",
                "Consider impairment when commodity prices fall",
                "Depletion reduces book value and taxable income",
                "Different methods for tax vs. financial reporting",
                "DD&A often largest expense for resource companies"
            ],
            examples: [
                FormulaExample(
                    title: "Coal Mine Depletion",
                    description: "Calculate annual depletion for mining operation",
                    inputs: ["Mine Acquisition Cost": "$500 million", "Total Reserves": "100 million tons", "Annual Production": "5 million tons"],
                    calculation: "Depletion Rate = $500M ÷ 100M tons = $5/ton\nAnnual Depletion = $5/ton × 5M tons = $25M",
                    result: "$25 million annual depletion",
                    interpretation: "Allocates 5% of asset cost based on 5% of reserves extracted"
                )
            ],
            relatedFormulas: ["oil-gas-reserves-npv", "discovery-cost", "reserve-replacement"],
            tags: ["depletion", "natural-resources", "accounting", "mining", "oil-gas", "cost-allocation", "cfa-level-2"]
        )
    }
    
    // Fund-of-Funds Complex Structures
    private func createFundOfFundsFeesFormula() -> FormulaReference {
        FormulaReference(
            name: "Fund-of-Funds Fee Layering",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "\\text{Total Fees} = \\text{FoF Mgmt Fee} + \\text{FoF Performance Fee} + \\text{Underlying Mgmt Fees} + \\text{Underlying Performance Fees}",
            description: "Comprehensive fee calculation for fund-of-funds structures showing fee layering effects that can significantly impact net returns to investors.",
            variables: [
                FormulaVariable(symbol: "\\text{FoF Mgmt Fee}", name: "Fund-of-Funds Management Fee", description: "Annual fee charged by FoF manager", units: "Percentage of AUM", typicalRange: "0.5% to 1.5%", notes: "Applied to total fund-of-funds assets"),
                FormulaVariable(symbol: "\\text{FoF Perf Fee}", name: "Fund-of-Funds Performance Fee", description: "Carried interest on FoF performance", units: "Percentage of profits", typicalRange: "5% to 15%", notes: "Usually lower than direct fund fees"),
                FormulaVariable(symbol: "\\text{Underlying Mgmt}", name: "Underlying Fund Management Fees", description: "Weighted average of underlying fund fees", units: "Percentage of AUM", typicalRange: "1.5% to 2.5%", notes: "Applied to underlying fund investments"),
                FormulaVariable(symbol: "\\text{Underlying Perf}", name: "Underlying Performance Fees", description: "Weighted average carried interest", units: "Percentage of profits", typicalRange: "15% to 25%", notes: "Standard private equity/hedge fund carry")
            ],
            derivation: FormulaDerivation(
                title: "Fee Impact on Net Returns",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Gross return generation", formula: "\\text{Gross Return} = \\sum w_i \\times \\text{Underlying Returns}_i", explanation: "Weighted returns from underlying funds"),
                    DerivationStep(stepNumber: 2, description: "First layer fees", formula: "\\text{Net of Underlying} = \\text{Gross} - \\text{Underlying Fees}", explanation: "Returns after underlying fund fees"),
                    DerivationStep(stepNumber: 3, description: "Second layer fees", formula: "\\text{Net to Investor} = \\text{Net of Underlying} - \\text{FoF Fees}", explanation: "Final returns after all fee layers")
                ],
                assumptions: [
                    "Underlying funds achieve target returns",
                    "Performance fees calculated on net returns",
                    "No fee rebates or preferred terms",
                    "Standard waterfall and hurdle structures"
                ],
                notes: "Fee layering can reduce gross returns by 300-500 basis points annually, significantly impacting long-term compound returns."
            ),
            variants: [
                FormulaVariant(name: "All-In Fee Rate", formula: "\\text{All-In} = 1 - \\frac{\\text{Net Return}}{\\text{Gross Return}}", description: "Total fee impact as percentage", whenToUse: "For performance attribution analysis"),
                FormulaVariant(name: "Fee Alpha Impact", formula: "\\text{Alpha Impact} = \\text{FoF Alpha} - \\text{Fee Drag}", description: "Value-add after fee consideration", whenToUse: "For manager selection decisions"),
                FormulaVariant(name: "Breakeven Analysis", formula: "\\text{Required Alpha} = \\text{Total Fee Rate} + \\text{Index Return}", description: "Performance needed to justify fees", whenToUse: "For investment committee analysis")
            ],
            usageNotes: [
                "Fee layering creates significant drag on returns",
                "Consider fee rebates and preferred terms for large investors",
                "Side pockets may incur additional fees",
                "Gates and lockups can compound fee impact",
                "Manager selection becomes critical to overcome fee drag"
            ],
            examples: [
                FormulaExample(
                    title: "Private Equity Fund-of-Funds Analysis",
                    description: "Calculate total fee impact for diversified PE FoF",
                    inputs: ["FoF Management Fee": "1.0%", "FoF Carry": "8%", "Underlying Mgmt Fee": "2.0%", "Underlying Carry": "20%", "Gross Return": "15%"],
                    calculation: "Management: 1.0% + 2.0% = 3.0%\nPerformance: 8% of (15% - fees) + 20% of profits\nTotal fee impact ≈ 4.5% annually",
                    result: "Net return ≈ 10.5% vs. 15% gross",
                    interpretation: "Fee layering reduces returns by 450bp annually"
                )
            ],
            relatedFormulas: ["waterfall-analysis", "side-pocket-fees", "gate-provisions"],
            tags: ["fund-of-funds", "fee-layering", "alternative-investments", "institutional-investing", "performance-attribution", "cfa-level-3"]
        )
    }
    
    private func createSidePocketProvisionFormula() -> FormulaReference {
        FormulaReference(
            name: "Side Pocket Valuation",
            category: .alternatives,
            level: .levelIII,
            mainFormula: "\\text{Side Pocket Value} = \\frac{\\text{Illiquid Asset FV}}{1 + \\text{Liquidity Discount}} \\times \\text{Investor Allocation}",
            description: "Valuation methodology for illiquid investments segregated into side pockets within hedge funds and other alternative investment structures.",
            variables: [
                FormulaVariable(symbol: "\\text{Illiquid Asset FV}", name: "Fair Value of Illiquid Asset", description: "Manager's estimate of asset fair value", units: "Currency units", typicalRange: "Variable", notes: "Subject to valuation uncertainty"),
                FormulaVariable(symbol: "\\text{Liquidity Discount}", name: "Illiquidity Discount", description: "Discount for lack of liquidity", units: "Percentage", typicalRange: "10% to 50%", notes: "Reflects exit uncertainty and timing"),
                FormulaVariable(symbol: "\\text{Investor Allocation}", name: "Investor's Pro Rata Share", description: "Percentage ownership in side pocket", units: "Percentage", typicalRange: "Variable", notes: "Based on capital at side pocket creation")
            ],
            derivation: FormulaDerivation(
                title: "Side Pocket Economics",
                steps: [
                    DerivationStep(stepNumber: 1, description: "Asset isolation", formula: "\\text{Side Pocket} = \\text{Segregated Illiquid Assets}", explanation: "Assets transferred to separate accounting"),
                    DerivationStep(stepNumber: 2, description: "Ownership allocation", formula: "\\text{Ownership} = \\frac{\\text{Investor Capital}}{\\text{Total Fund Capital}} \\text{ at creation}", explanation: "Pro rata based on timing"),
                    DerivationStep(stepNumber: 3, description: "Value realization", formula: "\\text{Distributions} = \\text{Realized Value} \\times \\text{Ownership}", explanation: "Paid out upon asset monetization")
                ],
                assumptions: [
                    "Fair value estimates are reasonable",
                    "Manager acts in investors' best interests",
                    "No preferential liquidation rights",
                    "Side pocket creation is justified by illiquidity"
                ],
                notes: "Side pockets protect remaining fund liquidity but create long-dated, uncertain value for investors."
            ),
            variants: [
                FormulaVariant(name: "Mark-to-Market Side Pocket", formula: "\\text{Value} = \\text{Latest Market Price} \\times \\text{Holdings}", description: "Using observable market prices", whenToUse: "When some price discovery exists"),
                FormulaVariant(name: "Discounted Cash Flow Side Pocket", formula: "\\text{Value} = \\text{NPV of Expected Distributions}", description: "DCF approach for complex assets", whenToUse: "For structured products or operating companies"),
                FormulaVariant(name: "Liquidation Value", formula: "\\text{Value} = \\text{Forced Sale Price} \\times \\text{Recovery Rate}", description: "Distressed scenario valuation", whenToUse: "For worst-case analysis")
            ],
            usageNotes: [
                "Side pockets lock up investor capital indefinitely",
                "Valuations are often highly subjective",
                "May incur additional management fees",
                "Can significantly impact fund liquidity terms",
                "Consider side pocket risk in allocation decisions"
            ],
            examples: [
                FormulaExample(
                    title: "Hedge Fund Side Pocket",
                    description: "Calculate value of illiquid debt securities in side pocket",
                    inputs: ["Asset Fair Value": "$50 million", "Liquidity Discount": "25%", "Investor Allocation": "3.2%"],
                    calculation: "Side Pocket Value = $50M ÷ (1 + 0.25) × 3.2%\n= $40M × 3.2% = $1.28M",
                    result: "$1.28 million side pocket value",
                    interpretation: "Investor has $1.28M locked up in illiquid assets"
                )
            ],
            relatedFormulas: ["fund-of-funds-fees", "gate-provisions", "illiquidity-premium"],
            tags: ["side-pocket", "hedge-funds", "illiquid-assets", "valuation", "alternative-investments", "liquidity-risk", "cfa-level-3"]
        )
    }
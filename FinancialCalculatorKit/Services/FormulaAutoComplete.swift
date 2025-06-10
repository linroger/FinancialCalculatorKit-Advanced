//
//  FormulaAutoComplete.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation

/// Auto-completion suggestions for mathematical formulas and functions
class FormulaAutoComplete {
    
    struct Suggestion {
        let title: String
        let subtitle: String
        let completion: String
        let latexFormula: String
        let category: Category
        let insertionText: String
        
        enum Category: String, CaseIterable {
            case geometry = "Geometry"
            case calculus = "Calculus"
            case algebra = "Algebra"
            case trigonometry = "Trigonometry"
            case statistics = "Statistics"
            case physics = "Physics"
            case finance = "Finance"
            case constants = "Constants"
            case functions = "Functions"
        }
    }
    
    private let commonFormulas: [Suggestion] = [
        // Geometry
        Suggestion(
            title: "Area of Circle",
            subtitle: "A = πr²",
            completion: "pi * r^2",
            latexFormula: "A = \\pi r^2",
            category: .geometry,
            insertionText: "π * r^2"
        ),
        Suggestion(
            title: "Volume of Sphere",
            subtitle: "V = (4/3)πr³",
            completion: "(4/3) * pi * r^3",
            latexFormula: "V = \\frac{4}{3}\\pi r^3",
            category: .geometry,
            insertionText: "(4/3) * π * r^3"
        ),
        Suggestion(
            title: "Surface Area of Sphere",
            subtitle: "A = 4πr²",
            completion: "4 * pi * r^2",
            latexFormula: "A = 4\\pi r^2",
            category: .geometry,
            insertionText: "4 * π * r^2"
        ),
        Suggestion(
            title: "Volume of Cylinder",
            subtitle: "V = πr²h",
            completion: "pi * r^2 * h",
            latexFormula: "V = \\pi r^2 h",
            category: .geometry,
            insertionText: "π * r^2 * h"
        ),
        Suggestion(
            title: "Pythagorean Theorem",
            subtitle: "c² = a² + b²",
            completion: "sqrt(a^2 + b^2)",
            latexFormula: "c = \\sqrt{a^2 + b^2}",
            category: .geometry,
            insertionText: "sqrt(a^2 + b^2)"
        ),
        
        // Calculus
        Suggestion(
            title: "Derivative of x^n",
            subtitle: "d/dx[x^n] = nx^(n-1)",
            completion: "n * x^(n-1)",
            latexFormula: "\\frac{d}{dx}[x^n] = nx^{n-1}",
            category: .calculus,
            insertionText: "n * x^(n-1)"
        ),
        Suggestion(
            title: "Chain Rule",
            subtitle: "d/dx[f(g(x))] = f'(g(x))·g'(x)",
            completion: "f_prime(g(x)) * g_prime(x)",
            latexFormula: "\\frac{d}{dx}[f(g(x))] = f'(g(x)) \\cdot g'(x)",
            category: .calculus,
            insertionText: "f'(g(x)) * g'(x)"
        ),
        
        // Algebra
        Suggestion(
            title: "Quadratic Formula",
            subtitle: "x = (-b ± √(b²-4ac))/2a",
            completion: "(-b + sqrt(b^2 - 4*a*c))/(2*a)",
            latexFormula: "x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}",
            category: .algebra,
            insertionText: "(-b ± sqrt(b^2 - 4*a*c))/(2*a)"
        ),
        Suggestion(
            title: "Binomial Theorem",
            subtitle: "(a+b)^n = Σ(n choose k)a^(n-k)b^k",
            completion: "sum(binomial(n,k) * a^(n-k) * b^k, k, 0, n)",
            latexFormula: "(a+b)^n = \\sum_{k=0}^{n} \\binom{n}{k} a^{n-k} b^k",
            category: .algebra,
            insertionText: "sum(C(n,k) * a^(n-k) * b^k, k, 0, n)"
        ),
        
        // Trigonometry
        Suggestion(
            title: "Pythagorean Identity",
            subtitle: "sin²θ + cos²θ = 1",
            completion: "sin(θ)^2 + cos(θ)^2",
            latexFormula: "\\sin^2\\theta + \\cos^2\\theta = 1",
            category: .trigonometry,
            insertionText: "sin(θ)^2 + cos(θ)^2"
        ),
        Suggestion(
            title: "Law of Cosines",
            subtitle: "c² = a² + b² - 2ab·cos(C)",
            completion: "sqrt(a^2 + b^2 - 2*a*b*cos(C))",
            latexFormula: "c^2 = a^2 + b^2 - 2ab\\cos C",
            category: .trigonometry,
            insertionText: "sqrt(a^2 + b^2 - 2*a*b*cos(C))"
        ),
        Suggestion(
            title: "Double Angle Formula (sin)",
            subtitle: "sin(2θ) = 2sin(θ)cos(θ)",
            completion: "2*sin(θ)*cos(θ)",
            latexFormula: "\\sin(2\\theta) = 2\\sin\\theta\\cos\\theta",
            category: .trigonometry,
            insertionText: "2*sin(θ)*cos(θ)"
        ),
        
        // Statistics
        Suggestion(
            title: "Normal Distribution",
            subtitle: "f(x) = (1/σ√(2π))e^(-½((x-μ)/σ)²)",
            completion: "(1/(σ*sqrt(2*π)))*exp(-0.5*((x-μ)/σ)^2)",
            latexFormula: "f(x) = \\frac{1}{\\sigma\\sqrt{2\\pi}} e^{-\\frac{1}{2}\\left(\\frac{x-\\mu}{\\sigma}\\right)^2}",
            category: .statistics,
            insertionText: "(1/(σ*sqrt(2*π)))*exp(-0.5*((x-μ)/σ)^2)"
        ),
        Suggestion(
            title: "Standard Deviation",
            subtitle: "σ = √(Σ(x-μ)²/N)",
            completion: "sqrt(sum((x-μ)^2)/N)",
            latexFormula: "\\sigma = \\sqrt{\\frac{\\sum(x-\\mu)^2}{N}}",
            category: .statistics,
            insertionText: "sqrt(sum((x-μ)^2)/N)"
        ),
        
        // Physics
        Suggestion(
            title: "Kinetic Energy",
            subtitle: "KE = ½mv²",
            completion: "0.5 * m * v^2",
            latexFormula: "KE = \\frac{1}{2}mv^2",
            category: .physics,
            insertionText: "0.5 * m * v^2"
        ),
        Suggestion(
            title: "Einstein's Mass-Energy",
            subtitle: "E = mc²",
            completion: "m * c^2",
            latexFormula: "E = mc^2",
            category: .physics,
            insertionText: "m * c^2"
        ),
        Suggestion(
            title: "Coulomb's Law",
            subtitle: "F = k(q₁q₂)/r²",
            completion: "k * (q1 * q2) / r^2",
            latexFormula: "F = k\\frac{q_1 q_2}{r^2}",
            category: .physics,
            insertionText: "k * (q1 * q2) / r^2"
        ),
        
        // Finance
        Suggestion(
            title: "Compound Interest",
            subtitle: "A = P(1 + r/n)^(nt)",
            completion: "P * (1 + r/n)^(n*t)",
            latexFormula: "A = P\\left(1 + \\frac{r}{n}\\right)^{nt}",
            category: .finance,
            insertionText: "P * (1 + r/n)^(n*t)"
        ),
        Suggestion(
            title: "Present Value",
            subtitle: "PV = FV/(1+r)^n",
            completion: "FV / (1 + r)^n",
            latexFormula: "PV = \\frac{FV}{(1+r)^n}",
            category: .finance,
            insertionText: "FV / (1 + r)^n"
        ),
        Suggestion(
            title: "Black-Scholes Call",
            subtitle: "C = S₀N(d₁) - Xe^(-rT)N(d₂)",
            completion: "S0 * N(d1) - X * exp(-r*T) * N(d2)",
            latexFormula: "C = S_0 N(d_1) - Xe^{-rT} N(d_2)",
            category: .finance,
            insertionText: "S0 * N(d1) - X * exp(-r*T) * N(d2)"
        )
    ]
    
    private let functions: [Suggestion] = [
        // Basic functions
        Suggestion(
            title: "Sine",
            subtitle: "sin(x)",
            completion: "sin(",
            latexFormula: "\\sin(x)",
            category: .functions,
            insertionText: "sin("
        ),
        Suggestion(
            title: "Cosine",
            subtitle: "cos(x)",
            completion: "cos(",
            latexFormula: "\\cos(x)",
            category: .functions,
            insertionText: "cos("
        ),
        Suggestion(
            title: "Tangent",
            subtitle: "tan(x)",
            completion: "tan(",
            latexFormula: "\\tan(x)",
            category: .functions,
            insertionText: "tan("
        ),
        Suggestion(
            title: "Natural Logarithm",
            subtitle: "ln(x)",
            completion: "ln(",
            latexFormula: "\\ln(x)",
            category: .functions,
            insertionText: "ln("
        ),
        Suggestion(
            title: "Square Root",
            subtitle: "√x",
            completion: "sqrt(",
            latexFormula: "\\sqrt{x}",
            category: .functions,
            insertionText: "sqrt("
        ),
        Suggestion(
            title: "Absolute Value",
            subtitle: "|x|",
            completion: "abs(",
            latexFormula: "|x|",
            category: .functions,
            insertionText: "abs("
        ),
        Suggestion(
            title: "Factorial",
            subtitle: "n!",
            completion: "factorial(",
            latexFormula: "n!",
            category: .functions,
            insertionText: "factorial("
        ),
        Suggestion(
            title: "Summation",
            subtitle: "Σ",
            completion: "sum(",
            latexFormula: "\\sum",
            category: .functions,
            insertionText: "sum("
        )
    ]
    
    private let constants: [Suggestion] = [
        Suggestion(
            title: "Pi",
            subtitle: "π ≈ 3.14159",
            completion: "π",
            latexFormula: "\\pi",
            category: .constants,
            insertionText: "π"
        ),
        Suggestion(
            title: "Euler's Number",
            subtitle: "e ≈ 2.71828",
            completion: "e",
            latexFormula: "e",
            category: .constants,
            insertionText: "e"
        ),
        Suggestion(
            title: "Golden Ratio",
            subtitle: "φ ≈ 1.618",
            completion: "φ",
            latexFormula: "\\phi",
            category: .constants,
            insertionText: "φ"
        ),
        Suggestion(
            title: "Speed of Light",
            subtitle: "c = 299,792,458 m/s",
            completion: "c",
            latexFormula: "c",
            category: .constants,
            insertionText: "c"
        )
    ]
    
    /// Gets suggestions based on input text
    func getSuggestions(for input: String, limit: Int = 10) -> [Suggestion] {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if trimmedInput.isEmpty {
            return Array(commonFormulas.prefix(limit))
        }
        
        var suggestions: [Suggestion] = []
        
        // Add exact matches first
        suggestions.append(contentsOf: getAllSuggestions().filter {
            $0.title.lowercased().hasPrefix(trimmedInput)
        })
        
        // Add partial matches
        suggestions.append(contentsOf: getAllSuggestions().filter {
            !$0.title.lowercased().hasPrefix(trimmedInput) &&
            ($0.title.lowercased().contains(trimmedInput) ||
             $0.subtitle.lowercased().contains(trimmedInput) ||
             $0.completion.lowercased().contains(trimmedInput))
        })
        
        // Remove duplicates
        suggestions = Array(Set(suggestions.map { $0.title })).compactMap { title in
            suggestions.first { $0.title == title }
        }
        
        return Array(suggestions.prefix(limit))
    }
    
    /// Gets suggestions by category
    func getSuggestions(for category: Suggestion.Category) -> [Suggestion] {
        return getAllSuggestions().filter { $0.category == category }
    }
    
    /// Gets all available suggestions
    func getAllSuggestions() -> [Suggestion] {
        return commonFormulas + functions + constants
    }
    
    /// Gets suggestions for function completion based on cursor position
    func getFunctionCompletions(for input: String, cursorPosition: Int) -> [Suggestion] {
        let beforeCursor = String(input.prefix(cursorPosition))
        
        // Check if we're in the middle of typing a function
        let functionPattern = #"([a-zA-Z]+)$"#
        guard let regex = try? NSRegularExpression(pattern: functionPattern),
              let match = regex.firstMatch(in: beforeCursor, range: NSRange(beforeCursor.startIndex..., in: beforeCursor)) else {
            return []
        }
        
        let partialFunction = String(beforeCursor[Range(match.range, in: beforeCursor)!])
        return functions.filter { $0.title.lowercased().hasPrefix(partialFunction.lowercased()) }
    }
    
    /// Suggests variable completions
    func getVariableCompletions(from variableStore: VariableStore, input: String) -> [String] {
        let variables = variableStore.getVariableNames()
        return variables.filter { $0.lowercased().hasPrefix(input.lowercased()) }
    }
}

// Make Suggestion hashable for Set operations
extension FormulaAutoComplete.Suggestion: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: FormulaAutoComplete.Suggestion, rhs: FormulaAutoComplete.Suggestion) -> Bool {
        return lhs.title == rhs.title
    }
}
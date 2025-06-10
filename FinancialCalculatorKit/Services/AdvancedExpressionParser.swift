//
//  AdvancedExpressionParser.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import MathParser

/// Advanced expression parser with LaTeX support and variable substitution
class AdvancedExpressionParser {
    
    enum ParseError: LocalizedError {
        case invalidExpression
        case undefinedVariable(String)
        case syntaxError(String)
        case divisionByZero
        case complexResult
        
        var errorDescription: String? {
            switch self {
            case .invalidExpression:
                return "Invalid expression"
            case .undefinedVariable(let variable):
                return "Undefined variable: \(variable)"
            case .syntaxError(let message):
                return "Syntax error: \(message)"
            case .divisionByZero:
                return "Division by zero"
            case .complexResult:
                return "Complex number result"
            }
        }
    }
    
    struct ParseResult {
        let value: Double
        let usedVariables: [String]
        let latexExpression: String
        let simplifiedExpression: String
    }
    
    private let variableStore: VariableStore
    private let mathParser = MathParser()
    
    init(variableStore: VariableStore) {
        self.variableStore = variableStore
    }
    
    /// Parses and evaluates an expression with variable substitution
    func parseExpression(_ expression: String) throws -> ParseResult {
        let preprocessed = preprocessExpression(expression)
        let (substituted, usedVariables) = substituteVariables(preprocessed)
        
        // Validate syntax
        try validateSyntax(substituted)
        
        // Evaluate expression
        guard let evaluator = mathParser.parse(substituted) else {
            throw ParseError.syntaxError("Unable to parse expression")
        }
        
        let result = evaluator.eval()
        
        // Check for invalid results
        if result.isNaN {
            throw ParseError.invalidExpression
        }
        if result.isInfinite {
            throw ParseError.divisionByZero
        }
        
        // Generate LaTeX
        let latexExpression = generateLatexExpression(expression)
        let simplifiedExpression = simplifyExpression(expression)
        
        return ParseResult(
            value: result,
            usedVariables: usedVariables,
            latexExpression: latexExpression,
            simplifiedExpression: simplifiedExpression
        )
    }
    
    /// Preprocesses expression to handle special symbols
    private func preprocessExpression(_ expression: String) -> String {
        var processed = expression
        
        // Replace Unicode symbols with function calls
        processed = processed.replacingOccurrences(of: "√", with: "sqrt")
        processed = processed.replacingOccurrences(of: "∛", with: "cbrt")
        processed = processed.replacingOccurrences(of: "∜", with: "pow(,1/4)")
        processed = processed.replacingOccurrences(of: "×", with: "*")
        processed = processed.replacingOccurrences(of: "÷", with: "/")
        processed = processed.replacingOccurrences(of: "−", with: "-")
        processed = processed.replacingOccurrences(of: "∞", with: "inf")
        
        // Handle special mathematical functions
        processed = processed.replacingOccurrences(of: "∑", with: "sum")
        processed = processed.replacingOccurrences(of: "∏", with: "product")
        processed = processed.replacingOccurrences(of: "∫", with: "integral")
        
        // Handle factorial
        processed = handleFactorial(processed)
        
        // Handle absolute value
        processed = handleAbsoluteValue(processed)
        
        // Handle implicit multiplication
        processed = addImplicitMultiplication(processed)
        
        return processed
    }
    
    /// Handles factorial notation
    private func handleFactorial(_ expression: String) -> String {
        let pattern = #"(\d+(?:\.\d+)?)!"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(expression.startIndex..., in: expression)
        
        return regex.stringByReplacingMatches(
            in: expression,
            options: [],
            range: range,
            withTemplate: "factorial($1)"
        )
    }
    
    /// Handles absolute value notation
    private func handleAbsoluteValue(_ expression: String) -> String {
        var result = expression
        var openBars: [String.Index] = []
        var i = result.startIndex
        
        while i < result.endIndex {
            if result[i] == "|" {
                if let lastOpen = openBars.last {
                    // Closing bar
                    let openIndex = lastOpen
                    let closeIndex = i
                    let content = String(result[result.index(after: openIndex)..<closeIndex])
                    let replacement = "abs(\(content))"
                    
                    result.replaceSubrange(openIndex...closeIndex, with: replacement)
                    openBars.removeLast()
                    
                    // Adjust index
                    i = result.index(openIndex, offsetBy: replacement.count)
                } else {
                    // Opening bar
                    openBars.append(i)
                    i = result.index(after: i)
                }
            } else {
                i = result.index(after: i)
            }
        }
        
        return result
    }
    
    /// Adds implicit multiplication where needed
    private func addImplicitMultiplication(_ expression: String) -> String {
        var result = expression
        
        // Number followed by variable or function
        let patterns = [
            (#"(\d)([a-zA-Zπφγα-ωΑ-Ω])"#, "$1*$2"),
            (#"(\))(\()"#, "$1*$2"),
            (#"(\d)(\()"#, "$1*$2"),
            (#"(\))([a-zA-Zπφγα-ωΑ-Ω])"#, "$1*$2")
        ]
        
        for (pattern, template) in patterns {
            let regex = try! NSRegularExpression(pattern: pattern)
            let range = NSRange(result.startIndex..., in: result)
            result = regex.stringByReplacingMatches(
                in: result,
                options: [],
                range: range,
                withTemplate: template
            )
        }
        
        return result
    }
    
    /// Substitutes variables with their values
    private func substituteVariables(_ expression: String) -> (substituted: String, usedVariables: [String]) {
        var result = expression
        var usedVariables: [String] = []
        
        let variableNames = variableStore.getVariableNames().sorted { $0.count > $1.count }
        
        for variableName in variableNames {
            if result.contains(variableName),
               let value = variableStore.getValue(for: variableName) {
                
                // Use word boundaries to ensure we're replacing complete variable names
                let pattern = "\\b\(NSRegularExpression.escapedPattern(for: variableName))\\b"
                let regex = try! NSRegularExpression(pattern: pattern)
                let range = NSRange(result.startIndex..., in: result)
                
                if regex.numberOfMatches(in: result, range: range) > 0 {
                    result = regex.stringByReplacingMatches(
                        in: result,
                        options: [],
                        range: range,
                        withTemplate: String(value)
                    )
                    usedVariables.append(variableName)
                }
            }
        }
        
        return (result, usedVariables)
    }
    
    /// Validates expression syntax
    private func validateSyntax(_ expression: String) throws {
        // Check for balanced parentheses
        var parenCount = 0
        for char in expression {
            if char == "(" {
                parenCount += 1
            } else if char == ")" {
                parenCount -= 1
                if parenCount < 0 {
                    throw ParseError.syntaxError("Unmatched closing parenthesis")
                }
            }
        }
        
        if parenCount > 0 {
            throw ParseError.syntaxError("Unmatched opening parenthesis")
        }
        
        // Check for invalid operator sequences
        let invalidPatterns = [
            #"\+\+"#, #"--"#, #"\*\*"#, #"//"#, #"\+\*"#, #"\*/", #"/\*"#
        ]
        
        for pattern in invalidPatterns {
            let regex = try! NSRegularExpression(pattern: pattern)
            let range = NSRange(expression.startIndex..., in: expression)
            if regex.numberOfMatches(in: expression, range: range) > 0 {
                throw ParseError.syntaxError("Invalid operator sequence")
            }
        }
        
        // Check for undefined variables
        let variablePattern = #"\b[a-zA-Zπφγα-ωΑ-Ω][a-zA-Z0-9_]*\b"#
        let regex = try! NSRegularExpression(pattern: variablePattern)
        let range = NSRange(expression.startIndex..., in: expression)
        let matches = regex.matches(in: expression, range: range)
        
        for match in matches {
            let matchString = String(expression[Range(match.range, in: expression)!])
            if !isMathFunction(matchString) && !variableStore.hasVariable(name: matchString) {
                throw ParseError.undefinedVariable(matchString)
            }
        }
    }
    
    /// Checks if a string is a known mathematical function
    private func isMathFunction(_ string: String) -> Bool {
        let basicFunctions = [
            "sin", "cos", "tan", "asin", "acos", "atan",
            "log", "ln", "exp", "sqrt", "abs", "floor", "ceil", "round",
            "min", "max", "sum", "product", "integral"
        ]
        
        let advancedFunctions = AdvancedMathFunctions.getAllFunctionNames()
        
        return basicFunctions.contains(string) || advancedFunctions.contains(string.lowercased())
    }
    
    /// Generates LaTeX representation of an expression
    func generateLatexExpression(_ expression: String) -> String {
        var latex = expression
        
        // Convert common patterns to LaTeX
        latex = convertFunctionsToLatex(latex)
        latex = convertSymbolsToLatex(latex)
        latex = convertSuperscriptsToLatex(latex)
        latex = convertFractionsToLatex(latex)
        latex = convertRootsToLatex(latex)
        latex = convertSummationToLatex(latex)
        
        return "$\(latex)$"
    }
    
    private func convertFunctionsToLatex(_ expression: String) -> String {
        var result = expression
        
        let latexFunctions = [
            // Basic trigonometric
            ("sin", "\\sin"), ("cos", "\\cos"), ("tan", "\\tan"),
            ("asin", "\\arcsin"), ("acos", "\\arccos"), ("atan", "\\arctan"),
            
            // Extended trigonometric
            ("sec", "\\sec"), ("csc", "\\csc"), ("cot", "\\cot"),
            ("asec", "\\arcsec"), ("acsc", "\\arccsc"), ("acot", "\\arccot"),
            
            // Hyperbolic
            ("sinh", "\\sinh"), ("cosh", "\\cosh"), ("tanh", "\\tanh"),
            ("sech", "\\text{sech}"), ("csch", "\\text{csch}"), ("coth", "\\coth"),
            ("asinh", "\\text{asinh}"), ("acosh", "\\text{acosh}"), ("atanh", "\\text{atanh}"),
            ("asech", "\\text{asech}"), ("acsch", "\\text{acsch}"), ("acoth", "\\text{acoth}"),
            
            // Logarithmic
            ("log", "\\log"), ("ln", "\\ln"), ("log10", "\\log_{10}"), ("log2", "\\log_2"),
            
            // Exponential
            ("exp", "\\exp"), ("exp2", "\\exp_2"), ("exp10", "\\exp_{10}"),
            
            // Root functions
            ("sqrt", "\\sqrt"), ("cbrt", "\\sqrt[3]"),
            
            // Special functions
            ("gamma", "\\Gamma"), ("factorial", ""), ("beta", "\\text{B}"),
            ("erf", "\\text{erf}"), ("erfc", "\\text{erfc}"),
            
            // Number theory
            ("gcd", "\\gcd"), ("lcm", "\\text{lcm}"),
            
            // Utility
            ("abs", "\\left|"), ("floor", "\\lfloor"), ("ceil", "\\lceil"),
            ("min", "\\min"), ("max", "\\max")
        ]
        
        for (function, latexFunction) in latexFunctions {
            if !latexFunction.isEmpty {
                result = result.replacingOccurrences(of: "\(function)(", with: "\(latexFunction)(")
            }
        }
        
        // Special handling for factorial
        let factorialPattern = #"factorial\(([^)]+)\)"#
        let factorialRegex = try! NSRegularExpression(pattern: factorialPattern)
        let factorialRange = NSRange(result.startIndex..., in: result)
        result = factorialRegex.stringByReplacingMatches(
            in: result,
            options: [],
            range: factorialRange,
            withTemplate: "$1!"
        )
        
        // Special handling for absolute value
        let absPattern = #"\\left\|\(([^)]+)\)"#
        let absRegex = try! NSRegularExpression(pattern: absPattern)
        let absRange = NSRange(result.startIndex..., in: result)
        result = absRegex.stringByReplacingMatches(
            in: result,
            options: [],
            range: absRange,
            withTemplate: "\\left|$1\\right|"
        )
        
        return result
    }
    
    private func convertSymbolsToLatex(_ expression: String) -> String {
        return expression
            .replacingOccurrences(of: "pi", with: "\\pi")
            .replacingOccurrences(of: "π", with: "\\pi")
            .replacingOccurrences(of: "φ", with: "\\phi")
            .replacingOccurrences(of: "γ", with: "\\gamma")
            .replacingOccurrences(of: "*", with: "\\cdot ")
            .replacingOccurrences(of: "inf", with: "\\infty")
            .replacingOccurrences(of: "∞", with: "\\infty")
    }
    
    private func convertSuperscriptsToLatex(_ expression: String) -> String {
        let pattern = #"\^(\d+|\([^)]+\))"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(expression.startIndex..., in: expression)
        
        return regex.stringByReplacingMatches(
            in: expression,
            options: [],
            range: range,
            withTemplate: "^{$1}"
        )
    }
    
    private func convertFractionsToLatex(_ expression: String) -> String {
        // This would implement fraction detection and conversion
        // For now, simple division
        return expression.replacingOccurrences(of: "/", with: "\\div ")
    }
    
    private func convertRootsToLatex(_ expression: String) -> String {
        var result = expression
        
        // Square root
        let sqrtPattern = #"sqrt\(([^)]+)\)"#
        let sqrtRegex = try! NSRegularExpression(pattern: sqrtPattern)
        let sqrtRange = NSRange(result.startIndex..., in: result)
        result = sqrtRegex.stringByReplacingMatches(
            in: result,
            options: [],
            range: sqrtRange,
            withTemplate: "\\sqrt{$1}"
        )
        
        // Cube root
        let cbrtPattern = #"cbrt\(([^)]+)\)"#
        let cbrtRegex = try! NSRegularExpression(pattern: cbrtPattern)
        let cbrtRange = NSRange(result.startIndex..., in: result)
        result = cbrtRegex.stringByReplacingMatches(
            in: result,
            options: [],
            range: cbrtRange,
            withTemplate: "\\sqrt[3]{$1}"
        )
        
        return result
    }
    
    private func convertSummationToLatex(_ expression: String) -> String {
        // Handle summation notation
        let sumPattern = #"sum\(([^,]+),([^,]+),([^)]+)\)"#
        let regex = try! NSRegularExpression(pattern: sumPattern)
        let range = NSRange(expression.startIndex..., in: expression)
        
        return regex.stringByReplacingMatches(
            in: expression,
            options: [],
            range: range,
            withTemplate: "\\sum_{$2}^{$3} $1"
        )
    }
    
    /// Simplifies an expression for display
    private func simplifyExpression(_ expression: String) -> String {
        // Basic simplification rules
        var simplified = expression
        
        // Remove unnecessary parentheses around single numbers
        let singleNumPattern = #"\((\d+(?:\.\d+)?)\)"#
        let regex = try! NSRegularExpression(pattern: singleNumPattern)
        let range = NSRange(simplified.startIndex..., in: simplified)
        simplified = regex.stringByReplacingMatches(
            in: simplified,
            options: [],
            range: range,
            withTemplate: "$1"
        )
        
        return simplified
    }
}
//
//  VariableStore.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import SwiftData

/// A variable stored in the calculator's memory
@Model
class CalculatorVariable {
    @Attribute(.unique) var name: String
    var value: Double
    var expression: String
    var latexExpression: String
    var timestamp: Date
    
    init(name: String, value: Double, expression: String = "", latexExpression: String = "") {
        self.name = name
        self.value = value
        self.expression = expression
        self.latexExpression = latexExpression
        self.timestamp = Date()
    }
}

/// Manages calculator variables and their operations
@Observable
class VariableStore {
    private(set) var variables: [String: CalculatorVariable] = [:]
    private(set) var constants: [String: Double] = [
        "π": .pi,
        "pi": .pi,
        "e": 2.71828182845904523536,
        "φ": 1.61803398874989484820, // Golden ratio
        "γ": 0.57721566490153286061, // Euler-Mascheroni constant
        "c": 299792458, // Speed of light in m/s
        "h": 6.62607015e-34, // Planck constant
        "k": 1.380649e-23, // Boltzmann constant
        "G": 6.67430e-11, // Gravitational constant
        "ε₀": 8.8541878128e-12, // Vacuum permittivity
        "μ₀": 1.25663706212e-6, // Vacuum permeability
        "α": 7.2973525693e-3, // Fine structure constant
        "R": 8.314462618 // Universal gas constant
    ]
    
    init() {
        // Initialize with common mathematical constants
        loadConstants()
    }
    
    private func loadConstants() {
        for (name, value) in constants {
            variables[name] = CalculatorVariable(
                name: name,
                value: value,
                expression: name,
                latexExpression: "\\text{\(name)}"
            )
        }
    }
    
    /// Sets a variable's value
    func setVariable(name: String, value: Double, expression: String = "", latexExpression: String = "") {
        if let existingVar = variables[name] {
            existingVar.value = value
            existingVar.expression = expression.isEmpty ? String(value) : expression
            existingVar.latexExpression = latexExpression.isEmpty ? String(value) : latexExpression
            existingVar.timestamp = Date()
        } else {
            variables[name] = CalculatorVariable(
                name: name,
                value: value,
                expression: expression.isEmpty ? String(value) : expression,
                latexExpression: latexExpression.isEmpty ? String(value) : latexExpression
            )
        }
    }
    
    /// Gets a variable's value
    func getValue(for name: String) -> Double? {
        return variables[name]?.value
    }
    
    /// Gets a variable object
    func getVariable(name: String) -> CalculatorVariable? {
        return variables[name]
    }
    
    /// Removes a variable
    func removeVariable(name: String) {
        // Don't allow removal of constants
        guard !constants.keys.contains(name) else { return }
        variables.removeValue(forKey: name)
    }
    
    /// Clears all user-defined variables (keeps constants)
    func clearUserVariables() {
        let userVars = variables.filter { !constants.keys.contains($0.key) }
        for (name, _) in userVars {
            variables.removeValue(forKey: name)
        }
    }
    
    /// Gets all user-defined variables (excluding constants)
    func getUserVariables() -> [CalculatorVariable] {
        return variables.values.filter { !constants.keys.contains($0.name) }
            .sorted { $0.name < $1.name }
    }
    
    /// Gets all variables including constants
    func getAllVariables() -> [CalculatorVariable] {
        return variables.values.sorted { $0.name < $1.name }
    }
    
    /// Checks if a variable exists
    func hasVariable(name: String) -> Bool {
        return variables[name] != nil
    }
    
    /// Gets variable names for autocomplete
    func getVariableNames() -> [String] {
        return Array(variables.keys).sorted()
    }
    
    /// Evaluates an expression with variable substitution
    func evaluateExpression(_ expression: String) -> (result: Double?, variables: [String]) {
        var processedExpression = expression
        var usedVariables: [String] = []
        
        // Replace variables with their values
        for (name, variable) in variables {
            if processedExpression.contains(name) {
                processedExpression = processedExpression.replacingOccurrences(of: name, with: String(variable.value))
                usedVariables.append(name)
            }
        }
        
        // Try to evaluate the expression
        // This would use MathParser or similar
        return (nil, usedVariables) // Placeholder for now
    }
    
    /// Creates a LaTeX representation of all variables
    func generateVariablesLatex() -> String {
        let userVars = getUserVariables()
        guard !userVars.isEmpty else { return "" }
        
        var latex = "\\begin{align}\n"
        for variable in userVars {
            if !variable.latexExpression.isEmpty && variable.latexExpression != variable.name {
                latex += "\(variable.name) &= \(variable.latexExpression) = \(variable.value) \\\\\n"
            } else {
                latex += "\(variable.name) &= \(variable.value) \\\\\n"
            }
        }
        latex += "\\end{align}"
        
        return latex
    }
}
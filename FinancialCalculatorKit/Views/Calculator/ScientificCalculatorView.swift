//
//  ScientificCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/10/25.
//

import SwiftUI
import Charts
import LaTeXSwiftUI
import MathParser

struct ScientificCalculatorView: View {
    @State private var expression: String = ""
    @State private var result: String = "0"
    @State private var history: [CalculationHistory] = []
    @State private var showingHistory: Bool = false
    @State private var memoryValue: Double = 0.0
    @State private var angleMode: AngleMode = .degrees
    @State private var displayMode: DisplayMode = .decimal
    @State private var precision: Int = 10
    @State private var lastLatexExpression: String = ""
    
    enum AngleMode: String, CaseIterable, Identifiable {
        case degrees = "deg"
        case radians = "rad"
        case gradians = "grad"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .degrees: return "DEG"
            case .radians: return "RAD"
            case .gradians: return "GRAD"
            }
        }
    }
    
    enum DisplayMode: String, CaseIterable, Identifiable {
        case decimal = "decimal"
        case scientific = "scientific"
        case engineering = "engineering"
        case fraction = "fraction"
        
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .decimal: return "DEC"
            case .scientific: return "SCI"
            case .engineering: return "ENG"
            case .fraction: return "FRAC"
            }
        }
    }
    
    struct CalculationHistory: Identifiable {
        let id = UUID()
        let expression: String
        let result: String
        let latexExpression: String
        let timestamp: Date
    }
    
    let scientificButtons: [[CalculatorButton]] = [
        // Row 1
        [.function("2nd"), .function("π"), .function("e"), .clear, .backspace],
        // Row 2
        [.function("x²"), .function("1/x"), .function("|x|"), .function("exp"), .function("mod")],
        // Row 3
        [.function("√"), .function("∛"), .function("x^y"), .function("log"), .function("ln")],
        // Row 4
        [.function("sin"), .function("cos"), .function("tan"), .openParen, .closeParen],
        // Row 5
        [.function("sin⁻¹"), .function("cos⁻¹"), .function("tan⁻¹"), .memoryAdd, .memoryRecall],
        // Row 6
        [.number("7"), .number("8"), .number("9"), .divide, .memoryClear],
        // Row 7
        [.number("4"), .number("5"), .number("6"), .multiply, .memoryStore],
        // Row 8
        [.number("1"), .number("2"), .number("3"), .subtract, .function("Ans")],
        // Row 9
        [.number("0"), .decimal, .function("±"), .add, .equals]
    ]
    
    enum CalculatorButton: Identifiable {
        case number(String)
        case operation(String)
        case function(String)
        case equals
        case clear
        case backspace
        case decimal
        case openParen
        case closeParen
        case add, subtract, multiply, divide
        case memoryStore, memoryRecall, memoryAdd, memoryClear
        
        var id: String {
            switch self {
            case .number(let value): return "num_\(value)"
            case .operation(let value): return "op_\(value)"
            case .function(let value): return "func_\(value)"
            case .equals: return "equals"
            case .clear: return "clear"
            case .backspace: return "back"
            case .decimal: return "decimal"
            case .openParen: return "open"
            case .closeParen: return "close"
            case .add: return "add"
            case .subtract: return "sub"
            case .multiply: return "mul"
            case .divide: return "div"
            case .memoryStore: return "ms"
            case .memoryRecall: return "mr"
            case .memoryAdd: return "mplus"
            case .memoryClear: return "mc"
            }
        }
        
        var display: String {
            switch self {
            case .number(let value): return value
            case .operation(let value): return value
            case .function(let value): return value
            case .equals: return "="
            case .clear: return "AC"
            case .backspace: return "⌫"
            case .decimal: return "."
            case .openParen: return "("
            case .closeParen: return ")"
            case .add: return "+"
            case .subtract: return "−"
            case .multiply: return "×"
            case .divide: return "÷"
            case .memoryStore: return "MS"
            case .memoryRecall: return "MR"
            case .memoryAdd: return "M+"
            case .memoryClear: return "MC"
            }
        }
        
        var color: Color {
            switch self {
            case .number: return .primary
            case .operation, .add, .subtract, .multiply, .divide: return .blue
            case .function: return .purple
            case .equals: return .green
            case .clear, .backspace: return .red
            case .decimal, .openParen, .closeParen: return .primary
            case .memoryStore, .memoryRecall, .memoryAdd, .memoryClear: return .orange
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 24) {
            calculatorSection
            
            VStack(spacing: 24) {
                displaySection
                latexSection
                if showingHistory {
                    historySection
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .background(Color(NSColor.windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("History") {
                    showingHistory.toggle()
                }
                .help("Show calculation history")
                .financialHover(style: .button)
                
                Button("Copy Result") {
                    copyToClipboard(result)
                }
                .help("Copy result to clipboard")
                .financialHover(style: .button)
                
                Button("Paste") {
                    pasteFromClipboard()
                }
                .help("Paste from clipboard")
                .financialHover(style: .button)
            }
        }
    }
    
    @ViewBuilder
    private var calculatorSection: some View {
        VStack(spacing: 16) {
            // Mode selectors
            HStack {
                Picker("Angle", selection: $angleMode) {
                    ForEach(AngleMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                
                Picker("Display", selection: $displayMode) {
                    ForEach(DisplayMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Expression input
            TextField("Enter expression", text: $expression)
                .textFieldStyle(.roundedBorder)
                .font(.financialNumberLarge)
                .onSubmit {
                    calculateResult()
                }
            
            // Result display
            HStack {
                Text("=")
                    .font(.financialHeadline)
                    .foregroundColor(.secondary)
                
                Text(result)
                    .font(.financialNumberLarge)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
            }
            
            // Memory display
            if memoryValue != 0 {
                HStack {
                    Text("M:")
                        .font(.financialCaption)
                        .foregroundColor(.orange)
                    
                    Text(formatNumber(memoryValue))
                        .font(.financialNumberSmall)
                        .foregroundColor(.orange)
                    
                    Spacer()
                }
            }
            
            // Calculator buttons
            VStack(spacing: 8) {
                ForEach(scientificButtons, id: \.first?.id) { row in
                    HStack(spacing: 8) {
                        ForEach(row) { button in
                            Button(action: {
                                handleButtonPress(button)
                            }) {
                                Text(button.display)
                                    .font(.financialBody)
                                    .fontWeight(.medium)
                                    .foregroundColor(button.color)
                                    .frame(width: 50, height: 40)
                                    .background(Color(NSColor.controlBackgroundColor))
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .frame(width: 320)
    }
    
    @ViewBuilder
    private var displaySection: some View {
        GroupBox("Enhanced Display") {
            VStack(spacing: 16) {
                // Current expression in LaTeX
                if !lastLatexExpression.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expression:")
                            .font(.financialSubheadline)
                            .fontWeight(.medium)
                        
                        LaTeX(lastLatexExpression)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                    }
                }
                
                // Result in different formats
                VStack(alignment: .leading, spacing: 12) {
                    Text("Result Formats:")
                        .font(.financialSubheadline)
                        .fontWeight(.medium)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Decimal:")
                                .font(.financialCaption)
                                .foregroundColor(.secondary)
                            Text(formatResultAs(.decimal))
                                .font(.financialNumber)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Scientific:")
                                .font(.financialCaption)
                                .foregroundColor(.secondary)
                            Text(formatResultAs(.scientific))
                                .font(.financialNumber)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Engineering:")
                                .font(.financialCaption)
                                .foregroundColor(.secondary)
                            Text(formatResultAs(.engineering))
                                .font(.financialNumber)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Fraction:")
                                .font(.financialCaption)
                                .foregroundColor(.secondary)
                            Text(formatResultAs(.fraction))
                                .font(.financialNumber)
                        }
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var latexSection: some View {
        GroupBox("LaTeX Expression Builder") {
            VStack(spacing: 16) {
                Text("Common Mathematical Functions")
                    .font(.financialSubheadline)
                    .fontWeight(.medium)
                
                let functionButtons = [
                    ("Square Root", "√x", "sqrt("),
                    ("Cube Root", "∛x", "cbrt("),
                    ("Power", "x^y", "^"),
                    ("Logarithm", "log(x)", "log("),
                    ("Natural Log", "ln(x)", "ln("),
                    ("Exponential", "e^x", "exp("),
                    ("Factorial", "n!", "!"),
                    ("Absolute", "|x|", "abs(")
                ]
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                    ForEach(functionButtons, id: \.0) { function in
                        Button(action: {
                            appendToExpression(function.2)
                        }) {
                            VStack {
                                Text(function.1)
                                    .font(.financialCaption)
                                Text(function.0)
                                    .font(.caption2)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                HStack {
                    Button("Clear Expression") {
                        expression = ""
                        lastLatexExpression = ""
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Generate LaTeX") {
                        generateLatexExpression()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var historySection: some View {
        GroupBox("Calculation History") {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(history.reversed()) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.timestamp, style: .time)
                                    .font(.financialCaption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button("Use") {
                                    expression = item.expression
                                    result = item.result
                                    lastLatexExpression = item.latexExpression
                                }
                                .buttonStyle(.borderless)
                                .font(.financialCaption)
                            }
                            
                            if !item.latexExpression.isEmpty {
                                LaTeX(item.latexExpression)
                                    .frame(height: 30)
                            } else {
                                Text(item.expression)
                                    .font(.financialNumber)
                            }
                            
                            Text("= \(item.result)")
                                .font(.financialNumber)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding(12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }
                }
                .padding(.vertical, 8)
            }
            .frame(maxHeight: 300)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    private func handleButtonPress(_ button: CalculatorButton) {
        switch button {
        case .number(let num):
            appendToExpression(num)
        case .operation(let op):
            appendToExpression(op)
        case .function(let function):
            handleFunction(function)
        case .add:
            appendToExpression("+")
        case .subtract:
            appendToExpression("-")
        case .multiply:
            appendToExpression("*")
        case .divide:
            appendToExpression("/")
        case .decimal:
            appendToExpression(".")
        case .openParen:
            appendToExpression("(")
        case .closeParen:
            appendToExpression(")")
        case .equals:
            calculateResult()
        case .clear:
            clearAll()
        case .backspace:
            backspace()
        case .memoryStore:
            memoryStore()
        case .memoryRecall:
            memoryRecall()
        case .memoryAdd:
            memoryAdd()
        case .memoryClear:
            memoryClear()
        }
    }
    
    private func handleFunction(_ function: String) {
        switch function {
        case "sin":
            appendToExpression("sin(")
        case "cos":
            appendToExpression("cos(")
        case "tan":
            appendToExpression("tan(")
        case "sin⁻¹":
            appendToExpression("asin(")
        case "cos⁻¹":
            appendToExpression("acos(")
        case "tan⁻¹":
            appendToExpression("atan(")
        case "log":
            appendToExpression("log(")
        case "ln":
            appendToExpression("ln(")
        case "exp":
            appendToExpression("exp(")
        case "√":
            appendToExpression("sqrt(")
        case "∛":
            appendToExpression("cbrt(")
        case "x²":
            appendToExpression("^2")
        case "x^y":
            appendToExpression("^")
        case "1/x":
            appendToExpression("1/(")
        case "|x|":
            appendToExpression("abs(")
        case "π":
            appendToExpression("pi")
        case "e":
            appendToExpression("e")
        case "±":
            toggleSign()
        case "mod":
            appendToExpression("%")
        case "Ans":
            appendToExpression(result)
        case "2nd":
            // Toggle second functions (implementation would require state tracking)
            break
        default:
            break
        }
    }
    
    private func appendToExpression(_ text: String) {
        expression += text
        generateLatexExpression()
    }
    
    private func calculateResult() {
        guard !expression.isEmpty else {
            result = "0"
            return
        }
        
        // Prepare expression for evaluation
        var processedExpression = expression
        
        // Replace common symbols with their mathematical equivalents
        processedExpression = processedExpression
            .replacingOccurrences(of: "π", with: "3.14159265359")
            .replacingOccurrences(of: "pi", with: "3.14159265359")
            .replacingOccurrences(of: "e", with: "2.71828182846")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
        
        // Use MathParser to evaluate
        let parser = MathParser()
        
        // Add angle conversion for trig functions if needed
        if angleMode == .degrees {
            // Convert degrees to radians for trig functions
            processedExpression = processedExpression
                .replacingOccurrences(of: "sin(", with: "sin(3.14159265359/180*")
                .replacingOccurrences(of: "cos(", with: "cos(3.14159265359/180*")
                .replacingOccurrences(of: "tan(", with: "tan(3.14159265359/180*")
        }
        
        if let evaluator = parser.parse(processedExpression) {
            let value = evaluator.eval()
            
            // Check for invalid results
            if value.isNaN || value.isInfinite {
                result = "Error"
                return
            }
            
            // Handle inverse trig functions result conversion
            if angleMode == .degrees && 
               (expression.contains("asin") || expression.contains("acos") || expression.contains("atan")) {
                result = formatNumber(value * 180.0 / Double.pi)
            } else {
                result = formatNumber(value)
            }
            
            // Add to history
            let historyItem = CalculationHistory(
                expression: expression,
                result: result,
                latexExpression: lastLatexExpression,
                timestamp: Date()
            )
            history.append(historyItem)
            
            // Keep only last 20 calculations
            if history.count > 20 {
                history.removeFirst()
            }
        } else {
            result = "Error"
        }
    }
    
    
    private func generateLatexExpression() {
        var latex = expression
        
        // Convert common mathematical symbols to LaTeX
        latex = latex.replacingOccurrences(of: "sqrt(", with: "\\sqrt{")
        latex = latex.replacingOccurrences(of: "cbrt(", with: "\\sqrt[3]{")
        latex = latex.replacingOccurrences(of: "^", with: "^{")
        latex = latex.replacingOccurrences(of: "*", with: "\\cdot ")
        latex = latex.replacingOccurrences(of: "/", with: "\\frac{}{}")
        latex = latex.replacingOccurrences(of: "pi", with: "\\pi")
        latex = latex.replacingOccurrences(of: "log(", with: "\\log(")
        latex = latex.replacingOccurrences(of: "ln(", with: "\\ln(")
        latex = latex.replacingOccurrences(of: "sin(", with: "\\sin(")
        latex = latex.replacingOccurrences(of: "cos(", with: "\\cos(")
        latex = latex.replacingOccurrences(of: "tan(", with: "\\tan(")
        latex = latex.replacingOccurrences(of: "abs(", with: "|")
        
        lastLatexExpression = "$\(latex)$"
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }
        
        switch displayMode {
        case .decimal:
            return String(format: "%.\(precision)g", value)
        case .scientific:
            return String(format: "%.\(precision)e", value)
        case .engineering:
            if abs(value) < 1e-100 {
                return "0.000×10^0"
            }
            let logValue = log10(abs(value))
            if logValue.isNaN || logValue.isInfinite {
                return String(format: "%.\(precision)g", value)
            }
            let exponent = Int(floor(logValue / 3.0) * 3)
            let mantissa = value / pow(10.0, Double(exponent))
            if mantissa.isNaN || mantissa.isInfinite {
                return String(format: "%.\(precision)g", value)
            }
            return String(format: "%.3f×10^%d", mantissa, exponent)
        case .fraction:
            return decimalToFraction(value)
        }
    }
    
    private func formatResultAs(_ mode: DisplayMode) -> String {
        guard let value = Double(result), !value.isNaN, !value.isInfinite else {
            return result
        }
        
        switch mode {
        case .decimal:
            return String(format: "%.\(precision)g", value)
        case .scientific:
            return String(format: "%.\(precision)e", value)
        case .engineering:
            if abs(value) < 1e-100 {
                return "0.000×10^0"
            }
            let logValue = log10(abs(value))
            if logValue.isNaN || logValue.isInfinite {
                return String(format: "%.\(precision)g", value)
            }
            let exponent = Int(floor(logValue / 3.0) * 3)
            let mantissa = value / pow(10.0, Double(exponent))
            if mantissa.isNaN || mantissa.isInfinite {
                return String(format: "%.\(precision)g", value)
            }
            return String(format: "%.3f×10^%d", mantissa, exponent)
        case .fraction:
            return decimalToFraction(value)
        }
    }
    
    private func decimalToFraction(_ decimal: Double) -> String {
        // Check for invalid values first
        if decimal.isNaN || decimal.isInfinite {
            return "Error"
        }
        
        // Handle zero case
        if abs(decimal) < 1e-10 {
            return "0"
        }
        
        let tolerance = 1e-6
        var h1 = 1, h2 = 0, k1 = 0, k2 = 1
        var b = decimal
        var iterations = 0
        let maxIterations = 100 // Prevent infinite loops
        
        repeat {
            // Check for invalid intermediate values
            if b.isNaN || b.isInfinite || abs(b) < tolerance {
                break
            }
            
            let a = Int(b)
            
            // Prevent overflow by checking bounds
            guard a.magnitude < Int.max / 1000 else {
                break
            }
            
            let aux = h1
            h1 = a * h1 + h2
            h2 = aux
            let aux2 = k1
            k1 = a * k1 + k2
            k2 = aux2
            
            // Check for overflow in results
            if abs(h1) > Int.max / 2 || abs(k1) > Int.max / 2 {
                break
            }
            
            let remainder = b - Double(a)
            if abs(remainder) < tolerance {
                break
            }
            
            b = 1.0 / remainder
            iterations += 1
            
        } while abs(decimal - Double(h1) / Double(k1)) > abs(decimal) * tolerance && iterations < maxIterations
        
        // Final safety check
        if k1 == 0 || abs(h1) > Int.max / 2 || abs(k1) > Int.max / 2 {
            return String(format: "%.6f", decimal)
        }
        
        if k1 == 1 {
            return "\(h1)"
        } else {
            return "\(h1)/\(k1)"
        }
    }
    
    private func clearAll() {
        expression = ""
        result = "0"
        lastLatexExpression = ""
    }
    
    private func backspace() {
        if !expression.isEmpty {
            expression.removeLast()
            generateLatexExpression()
        }
    }
    
    private func toggleSign() {
        if let value = Double(result) {
            result = formatNumber(-value)
        }
    }
    
    private func memoryStore() {
        if let value = Double(result) {
            memoryValue = value
        }
    }
    
    private func memoryRecall() {
        appendToExpression(formatNumber(memoryValue))
    }
    
    private func memoryAdd() {
        if let value = Double(result) {
            memoryValue += value
        }
    }
    
    private func memoryClear() {
        memoryValue = 0.0
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private func pasteFromClipboard() {
        let pasteboard = NSPasteboard.general
        if let string = pasteboard.string(forType: .string) {
            expression = string
            generateLatexExpression()
        }
    }
}

#Preview {
    ScientificCalculatorView()
        .frame(width: 1200, height: 800)
}
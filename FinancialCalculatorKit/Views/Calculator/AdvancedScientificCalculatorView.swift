//
//  AdvancedScientificCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import SwiftUI
import LaTeXSwiftUI
import SwiftData

struct AdvancedScientificCalculatorView: View {
    @State private var currentDocument = EquationDocument()
    @State private var variableStore = VariableStore()
    @State private var autoComplete = FormulaAutoComplete()
    
    @State private var currentExpression: String = ""
    @State private var currentResult: String = ""
    @State private var showingSyntaxError: Bool = false
    @State private var syntaxErrorMessage: String = ""
    
    @State private var showingVariableSheet: Bool = false
    @State private var showingDocumentList: Bool = false
    @State private var showingFormulaLibrary: Bool = false
    @State private var showingAutoFill: Bool = false
    
    @State private var selectedTemplate: MathTemplate? = nil
    @State private var showingCustomKeyboard: Bool = false
    @State private var templateValues: [String: Double] = [:]
    
    private var expressionParser: AdvancedExpressionParser {
        AdvancedExpressionParser(variableStore: variableStore)
    }
    
    var body: some View {
        NavigationSplitView {
            sidebarContent
        } detail: {
            mainCalculatorContent
        }
        .navigationTitle("Advanced Scientific Calculator")
        .toolbar {
            toolbarContent
        }
        .sheet(isPresented: $showingVariableSheet) {
            VariableManagementView(variableStore: variableStore)
        }
        .sheet(isPresented: $showingDocumentList) {
            DocumentListView(currentDocument: $currentDocument)
        }
        .sheet(isPresented: $showingFormulaLibrary) {
            FormulaLibraryView(autoComplete: autoComplete, onFormulaSelected: insertFormula)
        }
        .sheet(isPresented: $showingAutoFill) {
            AutoFillFormulasView(onFormulaSelected: insertAutoFillFormula)
        }
        .sheet(isPresented: $showingCustomKeyboard) {
            AdvancedCustomKeyboardView { insertion in
                insertText(insertion)
            }
        }
    }
    
    @ViewBuilder
    private var sidebarContent: some View {
        VStack(spacing: 16) {
            // Previous calculation results
            previousResultsSection
            
            // Variable list
            variableListSection
            
            // Quick templates
            quickTemplatesSection
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 320)
    }
    
    @ViewBuilder
    private var previousResultsSection: some View {
        GroupBox("Previous calculation results from the standard equation mode will show up here") {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(currentDocument.getSortedLines().prefix(5), id: \.id) { line in
                        previousResultRow(line)
                    }
                    
                    if currentDocument.lines.isEmpty {
                        Text("No previous calculations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 20)
                    }
                }
            }
            .frame(maxHeight: 200)
            .padding(8)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private func previousResultRow(_ line: EquationLine) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(line.expression)
                .font(.system(.caption, design: .monospaced))
                .lineLimit(1)
            
            if !line.result.isEmpty {
                Text("= \(line.result)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 2)
    }
    
    @ViewBuilder
    private var variableListSection: some View {
        GroupBox("Variables") {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(variableStore.getUserVariables(), id: \.name) { variable in
                        variableRow(variable)
                    }
                    
                    if variableStore.getUserVariables().isEmpty {
                        Text("No variables defined")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 20)
                    }
                }
            }
            .frame(maxHeight: 150)
            .padding(8)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private func variableRow(_ variable: CalculatorVariable) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(variable.name)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.medium)
                
                Text("= \(formatNumber(variable.value))")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Use") {
                insertText(variable.name)
            }
            .buttonStyle(.borderless)
            .font(.caption)
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var quickTemplatesSection: some View {
        GroupBox("Quick Templates") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(MathTemplate.allCases, id: \.self) { template in
                    Button(action: {
                        selectedTemplate = template
                    }) {
                        VStack(spacing: 4) {
                            Text(template.symbol)
                                .font(.title2)
                            Text(template.displayName)
                                .font(.caption2)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(selectedTemplate == template ? Color.accentColor.opacity(0.2) : Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var mainCalculatorContent: some View {
        VStack(spacing: 0) {
            // Top toolbar with Auto Fill
            topToolbarSection
            
            // Main expression display
            mainExpressionDisplay
            
            // Template workspace
            if let template = selectedTemplate {
                templateWorkspaceSection(template)
            }
            
            // Result display
            resultDisplaySection
            
            // Bottom controls
            bottomControlsSection
            
            // Scientific keyboard
            scientificKeyboardSection
        }
        .padding(.horizontal, 24)
        .overlay(alignment: .bottom) {
            if showingSyntaxError {
                syntaxErrorBanner
            }
        }
    }
    
    @ViewBuilder
    private var topToolbarSection: some View {
        HStack {
            Text("Advanced Scientific Calculator")
                .font(.headline)
            
            Spacer()
            
            // Auto Fill button with dropdown
            Menu {
                ForEach(AutoFillFormula.allCases, id: \.self) { formula in
                    Button(formula.displayName) {
                        insertAutoFillFormula(formula)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text("Auto Fill")
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
            }
            .menuStyle(.borderlessButton)
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private var mainExpressionDisplay: some View {
        VStack(spacing: 16) {
            // Large math expression area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .frame(minHeight: 120)
                
                if let template = selectedTemplate {
                    // Show visual template
                    template.visualRepresentation(with: getCurrentTemplateValues())
                        .padding(20)
                } else {
                    // Show current result or placeholder
                    VStack(spacing: 8) {
                        if !currentResult.isEmpty {
                            Text(currentResult)
                                .font(.system(size: 32, weight: .bold, design: .monospaced))
                                .foregroundColor(.primary)
                        } else {
                            Text("Select a template or enter an expression")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private func templateWorkspaceSection(_ template: MathTemplate) -> some View {
        GroupBox("Template Inputs") {
            template.inputFields { parameter, value in
                updateTemplateParameter(parameter, value: value)
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var resultDisplaySection: some View {
        if !currentResult.isEmpty {
            HStack {
                Text("=")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(currentResult)
                    .font(.system(.title, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
            .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    private var bottomControlsSection: some View {
        HStack(spacing: 12) {
            // Clear button
            Button("C") {
                clearAll()
            }
            .buttonStyle(.bordered)
            .font(.title2)
            .frame(width: 50, height: 50)
            
            // Menu button (hamburger)
            Button(action: {}) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .frame(width: 50, height: 50)
            
            // Navigation arrows
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .frame(width: 50, height: 50)
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .frame(width: 50, height: 50)
            
            // Delete button
            Button(action: {}) {
                Image(systemName: "delete.left")
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .frame(width: 50, height: 50)
            
            Spacer()
            
            // Evaluate button
            Button("Calculate") {
                evaluateCurrentTemplate()
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedTemplate == nil)
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var scientificKeyboardSection: some View {
        VStack(spacing: 0) {
            // First row: Advanced functions
            HStack(spacing: 8) {
                ForEach(["⌊⌋", "Σ", "x", "x!", "i"], id: \.self) { symbol in
                    scientificKeyButton(symbol)
                }
            }
            .padding(.bottom, 8)
            
            // Second row: Trigonometric functions
            HStack(spacing: 8) {
                ForEach(["|abs|", "log", "sin", "cos", "tan"], id: \.self) { symbol in
                    scientificKeyButton(symbol)
                }
            }
            .padding(.bottom, 8)
            
            // Third row: Powers and roots
            HStack(spacing: 8) {
                ForEach(["⌊⌋", "x□", "√x", "π", "e"], id: \.self) { symbol in
                    scientificKeyButton(symbol)
                }
            }
            .padding(.bottom, 8)
            
            // Number pad
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(["7", "8", "9", "(", ")"], id: \.self) { symbol in
                        keyboardButton(symbol)
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(["4", "5", "6", "×", "÷"], id: \.self) { symbol in
                        keyboardButton(symbol)
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(["1", "2", "3", "+", "-"], id: \.self) { symbol in
                        keyboardButton(symbol)
                    }
                }
                
                HStack(spacing: 8) {
                    keyboardButton("0")
                    keyboardButton(".")
                    keyboardButton("×10□")
                    keyboardButton("ANS")
                    keyboardButton("=")
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
            }
            
            // Expandable sections
            expandableKeyboardSections
        }
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private var expandableKeyboardSections: some View {
        VStack(spacing: 8) {
            DisclosureGroup("EQUATION MODE") {
                EmptyView() // Placeholder for equation mode
            }
            .foregroundColor(.blue)
            
            DisclosureGroup("DISPLAY") {
                EmptyView() // Placeholder for display options
            }
            .foregroundColor(.blue)
            
            DisclosureGroup("KEYBOARD") {
                AdvancedKeyboardGrid { insertion in
                    insertText(insertion)
                }
            }
            .foregroundColor(.blue)
            
            DisclosureGroup("SETTINGS, HELP & SUPPORT") {
                EmptyView() // Placeholder for settings
            }
            .foregroundColor(.blue)
        }
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private func scientificKeyButton(_ symbol: String) -> some View {
        Button(action: {
            handleScientificKey(symbol)
        }) {
            Text(symbol)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func keyboardButton(_ symbol: String) -> some View {
        Button(action: {
            handleKeyboardInput(symbol)
        }) {
            Text(symbol)
                .font(.system(.title2, design: .monospaced))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var syntaxErrorBanner: some View {
        HStack {
            Text("SYNTAX ERROR")
                .font(.caption.weight(.bold))
                .foregroundColor(.red)
            
            Spacer()
            
            Button("Dismiss") {
                showingSyntaxError = false
            }
            .buttonStyle(.borderless)
            .font(.caption)
        }
        .padding(12)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("x =") {
                // Handle x = button
            }
            .help("Solve for x")
            
            Button("y =") {
                // Handle y = button
            }
            .help("Solve for y")
            
            Button("f(x)") {
                showingFormulaLibrary = true
            }
            .help("Function library")
            
            Button(action: {
                showingVariableSheet = true
            }) {
                Image(systemName: "folder")
            }
            .help("Documents")
        }
    }
    
    // MARK: - Actions
    
    private func clearAll() {
        currentExpression = ""
        currentResult = ""
        selectedTemplate = nil
        templateValues = [:]
        showingSyntaxError = false
    }
    
    private func handleScientificKey(_ symbol: String) {
        switch symbol {
        case "Σ":
            selectedTemplate = .summation
        case "x!":
            insertText("!")
        case "x":
            insertText("x")
        case "i":
            insertText("i")
        case "|abs|":
            insertText("abs(")
        case "log":
            insertText("log(")
        case "sin":
            insertText("sin(")
        case "cos":
            insertText("cos(")
        case "tan":
            insertText("tan(")
        case "x□":
            insertText("^")
        case "√x":
            insertText("sqrt(")
        case "π":
            insertText("π")
        case "e":
            insertText("e")
        default:
            insertText(symbol)
        }
    }
    
    private func handleKeyboardInput(_ symbol: String) {
        switch symbol {
        case "=":
            evaluateCurrentTemplate()
        case "ANS":
            insertText("ANS")
        case "×10□":
            insertText("×10^")
        default:
            insertText(symbol)
        }
    }
    
    private func insertText(_ text: String) {
        currentExpression += text
    }
    
    private func insertFormula(_ suggestion: FormulaAutoComplete.Suggestion) {
        currentExpression = suggestion.insertionText
        evaluateCurrentTemplate()
    }
    
    private func insertAutoFillFormula(_ formula: AutoFillFormula) {
        selectedTemplate = formula.template
        templateValues = [:]
        
        // Pre-populate template with formula values
        switch formula {
        case .volumeOfSphere:
            templateValues = ["base": 4.0/3.0, "exponent": 3.0]
        case .areaOfCircle:
            templateValues = ["base": Double.pi, "exponent": 2.0]
        case .pythagoreanTheorem:
            templateValues = ["base": 1.0, "exponent": 2.0]
        case .quadraticFormula:
            templateValues = ["value": 1.0, "index": 2.0]
        case .distanceFormula:
            templateValues = ["value": 1.0, "index": 2.0]
        }
    }
    
    private func evaluateCurrentTemplate() {
        guard let template = selectedTemplate else {
            return
        }
        
        do {
            let result = try template.evaluate(with: getCurrentTemplateValues())
            currentResult = formatNumber(result)
            showingSyntaxError = false
            
            // Add to document
            let line = EquationLine(
                expression: template.getExpressionString(with: getCurrentTemplateValues()),
                latexExpression: "",
                result: currentResult
            )
            currentDocument.addLine(line)
            
        } catch {
            showingSyntaxError = true
            syntaxErrorMessage = error.localizedDescription
            currentResult = ""
        }
    }
    
    private func getCurrentTemplateValues() -> [String: Double] {
        return templateValues
    }
    
    private func updateTemplateParameter(_ parameter: String, value: Double) {
        templateValues[parameter] = value
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}

// MARK: - Supporting Types

enum MathTemplate: CaseIterable {
    case summation
    case integral
    case derivative
    case limit
    case matrix
    case fraction
    case power
    case root
    case logarithm
    case trigonometric
    
    var symbol: String {
        switch self {
        case .summation: return "Σ"
        case .integral: return "∫"
        case .derivative: return "d/dx"
        case .limit: return "lim"
        case .matrix: return "⌊ ⌋"
        case .fraction: return "a/b"
        case .power: return "x^n"
        case .root: return "√"
        case .logarithm: return "log"
        case .trigonometric: return "sin"
        }
    }
    
    var displayName: String {
        switch self {
        case .summation: return "Sum"
        case .integral: return "Integral"
        case .derivative: return "Derivative"
        case .limit: return "Limit"
        case .matrix: return "Matrix"
        case .fraction: return "Fraction"
        case .power: return "Power"
        case .root: return "Root"
        case .logarithm: return "Log"
        case .trigonometric: return "Trig"
        }
    }
    
    @ViewBuilder
    func visualRepresentation(with values: [String: Double]) -> some View {
        switch self {
        case .summation:
            SummationTemplateView(values: values)
        case .integral:
            IntegralTemplateView(values: values)
        case .derivative:
            DerivativeTemplateView(values: values)
        case .limit:
            LimitTemplateView(values: values)
        case .matrix:
            MatrixTemplateView(values: values)
        case .fraction:
            FractionTemplateView(values: values)
        case .power:
            PowerTemplateView(values: values)
        case .root:
            RootTemplateView(values: values)
        case .logarithm:
            LogarithmTemplateView(values: values)
        case .trigonometric:
            TrigonometricTemplateView(values: values)
        }
    }
    
    @ViewBuilder
    func inputFields(onChange: @escaping (String, Double) -> Void) -> some View {
        switch self {
        case .summation:
            SummationInputFields(onChange: onChange)
        case .integral:
            IntegralInputFields(onChange: onChange)
        case .derivative:
            DerivativeInputFields(onChange: onChange)
        case .limit:
            LimitInputFields(onChange: onChange)
        case .matrix:
            MatrixInputFields(onChange: onChange)
        case .fraction:
            FractionInputFields(onChange: onChange)
        case .power:
            PowerInputFields(onChange: onChange)
        case .root:
            RootInputFields(onChange: onChange)
        case .logarithm:
            LogarithmInputFields(onChange: onChange)
        case .trigonometric:
            TrigonometricInputFields(onChange: onChange)
        }
    }
    
    func evaluate(with values: [String: Double]) throws -> Double {
        switch self {
        case .summation:
            return try evaluateSummation(values)
        case .integral:
            return try evaluateIntegral(values)
        case .derivative:
            return try evaluateDerivative(values)
        case .limit:
            return try evaluateLimit(values)
        case .matrix:
            return try evaluateMatrix(values)
        case .fraction:
            return try evaluateFraction(values)
        case .power:
            return try evaluatePower(values)
        case .root:
            return try evaluateRoot(values)
        case .logarithm:
            return try evaluateLogarithm(values)
        case .trigonometric:
            return try evaluateTrigonometric(values)
        }
    }
    
    func getExpressionString(with values: [String: Double]) -> String {
        switch self {
        case .summation:
            return "Σ(x=\(values["start"] ?? 0) to \(values["end"] ?? 0)) \(values["expression"] ?? 0)"
        case .integral:
            return "∫(\(values["lower"] ?? 0) to \(values["upper"] ?? 0)) \(values["function"] ?? 0) dx"
        default:
            return displayName
        }
    }
    
    // Evaluation methods
    private func evaluateSummation(_ values: [String: Double]) throws -> Double {
        guard let start = values["start"],
              let end = values["end"],
              let expression = values["expression"] else {
            throw CalculationError.missingParameters
        }
        
        var sum = 0.0
        for x in Int(start)...Int(end) {
            sum += expression // This would be the evaluated expression with x substituted
        }
        return sum
    }
    
    private func evaluateIntegral(_ values: [String: Double]) throws -> Double {
        // Simplified numerical integration
        return 0.0 // Placeholder
    }
    
    private func evaluateDerivative(_ values: [String: Double]) throws -> Double {
        // Numerical derivative
        return 0.0 // Placeholder
    }
    
    private func evaluateLimit(_ values: [String: Double]) throws -> Double {
        // Limit evaluation
        return 0.0 // Placeholder
    }
    
    private func evaluateMatrix(_ values: [String: Double]) throws -> Double {
        // Matrix operations
        return 0.0 // Placeholder
    }
    
    private func evaluateFraction(_ values: [String: Double]) throws -> Double {
        guard let numerator = values["numerator"],
              let denominator = values["denominator"] else {
            throw CalculationError.missingParameters
        }
        
        guard denominator != 0 else {
            throw CalculationError.divisionByZero
        }
        
        return numerator / denominator
    }
    
    private func evaluatePower(_ values: [String: Double]) throws -> Double {
        guard let base = values["base"],
              let exponent = values["exponent"] else {
            throw CalculationError.missingParameters
        }
        
        return pow(base, exponent)
    }
    
    private func evaluateRoot(_ values: [String: Double]) throws -> Double {
        guard let value = values["value"],
              let index = values["index"] else {
            throw CalculationError.missingParameters
        }
        
        return pow(value, 1.0 / index)
    }
    
    private func evaluateLogarithm(_ values: [String: Double]) throws -> Double {
        guard let value = values["value"],
              let base = values["base"] else {
            throw CalculationError.missingParameters
        }
        
        return log(value) / log(base)
    }
    
    private func evaluateTrigonometric(_ values: [String: Double]) throws -> Double {
        guard let value = values["value"],
              let function = values["function"] else {
            throw CalculationError.missingParameters
        }
        
        switch Int(function) {
        case 0: return sin(value)
        case 1: return cos(value)
        case 2: return tan(value)
        default: return 0.0
        }
    }
}

enum AutoFillFormula: CaseIterable {
    case volumeOfSphere
    case areaOfCircle
    case pythagoreanTheorem
    case quadraticFormula
    case distanceFormula
    
    var displayName: String {
        switch self {
        case .volumeOfSphere: return "Volume of Sphere"
        case .areaOfCircle: return "Area of Circle"
        case .pythagoreanTheorem: return "Pythagorean Theorem"
        case .quadraticFormula: return "Quadratic Formula"
        case .distanceFormula: return "Distance Formula"
        }
    }
    
    var template: MathTemplate {
        switch self {
        case .volumeOfSphere: return .power
        case .areaOfCircle: return .power
        case .pythagoreanTheorem: return .power
        case .quadraticFormula: return .root
        case .distanceFormula: return .root
        }
    }
}

enum CalculationError: Error {
    case missingParameters
    case divisionByZero
    case invalidInput
}

#Preview {
    AdvancedScientificCalculatorView()
        .frame(width: 1200, height: 900)
}
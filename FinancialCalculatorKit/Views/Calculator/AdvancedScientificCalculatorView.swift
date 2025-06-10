//
//  AdvancedScientificCalculatorView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
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
    @State private var currentLatexExpression: String = ""
    @State private var showingSyntaxError: Bool = false
    @State private var syntaxErrorMessage: String = ""
    
    @State private var showingAutoComplete: Bool = false
    @State private var autoCompleteSuggestions: [FormulaAutoComplete.Suggestion] = []
    @State private var selectedSuggestionIndex: Int = 0
    
    @State private var showingVariableSheet: Bool = false
    @State private var showingDocumentList: Bool = false
    @State private var showingFormulaLibrary: Bool = false
    
    @State private var cursorPosition: Int = 0
    @State private var keyboardHeight: CGFloat = 0
    
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
    }
    
    @ViewBuilder
    private var sidebarContent: some View {
        VStack(spacing: 16) {
            // Document info
            documentInfoSection
            
            // Variable list
            variableListSection
            
            // Quick functions
            quickFunctionsSection
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 300)
    }
    
    @ViewBuilder
    private var documentInfoSection: some View {
        GroupBox("Document") {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Document Title", text: $currentDocument.title)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Subtitle (optional)", text: $currentDocument.subtitle)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Text("Lines: \(currentDocument.lines.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Modified: \(currentDocument.modified, style: .relative)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
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
            .frame(maxHeight: 200)
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
    private var quickFunctionsSection: some View {
        GroupBox("Quick Functions") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(quickFunctionButtons, id: \.title) { button in
                    Button(action: {
                        insertText(button.insertion)
                    }) {
                        VStack(spacing: 4) {
                            Text(button.symbol)
                                .font(.title2)
                            Text(button.title)
                                .font(.caption2)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(NSColor.controlBackgroundColor))
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
        VStack(spacing: 24) {
            // Expression editor
            expressionEditorSection
            
            // LaTeX preview
            latexPreviewSection
            
            // Document content
            documentContentSection
            
            // Auto-complete suggestions
            if showingAutoComplete {
                autoCompleteSuggestionsView
            }
            
            // Custom keyboard
            customKeyboardSection
        }
        .padding(24)
        .overlay(alignment: .bottom) {
            if showingSyntaxError {
                syntaxErrorBanner
            }
        }
    }
    
    @ViewBuilder
    private var expressionEditorSection: some View {
        GroupBox("Expression Editor") {
            VStack(spacing: 16) {
                // Main expression input
                HStack {
                    TextField("Enter mathematical expression...", text: $currentExpression)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.title2, design: .monospaced))
                        .onSubmit {
                            evaluateCurrentExpression()
                        }
                        .onChange(of: currentExpression) { _, newValue in
                            updateAutoCompleteSuggestions(for: newValue)
                            updateLatexPreview()
                        }
                    
                    Button("Clear") {
                        clearCurrentExpression()
                    }
                    .buttonStyle(.bordered)
                }
                
                // Result display
                if !currentResult.isEmpty {
                    HStack {
                        Text("=")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text(currentResult)
                            .font(.system(.title, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                    }
                }
                
                // Action buttons
                HStack {
                    Button("Evaluate", action: evaluateCurrentExpression)
                        .buttonStyle(.borderedProminent)
                        .disabled(currentExpression.isEmpty)
                    
                    Button("Add to Document", action: addToDocument)
                        .buttonStyle(.bordered)
                        .disabled(currentExpression.isEmpty)
                    
                    Button("Assign Variable", action: assignVariable)
                        .buttonStyle(.bordered)
                        .disabled(currentResult.isEmpty)
                    
                    Spacer()
                    
                    Button("Formulas", action: { showingFormulaLibrary = true })
                        .buttonStyle(.bordered)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var latexPreviewSection: some View {
        if !currentLatexExpression.isEmpty {
            GroupBox("LaTeX Preview") {
                VStack(spacing: 12) {
                    LaTeX(currentLatexExpression)
                        .frame(minHeight: 80)
                        .frame(maxWidth: .infinity)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    
                    if !currentResult.isEmpty {
                        LaTeX("$= \(currentResult)$")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
    }
    
    @ViewBuilder
    private var documentContentSection: some View {
        GroupBox("Document Content") {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(currentDocument.getSortedLines(), id: \.id) { line in
                        documentLineView(line)
                    }
                    
                    if currentDocument.lines.isEmpty {
                        VStack(spacing: 16) {
                            Text("No equations in document")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Start by entering an expression above and clicking 'Add to Document'")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding(.vertical, 8)
            }
            .frame(maxHeight: 400)
            .padding(12)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private func documentLineView(_ line: EquationLine) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if line.isVariable && !line.variableName.isEmpty {
                    Text(line.variableName)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("=")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Edit") {
                    editDocumentLine(line)
                }
                .buttonStyle(.borderless)
                .font(.caption)
                
                Button("Delete") {
                    deleteDocumentLine(line)
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .foregroundColor(.red)
            }
            
            if !line.latexExpression.isEmpty {
                LaTeX(line.latexExpression)
                    .frame(minHeight: 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(line.expression)
                    .font(.system(.body, design: .monospaced))
            }
            
            if !line.result.isEmpty {
                Text("= \(line.result)")
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private var autoCompleteSuggestionsView: some View {
        GroupBox("Suggestions") {
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(autoCompleteSuggestions.indices, id: \.self) { index in
                        let suggestion = autoCompleteSuggestions[index]
                        
                        Button(action: {
                            insertSuggestion(suggestion)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(suggestion.title)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Text(suggestion.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(suggestion.category.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                            .padding(8)
                            .background(index == selectedSuggestionIndex ? Color.accentColor.opacity(0.1) : Color.clear)
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxHeight: 200)
            .padding(8)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var customKeyboardSection: some View {
        GroupBox("Scientific Keyboard") {
            CustomScientificKeyboard { insertion in
                insertText(insertion)
            }
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var syntaxErrorBanner: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text(syntaxErrorMessage)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button("Dismiss") {
                showingSyntaxError = false
            }
            .buttonStyle(.borderless)
            .font(.caption)
        }
        .padding(12)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Variables") {
                showingVariableSheet = true
            }
            .help("Manage variables")
            
            Button("Documents") {
                showingDocumentList = true
            }
            .help("Document library")
            
            Button("Export") {
                exportDocument()
            }
            .help("Export document")
            .disabled(currentDocument.lines.isEmpty)
            
            Button("New Document") {
                createNewDocument()
            }
            .help("Create new document")
        }
    }
    
    // MARK: - Actions
    
    private func evaluateCurrentExpression() {
        guard !currentExpression.isEmpty else { return }
        
        do {
            let result = try expressionParser.parseExpression(currentExpression)
            currentResult = formatNumber(result.value)
            currentLatexExpression = result.latexExpression
            showingSyntaxError = false
        } catch {
            showingSyntaxError = true
            syntaxErrorMessage = error.localizedDescription
            currentResult = ""
        }
    }
    
    private func updateLatexPreview() {
        guard !currentExpression.isEmpty else {
            currentLatexExpression = ""
            return
        }
        
        currentLatexExpression = expressionParser.generateLatexExpression(currentExpression)
    }
    
    private func clearCurrentExpression() {
        currentExpression = ""
        currentResult = ""
        currentLatexExpression = ""
        showingSyntaxError = false
        showingAutoComplete = false
    }
    
    private func addToDocument() {
        let line = EquationLine(
            expression: currentExpression,
            latexExpression: currentLatexExpression,
            result: currentResult
        )
        currentDocument.addLine(line)
        clearCurrentExpression()
    }
    
    private func assignVariable() {
        // This would show a dialog to enter variable name
        // For now, using a simple naming scheme
        let variableName = generateVariableName()
        
        if let value = Double(currentResult) {
            variableStore.setVariable(
                name: variableName,
                value: value,
                expression: currentExpression,
                latexExpression: currentLatexExpression
            )
            
            let line = EquationLine(
                expression: currentExpression,
                latexExpression: currentLatexExpression,
                result: currentResult,
                isVariable: true,
                variableName: variableName
            )
            currentDocument.addLine(line)
            clearCurrentExpression()
        }
    }
    
    private func generateVariableName() -> String {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        
        for char in alphabet {
            let name = String(char)
            if !variableStore.hasVariable(name: name) {
                return name
            }
        }
        
        // If all single letters are used, try subscripted versions
        for char in alphabet {
            for i in 1...10 {
                let name = "\(char)\(i)"
                if !variableStore.hasVariable(name: name) {
                    return name
                }
            }
        }
        
        return "var\(Int.random(in: 1000...9999))"
    }
    
    private func insertText(_ text: String) {
        currentExpression += text
        updateAutoCompleteSuggestions(for: currentExpression)
        updateLatexPreview()
    }
    
    private func insertFormula(_ suggestion: FormulaAutoComplete.Suggestion) {
        currentExpression = suggestion.insertionText
        updateLatexPreview()
        evaluateCurrentExpression()
    }
    
    private func insertSuggestion(_ suggestion: FormulaAutoComplete.Suggestion) {
        currentExpression = suggestion.insertionText
        showingAutoComplete = false
        updateLatexPreview()
    }
    
    private func updateAutoCompleteSuggestions(for input: String) {
        let suggestions = autoComplete.getSuggestions(for: input, limit: 8)
        autoCompleteSuggestions = suggestions
        showingAutoComplete = !suggestions.isEmpty && !input.isEmpty
        selectedSuggestionIndex = 0
    }
    
    private func editDocumentLine(_ line: EquationLine) {
        currentExpression = line.expression
        currentResult = line.result
        currentLatexExpression = line.latexExpression
        
        // Remove the line from document since we're editing it
        if let index = currentDocument.lines.firstIndex(where: { $0.id == line.id }) {
            currentDocument.removeLine(at: index)
        }
    }
    
    private func deleteDocumentLine(_ line: EquationLine) {
        if let index = currentDocument.lines.firstIndex(where: { $0.id == line.id }) {
            currentDocument.removeLine(at: index)
        }
    }
    
    private func createNewDocument() {
        currentDocument = EquationDocument()
        clearCurrentExpression()
    }
    
    private func exportDocument() {
        // Implementation for exporting document
        // This would show a save dialog and export in various formats
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

// MARK: - Quick Function Buttons

private struct QuickFunctionButton {
    let title: String
    let symbol: String
    let insertion: String
}

private let quickFunctionButtons: [QuickFunctionButton] = [
    QuickFunctionButton(title: "Sum", symbol: "Σ", insertion: "sum("),
    QuickFunctionButton(title: "Product", symbol: "∏", insertion: "product("),
    QuickFunctionButton(title: "Integral", symbol: "∫", insertion: "integral("),
    QuickFunctionButton(title: "Square", symbol: "x²", insertion: "^2"),
    QuickFunctionButton(title: "Cube", symbol: "x³", insertion: "^3"),
    QuickFunctionButton(title: "Root", symbol: "√", insertion: "sqrt("),
    QuickFunctionButton(title: "Log", symbol: "log", insertion: "log("),
    QuickFunctionButton(title: "Ln", symbol: "ln", insertion: "ln("),
    QuickFunctionButton(title: "Sin", symbol: "sin", insertion: "sin("),
    QuickFunctionButton(title: "Cos", symbol: "cos", insertion: "cos("),
    QuickFunctionButton(title: "Tan", symbol: "tan", insertion: "tan("),
    QuickFunctionButton(title: "Pi", symbol: "π", insertion: "π"),
    QuickFunctionButton(title: "Euler", symbol: "e", insertion: "e"),
    QuickFunctionButton(title: "Phi", symbol: "φ", insertion: "φ"),
    QuickFunctionButton(title: "Factorial", symbol: "n!", insertion: "!"),
    QuickFunctionButton(title: "Abs", symbol: "|x|", insertion: "abs(")
]

#Preview {
    AdvancedScientificCalculatorView()
        .frame(width: 1400, height: 900)
}
//
//  VariableManagementView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import LaTeXSwiftUI

struct VariableManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var variableStore: VariableStore
    
    @State private var newVariableName: String = ""
    @State private var newVariableValue: String = ""
    @State private var newVariableExpression: String = ""
    @State private var selectedVariable: CalculatorVariable?
    @State private var showingEditSheet: Bool = false
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with statistics
                headerSection
                
                // Add new variable section
                addVariableSection
                
                // Variables list
                variablesListSection
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Variable Management")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Menu("Options") {
                        Button("Clear All Variables") {
                            clearAllVariables()
                        }
                        
                        Button("Export Variables") {
                            exportVariables()
                        }
                        
                        Button("Import Variables") {
                            importVariables()
                        }
                    }
                }
            }
        }
        .frame(width: 800, height: 600)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let variable = selectedVariable {
                EditVariableView(variable: variable, variableStore: variableStore)
            }
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        GroupBox("Variable Statistics") {
            HStack(spacing: 40) {
                VStack {
                    Text("\(variableStore.getUserVariables().count)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("User Variables")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(variableStore.constants.count)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Constants")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(variableStore.getAllVariables().count)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    Text("Total Variables")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var addVariableSection: some View {
        GroupBox("Add New Variable") {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Variable Name")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        TextField("e.g., x, alpha, rate", text: $newVariableName)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    }
                    .frame(width: 150)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Value")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        TextField("e.g., 3.14159, 42", text: $newVariableValue)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    }
                    .frame(width: 120)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Expression (optional)")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        TextField("e.g., 2*pi*r", text: $newVariableExpression)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    }
                    
                    VStack {
                        Spacer()
                        Button("Add Variable") {
                            addNewVariable()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(newVariableName.isEmpty || newVariableValue.isEmpty)
                    }
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var variablesListSection: some View {
        GroupBox("Variables") {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Name")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: 80, alignment: .leading)
                    
                    Text("Value")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: 120, alignment: .leading)
                    
                    Text("Expression")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Actions")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: 100, alignment: .center)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(NSColor.controlBackgroundColor))
                
                Divider()
                
                // Constants section
                if !variableStore.constants.isEmpty {
                    constantsSection
                    Divider()
                }
                
                // User variables section
                userVariablesSection
            }
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var constantsSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Mathematical Constants")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.green.opacity(0.1))
            
            ForEach(Array(variableStore.constants.keys.sorted()), id: \.self) { constantName in
                if let variable = variableStore.getVariable(name: constantName) {
                    variableRowView(variable, isConstant: true)
                }
            }
        }
    }
    
    @ViewBuilder
    private var userVariablesSection: some View {
        VStack(spacing: 0) {
            if !variableStore.getUserVariables().isEmpty {
                HStack {
                    Text("User-Defined Variables")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                
                ForEach(variableStore.getUserVariables(), id: \.name) { variable in
                    variableRowView(variable, isConstant: false)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "x.squareroot")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("No user variables defined")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Add variables above to store values and expressions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }
    
    @ViewBuilder
    private func variableRowView(_ variable: CalculatorVariable, isConstant: Bool) -> some View {
        HStack {
            // Name
            Text(variable.name)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(isConstant ? .green : .primary)
                .frame(width: 80, alignment: .leading)
            
            // Value
            Text(formatVariableValue(variable.value))
                .font(.system(.body, design: .monospaced))
                .frame(width: 120, alignment: .leading)
            
            // Expression/LaTeX
            HStack {
                if !variable.latexExpression.isEmpty && variable.latexExpression != variable.name {
                    LaTeX(variable.latexExpression)
                        .frame(height: 20)
                } else if !variable.expression.isEmpty && variable.expression != variable.name {
                    Text(variable.expression)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                } else {
                    Text("—")
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Actions
            HStack(spacing: 8) {
                if !isConstant {
                    Button("Edit") {
                        selectedVariable = variable
                        showingEditSheet = true
                    }
                    .buttonStyle(.borderless)
                    .font(.caption)
                    
                    Button("Delete") {
                        deleteVariable(variable)
                    }
                    .buttonStyle(.borderless)
                    .font(.caption)
                    .foregroundColor(.red)
                } else {
                    Text("Built-in")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 100, alignment: .center)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
    }
    
    // MARK: - Actions
    
    private func addNewVariable() {
        guard !newVariableName.isEmpty else {
            showError("Variable name cannot be empty")
            return
        }
        
        guard !newVariableValue.isEmpty else {
            showError("Variable value cannot be empty")
            return
        }
        
        guard let value = Double(newVariableValue) else {
            showError("Invalid numeric value")
            return
        }
        
        // Check if variable name already exists
        if variableStore.hasVariable(name: newVariableName) {
            showError("Variable '\(newVariableName)' already exists")
            return
        }
        
        // Validate variable name (basic check)
        if !isValidVariableName(newVariableName) {
            showError("Invalid variable name. Use letters, numbers, and underscores only.")
            return
        }
        
        variableStore.setVariable(
            name: newVariableName,
            value: value,
            expression: newVariableExpression.isEmpty ? newVariableValue : newVariableExpression
        )
        
        // Clear input fields
        newVariableName = ""
        newVariableValue = ""
        newVariableExpression = ""
    }
    
    private func deleteVariable(_ variable: CalculatorVariable) {
        variableStore.removeVariable(name: variable.name)
    }
    
    private func clearAllVariables() {
        variableStore.clearUserVariables()
    }
    
    private func exportVariables() {
        // Implementation for exporting variables to a file
    }
    
    private func importVariables() {
        // Implementation for importing variables from a file
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
    
    private func isValidVariableName(_ name: String) -> Bool {
        let pattern = "^[a-zA-Z_][a-zA-Z0-9_]*$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(name.startIndex..., in: name)
        return regex?.firstMatch(in: name, range: range) != nil
    }
    
    private func formatVariableValue(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}

// MARK: - Edit Variable View

struct EditVariableView: View {
    @Environment(\.dismiss) private var dismiss
    let variable: CalculatorVariable
    let variableStore: VariableStore
    
    @State private var name: String
    @State private var valueString: String
    @State private var expression: String
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    
    init(variable: CalculatorVariable, variableStore: VariableStore) {
        self.variable = variable
        self.variableStore = variableStore
        self._name = State(initialValue: variable.name)
        self._valueString = State(initialValue: String(variable.value))
        self._expression = State(initialValue: variable.expression)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                GroupBox("Edit Variable") {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Variable Name")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                TextField("Variable name", text: $name)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(.body, design: .monospaced))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Value")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                TextField("Numeric value", text: $valueString)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Expression (optional)")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            TextField("Mathematical expression", text: $expression)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(.body, design: .monospaced))
                        }
                        
                        if !expression.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("LaTeX Preview:")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                LaTeX("$\(expression)$")
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                                    .background(Color(NSColor.controlBackgroundColor))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Edit Variable")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        saveVariable()
                    }
                    .disabled(name.isEmpty || valueString.isEmpty)
                }
            }
        }
        .frame(width: 500, height: 400)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveVariable() {
        guard let value = Double(valueString) else {
            errorMessage = "Invalid numeric value"
            showingError = true
            return
        }
        
        // Remove old variable if name changed
        if name != variable.name {
            variableStore.removeVariable(name: variable.name)
        }
        
        variableStore.setVariable(
            name: name,
            value: value,
            expression: expression,
            latexExpression: expression.isEmpty ? "" : "$\(expression)$"
        )
        
        dismiss()
    }
}

#Preview {
    VariableManagementView(variableStore: VariableStore())
}
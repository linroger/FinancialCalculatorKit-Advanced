//
//  FormulaLibraryView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import LaTeXSwiftUI

struct FormulaLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    let autoComplete: FormulaAutoComplete
    let onFormulaSelected: (FormulaAutoComplete.Suggestion) -> Void
    
    @State private var selectedCategory: FormulaAutoComplete.Suggestion.Category = .geometry
    @State private var searchText: String = ""
    @State private var selectedFormula: FormulaAutoComplete.Suggestion?
    @State private var showingFormulaDetail: Bool = false
    
    var filteredFormulas: [FormulaAutoComplete.Suggestion] {
        let categoryFormulas = autoComplete.getSuggestions(for: selectedCategory)
        
        if searchText.isEmpty {
            return categoryFormulas
        } else {
            return categoryFormulas.filter { formula in
                formula.title.localizedCaseInsensitiveContains(searchText) ||
                formula.subtitle.localizedCaseInsensitiveContains(searchText) ||
                formula.completion.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            // Sidebar with categories
            sidebarContent
            
            // Main content with formulas
            mainContent
        }
        .navigationTitle("Formula Library")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .frame(width: 1200, height: 800)
        .sheet(isPresented: $showingFormulaDetail) {
            if let formula = selectedFormula {
                FormulaDetailView(formula: formula, onUse: { formula in
                    onFormulaSelected(formula)
                    dismiss()
                })
            }
        }
    }
    
    @ViewBuilder
    private var sidebarContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Search
            TextField("Search formulas...", text: $searchText)
                .textFieldStyle(.roundedBorder)
            
            // Categories
            VStack(alignment: .leading, spacing: 8) {
                Text("Categories")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                ForEach(FormulaAutoComplete.Suggestion.Category.allCases, id: \.self) { category in
                    categoryButton(category)
                }
            }
            
            Spacer()
            
            // Statistics
            statisticsSection
        }
        .padding(16)
        .frame(width: 250)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
    }
    
    @ViewBuilder
    private func categoryButton(_ category: FormulaAutoComplete.Suggestion.Category) -> some View {
        Button(action: {
            selectedCategory = category
        }) {
            HStack {
                categoryIcon(for: category)
                    .font(.title3)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Text("\(autoComplete.getSuggestions(for: category).count) formulas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(selectedCategory == category ? Color.accentColor.opacity(0.1) : Color.clear)
            .foregroundColor(selectedCategory == category ? .accentColor : .primary)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func categoryIcon(for category: FormulaAutoComplete.Suggestion.Category) -> some View {
        switch category {
        case .geometry:
            Image(systemName: "triangle")
        case .calculus:
            Image(systemName: "function")
        case .algebra:
            Image(systemName: "x.squareroot")
        case .trigonometry:
            Image(systemName: "waveform")
        case .statistics:
            Image(systemName: "chart.bar")
        case .physics:
            Image(systemName: "atom")
        case .finance:
            Image(systemName: "dollarsign.circle")
        case .constants:
            Image(systemName: "pi")
        case .functions:
            Image(systemName: "f.cursive")
        }
    }
    
    @ViewBuilder
    private var statisticsSection: some View {
        GroupBox("Library Stats") {
            VStack(spacing: 12) {
                HStack {
                    VStack {
                        Text("\(autoComplete.getAllSuggestions().count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(filteredFormulas.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("Filtered")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 20) {
            // Header
            headerSection
            
            // Formulas grid
            formulasGridSection
        }
        .padding(24)
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedCategory.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(filteredFormulas.count) formulas available")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                categoryIcon(for: selectedCategory)
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
            }
            
            if !searchText.isEmpty {
                Text("Showing results for '\(searchText)'")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var formulasGridSection: some View {
        if filteredFormulas.isEmpty {
            emptyStateView
        } else {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(filteredFormulas, id: \.title) { formula in
                        formulaCardView(formula)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Formulas Found")
                    .font(.title2)
                    .fontWeight(.medium)
                
                if searchText.isEmpty {
                    Text("This category doesn't have any formulas yet.")
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    Text("No formulas match '\(searchText)' in \(selectedCategory.rawValue)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button("Clear Search") {
                searchText = ""
            }
            .buttonStyle(.bordered)
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    @ViewBuilder
    private func formulaCardView(_ formula: FormulaAutoComplete.Suggestion) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(formula.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(formula.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // LaTeX formula
            VStack(alignment: .leading, spacing: 8) {
                Text("Formula:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                LaTeX(formula.latexFormula)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
            }
            
            // Implementation
            VStack(alignment: .leading, spacing: 8) {
                Text("Implementation:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(formula.completion)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            // Action buttons
            HStack {
                Button("Use Formula") {
                    onFormulaSelected(formula)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Details") {
                    selectedFormula = formula
                    showingFormulaDetail = true
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
                
                Button(action: {
                    copyToClipboard(formula.completion)
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(.borderless)
                .help("Copy to clipboard")
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

// MARK: - Formula Detail View

struct FormulaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let formula: FormulaAutoComplete.Suggestion
    let onUse: (FormulaAutoComplete.Suggestion) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(formula.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(formula.subtitle)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(formula.category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                        
                        Spacer()
                    }
                }
                
                // LaTeX display
                GroupBox("Mathematical Formula") {
                    LaTeX(formula.latexFormula)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Implementation
                GroupBox("Implementation") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Expression to enter:")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Text(formula.insertionText)
                            .font(.system(.title2, design: .monospaced))
                            .padding(12)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Parser-compatible version:")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Text(formula.completion)
                            .font(.system(.body, design: .monospaced))
                            .padding(12)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                // Usage notes
                if hasUsageNotes(for: formula) {
                    GroupBox("Usage Notes") {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(getUsageNotes(for: formula), id: \.self) { note in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(.blue)
                                        .fontWeight(.bold)
                                    
                                    Text(note)
                                        .font(.body)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(16)
                    }
                    .groupBoxStyle(FinancialGroupBoxStyle())
                }
                
                Spacer()
                
                // Action buttons
                HStack {
                    Button("Use This Formula") {
                        onUse(formula)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Copy Expression") {
                        copyToClipboard(formula.insertionText)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Spacer()
                }
            }
            .padding(24)
            .navigationTitle("Formula Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 700, height: 800)
    }
    
    private func hasUsageNotes(for formula: FormulaAutoComplete.Suggestion) -> Bool {
        return !getUsageNotes(for: formula).isEmpty
    }
    
    private func getUsageNotes(for formula: FormulaAutoComplete.Suggestion) -> [String] {
        switch formula.title {
        case "Area of Circle":
            return [
                "r represents the radius of the circle",
                "Result is in square units",
                "π (pi) ≈ 3.14159"
            ]
        case "Volume of Sphere":
            return [
                "r represents the radius of the sphere",
                "Result is in cubic units",
                "Formula derived from integral calculus"
            ]
        case "Pythagorean Theorem":
            return [
                "a and b are the lengths of the legs",
                "c is the length of the hypotenuse",
                "Only valid for right triangles"
            ]
        case "Quadratic Formula":
            return [
                "Solves ax² + bx + c = 0",
                "± means there are typically two solutions",
                "Discriminant b² - 4ac determines solution type"
            ]
        case "Normal Distribution":
            return [
                "μ (mu) is the mean",
                "σ (sigma) is the standard deviation",
                "x is the variable value"
            ]
        case "Black-Scholes Call":
            return [
                "S₀ is current stock price",
                "X is strike price",
                "r is risk-free rate",
                "T is time to expiration",
                "N(x) is cumulative normal distribution"
            ]
        default:
            return []
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

#Preview {
    FormulaLibraryView(
        autoComplete: FormulaAutoComplete(),
        onFormulaSelected: { _ in }
    )
}
//
//  FormulaReferenceView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import LaTeXSwiftUI

/// Comprehensive CFA Formula Reference with LaTeX rendering
struct FormulaReferenceView: View {
    @StateObject private var formulaDatabase = FormulaDatabase()
    @State private var selectedCategory: FormulaCategory = .fixedIncome
    @State private var selectedLevel: CFALevel = .all
    @State private var searchText: String = ""
    @State private var expandedFormula: UUID?
    @State private var showingFilters = false
    
    var filteredFormulas: [FormulaReference] {
        let categoryFormulas = formulaDatabase.formulas(for: selectedCategory, level: selectedLevel)
        
        if searchText.isEmpty {
            return categoryFormulas
        } else {
            return categoryFormulas.filter { formula in
                formula.name.localizedCaseInsensitiveContains(searchText) ||
                formula.description.localizedCaseInsensitiveContains(searchText) ||
                formula.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            mainContent
                .navigationTitle("CFA Formula Reference")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        filterButton
                    }
                }
                .sheet(isPresented: $showingFilters) {
                    FilterSheet(selectedLevel: $selectedLevel)
                }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            searchSection
            categoryPickerSection
            formulaScrollView
        }
    }
    
    @ViewBuilder
    private var formulaScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredFormulas) { formula in
                    FormulaCard(
                        formula: formula,
                        isExpanded: expandedFormula == formula.id
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if expandedFormula == formula.id {
                                expandedFormula = nil
                            } else {
                                expandedFormula = formula.id
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var searchSection: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search formulas...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            filterButton
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var filterButton: some View {
        Button(action: { showingFilters.toggle() }) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.blue)
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CFA Formula Reference")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Comprehensive formulas for all CFA levels")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Level indicator
                Text(selectedLevel.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(selectedLevel.color.opacity(0.1))
                    .foregroundColor(selectedLevel.color)
                    .clipShape(Capsule())
            }
            
            // Formula count
            Text("\(filteredFormulas.count) formulas")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    @ViewBuilder
    private var categoryPickerSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FormulaCategory.allCases) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                            expandedFormula = nil // Collapse any expanded formula
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

/// Individual category chip for the picker
struct CategoryChip: View {
    let category: FormulaCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? category.color : Color(NSColor.controlBackgroundColor))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(category.color, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

/// Individual formula card with expandable content
struct FormulaCard: View {
    let formula: FormulaReference
    let isExpanded: Bool
    let toggleExpanded: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main formula header
            mainFormulaSection
            
            if isExpanded {
                expandedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(formula.category.color.opacity(0.2), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var mainFormulaSection: some View {
        Button(action: toggleExpanded) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with title and level
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formula.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                        
                        Text(formula.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        // Level badge
                        Text(formula.level.rawValue)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(formula.level.color.opacity(0.1))
                            .foregroundColor(formula.level.color)
                            .clipShape(Capsule())
                        
                        // Expand indicator
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Main formula
                LaTeX(formula.mainFormula)
                    .parsingMode(.all)
                    .foregroundColor(Color.primary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(NSColor.windowBackgroundColor))
                    )
                
                // Tags
                if !formula.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(formula.tags.prefix(4)), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(formula.category.color.opacity(0.1))
                                    .foregroundColor(formula.category.color)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            
            // Variables section
            if !formula.variables.isEmpty {
                variablesSection
            }
            
            // Derivation section
            if let derivation = formula.derivation {
                derivationSection(derivation)
            }
            
            // Variants section
            if !formula.variants.isEmpty {
                variantsSection
            }
            
            // Usage notes
            if !formula.usageNotes.isEmpty {
                usageNotesSection
            }
            
            // Examples
            if !formula.examples.isEmpty {
                examplesSection
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var variablesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Variables")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(formula.category.color)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), alignment: .leading),
                GridItem(.flexible(), alignment: .leading)
            ], spacing: 8) {
                ForEach(formula.variables) { variable in
                    FormulaVariableView(variable: variable)
                }
            }
        }
    }
    
    @ViewBuilder
    private func derivationSection(_ derivation: FormulaDerivation) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 12) {
                // Assumptions
                if !derivation.assumptions.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Assumptions:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        ForEach(Array(derivation.assumptions.enumerated()), id: \.offset) { index, assumption in
                            Text("• \(assumption)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                
                // Derivation steps
                ForEach(derivation.steps) { step in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Step \(step.stepNumber): \(step.description)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color.primary)
                        
                        LaTeX(step.formula)
                            .parsingMode(.all)
                            .foregroundColor(Color.primary)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(NSColor.windowBackgroundColor))
                            )
                        
                        Text(step.explanation)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(formula.category.color.opacity(0.05))
                    )
                }
            }
        } label: {
            HStack {
                Text("Derivation")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(formula.category.color)
                
                Spacer()
                
                Image(systemName: "function")
                    .font(.caption)
                    .foregroundColor(formula.category.color)
            }
        }
        .tint(formula.category.color)
    }
    
    @ViewBuilder
    private var variantsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Formula Variants")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(formula.category.color)
            
            ForEach(formula.variants) { variant in
                FormulaVariantView(
                    variant: variant,
                    categoryColor: formula.category.color
                )
            }
        }
    }
    
    @ViewBuilder
    private var usageNotesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Usage Notes")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(formula.category.color)
            
            ForEach(Array(formula.usageNotes.enumerated()), id: \.offset) { index, note in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.top, 1)
                    
                    Text(note)
                        .font(.caption)
                        .foregroundColor(Color.primary)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.05))
        )
    }
    
    @ViewBuilder
    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Examples")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(formula.category.color)
            
            ForEach(formula.examples) { example in
                VStack(alignment: .leading, spacing: 8) {
                    Text(example.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.primary)
                    
                    Text(example.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Inputs
                    if !example.inputs.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Given:")
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            ForEach(Array(example.inputs.keys.sorted()), id: \.self) { key in
                                Text("\(key): \(example.inputs[key] ?? "")")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Calculation
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calculation:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text(example.calculation)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .font(.system(.caption2, design: .monospaced))
                    }
                    
                    // Result
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Result:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text(example.result)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(formula.category.color)
                    }
                    
                    // Interpretation
                    Text("Interpretation: \(example.interpretation)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.05))
                )
            }
        }
    }
}

/// Filter sheet for level selection
struct FilterSheet: View {
    @Binding var selectedLevel: CFALevel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Filter by CFA Level")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 12) {
                    ForEach(CFALevel.allCases) { level in
                        Button(action: {
                            selectedLevel = level
                            dismiss()
                        }) {
                            HStack {
                                Text(level.rawValue)
                                    .font(.body)
                                    .foregroundColor(Color.primary)
                                
                                Spacer()
                                
                                if selectedLevel == level {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(level.color)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FormulaReferenceView()
        .frame(width: 800, height: 1000)
}
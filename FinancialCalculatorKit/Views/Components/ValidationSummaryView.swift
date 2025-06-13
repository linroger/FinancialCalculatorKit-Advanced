//
//  ValidationSummaryView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Validation summary component for displaying validation results
//

import SwiftUI

/// View for displaying validation summary and errors
struct ValidationSummaryView: View {
    let results: [String: FinancialValidation.ValidationResult]
    @State private var isExpanded: Bool = false
    
    var body: some View {
        let errors = results.filter { !$0.value.isValid }
        let warnings = results.filter { $0.value.hasWarning }
        
        if !errors.isEmpty || !warnings.isEmpty {
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    // Header with expand/collapse
                    Button(action: { isExpanded.toggle() }) {
                        HStack {
                            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Validation Summary")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            // Error count badge
                            if !errors.isEmpty {
                                Badge(
                                    text: "\(errors.count)",
                                    color: .red,
                                    systemImage: "exclamationmark.triangle"
                                )
                            }
                            
                            // Warning count badge
                            if !warnings.isEmpty {
                                Badge(
                                    text: "\(warnings.count)",
                                    color: .orange,
                                    systemImage: "exclamationmark.triangle"
                                )
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    if isExpanded {
                        VStack(alignment: .leading, spacing: 6) {
                            // Show errors
                            ForEach(errors.sorted(by: { $0.key < $1.key }), id: \.key) { key, result in
                                ValidationItemView(
                                    fieldName: key,
                                    result: result,
                                    type: .error
                                )
                            }
                            
                            // Show warnings
                            ForEach(warnings.sorted(by: { $0.key < $1.key }), id: \.key) { key, result in
                                ValidationItemView(
                                    fieldName: key,
                                    result: result,
                                    type: .warning
                                )
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
            .groupBoxStyle(FinancialGroupBoxStyle(variant: .compact))
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
        }
    }
}

/// Individual validation item view
struct ValidationItemView: View {
    let fieldName: String
    let result: FinancialValidation.ValidationResult
    let type: ValidationItemType
    
    enum ValidationItemType {
        case error
        case warning
        
        var color: Color {
            switch self {
            case .error: return .red
            case .warning: return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: type.icon)
                .font(.caption)
                .foregroundColor(type.color)
                .frame(width: 16, alignment: .center)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(fieldName.capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if let message = result.errorMessage ?? result.warningMessage {
                    Text(message)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if let correctionAction = result.correctionAction {
                    Text(correctionAction)
                        .font(.caption2)
                        .foregroundColor(type.color)
                        .italic()
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

/// Simple badge component
struct Badge: View {
    let text: String
    let color: Color
    let systemImage: String?
    
    init(text: String, color: Color, systemImage: String? = nil) {
        self.text = text
        self.color = color
        self.systemImage = systemImage
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.caption2)
            }
            
            Text(text)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
        )
        .foregroundColor(color)
    }
}

/// Enhanced validation status indicator
struct ValidationStatusIndicator: View {
    let results: [String: FinancialValidation.ValidationResult]
    
    var body: some View {
        let errors = results.filter { !$0.value.isValid }
        let warnings = results.filter { $0.value.hasWarning }
        let valid = results.filter { $0.value.isValid && !$0.value.hasWarning }
        
        HStack(spacing: 4) {
            if !errors.isEmpty {
                StatusDot(color: .red, count: errors.count)
            }
            
            if !warnings.isEmpty {
                StatusDot(color: .orange, count: warnings.count)
            }
            
            if !valid.isEmpty && errors.isEmpty {
                StatusDot(color: .green, count: valid.count)
            }
        }
    }
}

struct StatusDot: View {
    let color: Color
    let count: Int
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .overlay(
                Text("\(count)")
                    .font(.system(size: 6, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(count > 1 ? 1 : 0)
            )
    }
}

/// Validation panel for detailed validation feedback
struct ValidationPanel: View {
    let results: [String: FinancialValidation.ValidationResult]
    let context: FinancialValidation.ValidationContext
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results.sorted(by: { $0.key < $1.key }), id: \.key) { key, result in
                    Section(key.capitalized) {
                        VStack(alignment: .leading, spacing: 8) {
                            // Status
                            HStack {
                                Image(systemName: result.isValid ? "checkmark.circle" : "xmark.circle")
                                    .foregroundColor(result.isValid ? .green : .red)
                                
                                Text(result.isValid ? "Valid" : "Invalid")
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            
                            // Messages
                            if let errorMessage = result.errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            if let warningMessage = result.warningMessage {
                                Text(warningMessage)
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                            
                            // Suggestions
                            let suggestions = FinancialValidation.shared.getRecoverySuggestions(
                                for: result,
                                context: context
                            )
                            
                            if !suggestions.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Suggestions:")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    
                                    ForEach(suggestions, id: \.self) { suggestion in
                                        Text("• \(suggestion)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            // Suggested value
                            if let suggestedValue = result.suggestedValue {
                                Text("Suggested value: \(String(format: "%.2f", suggestedValue))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Validation Details")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ValidationSummaryView(results: [
            "principal": FinancialValidation.ValidationResult.invalid(
                errorType: .outOfRange,
                message: "Principal must be at least $1.00",
                suggestedValue: 1000.0,
                context: FinancialValidation.ValidationContext(
                    calculationType: .loan,
                    fieldName: "principal"
                )
            ),
            "interestRate": FinancialValidation.ValidationResult.valid(
                warningMessage: "Interest rate above 20% is unusually high"
            ),
            "term": FinancialValidation.ValidationResult.valid()
        ])
        
        ValidationStatusIndicator(results: [
            "field1": FinancialValidation.ValidationResult.valid(),
            "field2": FinancialValidation.ValidationResult.invalid(
                errorType: .required,
                message: "Required field",
                context: FinancialValidation.ValidationContext(
                    calculationType: .loan,
                    fieldName: "field2"
                )
            )
        ])
        
        Badge(text: "3", color: .red, systemImage: "exclamationmark.triangle")
        Badge(text: "Valid", color: .green, systemImage: "checkmark")
    }
    .padding()
}
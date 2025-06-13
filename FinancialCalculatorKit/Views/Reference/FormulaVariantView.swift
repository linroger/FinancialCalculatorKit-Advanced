//
//  FormulaVariantView.swift
//  FinancialCalculatorKit
//
//  Created on 6/12/2025.
//

import SwiftUI
import LaTeXSwiftUI

struct FormulaVariantView: View {
    let variant: FormulaVariant
    let categoryColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(variant.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color.primary)
            
            LaTeX(variant.formula)
                .parsingMode(.all)
                .foregroundColor(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(NSColor.windowBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(NSColor.separatorColor).opacity(0.2), lineWidth: 1)
                )
            
            Text(variant.description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("When to use: \(variant.whenToUse)")
                .font(.caption2)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(categoryColor.opacity(0.05))
        )
    }
}
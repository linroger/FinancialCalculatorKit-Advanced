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
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(NSColor.windowBackgroundColor))
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
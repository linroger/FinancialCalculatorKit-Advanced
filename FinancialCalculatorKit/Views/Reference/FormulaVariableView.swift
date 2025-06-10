//
//  FormulaVariableView.swift
//  FinancialCalculatorKit
//
//  Created on 6/12/2025.
//

import SwiftUI
import LaTeXSwiftUI

struct FormulaVariableView: View {
    let variable: FormulaVariable
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                LaTeX(variable.symbol)
                    .parsingMode(.all)
                    .foregroundColor(Color.primary)
                
                Text(variable.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.primary)
                
                Spacer()
            }
            
            Text(variable.description)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            if let units = variable.units {
                Text("Units: \(units)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            if let range = variable.typicalRange {
                Text("Typical range: \(range)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(NSColor.textBackgroundColor))
        )
    }
}
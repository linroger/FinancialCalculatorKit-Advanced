//
//  DetailRow.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import SwiftUI

/// Consistent key-value display component for financial details
struct DetailRow: View {
    let title: String
    let value: String
    let isHighlighted: Bool
    
    init(title: String, value: String, isHighlighted: Bool = false) {
        self.title = title
        self.value = value
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(isHighlighted ? .financialSubheadline : .financialBody)
                .foregroundStyle(isHighlighted ? .primary : .secondary)
            
            Spacer()
            
            Text(value)
                .font(isHighlighted ? .financialNumber : .financialNumber)
                .foregroundStyle(isHighlighted ? .primary : .primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, isHighlighted ? 8 : 4)
        .background(
            isHighlighted ? 
            Color.accentColor.opacity(0.1) : 
            Color.clear
        )
        .cornerRadius(isHighlighted ? 8 : 0)
    }
}

/// Convenience initializers for common data types
extension DetailRow {
    /// Create DetailRow with currency value
    init(title: String, currencyValue: Double, currency: Currency, isHighlighted: Bool = false) {
        self.init(
            title: title,
            value: Formatters.formatCurrency(currencyValue, currency: currency),
            isHighlighted: isHighlighted
        )
    }
    
    /// Create DetailRow with percentage value
    init(title: String, percentageValue: Double, decimalPlaces: Int = 2, isHighlighted: Bool = false) {
        self.init(
            title: title,
            value: Formatters.formatPercentage(percentageValue, decimalPlaces: decimalPlaces),
            isHighlighted: isHighlighted
        )
    }
    
    /// Create DetailRow with numeric value
    init(title: String, numericValue: Double, decimalPlaces: Int = 2, isHighlighted: Bool = false) {
        let formatter = Formatters.decimalFormatter(decimalPlaces: decimalPlaces)
        self.init(
            title: title,
            value: formatter.string(from: NSNumber(value: numericValue)) ?? String(format: "%.\(decimalPlaces)f", numericValue),
            isHighlighted: isHighlighted
        )
    }
    
    /// Create DetailRow with date value
    init(title: String, dateValue: Date, isHighlighted: Bool = false) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        self.init(
            title: title,
            value: formatter.string(from: dateValue),
            isHighlighted: isHighlighted
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        DetailRow(title: "Principal", value: "$100,000")
        DetailRow(title: "Interest Rate", value: "5.25%")
        DetailRow(title: "Monthly Payment", value: "$2,147.29", isHighlighted: true)
        DetailRow(title: "Total Interest", value: "$25,000.50")
        DetailRow(title: "APR", value: "5.45%")
        DetailRow(title: "Last Updated", value: "Today")
    }
    .padding()
}
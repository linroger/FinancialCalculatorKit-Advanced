//
//  FormulaViewHelper.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI

/// View helper to provide UI-specific properties for formula models
struct FormulaViewHelper {
    
    /// Get color for CFA Level
    static func color(for level: CFALevel) -> Color {
        switch level {
        case .levelI: return .blue
        case .levelII: return .orange
        case .levelIII: return .red
        case .all: return .gray
        }
    }
    
    /// Get color for Formula Category
    static func color(for category: FormulaCategory) -> Color {
        switch category {
        case .quantitative: return .blue
        case .fixedIncome: return .green
        case .equity: return .purple
        case .derivatives: return .orange
        case .alternatives: return .brown
        case .portfolio: return .indigo
        case .risk: return .red
        case .economics: return .teal
        case .corporateIssuers: return .yellow
        }
    }
    
    /// Get icon name for Formula Category
    static func icon(for category: FormulaCategory) -> String {
        switch category {
        case .quantitative: return "function"
        case .fixedIncome: return "chart.line.uptrend.xyaxis"
        case .equity: return "building.columns"
        case .derivatives: return "arrow.triangle.swap"
        case .alternatives: return "building.2"
        case .portfolio: return "chart.pie"
        case .risk: return "shield"
        case .economics: return "globe"
        case .corporateIssuers: return "building.columns.fill"
        }
    }
}

// MARK: - Convenience Extensions

extension CFALevel {
    /// Get the associated color for UI display
    var displayColor: Color {
        FormulaViewHelper.color(for: self)
    }
}

extension FormulaCategory {
    /// Get the associated color for UI display
    var displayColor: Color {
        FormulaViewHelper.color(for: self)
    }
    
    /// Get the associated icon for UI display
    var displayIcon: String {
        FormulaViewHelper.icon(for: self)
    }
}
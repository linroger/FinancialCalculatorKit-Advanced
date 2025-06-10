//
//  PlaceholderViews.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/9/25.
//

import SwiftUI

// MARK: - Placeholder Views for Missing Calculators

struct AdvancedBondCalculatorView: View {
    var body: some View {
        ContentUnavailableView(
            "Advanced Bond Calculator",
            systemImage: "chart.line.uptrend.xyaxis",
            description: Text("Advanced bond calculator with duration, convexity, and risk analytics is under development.")
        )
    }
}

struct AdvancedScientificCalculatorView: View {
    var body: some View {
        ContentUnavailableView(
            "Advanced Scientific Calculator",
            systemImage: "function.variable",
            description: Text("Advanced scientific calculator with variable management and equation solving is under development.")
        )
    }
}

struct AdvancedDerivativesAnalyticsView: View {
    var body: some View {
        ContentUnavailableView(
            "Advanced Derivatives Analytics",
            systemImage: "rectangle.3.group.connected",
            description: Text("Professional derivatives analytics with cross-instrument analysis is under development.")
        )
    }
}

struct AlternativeInvestmentsView: View {
    var body: some View {
        ContentUnavailableView(
            "Alternative Investments",
            systemImage: "chart.bar.doc.horizontal",
            description: Text("Alternative investments analysis including REITs, commodities, and hedge funds is under development.")
        )
    }
}
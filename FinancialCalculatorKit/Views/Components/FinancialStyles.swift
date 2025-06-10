//
//  FinancialStyles.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI

/// Custom group box style for financial calculator components
struct FinancialGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            configuration.label
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            configuration.content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
        )
    }
}

/// Reusable detail row component for displaying key-value pairs
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
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.system(.body, design: .monospaced))
                .fontWeight(isHighlighted ? .semibold : .medium)
                .foregroundColor(isHighlighted ? .accentColor : .secondary)
        }
        .padding(.vertical, 4)
        .background(
            isHighlighted ? 
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.accentColor.opacity(0.05))
                .animation(.easeInOut(duration: 0.2), value: isHighlighted)
            : nil
        )
    }
}

/// Enhanced button style for primary actions
struct FinancialButtonStyle: ButtonStyle {
    let style: FinancialButtonStyleType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, weight: .medium))
            .foregroundColor(foregroundColor(for: style))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor(for: style))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor(for: style), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(for style: FinancialButtonStyleType) -> Color {
        switch style {
        case .primary:
            return .accentColor
        case .secondary:
            return Color(NSColor.controlBackgroundColor)
        case .destructive:
            return .red
        }
    }
    
    private func foregroundColor(for style: FinancialButtonStyleType) -> Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .primary
        case .destructive:
            return .white
        }
    }
    
    private func borderColor(for style: FinancialButtonStyleType) -> Color {
        switch style {
        case .primary:
            return .accentColor
        case .secondary:
            return Color(NSColor.separatorColor)
        case .destructive:
            return .red
        }
    }
}

enum FinancialButtonStyleType {
    case primary
    case secondary
    case destructive
}

/// Card style container for sections
struct FinancialCardStyle: ViewModifier {
    let padding: EdgeInsets
    
    init(padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)) {
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
            )
    }
}

extension View {
    func financialCard(padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)) -> some View {
        modifier(FinancialCardStyle(padding: padding))
    }
}

/// Extension for common financial app colors
extension Color {
    static let financialGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let financialRed = Color(red: 0.8, green: 0.2, blue: 0.2)
    static let financialBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let financialOrange = Color(red: 0.9, green: 0.6, blue: 0.1)
}

#Preview {
    VStack(spacing: 20) {
        GroupBox("Sample Group") {
            VStack(spacing: 12) {
                DetailRow(title: "Principal", value: "$100,000.00")
                DetailRow(title: "Interest Rate", value: "5.50%", isHighlighted: true)
                DetailRow(title: "Term", value: "30 years")
            }
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
        
        HStack(spacing: 12) {
            Button("Primary") { }
                .buttonStyle(FinancialButtonStyle(style: .primary))
            
            Button("Secondary") { }
                .buttonStyle(FinancialButtonStyle(style: .secondary))
            
            Button("Delete") { }
                .buttonStyle(FinancialButtonStyle(style: .destructive))
        }
        
        VStack {
            Text("Financial Card Example")
                .font(.headline)
            Text("This is a sample card with the financial styling.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .financialCard()
    }
    .padding()
    .frame(width: 400)
}
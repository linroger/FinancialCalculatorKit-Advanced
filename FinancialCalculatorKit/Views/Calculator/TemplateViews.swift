//
//  TemplateViews.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import SwiftUI
import LaTeXSwiftUI

// MARK: - Template Visual Representations

struct SummationTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Text("n")
                    .font(.system(size: 14))
                Text("Σ")
                    .font(.system(size: 48, weight: .light))
                Text("i=1")
                    .font(.system(size: 14))
            }
            
            Text("f(i)")
                .font(.system(size: 20))
                .italic()
        }
        .foregroundColor(.primary)
    }
}

struct IntegralTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Text("b")
                    .font(.system(size: 14))
                Text("∫")
                    .font(.system(size: 48, weight: .light))
                Text("a")
                    .font(.system(size: 14))
            }
            
            Text("f(x) dx")
                .font(.system(size: 20))
                .italic()
        }
        .foregroundColor(.primary)
    }
}

struct DerivativeTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 2) {
                Text("d")
                    .font(.system(size: 16))
                Rectangle()
                    .frame(height: 1)
                    .frame(width: 20)
                Text("dx")
                    .font(.system(size: 16))
            }
            
            Text("[f(x)]")
                .font(.system(size: 20))
                .italic()
        }
        .foregroundColor(.primary)
    }
}

struct LimitTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("lim")
                    .font(.system(size: 18))
                Text("x→a")
                    .font(.system(size: 14))
            }
            
            Text("f(x)")
                .font(.system(size: 20))
                .italic()
        }
        .foregroundColor(.primary)
    }
}

struct MatrixTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(spacing: 4) {
            Text("[")
                .font(.system(size: 48, weight: .light))
            
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Text("a₁₁")
                    Text("a₁₂")
                }
                HStack(spacing: 12) {
                    Text("a₂₁")
                    Text("a₂₂")
                }
            }
            .font(.system(size: 16))
            
            Text("]")
                .font(.system(size: 48, weight: .light))
        }
        .foregroundColor(.primary)
    }
}

struct FractionTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        VStack(spacing: 4) {
            Text("a")
                .font(.system(size: 20))
            
            Rectangle()
                .frame(height: 2)
                .frame(width: 40)
            
            Text("b")
                .font(.system(size: 20))
        }
        .foregroundColor(.primary)
    }
}

struct PowerTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            Text("x")
                .font(.system(size: 24))
            Text("n")
                .font(.system(size: 16))
                .offset(y: -8)
        }
        .foregroundColor(.primary)
    }
}

struct RootTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("n")
                .font(.system(size: 14))
                .offset(y: -12)
            
            Text("√")
                .font(.system(size: 32, weight: .light))
            
            Text("x")
                .font(.system(size: 20))
        }
        .foregroundColor(.primary)
    }
}

struct LogarithmTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            Text("log")
                .font(.system(size: 20))
            Text("b")
                .font(.system(size: 14))
                .offset(y: 4)
            Text("(x)")
                .font(.system(size: 20))
        }
        .foregroundColor(.primary)
    }
}

struct TrigonometricTemplateView: View {
    let values: [String: Double]
    
    var body: some View {
        HStack(spacing: 2) {
            Text("sin(x)")
                .font(.system(size: 20))
        }
        .foregroundColor(.primary)
    }
}

// MARK: - Template Input Fields

struct SummationInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var startValue: String = "1"
    @State private var endValue: String = "10"
    @State private var expression: String = "i"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("From:")
                TextField("Start", text: $startValue)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onChange(of: startValue) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("start", value)
                        }
                    }
                
                Text("To:")
                TextField("End", text: $endValue)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onChange(of: endValue) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("end", value)
                        }
                    }
            }
            
            HStack {
                Text("Expression:")
                TextField("f(i)", text: $expression)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: expression) { _, newValue in
                        onChange("expression", 1.0) // Placeholder for expression parsing
                    }
            }
        }
    }
}

struct IntegralInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var lowerBound: String = "0"
    @State private var upperBound: String = "1"
    @State private var function: String = "x"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Lower bound:")
                TextField("a", text: $lowerBound)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onChange(of: lowerBound) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("lower", value)
                        }
                    }
                
                Text("Upper bound:")
                TextField("b", text: $upperBound)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onChange(of: upperBound) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("upper", value)
                        }
                    }
            }
            
            HStack {
                Text("Function:")
                TextField("f(x)", text: $function)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: function) { _, newValue in
                        onChange("function", 1.0) // Placeholder for function parsing
                    }
            }
        }
    }
}

struct DerivativeInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var function: String = "x^2"
    @State private var point: String = "1"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Function:")
                TextField("f(x)", text: $function)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: function) { _, newValue in
                        onChange("function", 1.0) // Placeholder for function parsing
                    }
            }
            
            HStack {
                Text("At point:")
                TextField("x", text: $point)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onChange(of: point) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("point", value)
                        }
                    }
            }
        }
    }
}

struct LimitInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var function: String = "x^2"
    @State private var approach: String = "0"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Function:")
                TextField("f(x)", text: $function)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: function) { _, newValue in
                        onChange("function", 1.0) // Placeholder for function parsing
                    }
            }
            
            HStack {
                Text("x approaches:")
                TextField("a", text: $approach)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .onChange(of: approach) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("approach", value)
                        }
                    }
            }
        }
    }
}

struct MatrixInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var a11: String = "1"
    @State private var a12: String = "2"
    @State private var a21: String = "3"
    @State private var a22: String = "4"
    
    var body: some View {
        VStack(spacing: 12) {
            Text("2×2 Matrix")
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    TextField("a₁₁", text: $a11)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .onChange(of: a11) { _, newValue in
                            if let value = Double(newValue) {
                                onChange("a11", value)
                            }
                        }
                    
                    TextField("a₂₁", text: $a21)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .onChange(of: a21) { _, newValue in
                            if let value = Double(newValue) {
                                onChange("a21", value)
                            }
                        }
                }
                
                VStack(spacing: 8) {
                    TextField("a₁₂", text: $a12)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .onChange(of: a12) { _, newValue in
                            if let value = Double(newValue) {
                                onChange("a12", value)
                            }
                        }
                    
                    TextField("a₂₂", text: $a22)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .onChange(of: a22) { _, newValue in
                            if let value = Double(newValue) {
                                onChange("a22", value)
                            }
                        }
                }
            }
        }
    }
}

struct FractionInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var numerator: String = "1"
    @State private var denominator: String = "2"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Numerator:")
                TextField("a", text: $numerator)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: numerator) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("numerator", value)
                        }
                    }
            }
            
            HStack {
                Text("Denominator:")
                TextField("b", text: $denominator)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: denominator) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("denominator", value)
                        }
                    }
            }
        }
    }
}

struct PowerInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var base: String = "2"
    @State private var exponent: String = "3"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Base:")
                TextField("x", text: $base)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: base) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("base", value)
                        }
                    }
            }
            
            HStack {
                Text("Exponent:")
                TextField("n", text: $exponent)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: exponent) { _, newValue in
                        if let value = Double(newValue) {
                            onChange("exponent", value)
                        }
                    }
            }
        }
    }
}

struct RootInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var value: String = "8"
    @State private var index: String = "3"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Value:")
                TextField("x", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: value) { _, newValue in
                        if let val = Double(newValue) {
                            onChange("value", val)
                        }
                    }
            }
            
            HStack {
                Text("Root index:")
                TextField("n", text: $index)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: index) { _, newValue in
                        if let val = Double(newValue) {
                            onChange("index", val)
                        }
                    }
            }
        }
    }
}

struct LogarithmInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var value: String = "100"
    @State private var base: String = "10"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Value:")
                TextField("x", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: value) { _, newValue in
                        if let val = Double(newValue) {
                            onChange("value", val)
                        }
                    }
            }
            
            HStack {
                Text("Base:")
                TextField("b", text: $base)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: base) { _, newValue in
                        if let val = Double(newValue) {
                            onChange("base", val)
                        }
                    }
            }
        }
    }
}

struct TrigonometricInputFields: View {
    let onChange: (String, Double) -> Void
    @State private var value: String = "45"
    @State private var selectedFunction: Int = 0
    
    private let functions = ["sin", "cos", "tan"]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Function:")
                Picker("Function", selection: $selectedFunction) {
                    ForEach(0..<functions.count, id: \.self) { index in
                        Text(functions[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedFunction) { _, newValue in
                    onChange("function", Double(newValue))
                }
            }
            
            HStack {
                Text("Value (degrees):")
                TextField("x", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: value) { _, newValue in
                        if let val = Double(newValue) {
                            onChange("value", val * .pi / 180) // Convert to radians
                        }
                    }
            }
        }
    }
}

// MARK: - Advanced Keyboard Grid

struct AdvancedKeyboardGrid: View {
    let onInsert: (String) -> Void
    
    private let advancedFunctions = [
        ["∛x", "∜x", "cosec", "sec", "cot", "sinh", "cosh", "tanh"],
        ["arcsinh", "arccosh", "arctanh", "rand", "rand#", "min", "max", "lcm"],
        ["gcd", "0b", "0o", "0x", "A", "B", "C", "D"],
        ["E", "F", "x!", "Γ", "nPr", "nCr", "i", "re"],
        ["im", "*", "⌊⌋"]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<advancedFunctions.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(advancedFunctions[row], id: \.self) { function in
                        Button(action: {
                            onInsert(function)
                        }) {
                            Text(function)
                                .font(.system(.caption, design: .monospaced))
                                .frame(minWidth: 44, minHeight: 32)
                                .background(Color(NSColor.controlBackgroundColor))
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Auto Fill Formulas View

struct AutoFillFormulasView: View {
    let onFormulaSelected: (AutoFillFormula) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(AutoFillFormula.allCases, id: \.self) { formula in
                    Button(action: {
                        onFormulaSelected(formula)
                        dismiss()
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(formula.displayName)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(formula.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Auto Fill Formulas")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 400, height: 500)
    }
}

// MARK: - Advanced Custom Keyboard View

struct AdvancedCustomKeyboardView: View {
    let onInsert: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Advanced Mathematical Functions")
                    .font(.headline)
                    .padding(.top)
                
                AdvancedKeyboardGrid(onInsert: onInsert)
                
                Spacer()
            }
            .navigationTitle("Custom Keyboard")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 600, height: 500)
    }
}

// MARK: - Extensions

extension AutoFillFormula {
    var description: String {
        switch self {
        case .volumeOfSphere:
            return "V = (4/3)πr³"
        case .areaOfCircle:
            return "A = πr²"
        case .pythagoreanTheorem:
            return "c² = a² + b²"
        case .quadraticFormula:
            return "x = (-b ± √(b²-4ac)) / 2a"
        case .distanceFormula:
            return "d = √((x₂-x₁)² + (y₂-y₁)²)"
        }
    }
}
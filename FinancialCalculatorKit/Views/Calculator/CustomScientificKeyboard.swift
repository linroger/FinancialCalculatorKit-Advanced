//
//  CustomScientificKeyboard.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI

struct CustomScientificKeyboard: View {
    let onButtonPress: (String) -> Void
    @State private var currentLayout: KeyboardLayout = .basic
    @State private var showingFunctionDetails: Bool = false
    @State private var selectedFunction: KeyboardButton?
    
    enum KeyboardLayout: String, CaseIterable, Identifiable {
        case basic = "Basic"
        case advanced = "Advanced"
        case trigonometric = "Trig"
        case hyperbolic = "Hyperbolic"
        case logarithmic = "Log/Exp"
        case statistics = "Statistics"
        case constants = "Constants"
        case numberBases = "Bases"
        
        var id: String { rawValue }
    }
    
    struct KeyboardButton: Identifiable, Hashable {
        let id = UUID()
        let display: String
        let insertion: String
        let category: String
        let description: String
        let color: Color
        let isWide: Bool
        
        init(display: String, insertion: String? = nil, category: String = "", description: String = "", color: Color = .primary, isWide: Bool = false) {
            self.display = display
            self.insertion = insertion ?? display
            self.category = category
            self.description = description
            self.color = color
            self.isWide = isWide
        }
        
        static func == (lhs: KeyboardButton, rhs: KeyboardButton) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Layout selector
            layoutSelector
            
            Divider()
            
            // Keyboard content
            keyboardContent
                .animation(.easeInOut(duration: 0.2), value: currentLayout)
        }
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .sheet(isPresented: $showingFunctionDetails) {
            if let function = selectedFunction {
                FunctionDetailView(function: function, onUse: { insertion in
                    onButtonPress(insertion)
                    showingFunctionDetails = false
                })
            }
        }
    }
    
    @ViewBuilder
    private var layoutSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(KeyboardLayout.allCases) { layout in
                    Button(action: {
                        currentLayout = layout
                    }) {
                        Text(layout.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(currentLayout == layout ? Color.accentColor : Color.clear)
                            .foregroundColor(currentLayout == layout ? .white : .primary)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var keyboardContent: some View {
        let buttons = getButtons(for: currentLayout)
        let columns = getColumns(for: currentLayout)
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(buttons) { button in
                    keyboardButtonView(button)
                }
            }
            .padding(12)
        }
        .frame(maxHeight: 300)
    }
    
    @ViewBuilder
    private func keyboardButtonView(_ button: KeyboardButton) -> some View {
        Button(action: {
            if button.description.isEmpty {
                onButtonPress(button.insertion)
            } else {
                selectedFunction = button
                showingFunctionDetails = true
            }
        }) {
            VStack(spacing: 2) {
                Text(button.display)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(button.color)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if !button.category.isEmpty {
                    Text(button.category)
                        .font(.system(.caption2))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: button.isWide ? 70 : 50, height: 40)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
        .help(button.description.isEmpty ? button.insertion : button.description)
    }
    
    private func getColumns(for layout: KeyboardLayout) -> [GridItem] {
        let count: Int
        switch layout {
        case .basic, .trigonometric, .hyperbolic:
            count = 5
        case .advanced, .logarithmic, .statistics:
            count = 6
        case .constants:
            count = 4
        case .numberBases:
            count = 8
        }
        
        return Array(repeating: GridItem(.flexible()), count: count)
    }
    
    private func getButtons(for layout: KeyboardLayout) -> [KeyboardButton] {
        switch layout {
        case .basic:
            return basicButtons
        case .advanced:
            return advancedButtons
        case .trigonometric:
            return trigonometricButtons
        case .hyperbolic:
            return hyperbolicButtons
        case .logarithmic:
            return logarithmicButtons
        case .statistics:
            return statisticsButtons
        case .constants:
            return constantsButtons
        case .numberBases:
            return numberBasesButtons
        }
    }
    
    // MARK: - Button Definitions
    
    private var basicButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "π", insertion: "π", category: "", color: .blue),
            KeyboardButton(display: "e", insertion: "e", category: "", color: .blue),
            KeyboardButton(display: "i", insertion: "i", category: "", color: .blue),
            KeyboardButton(display: "∞", insertion: "∞", category: "", color: .blue),
            KeyboardButton(display: "∑", insertion: "sum(", category: "", color: .purple),
            
            KeyboardButton(display: "sin", insertion: "sin(", category: "trig"),
            KeyboardButton(display: "cos", insertion: "cos(", category: "trig"),
            KeyboardButton(display: "tan", insertion: "tan(", category: "trig"),
            KeyboardButton(display: "|x|", insertion: "abs(", category: "util"),
            KeyboardButton(display: "!", insertion: "factorial(", category: "comb"),
            
            KeyboardButton(display: "log", insertion: "log(", category: "log"),
            KeyboardButton(display: "ln", insertion: "ln(", category: "log"),
            KeyboardButton(display: "√", insertion: "sqrt(", category: "root"),
            KeyboardButton(display: "∛", insertion: "cbrt(", category: "root"),
            KeyboardButton(display: "x²", insertion: "^2", category: "pow"),
            
            KeyboardButton(display: "x³", insertion: "^3", category: "pow"),
            KeyboardButton(display: "xʸ", insertion: "^", category: "pow"),
            KeyboardButton(display: "1/x", insertion: "1/(", category: "util"),
            KeyboardButton(display: "exp", insertion: "exp(", category: "exp"),
            KeyboardButton(display: "%", insertion: "%", category: "util"),
            
            KeyboardButton(display: "(", insertion: "(", category: ""),
            KeyboardButton(display: ")", insertion: ")", category: ""),
            KeyboardButton(display: "×", insertion: "*", category: ""),
            KeyboardButton(display: "÷", insertion: "/", category: ""),
            KeyboardButton(display: "±", insertion: "-", category: "")
        ]
    }
    
    private var advancedButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "∏", insertion: "product(", category: "seq", description: "Product sequence"),
            KeyboardButton(display: "∫", insertion: "integral(", category: "calc", description: "Integral"),
            KeyboardButton(display: "∂", insertion: "partial(", category: "calc", description: "Partial derivative"),
            KeyboardButton(display: "∇", insertion: "gradient(", category: "calc", description: "Gradient"),
            KeyboardButton(display: "Γ", insertion: "gamma(", category: "spec", description: "Gamma function"),
            KeyboardButton(display: "β", insertion: "beta(", category: "spec", description: "Beta function"),
            
            KeyboardButton(display: "ⁿCᵣ", insertion: "binomial(", category: "comb", description: "Binomial coefficient"),
            KeyboardButton(display: "ⁿPᵣ", insertion: "permutation(", category: "comb", description: "Permutation"),
            KeyboardButton(display: "gcd", insertion: "gcd(", category: "num", description: "Greatest common divisor"),
            KeyboardButton(display: "lcm", insertion: "lcm(", category: "num", description: "Least common multiple"),
            KeyboardButton(display: "erf", insertion: "erf(", category: "spec", description: "Error function"),
            KeyboardButton(display: "erfc", insertion: "erfc(", category: "spec", description: "Complementary error function"),
            
            KeyboardButton(display: "min", insertion: "min(", category: "stat"),
            KeyboardButton(display: "max", insertion: "max(", category: "stat"),
            KeyboardButton(display: "⌊x⌋", insertion: "floor(", category: "util", description: "Floor function"),
            KeyboardButton(display: "⌈x⌉", insertion: "ceil(", category: "util", description: "Ceiling function"),
            KeyboardButton(display: "round", insertion: "round(", category: "util"),
            KeyboardButton(display: "sign", insertion: "sign(", category: "util", description: "Sign function"),
            
            KeyboardButton(display: "rand", insertion: "random()", category: "stat", description: "Random number 0-1"),
            KeyboardButton(display: "rand#", insertion: "randomint(", category: "stat", description: "Random integer"),
            KeyboardButton(display: "prime?", insertion: "isprime(", category: "num", description: "Check if prime"),
            KeyboardButton(display: "∑digits", insertion: "digitsum(", category: "num", description: "Sum of digits"),
            KeyboardButton(display: "clamp", insertion: "clamp(", category: "util", description: "Clamp to range"),
            KeyboardButton(display: "lerp", insertion: "lerp(", category: "util", description: "Linear interpolation")
        ]
    }
    
    private var trigonometricButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "sin", insertion: "sin(", category: "basic"),
            KeyboardButton(display: "cos", insertion: "cos(", category: "basic"),
            KeyboardButton(display: "tan", insertion: "tan(", category: "basic"),
            KeyboardButton(display: "csc", insertion: "csc(", category: "recip", description: "Cosecant"),
            KeyboardButton(display: "sec", insertion: "sec(", category: "recip", description: "Secant"),
            
            KeyboardButton(display: "cot", insertion: "cot(", category: "recip", description: "Cotangent"),
            KeyboardButton(display: "sin⁻¹", insertion: "asin(", category: "inv", description: "Arcsine"),
            KeyboardButton(display: "cos⁻¹", insertion: "acos(", category: "inv", description: "Arccosine"),
            KeyboardButton(display: "tan⁻¹", insertion: "atan(", category: "inv", description: "Arctangent"),
            KeyboardButton(display: "csc⁻¹", insertion: "acsc(", category: "inv", description: "Arccosecant"),
            
            KeyboardButton(display: "sec⁻¹", insertion: "asec(", category: "inv", description: "Arcsecant"),
            KeyboardButton(display: "cot⁻¹", insertion: "acot(", category: "inv", description: "Arccotangent"),
            KeyboardButton(display: "°", insertion: "*(π/180)", category: "conv", description: "Degrees to radians"),
            KeyboardButton(display: "ʳ", insertion: "*(180/π)", category: "conv", description: "Radians to degrees"),
            KeyboardButton(display: "ᵍ", insertion: "*(π/200)", category: "conv", description: "Gradians to radians")
        ]
    }
    
    private var hyperbolicButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "sinh", insertion: "sinh(", category: "basic", description: "Hyperbolic sine"),
            KeyboardButton(display: "cosh", insertion: "cosh(", category: "basic", description: "Hyperbolic cosine"),
            KeyboardButton(display: "tanh", insertion: "tanh(", category: "basic", description: "Hyperbolic tangent"),
            KeyboardButton(display: "csch", insertion: "csch(", category: "recip", description: "Hyperbolic cosecant"),
            KeyboardButton(display: "sech", insertion: "sech(", category: "recip", description: "Hyperbolic secant"),
            
            KeyboardButton(display: "coth", insertion: "coth(", category: "recip", description: "Hyperbolic cotangent"),
            KeyboardButton(display: "sinh⁻¹", insertion: "asinh(", category: "inv", description: "Inverse hyperbolic sine"),
            KeyboardButton(display: "cosh⁻¹", insertion: "acosh(", category: "inv", description: "Inverse hyperbolic cosine"),
            KeyboardButton(display: "tanh⁻¹", insertion: "atanh(", category: "inv", description: "Inverse hyperbolic tangent"),
            KeyboardButton(display: "csch⁻¹", insertion: "acsch(", category: "inv", description: "Inverse hyperbolic cosecant"),
            
            KeyboardButton(display: "sech⁻¹", insertion: "asech(", category: "inv", description: "Inverse hyperbolic secant"),
            KeyboardButton(display: "coth⁻¹", insertion: "acoth(", category: "inv", description: "Inverse hyperbolic cotangent"),
            KeyboardButton(display: "e^x", insertion: "exp(", category: "exp"),
            KeyboardButton(display: "e^(-x)", insertion: "exp(-", category: "exp"),
            KeyboardButton(display: "(e^x+e^(-x))/2", insertion: "cosh(", category: "def", isWide: true)
        ]
    }
    
    private var logarithmicButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "ln", insertion: "ln(", category: "nat", description: "Natural logarithm"),
            KeyboardButton(display: "log", insertion: "log10(", category: "10", description: "Common logarithm"),
            KeyboardButton(display: "log₂", insertion: "log2(", category: "2", description: "Binary logarithm"),
            KeyboardButton(display: "logₓ", insertion: "logbase(", category: "x", description: "Logarithm with custom base"),
            KeyboardButton(display: "exp", insertion: "exp(", category: "e", description: "e^x"),
            KeyboardButton(display: "10ˣ", insertion: "exp10(", category: "10", description: "10^x"),
            
            KeyboardButton(display: "2ˣ", insertion: "exp2(", category: "2", description: "2^x"),
            KeyboardButton(display: "xʸ", insertion: "^", category: "pow", description: "Power"),
            KeyboardButton(display: "√x", insertion: "sqrt(", category: "root", description: "Square root"),
            KeyboardButton(display: "∛x", insertion: "cbrt(", category: "root", description: "Cube root"),
            KeyboardButton(display: "ⁿ√x", insertion: "nthroot(", category: "root", description: "nth root"),
            KeyboardButton(display: "x^(1/n)", insertion: "^(1/", category: "pow", description: "Fractional power")
        ]
    }
    
    private var statisticsButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "∑", insertion: "sum(", category: "seq", description: "Summation"),
            KeyboardButton(display: "∏", insertion: "product(", category: "seq", description: "Product"),
            KeyboardButton(display: "μ", insertion: "mean(", category: "avg", description: "Mean"),
            KeyboardButton(display: "σ", insertion: "stdev(", category: "spread", description: "Standard deviation"),
            KeyboardButton(display: "σ²", insertion: "variance(", category: "spread", description: "Variance"),
            KeyboardButton(display: "med", insertion: "median(", category: "avg", description: "Median"),
            
            KeyboardButton(display: "min", insertion: "min(", category: "range"),
            KeyboardButton(display: "max", insertion: "max(", category: "range"),
            KeyboardButton(display: "range", insertion: "range(", category: "range", description: "Range"),
            KeyboardButton(display: "mode", insertion: "mode(", category: "avg", description: "Mode"),
            KeyboardButton(display: "rand", insertion: "random()", category: "prob", description: "Random [0,1]"),
            KeyboardButton(display: "norm", insertion: "normal(", category: "dist", description: "Normal distribution"),
            
            KeyboardButton(display: "binom", insertion: "binomial(", category: "comb", description: "Binomial coefficient"),
            KeyboardButton(display: "perm", insertion: "permutation(", category: "comb", description: "Permutation"),
            KeyboardButton(display: "fact", insertion: "factorial(", category: "comb", description: "Factorial"),
            KeyboardButton(display: "gamma", insertion: "gamma(", category: "spec", description: "Gamma function"),
            KeyboardButton(display: "beta", insertion: "beta(", category: "spec", description: "Beta function"),
            KeyboardButton(display: "erf", insertion: "erf(", category: "spec", description: "Error function")
        ]
    }
    
    private var constantsButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "π\n3.14159", insertion: "π", category: "math", description: "Pi", color: .blue),
            KeyboardButton(display: "e\n2.71828", insertion: "e", category: "math", description: "Euler's number", color: .blue),
            KeyboardButton(display: "φ\n1.61803", insertion: "φ", category: "math", description: "Golden ratio", color: .blue),
            KeyboardButton(display: "γ\n0.57722", insertion: "γ", category: "math", description: "Euler-Mascheroni constant", color: .blue),
            
            KeyboardButton(display: "c\n2.998×10⁸", insertion: "c", category: "phys", description: "Speed of light", color: .green),
            KeyboardButton(display: "h\n6.626×10⁻³⁴", insertion: "h", category: "phys", description: "Planck constant", color: .green),
            KeyboardButton(display: "k\n1.381×10⁻²³", insertion: "k", category: "phys", description: "Boltzmann constant", color: .green),
            KeyboardButton(display: "G\n6.674×10⁻¹¹", insertion: "G", category: "phys", description: "Gravitational constant", color: .green),
            
            KeyboardButton(display: "ε₀\n8.854×10⁻¹²", insertion: "ε₀", category: "phys", description: "Vacuum permittivity", color: .green),
            KeyboardButton(display: "μ₀\n1.257×10⁻⁶", insertion: "μ₀", category: "phys", description: "Vacuum permeability", color: .green),
            KeyboardButton(display: "α\n7.297×10⁻³", insertion: "α", category: "phys", description: "Fine structure constant", color: .green),
            KeyboardButton(display: "R\n8.314", insertion: "R", category: "phys", description: "Universal gas constant", color: .green)
        ]
    }
    
    private var numberBasesButtons: [KeyboardButton] {
        [
            KeyboardButton(display: "0b", insertion: "0b", category: "bin", description: "Binary prefix"),
            KeyboardButton(display: "0o", insertion: "0o", category: "oct", description: "Octal prefix"),
            KeyboardButton(display: "0x", insertion: "0x", category: "hex", description: "Hexadecimal prefix"),
            KeyboardButton(display: "A", insertion: "A", category: "hex"),
            KeyboardButton(display: "B", insertion: "B", category: "hex"),
            KeyboardButton(display: "C", insertion: "C", category: "hex"),
            KeyboardButton(display: "D", insertion: "D", category: "hex"),
            KeyboardButton(display: "E", insertion: "E", category: "hex"),
            
            KeyboardButton(display: "F", insertion: "F", category: "hex"),
            KeyboardButton(display: "bin", insertion: "bin(", category: "conv", description: "Convert to binary"),
            KeyboardButton(display: "oct", insertion: "oct(", category: "conv", description: "Convert to octal"),
            KeyboardButton(display: "hex", insertion: "hex(", category: "conv", description: "Convert to hexadecimal"),
            KeyboardButton(display: "dec", insertion: "dec(", category: "conv", description: "Convert to decimal"),
            KeyboardButton(display: "AND", insertion: "&", category: "bit", description: "Bitwise AND"),
            KeyboardButton(display: "OR", insertion: "|", category: "bit", description: "Bitwise OR"),
            KeyboardButton(display: "XOR", insertion: "^", category: "bit", description: "Bitwise XOR"),
            
            KeyboardButton(display: "NOT", insertion: "~", category: "bit", description: "Bitwise NOT"),
            KeyboardButton(display: "<<", insertion: "<<", category: "bit", description: "Left shift"),
            KeyboardButton(display: ">>", insertion: ">>", category: "bit", description: "Right shift"),
            KeyboardButton(display: "mod", insertion: "%", category: "math", description: "Modulo"),
            KeyboardButton(display: "div", insertion: "//", category: "math", description: "Integer division"),
            KeyboardButton(display: "rem", insertion: "rem(", category: "math", description: "Remainder"),
            KeyboardButton(display: "gcd", insertion: "gcd(", category: "num", description: "Greatest common divisor"),
            KeyboardButton(display: "lcm", insertion: "lcm(", category: "num", description: "Least common multiple")
        ]
    }
}

// MARK: - Function Detail View

struct FunctionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let function: CustomScientificKeyboard.KeyboardButton
    let onUse: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text(function.display)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(function.color)
                    
                    Text(function.description)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    if !function.category.isEmpty {
                        Text("Category: \(function.category)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Usage:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(function.insertion)
                        .font(.system(.title2, design: .monospaced))
                        .padding(12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                HStack {
                    Button("Use Function") {
                        onUse(function.insertion)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Copy") {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(function.insertion, forType: .string)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
            .padding(24)
            .navigationTitle("Function Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 400, height: 350)
    }
}

#Preview {
    CustomScientificKeyboard { insertion in
        print("Pressed: \(insertion)")
    }
    .frame(height: 400)
    .padding()
}
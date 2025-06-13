//
//  Input Validation Test
//  A simple test to verify the input validation system works
//

import SwiftUI

struct InputValidationTestView: View {
    @State private var currencyValue: Double = 1000
    @State private var percentageValue: Double = 5.5
    @State private var integerValue: Int = 30
    @State private var testString: String = "123.45"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Input Validation System Test")
                .font(.title)
                .padding()
            
            EnhancedCurrencyInputField(
                title: "Test Currency Input",
                subtitle: "Testing currency validation",
                value: $currencyValue,
                currency: .usd,
                isRequired: true,
                helpText: "Test currency input with validation",
                minValue: 0,
                maxValue: 1_000_000
            )
            
            EnhancedPercentageInputField(
                title: "Test Percentage Input",
                subtitle: "Testing percentage validation",
                value: $percentageValue,
                isRequired: true,
                helpText: "Test percentage input with validation",
                maxValue: 100,
                minValue: 0
            )
            
            EnhancedIntegerInputField(
                title: "Test Integer Input",
                subtitle: "Testing integer validation",
                value: $integerValue,
                isRequired: true,
                helpText: "Test integer input with validation",
                maxValue: 100,
                minValue: 1
            )
            
            TextField("Test Numbers Only", text: $testString)
                .textFieldStyle(.roundedBorder)
                .numbersOnly(
                    text: $testString,
                    maxValue: 999.99,
                    minValue: 0,
                    maxDecimalPlaces: 2
                )
            
            VStack {
                Text("Current Values:")
                Text("Currency: \(currencyValue, format: .currency(code: "USD"))")
                Text("Percentage: \(percentageValue, format: .number.precision(.fractionLength(3)))%")
                Text("Integer: \(integerValue)")
                Text("Test String: \(testString)")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    InputValidationTestView()
        .frame(width: 500, height: 700)
}
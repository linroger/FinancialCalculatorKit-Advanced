import SwiftUI

struct CurrencyConverterView: View {
    @State private var amount: String = "1"
    @State private var fromCurrency: String = "USD"
    @State private var toCurrency: String = "EUR"
    @State private var result: String?
    @State private var loading = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("From", text: $fromCurrency)
                    .frame(width: 60)
                Text("→")
                TextField("To", text: $toCurrency)
                    .frame(width: 60)
                Button("Convert") { Task { await convert() } }
                    .disabled(loading)
            }
            .padding()
            if loading {
                ProgressView().padding()
            } else if let result {
                Text(result).padding()
            }
            Spacer()
        }
        .navigationTitle("Currency Converter")
    }

    private func convert() async {
        guard let amt = Double(amount) else { return }
        loading = true
        defer { loading = false }
        do {
            let rate = try await CurrencyConversionService.fetchRate(from: fromCurrency, to: toCurrency)
            let converted = amt * rate.rate
            result = String(format: "%.2f %@", converted, toCurrency)
        } catch {
            result = "Conversion failed"
        }
    }
}

#Preview {
    CurrencyConverterView()
}

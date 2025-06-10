import SwiftUI
import Charts
import UniformTypeIdentifiers

struct FutureValueRow: Identifiable {
    let id = UUID()
    let period: Int
    let value: Double
}

struct FutureValueView: View {
    @State private var presentValue: String = "1000"
    @State private var interestRate: String = "0.05" // 5%
    @State private var periods: String = "10"
    @State private var history: [FutureValueRow] = []

    var body: some View {
        VStack(alignment: .leading) {
            Form {
                HStack {
                    TextField("Present Value", text: $presentValue)
                        .help("Initial amount of money")
                    TextField("Interest Rate", text: $interestRate)
                        .help("Interest rate per period (e.g. 0.05 for 5%)")
                    TextField("Periods", text: $periods)
                        .help("Number of periods (years)")
                    Button("Calculate") { calculate() }
                        .help("Calculate future value")
                }
            }
            if !history.isEmpty {
                Text("Future Value: \(history.last!.value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    .padding(.horizontal)

                Chart(history) { item in
                    LineMark(
                        x: .value("Period", item.period),
                        y: .value("Value", item.value)
                    )
                }
                .frame(height: 200)
                .padding(.horizontal)

                Table(history) {
                    TableColumn("Period") { item in Text("\(item.period)") }
                    TableColumn("Value") { item in Text(item.value, format: .currency(code: Locale.current.currency?.identifier ?? "USD")) }
                }
                .frame(maxHeight: 200)
                .padding(.horizontal)

                Button("Export CSV") { exportCSV() }
                    .padding(.horizontal)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Future Value")
    }

    private func calculate() {
        guard
            let pv = Double(presentValue),
            let r = Double(interestRate),
            let n = Int(periods)
        else { return }
        let series = FinancialCalculator.futureValueSeries(presentValue: pv, interestRate: r, periods: n)
        history = series.map { FutureValueRow(period: $0.period, value: $0.value) }
    }

    private func exportCSV() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.commaSeparatedText]
        panel.begin { response in
            if response == .OK, let url = panel.url {
                let rows = history.map { ["\($0.period)", String(format: "%.2f", $0.value)] }
                try? CSVHelper.export(rows: [["Period", "Value"]] + rows, to: url)
            }
        }
    }
}

#Preview {
    FutureValueView()
}

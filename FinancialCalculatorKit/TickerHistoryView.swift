import SwiftUI
import Charts

struct TickerHistoryView: View {
    @State private var symbol: String = "AAPL"
    @State private var prices: [TickerPrice] = []
    @State private var loading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Ticker", text: $symbol)
                    .help("US ticker symbol, e.g. AAPL")
                Button("Load") { Task { await load() } }
                    .disabled(loading)
            }
            .padding()
            if loading {
                ProgressView().padding()
            } else if let message = errorMessage {
                Text(message).foregroundColor(.red).padding()
            } else if !prices.isEmpty {
                Chart(prices) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Close", $0.close)
                    )
                }
                .frame(height: 200)
                .padding()

                Table(prices) {
                    TableColumn("Date") { Text($0.date, format: .dateTime.year().month().day()) }
                    TableColumn("Close") { Text($0.close, format: .currency(code: Locale.current.currency?.identifier ?? "USD")) }
                }
                .frame(maxHeight: 300)
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Ticker History")
    }

    private func load() async {
        loading = true
        defer { loading = false }
        do {
            prices = try await TickerHistoryService.fetchDailyHistory(for: symbol)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load history"
            prices = []
        }
    }
}

#Preview {
    TickerHistoryView()
}

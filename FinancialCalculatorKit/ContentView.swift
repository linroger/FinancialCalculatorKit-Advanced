import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                FutureValueView()
                    .tabItem { Label("Future Value", systemImage: "chart.line.uptrend.xyaxis") }
                TickerHistoryView()
                    .tabItem { Label("Ticker", systemImage: "chart.xyaxis.line") }
                CurrencyConverterView()
                    .tabItem { Label("Converter", systemImage: "dollarsign.circle") }
            }
            .frame(minWidth: 700, minHeight: 500)
        }
    }
}

#Preview {
    ContentView()
}

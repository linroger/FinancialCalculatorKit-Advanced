import Foundation

struct TickerPrice: Identifiable {
    let id = UUID()
    let date: Date
    let close: Double
}

enum TickerServiceError: Error {
    case invalidResponse
}

struct TickerHistoryService {
    static func fetchDailyHistory(for symbol: String) async throws -> [TickerPrice] {
        let urlString = "https://stooq.com/q/d/l/?s=\(symbol.lowercased()).us&i=d"
        guard let url = URL(string: urlString) else { throw TickerServiceError.invalidResponse }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let csv = String(data: data, encoding: .utf8) else { throw TickerServiceError.invalidResponse }

        var prices: [TickerPrice] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lines = csv.split(separator: "\n")
        for line in lines.dropFirst() {
            let parts = line.split(separator: ",")
            if parts.count >= 5, let date = dateFormatter.date(from: String(parts[0])), let close = Double(parts[4]) {
                prices.append(TickerPrice(date: date, close: close))
            }
        }
        return prices.sorted { $0.date < $1.date }
    }
}

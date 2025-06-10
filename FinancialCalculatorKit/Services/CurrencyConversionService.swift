import Foundation

struct CurrencyRate {
    let currency: String
    let rate: Double
}

enum CurrencyServiceError: Error {
    case invalidResponse
}

struct CurrencyConversionService {
    static func fetchRate(from: String, to: String) async throws -> CurrencyRate {
        let urlString = "https://api.exchangerate.host/latest?base=\(from)&symbols=\(to)"
        guard let url = URL(string: urlString) else { throw CurrencyServiceError.invalidResponse }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard
            let rates = json?["rates"] as? [String: Double],
            let rate = rates[to]
        else { throw CurrencyServiceError.invalidResponse }
        return CurrencyRate(currency: to, rate: rate)
    }
}

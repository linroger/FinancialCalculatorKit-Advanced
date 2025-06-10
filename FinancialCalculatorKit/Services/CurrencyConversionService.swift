import Foundation

// MARK: - Enhanced Currency Models

struct CurrencyRate: Codable {
    let fromCurrency: String
    let toCurrency: String
    let rate: Double
    let timestamp: Date
    let source: ExchangeRateSource
    let bid: Double?
    let ask: Double?
    let spread: Double?
    
    init(fromCurrency: String, toCurrency: String, rate: Double, timestamp: Date = Date(), source: ExchangeRateSource = .exchangeRateHost, bid: Double? = nil, ask: Double? = nil) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.rate = rate
        self.timestamp = timestamp
        self.source = source
        self.bid = bid
        self.ask = ask
        self.spread = (bid != nil && ask != nil) ? ask! - bid! : nil
    }
    
    var isExpired: Bool {
        let expirationInterval: TimeInterval = 300 // 5 minutes
        return Date().timeIntervalSince(timestamp) > expirationInterval
    }
    
    var age: TimeInterval {
        return Date().timeIntervalSince(timestamp)
    }
}

struct HistoricalRate: Codable {
    let date: Date
    let rate: Double
    let fromCurrency: String
    let toCurrency: String
}

struct CurrencyVolatility {
    let currency: String
    let baseCurrency: String
    let dailyVolatility: Double
    let weeklyVolatility: Double
    let monthlyVolatility: Double
    let annualizedVolatility: Double
    let calculationPeriodDays: Int
}

enum ExchangeRateSource: String, CaseIterable, Codable {
    case exchangeRateHost = "exchangerate-host"
    case openExchangeRates = "openexchangerates"
    case fixer = "fixer"
    case currencyLayer = "currencylayer"
    case ecb = "european-central-bank"
    case federalReserve = "federal-reserve"
    case cached = "cached"
    case fallback = "fallback"
    
    var displayName: String {
        switch self {
        case .exchangeRateHost: return "ExchangeRate-API"
        case .openExchangeRates: return "Open Exchange Rates"
        case .fixer: return "Fixer.io"
        case .currencyLayer: return "CurrencyLayer"
        case .ecb: return "European Central Bank"
        case .federalReserve: return "Federal Reserve"
        case .cached: return "Cached Data"
        case .fallback: return "Fallback Rate"
        }
    }
    
    var reliability: Double {
        switch self {
        case .ecb, .federalReserve: return 0.95
        case .openExchangeRates, .fixer: return 0.90
        case .currencyLayer, .exchangeRateHost: return 0.85
        case .cached: return 0.80
        case .fallback: return 0.60
        }
    }
}

enum CurrencyServiceError: Error, LocalizedError {
    case invalidResponse
    case networkError(Error)
    case apiKeyRequired
    case rateLimitExceeded
    case currencyNotSupported(String)
    case historicalDataNotAvailable
    case cacheError
    case invalidDateRange
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from currency service"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .apiKeyRequired:
            return "API key required for this service"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later"
        case .currencyNotSupported(let currency):
            return "Currency '\(currency)' is not supported"
        case .historicalDataNotAvailable:
            return "Historical data is not available for this request"
        case .cacheError:
            return "Error accessing currency rate cache"
        case .invalidDateRange:
            return "Invalid date range specified"
        }
    }
}

// MARK: - Enhanced Currency Conversion Service

actor CurrencyConversionService {
    static let shared = CurrencyConversionService()
    
    private var rateCache: [String: CurrencyRate] = [:]
    private var historicalCache: [String: [HistoricalRate]] = [:]
    private let session = URLSession.shared
    private let maxCacheAge: TimeInterval = 300 // 5 minutes
    private let maxHistoricalCacheAge: TimeInterval = 86400 // 24 hours
    
    // Configuration
    private var primarySource: ExchangeRateSource = .exchangeRateHost
    private var fallbackSources: [ExchangeRateSource] = [.openExchangeRates, .fixer]
    private var apiKeys: [ExchangeRateSource: String] = [:]
    
    private init() {}
    
    // MARK: - Configuration Methods
    
    func configure(primarySource: ExchangeRateSource, fallbackSources: [ExchangeRateSource] = [], apiKeys: [ExchangeRateSource: String] = [:]) {
        self.primarySource = primarySource
        self.fallbackSources = fallbackSources
        self.apiKeys = apiKeys
    }
    
    // MARK: - Real-time Exchange Rates
    
    func fetchRate(from: String, to: String, source: ExchangeRateSource? = nil) async throws -> CurrencyRate {
        let cacheKey = "\(from)-\(to)"
        
        // Check cache first
        if let cachedRate = rateCache[cacheKey], !cachedRate.isExpired {
            return cachedRate
        }
        
        let sourceToUse = source ?? primarySource
        
        do {
            let rate = try await fetchRateFromSource(from: from, to: to, source: sourceToUse)
            rateCache[cacheKey] = rate
            return rate
        } catch {
            // Try fallback sources
            for fallbackSource in fallbackSources {
                do {
                    let rate = try await fetchRateFromSource(from: from, to: to, source: fallbackSource)
                    rateCache[cacheKey] = rate
                    return rate
                } catch {
                    continue
                }
            }
            
            // Use cached rate if available, even if expired
            if let cachedRate = rateCache[cacheKey] {
                return cachedRate
            }
            
            throw error
        }
    }
    
    private func fetchRateFromSource(from: String, to: String, source: ExchangeRateSource) async throws -> CurrencyRate {
        switch source {
        case .exchangeRateHost:
            return try await fetchFromExchangeRateHost(from: from, to: to)
        case .openExchangeRates:
            return try await fetchFromOpenExchangeRates(from: from, to: to)
        case .fixer:
            return try await fetchFromFixer(from: from, to: to)
        case .ecb:
            return try await fetchFromECB(from: from, to: to)
        default:
            throw CurrencyServiceError.currencyNotSupported("Source \(source) not implemented")
        }
    }
    
    private func fetchFromExchangeRateHost(from: String, to: String) async throws -> CurrencyRate {
        let urlString = "https://api.exchangerate.host/latest?base=\(from)&symbols=\(to)"
        guard let url = URL(string: urlString) else {
            throw CurrencyServiceError.invalidResponse
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let rates = json?["rates"] as? [String: Double],
                  let rate = rates[to] else {
                throw CurrencyServiceError.invalidResponse
            }
            
            return CurrencyRate(
                fromCurrency: from,
                toCurrency: to,
                rate: rate,
                source: .exchangeRateHost
            )
        } catch {
            throw CurrencyServiceError.networkError(error)
        }
    }
    
    private func fetchFromOpenExchangeRates(from: String, to: String) async throws -> CurrencyRate {
        guard let apiKey = apiKeys[.openExchangeRates] else {
            throw CurrencyServiceError.apiKeyRequired
        }
        
        let urlString = "https://openexchangerates.org/api/latest.json?app_id=\(apiKey)&base=\(from)&symbols=\(to)"
        guard let url = URL(string: urlString) else {
            throw CurrencyServiceError.invalidResponse
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let rates = json?["rates"] as? [String: Double],
                  let rate = rates[to] else {
                throw CurrencyServiceError.invalidResponse
            }
            
            return CurrencyRate(
                fromCurrency: from,
                toCurrency: to,
                rate: rate,
                source: .openExchangeRates
            )
        } catch {
            throw CurrencyServiceError.networkError(error)
        }
    }
    
    private func fetchFromFixer(from: String, to: String) async throws -> CurrencyRate {
        guard let apiKey = apiKeys[.fixer] else {
            throw CurrencyServiceError.apiKeyRequired
        }
        
        let urlString = "http://data.fixer.io/api/latest?access_key=\(apiKey)&base=\(from)&symbols=\(to)"
        guard let url = URL(string: urlString) else {
            throw CurrencyServiceError.invalidResponse
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let rates = json?["rates"] as? [String: Double],
                  let rate = rates[to] else {
                throw CurrencyServiceError.invalidResponse
            }
            
            return CurrencyRate(
                fromCurrency: from,
                toCurrency: to,
                rate: rate,
                source: .fixer
            )
        } catch {
            throw CurrencyServiceError.networkError(error)
        }
    }
    
    private func fetchFromECB(from: String, to: String) async throws -> CurrencyRate {
        // European Central Bank rates (EUR base only)
        guard from == "EUR" || to == "EUR" else {
            throw CurrencyServiceError.currencyNotSupported("ECB only supports EUR-based conversions")
        }
        
        let urlString = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
        guard let url = URL(string: urlString) else {
            throw CurrencyServiceError.invalidResponse
        }
        
        // This would require XML parsing in a real implementation
        // For now, fallback to other sources
        throw CurrencyServiceError.currencyNotSupported("ECB XML parsing not implemented")
    }
    
    // MARK: - Historical Exchange Rates
    
    func fetchHistoricalRates(from: String, to: String, startDate: Date, endDate: Date) async throws -> [HistoricalRate] {
        guard startDate <= endDate else {
            throw CurrencyServiceError.invalidDateRange
        }
        
        let cacheKey = "\(from)-\(to)-\(startDate.timeIntervalSince1970)-\(endDate.timeIntervalSince1970)"
        
        // Check cache
        if let cachedRates = historicalCache[cacheKey] {
            return cachedRates
        }
        
        do {
            let rates = try await fetchHistoricalRatesFromSource(from: from, to: to, startDate: startDate, endDate: endDate)
            historicalCache[cacheKey] = rates
            return rates
        } catch {
            throw error
        }
    }
    
    private func fetchHistoricalRatesFromSource(from: String, to: String, startDate: Date, endDate: Date) async throws -> [HistoricalRate] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        let urlString = "https://api.exchangerate.host/timeseries?start_date=\(startDateString)&end_date=\(endDateString)&base=\(from)&symbols=\(to)"
        guard let url = URL(string: urlString) else {
            throw CurrencyServiceError.invalidResponse
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let rates = json?["rates"] as? [String: [String: Double]] else {
                throw CurrencyServiceError.invalidResponse
            }
            
            var historicalRates: [HistoricalRate] = []
            
            for (dateString, dayRates) in rates {
                if let rate = dayRates[to], let date = formatter.date(from: dateString) {
                    historicalRates.append(HistoricalRate(
                        date: date,
                        rate: rate,
                        fromCurrency: from,
                        toCurrency: to
                    ))
                }
            }
            
            return historicalRates.sorted { $0.date < $1.date }
        } catch {
            throw CurrencyServiceError.networkError(error)
        }
    }
    
    // MARK: - Currency Analysis and Risk Metrics
    
    func calculateCurrencyVolatility(from: String, to: String, days: Int = 30) async throws -> CurrencyVolatility {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate) ?? endDate
        
        let historicalRates = try await fetchHistoricalRates(from: from, to: to, startDate: startDate, endDate: endDate)
        
        guard historicalRates.count > 1 else {
            throw CurrencyServiceError.historicalDataNotAvailable
        }
        
        // Calculate daily returns
        var dailyReturns: [Double] = []
        for i in 1..<historicalRates.count {
            let previousRate = historicalRates[i-1].rate
            let currentRate = historicalRates[i].rate
            let return_ = log(currentRate / previousRate)
            dailyReturns.append(return_)
        }
        
        // Calculate volatilities
        let dailyVol = calculateStandardDeviation(dailyReturns)
        let weeklyVol = dailyVol * sqrt(7)
        let monthlyVol = dailyVol * sqrt(30)
        let annualizedVol = dailyVol * sqrt(252) // 252 trading days per year
        
        return CurrencyVolatility(
            currency: to,
            baseCurrency: from,
            dailyVolatility: dailyVol,
            weeklyVolatility: weeklyVol,
            monthlyVolatility: monthlyVol,
            annualizedVolatility: annualizedVol,
            calculationPeriodDays: days
        )
    }
    
    func calculateCurrencyCorrelation(currency1: String, currency2: String, baseCurrency: String = "USD", days: Int = 30) async throws -> Double {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate) ?? endDate
        
        async let rates1 = fetchHistoricalRates(from: baseCurrency, to: currency1, startDate: startDate, endDate: endDate)
        async let rates2 = fetchHistoricalRates(from: baseCurrency, to: currency2, startDate: startDate, endDate: endDate)
        
        let historicalRates1 = try await rates1
        let historicalRates2 = try await rates2
        
        // Align dates and calculate returns
        let returns1 = calculateReturns(historicalRates1)
        let returns2 = calculateReturns(historicalRates2)
        
        guard returns1.count == returns2.count && returns1.count > 1 else {
            throw CurrencyServiceError.historicalDataNotAvailable
        }
        
        return calculateCorrelation(returns1, returns2)
    }
    
    // MARK: - Multiple Currency Operations
    
    func convertAmount(_ amount: Double, from: String, to: String) async throws -> Double {
        let rate = try await fetchRate(from: from, to: to)
        return amount * rate.rate
    }
    
    func convertToMultipleCurrencies(_ amount: Double, from: String, to currencies: [String]) async throws -> [String: Double] {
        var results: [String: Double] = [:]
        
        // Use TaskGroup for concurrent fetching
        await withTaskGroup(of: (String, Result<Double, Error>).self) { group in
            for currency in currencies {
                group.addTask {
                    do {
                        let convertedAmount = try await self.convertAmount(amount, from: from, to: currency)
                        return (currency, .success(convertedAmount))
                    } catch {
                        return (currency, .failure(error))
                    }
                }
            }
            
            for await (currency, result) in group {
                switch result {
                case .success(let amount):
                    results[currency] = amount
                case .failure:
                    // Skip failed conversions
                    continue
                }
            }
        }
        
        return results
    }
    
    // MARK: - Cache Management
    
    func clearCache() {
        rateCache.removeAll()
        historicalCache.removeAll()
    }
    
    func clearExpiredCache() {
        rateCache = rateCache.filter { !$0.value.isExpired }
    }
    
    func getCacheStatus() -> (count: Int, oldestAge: TimeInterval, newestAge: TimeInterval) {
        let ages = rateCache.values.map { $0.age }
        return (
            count: rateCache.count,
            oldestAge: ages.max() ?? 0,
            newestAge: ages.min() ?? 0
        )
    }
    
    // MARK: - Helper Functions
    
    private func calculateStandardDeviation(_ values: [Double]) -> Double {
        guard values.count > 1 else { return 0 }
        let mean = values.reduce(0, +) / Double(values.count)
        let variance = values.map { pow($0 - mean, 2) }.reduce(0, +) / Double(values.count - 1)
        return sqrt(variance)
    }
    
    private func calculateReturns(_ rates: [HistoricalRate]) -> [Double] {
        guard rates.count > 1 else { return [] }
        
        var returns: [Double] = []
        for i in 1..<rates.count {
            let previousRate = rates[i-1].rate
            let currentRate = rates[i].rate
            let return_ = log(currentRate / previousRate)
            returns.append(return_)
        }
        return returns
    }
    
    private func calculateCorrelation(_ x: [Double], _ y: [Double]) -> Double {
        guard x.count == y.count && x.count > 1 else { return 0 }
        
        let n = Double(x.count)
        let meanX = x.reduce(0, +) / n
        let meanY = y.reduce(0, +) / n
        
        let numerator = zip(x, y).map { ($0 - meanX) * ($1 - meanY) }.reduce(0, +)
        let denomX = x.map { pow($0 - meanX, 2) }.reduce(0, +)
        let denomY = y.map { pow($0 - meanY, 2) }.reduce(0, +)
        let denominator = sqrt(denomX * denomY)
        return denominator != 0 ? numerator / denominator : 0
    }
}

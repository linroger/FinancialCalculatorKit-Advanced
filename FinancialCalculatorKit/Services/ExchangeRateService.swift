//
//  ExchangeRateService.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation

/// Service for fetching real-time exchange rates
class ExchangeRateService {
    private let apiKey = "demo-key" // In a real app, this would be from configuration or environment variables
    private let baseURL = "https://api.exchangerate-api.com/v4/latest"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    enum ExchangeRateError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError(Error)
        case apiError(String)
        case networkError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid API URL"
            case .noData:
                return "No data received from exchange rate service"
            case .decodingError(let error):
                return "Failed to decode exchange rate data: \(error.localizedDescription)"
            case .apiError(let message):
                return "Exchange rate API error: \(message)"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    /// Fetch exchange rates for major currencies
    func fetchExchangeRates() async throws -> [String: [String: Double]] {
        // For this implementation, we'll use a free API service
        // In production, you'd want to use a more reliable paid service
        
        let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY"]
        var allRates: [String: [String: Double]] = [:]
        
        // Fetch rates for each base currency
        for baseCurrency in currencies {
            do {
                let rates = try await fetchRatesForBaseCurrency(baseCurrency)
                allRates[baseCurrency] = rates
            } catch {
                print("Failed to fetch rates for \(baseCurrency): \(error)")
                // Continue with other currencies
            }
        }
        
        // If we got some rates, fill in missing ones using cross-calculations
        if !allRates.isEmpty {
            return fillMissingRates(allRates)
        } else {
            throw ExchangeRateError.apiError("Failed to fetch any exchange rates")
        }
    }
    
    /// Fetch exchange rates for a specific base currency
    private func fetchRatesForBaseCurrency(_ baseCurrency: String) async throws -> [String: Double] {
        // Use a free exchange rate API (like exchangerate-api.com)
        guard let url = URL(string: "\(baseURL)/\(baseCurrency)") else {
            throw ExchangeRateError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ExchangeRateError.networkError(URLError(.badServerResponse))
            }
            
            guard httpResponse.statusCode == 200 else {
                throw ExchangeRateError.apiError("HTTP \(httpResponse.statusCode)")
            }
            
            let exchangeRateResponse = try decoder.decode(ExchangeRateResponse.self, from: data)
            
            // Filter to only the currencies we care about
            let filteredRates = exchangeRateResponse.rates.filter { key, _ in
                ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY"].contains(key)
            }
            
            return filteredRates
            
        } catch let decodingError as DecodingError {
            throw ExchangeRateError.decodingError(decodingError)
        } catch {
            throw ExchangeRateError.networkError(error)
        }
    }
    
    /// Fill in missing exchange rates using cross-calculations
    private func fillMissingRates(_ rates: [String: [String: Double]]) -> [String: [String: Double]] {
        var filledRates = rates
        let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY"]
        
        for fromCurrency in currencies {
            if filledRates[fromCurrency] == nil {
                filledRates[fromCurrency] = [:]
            }
            
            for toCurrency in currencies {
                if fromCurrency == toCurrency {
                    filledRates[fromCurrency]![toCurrency] = 1.0
                    continue
                }
                
                // If we don't have a direct rate, try to calculate it
                if filledRates[fromCurrency]![toCurrency] == nil {
                    // Try to find it through USD
                    if let fromToUSD = filledRates[fromCurrency]?["USD"],
                       let usdToTarget = filledRates["USD"]?[toCurrency] {
                        filledRates[fromCurrency]![toCurrency] = fromToUSD * usdToTarget
                    }
                    // Try the inverse
                    else if let inverse = filledRates[toCurrency]?[fromCurrency] {
                        filledRates[fromCurrency]![toCurrency] = 1.0 / inverse
                    }
                }
            }
        }
        
        return filledRates
    }
}

/// Response structure for exchange rate API
private struct ExchangeRateResponse: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}
//
//  FREDService.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/11/25.
//

import Foundation

/// Service for interacting with the FRED API
@Observable
class FREDService {
    private let apiKey = "e539b90fe610a7550375692c72e66376"
    private let baseURL = "https://api.stlouisfed.org/fred"
    
    var isLoading = false
    var currentError: Error?
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.urlSession = URLSession(configuration: config)
        
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.fredDateFormatter)
    }
    
    // MARK: - Sample Data Methods (for testing)
    
    /// Create sample series data for testing
    func createSampleSeries(id: String) -> FREDSeries {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .year, value: -2, to: Date()) ?? Date()
        
        let observations = (0..<24).compactMap { index -> FREDObservation? in
            guard let date = calendar.date(byAdding: .month, value: index, to: startDate) else { return nil }
            
            let baseValue: Double
            switch id.uppercased() {
            case "GDP":
                baseValue = 20000.0 + Double(index) * 100.0
            case "UNRATE":
                baseValue = 4.0 + sin(Double(index) * 0.3) * 2.0
            case "FEDFUNDS":
                baseValue = 2.0 + Double(index) * 0.1
            case "GS10":
                baseValue = 3.0 + sin(Double(index) * 0.2) * 1.5
            default:
                baseValue = 100.0 + Double(index) * 5.0
            }
            
            let noise = Double.random(in: -baseValue*0.05...baseValue*0.05)
            return FREDObservation(date: date, value: baseValue + noise)
        }
        
        var series = FREDSeries(
            id: id,
            title: getTitleForSeries(id),
            description: getDescriptionForSeries(id),
            units: getUnitsForSeries(id),
            frequency: "Monthly"
        )
        series.observations = observations
        
        return series
    }
    
    /// Get display title for series ID
    private func getTitleForSeries(_ id: String) -> String {
        switch id.uppercased() {
        case "GDP":
            return "Gross Domestic Product"
        case "UNRATE":
            return "Unemployment Rate"
        case "FEDFUNDS":
            return "Federal Funds Rate"
        case "GS10":
            return "10-Year Treasury Constant Maturity Rate"
        case "CPIAUCSL":
            return "Consumer Price Index for All Urban Consumers: All Items"
        default:
            return "Economic Data Series \(id)"
        }
    }
    
    /// Get description for series ID
    private func getDescriptionForSeries(_ id: String) -> String {
        switch id.uppercased() {
        case "GDP":
            return "The market value of goods and services produced by labor and property located in the United States"
        case "UNRATE":
            return "The unemployment rate represents the number of unemployed as a percentage of the labor force"
        case "FEDFUNDS":
            return "The federal funds rate is the interest rate at which depository institutions trade federal funds"
        case "GS10":
            return "10-year Treasury bonds are debt obligations issued by the United States Treasury"
        default:
            return "Economic data series from the Federal Reserve Economic Data (FRED) database"
        }
    }
    
    /// Get units for series ID
    private func getUnitsForSeries(_ id: String) -> String {
        switch id.uppercased() {
        case "GDP":
            return "Billions of Dollars"
        case "UNRATE", "FEDFUNDS", "GS10":
            return "Percent"
        case "CPIAUCSL":
            return "Index 1982-84=100"
        default:
            return "Units"
        }
    }
    
    /// Get recommendations for a series
    func getRecommendations(for seriesId: String) -> [String] {
        return FREDCategorySchema.getRecommendations(for: seriesId)
    }
    
    // MARK: - Future API Methods (to be implemented)
    
    /// Fetch series information and observations by ID using the FRED API
    @MainActor
    func fetchSeries(id: String) async throws -> FREDSeries {
        isLoading = true
        defer { isLoading = false }
        
        // First fetch the series metadata
        var components = URLComponents(string: "\(baseURL)/series")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "series_id", value: id),
            URLQueryItem(name: "file_type", value: "json")
        ]
        
        guard let metadataURL = components.url else {
            throw FREDError.invalidURL
        }
        
        do {
            let (metadataData, metadataResponse) = try await urlSession.data(from: metadataURL)
            
            guard let httpResponse = metadataResponse as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw FREDError.seriesNotFound(id)
            }
            
            let metadataResult = try jsonDecoder.decode(FREDSeriesResponse.self, from: metadataData)
            
            guard let seriesInfo = metadataResult.seriess.first else {
                throw FREDError.seriesNotFound(id)
            }
            
            // Now fetch the observations
            var observationsComponents = URLComponents(string: "\(baseURL)/series/observations")!
            observationsComponents.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "series_id", value: id),
                URLQueryItem(name: "file_type", value: "json")
            ]
            
            guard let observationsURL = observationsComponents.url else {
                throw FREDError.invalidURL
            }
            
            let (observationsData, _) = try await urlSession.data(from: observationsURL)
            let observationsResult = try jsonDecoder.decode(FREDObservationsResponse.self, from: observationsData)
            
            // Create the FREDSeries object
            var series = FREDSeries(
                id: seriesInfo.id,
                title: seriesInfo.title,
                description: seriesInfo.notes ?? "",
                units: seriesInfo.units,
                frequency: seriesInfo.frequency
            )
            
            // Convert observations
            series.observations = observationsResult.observations.compactMap { obs in
                guard let date = DateFormatter.fredDateFormatter.date(from: obs.date) else {
                    return nil
                }
                
                let value: Double? = (obs.value == "." || obs.value.isEmpty) ? nil : Double(obs.value)
                return FREDObservation(date: date, value: value)
            }
            
            return series
        } catch {
            currentError = error
            throw error
        }
    }
    
    /// Search for series by text using the FRED API
    @MainActor
    func searchSeries(query: String, limit: Int = 50) async throws -> [FREDSeriesInfo] {
        isLoading = true
        defer { isLoading = false }
        
        // Build the search URL
        var components = URLComponents(string: "\(baseURL)/series/search")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "search_text", value: query),
            URLQueryItem(name: "file_type", value: "json"),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "order_by", value: "popularity"),
            URLQueryItem(name: "sort_order", value: "desc")
        ]
        
        guard let url = components.url else {
            throw FREDError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw FREDError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw FREDError.httpError(httpResponse.statusCode)
            }
            
            let searchResponse = try jsonDecoder.decode(FREDSearchResponse.self, from: data)
            
            return searchResponse.seriess.map { series in
                FREDSeriesInfo(
                    id: series.id,
                    title: series.title,
                    units: series.units,
                    frequency: series.frequency,
                    popularityRank: series.popularity,
                    lastUpdated: series.last_updated,
                    observationStart: series.observation_start,
                    observationEnd: series.observation_end,
                    notes: series.notes ?? ""
                )
            }
        } catch {
            currentError = error
            throw error
        }
    }
    
    /// Get recommendations for a series based on compatible units
    func getRecommendationsBasedOnUnits(for seriesId: String, currentUnits: String) -> [String] {
        
        let normalizedUnits = currentUnits.lowercased()
        var recommendations: [String] = []
        
        // Group series by unit type
        if normalizedUnits.contains("billion") && normalizedUnits.contains("dollar") {
            recommendations = ["GDP", "M2SL", "GFDEBTN", "FYGFD"]
        } else if normalizedUnits.contains("percent") || normalizedUnits == "percent" {
            recommendations = ["UNRATE", "FEDFUNDS", "GS10", "GS2", "TB3MS", "DFEDTARU"]
        } else if normalizedUnits.contains("per capita") || normalizedUnits.contains("dollars") && !normalizedUnits.contains("billion") {
            recommendations = ["A939RX0Q048SBEA", "NYGDPMKTPCDWLD"]
        } else if normalizedUnits.contains("thousand") && normalizedUnits.contains("person") {
            recommendations = ["PAYEMS", "MANEMP"]
        } else if normalizedUnits.contains("index") {
            recommendations = ["CPIAUCSL", "CPILFESL"]
        } else {
            // Default recommendations based on popularity
            recommendations = ["GDP", "UNRATE", "FEDFUNDS", "CPIAUCSL", "PAYEMS"]
        }
        
        // Remove the current series from recommendations
        recommendations.removeAll { $0 == seriesId }
        
        return recommendations
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let fredDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
}

// MARK: - FRED Errors

enum FREDError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case seriesNotFound(String)
    case invalidDateFormat
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .seriesNotFound(let id):
            return "Series '\(id)' not found"
        case .invalidDateFormat:
            return "Invalid date format in response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
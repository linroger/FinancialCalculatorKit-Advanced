//
//  FREDModels.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/11/25.
//

import Foundation

// MARK: - FRED Data Series Models

/// A FRED data series with metadata and observations
struct FREDSeries: Identifiable, Codable {
    let id: String
    let title: String
    let seriesDescription: String
    let units: String
    let frequency: String
    let categoryId: Int
    let popularityRank: Int
    let lastUpdated: Date
    let observationStart: Date
    let observationEnd: Date
    let isSeasonallyAdjusted: Bool
    let notes: String
    
    /// Observations data
    var observations: [FREDObservation] = []
    
    init(
        id: String,
        title: String,
        description: String = "",
        units: String = "",
        frequency: String = "",
        categoryId: Int = 0,
        popularityRank: Int = 0,
        lastUpdated: Date = Date(),
        observationStart: Date = Date(),
        observationEnd: Date = Date(),
        isSeasonallyAdjusted: Bool = false,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.seriesDescription = description
        self.units = units
        self.frequency = frequency
        self.categoryId = categoryId
        self.popularityRank = popularityRank
        self.lastUpdated = lastUpdated
        self.observationStart = observationStart
        self.observationEnd = observationEnd
        self.isSeasonallyAdjusted = isSeasonallyAdjusted
        self.notes = notes
        self.observations = []
    }
}

/// A single observation point for a FRED series
struct FREDObservation: Identifiable, Codable {
    let id: UUID
    let date: Date
    let value: Double?
    
    init(date: Date, value: Double? = nil) {
        self.id = UUID()
        self.date = date
        self.value = value
    }
}

/// FRED category information
struct FREDCategory: Identifiable, Codable {
    let id: Int
    let name: String
    let parentId: Int
    let children: [FREDCategory]
    let seriesCount: Int
    
    init(id: Int, name: String, parentId: Int = 0, children: [FREDCategory] = [], seriesCount: Int = 0) {
        self.id = id
        self.name = name
        self.parentId = parentId
        self.children = children
        self.seriesCount = seriesCount
    }
}

// MARK: - FRED API Response Models

/// Response model for FRED series search API
struct FREDSearchResponse: Codable {
    let realtime_start: String
    let realtime_end: String
    let order_by: String
    let sort_order: String
    let count: Int
    let offset: Int
    let limit: Int
    let seriess: [FREDSeriesData]
}

/// Response model for FRED series API
struct FREDSeriesResponse: Codable {
    let realtime_start: String
    let realtime_end: String
    let seriess: [FREDSeriesData]
}

/// Series data from FRED API (raw from API)
struct FREDSeriesData: Codable {
    let id: String
    let title: String
    let units: String
    let frequency: String
    let frequency_short: String
    let popularity: Int
    let observation_start: String
    let observation_end: String
    let last_updated: String
    let notes: String?
    let seasonal_adjustment: String?
    let seasonal_adjustment_short: String?
}

/// Series information for app use (processed)
struct FREDSeriesInfo: Codable {
    let id: String
    let title: String
    let units: String
    let frequency: String
    let popularityRank: Int
    let lastUpdated: String
    let observationStart: String
    let observationEnd: String
    let notes: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case units
        case frequency
        case popularityRank = "popularity"
        case lastUpdated = "last_updated"
        case observationStart = "observation_start"
        case observationEnd = "observation_end"
        case notes
    }
}

/// Response model for FRED observations API
struct FREDObservationsResponse: Codable {
    let realtime_start: String
    let realtime_end: String
    let observation_start: String
    let observation_end: String
    let units: String
    let output_type: Int
    let file_type: String
    let order_by: String
    let sort_order: String
    let count: Int
    let offset: Int
    let limit: Int
    let observations: [FREDObservationData]
}

/// Observation data from FRED API (raw from API)
struct FREDObservationData: Codable {
    let realtime_start: String
    let realtime_end: String
    let date: String
    let value: String
}

/// Observation information for app use (processed)
struct FREDObservationInfo: Codable {
    let date: String
    let value: String
}

/// Response model for FRED categories API
struct FREDCategoriesResponse: Codable {
    let categories: [FREDCategoryInfo]
}

/// Category information from FRED API
struct FREDCategoryInfo: Codable {
    let id: Int
    let name: String
    let parentId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parentId = "parent_id"
    }
}

// MARK: - FRED Data Organization Schema

/// Comprehensive FRED category structure for logical organization
enum FREDCategorySchema {
    
    /// Main category groups for financial data
    static let categoryStructure: [FREDCategory] = [
        
        // MARK: - Macroeconomic Indicators
        FREDCategory(
            id: 100000, // Virtual ID for organizational purposes
            name: "Macroeconomic Indicators",
            children: [
                FREDCategory(id: 32992, name: "Gross Domestic Product", children: [
                    FREDCategory(id: 100001, name: "Real GDP", seriesCount: 25),
                    FREDCategory(id: 100002, name: "Nominal GDP", seriesCount: 15),
                    FREDCategory(id: 100003, name: "GDP by Components", seriesCount: 40),
                    FREDCategory(id: 100004, name: "GDP by Industry", seriesCount: 30)
                ]),
                FREDCategory(id: 10, name: "Employment & Labor Markets", children: [
                    FREDCategory(id: 100005, name: "Unemployment Rate", seriesCount: 20),
                    FREDCategory(id: 100006, name: "Employment Level", seriesCount: 25),
                    FREDCategory(id: 100007, name: "Labor Force Participation", seriesCount: 15),
                    FREDCategory(id: 100008, name: "Wages & Earnings", seriesCount: 35)
                ]),
                FREDCategory(id: 32455, name: "Inflation & Prices", children: [
                    FREDCategory(id: 100009, name: "Consumer Price Index", seriesCount: 30),
                    FREDCategory(id: 100010, name: "Producer Price Index", seriesCount: 25),
                    FREDCategory(id: 100011, name: "Core Inflation", seriesCount: 15),
                    FREDCategory(id: 100012, name: "PCE Price Index", seriesCount: 20)
                ])
            ]
        ),
        
        // MARK: - Monetary Policy & Interest Rates
        FREDCategory(
            id: 200000,
            name: "Monetary Policy & Interest Rates",
            children: [
                FREDCategory(id: 22, name: "Federal Funds Rate", children: [
                    FREDCategory(id: 200001, name: "Effective Federal Funds Rate", seriesCount: 10),
                    FREDCategory(id: 200002, name: "Target Federal Funds Rate", seriesCount: 8),
                    FREDCategory(id: 200003, name: "Shadow Rate", seriesCount: 5)
                ]),
                FREDCategory(id: 200004, name: "Treasury Rates", children: [
                    FREDCategory(id: 200005, name: "Treasury Bills (3M, 6M, 1Y)", seriesCount: 15),
                    FREDCategory(id: 200006, name: "Treasury Notes (2Y, 5Y, 7Y)", seriesCount: 18),
                    FREDCategory(id: 200007, name: "Treasury Bonds (10Y, 20Y, 30Y)", seriesCount: 12),
                    FREDCategory(id: 200008, name: "TIPS (Inflation-Protected)", seriesCount: 20)
                ])
            ]
        )
    ]
    
    /// Popular series for quick access and recommendations
    static let popularSeries: [String: [String]] = [
        "Macroeconomic": ["GDP", "UNRATE", "CPIAUCSL", "CPILFESL", "PAYEMS"],
        "Interest Rates": ["FEDFUNDS", "GS10", "GS2", "DGS30", "DGS5"],
        "Money & Banking": ["M2SL", "M1SL", "BOGMBASE", "TOTLL", "LOANINV"],
        "Exchange Rates": ["DEXUSEU", "DEXJPUS", "DEXUSUK", "DEXCAUS"],
        "Housing": ["CSUSHPISA", "HOUST", "EXHOSLUSM495S", "MORTGAGE30US"],
        "Business": ["INDPRO", "RRSFS", "UMCSENT", "BUSINV", "NEWORDER"]
    ]
    
    /// Series recommendations based on selected series
    static func getRecommendations(for seriesId: String) -> [String] {
        switch seriesId.uppercased() {
        case "GDP":
            return ["GDPC1", "NYGDPMKTPCDWLD", "NGDP", "GDPPOT", "UNRATE"]
        case "UNRATE":
            return ["PAYEMS", "CIVPART", "EMRATIO", "U6RATE", "GDPC1"]
        case "FEDFUNDS":
            return ["GS10", "GS2", "DGS30", "TB3MS", "MORTGAGE30US"]
        case "GS10":
            return ["GS2", "GS30", "FEDFUNDS", "T10Y2Y", "MORTGAGE30US"]
        case "CPIAUCSL":
            return ["CPILFESL", "PCEPILFE", "GDPDEF", "UMCSENT"]
        case "DEXUSEU":
            return ["DEXJPUS", "DEXUSUK", "DEXCAUS", "TWEXBMTH"]
        case "HOUST":
            return ["PERMIT", "EXHOSLUSM495S", "MORTGAGE30US", "CSUSHPISA"]
        default:
            return ["GDP", "UNRATE", "FEDFUNDS", "CPIAUCSL", "GS10"]
        }
    }
    
    /// Get category path for a given series ID
    static func getCategoryPath(for seriesId: String) -> [String] {
        // This would be populated with actual FRED category mapping
        // For now, return a sample path
        switch seriesId.uppercased() {
        case "GDP", "GDPC1":
            return ["Macroeconomic Indicators", "Gross Domestic Product", "Real GDP"]
        case "UNRATE":
            return ["Macroeconomic Indicators", "Employment & Labor Markets", "Unemployment Rate"]
        case "FEDFUNDS":
            return ["Monetary Policy & Interest Rates", "Federal Funds Rate", "Effective Federal Funds Rate"]
        case "GS10":
            return ["Monetary Policy & Interest Rates", "Treasury Rates", "Treasury Bonds (10Y, 20Y, 30Y)"]
        default:
            return ["Macroeconomic Indicators"]
        }
    }
}

// MARK: - Series Display Models

/// Model for displaying multiple series in charts and tables
@Observable
class FREDSeriesCollection {
    var series: [FREDSeries] = []
    var selectedSeriesIds: Set<String> = []
    var displayMode: DisplayMode = .chart
    var chartType: ChartType = .line
    var timeRange: TimeRange = .oneYear
    
    enum DisplayMode: String, CaseIterable {
        case chart = "chart"
        case table = "table"
        
        var displayName: String {
            switch self {
            case .chart: return "Chart"
            case .table: return "Table"
            }
        }
        
        var systemImage: String {
            switch self {
            case .chart: return "chart.xyaxis.line"
            case .table: return "tablecells"
            }
        }
    }
    
    enum TimeRange: String, CaseIterable {
        case oneMonth = "1m"
        case threeMonths = "3m"
        case sixMonths = "6m"
        case oneYear = "1y"
        case fiveYears = "5y"
        case tenYears = "10y"
        case all = "all"
        
        var displayName: String {
            switch self {
            case .oneMonth: return "1 Month"
            case .threeMonths: return "3 Months"
            case .sixMonths: return "6 Months"
            case .oneYear: return "1 Year"
            case .fiveYears: return "5 Years"
            case .tenYears: return "10 Years"
            case .all: return "All Time"
            }
        }
    }
    
    func addSeries(_ series: FREDSeries) {
        if !self.series.contains(where: { $0.id == series.id }) {
            self.series.append(series)
            selectedSeriesIds.insert(series.id)
        }
    }
    
    func removeSeries(_ seriesId: String) {
        series.removeAll { $0.id == seriesId }
        selectedSeriesIds.remove(seriesId)
    }
    
    func clearAllSeries() {
        series.removeAll()
        selectedSeriesIds.removeAll()
    }
    
    var hasMultipleSeries: Bool {
        series.count > 1
    }
}
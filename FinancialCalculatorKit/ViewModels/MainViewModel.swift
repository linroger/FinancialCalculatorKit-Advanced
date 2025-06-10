//
//  MainViewModel.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation
import SwiftUI
import SwiftData

/// Main view model coordinating the entire application state
@Observable
class MainViewModel {
    /// Currently selected calculation type
    var selectedCalculationType: CalculationType = .timeValue
    
    /// Selected calculation for editing
    var selectedCalculation: FinancialCalculation?
    
    /// Search text for filtering calculations
    var searchText: String = ""
    
    /// Show favorites only
    var showFavoritesOnly: Bool = false
    
    /// Current navigation path for detail views
    var navigationPath = NavigationPath()
    
    /// User preferences
    var userPreferences: UserPreferences = UserPreferences()
    
    /// Error handling
    var currentError: FinancialCalculatorError?
    var showingError: Bool = false
    
    /// Loading states
    var isCalculating: Bool = false
    var isLoadingData: Bool = false
    
    /// Sheet presentation states
    var showingCalculationSheet: Bool = false
    var showingPreferencesSheet: Bool = false
    var showingHelpSheet: Bool = false
    var showingImportSheet: Bool = false
    var showingExportSheet: Bool = false
    
    /// Initialize with default settings
    init() {
        loadUserPreferences()
    }
    
    /// Load user preferences from storage
    private func loadUserPreferences() {
        // In a real app, this would load from UserDefaults or SwiftData
        // For now, using defaults
        userPreferences = UserPreferences()
    }
    
    /// Save user preferences
    func saveUserPreferences() {
        // Save to persistent storage
        // Implementation would go here
    }
    
    /// Create a new calculation of the specified type
    func createNewCalculation(type: CalculationType) {
        selectedCalculationType = type
        selectedCalculation = nil
        showingCalculationSheet = true
    }
    
    /// Edit an existing calculation
    func editCalculation(_ calculation: FinancialCalculation) {
        selectedCalculation = calculation
        selectedCalculationType = calculation.calculationType
        showingCalculationSheet = true
    }
    
    /// Delete a calculation
    func deleteCalculation(_ calculation: FinancialCalculation, from context: ModelContext) {
        context.delete(calculation)
        
        // If this was the selected calculation, clear selection
        if selectedCalculation?.id == calculation.id {
            selectedCalculation = nil
        }
        
        try? context.save()
    }
    
    /// Toggle favorite status of a calculation
    func toggleFavorite(_ calculation: FinancialCalculation, in context: ModelContext) {
        calculation.toggleFavorite()
        try? context.save()
    }
    
    /// Handle errors
    func handleError(_ error: FinancialCalculatorError) {
        currentError = error
        showingError = true
    }
    
    /// Clear current error
    func clearError() {
        currentError = nil
        showingError = false
    }
    
    /// Filter calculations based on search and favorites
    func filteredCalculations(_ calculations: [FinancialCalculation]) -> [FinancialCalculation] {
        var filtered = calculations
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { calculation in
                calculation.name.localizedCaseInsensitiveContains(searchText) ||
                calculation.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by favorites if enabled
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        // Sort by last modified date (most recent first)
        return filtered.sorted { $0.lastModified > $1.lastModified }
    }
}

/// User preferences model
@Observable
class UserPreferences {
    /// Default currency for new calculations
    var defaultCurrency: Currency = .usd
    
    /// Default payment frequency
    var defaultPaymentFrequency: PaymentFrequency = .monthly
    
    /// Number format preferences
    var decimalPlaces: Int = 2
    var useThousandsSeparator: Bool = true
    
    /// Chart preferences
    var defaultChartType: ChartType = .line
    var showDataLabels: Bool = true
    
    /// UI preferences
    var sidebarWidth: Double = 250
    var showTooltips: Bool = true
    var autoSaveCalculations: Bool = true
    
    /// Export preferences
    var defaultExportFormat: ExportFormat = .csv
    var includeChartsInExport: Bool = true
}

/// Supported chart types
enum ChartType: String, CaseIterable, Identifiable {
    case line = "line"
    case bar = "bar"
    case area = "area"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .line:
            return "Line Chart"
        case .bar:
            return "Bar Chart"
        case .area:
            return "Area Chart"
        }
    }
}

/// Export format options
enum ExportFormat: String, CaseIterable, Identifiable {
    case csv = "csv"
    case excel = "excel"
    case pdf = "pdf"
    case json = "json"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .csv:
            return "CSV"
        case .excel:
            return "Excel"
        case .pdf:
            return "PDF"
        case .json:
            return "JSON"
        }
    }
    
    var fileExtension: String {
        switch self {
        case .csv:
            return "csv"
        case .excel:
            return "xlsx"
        case .pdf:
            return "pdf"
        case .json:
            return "json"
        }
    }
}

/// Application-specific errors
enum FinancialCalculatorError: LocalizedError, Identifiable {
    case invalidInput(String)
    case calculationFailed(String)
    case dataImportFailed(String)
    case dataExportFailed(String)
    case networkError(String)
    case fileAccessError(String)
    
    var id: String {
        switch self {
        case .invalidInput(let message):
            return "invalidInput_\(message)"
        case .calculationFailed(let message):
            return "calculationFailed_\(message)"
        case .dataImportFailed(let message):
            return "dataImportFailed_\(message)"
        case .dataExportFailed(let message):
            return "dataExportFailed_\(message)"
        case .networkError(let message):
            return "networkError_\(message)"
        case .fileAccessError(let message):
            return "fileAccessError_\(message)"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid Input: \(message)"
        case .calculationFailed(let message):
            return "Calculation Failed: \(message)"
        case .dataImportFailed(let message):
            return "Import Failed: \(message)"
        case .dataExportFailed(let message):
            return "Export Failed: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        case .fileAccessError(let message):
            return "File Access Error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidInput:
            return "Please check your input values and try again."
        case .calculationFailed:
            return "Verify that all required fields are filled correctly."
        case .dataImportFailed:
            return "Check that the file format is correct and try again."
        case .dataExportFailed:
            return "Ensure you have write permissions to the selected location."
        case .networkError:
            return "Check your internet connection and try again."
        case .fileAccessError:
            return "Verify file permissions and try again."
        }
    }
}
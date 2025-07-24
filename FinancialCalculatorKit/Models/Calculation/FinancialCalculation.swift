//
//  FinancialCalculation.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation
import SwiftData

/// Protocol defining common behavior for financial calculations
protocol FinancialCalculationProtocol {
    var id: UUID { get }
    var metadata: CalculationMetadata { get set }
    
    // Computed properties for backward compatibility
    var name: String { get set }
    var currency: Currency { get set }
    var calculationType: CalculationType { get set }
    var createdDate: Date { get set }
    var lastModified: Date { get set }
    var notes: String { get set }
    var isFavorite: Bool { get set }
    
    var result: CalculationResult { get }
    var isValid: Bool { get }
    var validationErrors: [String] { get }
    
    func updateTimestamp()
    func toggleFavorite()
}

/// Base financial calculation model with common properties
@Model
final class FinancialCalculation {
    var id: UUID
    var metadata: CalculationMetadata
    
    // MARK: - Computed Properties for Backward Compatibility
    var name: String {
        get { metadata.name }
        set { metadata.name = newValue }
    }
    
    var currency: Currency {
        get { metadata.currency }
        set { metadata.currency = newValue }
    }
    
    var calculationType: CalculationType {
        get { metadata.calculationType }
        set { metadata.calculationType = newValue }
    }
    
    var createdDate: Date {
        get { metadata.createdDate }
        set { metadata.createdDate = newValue }
    }
    
    var lastModified: Date {
        get { metadata.lastModified }
        set { metadata.lastModified = newValue }
    }
    
    var notes: String {
        get { metadata.notes }
        set { metadata.notes = newValue }
    }
    
    var isFavorite: Bool {
        get { metadata.isFavorite }
        set { metadata.isFavorite = newValue }
    }
    
    /// Computed result of the calculation
    var result: CalculationResult {
        CalculationResult(
            primaryValue: 0.0,
            secondaryValues: [:],
            formattedPrimaryValue: "Not calculated",
            explanation: "Generic calculation - specific calculations implemented in dedicated models"
        )
    }
    
    init(
        name: String,
        calculationType: CalculationType,
        currency: Currency = .usd,
        notes: String = ""
    ) {
        self.id = UUID()
        self.metadata = CalculationMetadata(
            name: name,
            calculationType: calculationType,
            currency: currency,
            notes: notes
        )
    }
    
    /// Update the last modified timestamp
    func updateTimestamp() {
        metadata.updateTimestamp()
    }
    
    /// Toggle favorite status
    func toggleFavorite() {
        metadata.toggleFavorite()
    }
    
    /// Validate that all required inputs are provided
    var isValid: Bool {
        return !metadata.name.isEmpty
    }
    
    /// Get validation errors
    var validationErrors: [String] {
        var errors: [String] = []
        if metadata.name.isEmpty {
            errors.append("Name is required")
        }
        return errors
    }
}

// MARK: - Protocol Conformance

extension FinancialCalculation: FinancialCalculationProtocol {}

/// Result structure for financial calculations
struct CalculationResult {
    let primaryValue: Double
    let secondaryValues: [String: Double]
    let formattedPrimaryValue: String
    let explanation: String
    let chartData: [ChartDataPoint]?
    let tableData: [TableRow]?
    
    /// Whether the calculation result is valid
    var isValid: Bool {
        return !formattedPrimaryValue.contains("Invalid") && !formattedPrimaryValue.contains("Missing")
    }
    
    init(
        primaryValue: Double,
        secondaryValues: [String: Double] = [:],
        formattedPrimaryValue: String,
        explanation: String,
        chartData: [ChartDataPoint]? = nil,
        tableData: [TableRow]? = nil
    ) {
        self.primaryValue = primaryValue
        self.secondaryValues = secondaryValues
        self.formattedPrimaryValue = formattedPrimaryValue
        self.explanation = explanation
        self.chartData = chartData
        self.tableData = tableData
    }
}

/// Data point for charts
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
    let label: String?
    let date: Date?
    
    init(x: Double, y: Double, label: String? = nil, date: Date? = nil) {
        self.x = x
        self.y = y
        self.label = label
        self.date = date
    }
}

/// Row data for tables
struct TableRow: Identifiable {
    let id = UUID()
    let values: [String: String]
    
    init(values: [String: String]) {
        self.values = values
    }
}

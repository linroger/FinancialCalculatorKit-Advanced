//
//  CalculationMetadata.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation

/// Common metadata for all financial calculations
/// This struct encapsulates the shared properties to eliminate code duplication across models
struct CalculationMetadata: Codable {
    var name: String
    private var calculationTypeRawValue: String
    var createdDate: Date
    var lastModified: Date
    var notes: String
    var isFavorite: Bool
    private var currencyRawValue: String
    
    /// Computed property for calculationType
    var calculationType: CalculationType {
        get {
            CalculationType(rawValue: calculationTypeRawValue) ?? .timeValue
        }
        set {
            calculationTypeRawValue = newValue.rawValue
        }
    }
    
    /// Computed property for currency
    var currency: Currency {
        get {
            Currency(rawValue: currencyRawValue) ?? .usd
        }
        set {
            currencyRawValue = newValue.rawValue
        }
    }
    
    init(
        name: String,
        calculationType: CalculationType,
        currency: Currency = .usd,
        notes: String = ""
    ) {
        self.name = name
        self.calculationTypeRawValue = calculationType.rawValue
        self.createdDate = Date()
        self.lastModified = Date()
        self.notes = notes
        self.isFavorite = false
        self.currencyRawValue = currency.rawValue
    }
    
    /// Update the last modified timestamp
    mutating func updateTimestamp() {
        lastModified = Date()
    }
    
    /// Toggle favorite status
    mutating func toggleFavorite() {
        isFavorite.toggle()
        updateTimestamp()
    }
}
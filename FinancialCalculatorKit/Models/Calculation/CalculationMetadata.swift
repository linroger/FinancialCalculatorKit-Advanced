//
//  CalculationMetadata.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import Foundation

/// Common metadata for all financial calculations
/// This struct encapsulates the shared properties to eliminate code duplication across models
public struct CalculationMetadata: Codable {
    public var name: String
    private var calculationTypeRawValue: String
    public var createdDate: Date
    public var lastModified: Date
    public var notes: String
    public var isFavorite: Bool
    private var currencyRawValue: String
    
    /// Computed property for calculationType
    public var calculationType: CalculationType {
        get {
            CalculationType(rawValue: calculationTypeRawValue) ?? .timeValue
        }
        set {
            calculationTypeRawValue = newValue.rawValue
        }
    }
    
    /// Computed property for currency
    public var currency: Currency {
        get {
            Currency(rawValue: currencyRawValue) ?? .usd
        }
        set {
            currencyRawValue = newValue.rawValue
        }
    }
    
    public init(
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
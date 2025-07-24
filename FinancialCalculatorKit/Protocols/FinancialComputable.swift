//
//  FinancialComputable.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 7/5/25.
//  Protocol for standardizing financial calculations
//

import Foundation
import SwiftData
import Combine

// MARK: - Core Protocol

/// Protocol that standardizes all financial calculations in the app
public protocol FinancialComputable: AnyObject {
    // MARK: - Required Properties
    
    /// Unique identifier for the calculation
    var id: UUID { get }
    
    /// Metadata containing common properties
    var metadata: CalculationMetadata { get set }
    
    /// Whether the calculation has valid inputs
    var isValid: Bool { get }
    
    /// Array of validation errors if the calculation is invalid
    var validationErrors: [String] { get }
    
    /// The computed result of the calculation
    var result: CalculationResult { get }
    
    // MARK: - Required Methods
    
    /// Validates all inputs and returns detailed validation results
    func validate() -> ValidationResult
    
    /// Performs the calculation and returns the result
    /// - Throws: CalculationError if the computation fails
    func compute() throws -> CalculationResult
    
    /// Performs the calculation asynchronously with progress reporting
    /// - Parameter progressHandler: Optional handler for progress updates
    /// - Returns: The calculation result
    func computeAsync(progressHandler: ((Double) -> Void)?) async throws -> CalculationResult
    
    /// Updates the last modified timestamp
    func updateTimestamp()
    
    /// Toggles the favorite status
    func toggleFavorite()
    
    /// Returns a summary of the calculation for display
    func summary() -> CalculationSummary
    
    /// Exports the calculation data in the specified format
    func export(format: ExportFormat) throws -> Data
    
    /// Creates a deep copy of the calculation
    func duplicate() -> Self
}

// MARK: - Default Implementations

public extension FinancialComputable {
    /// Default validation that checks if the calculation is valid
    func validate() -> ValidationResult {
        if isValid {
            return ValidationResult.valid()
        } else {
            let errors = validationErrors.joined(separator: "; ")
            return ValidationResult.invalid(
                errorType: .businessRule,
                message: errors.isEmpty ? "Invalid calculation inputs" : errors
            )
        }
    }
    
    /// Default async compute that wraps the synchronous version
    func computeAsync(progressHandler: ((Double) -> Void)? = nil) async throws -> CalculationResult {
        // For simple calculations, just call compute directly
        progressHandler?(0.0)
        let result = try await Task { try compute() }.value
        progressHandler?(1.0)
        return result
    }
    
    /// Default update timestamp implementation
    func updateTimestamp() {
        metadata.updateTimestamp()
    }
    
    /// Default toggle favorite implementation
    func toggleFavorite() {
        metadata.toggleFavorite()
    }
    
    /// Default export implementation
    func export(format: ExportFormat) throws -> Data {
        switch format {
        case .json:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(summary())
            
        case .csv:
            return summary().toCSV().data(using: .utf8) ?? Data()
            
        case .pdf:
            // PDF export would be implemented with proper PDF generation
            throw CalculationError.exportNotSupported(format)
            
        case .excel:
            // Excel export would use a library like XLSXWriter
            throw CalculationError.exportNotSupported(format)
        }
    }
}

// MARK: - Supporting Types

/// Errors that can occur during calculation
public enum CalculationError: LocalizedError {
    case invalidInput(String)
    case mathematicalError(String)
    case convergenceFailure(String)
    case overflow
    case underflow
    case divisionByZero
    case negativeLogarithm
    case complexNumber
    case notImplemented
    case exportNotSupported(ExportFormat)
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .mathematicalError(let message):
            return "Mathematical error: \(message)"
        case .convergenceFailure(let message):
            return "Failed to converge: \(message)"
        case .overflow:
            return "Calculation resulted in overflow"
        case .underflow:
            return "Calculation resulted in underflow"
        case .divisionByZero:
            return "Division by zero"
        case .negativeLogarithm:
            return "Cannot take logarithm of negative number"
        case .complexNumber:
            return "Result would be a complex number"
        case .notImplemented:
            return "Calculation not yet implemented"
        case .exportNotSupported(let format):
            return "Export to \(format.rawValue) is not supported"
        case .cancelled:
            return "Calculation was cancelled"
        }
    }
}

/// Summary of a calculation for display and export
public struct CalculationSummary: Codable {
    public let id: UUID
    public let name: String
    public let type: String
    public let date: Date
    public let inputs: [String: Any]
    public let outputs: [String: Any]
    public let result: CalculationResult
    public let notes: String
    public let currency: Currency
    
    public init(
        id: UUID,
        name: String,
        type: String,
        date: Date,
        inputs: [String: Any],
        outputs: [String: Any],
        result: CalculationResult,
        notes: String,
        currency: Currency
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.date = date
        self.inputs = inputs
        self.outputs = outputs
        self.result = result
        self.notes = notes
        self.currency = currency
    }
    
    /// Convert to CSV format
    public func toCSV() -> String {
        var csv = "Field,Value\n"
        csv += "Calculation Name,\(name)\n"
        csv += "Type,\(type)\n"
        csv += "Date,\(ISO8601DateFormatter().string(from: date))\n"
        csv += "Currency,\(currency.rawValue)\n"
        csv += "\nInputs\n"
        
        for (key, value) in inputs.sorted(by: { $0.key < $1.key }) {
            csv += "\(key),\(String(describing: value))\n"
        }
        
        csv += "\nOutputs\n"
        for (key, value) in outputs.sorted(by: { $0.key < $1.key }) {
            csv += "\(key),\(String(describing: value))\n"
        }
        
        csv += "\nResult\n"
        csv += "Primary Value,\(result.formattedPrimaryValue)\n"
        csv += "Explanation,\"\(result.explanation)\"\n"
        
        if !notes.isEmpty {
            csv += "\nNotes\n"
            csv += "\"\(notes.replacingOccurrences(of: "\"", with: "\"\""))\"\n"
        }
        
        return csv
    }
    
    // Custom encoding for Any types
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(date, forKey: .date)
        try container.encode(convertToEncodable(inputs), forKey: .inputs)
        try container.encode(convertToEncodable(outputs), forKey: .outputs)
        try container.encode(result, forKey: .result)
        try container.encode(notes, forKey: .notes)
        try container.encode(currency, forKey: .currency)
    }
    
    // Custom decoding for Any types
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        date = try container.decode(Date.self, forKey: .date)
        inputs = try container.decode([String: AnyCodable].self, forKey: .inputs).mapValues { $0.value }
        outputs = try container.decode([String: AnyCodable].self, forKey: .outputs).mapValues { $0.value }
        result = try container.decode(CalculationResult.self, forKey: .result)
        notes = try container.decode(String.self, forKey: .notes)
        currency = try container.decode(Currency.self, forKey: .currency)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, type, date, inputs, outputs, result, notes, currency
    }
    
    private func convertToEncodable(_ dict: [String: Any]) -> [String: AnyCodable] {
        return dict.mapValues { AnyCodable($0) }
    }
}

/// Export format options
public enum ExportFormat: String, CaseIterable {
    case json = "JSON"
    case csv = "CSV"
    case pdf = "PDF"
    case excel = "Excel"
}

// MARK: - Protocol Extensions for Specific Calculations

/// Extension for calculations that support cash flow analysis
public protocol CashFlowComputable: FinancialComputable {
    /// Generate cash flow data for visualization
    func generateCashFlowData() -> [CashFlowDataPoint]
    
    /// Calculate NPV for the cash flows
    func calculateNPV(discountRate: Double) -> Double
    
    /// Calculate IRR for the cash flows
    func calculateIRR() throws -> Double
}

/// Extension for calculations that support sensitivity analysis
public protocol SensitivityAnalyzable: FinancialComputable {
    associatedtype SensitivityParameter: CaseIterable & RawRepresentable where SensitivityParameter.RawValue == String
    
    /// Perform sensitivity analysis on a parameter
    func performSensitivityAnalysis(
        parameter: SensitivityParameter,
        range: ClosedRange<Double>,
        steps: Int
    ) -> [SensitivityDataPoint]
}

/// Extension for calculations that support scenario analysis
public protocol ScenarioAnalyzable: FinancialComputable {
    /// Define and analyze different scenarios
    func analyzeScenarios(_ scenarios: [Scenario]) -> [ScenarioResult]
}

// MARK: - Supporting Data Types

/// Data point for cash flow visualization
public struct CashFlowDataPoint: Codable {
    public let period: Int
    public let date: Date
    public let amount: Double
    public let description: String
    public let type: CashFlowType
    
    public enum CashFlowType: String, Codable {
        case inflow
        case outflow
        case net
    }
}

/// Data point for sensitivity analysis
public struct SensitivityDataPoint: Codable {
    public let parameterValue: Double
    public let resultValue: Double
    public let percentChange: Double
}

/// Scenario definition
public struct Scenario: Codable {
    public let name: String
    public let description: String
    public let parameters: [String: Double]
}

/// Scenario analysis result
public struct ScenarioResult: Codable {
    public let scenario: Scenario
    public let result: CalculationResult
    public let percentDifference: Double
}

// MARK: - Validation Result Extensions

extension FinancialValidation.ValidationResult {
    /// Create a validation result from an array of errors
    public static func fromErrors(_ errors: [String]) -> FinancialValidation.ValidationResult {
        if errors.isEmpty {
            return .valid()
        } else {
            return .invalid(
                errorType: .businessRule,
                message: errors.joined(separator: "; ")
            )
        }
    }
}

// MARK: - Helper Type for Any Codable

struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let date as Date:
            try container.encode(date)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        default:
            try container.encode(String(describing: value))
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let date = try? container.decode(Date.self) {
            value = date
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unable to decode value"
            )
        }
    }
}
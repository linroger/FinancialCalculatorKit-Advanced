//
//  CashFlowsTransformer.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import Foundation

/// Custom transformer for cash flows array used in SwiftData persistence
final class CashFlowsTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let cashFlows = value as? [Double] else { return nil }
        do {
            return try JSONEncoder().encode(cashFlows)
        } catch {
            print("Error encoding cash flows: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try JSONDecoder().decode([Double].self, from: data)
        } catch {
            print("Error decoding cash flows: \(error)")
            return nil
        }
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    /// Register the transformer for use with SwiftData
    static func register() {
        ValueTransformer.setValueTransformer(
            CashFlowsTransformer(),
            forName: NSValueTransformerName("CashFlowsTransformer")
        )
    }
}
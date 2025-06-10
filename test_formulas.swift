import Foundation

// Test if the FormulaReference structures compile correctly
struct TestFormulaReference {
    let id = UUID()
    let name: String
    let category: String
    let level: String
    let mainFormula: String
    let description: String
    let variables: [String]
    let examples: [[String: String]]
}

// Test if the problematic dictionary syntax is fixed
let testExample = [
    "S₀": "$100",
    "K": "$85",
    "T": "0.25 years",
    "r": "5%"
]

print("Test compilation successful!")
print("Dictionary example: \(testExample)")
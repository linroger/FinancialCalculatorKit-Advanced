//
//  FinancialCalculatorKitApp.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI
import SwiftData

@main
struct FinancialCalculatorKitApp: App {
    let sharedModelContainer: ModelContainer
    
    init() {
        // Register custom transformers BEFORE creating the ModelContainer
        CashFlowsTransformer.register()
        
        // Now create the ModelContainer
        let schema = Schema([
            FinancialCalculation.self,
            TimeValueCalculation.self,
            LoanCalculation.self,
            BondCalculation.self,
            InvestmentCalculation.self,
            DepreciationCalculation.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .windowResizability(.contentSize)
        
        WindowGroup("Compact Calculator", id: "compact-calculator") {
            CompactCalculatorView()
        }
        .windowResizability(.contentSize)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 800, height: 600)
    }
}

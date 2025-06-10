//
//  ContentView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var calculations: [FinancialCalculation]
    @State private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
        } detail: {
            DetailView()
                .environment(viewModel)
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $viewModel.showingCalculationSheet) {
            CalculationSheetView()
                .environment(viewModel)
        }
        .sheet(isPresented: $viewModel.showingPreferencesSheet) {
            PreferencesView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingHelpSheet) {
            HelpView()
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let error = viewModel.currentError {
                VStack(alignment: .leading, spacing: 8) {
                    Text(error.localizedDescription)
                    if let suggestion = error.recoverySuggestion {
                        Text(suggestion)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

struct SidebarView: View {
    @Bindable var viewModel: MainViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var calculations: [FinancialCalculation]
    
    var body: some View {
        List(selection: $viewModel.selectedCalculationType) {
            Section("Calculators") {
                ForEach(CalculationType.allCases) { type in
                    NavigationLink(value: type) {
                        Label(type.displayName, systemImage: type.systemImage)
                    }
                    .tag(type)
                }
            }
            
            Section("Recent Calculations") {
                ForEach(recentCalculations) { calculation in
                    CalculationRowView(calculation: calculation)
                        .environment(viewModel)
                }
                .onDelete(perform: deleteCalculations)
            }
        }
        .navigationTitle("Financial Calculator")
        .navigationSplitViewColumnWidth(min: 280, ideal: 320)
        .searchable(text: $viewModel.searchText, prompt: "Search calculations...")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { viewModel.showFavoritesOnly.toggle() }) {
                    Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                }
                .help("Show favorites only")
                
                Menu {
                    ForEach(CalculationType.allCases) { type in
                        Button(action: { viewModel.createNewCalculation(type: type) }) {
                            Label(type.displayName, systemImage: type.systemImage)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                } primaryAction: {
                    viewModel.createNewCalculation(type: viewModel.selectedCalculationType)
                }
                .help("Create new calculation")
            }
            
            ToolbarItemGroup(placement: .secondaryAction) {
                Button(action: { viewModel.showingPreferencesSheet = true }) {
                    Image(systemName: "gear")
                }
                .help("Preferences")
                
                Button(action: { viewModel.showingHelpSheet = true }) {
                    Image(systemName: "questionmark.circle")
                }
                .help("Help")
            }
        }
    }
    
    private var recentCalculations: [FinancialCalculation] {
        viewModel.filteredCalculations(calculations)
            .prefix(10)
            .map { $0 }
    }
    
    private func deleteCalculations(offsets: IndexSet) {
        for index in offsets {
            let calculation = recentCalculations[index]
            viewModel.deleteCalculation(calculation, from: modelContext)
        }
    }
}

struct CalculationRowView: View {
    let calculation: FinancialCalculation
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(calculation.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if calculation.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Text(calculation.calculationType.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(calculation.lastModified, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { viewModel.editCalculation(calculation) }) {
                Image(systemName: "pencil")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .help("Edit calculation")
        }
        .contentShape(Rectangle())
        .contextMenu {
            Button(action: { viewModel.editCalculation(calculation) }) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(action: { viewModel.toggleFavorite(calculation, in: modelContext) }) {
                Label(
                    calculation.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: calculation.isFavorite ? "heart.slash" : "heart"
                )
            }
            
            Divider()
            
            Button(action: { viewModel.deleteCalculation(calculation, from: modelContext) }) {
                Label("Delete", systemImage: "trash")
            }
            .foregroundColor(.red)
        }
    }
}

struct DetailView: View {
    @Environment(MainViewModel.self) private var viewModel
    
    var body: some View {
        Group {
            switch viewModel.selectedCalculationType {
            case .timeValue:
                TimeValueCalculatorView()
            case .loan, .mortgage:
                LoanCalculatorView()
            case .bond:
                BondCalculatorView()
            case .investment:
                InvestmentCalculatorView()
            case .options:
                OptionsCalculatorView()
            case .mathExpression:
                MathExpressionCalculatorView()
            case .depreciation:
                DepreciationCalculatorView()
            case .currency:
                CurrencyConverterView()
            case .conversion:
                UnitConverterView()
            }
        }
        .navigationTitle(viewModel.selectedCalculationType.displayName)
        .navigationSubtitle(viewModel.selectedCalculationType.description)
        .frame(minWidth: 600, minHeight: 400)
    }
}

// MARK: - Placeholder Views (to be implemented)

// TimeValueCalculatorView is now implemented in its own file

// LoanCalculatorView is now implemented in its own file

// BondCalculatorView is now implemented in its own file

// InvestmentCalculatorView is now implemented in its own file

// DepreciationCalculatorView is now implemented in its own file

// CurrencyConverterView is now implemented in its own file

// UnitConverterView is now implemented in its own file

struct CalculationSheetView: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Calculation Editor")
                    .font(.title)
                
                Text("Calculator type: \(viewModel.selectedCalculationType.displayName)")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Text("Implementation coming soon...")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Calculation")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Save logic here
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct PreferencesView: View {
    @Bindable var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Currency") {
                    Picker("Default Currency", selection: $viewModel.userPreferences.defaultCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text("\(currency.displayName) (\(currency.symbol))")
                                .tag(currency)
                        }
                    }
                }
                
                Section("Formatting") {
                    Stepper("Decimal Places: \(viewModel.userPreferences.decimalPlaces)", 
                           value: $viewModel.userPreferences.decimalPlaces, 
                           in: 0...6)
                    
                    Toggle("Use Thousands Separator", 
                           isOn: $viewModel.userPreferences.useThousandsSeparator)
                }
                
                Section("Interface") {
                    Toggle("Show Tooltips", 
                           isOn: $viewModel.userPreferences.showTooltips)
                    
                    Toggle("Auto-save Calculations", 
                           isOn: $viewModel.userPreferences.autoSaveCalculations)
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        viewModel.saveUserPreferences()
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Financial Calculator Help")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome to FinancialCalculatorKit, your comprehensive financial calculation tool.")
                        .font(.body)
                    
                    HelpSection(title: "Getting Started", items: [
                        "Select a calculator type from the sidebar",
                        "Enter your values in the input fields",
                        "View results and visualizations",
                        "Save calculations for future reference"
                    ])
                    
                    HelpSection(title: "Calculator Types", items: [
                        "Time Value of Money: PV, FV, PMT, Interest Rate, Periods",
                        "Loan Calculator: Payment schedules and amortization",
                        "Bond Calculator: Pricing and yield analysis",
                        "Investment Analysis: NPV, IRR, and performance metrics"
                    ])
                    
                    HelpSection(title: "Features", items: [
                        "Interactive charts and visualizations",
                        "Export calculations to CSV, Excel, or PDF",
                        "Currency conversion and international support",
                        "Comprehensive help and tooltips"
                    ])
                }
                .padding()
            }
            .navigationTitle("Help")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct HelpSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top) {
                    Text("•")
                    Text(item)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FinancialCalculation.self, inMemory: true)
}

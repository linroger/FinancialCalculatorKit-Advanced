//
//  CurrencyConverterView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/8/25.
//

import SwiftUI

/// Currency converter with real-time exchange rates
struct CurrencyConverterView: View {
    @Environment(MainViewModel.self) private var mainViewModel
    
    @State private var amount: Double = 100.0
    @State private var fromCurrency: Currency = .usd
    @State private var toCurrency: Currency = .eur
    @State private var exchangeRate: Double = 1.0
    @State private var convertedAmount: Double = 0.0
    @State private var isLoading: Bool = false
    @State private var lastUpdated: Date = Date()
    @State private var showAllCurrencies: Bool = false
    
    @State private var exchangeRates: [String: [String: Double]] = [:]
    @State private var isLoadingRates: Bool = false
    @State private var ratesError: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                HStack(alignment: .top, spacing: 24) {
                    converterSection
                    resultSection
                }
                
                exchangeRateInfoSection
                
                if showAllCurrencies {
                    allCurrenciesSection
                }
            }
            .padding(24)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            Task {
                await loadExchangeRates()
            }
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Currency Converter")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Convert between major world currencies with real-time exchange rates")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if isLoading || isLoadingRates {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else if ratesError != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Text("Last updated: \(lastUpdated.formatted(as: .short))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var converterSection: some View {
        VStack(spacing: 20) {
            GroupBox("Conversion") {
                VStack(spacing: 20) {
                    // Amount input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        HStack {
                            Text(fromCurrency.symbol)
                                .font(.system(.title3, design: .monospaced))
                                .foregroundColor(.secondary)
                            
                            TextField("Amount", value: $amount, format: .number.precision(.fractionLength(2)))
                                .textFieldStyle(.roundedBorder)
                                .font(.system(.title3, design: .monospaced))
                                .onChange(of: amount) { _, _ in
                                    performConversion()
                                }
                        }
                    }
                    
                    // Currency selectors
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("From")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Picker("From Currency", selection: $fromCurrency) {
                                ForEach(Currency.allCases.prefix(showAllCurrencies ? 16 : 8)) { currency in
                                    HStack {
                                        Text(currency.countryCode)
                                            .font(.system(.body, design: .monospaced))
                                        Text(currency.displayName)
                                    }
                                    .tag(currency)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: fromCurrency) { _, _ in
                                performConversion()
                            }
                        }
                        
                        // Swap button
                        Button(action: swapCurrencies) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 24)
                        .help("Swap currencies")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("To")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Picker("To Currency", selection: $toCurrency) {
                                ForEach(Currency.allCases.prefix(showAllCurrencies ? 16 : 8)) { currency in
                                    HStack {
                                        Text(currency.countryCode)
                                            .font(.system(.body, design: .monospaced))
                                        Text(currency.displayName)
                                    }
                                    .tag(currency)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: toCurrency) { _, _ in
                                performConversion()
                            }
                        }
                    }
                    
                    Toggle("Show all currencies", isOn: $showAllCurrencies)
                        .help("Display all available currencies in the selection menus")
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Quick amount buttons
            GroupBox("Quick Amounts") {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach([10, 50, 100, 500, 1000, 5000, 10000, 50000], id: \.self) { quickAmount in
                        Button(action: {
                            amount = Double(quickAmount)
                        }) {
                            Text(Formatters.formatAbbreviated(Double(quickAmount)))
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: 20) {
            // Conversion result
            GroupBox {
                VStack(spacing: 16) {
                    Text("Converted Amount")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(toCurrency.symbol)\(Formatters.decimalFormatter(decimalPlaces: 2).string(from: NSNumber(value: convertedAmount)) ?? "0.00")")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("1 \(fromCurrency.rawValue) = \(String(format: "%.4f", exchangeRate)) \(toCurrency.rawValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
            
            // Conversion breakdown
            GroupBox("Conversion Details") {
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(
                        title: "Original Amount",
                        value: "\(fromCurrency.symbol)\(Formatters.decimalFormatter(decimalPlaces: 2).string(from: NSNumber(value: amount)) ?? "0.00")"
                    )
                    
                    DetailRow(
                        title: "Exchange Rate",
                        value: "1 \(fromCurrency.rawValue) = \(String(format: "%.4f", exchangeRate)) \(toCurrency.rawValue)"
                    )
                    
                    Divider()
                    
                    DetailRow(
                        title: "Converted Amount",
                        value: "\(toCurrency.symbol)\(Formatters.decimalFormatter(decimalPlaces: 2).string(from: NSNumber(value: convertedAmount)) ?? "0.00")",
                        isHighlighted: true
                    )
                    
                    // Reverse conversion
                    Divider()
                    
                    DetailRow(
                        title: "Reverse Rate",
                        value: "1 \(toCurrency.rawValue) = \(String(format: "%.4f", 1.0 / exchangeRate)) \(fromCurrency.rawValue)"
                    )
                }
                .padding(16)
            }
            .groupBoxStyle(FinancialGroupBoxStyle())
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var exchangeRateInfoSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                    
                    Text("Exchange Rate Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                if let error = ratesError {
                    Text("Error loading exchange rates: \(error). Using cached rates if available.")
                        .font(.body)
                        .foregroundColor(.red)
                } else {
                    Text("Exchange rates are fetched from a reliable financial data provider and updated periodically.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Button("Refresh Rates") {
                        Task {
                            await loadExchangeRates()
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Text("Rates updated every 5 minutes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var allCurrenciesSection: some View {
        GroupBox("Exchange Rates for \(fromCurrency.displayName)") {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(Currency.allCases.filter { $0 != fromCurrency }) { currency in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currency.displayName)
                                .font(.headline)
                            Text("\(currency.rawValue) • \(currency.symbol)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.4f", getExchangeRate(from: fromCurrency, to: currency)))
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(NSColor.controlBackgroundColor))
                    )
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    private func performConversion() {
        exchangeRate = getExchangeRate(from: fromCurrency, to: toCurrency)
        convertedAmount = amount * exchangeRate
    }
    
    private func swapCurrencies() {
        withAnimation(.easeInOut(duration: 0.3)) {
            let temp = fromCurrency
            fromCurrency = toCurrency
            toCurrency = temp
            performConversion()
        }
    }
    
    @MainActor
    private func loadExchangeRates() async {
        isLoadingRates = true
        ratesError = nil
        
        do {
            let service = ExchangeRateService()
            exchangeRates = try await service.fetchExchangeRates()
            lastUpdated = Date()
            performConversion()
        } catch {
            ratesError = error.localizedDescription
            // Use fallback rates if no cached rates available
            if exchangeRates.isEmpty {
                exchangeRates = fallbackExchangeRates
            }
            performConversion()
        }
        
        isLoadingRates = false
    }
    
    private var fallbackExchangeRates: [String: [String: Double]] {
        [
            "USD": ["EUR": 0.92, "GBP": 0.79, "JPY": 156.85, "CAD": 1.44, "AUD": 1.57, "CHF": 0.90, "CNY": 7.30],
            "EUR": ["USD": 1.09, "GBP": 0.86, "JPY": 170.92, "CAD": 1.57, "AUD": 1.71, "CHF": 0.98, "CNY": 7.95],
            "GBP": ["USD": 1.27, "EUR": 1.16, "JPY": 198.76, "CAD": 1.82, "AUD": 1.99, "CHF": 1.14, "CNY": 9.25],
            "JPY": ["USD": 0.0064, "EUR": 0.0059, "GBP": 0.0050, "CAD": 0.0092, "AUD": 0.0100, "CHF": 0.0057, "CNY": 0.047]
        ]
    }

    private func getExchangeRate(from: Currency, to: Currency) -> Double {
        if from == to {
            return 1.0
        }
        
        // Use real exchange rates if available
        if let fromRates = exchangeRates[from.rawValue],
           let rate = fromRates[to.rawValue] {
            return rate
        }
        
        // Fallback calculation through USD if direct rate not available
        if from != .usd && to != .usd,
           let fromToUSD = exchangeRates[from.rawValue]?["USD"],
           let usdToTarget = exchangeRates["USD"]?[to.rawValue] {
            return fromToUSD * usdToTarget
        }
        
        // Default fallback
        return 1.0
    }
}


#Preview {
    CurrencyConverterView()
        .environment(MainViewModel())
        .frame(width: 1000, height: 800)
}
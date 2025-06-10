//
//  FREDDataView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/11/25.
//

import SwiftUI
import SwiftData
import Charts

struct FREDDataView: View {
    @State private var fredService = FREDService()
    @State private var selectedView: ViewMode = .chart
    @State private var seriesCollection: [FREDSeries] = []
    @State private var showingSearch = false
    @State private var showingDateRangePicker = false
    @State private var showingDataFrequencyPicker = false
    @State private var searchText = ""
    @State private var searchResults: [FREDSeriesInfo] = []
    @State private var isSearching = false
    @State private var selectedStartDate = Calendar.current.date(byAdding: .year, value: -5, to: Date()) ?? Date()
    @State private var selectedEndDate = Date()
    @State private var selectedFrequency: DataFrequency = .monthly
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    enum ViewMode: String, CaseIterable {
        case chart = "Chart"
        case table = "Table"
        
        var systemImage: String {
            switch self {
            case .chart: return "chart.xyaxis.line"
            case .table: return "tablecells"
            }
        }
    }
    
    enum DataFrequency: String, CaseIterable {
        case daily = "d"
        case weekly = "w"
        case monthly = "m"
        case quarterly = "q"
        case semiannual = "sa"
        case annual = "a"
        
        var displayName: String {
            switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            case .quarterly: return "Quarterly"
            case .semiannual: return "Semi-annual"
            case .annual: return "Annual"
            }
        }
        
        var description: String {
            switch self {
            case .daily: return "Daily observations (business days only)"
            case .weekly: return "Weekly observations (typically Friday)"
            case .monthly: return "Monthly observations (end of month)"
            case .quarterly: return "Quarterly observations (end of quarter)"
            case .semiannual: return "Semi-annual observations (June & December)"
            case .annual: return "Annual observations (end of year)"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            sidebarView
        } detail: {
            detailView
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $showingSearch) {
            searchView
        }
        .sheet(isPresented: $showingDateRangePicker) {
            dateRangePickerView
        }
        .sheet(isPresented: $showingDataFrequencyPicker) {
            dataFrequencyPickerView
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Sidebar View
    
    private var sidebarView: some View {
        List {
            Section("Quick Start") {
                Button(action: { showingSearch = true }) {
                    Label("Search Data Series", systemImage: "magnifyingglass")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
            }
            
            Section("Economic Indicators") {
                Group {
                    Button("GDP - Gross Domestic Product") {
                        Task { await loadSeries("GDP") }
                    }
                    
                    Button("UNRATE - Unemployment Rate") {
                        Task { await loadSeries("UNRATE") }
                    }
                    
                    Button("FEDFUNDS - Federal Funds Rate") {
                        Task { await loadSeries("FEDFUNDS") }
                    }
                    
                    Button("CPIAUCSL - Consumer Price Index") {
                        Task { await loadSeries("CPIAUCSL") }
                    }
                    
                    Button("GS10 - 10-Year Treasury Rate") {
                        Task { await loadSeries("GS10") }
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
            }
            
            Section("Financial Markets") {
                Group {
                    Button("DGS2 - 2-Year Treasury Rate") {
                        Task { await loadSeries("DGS2") }
                    }
                    
                    Button("TB3MS - 3-Month Treasury Bill") {
                        Task { await loadSeries("TB3MS") }
                    }
                    
                    Button("DEXUSEU - USD/EUR Exchange Rate") {
                        Task { await loadSeries("DEXUSEU") }
                    }
                    
                    Button("DFEDTARU - Fed Target Rate") {
                        Task { await loadSeries("DFEDTARU") }
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
            }
            
            Section("Employment & Labor") {
                Group {
                    Button("PAYEMS - Total Nonfarm Employment") {
                        Task { await loadSeries("PAYEMS") }
                    }
                    
                    Button("CIVPART - Labor Force Participation") {
                        Task { await loadSeries("CIVPART") }
                    }
                    
                    Button("AWHMAN - Average Weekly Hours") {
                        Task { await loadSeries("AWHMAN") }
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
            }
            
            if !seriesCollection.isEmpty {
                Section("Active Series (\(seriesCollection.count))") {
                    ForEach(seriesCollection, id: \.id) { series in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(series.id)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text(series.title)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                
                                HStack {
                                    Text(series.units)
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                    
                                    Spacer()
                                    
                                    Text(series.frequency)
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: { removeSeries(series.id) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .help("Remove \(series.id)")
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                    }
                }
            }
            
            if !seriesCollection.isEmpty {
                Section("Actions") {
                    Button("Clear All Series") {
                        seriesCollection.removeAll()
                    }
                    .foregroundStyle(.red)
                    .buttonStyle(.plain)
                    
                    if let lastSeries = seriesCollection.last {
                        Menu("Add Compatible Series") {
                            let recommendations = getRecommendations(for: lastSeries)
                            ForEach(recommendations.prefix(5), id: \.self) { seriesId in
                                Button(seriesId) {
                                    Task { await loadSeries(seriesId) }
                                }
                            }
                            
                            if recommendations.isEmpty {
                                Text("No compatible series available")
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.primary)
                    }
                }
            }
        }
        .navigationTitle("FRED Economic Data")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Search", systemImage: "magnifyingglass") {
                    showingSearch = true
                }
                .help("Search for data series")
                
                Button("Date Range", systemImage: "calendar") {
                    showingDateRangePicker = true
                }
                .help("Select date range")
                
                Button("Frequency", systemImage: "clock") {
                    showingDataFrequencyPicker = true
                }
                .help("Select data frequency")
            }
        }
    }
    
    // MARK: - Detail View
    
    private var detailView: some View {
        VStack {
            if isLoading {
                ProgressView("Loading FRED data...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if seriesCollection.isEmpty {
                emptyStateView
            } else {
                dataDisplayView
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Picker("View Mode", selection: $selectedView) {
                    ForEach(ViewMode.allCases, id: \.rawValue) { mode in
                        Label(mode.rawValue, systemImage: mode.systemImage)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            ToolbarItemGroup(placement: .secondaryAction) {
                Button("Clear All", systemImage: "trash") {
                    seriesCollection.removeAll()
                }
                .disabled(seriesCollection.isEmpty)
                
                Button("Add Series", systemImage: "plus") {
                    showingSearch = true
                }
                
                Menu("Recommendations", systemImage: "lightbulb") {
                    if let lastSeries = seriesCollection.last {
                        let recommendations = getRecommendations(for: lastSeries)
                        ForEach(recommendations.prefix(5), id: \.self) { seriesId in
                            Button(seriesId) {
                                Task { await loadSeries(seriesId) }
                            }
                        }
                        
                        if recommendations.isEmpty {
                            Text("No compatible series found")
                        }
                    } else {
                        Text("Add a series to see recommendations")
                    }
                }
                .disabled(seriesCollection.isEmpty)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            Text("FRED Economic Data Explorer")
                .font(.title)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Browse categories or search to discover economic data series from the Federal Reserve Bank of St. Louis")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Features:")
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("Multiple data series on one chart", systemImage: "chart.line.uptrend.xyaxis")
                    Label("Interactive tables with sorting", systemImage: "tablecells")
                    Label("Customizable date ranges", systemImage: "calendar")
                    Label("Multiple data frequencies", systemImage: "clock")
                    Label("Smart recommendations", systemImage: "lightbulb")
                }
                .font(.callout)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                Button("Search Data Series", systemImage: "magnifyingglass") {
                    showingSearch = true
                }
                .buttonStyle(.borderedProminent)
                
                HStack(spacing: 12) {
                    Button("GDP") { Task { await loadSeries("GDP") } }
                    Button("Unemployment") { Task { await loadSeries("UNRATE") } }
                    Button("Fed Funds") { Task { await loadSeries("FEDFUNDS") } }
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Data Display View
    
    private var dataDisplayView: some View {
        VStack(spacing: 0) {
            // Data info header
            dataInfoHeader
            
            Divider()
            
            // Main content
            Group {
                switch selectedView {
                case .chart:
                    chartView
                case .table:
                    tableView
                }
            }
        }
    }
    
    private var dataInfoHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Data Series (\(seriesCollection.count))")
                        .font(.headline)
                    
                    if seriesCollection.count == 1, let series = seriesCollection.first {
                        Text(series.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    } else if seriesCollection.count > 1 {
                        Text("Multiple series selected")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Frequency: \(selectedFrequency.displayName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("Range: \(formattedDateRange)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(totalObservationsCount) observations")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Series tags
            if !seriesCollection.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(seriesCollection, id: \.id) { series in
                            seriesTag(for: series)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func seriesTag(for series: FREDSeries) -> some View {
        HStack(spacing: 6) {
            Text(series.id)
                .font(.caption)
                .fontWeight(.medium)
            
            Button(action: { removeSeries(series.id) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.accentColor.opacity(0.1))
        .foregroundStyle(.primary)
        .cornerRadius(12)
    }
    
    // MARK: - Chart View
    
    private var chartView: some View {
        Chart {
            ForEach(seriesCollection, id: \.id) { series in
                ForEach(filteredObservations(for: series), id: \.date) { observation in
                    if let value = observation.value {
                        LineMark(
                            x: .value("Date", observation.date),
                            y: .value("Value", value),
                            series: .value("Series", series.id)
                        )
                        .foregroundStyle(by: .value("Series", series.id))
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .frame(minHeight: 400)
        .padding()
    }
    
    // MARK: - Table View
    
    private var tableView: some View {
        tableContent
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .padding()
    }
    
    private var tableContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                tableHeader
                Divider()
                tableDataRows
            }
        }
    }
    
    private var tableHeader: some View {
        HStack {
            Text("Date")
                .font(.headline)
                .frame(width: 150, alignment: .leading)
                .padding()
            
            ForEach(seriesCollection, id: \.id) { series in
                Text(series.id)
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                    .padding()
            }
            Spacer()
        }
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private var tableDataRows: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(combinedTableData.enumerated()), id: \.element.id) { index, dataPoint in
                tableRow(for: dataPoint, at: index)
            }
        }
    }
    
    private func tableRow(for dataPoint: TableDataPoint, at index: Int) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(dataPoint.date, style: .date)
                    .font(.system(.body, design: .monospaced))
                    .frame(width: 150, alignment: .leading)
                    .padding()
                
                ForEach(seriesCollection, id: \.id) { series in
                    tableCell(for: dataPoint, series: series)
                }
                Spacer()
            }
            .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.1))
            
            if index < combinedTableData.count - 1 {
                Divider()
            }
        }
    }
    
    private func tableCell(for dataPoint: TableDataPoint, series: FREDSeries) -> some View {
        Group {
            if let value = dataPoint.values[series.id] {
                Text(formatValue(value, units: series.units))
                    .font(.system(.body, design: .monospaced))
            } else {
                Text("—")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 150, alignment: .leading)
        .padding()
    }
    
    // MARK: - Search View
    
    private var searchView: some View {
        NavigationStack {
            VStack {
                searchInterface
                
                if isSearching {
                    ProgressView("Searching FRED database...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    searchEmptyState
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("Search Data Series")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingSearch = false
                    }
                }
            }
        }
        .frame(minWidth: 700, minHeight: 600)
    }
    
    private var searchInterface: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Search FRED data series...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        Task { await performSearchAsync() }
                    }
                
                Button("Search") {
                    Task { await performSearchAsync() }
                }
                .disabled(searchText.isEmpty || isSearching)
                .buttonStyle(.borderedProminent)
            }
            
            Text("Search by series ID (e.g., GDP, UNRATE) or description (e.g., \"unemployment rate\")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private var searchEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No series found for '\(searchText)'")
                .foregroundStyle(.secondary)
            Text("Try searching for common terms like 'GDP', 'unemployment', 'inflation', or 'interest rates'")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var searchResultsList: some View {
        List(searchResults, id: \.id) { series in
            SearchResultRow(
                series: series,
                onAdd: { addSearchResult($0) },
                isAdded: seriesCollection.contains { $0.id == series.id }
            )
        }
    }
    
    // MARK: - Date Range Picker
    
    private var dateRangePickerView: some View {
        NavigationStack {
            Form {
                Section("Custom Date Range") {
                    DatePicker("Start Date", selection: $selectedStartDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $selectedEndDate, displayedComponents: .date)
                }
                
                Section("Quick Ranges") {
                    ForEach(quickDateRanges, id: \.title) { range in
                        Button(range.title) {
                            selectedStartDate = range.startDate
                            selectedEndDate = range.endDate
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Select Date Range")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingDateRangePicker = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        showingDateRangePicker = false
                    }
                }
            }
        }
        .frame(width: 450, height: 500)
    }
    
    // MARK: - Data Frequency Picker
    
    private var dataFrequencyPickerView: some View {
        NavigationStack {
            List(DataFrequency.allCases, id: \.rawValue, selection: $selectedFrequency) { frequency in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(frequency.displayName)
                            .font(.headline)
                        Text(frequency.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if frequency == selectedFrequency {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedFrequency = frequency
                }
            }
            .navigationTitle("Data Frequency")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingDataFrequencyPicker = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        showingDataFrequencyPicker = false
                    }
                }
            }
        }
        .frame(width: 450, height: 400)
    }
    
    // MARK: - Helper Methods
    
    private func getRecommendations(for series: FREDSeries) -> [String] {
        return fredService.getRecommendationsBasedOnUnits(for: series.id, currentUnits: series.units)
    }
    
    @MainActor
    private func loadSeries(_ seriesId: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let series = try await fredService.fetchSeries(id: seriesId)
            if !seriesCollection.contains(where: { $0.id == series.id }) {
                seriesCollection.append(series)
            }
        } catch {
            errorMessage = "Failed to load series \(seriesId): \(error.localizedDescription)"
        }
    }
    
    private func removeSeries(_ seriesId: String) {
        seriesCollection.removeAll { $0.id == seriesId }
    }
    
    private func loadCategorySeries(_ category: FREDCategory) {
        // This would load popular series from the selected category
        // For now, we'll load some sample series based on category name
        let sampleSeries: [String]
        switch category.name.lowercased() {
        case let name where name.contains("gdp"):
            sampleSeries = ["GDP", "GDPC1"]
        case let name where name.contains("employment") || name.contains("unemployment"):
            sampleSeries = ["UNRATE", "PAYEMS"]
        case let name where name.contains("inflation") || name.contains("price"):
            sampleSeries = ["CPIAUCSL", "CPILFESL"]
        case let name where name.contains("rate") || name.contains("treasury"):
            sampleSeries = ["FEDFUNDS", "GS10"]
        default:
            sampleSeries = ["GDP"]
        }
        
        Task {
            for seriesId in sampleSeries.prefix(2) {
                await loadSeries(seriesId)
            }
        }
    }
    
    private func performSearch() {
        Task { await performSearchAsync() }
    }
    
    @MainActor
    private func performSearchAsync() async {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        defer { isSearching = false }
        
        do {
            searchResults = try await fredService.searchSeries(query: searchText)
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
        }
    }
    
    private func addSearchResult(_ seriesInfo: FREDSeriesInfo) {
        Task {
            await loadSeries(seriesInfo.id)
            showingSearch = false
        }
    }
    
    private func filteredObservations(for series: FREDSeries) -> [FREDObservation] {
        return series.observations.filter { observation in
            observation.date >= selectedStartDate && observation.date <= selectedEndDate
        }
    }
    
    private var combinedTableData: [TableDataPoint] {
        var allDates: Set<Date> = []
        
        // Collect all unique dates
        for series in seriesCollection {
            for observation in filteredObservations(for: series) {
                allDates.insert(observation.date)
            }
        }
        
        // Create table data points
        return allDates.sorted().map { date in
            var values: [String: Double] = [:]
            
            for series in seriesCollection {
                if let observation = series.observations.first(where: { $0.date == date }) {
                    values[series.id] = observation.value
                }
            }
            
            return TableDataPoint(date: date, values: values)
        }
    }
    
    private func formatValue(_ value: Double, units: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if units.lowercased().contains("percent") {
            formatter.numberStyle = .percent
            formatter.multiplier = 0.01
        } else if units.lowercased().contains("billion") {
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
    
    private var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "\(formatter.string(from: selectedStartDate)) - \(formatter.string(from: selectedEndDate))"
    }
    
    private var totalObservationsCount: Int {
        seriesCollection.reduce(0) { total, series in
            total + filteredObservations(for: series).count
        }
    }
    
    private var quickDateRanges: [QuickDateRange] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            QuickDateRange(title: "Last 3 Months",
                          startDate: calendar.date(byAdding: .month, value: -3, to: now) ?? now,
                          endDate: now),
            QuickDateRange(title: "Last Year",
                          startDate: calendar.date(byAdding: .year, value: -1, to: now) ?? now,
                          endDate: now),
            QuickDateRange(title: "Last 5 Years",
                          startDate: calendar.date(byAdding: .year, value: -5, to: now) ?? now,
                          endDate: now),
            QuickDateRange(title: "Last 10 Years",
                          startDate: calendar.date(byAdding: .year, value: -10, to: now) ?? now,
                          endDate: now),
            QuickDateRange(title: "2020-Present",
                          startDate: calendar.date(from: DateComponents(year: 2020, month: 1, day: 1)) ?? now,
                          endDate: now),
            QuickDateRange(title: "2008 Financial Crisis",
                          startDate: calendar.date(from: DateComponents(year: 2007, month: 1, day: 1)) ?? now,
                          endDate: calendar.date(from: DateComponents(year: 2010, month: 12, day: 31)) ?? now)
        ]
    }
}

// MARK: - Supporting Views

struct CategoryRowView: View {
    let category: FREDCategory
    let onSelect: (FREDCategory) -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: category.children.isEmpty ? "chart.xyaxis.line" : "folder")
                
                Text(category.name)
                    .font(.headline)
                
                Spacer()
                
                if category.seriesCount > 0 {
                    Text("\(category.seriesCount)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                }
                
                if !category.children.isEmpty {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if category.children.isEmpty {
                    onSelect(category)
                } else {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
            
            if isExpanded && !category.children.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(category.children, id: \.id) { child in
                        CategoryRowView(category: child, onSelect: onSelect)
                            .padding(.leading, 20)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 2)
    }
}

struct SearchResultRow: View {
    let series: FREDSeriesInfo
    let onAdd: (FREDSeriesInfo) -> Void
    let isAdded: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(series.id)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(series.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(series.frequency)
                    Text("•")
                    Text(series.units)
                    if series.popularityRank > 0 {
                        Text("•")
                        Text("Popularity: \(series.popularityRank)")
                    }
                }
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            Button(isAdded ? "Added" : "Add") {
                if !isAdded {
                    onAdd(series)
                }
            }
            .disabled(isAdded)
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Helper Structures

struct QuickDateRange {
    let title: String
    let startDate: Date
    let endDate: Date
}

struct TableDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let values: [String: Double]
}

#Preview {
    FREDDataView()
        .modelContainer(for: FinancialCalculation.self, inMemory: true)
}
//
//  InteractiveDataTables.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on Phase 3 implementation.
//

import SwiftUI

/// Interactive data table with sorting, filtering, and export capabilities
struct InteractiveDataTable<RowData: Identifiable>: View {
    let title: String
    let data: [RowData]
    let columns: [TableColumn<RowData>]
    let rowHeight: CGFloat
    let showSummary: Bool
    let allowExport: Bool
    
    @State private var sortColumn: String?
    @State private var sortAscending: Bool = true
    @State private var searchText: String = ""
    @State private var selectedRows: Set<RowData.ID> = []
    @State private var showingExportOptions: Bool = false
    
    init(
        title: String,
        data: [RowData],
        columns: [TableColumn<RowData>],
        rowHeight: CGFloat = 36,
        showSummary: Bool = true,
        allowExport: Bool = true
    ) {
        self.title = title
        self.data = data
        self.columns = columns
        self.rowHeight = rowHeight
        self.showSummary = showSummary
        self.allowExport = allowExport
    }
    
    var filteredAndSortedData: [RowData] {
        var result = data
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { row in
                columns.contains { column in
                    column.searchableText(row).localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        // Apply sorting
        if let sortColumn = sortColumn,
           let column = columns.first(where: { $0.id == sortColumn }) {
            result.sort { row1, row2 in
                let comparison = column.compare(row1, row2)
                return sortAscending ? comparison : !comparison
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with title and controls
            headerSection
            
            // Search bar
            if data.count > 10 {
                searchBar
            }
            
            // Table content
            tableContent
            
            // Summary footer
            if showSummary {
                summaryFooter
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.windowBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                )
        )
        .sheet(isPresented: $showingExportOptions) {
            ExportOptionsView(
                data: Array(selectedRows.isEmpty ? filteredAndSortedData : filteredAndSortedData.filter { selectedRows.contains($0.id) }),
                columns: columns,
                title: title
            )
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            if allowExport {
                Button(action: { showingExportOptions = true }) {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(filteredAndSortedData.isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var tableContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Table header
                tableHeader
                
                Divider()
                
                // Table rows
                if filteredAndSortedData.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredAndSortedData) { row in
                            tableRow(row)
                            
                            if row.id != filteredAndSortedData.last?.id {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 500)
    }
    
    @ViewBuilder
    private var tableHeader: some View {
        HStack(spacing: 0) {
            // Selection checkbox
            if allowExport {
                Button(action: toggleAllSelection) {
                    Image(systemName: selectionIcon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .frame(width: 30)
                .padding(.horizontal, 8)
            }
            
            // Column headers
            ForEach(columns) { column in
                Button(action: { toggleSort(column.id) }) {
                    HStack {
                        Text(column.title)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if sortColumn == column.id {
                            Image(systemName: sortAscending ? "chevron.up" : "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
                .frame(width: column.width)
                .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
    }
    
    @ViewBuilder
    private func tableRow(_ row: RowData) -> some View {
        HStack(spacing: 0) {
            // Selection checkbox
            if allowExport {
                Button(action: { toggleSelection(row.id) }) {
                    Image(systemName: selectedRows.contains(row.id) ? "checkmark.square.fill" : "square")
                        .font(.caption)
                        .foregroundColor(selectedRows.contains(row.id) ? .accentColor : .secondary)
                }
                .buttonStyle(.plain)
                .frame(width: 30)
                .padding(.horizontal, 8)
            }
            
            // Row cells
            ForEach(columns) { column in
                column.content(row)
                    .frame(width: column.width, alignment: column.alignment)
                    .padding(.horizontal, 8)
            }
        }
        .frame(height: rowHeight)
        .background(
            selectedRows.contains(row.id) 
                ? Color.accentColor.opacity(0.1)
                : Color.clear
        )
        .onHover { isHovering in
            if isHovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: searchText.isEmpty ? "tray" : "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text(searchText.isEmpty ? "No data available" : "No results found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if !searchText.isEmpty {
                Button("Clear Search") {
                    searchText = ""
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    @ViewBuilder
    private var summaryFooter: some View {
        HStack {
            Text("\(filteredAndSortedData.count) rows")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if !selectedRows.isEmpty {
                Text("(\(selectedRows.count) selected)")
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            // Column summaries
            ForEach(columns.filter { $0.showSummary }) { column in
                if let summaryFunc = column.summary {
                    let summary = summaryFunc(filteredAndSortedData)
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(column.summaryLabel ?? "Total")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(summary)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
    }
    
    // MARK: - Helper Methods
    
    private func toggleSort(_ columnId: String) {
        if sortColumn == columnId {
            sortAscending.toggle()
        } else {
            sortColumn = columnId
            sortAscending = true
        }
    }
    
    private func toggleSelection(_ id: RowData.ID) {
        if selectedRows.contains(id) {
            selectedRows.remove(id)
        } else {
            selectedRows.insert(id)
        }
    }
    
    private func toggleAllSelection() {
        if selectedRows.count == filteredAndSortedData.count {
            selectedRows.removeAll()
        } else {
            selectedRows = Set(filteredAndSortedData.map { $0.id })
        }
    }
    
    private var selectionIcon: String {
        if selectedRows.isEmpty {
            return "square"
        } else if selectedRows.count == filteredAndSortedData.count {
            return "checkmark.square.fill"
        } else {
            return "minus.square"
        }
    }
}

/// Table column definition
struct TableColumn<RowData>: Identifiable {
    let id: String
    let title: String
    let width: CGFloat
    let alignment: Alignment
    let content: (RowData) -> AnyView
    let searchableText: (RowData) -> String
    let compare: (RowData, RowData) -> Bool
    let showSummary: Bool
    let summaryLabel: String?
    let summary: (([RowData]) -> String)?
    
    init<Content: View>(
        id: String,
        title: String,
        width: CGFloat,
        alignment: Alignment = .leading,
        showSummary: Bool = false,
        summaryLabel: String? = nil,
        content: @escaping (RowData) -> Content,
        searchableText: @escaping (RowData) -> String,
        compare: @escaping (RowData, RowData) -> Bool,
        summary: (([RowData]) -> String)? = nil
    ) {
        self.id = id
        self.title = title
        self.width = width
        self.alignment = alignment
        self.showSummary = showSummary
        self.summaryLabel = summaryLabel
        self.content = { AnyView(content($0)) }
        self.searchableText = searchableText
        self.compare = compare
        self.summary = summary
    }
}

/// Export options view
struct ExportOptionsView<RowData>: View {
    let data: [RowData]
    let columns: [TableColumn<RowData>]
    let title: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var exportFormat: ExportFormat = .csv
    @State private var includeHeaders: Bool = true
    @State private var selectedColumns: Set<String> = []
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case excel = "Excel"
        case pdf = "PDF"
        case json = "JSON"
        
        var fileExtension: String {
            switch self {
            case .csv: return "csv"
            case .excel: return "xlsx"
            case .pdf: return "pdf"
            case .json: return "json"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Export Options")
                .font(.headline)
            
            // Format selection
            Picker("Format", selection: $exportFormat) {
                ForEach(ExportFormat.allCases, id: \.self) { format in
                    Text(format.rawValue).tag(format)
                }
            }
            .pickerStyle(.segmented)
            
            // Options
            Toggle("Include Headers", isOn: $includeHeaders)
            
            // Column selection
            GroupBox("Columns to Export") {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(columns) { column in
                            Toggle(column.title, isOn: Binding(
                                get: { selectedColumns.contains(column.id) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedColumns.insert(column.id)
                                    } else {
                                        selectedColumns.remove(column.id)
                                    }
                                }
                            ))
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
            
            // Action buttons
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Spacer()
                
                Button("Export") {
                    performExport()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedColumns.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)
        .onAppear {
            // Select all columns by default
            selectedColumns = Set(columns.map { $0.id })
        }
    }
    
    private func performExport() {
        // Implementation would handle actual export logic
        print("Exporting \(data.count) rows in \(exportFormat.rawValue) format")
    }
}

/// Specialized amortization table
struct AmortizationTable: View {
    let entries: [AmortizationEntry]
    let currency: Currency
    let showFullSchedule: Bool

    @State private var displayedEntries: Int = 12

    var visibleEntries: [AmortizationEntry] {
        if showFullSchedule {
            return entries
        } else {
            return Array(entries.prefix(displayedEntries))
        }
    }

    private var tableColumns: [TableColumn<AmortizationEntry>] {
        [
            TableColumn(
                id: "period",
                title: "Period",
                width: 80,
                alignment: .center,
                content: { entry in
                    Text("\(entry.paymentNumber)")
                        .font(.system(.body, design: .monospaced))
                },
                searchableText: { "\($0.paymentNumber)" },
                compare: { $0.paymentNumber < $1.paymentNumber }
            ),
            TableColumn(
                id: "payment",
                title: "Payment",
                width: 120,
                alignment: .trailing,
                showSummary: true,
                summaryLabel: "Total",
                content: { entry in
                    Text(currency.formatValue(entry.payment))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.primary)
                },
                searchableText: { currency.formatValue($0.payment) },
                compare: { $0.payment < $1.payment },
                summary: { entries in
                    currency.formatValue(entries.reduce(0, { $0 + $1.payment }))
                }
            ),
            TableColumn(
                id: "principal",
                title: "Principal",
                width: 120,
                alignment: .trailing,
                showSummary: true,
                content: { entry in
                    Text(currency.formatValue(entry.principalPayment))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                },
                searchableText: { currency.formatValue($0.principalPayment) },
                compare: { $0.principalPayment < $1.principalPayment },
                summary: { entries in
                    currency.formatValue(entries.reduce(0) { $0 + $1.principalPayment })
                }
            ),
            TableColumn(
                id: "interest",
                title: "Interest",
                width: 120,
                alignment: .trailing,
                showSummary: true,
                content: { entry in
                    Text(currency.formatValue(entry.interestPayment))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.orange)
                },
                searchableText: { currency.formatValue($0.interestPayment) },
                compare: { $0.interestPayment < $1.interestPayment },
                summary: { entries in
                    currency.formatValue(entries.reduce(0) { $0 + $1.interestPayment })
                }
            ),
            TableColumn(
                id: "balance",
                title: "Balance",
                width: 140,
                alignment: .trailing,
                content: { entry in
                    Text(currency.formatValue(entry.remainingBalance))
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(entry.remainingBalance == 0 ? .bold : .regular)
                        .foregroundColor(entry.remainingBalance == 0 ? .green : .primary)
                },
                searchableText: { currency.formatValue($0.remainingBalance) },
                compare: { $0.remainingBalance < $1.remainingBalance }
            )
        ]
    }

    var body: some View {
        VStack(spacing: 16) {
            InteractiveDataTable(
                title: "Amortization Schedule",
                data: visibleEntries,
                columns: tableColumns
            )
            
            // Show more button if not displaying all entries
            if !showFullSchedule && displayedEntries < entries.count {
                Button(action: {
                    withAnimation {
                        displayedEntries = min(displayedEntries + 12, entries.count)
                    }
                }) {
                    Label("Show More", systemImage: "chevron.down")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
    }
}

/* Preview temporarily disabled to resolve compiler type-checking issues
#Preview {
    VStack(spacing: 20) {
        // Sample data table
        InteractiveDataTable(
            title: "Investment Scenarios",
            data: [
                (id: 1, name: "Conservative", npv: 45000, irr: 8.5, risk: "Low"),
                (id: 2, name: "Moderate", npv: 67000, irr: 12.3, risk: "Medium"),
                (id: 3, name: "Aggressive", npv: 92000, irr: 18.7, risk: "High"),
                (id: 4, name: "Balanced", npv: 58000, irr: 10.2, risk: "Medium")
            ],
            columns: [
                TableColumn(
                    id: "name",
                    title: "Scenario",
                    width: 120,
                    content: { Text($0.name).fontWeight(.medium) },
                    searchableText: { $0.name },
                    compare: { $0.name < $1.name }
                ),
                TableColumn(
                    id: "npv",
                    title: "NPV",
                    width: 100,
                    alignment: .trailing,
                    showSummary: true,
                    content: { Text("$\(String(format: "%,.0f", $0.npv))") },
                    searchableText: { "\($0.npv)" },
                    compare: { $0.npv < $1.npv },
                    summary: { data in
                        "$\(String(format: "%,.0f", data.reduce(0) { $0 + $1.npv }))"
                    }
                ),
                TableColumn(
                    id: "irr",
                    title: "IRR %",
                    width: 80,
                    alignment: .trailing,
                    content: { Text(String(format: "%.1f%%", $0.irr)) },
                    searchableText: { "\($0.irr)" },
                    compare: { $0.irr < $1.irr }
                ),
                TableColumn(
                    id: "risk",
                    title: "Risk",
                    width: 80,
                    alignment: .center,
                    content: { row in
                        Text(row.risk)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(row.risk == "Low" ? Color.green.opacity(0.2) :
                                          row.risk == "Medium" ? Color.orange.opacity(0.2) :
                                          Color.red.opacity(0.2))
                            )
                    },
                    searchableText: { $0.risk },
                    compare: { $0.risk < $1.risk }
                )
            ]
        )
        
        // Sample amortization table
        AmortizationTable(
            entries: generateSampleAmortization(),
            currency: .usd,
            showFullSchedule: false
        )
    }
    .padding()
    .frame(width: 700)
}

// Generate sample data for preview
private func generateSampleAmortization() -> [AmortizationEntry] {
    var entries: [AmortizationEntry] = []
    let principal = 200000.0
    let rate = 0.045 / 12
    let periods = 360
    let payment = 1013.37
    
    var balance = principal
    var cumulativeInterest = 0.0
    var cumulativePrincipal = 0.0
    
    for period in 1...24 { // First 24 months for preview
        let interestPayment = balance * rate
        let principalPayment = payment - interestPayment
        balance -= principalPayment
        cumulativeInterest += interestPayment
        cumulativePrincipal += principalPayment
        
        entries.append(AmortizationEntry(
            period: period,
            totalPayment: payment,
            principalPayment: principalPayment,
            interestPayment: interestPayment,
            remainingBalance: max(0, balance),
            cumulativeInterest: cumulativeInterest,
            cumulativePrincipal: cumulativePrincipal
        ))
    }

    return entries
}
*/
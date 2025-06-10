




I'll help you study the latest Swift Charts and Swift Tables documentation from Apple. Let me fetch comprehensive documentation on both topics using the available tools.Let me search for Swift Charts and Swift Tables documentation more specifically:Let me search for Apple's official Swift Charts documentation:Let me fetch the official Apple documentation for Swift Charts:Let me search for more specific Swift Charts information:Now let me search for Swift Tables documentation:Let me search for more specific information about column sizing and autofit behavior in Swift Tables:Based on my research of the latest Swift Charts and Swift Tables documentation, I'll provide you with a comprehensive guide on both frameworks.

## Swift Charts

### Overview
Swift Charts is Apple's powerful framework for creating data visualizations in SwiftUI. It provides various chart types and extensive customization options.

### Displaying Multiple Data Series Without Connected Lines

The key to displaying multiple data series on the same chart without having them connect is to use the `series` parameter or `foregroundStyle(by:)` modifier:

```swift
import SwiftUI
import Charts

struct MultiSeriesChart: View {
    struct DataPoint: Identifiable {
        let id = UUID()
        let x: Double
        let y: Double
        let series: String
    }

    let data = [
        // Series 1
        DataPoint(x: 0, y: 10, series: "Series A"),
        DataPoint(x: 1, y: 15, series: "Series A"),
        DataPoint(x: 2, y: 12, series: "Series A"),
        // Series 2
        DataPoint(x: 0, y: 20, series: "Series B"),
        DataPoint(x: 1, y: 18, series: "Series B"),
        DataPoint(x: 2, y: 22, series: "Series B")
    ]

    var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value("X", point.x),
                y: .value("Y", point.y),
                series: .value("Series", point.series) // This separates the lines
            )
            .foregroundStyle(by: .value("Series", point.series))
        }
    }
}
```

### Alternative Approach Using Multiple LineMark
```swift
Chart {
    ForEach(seriesAData) { dataPoint in
        LineMark(
            x: .value("X", dataPoint.x),
            y: .value("Y", dataPoint.y)
        )
        .foregroundStyle(.blue)
        .symbol(Circle())
    }

    ForEach(seriesBData) { dataPoint in
        LineMark(
            x: .value("X", dataPoint.x),
            y: .value("Y", dataPoint.y)
        )
        .foregroundStyle(.red)
        .symbol(Rectangle())
    }
}
```

### Chart Customization

#### Line Styling
```swift
LineMark(x: .value("Day", day), y: .value("Value", value))
    .interpolationMethod(.catmullRom) // Smooth curves
    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10])) // Dashed line
    .symbol {
        Circle()
            .fill(.blue)
            .frame(width: 8, height: 8)
    }
```

#### Color Customization
```swift
Chart {
    // ... your marks
}
.chartForegroundStyleScale([
    "Series A": Color.blue,
    "Series B": Color.red,
    "Series C": Color.green
])
```

#### Axis Customization
```swift
Chart {
    // ... your marks
}
.chartYAxis {
    AxisMarks(position: .leading)
}
.chartXAxis {
    AxisMarks(values: .automatic) { value in
        AxisValueLabel()
        AxisTick()
        AxisGridLine()
    }
}
```

## Swift Tables

### Overview
Swift Tables provides a multi-column table view for macOS and iPadOS (iOS 16+). On iPhone, tables collapse to show only the first column.

### Basic Table Structure
```swift
struct ContentView: View {
    struct Person: Identifiable {
        let id = UUID()
        var name: String
        var age: Int
        var department: String
    }

    @State private var people = [
        Person(name: "John", age: 30, department: "Engineering"),
        Person(name: "Jane", age: 28, department: "Design"),
        Person(name: "Bob", age: 35, department: "Marketing")
    ]

    var body: some View {
        Table(people) {
            TableColumn("Name", value: \.name)
            TableColumn("Age") { person in
                Text("\(person.age)")
            }
            .width(50) // Fixed width

            TableColumn("Department", value: \.department)
                .width(min: 100, ideal: 150, max: 200) // Flexible width
        }
    }
}
```

### Column Width Control
```swift
TableColumn("Name", value: \.name)
    .width(200) // Fixed width

TableColumn("Description", value: \.description)
    .width(min: 100, ideal: 200, max: 300) // Flexible width
```

### Header Styling

#### Table Styles
```swift
Table(data) {
    // columns
}
.tableStyle(.inset) // Default on iPadOS
.tableStyle(.inset(alternatesRowBackgrounds: true)) // macOS only
.tableStyle(.bordered) // macOS only
```

#### Custom Header Appearance
```swift
Table(data) {
    TableColumn("Name") { item in
        Text(item.name)
            .font(.headline)
    }
}
.tableColumnHeaders(.visible) // or .hidden
```

### Selection and Sorting
```swift
struct SortableTable: View {
    @State private var selection = Set<Person.ID>()
    @State private var sortOrder = [KeyPathComparator(\Person.name)]

    var body: some View {
        Table(people, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name)
            TableColumn("Age", value: \.age)
            TableColumn("Department", value: \.department)
        }
        .onChange(of: sortOrder) { _, newOrder in
            people.sort(using: newOrder)
        }
    }
}
```

### Context Menu for Rows
```swift
Table(data) {
    // columns
}
.contextMenu(forSelectionType: Person.ID.self) { items in
    Button("Delete") {
        // Delete selected items
    }
    Button("Edit") {
        // Edit selected items
    }
}
```

### Responsive Design
```swift
@Environment(\.horizontalSizeClass) var sizeClass

TableColumn("Name", value: \.name) { person in
    VStack(alignment: .leading) {
        Text(person.name)
        if sizeClass == .compact {
            Text(person.department)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
```

### Best Practices

1. **Auto-fitting Content**: Tables automatically size columns based on content, but you can provide constraints using `.width()` modifiers
2. **Platform Considerations**: Always test on iPhone, iPad, and Mac to ensure proper layout
3. **Performance**: Tables use lazy loading, so they're efficient with large datasets
4. **Sorting**: Always bind sortOrder and implement the onChange handler
5. **Selection**: Use single selection for detail views, multiple selection for batch operations

These frameworks provide powerful, native solutions for data visualization and tabular display in SwiftUI applications. The key is understanding their modifiers and how they adapt across different platforms.

# Comprehensive Guide to Styling SwiftUI Tables and Swift Charts

## Swift Tables Styling Guide

### Column Header Customization

#### Basic Header Styling
SwiftUI Tables have limited built-in header customization, but you can style headers using Text views:

```swift
Table(data) {
    TableColumn(Text("Column Name")
        .foregroundStyle(.blue)
        .font(.headline)
        .bold()
    ) { item in
        Text(item.name)
    }
}
```

#### Text Wrapping in Headers (Workaround)
Native multi-line headers aren't directly supported, but you can achieve this effect:

```swift
// Option 1: Using line breaks in Text
TableColumn(Text("First Line\nSecond Line")
    .multilineTextAlignment(.center)
    .font(.caption)
) { item in
    Text(item.value)
}

// Option 2: Custom header with fixed height
Table(data) {
    TableColumn("Name") { item in
        VStack(alignment: .leading) {
            Text("Customer")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("Name")
                .font(.caption)
                .bold()
        }
        .frame(height: 40)
    }
}
.frame(minHeight: 300)
```

### Column Width Management

```swift
Table(data) {
    // Fixed width
    TableColumn("ID", value: \.id)
        .width(50)

    // Flexible width with constraints
    TableColumn("Name", value: \.name)
        .width(min: 100, ideal: 200, max: 300)

    // Last column takes remaining space
    TableColumn("Description", value: \.description)
}
```

### Table Styles

```swift
// iOS/iPadOS - Limited to inset style
Table(data) { /* columns */ }
    .tableStyle(.inset)

// macOS - Additional styles available
Table(data) { /* columns */ }
    .tableStyle(.bordered)
    .tableStyle(.bordered(alternatesRowBackgrounds: false))
    .tableStyle(.inset(alternatesRowBackgrounds: true))
```

### Header Visibility Control

```swift
Table(data) { /* columns */ }
    .tableColumnHeaders(.visible) // or .hidden
```

### Column Alignment (Limited Support)
Direct column alignment isn't supported, but you can align content within cells:

```swift
TableColumn("Price") { item in
    Text(String(format: "$%.2f", item.price))
        .frame(maxWidth: .infinity, alignment: .trailing)
}
.width(100)
```

### Responsive Design for Compact Environments

```swift
struct ResponsiveTable: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        Table(data) {
            TableColumn("Name", value: \.name) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    if sizeClass == .compact {
                        // Show additional info in compact mode
                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if sizeClass != .compact {
                TableColumn("Details", value: \.details)
            }
        }
    }
}
```

### Row Selection and Context Menus

```swift
struct SelectableTable: View {
    @State private var selection = Set<Item.ID>()

    var body: some View {
        Table(items, selection: $selection) {
            TableColumn("Name", value: \.name)
            TableColumn("Status", value: \.status)
        }
        .contextMenu(forSelectionType: Item.ID.self) { selectedIds in
            Button("Delete Selected") {
                deleteItems(ids: selectedIds)
            }
            Button("Export Selected") {
                exportItems(ids: selectedIds)
            }
        }
    }
}
```

### Sorting with Custom Comparators

```swift
struct SortableTable: View {
    @State private var items = Item.sampleData
    @State private var sortOrder = [
        KeyPathComparator(\Item.name, order: .forward)
    ]

    var body: some View {
        Table(items, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name)
            TableColumn("Date", value: \.date) { item in
                Text(item.date, style: .date)
            }
            TableColumn("Amount", value: \.amount) { item in
                Text(item.amount, format: .currency(code: "USD"))
            }
        }
        .onChange(of: sortOrder) { _, newOrder in
            items.sort(using: newOrder)
        }
    }
}
```

## Swift Charts Comprehensive Styling Guide

### Chart Container Styling

```swift
Chart {
    // Your marks here
}
.frame(height: 300)
.padding()
.background(Color.gray.opacity(0.1))
.cornerRadius(10)
```

### Plot Area Customization

```swift
Chart {
    // marks
}
.chartPlotStyle { plotArea in
    plotArea
        .frame(height: 250)
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.1), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .border(Color.blue.opacity(0.3), width: 1)
        .cornerRadius(8)
}
```

### Background and Overlay

```swift
Chart(data) {
    LineMark(
        x: .value("Date", $0.date),
        y: .value("Value", $0.value)
    )
}
.chartBackground { proxy in
    // Add background elements
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.mint.opacity(0.1))
}
.chartOverlay { proxy in
    // Add overlay elements for interaction
    GeometryReader { geometry in
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture { location in
                // Handle tap at location
                let plotAreaFrame = proxy.plotAreaFrame
                // Convert location to data coordinates
            }
    }
}
```

### Axis Customization

#### X-Axis Styling
```swift
Chart(data) {
    LineMark(x: .value("Date", $0.date), y: .value("Value", $0.value))
}
.chartXAxis {
    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 7)) { value in
        AxisGridLine(
            centered: true,
            stroke: StrokeStyle(lineWidth: 0.5, dash: [5, 5])
        )
        .foregroundStyle(Color.gray.opacity(0.3))

        AxisTick(
            centered: false,
            stroke: StrokeStyle(lineWidth: 2)
        )
        .foregroundStyle(Color.primary)

        AxisValueLabel(
            centered: false,
            anchor: .top,
            multiLabelAlignment: .center
        ) {
            if let date = value.as(Date.self) {
                VStack {
                    Text(date.formatted(.dateTime.day()))
                        .font(.caption2)
                    Text(date.formatted(.dateTime.month(.abbreviated)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```

#### Y-Axis Styling
```swift
.chartYAxis {
    AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) { value in
        AxisGridLine(
            centered: true,
            stroke: StrokeStyle(lineWidth: 0.5)
        )
        .foregroundStyle(Color.gray.opacity(0.2))

        AxisValueLabel(
            centered: false,
            horizontalSpacing: 10
        ) {
            if let intValue = value.as(Int.self) {
                Text("\(intValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
```

### Scale Customization

```swift
Chart(data) {
    LineMark(x: .value("X", $0.x), y: .value("Y", $0.y))
}
.chartXScale(domain: 0...100, type: .linear)
.chartYScale(domain: -50...150, type: .linear)
// For log scale:
// .chartYScale(domain: 1...1000, type: .log)
```

### Multiple Series Styling

```swift
Chart {
    ForEach(seriesData) { series in
        ForEach(series.points) { point in
            LineMark(
                x: .value("X", point.x),
                y: .value("Y", point.y),
                series: .value("Series", series.name)
            )
            .foregroundStyle(by: .value("Series", series.name))
            .symbol(by: .value("Series", series.name))
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 2))
        }
    }
}
.chartForegroundStyleScale([
    "Series A": Color.blue,
    "Series B": Color.red,
    "Series C": Color.green
])
.chartSymbolScale([
    "Series A": Circle(),
    "Series B": Square(),
    "Series C": Diamond()
])
```

### Legend Customization

```swift
Chart {
    // marks
}
.chartLegend(position: .top, alignment: .leading) {
    HStack(spacing: 20) {
        ForEach(["Series A", "Series B"], id: \.self) { series in
            HStack(spacing: 5) {
                Circle()
                    .fill(seriesColor(for: series))
                    .frame(width: 10, height: 10)
                Text(series)
                    .font(.caption)
            }
        }
    }
}
// Or hide the legend
.chartLegend(.hidden)
```

### Interactive Features

```swift
struct InteractiveChart: View {
    @State private var selectedElement: DataPoint?
    @State private var plotAreaFrame: CGRect = .zero

    var body: some View {
        Chart(data) {
            ForEach($0) { point in
                LineMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )

                if selectedElement?.id == point.id {
                    PointMark(
                        x: .value("X", point.x),
                        y: .value("Y", point.y)
                    )
                    .foregroundStyle(.red)
                    .symbolSize(100)

                    RuleMark(x: .value("X", point.x))
                        .foregroundStyle(.gray.opacity(0.3))
                        .lineStyle(StrokeStyle(dash: [5, 5]))
                }
            }
        }
        .chartBackground { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onContinuousHover { phase in
                        switch phase {
                        case .active(let location):
                            if let dataPoint = findDataPoint(at: location,
                                                            proxy: proxy,
                                                            geometry: geometry) {
                                selectedElement = dataPoint
                            }
                        case .ended:
                            selectedElement = nil
                        }
                    }
            }
        }
    }
}
```

### Annotations and Reference Lines

```swift
Chart(data) {
    ForEach($0) { point in
        LineMark(x: .value("X", point.x), y: .value("Y", point.y))
    }

    // Average line
    RuleMark(y: .value("Average", averageValue))
        .foregroundStyle(.orange)
        .lineStyle(StrokeStyle(lineWidth: 2, dash: [10, 5]))
        .annotation(position: .top, alignment: .trailing) {
            Label("Average: \(averageValue, format: .number)",
                  systemImage: "chart.line.uptrend.xyaxis")
                .padding(4)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(4)
        }

    // Threshold area
    RectangleMark(
        xStart: .value("Start", xMin),
        xEnd: .value("End", xMax),
        yStart: .value("Bottom", thresholdMin),
        yEnd: .value("Top", thresholdMax)
    )
    .foregroundStyle(.red.opacity(0.1))
}
```

### Gradient and Advanced Styling

```swift
struct GradientChart: View {
    let gradient = LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        Chart(data) {
            ForEach($0) { point in
                LineMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(gradient)
                .lineStyle(StrokeStyle(lineWidth: 3))

                AreaMark(
                    x: .value("X", point.x),
                    y: .value("Y", point.y)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [gradient.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}
```

### Performance Optimization

```swift
// For large datasets, use data aggregation
Chart {
    ForEach(aggregatedData) { bucket in
        RectangleMark(
            x: .value("Time", bucket.timeRange),
            y: .value("Average", bucket.average),
            height: .ratio(1),
            width: .ratio(1)
        )
        .foregroundStyle(by: .value("Count", bucket.count))
    }
}
.chartForegroundStyleScale(
    range: Gradient(colors: [.blue, .green, .yellow, .red])
)
```

These styling options provide extensive customization capabilities for both Swift Tables and Swift Charts, allowing you to create professional, polished data visualizations that match your app's design requirements.
# Comprehensive Guide to Swift DataFrames with TabularData Framework

## Introduction

The TabularData framework, introduced in iOS 15, macOS 12, and watchOS 8, provides Swift developers with powerful data manipulation capabilities similar to Python's Pandas. It's designed for:
- Loading and exploring structured data
- Pre-processing data for machine learning
- Handling large datasets efficiently
- Building data pipelines

## Basic DataFrame Operations

### Importing the Framework
```swift
import TabularData
import Foundation
```

### Creating DataFrames

#### From Scratch
```swift
// Empty DataFrame
var emptyDF = DataFrame()

// Creating columns manually
let idColumn = Column(name: "id", contents: [1, 2, 3, 4, 5])
let nameColumn = Column(name: "name", contents: ["Alice", "Bob", "Charlie", "David", "Eve"])
let ageColumn = Column(name: "age", contents: [25, 30, 35, 28, 32])

// Initialize DataFrame with columns
let df = DataFrame(columns: [idColumn, nameColumn, ageColumn])
print(df)
```

#### From CSV Files
```swift
// Load from local file
let csvOptions = CSVReadingOptions(
    hasHeaderRow: true,
    delimiter: ",",
    ignoresEmptyLines: true
)

let fileURL = Bundle.main.url(forResource: "data", withExtension: "csv")!
let df = try DataFrame(
    contentsOfCSVFile: fileURL,
    columns: ["Name", "Age", "City"], // Optional: specify columns
    rows: 0..<100, // Optional: limit rows
    types: ["Name": .string, "Age": .integer, "City": .string], // Specify types
    options: csvOptions
)

// Load from URL
let remoteURL = URL(string: "https://example.com/data.csv")!
let remoteDF = try DataFrame(contentsOfCSVFile: remoteURL, options: csvOptions)
```

#### From JSON
```swift
let jsonData = """
[
    {"name": "Alice", "age": 25, "score": 85.5},
    {"name": "Bob", "age": 30, "score": 92.0}
]
""".data(using: .utf8)!

let df = try DataFrame(jsonData: jsonData)
```

## Data Exploration

### Basic Information
```swift
// Shape of the DataFrame
print("Rows: \(df.rows.count)")
print("Columns: \(df.columns.count)")

// Column names
let columnNames = df.columns.map { $0.name }
print("Columns: \(columnNames)")

// Preview data
print(df) // Prints formatted table
print(df.prefix(5)) // First 5 rows
print(df.suffix(5)) // Last 5 rows
```

### Column Operations
```swift
// Access column by name
let ageColumn = df["age"]

// Get column summary
if let ageColumn = df["age", Double.self] {
    let summary = ageColumn.summary()
    print("Count: \(summary.count)")
    print("Unique values: \(summary.uniqueCount)")
    print("Mode: \(summary.mode ?? "None")")
}

// Numeric summary for numeric columns
if let ageColumn = df["age", Double.self] {
    let numericSummary = ageColumn.numericSummary()
    print("Mean: \(numericSummary?.mean ?? 0)")
    print("Std Dev: \(numericSummary?.standardDeviation ?? 0)")
    print("Min: \(numericSummary?.min ?? 0)")
    print("Max: \(numericSummary?.max ?? 0)")
}
```

## Data Transformation

### Column Transformations

```swift
// Map values in a column
df["age_group"] = df["age", Int.self]?.map { age -> String in
    switch age {
    case 0..<18: return "Minor"
    case 18..<65: return "Adult"
    default: return "Senior"
    }
}

// Type conversion
df["age_double"] = df["age", Int.self]?.map { Double($0) }

// Combining columns
df.combineColumns("first_name", "last_name", into: "full_name") {
    (first: String?, last: String?) -> String? in
    guard let first = first, let last = last else { return nil }
    return "\(first) \(last)"
}

// Fillna - Replace missing values
df["score"]?.fillMissing(with: 0.0)
```

### Filtering Data

```swift
// Filter using a predicate
let adults = df.filter(on: "age", Int.self) { age in
    age != nil && age! >= 18
}

// Multiple conditions
let highScoringAdults = df.filter(on: "age", Int.self) { age in
    age != nil && age! >= 18
}.filter(on: "score", Double.self) { score in
    score != nil && score! > 80.0
}

// Using row-based filtering
let filtered = df.rows.filter { row in
    let age = row["age"] as? Int ?? 0
    let score = row["score"] as? Double ?? 0.0
    return age >= 21 && score > 75.0
}
```

### Sorting

```swift
// Sort by single column
let sortedByAge = df.sorted(on: "age", order: .ascending)

// Sort by multiple columns
let multiSort = df.sorted(on: "department", order: .ascending)
                  .sorted(on: "salary", order: .descending)

// Using key path comparators
let comparators = [
    SortComparator(keyPath: \DataFrame.Row["age"], order: .ascending),
    SortComparator(keyPath: \DataFrame.Row["name"], order: .descending)
]
let sorted = df.sorted(using: comparators)
```

## Grouping and Aggregation

```swift
// Group by single column
let groupedByDept = df.grouped(by: "department")

// Apply aggregations
for (department, group) in groupedByDept {
    let averageSalary = group["salary", Double.self]?
        .numericSummary()?.mean ?? 0
    print("\(department): Average salary = \(averageSalary)")
}

// Group by multiple columns (requires combining first)
df.combineColumns("department", "location", into: "dept_location") {
    (dept: String?, loc: String?) -> String? in
    guard let dept = dept, let loc = loc else { return nil }
    return "\(dept)-\(loc)"
}
let multiGrouped = df.grouped(by: "dept_location")
```

## Joining DataFrames

```swift
// Inner join
let employeeDF = DataFrame(/* employee data */)
let departmentDF = DataFrame(/* department data */)

let joined = employeeDF.joined(
    departmentDF,
    on: "department_id",
    kind: .inner
)

// Left join
let leftJoined = employeeDF.joined(
    departmentDF,
    on: "department_id",
    kind: .left
)

// Join on multiple columns
let multiJoined = df1.joined(
    df2,
    on: ("id", "date"), // Tuple of column names
    kind: .inner
)
```

## Working with Rows

```swift
// Iterate over rows
for row in df.rows {
    let name = row["name"] as? String ?? ""
    let age = row["age"] as? Int ?? 0
    print("\(name) is \(age) years old")
}

// Safe row access with proper index handling
var index = df.rows.startIndex
while index != df.rows.endIndex {
    let row = df.rows[index]
    // Process row
    index = df.rows.index(after: index)
}

// Convert rows to array (for SwiftUI)
extension DataFrame.Rows: RandomAccessCollection {}

// Now can be used in ForEach
ForEach(df.rows, id: \.index) { row in
    HStack {
        Text(row["name"] as? String ?? "")
        Text("\(row["age"] as? Int ?? 0)")
    }
}
```

## Advanced Operations

### Window Functions
```swift
// Calculate rolling statistics
func rollingMean(column: Column<Double>, windowSize: Int) -> [Double?] {
    var results: [Double?] = []
    let values = column.map { $0 }

    for i in 0..<values.count {
        if i < windowSize - 1 {
            results.append(nil)
        } else {
            let window = values[(i - windowSize + 1)...i]
            let sum = window.compactMap { $0 }.reduce(0, +)
            let count = window.compactMap { $0 }.count
            results.append(count > 0 ? sum / Double(count) : nil)
        }
    }
    return results
}
```

### Pivot Tables
```swift
// Manual pivot implementation
func pivot(df: DataFrame,
          rows: String,
          columns: String,
          values: String,
          aggFunc: ([Double]) -> Double) -> DataFrame {

    var pivotData: [String: [String: Double]] = [:]

    for row in df.rows {
        let rowKey = row[rows] as? String ?? ""
        let colKey = row[columns] as? String ?? ""
        let value = row[values] as? Double ?? 0.0

        if pivotData[rowKey] == nil {
            pivotData[rowKey] = [:]
        }

        if pivotData[rowKey]![colKey] == nil {
            pivotData[rowKey]![colKey] = value
        } else {
            // Aggregate logic here
            pivotData[rowKey]![colKey]! += value
        }
    }

    // Convert back to DataFrame
    // Implementation depends on your needs
    return DataFrame()
}
```

### Custom Column Types
```swift
// Decode JSON column to custom type
struct Address: Codable {
    let street: String
    let city: String
    let zipCode: String
}

let decoder = JSONDecoder()
df["parsed_address"] = df["address_json", String.self]?.map { jsonString -> Address? in
    guard let data = jsonString.data(using: .utf8) else { return nil }
    return try? decoder.decode(Address.self, from: data)
}
```

## Performance Best Practices

### 1. **Specify Types When Loading**
```swift
// Good - Types specified
let df = try DataFrame(
    contentsOfCSVFile: url,
    types: ["id": .integer, "name": .string, "score": .double],
    options: options
)

// Avoid - No types specified
let df = try DataFrame(contentsOfCSVFile: url)
```

### 2. **Use Basic Types for Operations**
```swift
// Good - Group by basic type
let grouped = df.grouped(by: "category")

// For multiple columns, combine into single basic type
df.combineColumns("age", "city", into: "age_city") {
    (age: Int?, city: String?) -> String? in
    guard let age = age, let city = city else { return nil }
    return "\(age)-\(city)"
}
```

### 3. **Slice Before Heavy Operations**
```swift
// Work with subset for exploration
let sample = df.randomSample(withCount: 1000)
// Perform expensive operations on sample first
```

### 4. **Remove Unnecessary Columns**
```swift
// Remove columns not needed (mutating operation)
var workingDF = df
workingDF.removeColumn("unnecessary_column")
```

## Integration with SwiftUI

```swift
struct DataTableView: View {
    let dataFrame: DataFrame

    var body: some View {
        Table(dataFrame.rows, id: \.index) { row in
            TableColumn("Name") { _ in
                Text(row["name"] as? String ?? "")
            }
            TableColumn("Age") { _ in
                Text("\(row["age"] as? Int ?? 0)")
            }
            TableColumn("Score") { _ in
                Text(String(format: "%.1f", row["score"] as? Double ?? 0.0))
            }
        }
    }
}
```

## Error Handling

```swift
enum DataFrameError: Error {
    case columnNotFound(String)
    case typeMismatch(expected: String, actual: String)
    case invalidOperation(String)
}

func safeColumnOperation<T>(
    df: DataFrame,
    columnName: String,
    type: T.Type
) throws -> Column<T> {
    guard let column = df[columnName, type] else {
        throw DataFrameError.columnNotFound(columnName)
    }
    return column
}
```

## Exporting Data

```swift
// To CSV
let csvData = df.csvRepresentation()
try csvData.write(to: outputURL)

// To JSON (manual implementation)
func dataFrameToJSON(_ df: DataFrame) -> Data? {
    var jsonArray: [[String: Any]] = []

    for row in df.rows {
        var jsonRow: [String: Any] = [:]
        for column in df.columns {
            jsonRow[column.name] = row[column.name]
        }
        jsonArray.append(jsonRow)
    }

    return try? JSONSerialization.data(withJSONObject: jsonArray)
}
```

## Limitations and Considerations

1. **Not Open Source**: Unlike Pandas, TabularData is not open-source and only available on Apple platforms
2. **Limited Documentation**: Official documentation lacks comprehensive examples
3. **No Direct Multi-column Grouping**: Requires combining columns first
4. **Type Safety**: Requires careful handling of optionals and type casting
5. **Performance**: Best suited for datasets that fit in memory

The TabularData framework provides a solid foundation for data manipulation in Swift, making it easier to work with structured data for analysis, machine learning preprocessing, and general data processing tasks within Apple's ecosystem.
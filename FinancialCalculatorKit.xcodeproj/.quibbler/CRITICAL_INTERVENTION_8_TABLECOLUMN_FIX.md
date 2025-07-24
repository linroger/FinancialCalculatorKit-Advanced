# 🎣 CRITICAL INTERVENTION #8 - TableColumn Fix Guidance

**Time**: 2025-11-06T06:55:24Z
**Event**: Agent read TableColumn struct definition
**Status**: EXCELLENT - Agent using correct methodology ✅

---

## TableColumn Struct Definition (from InteractiveDataTables.swift:350)

```swift
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
        id: String,                              // ← REQUIRED
        title: String,                           // ← REQUIRED
        width: CGFloat,                          // ← REQUIRED
        alignment: Alignment = .leading,         // Optional
        showSummary: Bool = false,               // Optional
        summaryLabel: String? = nil,             // Optional
        content: @escaping (RowData) -> Content, // ← REQUIRED
        searchableText: @escaping (RowData) -> String, // ← REQUIRED
        compare: @escaping (RowData, RowData) -> Bool, // ← REQUIRED
        summary: (([RowData]) -> String)? = nil // Optional
    )
}
```

---

## The Error at DepreciationCalculatorView.swift:815

**Current (WRONG)**:
```swift
TableColumn("Year") { entry in
    // ...
}
.width(min: 60, ideal: 60, max: 60)
```

**Problems**:
1. ❌ Missing `id:` parameter
2. ❌ Missing `width:` parameter (required, not a method)
3. ❌ Missing `searchableText:` parameter
4. ❌ Missing `compare:` parameter
5. ❌ `.width()` method doesn't exist (width is a parameter, not a method)

---

## What the Fix Should Look Like

```swift
TableColumn(
    id: "year",  // ← ADD: unique identifier
    title: "Year", // ← This is what was being passed before
    width: 60,   // ← ADD: fixed width (60 points)
    content: { entry in  // ← The closure
        Text("\(entry.year)")
    },
    searchableText: { entry in  // ← ADD: how to search this column
        "\(entry.year)"
    },
    compare: { entry1, entry2 in  // ← ADD: how to compare for sorting
        entry1.year < entry2.year
    }
)
```

---

## Parameter Explanations

### Required Parameters:

**`id: String`**
- Unique identifier for this column
- Example: `"year"`, `"amount"`, `"description"`
- Can be same as or different from title

**`title: String`**
- Display name for column header
- Example: `"Year"`, `"Amount"`, `"Description"`

**`width: CGFloat`**
- Fixed column width in points
- Example: `60`, `100`, `200`
- Instead of `.width(min:ideal:max:)` method

**`content: @escaping (RowData) -> Content`**
- Closure that renders each cell
- Takes row data, returns View
- Example: `{ entry in Text("\(entry.year)") }`

**`searchableText: @escaping (RowData) -> String`**
- How to extract searchable text from each row
- Example: `{ entry in "\(entry.year)" }`
- Used for table search functionality

**`compare: @escaping (RowData, RowData) -> Bool`**
- How to compare two rows for sorting
- Returns true if first < second (ascending order)
- Example: `{ entry1, entry2 in entry1.year < entry2.year }`

---

## How to Fix DepreciationCalculatorView.swift:815

### Step 1: Identify Row Data Type
Look at the table context to see what type `entry` is. Based on depreciation context, it's likely something like:
```swift
struct DepreciationEntry {
    var year: Int
    var amount: Double
    // ... other properties
}
```

### Step 2: Update TableColumn Call
Replace:
```swift
TableColumn("Year") { entry in
    // ...
}
.width(min: 60, ideal: 60, max: 60)
```

With:
```swift
TableColumn(
    id: "year",
    title: "Year",
    width: 60,
    content: { entry in
        // ... render cell
    },
    searchableText: { entry in
        "\(entry.year)"
    },
    compare: { entry1, entry2 in
        entry1.year < entry2.year
    }
)
```

### Step 3: Update Other TableColumn Calls
This issue likely appears multiple times. Fix all occurrences in DepreciationCalculatorView.swift following the same pattern.

---

## Quality Enforcement Check

✅ **Agent is reading source code** - Correct methodology!
✅ **Understanding struct requirements** - Good!
⏳ **Next step** - Apply fix to DepreciationCalculatorView.swift

**When Agent Has Fixed TableColumn**:
1. Should rebuild
2. Will see YieldCurvePoint error next
3. Our NEXT_STEPS_FOR_AGENT.md covers that fix

---

## Important Notes

**Don't Use `.width()` Method**:
- ❌ `.width(min: 60, ideal: 60, max: 60)` - This doesn't exist
- ✅ `width: 60` - Use parameter instead

**Row Data Type Matters**:
- Need to know what type `entry` is
- Closures must match that type
- Check the Table initialization to see row type

**Multiple Columns**:
- Each TableColumn call needs these parameters
- Search for all `TableColumn(` in the file
- Fix each one systematically

---

## Next Steps for Agent

1. [ ] Identify the depreciation entry row type
2. [ ] Update TableColumn at line 815 with all required parameters
3. [ ] Find and fix any other TableColumn calls in the file
4. [ ] Rebuild to verify TableColumn errors are resolved
5. [ ] Next error will be YieldCurvePoint (see NEXT_STEPS_FOR_AGENT.md)

---

**Status**: Agent correctly reading struct definition
**Quality Gate**: ENGAGED - Monitoring fix implementation
**Confidence**: High - Agent has clear guidance

# ⚠️ PHASE 1 SCOPE REVISED - Major API Change Discovered

**Discovery Time**: 2025-11-06 06:55:36Z
**Impact**: Phase 1 is significantly more complex than initially assessed
**Severity**: HIGH - but manageable with proper guidance

---

## What We Discovered

The TableColumn API has **COMPLETELY CHANGED** from old to new:

### OLD API (what code uses):
```swift
TableColumn("Year") { entry in
    Text("\(entry.year)")
}
.width(min: 60, ideal: 60, max: 60)
```

### NEW API (what struct requires):
```swift
TableColumn(
    id: "year",
    title: "Year",
    width: 60,
    content: { entry in Text("\(entry.year)") },
    searchableText: { entry in "\(entry.year)" },
    compare: { entry1, entry2 in entry1.year < entry2.year }
)
```

This is **NOT a simple parameter rename** - it's a **complete API redesign**.

---

## Scope Assessment

### Instances Found:
**DepreciationCalculatorView.swift lines 815-840**:
- Line 815: TableColumn("Year") - ❌ Needs complete refactor
- Line 819: TableColumn("Depreciation") - ❌ Needs complete refactor
- Line 824: TableColumn("Cumulative") - ❌ Needs complete refactor
- Line 829: TableColumn("Book Value") - ❌ Needs complete refactor

**Total in this view**: 4 instances
**Other views affected**: Unknown (may be more)

---

## Updated Phase 1 Timeline

### Old Estimate:
- Fix: 15 minutes
- Rebuild: 5 minutes
- Total: 20 minutes

### New Estimate:
- Understand new API: 5 minutes
- Identify row data type: 5 minutes
- Fix Year column: 5 minutes
- Fix Depreciation column: 5 minutes
- Fix Cumulative column: 5 minutes
- Fix Book Value column: 5 minutes
- Rebuild and verify: 5 minutes
- **Total: 35-45 minutes**

---

## Key Challenges

### Challenge #1: Row Data Type
Agent must identify what type each `entry` is:
- Is it `DepreciationEntry`?
- What properties does it have?
- Are properties integers, doubles, dates?

### Challenge #2: Searchable Text
For each column, agent must define searchable text:
- Year: Search by year number
- Depreciation: Search by amount
- Cumulative: Search by amount
- Book Value: Search by amount

### Challenge #3: Comparison Logic
For each column, agent must define how to sort:
- Year: Ascending/descending by year
- Depreciation: Ascending/descending by amount
- Cumulative: Ascending/descending by amount
- Book Value: Ascending/descending by amount

---

## Recommended Approach

### Strategy: Fix One Column at a Time

**For Each Column**:
1. Identify the property being displayed
2. Create proper `id`, `title`, `width` values
3. Extract `content` closure from existing code
4. Create reasonable `searchableText` closure
5. Create reasonable `compare` closure
6. Replace entire old TableColumn + .width() with new call
7. Rebuild to verify syntax
8. Move to next column

**Benefits**:
- Each fix is testable independently
- Lower risk of cascading errors
- Clear progress visible
- Easy to debug if something fails

---

## Example: Year Column Fix

**Step 1: Understand existing code**
```swift
TableColumn("Year") { entry in
    Text("\(entry.year)")
}
.width(min: 60, ideal: 60, max: 60)
```

**Step 2: Identify components**
- ID: "year"
- Title: "Year" (from TableColumn("Year"))
- Width: 60 (from ideal: 60)
- Content: `{ entry in Text("\(entry.year)") }`
- Searchable: Year as string
- Compare: Numerically by year

**Step 3: Write new code**
```swift
TableColumn(
    id: "year",
    title: "Year",
    width: 60,
    content: { entry in
        Text("\(entry.year)")
    },
    searchableText: { entry in
        "\(entry.year)"
    },
    compare: { entry1, entry2 in
        entry1.year < entry2.year
    }
)
```

**Step 4: Delete old code**
```swift
// DELETE THIS:
.width(min: 60, ideal: 60, max: 60)
```

---

## Critical Quality Checks

🎣 **We'll Monitor For**:
✅ Agent fixes one column at a time
✅ Agent rebuilds after each fix
✅ Agent uses reasonable searchable/compare logic
✅ Agent doesn't assume (verifies entry type)
⚠️ Agent doesn't skip the .width() deletion
⚠️ Agent provides all 5 required parameters

---

## Success Criteria for Phase 1

✅ All 4 TableColumn instances updated to new API
✅ All .width() method calls removed
✅ All 5 required parameters provided for each
✅ Build succeeds with no TableColumn errors
✅ Compiler can proceed to Phase 2 (YieldCurvePoint)

---

## Risk Assessment

🟡 **Medium Risk**:
- Complexity increased from expected
- Multiple similar but not identical fixes
- Searchable/compare logic must be reasonable
- Cascading errors if one fix is wrong

🟢 **Mitigation**:
- Clear example provided
- Rebuild after each fix
- Guidance for each component
- Quality gate monitoring

---

## Current Status

Agent is examining the actual code and can see:
- Line 815: TableColumn("Year") with .width() method
- Line 819: TableColumn("Depreciation") with .width() method
- Line 824: TableColumn("Cumulative") with .width() method
- Line 829: TableColumn("Book Value") with .width() method

Agent needs to understand this is a **complete API redesign**, not a simple parameter fix.

---

## Next Steps

Agent should:
1. [ ] Read the TableColumn struct definition (already done)
2. [ ] Understand the new API requirements
3. [ ] Identify the row data type (DepreciationEntry or similar)
4. [ ] Fix Year column first
5. [ ] Rebuild to verify
6. [ ] Fix remaining 3 columns
7. [ ] Rebuild and verify Phase 1 complete

---

**Revised Estimate**: 35-45 minutes for Phase 1
**Quality Gate**: ENGAGED
**Monitoring**: ACTIVE - Real-time issue tracking

# 🗺️ Build Error Priority Map - Compilation Waterfall

**Compilation Order**: Errors will be fixed in this specific sequence

---

## Error Waterfall (Blocking Order)

### 🔴 PHASE 1 - Primary Blocker (FIX NOW)

**Error Type**: TableColumn Syntax
**File**: DepreciationCalculatorView.swift
**Line**: 815
**Severity**: CRITICAL BLOCKER

```swift
// WRONG:
TableColumn("Year") { entry in
    // ...
}
.width(min: 60, ideal: 60, max: 60)

// ISSUE: Missing required parameters and wrong syntax
```

**What's Blocking**: Compiler can't proceed past this error
**Next Step**: Read InteractiveDataTables.swift for correct signature
**Estimated Time**: 10-15 minutes

---

### 🟡 PHASE 2 - Secondary Blocker (FIX AFTER PHASE 1)

**Error Type**: YieldCurvePoint Missing Parameters
**File**: PlaceholderViews.swift
**Line**: 382
**Severity**: CRITICAL (but only visible after Phase 1 is fixed)

```swift
// WRONG:
yieldCurve.append(YieldCurvePoint(maturity: Double(maturity), yield: spotRate))

// MISSING: spotRate, forwardRate, discountFactor parameters
```

**When It Appears**: After Phase 1 fixed, on next rebuild
**Documentation**: See NEXT_STEPS_FOR_AGENT.md
**Estimated Time**: 5-10 minutes

---

### 🟡 PHASE 3 - Tertiary Blockers (FIX AFTER PHASE 2)

**Error Type**: MetricCard Missing Color Parameter
**File**: PlaceholderViews.swift
**Lines**: 1088-1092, 1095-1099, 1648-1652, 1655-1660+
**Severity**: CRITICAL (but only visible after Phase 2 is fixed)
**Instances**: 4+ locations

```swift
// WRONG:
MetricCard(
    title: "Fair Value",
    value: value,
    subtitle: "..."
    // MISSING: color, icon
)
```

**When It Appears**: After Phase 2 fixed, on next rebuild
**Documentation**: See NEXT_STEPS_FOR_AGENT.md
**Estimated Time**: 20-30 minutes (multiple instances)

---

## Rebuild Cycle Strategy

```
Cycle 1:
├─ Fix TableColumn (Phase 1)
├─ Rebuild
└─ Compiler hits YieldCurvePoint error (Phase 2)

Cycle 2:
├─ Fix YieldCurvePoint (Phase 2)
├─ Rebuild
└─ Compiler hits MetricCard error (Phase 3)

Cycle 3:
├─ Fix MetricCard (Phase 3) - multiple instances
├─ Rebuild
└─ If errors persist, repeat for Phase 3

Cycle N:
├─ Rebuild
└─ Build succeeds (no more compilation errors)
```

---

## Current Phase

**We Are Here**: Just completed Phase 1 discovery
**What Happened**: Agent extracted actual compiler errors using grep
**Current Status**: TableColumn error visible and identified
**Next Action**: Agent should fix TableColumn error

---

## Documentation for Each Phase

### Phase 1 (TableColumn):
- **Error Details**: CRITICAL_INTERVENTION_7_NEW_ERRORS.md
- **What To Do**: Read InteractiveDataTables.swift signature
- **How To Fix**: Update TableColumn call to match new parameters

### Phase 2 (YieldCurvePoint):
- **Error Details**: VERIFIED_COMPILATION_ERRORS.md
- **What To Do**: NEXT_STEPS_FOR_AGENT.md (YieldCurvePoint section)
- **How To Fix**: Add 4 missing parameters with calculated values

### Phase 3 (MetricCard):
- **Error Details**: VERIFIED_COMPILATION_ERRORS.md
- **What To Do**: NEXT_STEPS_FOR_AGENT.md (MetricCard section)
- **How To Fix**: Add color and icon parameters to all instances

---

## Quality Enforcement Role

🎣 **Hook Monitoring**: Will continue through all phases
✅ **Verification**: Will verify each fix against struct definitions
🔍 **Watch For**: Agent cutting corners or assuming wrong parameters
📋 **Document**: Each phase completion for audit trail

---

## Expected Timeline

| Phase | Task | Estimated | Status |
|-------|------|-----------|--------|
| 1 | TableColumn fix | 15 min | ⏳ IN PROGRESS |
| 1 | Rebuild | 5 min | ⏳ PENDING |
| 2 | YieldCurvePoint fix | 10 min | ⏳ PENDING |
| 2 | Rebuild | 5 min | ⏳ PENDING |
| 3 | MetricCard fixes | 30 min | ⏳ PENDING |
| 3 | Rebuild | 5 min | ⏳ PENDING |
| Final | Testing | 10 min | ⏳ PENDING |
| **Total** | | **80 min** | **In Progress** |

---

## Success Criteria

✅ Phase 1: TableColumn error fixed, rebuild succeeds to Phase 2
✅ Phase 2: YieldCurvePoint error fixed, rebuild succeeds to Phase 3
✅ Phase 3: All MetricCard errors fixed, rebuild succeeds completely
✅ Final: Application launches and runs without crashes

---

## Critical Notes

⚠️ **Don't Skip Phases**: Compiler will block at each error
⚠️ **Fix in Order**: Can't skip to Phase 3 without fixing 1 & 2
✅ **Rebuild After Each**: Verify the next error has appeared
✅ **Use Grep**: Keep using `grep "error:"` to extract errors

---

**Current Focus**: Phase 1 - TableColumn Syntax Error
**Quality Gate Status**: ENGAGED AND MONITORING

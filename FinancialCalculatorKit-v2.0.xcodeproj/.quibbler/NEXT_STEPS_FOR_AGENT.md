# 📋 NEXT STEPS - Action Items for Agent

**Status**: Quality Enforcement Monitoring Complete
**Issues Verified**: 2 confirmed compilation errors
**Build Status**: BLOCKED until errors are fixed

---

## CRITICAL ISSUES FOUND

### 1️⃣ YieldCurvePoint Missing Parameters
**File**: PlaceholderViews.swift, Line 382
**Severity**: BLOCKING

**Current (WRONG):**
```swift
yieldCurve.append(YieldCurvePoint(maturity: Double(maturity), yield: spotRate))
```

**Required Fix:**
- Add `spotRate` parameter
- Add `forwardRate` parameter
- Add `discountFactor` parameter

**How to Fix:**
1. Read YieldCurveTypes.swift to see struct definition
2. Understand what values these parameters should have
3. Update line 382 to provide all 6 parameters

---

### 2️⃣ MetricCard Missing Color Parameter
**File**: PlaceholderViews.swift, Lines 1648-1652, 1655-1660+
**Severity**: BLOCKING (multiple instances)

**Current (WRONG):**
```swift
MetricCard(
    title: "Fair Value",
    value: currency.formatValue(valuation.fairValue),
    subtitle: "Estimated market value"
    // Missing: color, icon
)
```

**Required Fix:**
- Add `color` parameter (required)
- Add `icon` parameter (recommended for subtitle-based init)

**How to Fix:**
1. Search PlaceholderViews.swift for all `MetricCard(` calls
2. Check which initializer each should use
3. Add missing parameters:
   - `color: .blue` (or appropriate color)
   - `icon: "dollarsign.circle.fill"` (or appropriate icon)

**Available Initializers** (from FinancialStyles.swift):
```swift
// Option 1: Simple (no subtitle)
init(title: String, value: String, color: Color)

// Option 2: With icon and subtitle
init(title: String, value: String, icon: String, color: Color, subtitle: String? = nil)

// Option 3: Full (with trend)
init(title: String, value: String, subtitle: String?, trend: TrendDirection?,
     trendValue: String?, icon: String, color: Color)
```

---

## RECOMMENDED COLORS FOR METRICS

Based on FinancialStyles.swift extension:
- Financial metrics: `.financialBlue`
- Growth/positive: `.financialGreen`
- Risk/negative: `.financialRed`
- Warning: `.financialOrange`
- Alternative: `.accentColor`

---

## RECOMMENDED ICONS

Based on SF Symbols:
- Financial value: `"dollarsign.circle.fill"` or `"chart.line.uptrend.xyaxis"`
- Asset value: `"square.stack.3d.up.fill"` or `"bag.fill"`
- Valuation: `"chart.bar.fill"`
- Performance: `"arrow.up.right"` or `"arrow.down.right"`

---

## ACTION PLAN

### Step 1: Fix YieldCurvePoint (Line 382)
```
[ ] Read YieldCurveTypes.swift to understand the struct
[ ] Determine appropriate values for missing parameters
[ ] Update PlaceholderViews.swift line 382 with all 6 parameters
```

### Step 2: Fix MetricCard Calls (Lines 1648+)
```
[ ] Search for all MetricCard( in PlaceholderViews.swift
[ ] For each instance, determine appropriate color
[ ] For each instance, determine appropriate icon
[ ] Update all calls with color and icon parameters
```

### Step 3: Verify Build Success
```
[ ] Run xcodebuild again
[ ] Extract actual error messages (use grep or Grep tool)
[ ] Verify both YieldCurvePoint and MetricCard errors are resolved
[ ] Check for any new/remaining compilation errors
```

### Step 4: Test Application
```
[ ] Once build succeeds, launch the application
[ ] Verify no runtime crashes
[ ] Test relevant calculator functionality
```

---

## HOW TO EXTRACT BUILD ERRORS

**Wrong Way:**
```bash
xcodebuild ... | tail -100  # Hides errors!
```

**Right Way - Option 1 (grep):**
```bash
grep "error:" build_current_status.log
```

**Right Way - Option 2 (full output):**
```bash
xcodebuild ... 2>&1 | tee build_output.log
# Then view full log in editor
```

---

## VERIFICATION DOCUMENTATION

All findings have been verified by reading source code:
✅ YieldCurveTypes.swift - Confirms 6-parameter requirement
✅ FinancialStyles.swift - Confirms MetricCard struct and initializers
✅ PlaceholderViews.swift - Confirms current implementation is wrong

See these documents for details:
- VERIFIED_COMPILATION_ERRORS.md
- VERIFICATION_METRICCARD.md
- CRITICAL_INTERVENTION_*.md files

---

## EXPECTED OUTCOME

After fixes:
- ✅ Build should complete without these errors
- ✅ Possible other errors may emerge
- ✅ Continue fixing until build succeeds
- ✅ Test application for runtime issues

**Current Build Status**: 🔴 BLOCKED
**Expected After Fixes**: 🟡 May have other errors
**Ultimate Goal**: 🟢 Clean build + no crashes

---

## Questions/Clarifications Needed

If any of these are unclear:
1. What values should spotRate/forwardRate/discountFactor have?
2. What color/icon should each metric use?
3. Are there more MetricCard instances than found at lines 1648-1660?

Check these files for context:
- Bond pricing logic for yield curve parameters
- Existing MetricCard usage patterns in the file
- Color scheme definitions in FinancialStyles.swift

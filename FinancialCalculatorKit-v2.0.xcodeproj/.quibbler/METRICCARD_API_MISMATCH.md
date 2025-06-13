# 🚨 COMPILATION ERROR: MetricCard Missing Required Parameter

**Status:** CRITICAL - BUILD BLOCKING
**Severity:** CRITICAL
**Time:** 2025-11-06 06:49:36Z

---

## Issue: MetricCard Missing Required `color` Parameter

### Actual MetricCard Definition (FinancialStyles.swift)
```swift
struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let trend: TrendDirection?
    let trendValue: String?
    let icon: String
    let color: Color      // ← REQUIRED

    // Convenience init #1 - requires: title, value, color
    init(title: String, value: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = nil
        self.trend = nil
        self.trendValue = nil
        self.icon = "chart.line.uptrend.xyaxis"
        self.color = color
    }

    // Convenience init #2 - requires: title, value, icon, color
    init(title: String, value: String, icon: String, color: Color, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.trend = nil
        self.trendValue = nil
        self.icon = icon
        self.color = color
    }
}
```

### Current Usage in PlaceholderViews.swift (WRONG - Example from line 1088)
```swift
MetricCard(
    title: "Fair Value",
    value: Currency.usd.formatValue(price),
    subtitle: "Theoretical price"
    // ❌ MISSING: color parameter - REQUIRED!
)
```

### Why This Fails
- MetricCard requires either initializer #1 (title, value, color) or #2 (title, value, icon, color)
- Current usage provides: title, value, subtitle
- **Missing:** color
- **Extra:** subtitle (without other required params)

### Swift Compiler Error
```
error: missing argument for parameter 'color' in call
```

---

## Compilation Errors This Will Cause

All MetricCard instantiations in PlaceholderViews.swift will fail:
- Line 1088-1092: Fair Value
- Line 1653-1657: Net Asset Value
- Line 1666-1670: IRR
- Plus any others

---

## Required Fix

### Option 1: Use Initializer #1 (Simple)
```swift
MetricCard(
    title: "Fair Value",
    value: Currency.usd.formatValue(price),
    color: .blue  // Must provide color
)
```

### Option 2: Use Initializer #2 (With Icon)
```swift
MetricCard(
    title: "Fair Value",
    value: Currency.usd.formatValue(price),
    icon: "dollarsign.circle.fill",
    color: .green,
    subtitle: "Theoretical price"
)
```

---

## Search and Fix All Instances

Find all MetricCard calls:
```bash
grep -n "MetricCard(" PlaceholderViews.swift
```

For each instance:
1. Identify if it has subtitle parameter
2. Add appropriate `color` parameter
3. If using subtitle, also add `icon` parameter (use Initializer #2)

---

## Build Status

❌ **NOT READY FOR BUILD**
🚨 **MetricCard API MISMATCH - MISSING COLOR PARAMETER**
⏸️ **Multiple compilation errors will occur**

---

## Summary of All Critical Errors Found So Far

1. ✅ YieldCurvePoint: Missing 3 parameters (spotRate, forwardRate, discountFactor)
2. ✅ ResultDisplayView: Complete API mismatch (title/value/subtitle/icon/iconColor vs result/currency/showSecondaryValues/showExplanation)
3. ✅ MetricCard: Missing required `color` parameter

**Build will fail with multiple compilation errors**

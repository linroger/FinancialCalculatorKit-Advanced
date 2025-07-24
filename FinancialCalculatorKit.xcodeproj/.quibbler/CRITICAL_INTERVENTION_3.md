# 🚨 CRITICAL INTERVENTION #3 - MetricCard Missing Required Color Parameter

**Time**: 2025-11-06T06:53:59Z
**Location**: PlaceholderViews.swift, lines 1648-1652
**Severity**: BLOCKING BUILD ERROR

## Issue Found:

```swift
// LINE 1648-1652 - WRONG:
MetricCard(
    title: "Fair Value",
    value: currency.formatValue(valuation.fairValue),
    subtitle: "Estimated market value"
    // ❌ MISSING: color parameter
)

// LINE 1655-1660 - SAME ISSUE:
MetricCard(
    title: "Net Asset Value",
    value: currency.formatValue(valuation.nav),
    subtitle: "NAV per share/unit"
    // ❌ MISSING: color parameter
)
```

## Verification Against MetricCard Definition:

From FinancialStyles.swift, MetricCard has multiple initializers but **ALL require a `color` parameter**:

```swift
// Init #1 signature:
init(title: String, value: String, color: Color)

// Init #2 signature:
init(title: String, value: String, icon: String, color: Color, subtitle: String? = nil)
```

**There is NO initializer that accepts** `(title, value, subtitle)` **without color**.

## This is a Compilation Error:

The Swift compiler will reject these calls because:
1. No matching initializer found
2. Required parameter `color` is missing
3. Multiple instances in this section alone

## What Previous Session Found:

The previous context summary identified this exact issue:
- Multiple MetricCard locations missing `color` parameter
- Lines 1088+, 1653+, 1666+ were flagged
- This is NOW CONFIRMED at lines 1648-1652 (and likely 1655-1660)

## Action Required:

Agent MUST add `color` parameter to all MetricCard instantiations. Example fix:

```swift
MetricCard(
    title: "Fair Value",
    value: currency.formatValue(valuation.fairValue),
    icon: "dollarsign.circle.fill",
    color: .blue,  // ✅ ADD THIS
    subtitle: "Estimated market value"
)
```

## Pattern to Search For:

Agent should search PlaceholderViews.swift for all instances of:
```
MetricCard(
    title:
    value:
    subtitle:
```

And add missing `color` and `icon` parameters to each.

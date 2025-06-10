//
//  LoadingResultView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import SwiftUI

/// Loading state view for financial calculation results
struct LoadingResultView: View {
    let title: String
    let message: String?
    let showProgress: Bool
    
    @State private var isAnimating = false
    
    init(title: String = "Calculating...", message: String? = nil, showProgress: Bool = true) {
        self.title = title
        self.message = message
        self.showProgress = showProgress
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Loading indicator
            if showProgress {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
                }
                .onAppear {
                    isAnimating = true
                }
            }
            
            // Title and message
            VStack(spacing: 8) {
                Text(title)
                    .font(.financialSubheadline)
                    .foregroundStyle(.primary)
                
                if let message = message {
                    Text(message)
                        .font(.financialBody)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.8))
    }
}

/// Specialized loading views for different calculation types
extension LoadingResultView {
    /// Loading view for loan calculations
    static func loanCalculation() -> LoadingResultView {
        LoadingResultView(
            title: "Calculating Loan Details...",
            message: "Computing payment schedule and interest breakdown"
        )
    }
    
    /// Loading view for bond calculations
    static func bondCalculation() -> LoadingResultView {
        LoadingResultView(
            title: "Pricing Bond...",
            message: "Calculating present value and yield metrics"
        )
    }
    
    /// Loading view for investment analysis
    static func investmentAnalysis() -> LoadingResultView {
        LoadingResultView(
            title: "Analyzing Investment...",
            message: "Computing NPV, IRR, and cash flow metrics"
        )
    }
    
    /// Loading view for currency conversion
    static func currencyConversion() -> LoadingResultView {
        LoadingResultView(
            title: "Converting Currency...",
            message: "Fetching latest exchange rates"
        )
    }
    
    /// Loading view for FRED data
    static func fredData() -> LoadingResultView {
        LoadingResultView(
            title: "Loading Economic Data...",
            message: "Retrieving data from FRED API"
        )
    }
    
    /// Simple loading overlay without detailed messaging
    static func overlay() -> LoadingResultView {
        LoadingResultView(
            title: "Loading...",
            message: nil,
            showProgress: true
        )
    }
}

/// Compact loading indicator for inline use
struct LoadingIndicator: View {
    let size: CGFloat
    @State private var isAnimating = false
    
    init(size: CGFloat = 20) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        LoadingResultView.loanCalculation()
            .frame(height: 200)
        
        LoadingResultView.overlay()
            .frame(height: 150)
        
        HStack {
            LoadingIndicator(size: 16)
            LoadingIndicator(size: 24)
            LoadingIndicator(size: 32)
        }
    }
    .padding()
}
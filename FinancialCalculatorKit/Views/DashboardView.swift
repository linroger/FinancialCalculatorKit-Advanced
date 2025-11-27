//
//  DashboardView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/9/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var mainViewModel

    // Recent calculations queries
    @Query(sort: \TimeValueCalculation.lastModified, order: .reverse) private var recentTVM: [TimeValueCalculation]
    @Query(sort: \LoanCalculation.lastModified, order: .reverse) private var recentLoans: [LoanCalculation]
    @Query(sort: \InvestmentCalculation.lastModified, order: .reverse) private var recentInvestments: [InvestmentCalculation]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Welcome Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("What would you like to calculate today?")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            QuickActionCard(type: .timeValue, color: .blue)
                            QuickActionCard(type: .loan, color: .green)
                            QuickActionCard(type: .investment, color: .purple)
                            QuickActionCard(type: .options, color: .orange)
                        }
                        .padding(.horizontal)
                    }
                }

                // Market Overview (Mock Data)
                MarketOverviewView()
                    .padding(.horizontal)

                // Recent Activity
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.horizontal)

                    if recentTVM.isEmpty && recentLoans.isEmpty && recentInvestments.isEmpty {
                        ContentUnavailableView("No Recent Calculations", systemImage: "clock", description: Text("Your calculation history will appear here."))
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(recentTVM.prefix(3)) { calc in
                                RecentActivityRow(icon: "clock.arrow.circlepath", title: calc.name, subtitle: "TVM Calculator", date: calc.lastModified, result: calc.result.formattedPrimaryValue)
                            }
                            ForEach(recentLoans.prefix(3)) { calc in
                                RecentActivityRow(icon: "creditcard", title: calc.name, subtitle: calc.loanType.displayName, date: calc.lastModified, result: calc.result.formattedPrimaryValue)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct QuickActionCard: View {
    let type: CalculationType
    let color: Color
    @Environment(MainViewModel.self) private var mainViewModel

    var body: some View {
        Button(action: {
            mainViewModel.selectedCalculationType = type
        }) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: type.systemImage)
                    .font(.largeTitle)
                    .foregroundColor(color)

                Text(type.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 140, height: 120)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct MarketOverviewView: View {
    var body: some View {
        GroupBox("Market Overview") {
            HStack(spacing: 20) {
                MarketMetric(name: "S&P 500", value: "4,450.32", change: "+0.45%", isPositive: true)
                Divider()
                MarketMetric(name: "NASDAQ", value: "13,890.15", change: "+0.82%", isPositive: true)
                Divider()
                MarketMetric(name: "10Y Treasury", value: "4.25%", change: "-0.05%", isPositive: false) // Yield down is good for bonds
                Divider()
                MarketMetric(name: "EUR/USD", value: "1.08", change: "-0.12%", isPositive: false)
            }
            .padding()
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
}

struct MarketMetric: View {
    let name: String
    let value: String
    let change: String
    let isPositive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
            Text(change)
                .font(.caption)
                .foregroundColor(isPositive ? .green : .red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RecentActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let date: Date
    let result: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(result)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
                )
        )
    }
}

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
    @Query(sort: \OptionsCalculation.lastModified, order: .reverse) private var recentOptions: [OptionsCalculation]
    @Query(sort: \MathExpressionCalculation.lastModified, order: .reverse) private var recentMath: [MathExpressionCalculation]

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

                    if recentActivity.isEmpty {
                        ContentUnavailableView("No Recent Calculations", systemImage: "clock", description: Text("Your calculation history will appear here."))
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(recentActivity) { activity in
                                Button(action: {
                                    mainViewModel.editCalculation(activity.calculation)
                                }) {
                                    RecentActivityRow(
                                        icon: activity.icon,
                                        title: activity.title,
                                        subtitle: activity.subtitle,
                                        date: activity.date,
                                        result: activity.result
                                    )
                                }
                                .buttonStyle(.plain)
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

    // Aggregate and sort recent activity
    private var recentActivity: [ActivityItem] {
        var items: [ActivityItem] = []

        for item in recentTVM.prefix(5) {
            items.append(ActivityItem(
                id: item.id,
                title: item.name,
                subtitle: "TVM Calculator",
                date: item.lastModified,
                result: item.result.formattedPrimaryValue,
                icon: "clock.arrow.circlepath",
                calculation: item
            ))
        }

        for item in recentLoans.prefix(5) {
            items.append(ActivityItem(
                id: item.id,
                title: item.name,
                subtitle: item.loanType.displayName,
                date: item.lastModified,
                result: item.result.formattedPrimaryValue,
                icon: "creditcard",
                calculation: item
            ))
        }

        for item in recentInvestments.prefix(5) {
            items.append(ActivityItem(
                id: item.id,
                title: item.name,
                subtitle: "Investment Analysis",
                date: item.lastModified,
                result: item.result.formattedPrimaryValue,
                icon: "chart.bar.fill",
                calculation: item
            ))
        }

        for item in recentOptions.prefix(5) {
            items.append(ActivityItem(
                id: item.id,
                title: item.name,
                subtitle: "Options Calculator",
                date: item.lastModified,
                result: item.result.formattedPrimaryValue,
                icon: "function",
                calculation: item
            ))
        }

        for item in recentMath.prefix(5) {
            items.append(ActivityItem(
                id: item.id,
                title: item.name,
                subtitle: "Math Expression",
                date: item.lastModified,
                result: item.result.formattedPrimaryValue,
                icon: "x.squareroot",
                calculation: item
            ))
        }

        return items.sorted(by: { $0.date > $1.date }).prefix(10).map { $0 }
    }
}

struct ActivityItem: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let date: Date
    let result: String
    let icon: String
    let calculation: FinancialCalculation // Uses the protocol/base class
}

struct QuickActionCard: View {
    let type: CalculationType
    let color: Color
    @Environment(MainViewModel.self) private var mainViewModel

    var body: some View {
        Button(action: {
            mainViewModel.createNewCalculation(type: type)
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
        .contentShape(Rectangle())
    }
}

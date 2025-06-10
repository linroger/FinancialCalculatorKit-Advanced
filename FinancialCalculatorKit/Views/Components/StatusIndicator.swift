//
//  StatusIndicator.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/13/25.
//

import SwiftUI

/// Status indicator for validation states and system feedback
struct StatusIndicator: View {
    let status: StatusType
    let message: String?
    
    enum StatusType {
        case success
        case warning
        case error
        case info
        case loading
        
        var systemImage: String {
            switch self {
            case .success:
                return "checkmark.circle.fill"
            case .warning:
                return "exclamationmark.triangle.fill"
            case .error:
                return "xmark.circle.fill"
            case .info:
                return "info.circle.fill"
            case .loading:
                return "clock.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .success:
                return .green
            case .warning:
                return .orange
            case .error:
                return .red
            case .info:
                return .blue
            case .loading:
                return .gray
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .success:
                return .green.opacity(0.1)
            case .warning:
                return .orange.opacity(0.1)
            case .error:
                return .red.opacity(0.1)
            case .info:
                return .blue.opacity(0.1)
            case .loading:
                return .gray.opacity(0.1)
            }
        }
    }
    
    init(_ status: StatusType, message: String? = nil) {
        self.status = status
        self.message = message
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if status == .loading {
                ProgressView()
                    .scaleEffect(0.8)
                    .progressViewStyle(CircularProgressViewStyle(tint: status.color))
            } else {
                Image(systemName: status.systemImage)
                    .foregroundStyle(status.color)
                    .font(.system(size: 16, weight: .medium))
            }
            
            if let message = message {
                Text(message)
                    .font(.financialBody)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(status.backgroundColor)
        .cornerRadius(8)
    }
}

/// Convenience initializers for common use cases
extension StatusIndicator {
    /// Validation success indicator
    static func validationSuccess(_ message: String = "Valid") -> StatusIndicator {
        StatusIndicator(.success, message: message)
    }
    
    /// Validation warning indicator
    static func validationWarning(_ message: String) -> StatusIndicator {
        StatusIndicator(.warning, message: message)
    }
    
    /// Validation error indicator
    static func validationError(_ message: String) -> StatusIndicator {
        StatusIndicator(.error, message: message)
    }
    
    /// Loading indicator
    static func loading(_ message: String = "Loading...") -> StatusIndicator {
        StatusIndicator(.loading, message: message)
    }
    
    /// Information indicator
    static func info(_ message: String) -> StatusIndicator {
        StatusIndicator(.info, message: message)
    }
}

/// Icon-only status indicator for compact layouts
struct StatusIcon: View {
    let status: StatusIndicator.StatusType
    
    var body: some View {
        Image(systemName: status.systemImage)
            .foregroundStyle(status.color)
            .font(.system(size: 14, weight: .medium))
    }
}

#Preview {
    VStack(spacing: 16) {
        StatusIndicator(.success, message: "All fields are valid")
        StatusIndicator(.warning, message: "Interest rate seems high")
        StatusIndicator(.error, message: "Principal amount is required")
        StatusIndicator(.loading, message: "Calculating...")
        StatusIndicator(.info, message: "This calculation uses compound interest")
        
        HStack {
            StatusIcon(status: StatusIndicator.StatusType.success)
            StatusIcon(status: StatusIndicator.StatusType.warning)
            StatusIcon(status: StatusIndicator.StatusType.error)
            StatusIcon(status: StatusIndicator.StatusType.loading)
            StatusIcon(status: StatusIndicator.StatusType.info)
        }
    }
    .padding()
}
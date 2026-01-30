// ⌘
//  GymCat/GymCatApp/Views/Today/ReadOnlyTrackerRow.swift
//
//  Purpose:
//  Read-only version of TrackerRow used to display historical records.
//
//  Created by @jonathaxs on 2026-01-29.
// ⌘

import SwiftUI

struct ReadOnlyTrackerRow: View {
    
    // MARK: - Inputs
    let icon: String
    let title: String
    let unit: String
    let goal: Int
    let value: Int
    
    // MARK: - Computed values
    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(value) / Double(goal), 1.0)
    }
    
    private var metricText: String {
        "\(value) \(unit) / \(goal) \(unit)"
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Text(icon)
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(metricText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            ProgressView(value: Double(value), total: Double(goal))
                .tint(Color.accentColor)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .frame(height: 10)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ReadOnlyTrackerRow(
        icon: "🍗",
        title: "Protein",
        unit: "g",
        goal: 150,
        value: 120
    )
}

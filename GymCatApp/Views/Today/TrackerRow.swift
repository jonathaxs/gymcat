// ⌘
//
//  GymCat/GymCatApp/Views/Cat/TrackerRow.swift
//
//  Created by @jonathaxs on 2025-11-22.
//
// ⌘

import SwiftUI

// MARK: - Subviews
// Reusable subview to avoid duplicated logic.
struct TrackerRow: View {
    let icon: String
    let title: String
    let unit: String
    let increment: Int
    let goal: Int
    @Binding var value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(icon)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 8) {
                Text("\(value) \(unit) \(String(localized: "tracker.metric.separator")) \(goal) \(unit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                HStack(spacing: 5) {
                    Button(action: {
                        let newValue = value - increment
                        value = max(newValue, 0)
                    }) {
                        Text("-")
                            .font(.title2.bold())
                            .frame(minWidth: 60)
                    }
                    .buttonStyle(GlassButtonStyle(tint: .red))
                    
                    Button(action: {
                        let newValue = value + increment
                        value = min(newValue, goal)
                    }) {
                        Text("+")
                            .font(.title2.bold())
                            .frame(minWidth: 60)
                    }
                    .buttonStyle(GlassButtonStyle(tint: .blue))
                }
            }
            
            ProgressView(value: Float(value), total: Float(goal))
                .progressViewStyle(LinearProgressViewStyle())
                .tint(Color.green.opacity(0.9))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .frame(height: 10)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .padding(15)
        .background(Color(.systemGray6))
        .cornerRadius(25)
    }
}

// Glass-like button style with blur, rounded corners and subtle border.
struct GlassButtonStyle: ButtonStyle {
    let tint: Color
    
    init(tint: Color = .white) {
        self.tint = tint
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
            .background(
                Capsule()
                    .fill(tint.opacity(0.4))
            )
            .overlay(
                Capsule()
                    .strokeBorder(tint.opacity(0.6), lineWidth: 1)
            )
            .shadow(radius: 2)
            .scaleEffect(configuration.isPressed ? 0.5 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .animation(
                .easeInOut(duration: 0.15),
                value: configuration.isPressed
            )
    }
}

// ⌘
//  GymCat/GymCatApp/Views/Today/TrackerRow.swift
//
//  Purpose: Reusable tracker row with +/- controls and progress bar for a single metric.
//
//  Created by @jonathaxs on 2025-11-22.
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
    
    // Localized separator used between current value and goal (e.g. "of", "/", "de")
    // Extracted to keep localization logic out of the View body.
    private var separatorText: String {
        String(localized: "tracker.metric.separator")
    }

    // Pre-formatted metric text shown in the UI (e.g. "120 ml of 200 ml").
    // This keeps string composition separate from layout, improving readability and maintenance.
    private var metricText: String {
        "\(value) \(unit) \(separatorText) \(goal) \(unit)"
    }

    // Slider works with Double internally, so we bridge it to our Int-based model.
    // Dragging snaps to the same step used by the +/- buttons (`increment`).
    private var sliderValue: Binding<Double> {
        Binding(
            get: { Double(value) },
            set: { newValue in
                let step = max(1, increment)
                let snapped = (newValue / Double(step)).rounded() * Double(step)
                let clamped = min(max(snapped, 0), Double(goal))
                value = Int(clamped)
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(icon)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 8) {
                // Displays the metric text using the pre-composed string from `metricText`
                Text(metricText)
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
            
            // Fast input: drag to reach the target quickly.
            if goal > 0 {
                Slider(
                    value: sliderValue,
                    in: 0...Double(goal),
                    step: Double(max(1, increment))
                )
            }

        }
        .padding(15)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(25)
    }
}

// Glass-like button style with blur, rounded corners and subtle border.
struct GlassButtonStyle: ButtonStyle {
    let tint: Color

    private static let pressedScale: CGFloat = 0.92
    private static let pressedOpacity: Double = 0.85
    private static let animationDuration: Double = 0.15
    
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
            .scaleEffect(configuration.isPressed ? Self.pressedScale : 1.0)
            .opacity(configuration.isPressed ? Self.pressedOpacity : 1.0)
            .animation(
                .easeInOut(duration: Self.animationDuration),
                value: configuration.isPressed
            )
    }
}

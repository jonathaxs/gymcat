//
//  NutrientTrackerRow.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-11-22.
/*  Criado por @jonathaxs em 2025-11-22. */
//

import SwiftUI

// MARK: - Subviews
// Reusable subview to avoid duplicated logic.

/* MARK: - Subviews (Subcomponentes) */
/* Subview reutilizável para evitar duplicação de layout e lógica. */

struct NutrientTrackerRow: View {
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
                Text("\(value) \(unit) / \(goal) \(unit)")
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
                    }
                    .buttonStyle(GlassButtonStyle())

                    Button(action: {
                        let newValue = value + increment
                        value = min(newValue, goal)
                    }) {
                        Text("+")
                            .font(.title2.bold())
                    }
                    .buttonStyle(GlassButtonStyle())
                }
            }

            ProgressView(value: Float(value), total: Float(goal))
                .progressViewStyle(LinearProgressViewStyle())
                .tint(Color.green.opacity(0.9))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .frame(height: 10)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .padding(15)
        .background(Color(.systemGray6))
        .cornerRadius(25)
    }
}
// Glass-like button style with blur, rounded corners and subtle border.
/* Estilo de botão com aparência de vidro: blur, cantos arredondados e borda sutil. */
struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.5), lineWidth: 1)
            )
            .shadow(radius: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(
                .spring(response: 0.25, dampingFraction: 0.7),
                value: configuration.isPressed
            )
    }
}

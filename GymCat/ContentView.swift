//
//  ContentView.swift
//  GymCat App
//
//  Created by @jonathaxs on 2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("waterIntake") private var waterIntake: Int = 0
    @AppStorage("proteinIntake") private var proteinIntake: Int = 0
    @AppStorage("carbIntake") private var carbIntake: Int = 0
    @AppStorage("fatIntake") private var fatIntake: Int = 0

    let waterGoal = 2000
    let proteinGoal = 150
    let carbGoal = 250
    let fatGoal = 60

    var body: some View {
        VStack(spacing: 24) {
            Text("GymCat")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 24)

            NutrientTrackerRow(
                icon: "💧",
                title: "Água",
                unit: "ml",
                increment: 250,
                goal: waterGoal,
                value: $waterIntake
            )

            NutrientTrackerRow(
                icon: "🍗",
                title: "Proteína",
                unit: "g",
                increment: 10,
                goal: proteinGoal,
                value: $proteinIntake
            )

            NutrientTrackerRow(
                icon: "🍞",
                title: "Carboidratos",
                unit: "g",
                increment: 20,
                goal: carbGoal,
                value: $carbIntake
            )

            NutrientTrackerRow(
                icon: "🧈",
                title: "Gorduras",
                unit: "g",
                increment: 5,
                goal: fatGoal,
                value: $fatIntake
            )

            Button(action: {
                waterIntake = 0
                proteinIntake = 0
                carbIntake = 0
                fatIntake = 0
            }) {
                Text("Finalizar dia")
                    .font(.body)
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
    }
}

// This view is a reusable sub-component used only by ContentView.
struct NutrientTrackerRow: View {
    let icon: String
    let title: String
    let unit: String
    let increment: Int
    let goal: Int
    @Binding var value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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

                HStack(spacing: 6) {
                    Button(action: {
                        let newValue = value - increment
                        value = max(newValue, 0)
                    }) {
                        Text("-")
                            .font(.subheadline)
                            .frame(width: 60, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(6)
                    }

                    Button(action: {
                        let newValue = value + increment
                        value = min(newValue, goal)
                    }) {
                        Text("+")
                            .font(.subheadline)
                            .frame(width: 60, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
            }

            ProgressView(value: Float(value), total: Float(goal))
                .progressViewStyle(LinearProgressViewStyle())
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}

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
                Text("Resetar dia")
                    .font(.body)
                    .padding(8)
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

struct NutrientTrackerRow: View {
    let icon: String
    let title: String
    let unit: String
    let increment: Int
    let goal: Int
    @Binding var value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(icon)
                Text(title)
                    .font(.headline)
            }

            Text("\(value) \(unit) de \(goal) \(unit)")
                .font(.subheadline)

            ProgressView(value: Float(value), total: Float(goal))
                .progressViewStyle(LinearProgressViewStyle())

            Button(action: {
                let newValue = value + increment
                value = min(newValue, goal)
            }) {
                Text("+\(increment) \(unit)")
                    .font(.subheadline)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  GymCat App
//  Today Screen
//
//  Created by @jonathaxs on 2025-08-16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: - State & persisted values
    // Access to the SwiftData context so we can save a DailyRecord when the user finishes the day.
    @Environment(\.modelContext) private var modelContext
    @AppStorage("waterIntake") private var waterIntake: Int = 0
    @AppStorage("proteinIntake") private var proteinIntake: Int = 0
    @AppStorage("carbIntake") private var carbIntake: Int = 0
    @AppStorage("fatIntake") private var fatIntake: Int = 0
    @AppStorage("sleepHours") private var sleepHours: Int = 0

    // Default daily goals for each tracked metric.
    // In the future these values should come from user settings / onboarding instead of being hard-coded here.
    let waterGoal = 3000
    let proteinGoal = 150
    let carbGoal = 300
    let fatGoal = 80
    let sleepGoal = 7

    // MARK: - Daily progress helpers
    // These helpers normalize each intake into a 0...1 progress value, clamped to a maximum of 100%.
    private var waterProgress: Double {
        min(Double(waterIntake) / Double(waterGoal), 1.0)
    }

    private var proteinProgress: Double {
        min(Double(proteinIntake) / Double(proteinGoal), 1.0)
    }

    private var carbProgress: Double {
        min(Double(carbIntake) / Double(carbGoal), 1.0)
    }

    private var fatProgress: Double {
        min(Double(fatIntake) / Double(fatGoal), 1.0)
    }
    
    private var sleepProgress: Double {
        min(Double(sleepHours) / Double(sleepGoal), 1.0)
    }

    private var dailyProgress: Double {
        (waterProgress + proteinProgress + carbProgress + fatProgress + sleepProgress) / 5.0
    }

    private var dailyPercent: Int {
        Int(dailyProgress * 100)
    }
    
    // MARK: - Daily cat evaluation
    // NOTE: All these properties use the same threshold logic based on dailyProgress.
    // TODO: In a future refactor, extract this logic into a single model (e.g. an enum DailyCat)
    // that exposes emoji, title, color and points. That avoids repeating the same switch
    // over dailyProgress in multiple places.

    private var dailyCatEmoji: String {
        switch dailyProgress {
        case ..<0.5:
            return "😿"
        case ..<0.7:
            return "😺"
        case ..<0.9:
            return "🐈"
        default:
            return "🦁"
        }
    }

    private var dailyCatTitle: String {
        switch dailyProgress {
        case ..<0.5:
            return "Gato Triste"
        case ..<0.7:
            return "Gato Iniciante"
        case ..<0.9:
            return "Gato Fitness"
        default:
            return "Gato Forte"
        }
    }

    private var dailyCardColor: Color {
        switch dailyCatTitle {
        case "Gato Triste":
            return Color.red.opacity(0.30)
        case "Gato Iniciante":
            return Color.yellow.opacity(0.30)
        case "Gato Fitness":
            return Color.blue.opacity(0.30)
        case "Gato Forte":
            return Color.green.opacity(0.30)
        default:
            return Color.gray.opacity(0.30)
        }
    }

    private var dailyPoints: Int {
        switch dailyProgress {
        case ..<0.5:
            return 15
        case ..<0.7:
            return 55
        case ..<0.9:
            return 75
        default:
            return 105
        }
    }

    // MARK: - View body
    // Main layout for the "Hoje" screen: summary card at the top, followed by
    // each nutrient/sleep tracker row and the "Finalizar Dia" action button.
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Screen header
                Text("Hoje")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 0)

                // Daily summary card: current cat, progress percentage and points
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        Text(dailyCatEmoji)
                            .font(.largeTitle)

                        VStack(alignment: .leading, spacing: 10) {
                            Text(dailyCatTitle)
                                .font(.headline)
                            Text("Progresso do dia: ")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            + Text("\(dailyPercent)%")
                                .font(.subheadline.bold())
                        }

                        Spacer()

                        Text("\(dailyPoints) pts")
                            .font(.headline)
                    }
                }
                .padding(20)
                .background(dailyCardColor)
                .cornerRadius(25)
                
                // Individual trackers for each metric
                NutrientTrackerRow(
                    icon: "😴",
                    title: "Sono",
                    unit: "h",
                    increment: 1,
                    goal: sleepGoal,
                    value: $sleepHours
                )

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
                    increment: 20,
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

                // When the user finishes the day, we save a DailyRecord and reset all counters.
                Button(action: {
                    let record = DailyRecord(
                        date: Date(),
                        water: waterIntake,
                        protein: proteinIntake,
                        carb: carbIntake,
                        fat: fatIntake,
                        sleep: sleepHours,
                        percent: dailyPercent,
                        catTitle: dailyCatTitle,
                        catEmoji: dailyCatEmoji,
                        points: dailyPoints
                    )
                    modelContext.insert(record)

                    waterIntake = 0
                    proteinIntake = 0
                    carbIntake = 0
                    fatIntake = 0
                    sleepHours = 0
                }) {
                    Text("Finalizar Dia")
                        .font(.body.bold())
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.6))
                        .foregroundColor(.primary)
                        .cornerRadius(20)
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            }
    }
}

// MARK: - Subviews
// This View is a reusable sub-component used only by ContentView to avoid repeating the same
// layout and logic for Água, Proteína, Carboidratos, Gorduras e Sono.

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
                            .frame(width: 80, height: 40)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }

                    Button(action: {
                        let newValue = value + increment
                        value = min(newValue, goal)
                    }) {
                        Text("+")
                            .font(.title2.bold())
                            .frame(width: 80, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
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

#Preview {
    ContentView()
}

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
    @Environment(\.modelContext) private var modelContext
    @AppStorage("waterIntake") private var waterIntake: Int = 0
    @AppStorage("proteinIntake") private var proteinIntake: Int = 0
    @AppStorage("carbIntake") private var carbIntake: Int = 0
    @AppStorage("fatIntake") private var fatIntake: Int = 0
    @AppStorage("sleepHours") private var sleepHours: Int = 0

    let waterGoal = 2000
    let proteinGoal = 150
    let carbGoal = 250
    let fatGoal = 60
    let sleepGoal = 7

    // Daily progress helpers
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

    private var dailyCatEmoji: String {
        switch dailyProgress {
        case ..<0.50:
            return "😿"
        case ..<0.75:
            return "😺"
        case ..<1.0:
            return "🐈"
        default:
            return "🦁"
        }
    }

    private var dailyCatTitle: String {
        switch dailyProgress {
        case ..<0.50:
            return "Gato Triste"
        case ..<0.75:
            return "Gato Iniciante"
        case ..<1.0:
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
        case ..<0.50:
            return 15
        case ..<0.75:
            return 45
        case ..<1.0:
            return 75
        default:
            return 100
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Hoje")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 0)

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

// This View is a reusable sub-component used only by ContentView.

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

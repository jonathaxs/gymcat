//
//  TodayView.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-08-16.
/*  Criado por @jonathaxs em 2025-08-16. */
//

import SwiftUI
import SwiftData

// MARK: - DailyCat (Enum for cat categories)
// Represents the daily cat categories based on progress.
// Centralizes emoji, name, color and points in a single type.

/* MARK: - DailyCat (Enum de categorias de gato) */
/* Representa as categorias de gato do dia com base no progresso. */
/* Centraliza emoji, nome, cor e pontos em um único tipo. */
enum DailyCat {
    case triste
    case iniciante
    case fitness
    case forte
}

// Extension adding calculation logic and derived properties.
// Defines how progress maps to a DailyCat and which emoji, name,
// color and points belong to each case.

/* Extensão com lógica de cálculo e propriedades derivadas. */
/* Aqui definimos como o progresso vira um DailyCat e quais */
/* são os atributos (emoji, nome, cor e pontos) de cada caso. */
extension DailyCat {
    static func from(progress: Double) -> DailyCat {
        switch progress {
        case ..<0.5:
            return .triste
        case ..<0.7:
            return .iniciante
        case ..<0.9:
            return .fitness
        default:
            return .forte
        }
    }

    var emoji: String {
        switch self {
        case .triste:
            return "😿"
        case .iniciante:
            return "😺"
        case .fitness:
            return "🐈"
        case .forte:
            return "🦁"
        }
    }

    var name: String {
        switch self {
        case .triste:
            return "Gato Triste"
        case .iniciante:
            return "Gato Iniciante"
        case .fitness:
            return "Gato Fitness"
        case .forte:
            return "Gato Forte"
        }
    }

    var color: Color {
        switch self {
        case .triste:
            return Color.red.opacity(0.30)
        case .iniciante:
            return Color.yellow.opacity(0.30)
        case .fitness:
            return Color.blue.opacity(0.30)
        case .forte:
            return Color.green.opacity(0.30)
        }
    }

    var points: Int {
        switch self {
        case .triste:
            return 15
        case .iniciante:
            return 55
        case .fitness:
            return 75
        case .forte:
            return 105
        }
    }
}

struct TodayView: View {
    // MARK: - State & persisted values
    // Access to the SwiftData context and variables persisted using @AppStorage.

    /* MARK: - States & valores persistidos */
    /* Acesso ao contexto do SwiftData e variáveis persistidas com @AppStorage. */
    @Environment(\.modelContext) private var modelContext
    @AppStorage("waterIntake") private var waterIntake: Int = 0
    @AppStorage("proteinIntake") private var proteinIntake: Int = 0
    @AppStorage("carbIntake") private var carbIntake: Int = 0
    @AppStorage("fatIntake") private var fatIntake: Int = 0
    @AppStorage("sleepHours") private var sleepHours: Int = 0

    // Default daily goals for each tracked metric.
    // In the future these should come from user settings.

    /* Metas diárias padrão para cada métrica acompanhada. */
    /* No futuro, virão das configurações do usuário. */
    let waterGoal = 3000
    let proteinGoal = 150
    let carbGoal = 300
    let fatGoal = 80
    let sleepGoal = 7

    // MARK: - Daily progress helpers
    // Normalizes each intake into values between 0...1.

    /* MARK: - Auxiliares de cálculo de progresso diário */
    /* Normaliza consumo para valores entre 0...1. */
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

    private var dailyPercentage: Int {
        Int(dailyProgress * 100)
    }
    
    // Daily cat category computed from the average progress.
    // Uses the DailyCat enum to unify emoji, name, color and points.

    /* Categoria de gato do dia calculada a partir do progresso médio. */
    /* Usa o enum DailyCat para unificar emoji, nome, cor e pontos. */
    private var dailyCat: DailyCat {
        DailyCat.from(progress: dailyProgress)
    }

    // MARK: - View body
    // Main layout for the "Today" screen.

    /* MARK: - Corpo da View */
    /* Estrutura visual da tela principal "Hoje". */
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
                        Text(dailyCat.emoji)
                            .font(.largeTitle)

                        VStack(alignment: .leading, spacing: 10) {
                            Text(dailyCat.name)
                                .font(.headline)
                            Text("Progresso do dia: ")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            + Text("\(dailyPercentage)%")
                                .font(.subheadline.bold())
                        }

                        Spacer()

                        Text("\(dailyCat.points) pts")
                            .font(.headline)
                    }
                }
                .padding(20)
                .background(dailyCat.color)
                .cornerRadius(25)
                
                // Individual trackers for each metric.
                // Each one uses the NutrientTrackerRow subview.

                /* Blocos individuais de acompanhamento. */
                /* Cada um utiliza a subview NutrientTrackerRow. */
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

                /* Quando o usuário finaliza o dia, salvamos um DailyRecord e zeramos todos os contadores. */
                Button(action: {
                    let record = DailyRecord(
                        date: Date(),
                        waterAmount: waterIntake,
                        proteinAmount: proteinIntake,
                        carbAmount: carbIntake,
                        fatAmount: fatIntake,
                        sleepHours: sleepHours,
                        percentValue: dailyPercentage,
                        catTitle: dailyCat.name,
                        catEmoji: dailyCat.emoji,
                        pointsEarned: dailyCat.points
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
    TodayView()
}

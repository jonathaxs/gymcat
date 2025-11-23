//
//  TodayView.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-08-16.
/*  Criado por @jonathaxs em 2025-08-16. */
//

import SwiftUI
import SwiftData

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
    private func calculateProgress(current: Int, goal: Int) -> Double {
        min(Double(current) / Double(goal), 1.0)
    }

    private var waterProgress: Double {
        calculateProgress(current: waterIntake, goal: waterGoal)
    }

    private var proteinProgress: Double {
        calculateProgress(current: proteinIntake, goal: proteinGoal)
    }

    private var carbProgress: Double {
        calculateProgress(current: carbIntake, goal: carbGoal)
    }

    private var fatProgress: Double {
        calculateProgress(current: fatIntake, goal: fatGoal)
    }
    
    private var sleepProgress: Double {
        calculateProgress(current: sleepHours, goal: sleepGoal)
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

    // MARK: - Actions
    // Encapsulates logic to finish the day and save data.

    /* MARK: - Ações */
    /* Encapsula lógica para finalizar o dia e salvar dados. */
    private func finishDay() {
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
                Button(action: finishDay) {
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


#Preview {
    TodayView()
}

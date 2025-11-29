//
//  GymCat/GymCatApp/Views/Today/TodayView.swift
//
//  Created by @jonathaxs on 2025-08-16.
/*  Criado por @jonathaxs em 2025-08-16. */
// ⌘

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
    @AppStorage("lastFinishedDate") private var lastFinishedDate: String = ""

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

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // MARK: - Actions
    // Encapsulates logic to finish the day and save data.

    /* MARK: - Ações */
    /* Encapsula lógica para finalizar o dia e salvar dados. */
    /* MARK: - Ações */
    /* Encapsula lógica para finalizar o dia e salvar dados. */
    private func finishSpecificDay(_ date: Date) {
        let record = DailyRecord(
            date: date,
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
    }

    private func finishDay() {
        waterIntake = 0
        proteinIntake = 0
        carbIntake = 0
        fatIntake = 0
        sleepHours = 0
    }

    private func checkIfNewDay() {
        let todayString = dateString(from: Date())

        // If the app has never saved a date before, initialize and exit.
        /* Se o app nunca salvou uma data antes, inicializa e sai. */
        if lastFinishedDate.isEmpty {
            lastFinishedDate = todayString
            return
        }

        // If the day did not change, do nothing.
        /* Se o dia não mudou, não faz nada. */
        if todayString == lastFinishedDate {
            return
        }

        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        // Parse the last finished date from storage.
        /* Converte a última data finalizada salva. */
        guard let lastDate = formatter.date(from: lastFinishedDate) else {
            lastFinishedDate = todayString
            finishDay()
            return
        }

        // 1) Save ONLY the real last day using the user's actual data.
        /* 1) Salva APENAS o último dia real usando os dados atuais do usuário. */
        finishSpecificDay(lastDate)

        // 2) Reset metrics BEFORE generating missing days.
        /* 2) Zera as métricas ANTES de gerar os dias perdidos. */
        finishDay()

        // 3) Generate "Sad Cat" records for all missing days (except today).
        /* 3) Gera registros "Gato Triste" para todos os dias perdidos (exceto hoje). */
        var cursor = calendar.date(byAdding: .day, value: 1, to: lastDate)!

        let todayStart = calendar.startOfDay(for: Date())

        while cursor < todayStart {
            // Create Sad Cat with zero progress.
            /* Cria Gato Triste com progresso zero. */
            let sad = DailyCat.sad

            let sadRecord = DailyRecord(
                date: cursor,
                waterAmount: 0,
                proteinAmount: 0,
                carbAmount: 0,
                fatAmount: 0,
                sleepHours: 0,
                percentValue: 0,
                catTitle: sad.name,
                catEmoji: sad.emoji,
                pointsEarned: sad.points
            )

            modelContext.insert(sadRecord)

            // Move to the next day.
            /* Avança para o próximo dia. */
            cursor = calendar.date(byAdding: .day, value: 1, to: cursor)!
        }

        // 4) Update lastFinishedDate to today.
        /* 4) Atualiza a última data finalizada para hoje. */
        lastFinishedDate = todayString

        // 5) The new day starts clean with all metrics already zero.
        /* 5) O novo dia já começa limpo com todas as métricas zeradas. */
    }

    // MARK: - View body
    // Main layout for the "Today" screen.

    /* MARK: - Corpo da View */
    /* Estrutura visual da tela principal "Hoje". */
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                // Screen header and Daily summary card
                
                /* Cabeçalho e Card de resumo diário */
                /* Cabeçalho e Card de resumo diário */
                DailySummaryCard(
                    dailyCat: dailyCat,
                    dailyPercentage: dailyPercentage
                )
                
                // Individual trackers for each metric.
                // Each one uses the NutrientTrackerRow subview.

                /* Blocos individuais de acompanhamento. */
                /* Cada um utiliza a subview NutrientTrackerRow. */
                NutrientTrackerRow(
                    icon: "😴",
                    title: String(localized: "today.metric.sleep"),
                    unit: "h",
                    increment: 1,
                    goal: sleepGoal,
                    value: $sleepHours
                )

                NutrientTrackerRow(
                    icon: "💧",
                    title: String(localized: "today.metric.water"),
                    unit: "ml",
                    increment: 250,
                    goal: waterGoal,
                    value: $waterIntake
                )

                NutrientTrackerRow(
                    icon: "🍗",
                    title: String(localized: "today.metric.protein"),
                    unit: "g",
                    increment: 20,
                    goal: proteinGoal,
                    value: $proteinIntake
                )

                NutrientTrackerRow(
                    icon: "🍞",
                    title: String(localized: "today.metric.carbs"),
                    unit: "g",
                    increment: 20,
                    goal: carbGoal,
                    value: $carbIntake
                )

                NutrientTrackerRow(
                    icon: "🧈",
                    title: String(localized: "today.metric.fats"),
                    unit: "g",
                    increment: 5,
                    goal: fatGoal,
                    value: $fatIntake
                )

                // When the user finishes the day, we save a DailyRecord and reset all counters.

                /* Quando o usuário finaliza o dia, salvamos um DailyRecord e zeramos todos os contadores. */
                // Button removed, now inside DailySummaryCard

                Spacer()
            }
            .padding()
        }
        .onAppear {
            checkIfNewDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            checkIfNewDay()
        }
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            checkIfNewDay()
        }
    }
}

#Preview {
    TodayView()
}

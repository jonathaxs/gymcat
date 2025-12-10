// ⌘
//
//  /Users/jonathaxs/Developer/GymCatProject/GymCat/GymCatApp/Views/Achievements/EditRecordView.swift
//
//  Created by @jonathaxs on 2025-12-10.
//
// ⌘

import SwiftUI
import SwiftData

// MARK: - EditRecordView
// Screen used to edit an existing DailyRecord up to 72 hours after its date.
// Reuses the same goals and visual components from CatView (CatCard + TrackerRow).
struct EditRecordView: View {
    
    // Daily record selected from AchievementsView.
    let record: DailyRecord
    
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Editable values
    // Local state mirrors the stored values and is used for editing.
    @State private var water: Int
    @State private var protein: Int
    @State private var carb: Int
    @State private var fat: Int
    @State private var sleep: Int
    
    // MARK: - Goals
    // Uses the same default goals as CatView / TodayView.
    private let waterGoal = 3000
    private let proteinGoal = 150
    private let carbGoal = 300
    private let fatGoal = 80
    private let sleepGoal = 7
    
    // MARK: - Initializer
    // Initializes the local state using the existing values of the record.
    init(record: DailyRecord) {
        self.record = record
        _water = State(initialValue: record.water)
        _protein = State(initialValue: record.protein)
        _carb = State(initialValue: record.carb)
        _fat = State(initialValue: record.fat)
        _sleep = State(initialValue: record.sleep)
    }
    
    // MARK: - Progress helpers
    private func calculateProgress(current: Int, goal: Int) -> Double {
        min(Double(current) / Double(goal), 1.0)
    }
    
    private var waterProgress: Double {
        calculateProgress(current: water, goal: waterGoal)
    }
    
    private var proteinProgress: Double {
        calculateProgress(current: protein, goal: proteinGoal)
    }
    
    private var carbProgress: Double {
        calculateProgress(current: carb, goal: carbGoal)
    }
    
    private var fatProgress: Double {
        calculateProgress(current: fat, goal: fatGoal)
    }
    
    private var sleepProgress: Double {
        calculateProgress(current: sleep, goal: sleepGoal)
    }
    
    private var dailyProgress: Double {
        (waterProgress + proteinProgress + carbProgress + fatProgress + sleepProgress) / 5.0
    }
    
    private var dailyPercentage: Int {
        Int(dailyProgress * 100)
    }
    
    private var dailyCat: DailyCat {
        DailyCat.from(progress: dailyProgress)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    
                    // Summary card showing the current cat and percentage based on the edited values.
                    CatCard(
                        dailyCat: dailyCat,
                        dailyPercentage: dailyPercentage
                    )
                    
                    // Editable rows for each metric, reusing TrackerRow.
                    TrackerRow(
                        icon: "😴",
                        title: String(localized: "today.metric.sleep"),
                        unit: "h",
                        increment: 1,
                        goal: sleepGoal,
                        value: $sleep
                    )
                    
                    TrackerRow(
                        icon: "💧",
                        title: String(localized: "today.metric.water"),
                        unit: "ml",
                        increment: 250,
                        goal: waterGoal,
                        value: $water
                    )
                    
                    TrackerRow(
                        icon: "🍗",
                        title: String(localized: "today.metric.protein"),
                        unit: "g",
                        increment: 20,
                        goal: proteinGoal,
                        value: $protein
                    )
                    
                    TrackerRow(
                        icon: "🍞",
                        title: String(localized: "today.metric.carbs"),
                        unit: "g",
                        increment: 20,
                        goal: carbGoal,
                        value: $carb
                    )
                    
                    TrackerRow(
                        icon: "🧈",
                        title: String(localized: "today.metric.fats"),
                        unit: "g",
                        increment: 5,
                        goal: fatGoal,
                        value: $fat
                    )
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "edit.record.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "edit.record.save")) {
                        saveChanges()
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    // Applies the edited values back into the DailyRecord and recalculates cat and points.
    private func saveChanges() {
        
        // Update stored values.
        record.water = water
        record.protein = protein
        record.carb = carb
        record.fat = fat
        record.sleep = sleep
        
        // Recalculate percentage and cat based on the edited data.
        record.percent = dailyPercentage
        record.catTitle = dailyCat.name
        record.catEmoji = dailyCat.emoji
        record.points = dailyCat.points
        
        // SwiftData will track and persist these changes automatically.
        // Dismiss the edit screen when done.
        dismiss()
    }
}

#Preview {
    // Simple preview using a sample DailyRecord.
    let sample = DailyRecord(
        waterAmount: 1500,
        proteinAmount: 80,
        carbAmount: 200,
        fatAmount: 50,
        sleepHours: 6,
        percentValue: 70,
        catTitle: DailyCat.fitness.name,
        catEmoji: DailyCat.fitness.emoji,
        pointsEarned: DailyCat.fitness.points
    )
    
    return EditRecordView(record: sample)
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

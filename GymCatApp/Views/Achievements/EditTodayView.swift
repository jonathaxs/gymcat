// ⌘
//  GymCat/GymCatApp/Views/Achievements/EditTodayView.swift
//
//  Purpose: Edit screen to update a recent DailyRecord and recalculate the cat and points.
//
//  Created by @jonathaxs on 2025-12-10.
// ⌘

import SwiftUI
import SwiftData

// MARK: - EditRecordView
// Screen used to edit an existing DailyRecord up to 72 hours after its date.
// Reuses the same goals and visual components from TodayView (CatCard + TrackerRow).
struct EditTodayView: View {
    
    // Daily record selected from AchievementsView.
    let record: DailyRecord
    
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Editable values
    // Local state mirrors the stored values and is used for editing.
    @State private var water: Int
    @State private var protein: Int
    @State private var carb: Int
    @State private var fat: Int
    @State private var creatine: Int
    @State private var sleep: Int
    
    // MARK: - Goals
    // Uses the same default goals as TodayView.
    // Centralized via GoalsProvider to ease future Settings migration.
    private let waterGoal: Int = GoalsProvider.water
    private let proteinGoal: Int = GoalsProvider.protein
    private let carbGoal: Int = GoalsProvider.carbs
    private let fatGoal: Int = GoalsProvider.fats
    private let creatineGoal: Int = GoalsProvider.creatine
    private let sleepGoal: Int = GoalsProvider.sleep
    
    // MARK: - Initializer
    // Initializes the local state using the existing values of the record.
    init(record: DailyRecord) {
        self.record = record
        _water = State(initialValue: record.water)
        _protein = State(initialValue: record.protein)
        _carb = State(initialValue: record.carb)
        _fat = State(initialValue: record.fat)
        _creatine = State(initialValue: record.creatine)
        _sleep = State(initialValue: record.sleep)
    }
    
    // MARK: - Progress helpers
    
    private var waterProgress: Double {
        ProgressHelpers.normalizedProgress(current: water, goal: waterGoal)
    }
    
    private var proteinProgress: Double {
        ProgressHelpers.normalizedProgress(current: protein, goal: proteinGoal)
    }
    
    private var carbProgress: Double {
        ProgressHelpers.normalizedProgress(current: carb, goal: carbGoal)
    }
    
    private var fatProgress: Double {
        ProgressHelpers.normalizedProgress(current: fat, goal: fatGoal)
    }
    
    private var creatineProgress: Double {
        ProgressHelpers.normalizedProgress(current: creatine, goal: creatineGoal)
    }
    
    private var sleepProgress: Double {
        ProgressHelpers.normalizedProgress(current: sleep, goal: sleepGoal)
    }
    
    private var progressValues: [Double] {
        [
            waterProgress,
            proteinProgress,
            carbProgress,
            fatProgress,
            creatineProgress,
            sleepProgress
        ]
    }

    private var dailyProgress: Double {
        guard !progressValues.isEmpty else { return 0 }
        return progressValues.reduce(0, +) / Double(progressValues.count)
    }

    private var dailyPercentage: Int {
        Int((dailyProgress * 100).rounded())
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
                    
                    TrackerRow(
                        icon: "⚡️",
                        title: String(localized: "today.metric.creatine"),
                        unit: "g",
                        increment: 2,
                        goal: creatineGoal,
                        value: $creatine
                    )
                    Spacer()
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
        record.creatine = creatine
        record.sleep = sleep

        // If the user provided sleep hours, mirror the value into Apple Health.
        // Safe no-op if HealthKit is unavailable or not authorized.
        HealthKitManager.shared.writeSleepIfNeeded(for: record.date, hours: sleep)
        
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
        water: 1500,
        protein: 80,
        carb: 200,
        fat: 50,
        creatine: 3,
        sleep: 6,
        percent: 70,
        catTitle: DailyCat.fitness.name,
        catEmoji: DailyCat.fitness.emoji,
        points: DailyCat.fitness.points
    )
    EditTodayView(record: sample)
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

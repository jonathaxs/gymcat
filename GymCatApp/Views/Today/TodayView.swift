// ⌘
//  GymCat/GymCatApp/Views/Today/TodayView.swift
//
//  Purpose: Main “Today” screen where users track daily metrics and finish the day.
//
//  Created by @jonathaxs on 2025-08-16.
// ⌘

import SwiftUI
import SwiftData
import HealthKit

struct TodayView: View {
    
    // MARK: - State & persisted values
    // Access to the SwiftData context and variables persisted using @AppStorage.
    @Environment(\.modelContext) private var modelContext
    @AppStorage("waterIntake") private var waterIntake: Int = 0
    @AppStorage("proteinIntake") private var proteinIntake: Int = 0
    @AppStorage("carbIntake") private var carbIntake: Int = 0
    @AppStorage("fatIntake") private var fatIntake: Int = 0
    @AppStorage("creatineIntake") private var creatineIntake: Int = 0
    @AppStorage("sleepHours") private var sleepHours: Int = 0
    @AppStorage("lastFinishedDate") private var lastFinishedDate: String = ""
    
    // Default daily goals for each tracked metric.
    // In the future these should come from user settings.
    private let waterGoal: Int = DefaultGoals.water
    private let proteinGoal: Int = DefaultGoals.protein
    private let carbGoal: Int = DefaultGoals.carbs
    private let fatGoal: Int = DefaultGoals.fats
    private let creatineGoal: Int = DefaultGoals.creatine
    private let sleepGoal: Int = DefaultGoals.sleep
    
    // MARK: - Daily progress helpers
    // Normalizes each metric into values between 0...1.
    
    private var waterProgress: Double {
        ProgressHelpers.clampedProgress(current: waterIntake, goal: waterGoal)
    }
    
    private var proteinProgress: Double {
        ProgressHelpers.clampedProgress(current: proteinIntake, goal: proteinGoal)
    }
    
    private var carbProgress: Double {
        ProgressHelpers.clampedProgress(current: carbIntake, goal: carbGoal)
    }
    
    private var fatProgress: Double {
        ProgressHelpers.clampedProgress(current: fatIntake, goal: fatGoal)
    }
    
    private var creatineProgress: Double {
        ProgressHelpers.clampedProgress(current: creatineIntake, goal: creatineGoal)
    }
    
    private var sleepProgress: Double {
        ProgressHelpers.clampedProgress(current: sleepHours, goal: sleepGoal)
    }
    
    private var dailyProgress: Double {
        (waterProgress + proteinProgress + carbProgress + fatProgress + creatineProgress + sleepProgress) / 6.0
    }
    
    private var dailyPercentage: Int {
        Int(dailyProgress * 100)
    }
    
    // Daily cat category computed from the average progress.
    // Uses the DailyCat enum to unify emoji, name, color and points.
    private var dailyCat: DailyCat {
        DailyCat.from(progress: dailyProgress)
    }
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private static let healthStore = HKHealthStore()
    
    private func dateString(from date: Date) -> String {
        Self.dayFormatter.string(from: date)
    }
    
    // Writes Sleep Analysis to Apple Health for the finished day.
    // If `sleepHours` is 0, Health data is unavailable, or permissions are missing, it safely does nothing.
    private func writeSleepToHealthIfNeeded(for date: Date) {
        guard sleepHours > 0 else { return }
        guard HKHealthStore.isHealthDataAvailable() else { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = start.addingTimeInterval(TimeInterval(sleepHours) * 60 * 60)

        let sample = HKCategorySample(
            type: sleepType,
            value: HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
            start: start,
            end: end
        )

        Self.healthStore.save(sample) { _, _ in
            // Intentionally ignored: if saving fails, the app should continue normally.
        }
    }
    
    // MARK: - Actions
    // Encapsulates logic to finish the day and save data.
    private func finishSpecificDay(_ date: Date) {
        let record = DailyRecord(
            date: date,
            waterAmount: waterIntake,
            proteinAmount: proteinIntake,
            carbAmount: carbIntake,
            fatAmount: fatIntake,
            creatineAmount: creatineIntake,
            sleepHours: sleepHours,
            percentValue: dailyPercentage,
            catTitle: dailyCat.name,
            catEmoji: dailyCat.emoji,
            pointsEarned: dailyCat.points
        )
        modelContext.insert(record)
        writeSleepToHealthIfNeeded(for: date)
    }
    
    private func finishDay() {
        waterIntake = 0
        proteinIntake = 0
        carbIntake = 0
        fatIntake = 0
        creatineIntake = 0
        sleepHours = 0
    }
    
    private func checkIfNewDay() {
        let todayString = dateString(from: Date())
        
        // If the app has never saved a date before, initialize and exit.
        if lastFinishedDate.isEmpty {
            lastFinishedDate = todayString
            return
        }
        
        // If the day did not change, do nothing.
        if todayString == lastFinishedDate {
            return
        }
        
        let calendar = Calendar.current
        
        // Parse the last finished date from storage.
        guard let lastDate = Self.dayFormatter.date(from: lastFinishedDate) else {
            lastFinishedDate = todayString
            finishDay()
            return
        }
        
        // 1) Save ONLY the real last day using the user's actual data.
        finishSpecificDay(lastDate)
        
        // 2) Reset metrics BEFORE generating missing days.
        finishDay()
        
        // 3) Generate "Sad Cat" records for missing past days only (from the day after lastDate up to yesterday).
        var cursor = calendar.date(byAdding: .day, value: 1, to: lastDate)!
        
        let todayStart = calendar.startOfDay(for: Date())
        
        while cursor < todayStart {
            // Create Sad Cat with zero progress.
            let sad = DailyCat.sad
            
            let sadRecord = DailyRecord(
                date: cursor,
                waterAmount: 0,
                proteinAmount: 0,
                carbAmount: 0,
                fatAmount: 0,
                creatineAmount: 0,
                sleepHours: 0,
                percentValue: 0,
                catTitle: sad.name,
                catEmoji: sad.emoji,
                pointsEarned: sad.points
            )
            
            modelContext.insert(sadRecord)
            
            // Move to the next day.
            cursor = calendar.date(byAdding: .day, value: 1, to: cursor)!
        }
        
        // 4) Update lastFinishedDate to today.
        lastFinishedDate = todayString
        
        // 5) The new day starts clean with all metrics already zero.
    }
    
    // MARK: - View body
    // Main layout for the "cat" screen.
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                // Screen header and Daily summary card
                CatCard(
                    dailyCat: dailyCat,
                    dailyPercentage: dailyPercentage
                )
                
                // Individual trackers for each metric.
                // Each one uses the TrackerRow subview.
                TrackerRow(
                    icon: "😴",
                    title: String(localized: "today.metric.sleep"),
                    unit: "h",
                    increment: 1,
                    goal: sleepGoal,
                    value: $sleepHours
                )
                
                TrackerRow(
                    icon: "💧",
                    title: String(localized: "today.metric.water"),
                    unit: "ml",
                    increment: 250,
                    goal: waterGoal,
                    value: $waterIntake
                )
                
                TrackerRow(
                    icon: "🍗",
                    title: String(localized: "today.metric.protein"),
                    unit: "g",
                    increment: 20,
                    goal: proteinGoal,
                    value: $proteinIntake
                )
                
                TrackerRow(
                    icon: "🍞",
                    title: String(localized: "today.metric.carbs"),
                    unit: "g",
                    increment: 20,
                    goal: carbGoal,
                    value: $carbIntake
                )
                
                TrackerRow(
                    icon: "🧈",
                    title: String(localized: "today.metric.fats"),
                    unit: "g",
                    increment: 5,
                    goal: fatGoal,
                    value: $fatIntake
                )
                
                TrackerRow(
                    icon: "⚡️",
                    title: String(localized: "today.metric.creatine"),
                    unit: "g",
                    increment: 2,
                    goal: creatineGoal,
                    value: $creatineIntake
                )
                // When the user finishes the day, we save a DailyRecord and reset all counters.
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

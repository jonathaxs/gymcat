// ⌘
//  GymCat/GymCatApp/Views/Today/TodayView.swift
//
//  Purpose: Main “Today” screen where users track daily metrics and finish the day.
//
//  Created by @jonathaxs on 2025-08-16.
// ⌘

import SwiftUI
import SwiftData

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
    // Centralized via GoalsProvider to ease future Settings migration.
    private let waterGoal: Int = GoalsProvider.water
    private let proteinGoal: Int = GoalsProvider.protein
    private let carbGoal: Int = GoalsProvider.carbs
    private let fatGoal: Int = GoalsProvider.fats
    private let creatineGoal: Int = GoalsProvider.creatine
    private let sleepGoal: Int = GoalsProvider.sleep
    
    // MARK: - Daily progress helpers
    // Normalizes each metric into values between 0...1.
    
    private var waterProgress: Double {
        ProgressHelpers.normalizedProgress(current: waterIntake, goal: waterGoal)
    }
    
    private var proteinProgress: Double {
        ProgressHelpers.normalizedProgress(current: proteinIntake, goal: proteinGoal)
    }
    
    private var carbProgress: Double {
        ProgressHelpers.normalizedProgress(current: carbIntake, goal: carbGoal)
    }
    
    private var fatProgress: Double {
        ProgressHelpers.normalizedProgress(current: fatIntake, goal: fatGoal)
    }
    
    private var creatineProgress: Double {
        ProgressHelpers.normalizedProgress(current: creatineIntake, goal: creatineGoal)
    }
    
    private var sleepProgress: Double {
        ProgressHelpers.normalizedProgress(current: sleepHours, goal: sleepGoal)
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
    
    private func dateString(from date: Date) -> String {
        Self.dayFormatter.string(from: date)
    }
    
    // MARK: - Actions
    // Encapsulates logic to finish the day and save data.
    private func finishSpecificDay(_ date: Date) {
        let record = DailyRecord(
            date: date,
            water: waterIntake,
            protein: proteinIntake,
            carb: carbIntake,
            fat: fatIntake,
            creatine: creatineIntake,
            sleep: sleepHours,
            percent: dailyPercentage,
            catTitle: dailyCat.name,
            catEmoji: dailyCat.emoji,
            points: dailyCat.points
        )
        modelContext.insert(record)
        HealthKitManager.shared.writeSleepIfNeeded(for: date, hours: sleepHours)
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
                water: 0,
                protein: 0,
                carb: 0,
                fat: 0,
                creatine: 0,
                sleep: 0,
                percent: 0,
                catTitle: sad.name,
                catEmoji: sad.emoji,
                points: sad.points
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
                    icon: "🌙",
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

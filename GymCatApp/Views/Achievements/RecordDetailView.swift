// ⌘
//  GymCat/GymCatApp/Views/Achievements/RecordDetailView.swift
//
//  Purpose: Read-only detail screen for a historical DailyRecord.
//
//  Created by @jonathaxs on 2026-01-29.
// ⌘

import SwiftUI

struct RecordDetailView: View {

    @Environment(\.dismiss) private var dismiss

    // MARK: - Navigation actions
    let canEdit: Bool
    let onEdit: () -> Void

    // MARK: - Inputs
    let record: DailyRecord

    // MARK: - Goals
    // For now we use the app default goals (hard-coded provider).
    // In the future this can be sourced from Settings.
    private let waterGoal: Int = GoalsProvider.water
    private let proteinGoal: Int = GoalsProvider.protein
    private let carbGoal: Int = GoalsProvider.carbs
    private let fatGoal: Int = GoalsProvider.fats
    private let creatineGoal: Int = GoalsProvider.creatine
    private let sleepGoal: Int = GoalsProvider.sleep

    // MARK: - View
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Summary card for this specific day
                CatCard(
                    dailyCat: DailyCat.from(emoji: record.catEmoji),
                    dailyPercentage: record.percent,
                    headerDate: record.date
                )

                Divider()
                    .opacity(0.6)

                // Metrics read-only rows
                ReadOnlyTrackerRow(
                    icon: "🌙",
                    title: String(localized: "today.metric.sleep"),
                    unit: "h",
                    goal: sleepGoal,
                    value: record.sleep
                )

                ReadOnlyTrackerRow(
                    icon: "💧",
                    title: String(localized: "today.metric.water"),
                    unit: "ml",
                    goal: waterGoal,
                    value: record.water
                )

                ReadOnlyTrackerRow(
                    icon: "🍗",
                    title: String(localized: "today.metric.protein"),
                    unit: "g",
                    goal: proteinGoal,
                    value: record.protein
                )

                ReadOnlyTrackerRow(
                    icon: "🍞",
                    title: String(localized: "today.metric.carbs"),
                    unit: "g",
                    goal: carbGoal,
                    value: record.carb
                )

                ReadOnlyTrackerRow(
                    icon: "🧈",
                    title: String(localized: "today.metric.fats"),
                    unit: "g",
                    goal: fatGoal,
                    value: record.fat
                )

                ReadOnlyTrackerRow(
                    icon: "⚡️",
                    title: String(localized: "today.metric.creatine"),
                    unit: "g",
                    goal: creatineGoal,
                    value: record.creatine
                )

                Spacer(minLength: 0)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(String(localized: "record.detail.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "record.detail.back")) {
                    dismiss()
                }
            }

            if canEdit {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "record.detail.edit")) {
                        onEdit()
                    }
                }
            }
        }
    }

    // MARK: - Notes
    // This screen is intentionally read-only.
    // When a record is still within the editable window, an Edit action is exposed
    // via the navigation bar, delegating editing to `EditTodayView`.
}

#Preview {
    // NOTE: SwiftData-backed model previews can be added later.
    Text("RecordDetailView Preview")
}

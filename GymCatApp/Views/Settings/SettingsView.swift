// ⌘
//  GymCat/GymCatApp/Views/Settings/SettingsView.swift
//
//  Purpose: Settings placeholder screen (will later store user preferences like goals and theme).
//
//  Created by @jonathaxs on 2025-11-24.
// ⌘

import SwiftUI

struct SettingsView: View {
    var body: some View {
        // Root navigation container for the Settings tab
        NavigationStack {
            // Main list grouping all settings sections
            List {
                // Read-only section displaying the current default goals
                // (will become editable in future iterations)
                Section(String(localized: "settings.section.goals")) {
                    goalRow(titleKey: "settings.goal.water", value: "\(GoalsProvider.water)")
                    goalRow(titleKey: "settings.goal.protein", value: "\(GoalsProvider.protein)")
                    goalRow(titleKey: "settings.goal.carbs", value: "\(GoalsProvider.carbs)")
                    goalRow(titleKey: "settings.goal.fats", value: "\(GoalsProvider.fats)")
                    goalRow(titleKey: "settings.goal.creatine", value: "\(GoalsProvider.creatine)")
                    goalRow(titleKey: "settings.goal.sleep", value: "\(GoalsProvider.sleep)")
                }

                // App metadata and informational section
                Section(String(localized: "settings.section.about")) {
                    LabeledContent(String(localized: "settings.about.version"), value: appVersion)
                    LabeledContent(String(localized: "settings.about.build"), value: appBuild)
                }
            }
            .navigationTitle(String(localized: "settings.header.title"))
        }
    }

    // Human-readable app version (e.g. 1.0.0)
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }

    // Internal build number from the app bundle
    private var appBuild: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
    }

    // Helper to render a single goal row using a localized title and value
    private func goalRow(titleKey: LocalizedStringKey, value: String) -> some View {
        LabeledContent(titleKey, value: value)
    }
}

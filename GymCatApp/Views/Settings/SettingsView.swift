// ⌘
//  GymCat/GymCatApp/Views/Settings/SettingsView.swift
//
//  Purpose: Settings placeholder screen (will later store user preferences like goals and theme).
//
//  Created by @jonathaxs on 2025-11-24.
// ⌘

import SwiftUI

struct SettingsView: View {
    // Persisted user preferences (Settings)
    @AppStorage("healthkit.syncSleepEnabled") private var syncSleepToAppleHealth: Bool = true

    var body: some View {
        // Root navigation container for the Settings tab
        NavigationStack {
            // Main list grouping all settings sections
            List {
                // User preferences section (toggles and behaviors)
                Section(String(localized: "settings.section.goals")) {
                    NavigationLink {
                        GoalsSettingsView()
                    } label: {
                        Label(String(localized: "settings.goals.edit"), systemImage: "target")
                    }
                }

                // User preferences section (toggles and behaviors)
                Section(String(localized: "settings.section.preferences")) {
                    Toggle(String(localized: "settings.preference.syncSleep"), isOn: $syncSleepToAppleHealth)
                }

                // App metadata and informational section
                Section(String(localized: "settings.section.about")) {
                    LabeledContent(String(localized: "settings.about.version"), value: appVersion)
                    LabeledContent(String(localized: "settings.about.build"), value: appBuild)
                }
            }
            .navigationTitle(String(localized: "settings.header.title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Beta")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
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
}

// Displays the user's current daily goals in read-only mode.
// This screen centralizes all goal-related information and will later
// evolve into an editable goals configuration screen.
private struct GoalsSettingsView: View {
    var body: some View {
        List {
            // Current configured daily goals (read-only for now)
            Section(String(localized: "settings.section.goals")) {
                LabeledContent("settings.goal.water", value: "\(GoalsProvider.water)")
                LabeledContent("settings.goal.protein", value: "\(GoalsProvider.protein)")
                LabeledContent("settings.goal.carbs", value: "\(GoalsProvider.carbs)")
                LabeledContent("settings.goal.fats", value: "\(GoalsProvider.fats)")
                LabeledContent("settings.goal.creatine", value: "\(GoalsProvider.creatine)")
                LabeledContent("settings.goal.sleep", value: "\(GoalsProvider.sleep)")
            }

            // Placeholder section for future goal editing capabilities
            Section {
                ContentUnavailableView(
                    String(localized: "settings.goals.placeholder.title"),
                    systemImage: "target",
                    description: Text(String(localized: "settings.goals.placeholder.description"))
                )
            }
        }
        .navigationTitle(String(localized: "settings.goals.title"))
    }
}

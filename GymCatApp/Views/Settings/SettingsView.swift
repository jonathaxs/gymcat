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
        ContentUnavailableView(
            String(localized: "settings.empty.title"),
            systemImage: "gearshape.fill",
            description: Text(String(localized: "settings.empty.description"))
        )
    }
}

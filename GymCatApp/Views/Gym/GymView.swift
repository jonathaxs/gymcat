// ⌘
//  GymCat/GymCatApp/Views/Gym/GymView.swift
//
//  Purpose: Gym/workouts placeholder screen for future training features.
//
//  Created by @jonathaxs on 2025-12-02.
// ⌘

import SwiftUI

struct GymView: View {
    var body: some View {
        ContentUnavailableView(
            String(localized: "gym.empty.title"),
            systemImage: "dumbbell.fill",
            description: Text(String(localized: "gym.empty.description"))
        )
    }
}

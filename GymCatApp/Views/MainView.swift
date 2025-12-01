// ⌘
//
//  GymCat/GymCatApp/Views/MainView.swift
//
//  Created by @jonathaxs on 2025-11-15.
//
// ⌘

import SwiftUI
import SwiftData

// MARK: - Main Screen
// Organizes the main app tabs: Today and History.
struct MainView: View {
    var body: some View {
        
        // MARK: - View Body
        // Displays the tab-based navigation structure using TabView.
        TabView {
            
            // Main tab showing the daily tracker screen.
            TodayView()
                .tabItem {
                    Label(String(localized: "main.tab.today"), systemImage: "house.fill")
                }
            
            // Tab that displays the saved day history.
            AchievementsView()
                .tabItem {
                    Label(String(localized: "achievements.tab.title"), systemImage: "calendar")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

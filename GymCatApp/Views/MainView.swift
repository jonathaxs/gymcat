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
            
            TodayView()
                .tabItem {
                    Label(String(localized: "main.tab.cat"), systemImage: "trophy.fill")
                }
            
            AchievementsView()
                .tabItem {
                    Label(String(localized: "main.tab.achievements"), systemImage: "cat.fill")
                }
            
            /* Future Idea
            GymView()
                .tabItem {
                    Label(String(localized: "main.tab.gym"), systemImage: "dumbbell.fill")
                }
             */
            
            SettingsView()
                .tabItem {
                    Label(String(localized: "main.tab.achievements"), systemImage: "settings.fill")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

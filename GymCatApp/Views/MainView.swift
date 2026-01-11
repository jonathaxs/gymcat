// ⌘
//  GymCat/GymCatApp/Views/MainView.swift
//
//  Purpose: Hosts the main TabView and routes users to the primary app screens.
//
//  Created by @jonathaxs on 2025-11-15.
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
                    Label(String(localized: "main.tab.cat"), systemImage: "cat.fill")
                }
            
            AchievementsView()
                .tabItem {
                    Label(String(localized: "main.tab.achievements"), systemImage: "dumbbell.fill")
                }
            
            /* Future Idea
            GymView()
                .tabItem {
                    Label(String(localized: "main.tab.gym"), systemImage: "muscle.fill")
                }
             */
            
            SettingsView()
                .tabItem {
                    Label(String(localized: "main.tab.settings"), systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

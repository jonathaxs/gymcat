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
            
            CatView()
                .tabItem {
                    Label(String(localized: "main.tab.cat"), systemImage: "cat.fill")
                }
            
            GymView()
                .tabItem {
                    Label(String(localized: "main.tab.gym"), systemImage: "dumbbell.fill")
                }

            AchievementsView()
                .tabItem {
                    Label(String(localized: "main.tab.achievements"), systemImage: "trophy.fill")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

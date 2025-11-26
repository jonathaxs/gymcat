//
//  MainView.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-11-15.
/*  Criado por @jonathaxs em 2025-11-15. */
//

import SwiftUI
import SwiftData

// MARK: - Main Screen
// Organizes the main app tabs: Today and History.

/* MARK: - Tela Principal */
/* Organiza as abas principais do aplicativo: Hoje e Histórico. */
struct MainView: View {
    var body: some View {
        // MARK: - View Body
        // Displays the tab-based navigation structure using TabView.

        /* MARK: - Corpo da View */
        /* Exibe a estrutura de navegação baseada em abas usando TabView. */
        TabView {
            // Main tab showing the daily tracker screen.

            /* Aba principal que exibe o acompanhamento diário. */
            TodayView()
                .tabItem {
                    Label(String(localized: "main.tab.today"), systemImage: "house.fill")
                }

            // Tab that displays the saved day history.

            /* Aba que exibe o histórico de registros salvos. */
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

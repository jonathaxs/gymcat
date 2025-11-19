//
//  MainView.swift
//  GymCat
//
//  Criado por @jonathaxs em 2025-11-15.
/*  Created by @jonathaxs on 2025-11-15. */
//

import SwiftUI
import SwiftData

// MARK: - Tela Principal
// Organiza as abas principais do aplicativo: Hoje e Histórico.

/* MARK: - Main Screen */
/* Organizes the main app tabs: Today and History. */
struct MainView: View {
    var body: some View {
        // MARK: - Corpo da View
        // Exibe a estrutura de navegação baseada em abas usando TabView.
        
        /* MARK: - View Body */
        /* Displays the tab-based navigation structure using TabView. */
        TabView {
            // Aba principal que exibe o acompanhamento diário.
            
            /* Main tab showing the daily tracker screen. */
            TodayView()
                .tabItem {
                    Label("Hoje", systemImage: "house.fill")
                }

            // Aba que exibe o histórico de registros salvos.
            
            /* Tab that displays the saved day history. */
            HistoryView()
                .tabItem {
                    Label("Histórico", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

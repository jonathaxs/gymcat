//
//  MainView.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-11-15.
//

import SwiftUI
import SwiftData

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Hoje", systemImage: "house.fill")
                }

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

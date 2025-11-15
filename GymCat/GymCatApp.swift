//
//  GymCatApp.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-08-16.
//

import SwiftUI
import SwiftData

@main
struct GymCatApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DailyRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

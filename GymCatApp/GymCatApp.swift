// ⌘
//
//  GymCat/GymCatApp/GymCatApp.swift
//
//  Created by @jonathaxs on 2025-08-16.
//
// ⌘

// MARK: - Main Application
// Entry point of the GymCat app. Sets up SwiftData and loads MainView.
import SwiftUI
import SwiftData

@main
struct GymCatApp: App {
    
    // Shared SwiftData container.
    // Defines the schema and storage configuration for the database.
    var sharedModelContainer: ModelContainer = {
        
        // SwiftData schema with persisted models.
        // Each listed type will be stored in the database.
        let schema = Schema([
            DailyRecord.self,
        ])
        
        // Model configuration defining how and where data will be stored.
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        // Creates the ModelContainer using the given schema and configuration.
        // If it fails, the app terminates with an error message.
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // MARK: - Scene Body
    // Defines the app's main scene and injects the SwiftData container.
    var body: some Scene {
        
        // Main window group that displays the MainView.
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

// ⌘
//  GymCat/GymCatApp/GymCatApp.swift
//
//  Purpose: Entry point of the app; configures SwiftData and loads MainView.
//
//  Created by @jonathaxs on 2025-08-16.
// ⌘

// MARK: - Main Application
// Entry point of the GymCat app. Sets up SwiftData and loads MainView.
import SwiftUI
import SwiftData
import HealthKit

@main
struct GymCatApp: App {
    
    // Shared HealthKit store used to request permissions and write health data.
    private let healthStore = HKHealthStore()
    
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
                .task {
                    requestSleepAuthorizationIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    // Requests permission to write Sleep Analysis data.
    // If Health data is unavailable or the type is missing, it safely does nothing.
    private func requestSleepAuthorizationIfNeeded() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let typesToShare: Set<HKSampleType> = [sleepType]
        let typesToRead: Set<HKObjectType> = [sleepType]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, _ in
            // Intentionally ignored here. The app will simply skip Health writes if not authorized.
        }
    }
}

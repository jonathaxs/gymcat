// ⌘
//  GymCat/GymCatApp/Helpers/HealthKitManager.swift
//
//  Purpose: Centralizes Apple Health (HealthKit) authorization and writing Sleep Analysis entries.
//
//  Created by @jonathaxs on 2026-01-08.
// ⌘

import Foundation
import HealthKit

/// Centralizes Apple Health (HealthKit) authorization and writes for the app.
///
/// Current scope:
/// - Requests permission for Sleep Analysis.
/// - Writes Sleep Analysis samples only when the user provided a valid sleep value.
///
/// Design:
/// - GymCat intentionally does **not** overwrite existing sleep data in Apple Health.
///   This avoids interfering with Apple Watch or other sleep trackers.
/// - Sleep entries are only added when the user explicitly provides a value.
final class HealthKitManager {

    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()

    private init() {}

    // MARK: - Authorization

    /// Requests permission to read/write Sleep Analysis.
    /// Safe no-op if Health data is unavailable on this device.
    func requestSleepAuthorizationIfNeeded() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let typesToShare: Set<HKSampleType> = [sleepType]
        let typesToRead: Set<HKObjectType> = [sleepType]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, _ in
            // Intentionally ignored. The app will skip writes if not authorized.
        }
    }

    // MARK: - Writes

    /// Writes Sleep Analysis to Apple Health for a given day.
    ///
    /// - Important: This writes a simplified sleep interval starting at the beginning of `date`.
    ///   It is meant as an initial implementation until we store exact sleep start/end times.
    ///
    /// - Parameters:
    ///   - date: The day being saved (DailyRecord date).
    ///   - hours: User-provided sleep hours. If `hours <= 0`, this does nothing.
    func writeSleepIfNeeded(for date: Date, hours: Int) {
        guard hours > 0 else { return }
        guard HKHealthStore.isHealthDataAvailable() else { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let status = healthStore.authorizationStatus(for: sleepType)
        guard status == .sharingAuthorized else { return }

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = start.addingTimeInterval(TimeInterval(hours) * 60 * 60)

        let sample = HKCategorySample(
            type: sleepType,
            value: HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
            start: start,
            end: end
        )

        healthStore.save(sample) { _, _ in
            // Intentionally ignored: if saving fails, the app should continue normally.
        }
    }
}

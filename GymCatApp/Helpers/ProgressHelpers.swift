// ⌘
//
//  GymCat/GymCatApp/Helpers/ProgressHelpers.swift
//
//  Created by @jonathaxs on 2025-12-19.
//
// ⌘

import Foundation

// MARK: - ProgressHelpers
// Shared helpers for progress calculations (0...1).
enum ProgressHelpers {

    /// Returns a normalized progress value clamped to 0...1.
    /// - Parameters:
    ///   - current: Current metric value (e.g. 1200 ml).
    ///   - goal: Goal value (e.g. 3000 ml). If goal <= 0, returns 0.
    static func clampedProgress(current: Int, goal: Int) -> Double {
        guard goal > 0 else { return 0.0 }
        let raw = Double(current) / Double(goal)
        return min(max(raw, 0.0), 1.0)
    }

    /// Returns a normalized progress value clamped to 0...1 (Double overload).
    /// - Parameters:
    ///   - current: Current metric value as Double.
    ///   - goal: Goal value as Double. If goal <= 0, returns 0.
    static func clampedProgress(current: Double, goal: Double) -> Double {
        guard goal > 0 else { return 0.0 }
        let raw = current / goal
        return min(max(raw, 0.0), 1.0)
    }
}

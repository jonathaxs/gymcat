// ⌘
//  GymCat/GymCatApp/Helpers/DefaultGoals.swift
//
//  Purpose: Centralizes the default daily goal values used across the app.
//
//  Created by @jonathaxs on 2025-12-19.
// ⌘

import Foundation

/// Centralizes the app's default daily goals.
/// These values represent the initial baseline used by the app.
/// In the future, they should come from user-defined settings.
enum DefaultGoals {
    // MARK: - Hydration
    static let water: Int = 3000

    // MARK: - Macros
    static let protein: Int = 150
    static let carbs: Int = 300
    static let fats: Int = 80

    // MARK: - Supplements
    static let creatine: Int = 6

    // MARK: - Recovery
    static let sleep: Int = 7
}

/// Provides a single access point for goal values used by the app.
/// Today it proxies `DefaultGoals`, but it allows future migration
/// to user-defined settings (e.g., AppStorage / Settings) without
/// touching call sites.
enum GoalsProvider {
    // MARK: - Hydration
    static var water: Int { DefaultGoals.water }

    // MARK: - Macros
    static var protein: Int { DefaultGoals.protein }
    static var carbs: Int { DefaultGoals.carbs }
    static var fats: Int { DefaultGoals.fats }

    // MARK: - Supplements
    static var creatine: Int { DefaultGoals.creatine }

    // MARK: - Recovery
    static var sleep: Int { DefaultGoals.sleep }
}

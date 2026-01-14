// ⌘
//  GymCat/GymCatApp/Models/DailyCat.swift
//
//  Purpose: Defines the daily cat tier logic (emoji, name, color, points) based on progress.
//
//  Created by @jonathaxs on 2025-11-22.
// ⌘

import SwiftUI

// MARK: - DailyCat (Enum for cat categories)
// Represents the daily cat categories based on progress.
// Centralizes emoji, name, color and points in a single type.
enum DailyCat {
    case sad
    case beginner
    case fitness
    case strong
}

// Extension adding calculation logic and derived properties.
// Defines how progress maps to a DailyCat and which emoji, name,
// color and points belong to each case.
extension DailyCat {
    /// Maps a normalized progress value (0...1) to a `DailyCat` tier.
    ///
    /// Thresholds:
    /// - `< 0.5`  → `.sad`
    /// - `< 0.7`  → `.beginner`
    /// - `< 0.9`  → `.fitness`
    /// - `≥ 0.9`  → `.strong`
    ///
    /// - Parameter progress: A normalized progress value, ideally clamped to the 0...1 range.
    static func from(progress: Double) -> DailyCat {
        switch progress {
        case ..<0.5:
            return .sad
        case ..<0.7:
            return .beginner
        case ..<0.9:
            return .fitness
        default:
            return .strong
        }
    }

    var emoji: String {
        switch self {
        case .sad:
            return "😿"
        case .beginner:
            return "😺"
        case .fitness:
            return "🐈"
        case .strong:
            return "🦁"
        }
    }

    var name: String {
        switch self {
        case .sad:
            return String(localized: "daily.cat.sad")
        case .beginner:
            return String(localized: "daily.cat.beginner")
        case .fitness:
            return String(localized: "daily.cat.fitness")
        case .strong:
            return String(localized: "daily.cat.strong")
        }
    }

    var color: Color {
        switch self {
        case .sad:
            return Color.red.opacity(0.30)
        case .beginner:
            return Color.yellow.opacity(0.30)
        case .fitness:
            return Color.blue.opacity(0.30)
        case .strong:
            return Color.green.opacity(0.30)
        }
    }

    var points: Int {
        switch self {
        case .sad:
            return 0
        case .beginner:
            return 45
        case .fitness:
            return 65
        case .strong:
            return 95
        }
    }
}

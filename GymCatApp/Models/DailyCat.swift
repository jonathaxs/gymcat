//
//  GymCat/GymCatApp/Models/DailyCat.swift
//
//  Created by @jonathaxs on 2025-11-22.
/*  Criado por @jonathaxs em 2025-11-22. */
// ⌘

import SwiftUI

// MARK: - DailyCat (Enum for cat categories)
// Represents the daily cat categories based on progress.
// Centralizes emoji, name, color and points in a single type.

/* MARK: - DailyCat (Enum de categorias de gato) */
/* Representa as categorias de gato do dia com base no progresso. */
/* Centraliza emoji, nome, cor e pontos em um único tipo. */
enum DailyCat {
    case sad
    case beginner
    case fitness
    case strong
}

// Extension adding calculation logic and derived properties.
// Defines how progress maps to a DailyCat and which emoji, name,
// color and points belong to each case.

/* Extensão com lógica de cálculo e propriedades derivadas. */
/* Aqui definimos como o progresso vira um DailyCat e quais */
/* são os atributos (emoji, nome, cor e pontos) de cada caso. */
extension DailyCat {
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
            return String(localized: "cat.sad")
        case .beginner:
            return String(localized: "cat.beginner")
        case .fitness:
            return String(localized: "cat.fitness")
        case .strong:
            return String(localized: "cat.strong")
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
            return 15
        case .beginner:
            return 55
        case .fitness:
            return 75
        case .strong:
            return 105
        }
    }
}

//
//  GymCat/GymCatApp/Models/DailyRecord.swift
//
//  Created by @jonathaxs on 2025-08-16.
/*  Criado por @jonathaxs em 2025-08-16. */
// ⌘

import Foundation
import SwiftData

// MARK: - SwiftData Model
// DailyRecord represents a single completed day in the GymCat app.
// Each property is persisted automatically by SwiftData.
// This model is created when the user taps "Finalizar Dia".

/* MARK: - Modelo SwiftData */
/* DailyRecord representa um único dia concluído no aplicativo GymCat. */
/* Cada propriedade é salva automaticamente pelo SwiftData. */
/* Este modelo é criado quando o usuário toca em "Finalizar Dia". */
@Model
final class DailyRecord {
    // Stored properties for each metric and metadata for the daily record.
    // These values correspond to the user's progress on a given day.

    /* Propriedades armazenadas para cada métrica e informações adicionais do registro diário. */
    /* Esses valores correspondem ao progresso do usuário em um determinado dia. */
    var date: Date
    var water: Int
    var protein: Int
    var carb: Int
    var fat: Int
    var sleep: Int
    var percent: Int
    var catTitle: String
    var catEmoji: String
    var points: Int

    // MARK: - Initializer
    // The initializer assigns all incoming values to the model's stored properties.
    // `self.` is used here to distinguish the class properties from the parameters.
    // In the future we will rename parameters to improve readability.

    /* MARK: - Inicializador */
    /* O inicializador atribui valores recebidos às propriedades do modelo. */
    /* `self.` é utilizado para diferenciar propriedades internas dos parâmetros recebidos. */
    /* No futuro, os nomes dos parâmetros serão renomeados para melhorar a clareza. */

    init(
        // The `date` parameter has a default value of `Date()`,
        // meaning new records will automatically store the current day unless another date is provided.

        /* O parâmetro `date` possui valor padrão `Date()`, */
        /* garantindo que novos registros utilizem a data atual, */
        /* a menos que outra seja informada. */
        date: Date = Date(),
        waterAmount: Int,
        proteinAmount: Int,
        carbAmount: Int,
        fatAmount: Int,
        sleepHours: Int,
        percentValue: Int,
        catTitle: String,
        catEmoji: String,
        pointsEarned: Int
    ) {
        self.date = date
        self.water = waterAmount
        self.protein = proteinAmount
        self.carb = carbAmount
        self.fat = fatAmount
        self.sleep = sleepHours
        self.percent = percentValue
        self.catTitle = catTitle
        self.catEmoji = catEmoji
        self.points = pointsEarned
    }
}

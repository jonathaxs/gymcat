// ⌘
//  GymCat/GymCatApp/Models/DailyRecord.swift
//
//  Purpose: SwiftData model that persists a completed day with metrics, cat result and points.
//
//  Created by @jonathaxs on 2025-08-16.
// ⌘

import Foundation
import SwiftData

// MARK: - SwiftData Model
// DailyRecord represents a single completed day in the GymCat app.
// Each property is persisted automatically by SwiftData.
// This model is created when the user taps "Finalizar Dia".
@Model
final class DailyRecord {
    
    // Stored properties for each metric and metadata for the daily record.
    // These values correspond to the user's progress on a given day.
    var date: Date
    var water: Int
    var protein: Int
    var carb: Int
    var fat: Int
    var creatine: Int = 0
    var sleep: Int
    var percent: Int
    var catTitle: String
    var catEmoji: String
    var points: Int
    
    // MARK: - Initializer
    // The initializer assigns all incoming values to the model's stored properties.
    // `self.` is used here to distinguish the class properties from the parameters.
    // In the future we will rename parameters to improve readability.
    init(
        
        // The `date` parameter has a default value of `Date()`,
        // meaning new records will automatically store the current day unless another date is provided.
        
        date: Date = Date(),
        waterAmount: Int,
        proteinAmount: Int,
        carbAmount: Int,
        fatAmount: Int,
        creatineAmount: Int,
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
        self.creatine = creatineAmount
        self.sleep = sleepHours
        self.percent = percentValue
        self.catTitle = catTitle
        self.catEmoji = catEmoji
        self.points = pointsEarned
    }
}

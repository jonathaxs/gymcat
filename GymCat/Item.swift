//
//  Item.swift
//  GymCat
//
//  Created by @jonathaxs on 2025-08-16.
//

import Foundation
import SwiftData

@Model
final class DailyRecord {
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

    init(
        date: Date = Date(),
        water: Int,
        protein: Int,
        carb: Int,
        fat: Int,
        sleep: Int,
        percent: Int,
        catTitle: String,
        catEmoji: String,
        points: Int
    ) {
        self.date = date
        self.water = water
        self.protein = protein
        self.carb = carb
        self.fat = fat
        self.sleep = sleep
        self.percent = percent
        self.catTitle = catTitle
        self.catEmoji = catEmoji
        self.points = points
    }
}

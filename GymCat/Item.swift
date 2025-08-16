//
//  Item.swift
//  GymCat
//
//  Created by Jonathas Motta on 16/08/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

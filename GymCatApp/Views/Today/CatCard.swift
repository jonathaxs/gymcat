// ⌘
//
//  GymCat/GymCatApp/Views/Cat/CatCard.swift
//
//  Created by @jonathaxs on 2025-11-26.
//
// ⌘

import SwiftUI

struct CatCard: View {
    let dailyCat: DailyCat
    let dailyPercentage: Int
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text(String(localized: "cat.card.title"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 12) {
                    Text(dailyCat.emoji)
                        .font(.largeTitle)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dailyCat.name)
                            .font(.title3.bold())
                        
                        Text("\(String(localized: "cat.card.progress")) \(dailyPercentage)%")
                            .font(.subheadline)
                        
                        Text("\(String(localized: "cat.card.points")) \(dailyCat.points)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(dailyCat.color)
        .cornerRadius(20)
    }
}

#Preview {
    CatCard(
        dailyCat: .fitness,
        dailyPercentage: 85
    )
}

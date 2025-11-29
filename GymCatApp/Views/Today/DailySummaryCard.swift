//
//  GymCat/GymCatApp/Views/Today/DailySummaryCard.swift
//
//  Created by @jonathaxs on 2025-11-26.
/*  Criado por @jonathaxs em 2025-11-26. */
// ⌘

import SwiftUI

//

/* */
/* */

struct DailySummaryCard: View {
    let dailyCat: DailyCat
    let dailyPercentage: Int
    let finishDayAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text(String(localized: "today.card.title"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 12) {
                    Text(dailyCat.emoji)
                        .font(.largeTitle)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dailyCat.name)
                            .font(.title3.bold())
                        
                        Text("\(String(localized: "today.card.progress")) \(dailyPercentage)%")
                            .font(.subheadline)
                        
                        Text("\(String(localized: "today.card.points")) \(dailyCat.points)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Spacer()
            
            FinishDayButton(action: finishDayAction)
        }
        .padding()
        .background(dailyCat.color)
        .cornerRadius(20)
    }
}

#Preview {
    DailySummaryCard(
        dailyCat: .fitness,
        dailyPercentage: 85,
        finishDayAction: {}
    )
}

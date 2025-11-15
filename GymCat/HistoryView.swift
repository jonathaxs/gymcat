//
//  HistoryView.swift
//  GymCat
//  History Screen?
//
//  Created by @jonathaxs on 2025-11-14.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \DailyRecord.date, order: .reverse) private var records: [DailyRecord]

    var body: some View {
        NavigationStack {
            List(records) { record in
                HStack(spacing: 16) {
                    Text(record.catEmoji)
                        .font(.largeTitle)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(record.catTitle)
                            .font(.headline)

                        Text(record.date, style: .date)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }

                    Spacer()

                    Text("\(record.points) pts")
                        .font(.subheadline.bold())
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Histórico")
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

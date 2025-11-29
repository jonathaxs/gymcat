//
//  GymCat/GymCatApp/Views/Achievements/AchievementsView.swift
//
//  Created by @jonathaxs on 2025-11-14.
/*  Criado por @jonathaxs em 2025-11-14. */
// ⌘

import SwiftUI
import SwiftData

// MARK: - Achievements Screen
// Displays all saved DailyRecord entries using SwiftData, sorted newest to oldest.

/* MARK: - Tela de Conquistas */
/* Exibe todos os registros diários salvos no SwiftData, ordenados do mais recente para o mais antigo. */

struct AchievementsView: View {
    // SwiftData query that retrieves all daily records.
    // Sorting by date in reverse order shows the most recent day first.

    /* Consulta SwiftData que recupera todos os registros diários. */
    /* O sort por data em ordem reversa garante que o dia mais recente apareça no topo. */
    @Query(sort: \DailyRecord.date, order: .reverse) private var records: [DailyRecord]
    @Environment(\.modelContext) private var modelContext

    // MARK: - Actions
    // Deletes the selected record from the database.

    /* MARK: - Ações */
    /* Remove o registro selecionado do banco de dados. */
    private func deleteRecord(offsets: IndexSet) {
        for index in offsets {
            let record = records[index]
            modelContext.delete(record)
        }
    }

    var body: some View {
        // MARK: - View Body
        // Visual structure for the achievements screen using NavigationStack.
        // Each record is displayed in a list row with emoji, title, date, and points.

        /* MARK: - Corpo da View */
        /* Estrutura visual da tela de conquistas utilizando NavigationStack. */
        /* Cada registro é exibido em uma linha da lista com emoji, título, data e pontos. */
        NavigationStack {
            Group {
                if records.isEmpty {
                    // Empty state view.
                    // Shown when there are no records to display.

                    /* Estado vazio. */
                    /* Exibido quando não há registros para mostrar. */
                    ContentUnavailableView(
                        String(localized: "achievements.empty.title"),
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text(String(localized: "achievements.empty.description"))
                    )
                } else {
                    List {
                        ForEach(records) { record in
                            // Individual history row.
                            // Shows the cat emoji, title, date, and points for that day.

                            /* Linha individual do histórico. */
                            /* Mostra o emoji do gato, o título, a data e os pontos do dia. */
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

                                Text("\(record.points) \(String(localized: "achievements.points.total"))")
                                    .font(.subheadline.bold())
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete(perform: deleteRecord)
                    }
                }
            }
            // Navigation title for the achievements screen.

            /* Título da navegação para a tela de conquistas. */
            .navigationTitle(String(localized: "achievements.header.title"))
        }
    }
}

#Preview {
    AchievementsView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

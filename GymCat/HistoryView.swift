//
//  HistoryView.swift
//  GymCat
//  History Screen?
//
//  Criado por @jonathaxs em 2025-11-14.
/*  Created by @jonathaxs on 2025-11-14. */
//

import SwiftUI
import SwiftData

// MARK: - Tela de Histórico
// Exibe todos os registros diários salvos no SwiftData, ordenados do mais recente para o mais antigo.

/* MARK: - History Screen */
/* Displays all saved DailyRecord entries using SwiftData, sorted newest to oldest. */

struct HistoryView: View {
    // Consulta SwiftData que recupera todos os registros diários.
    // O sort por data em ordem reversa garante que o dia mais recente apareça no topo.
    
    /* SwiftData query that retrieves all daily records.
       Sorting by date in reverse order shows the most recent day first.
    */
    @Query(sort: \DailyRecord.date, order: .reverse) private var records: [DailyRecord]

    var body: some View {
        // MARK: - Corpo da View
        // Estrutura visual da tela de histórico utilizando NavigationStack.
        // Cada registro é exibido em uma linha da lista com emoji, título, data e pontos.
        
        /* MARK: - View Body */
        /* Visual structure for the history screen using NavigationStack. */
        /* Each record is displayed in a list row with emoji, title, date, and points. */
        NavigationStack {
            List(records) { record in
                // Linha individual do histórico.
                // Mostra o emoji do gato, o título, a data e os pontos do dia.
                
                /* Individual history row. */
                /* Shows the cat emoji, title, date, and points for that day. */
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
            // Título da navegação para a tela de histórico.
            
            /* Navigation title for the history screen. */
            .navigationTitle("Histórico")
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}

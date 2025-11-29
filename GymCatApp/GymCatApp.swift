//
//  GymCat/GymCatApp/GymCatApp.swift
//
//  Created by @jonathaxs on 2025-08-16.
/*  Criado por @jonathaxs em 2025-08-16. */
// ⌘

// MARK: - Main Application
// Entry point of the GymCat app. Sets up SwiftData and loads MainView.

/* MARK: - Aplicativo Principal */
/* Ponto de entrada do app GymCat. Configura o SwiftData e carrega a MainView. */
import SwiftUI
import SwiftData

@main
struct GymCatApp: App {
    // Shared SwiftData container.
    // Defines the schema and storage configuration for the database.

    /* Container compartilhado do SwiftData. */
    /* Define o schema e a configuração de armazenamento do banco de dados. */
    var sharedModelContainer: ModelContainer = {
        // SwiftData schema with persisted models.
        // Each listed type will be stored in the database.

        /* Schema do SwiftData com os modelos persistidos. */
        /* Cada tipo listado aqui será salvo no banco de dados. */
        let schema = Schema([
            DailyRecord.self,
        ])
        // Model configuration defining how and where data will be stored.

        /* Configuração do modelo definindo como e onde os dados serão armazenados. */
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        // Creates the ModelContainer using the given schema and configuration.
        // If it fails, the app terminates with an error message.

        /* Cria o ModelContainer usando o schema e a configuração definidos. */
        /* Se falhar, o app é encerrado com uma mensagem de erro. */
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Scene Body
    // Defines the app's main scene and injects the SwiftData container.

    /* MARK: - Corpo da Cena */
    /* Define a cena principal do app e injeta o container do SwiftData. */
    var body: some Scene {
        // Main window group that displays the MainView.

        /* Grupo de janelas principal que exibe a MainView. */
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

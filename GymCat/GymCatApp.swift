//
//  GymCatApp.swift
//  GymCat
//
//  Criado por @jonathaxs em 2025-08-16.
/*  Created by @jonathaxs on 2025-08-16. */
//

// MARK: - Aplicativo Principal
// Ponto de entrada do app GymCat. Configura o SwiftData e carrega a MainView.

/* MARK: - Main Application */
/* Entry point of the GymCat app. Sets up SwiftData and loads MainView. */
import SwiftUI
import SwiftData

@main
struct GymCatApp: App {
    // Container compartilhado do SwiftData.
    // Define o schema e a configuração de armazenamento do banco de dados.
    
    /* Shared SwiftData container. */
    /* Defines the schema and storage configuration for the database. */
    var sharedModelContainer: ModelContainer = {
        // Schema do SwiftData com os modelos persistidos.
        // Cada tipo listado aqui será salvo no banco de dados.
        
        /* SwiftData schema with persisted models. */
        /* Each listed type will be stored in the database. */
        let schema = Schema([
            DailyRecord.self,
        ])
        // Configuração do modelo definindo como e onde os dados serão armazenados.
        
        /* Model configuration defining how and where data will be stored. */
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        // Cria o ModelContainer usando o schema e a configuração definidos.
        // Se falhar, o app é encerrado com uma mensagem de erro.
        
        /* Creates the ModelContainer using the given schema and configuration. */
        /* If it fails, the app terminates with an error message. */
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Corpo da Cena
    // Define a cena principal do app e injeta o container do SwiftData.
    
    /* MARK: - Scene Body */
    /* Defines the app's main scene and injects the SwiftData container. */
    var body: some Scene {
        // Grupo de janelas principal que exibe a MainView.
        
        /* Main window group that displays the MainView. */
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

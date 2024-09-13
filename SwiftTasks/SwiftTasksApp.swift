//
//  SwiftTasksApp.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftTasksApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Tasks.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

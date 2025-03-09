//
//  SwiftTasksApp.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct SwiftTasksApp: App {
    @StateObject private var taskManagerWrapper: TaskManagerWrapper

    init() {
        do {
            let schema = Schema([ToDoTask.self])
            let container = try ModelContainer(for: schema)
            _taskManagerWrapper = StateObject(wrappedValue: TaskManagerWrapper(container: container))
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskManagerWrapper)
        }
    }
    
    func requestNotificationPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            print(granted ? "Notifications permission granted" : "Notifications permission denied")
        } catch {
            print("Error requesting notification permission: \(error.localizedDescription)")
        }
    }
}

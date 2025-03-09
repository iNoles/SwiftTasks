//
//  TaskManagerObservable.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 3/8/25.
//

import SwiftData
import Foundation

@MainActor
class TaskManagerWrapper: ObservableObject {
    let taskManager: TaskManager
    
    init(container: ModelContainer) {
        self.taskManager = TaskManager(modelContainer: container)
    }
}

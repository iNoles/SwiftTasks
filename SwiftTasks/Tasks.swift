//
//  Tasks.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//

import Foundation
import SwiftData

@Model
final class Tasks: ObservableObject {
    var title: String
    var notes: String
    var category: String
    var dueDate: Date?
    var isCompleted: Bool = false
    
    init(title: String, notes: String, category: String = "Uncategorized", dueDate: Date? = nil) {
        self.title = title
        self.notes = notes
        self.category = category
        self.dueDate = dueDate
    }
}

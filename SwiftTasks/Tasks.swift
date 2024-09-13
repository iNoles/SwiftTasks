//
//  Tasks.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//

import Foundation
import SwiftData

@Model
final class Tasks {
    var title: String
    var notes: String
    var isCompleted: Bool
    
    init(title: String, notes: String, isCompleted: Bool) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

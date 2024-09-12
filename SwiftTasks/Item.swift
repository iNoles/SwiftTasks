//
//  Item.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

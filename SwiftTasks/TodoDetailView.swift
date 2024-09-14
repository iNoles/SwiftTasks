//
//  TodoDetailView.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//


import SwiftUI
import SwiftData

struct TodoDetailView: View {
    @ObservedObject var task: Tasks

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    Text(task.title)
                        .font(.headline)
                    Text(task.notes)
                        .font(.subheadline)
                        .lineLimit(nil) // Show full notes
                }
                
                Section(header: Text("Category")) {
                    Text(task.category)
                        .font(.body)
                }
                
                Section(header: Text("Due Date")) {
                    if let dueDate = task.dueDate {
                        Text("\(dueDate, style: .date) at \(dueDate, style: .time)")
                            .font(.body)
                    } else {
                        Text("No due date set")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Status")) {
                    Text(task.isCompleted ? "Completed" : "Not Completed")
                        .font(.body)
                        .foregroundColor(task.isCompleted ? .green : .red)
                }
            }
            .navigationTitle("Task Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        // Dismiss the view or navigate back
                    }
                }
            }
        }
    }
}

#Preview {
    TodoDetailView(task: Tasks(title: "Sample Task", notes: "Sample notes", category: "Work", dueDate: Date()))
        .modelContainer(for: Tasks.self, inMemory: true)
}

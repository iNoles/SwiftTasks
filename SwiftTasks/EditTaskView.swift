//
//  EditTaskView.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/14/24.
//

import SwiftUI

struct EditTaskView: View {
    @Binding var task: Tasks
    @Binding var isPresented: Bool

    @State private var title: String
    @State private var notes: String
    @State private var category: String
    @State private var dueDate: Date
    @State private var isCompleted: Bool
    
    let categories = ["Work", "Personal", "Fitness", "Errands", "Uncategorized"] // Example categories

    init(task: Binding<Tasks>, isPresented: Binding<Bool>) {
        _task = task
        _isPresented = isPresented
        _title = State(initialValue: task.wrappedValue.title)
        _notes = State(initialValue: task.wrappedValue.notes)
        _category = State(initialValue: task.wrappedValue.category)
        _dueDate = State(initialValue: task.wrappedValue.dueDate ?? Date())
        _isCompleted = State(initialValue: task.wrappedValue.isCompleted)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes)
                    
                    // Picker for category
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute]).datePickerStyle(.compact)
                    
                    Toggle(isOn: $isCompleted) {
                        Text("Completed")
                    }
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateTask()
                        isPresented = false
                    }
                }
            }
        }
    }

    private func updateTask() {
        task.title = title
        task.notes = notes
        task.category = category
        task.dueDate = dueDate
        task.isCompleted = isCompleted
    }
}

#Preview {
    // Example preview with mock data
    let mockTask = Tasks(title: "Sample Task", notes: "Some notes", category: "Personal", dueDate: Date())
    return EditTaskView(task: .constant(mockTask), isPresented: .constant(true))
}

//
//  AddTaskView.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//


import SwiftUI

struct AddTaskView: View {
    @Binding var isPresented: Bool
    
    @State private var taskTitle: String = ""
    @State private var taskNotes: String = ""
    @State private var selectedCategory: String = "Work"
    @State private var dueDate = Date()
    
    var onSave: (String, String, String, Date) -> Void
    let categories = ["Work", "Personal", "Health", "Shopping"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $taskTitle)
                    TextField("Notes", text: $taskNotes)
                }
                
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Set Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(taskTitle, taskNotes, selectedCategory, dueDate)
                        isPresented = false
                    }
                    .disabled(taskTitle.isEmpty && taskNotes.isEmpty)
                    // Disable save button if the title and notes are empty
                }
            }
        }
    }
}

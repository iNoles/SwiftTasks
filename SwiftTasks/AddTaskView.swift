//
//  AddTaskView.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//


import SwiftUI

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var notes: String = ""
    var onSave: (String, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Title", text: $title)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
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
                        onSave(title, notes)
                        isPresented = false
                    }
                    .disabled(title.isEmpty && notes.isEmpty)
                    // Disable save button if the title and notes are empty
                }
            }
        }
    }
}

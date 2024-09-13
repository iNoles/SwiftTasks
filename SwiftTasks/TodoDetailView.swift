//
//  TodoDetailView.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//


import SwiftUI
import SwiftData

struct TodoDetailView: View {
    @Bindable var tasks: Tasks // Make the Tasks editable

    var body: some View {
        Form {
            Section(header: Text("Task Information")) {
                TextField("Title", text: $tasks.title)
                    .font(.headline)

                Toggle(isOn: $tasks.isCompleted) {
                    Text("Completed")
                }
            }

            Section(header: Text("Notes")) {
                TextEditor(text: $tasks.notes)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .padding(.vertical)
            }
        }
        .navigationTitle("Task Details")
    }
}

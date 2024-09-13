//
//  ContentView.swift
//  SwiftTasks
//
//  Created by Jonathan Steele on 9/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Tasks]
    @State private var isAddingTask = false // State to control the sheet presentation

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: TodoDetailView(tasks: item)) {
                        VStack(alignment: .leading) {
                            Text(item.title).font(.headline)
                            Text(item.notes)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1) // Show only one line of notes
                        }
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isAddingTask = true }) { // Present the add task sheet
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a task")
        }.sheet(isPresented: $isAddingTask) {
            AddTaskView(isPresented: $isAddingTask) { title, notes in
                addTask(title: title, notes: notes)
            }
        }
    }

    private func addTask(title: String, notes: String) {
        withAnimation {
            let newItem = Tasks(title: title, notes: notes, isCompleted: false)
            modelContext.insert(newItem)
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Tasks.self, inMemory: true)
}

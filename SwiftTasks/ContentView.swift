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
    @State private var selectedCategory: String = "All"
    @State private var isAddingTask = false // State to control the sheet presentation
    @State private var isEditingTask = false
    @State private var selectedTask: Tasks?
    
    @Query private var items: [Tasks]
    
    private var filteredItems: [Tasks] {
            if selectedCategory == "All" {
                return items
            } else {
                return items.filter { $0.category == selectedCategory }
            }
        }

    var body: some View {
        NavigationSplitView {
            VStack {
                Picker("Select Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    Text("Work").tag("Work")
                    Text("Personal").tag("Personal")
                    Text("Health").tag("Health")
                    Text("Shopping").tag("Shopping")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: TodoDetailView(task: item)) {
                            VStack(alignment: .leading) {
                                Text(item.title).font(.headline)
                                Text(item.notes)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1) // Show only one line of notes
                                if let dueDate = item.dueDate {
                                    Text("Due: \(dueDate, style: .date) at \(dueDate, style: .time)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }.contextMenu {
                            Button(action: {
                                selectedTask = item
                                isEditingTask = true
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
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
            AddTaskView(isPresented: $isAddingTask) { title, notes, catalog, dueDate in
                addTask(title: title, notes: notes, category: catalog, dueDate: dueDate)
            }
        }.sheet(isPresented: $isEditingTask, onDismiss: {
            selectedTask = nil // Reset selected task after editing
        }) {
            if let taskToEdit = selectedTask {
                EditTaskView(task: .constant(taskToEdit), isPresented: $isEditingTask)
            }
        }
    }

    private func addTask(title: String, notes: String, category: String, dueDate: Date?) {
        withAnimation {
            let newTasks = Tasks(title: title, notes: notes, category: category, dueDate: dueDate)
            modelContext.insert(newTasks)
            scheduleNotification(for: newTasks)
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func scheduleNotification(for task: Tasks) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Your task \"\(task.title)\" is due soon."
        content.sound = .default
            
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dueDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Tasks.self, inMemory: true)
}

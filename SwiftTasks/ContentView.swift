import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var taskManagerWrapper: TaskManagerWrapper
    
    @State private var selectedCategory: String = "All"
    @State private var isAddingTask = false
    @State private var isEditingTask = false
    @State private var selectedTask: ToDoTask?
    @State private var tasks: [ToDoTask] = []
        
    var filteredItems: [ToDoTask] {
        tasks.filter { selectedCategory == "All" || $0.category == selectedCategory }
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
                                    .lineLimit(1)
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
            .task {
                await loadTasks()
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView(isPresented: $isAddingTask) { title, notes, category, dueDate in
                    Task {
                        await addTask(title: title, notes: notes, category: category, dueDate: dueDate)
                    }
                }
            }
            .sheet(isPresented: $isEditingTask, onDismiss: {
                selectedTask = nil  // Reset selected task after editing
            }) {
                if let taskToEdit = selectedTask {
                    EditTaskView(task: .constant(taskToEdit), isPresented: $isEditingTask)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isAddingTask = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a task")
        }
    }
    
    @MainActor
    private func loadTasks() async {
        do {
            tasks = try await taskManagerWrapper.taskManager.fetchTasks()
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    @MainActor
    private func addTask(title: String, notes: String, category: String, dueDate: Date?) async {
        do {
            try await taskManagerWrapper.taskManager.addTask(title: title, notes: notes, category: category, dueDate: dueDate)
            await loadTasks()  // Reload tasks after adding a new one
        } catch {
            print("Error adding task: \(error)")
        }
    }
    
    @MainActor
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            Task {
                do {
                    try await taskManagerWrapper.taskManager.deleteTask(tasks[index])
                    await loadTasks()  // Reload tasks after deleting a task
                } catch {
                    print("Error deleting task: \(error)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoTask.self, inMemory: true)
}

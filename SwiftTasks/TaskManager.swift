import UserNotifications
import SwiftData

actor TaskManager {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // Fetch all tasks inside the actor
    func fetchTasks() throws -> [ToDoTask] {
        let modelContext = ModelContext(modelContainer) // Create a new context
        let descriptor = FetchDescriptor<ToDoTask>()
        return try modelContext.fetch(descriptor) // This must be done within the actor context
    }

    // Create a new task and schedule notification if there's a due date
    func addTask(title: String, notes: String, category: String, dueDate: Date? = nil) async throws {
        let modelContext = ModelContext(modelContainer) // Create a new context
        let newTask = ToDoTask(title: title, notes: notes, category: category, dueDate: dueDate)
         modelContext.insert(newTask)
        do {
            try modelContext.save()

            if let dueDate = dueDate {
                 scheduleNotification(for: newTask, at: dueDate)
            }
        } catch {
            print("Error adding task: \(error.localizedDescription)")
            throw error
        }
    }

    // Update a task and reschedule notification if there's a new due date
    func updateTask(_ task: ToDoTask, title: String, notes: String, category: String, dueDate: Date?, isCompleted: Bool) async throws {
        let modelContext = ModelContext(modelContainer) // Create a new context
        task.title = title
        task.notes = notes
        task.category = category
        task.dueDate = dueDate
        task.isCompleted = isCompleted
        do {
            try modelContext.save()

            if let dueDate = dueDate {
                scheduleNotification(for: task, at: dueDate)
            }
        } catch {
            print("Error updating task: \(error.localizedDescription)")
            throw error
        }
    }

    // Delete a task and cancel its notification
    func deleteTask(_ task: ToDoTask) async throws {
        let modelContext = ModelContext(modelContainer) // Create a new context
        if let dueDate = task.dueDate {
            cancelNotification(for: task, at: dueDate)
        }
        modelContext.delete(task)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
            throw error
        }
    }

    // Schedule a notification for a task
    private func scheduleNotification(for task: ToDoTask, at dueDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.notes
        content.sound = .default

        // Trigger the notification at the task's due date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(task.id)", content: content, trigger: trigger)

        // Schedule the notification
        UNUserNotificationCenter.current().add(request)
        print("Notification scheduled for task: \(task.title) at \(dueDate)")
    }

    // Cancel a notification for a task
    private func cancelNotification(for task: ToDoTask, at dueDate: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(task.id)"])
        print("Notification canceled for task: \(task.title)")
    }
}

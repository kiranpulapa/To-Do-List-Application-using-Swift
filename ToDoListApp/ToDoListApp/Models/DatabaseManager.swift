//
//  DatabaseManager.swift
//  ToDoListApp
//
//  Created by Pulapa Sai Kiran on 09/01/24.
//

import Foundation
import SQLite

class DatabaseManager {

    static let shared = DatabaseManager()

    private var db: Connection?

    private let tasksTable = Table("tasks")
    private let id = Expression<Int>("id")
    private let title = Expression<String>("title")
    private let description = Expression<String>("description")
    private let dueDate = Expression<Date>("dueDate")
    private let priority = Expression<String>("priority")
    private let category = Expression<String>("category")
    private let status = Expression<String>("status")

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!

            db = try Connection("\(path)/tasks.sqlite3")

            try db!.run(tasksTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(title)
                table.column(description)
                table.column(dueDate)
                table.column(priority)
                table.column(category)
                table.column(status)
            })
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    func saveTask(task: Task) {
        do {
            let insert = tasksTable.insert(
                title <- task.title,
                description <- task.description,
                dueDate <- task.dueDate,
                priority <- task.priority.rawValue,
                category <- task.category,
                status <- task.status.rawValue
            )
            try db!.run(insert)
        } catch {
            print("Error saving task: \(error)")
        }
    }
    
    func deleteTask(task: Task) {
            do {
                let targetTask = tasksTable.filter(id == task.id)
                try db?.run(targetTask.delete())
            } catch {
                print("Error deleting task: \(error)")
            }
        }
    
    func loadTasks() -> [Task] {
        var tasks: [Task] = []
        do {
            for taskRow in try db!.prepare(tasksTable) {
                let task = Task(
                    id: taskRow[id],
                    title: taskRow[title],
                    description: taskRow[description],
                    dueDate: taskRow[dueDate],
                    priority: Priority(rawValue: taskRow[priority]) ?? .low,
                    category: taskRow[category],
                    status: Status(rawValue: taskRow[status]) ?? .new
                )
                tasks.append(task)
            }
        } catch {
            print("Error loading tasks: \(error)")
        }
        return tasks
    }
}

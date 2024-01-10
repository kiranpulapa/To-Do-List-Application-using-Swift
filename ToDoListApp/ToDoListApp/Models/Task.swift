//
//  Task.swift
//  ToDoListApp
//
//  Created by Pulapa Sai Kiran on 09/01/24.
//

import Foundation

struct Task {
    var id: Int
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var category: String
    var status: Status
}

enum Priority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum Status: String {
    case new = "New"
    case inProgress = "In Progress"
    case completed = "Completed"
}

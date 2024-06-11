//
//  Job.swift
//  SaveEasy
//
//  Created by Jack Hodges on 22/5/2024.
//

import SwiftUI

struct Job: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var dueDate: Date?
    var price: Double
    var image: String
    var description: String
    var dueDateString: String {
        if let dueDate = dueDate {
            return timeRemaining(until: dueDate)
        } else {
            return "No due date"
        }
    }
}

// Sample Data
let sampleJobs = [
    Job(id: UUID().uuidString, name: "Dishwasher", dueDate: Date().addingTimeInterval(-3600), price: 5, image: "Dishwasher", description: "Don't forget to check if everything was properly cleaned!"),
    Job(id: UUID().uuidString, name: "Vacuuming", dueDate: Date().addingTimeInterval(7200), price: 10, image: "Vacuum", description: "If you have time please vacuum the skirting boards! I'll add an extra $5 to your account 😎"),
    Job(id: UUID().uuidString, name: "Laundry", dueDate: nil, price: 15, image: "Laundry", description: ""),
    Job(id: UUID().uuidString, name: "Gardening", dueDate: Date().addingTimeInterval(14400), price: 20, image: "Gardening", description: "Use the blue gloves")
]

func timeRemaining(until dueDate: Date) -> String {
    let now = Date()
    let interval = dueDate.timeIntervalSince(now)

    if interval <= 0 {
        return "Overdue"
    }

    let seconds = Int(interval)
    let minutes = seconds / 60
    let hours = minutes / 60
    let days = hours / 24

    if days > 0 {
        return "Due in \(days) day\(days > 1 ? "s" : "")"
    } else if hours > 0 {
        return "Due in \(hours) hour\(hours > 1 ? "s" : "")"
    } else if minutes > 0 {
        return "Due in \(minutes) minute\(minutes > 1 ? "s" : "")"
    } else {
        return "Due in \(seconds) second\(seconds > 1 ? "s" : "")"
    }
}

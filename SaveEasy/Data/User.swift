//
//  User.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var profileImage: String
    var savedAmount: Double
    var saveGoal: Double
    var goalName: String
    var colourSchemeName: String
    var goalImage: String?
    var jobs: [Job]
    var parent: Bool
    var linkedAccounts: String

    var colourScheme: AppColour {
        return AppColour.getColourScheme(by: colourSchemeName) ?? AppColour(name: "Default", primaryColour: .black, secondaryColour: .gray, backgroundColour: .white)
    }
    
    var percentage: Double {
        return saveGoal > 0 ? savedAmount / saveGoal * 100 : 0
    }
}

// Sample Data
let sampleUsers = [
    User(id: UUID().uuidString, email: "jack@example.com", firstName: "Jack", lastName: "Hodges", profileImage: "blank", savedAmount: 369, saveGoal: 799, goalName: "PS5", colourSchemeName: "Mint", goalImage: "PS5", jobs: sampleJobs, parent: true, linkedAccounts: "hannah@example.com;"),
    User(id: UUID().uuidString, email: "hannah@example.com", firstName: "Hannah", lastName: "Hodges", profileImage: "blank", savedAmount: 0, saveGoal: 100, goalName: "PS5", colourSchemeName: "Purple", goalImage: "PS5", jobs: sampleJobs, parent: false, linkedAccounts: "jack@example.com;"),
    User(id: UUID().uuidString, email: "leo@example.com", firstName: "Leo", lastName: "Hodges", profileImage: "blank", savedAmount: 38.5, saveGoal: 40, goalName: "PS5", colourSchemeName: "Orange", goalImage: "PS5", jobs: sampleJobs, parent: false, linkedAccounts: "")
]

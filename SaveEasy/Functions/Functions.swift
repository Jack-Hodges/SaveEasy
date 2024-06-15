//
//  Functions.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import Foundation

func priceString(price: Double) -> String {
    if price.truncatingRemainder(dividingBy: 1) == 0 {
        return "$\(Int(price))"
    } else {
        return String(format: "$%.2f", price)
    }
}

func roundedPercentage(percent: Double) -> String {
    return String(format: "%.0f%", percent)
}

func changeText(savePercent: Double) -> String {
    var piggyText = "Way to go!"
    switch savePercent {
    case 0:
        // Code for when percentage is 0
        piggyText = "Every great journey starts with a single step. Let's begin!"
    case 1..<20:
        // Code for when percentage is below 20
        piggyText = "You're on your way! Keep up the momentum."
    case 20..<40:
        // Code for when percentage is below 40
        piggyText = "Great progress! You're making strides towards your goal."
    case 40..<50:
        // Code for when percentage is below 50
        piggyText = "Almost halfway there! Keep pushing forward."
    case 50..<60:
        // Code for when percentage is below 60
        piggyText = "Over halfway done! You're doing fantastic."
    case 60..<70:
        // Code for when percentage is below 70
        piggyText = "Amazing work! The finish line is getting closer."
    case 70..<80:
        // Code for when percentage is below 80
        piggyText = "You're in the home stretch! Keep going strong."
    case 80...100:
        // Code for when percentage is 80 or above
        piggyText = "Incredible job! You're almost at your goal."
    default:
        // Code for any other case (if needed)
        piggyText = "Keep going! Every bit of progress counts."
    }
    return piggyText
}

// takes in a string of jobs, and returns an array of jobs
func parseJobs(from input: String) -> [Job] {
    
    let array = input.components(separatedBy: ";")
    
    var jobs: [Job] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm E d MMM y"
    
    for jobString in array {
        let components = jobString.components(separatedBy: ",")
        if components.count == 6 {
            let price = Double(components[3].trimmingCharacters(in: .whitespacesAndNewlines))
            let dueDate = (dateFormatter.date(from: components[2]) ?? nil)
            let job = Job(
                id: components[0].trimmingCharacters(in: .whitespacesAndNewlines),
                name: components[1].trimmingCharacters(in: .whitespacesAndNewlines),
                dueDate: dueDate,
                price: price ?? 0,
                image: components[4].trimmingCharacters(in: .whitespacesAndNewlines),
                description: components[5].trimmingCharacters(in: .whitespacesAndNewlines)
            )
            jobs.append(job)
        }
    }
    return jobs
}

func parseString(from input: [Job]) -> String {
    
    var outputString = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm E d MMM y"
    
    for (index, currJob) in input.enumerated() {
        let dueDateString = currJob.dueDate != nil ? dateFormatter.string(from: currJob.dueDate!) : ""
        outputString += "\(index + 1), \(currJob.name), \(dueDateString), \(currJob.price), \(currJob.image), \(currJob.description); "
    }
    
    return outputString
}

func createChildJobsDictionary(for user: User) -> [Job: [String]] {
    var jobsDictionary = [Job: [String]]()

    for child in user.linkedAccounts {
        for job in child.jobs {
            if jobsDictionary[job] != nil {
                jobsDictionary[job]?.append(child.firstName)
            } else {
                jobsDictionary[job] = [child.firstName]
            }
        }
    }
    
    return jobsDictionary
}

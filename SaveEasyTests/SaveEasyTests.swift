//
//  SaveEasyTests.swift
//  SaveEasyTests
//
//  Created by Jack Hodges on 10/6/2024.
//

import XCTest
@testable import SaveEasy

final class SaveEasyTests: XCTestCase {
    
    func testParseString_withValidJobs() {
        // Arrange
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let job1 = Job(id: "1", name: "Dishwasher", dueDate: dateFormatter.date(from: "2024/06/09 15:30"), price: 5, image: "Dishwasher", description: "Description for job one")
        let job2 = Job(id: "2", name: "Vacuuming", dueDate: dateFormatter.date(from: "2024/06/10 10:00"), price: 10, image: "Vacuum", description: "Description for job two")
        let job3 = Job(id: "3", name: "Job", dueDate: nil, price: 15, image: "Job", description: "Description for job three")
        let jobs = [job1, job2, job3]
        
        let expectedOutput = "1, Dishwasher, 15:30 Sun 9 Jun 2024, 5.0, Dishwasher, Description for job one; 2, Vacuuming, 10:00 Mon 10 Jun 2024, 10.0, Vacuum, Description for job two; 3, Job, , 15.0, Job, Description for job three; "
        
        // Act
        let result = parseString(from: jobs)
        
        // Assert
        XCTAssertEqual(result, expectedOutput)
    }
        
    func testParseString_withEmptyArray() {
        // Arrange
        let jobs: [Job] = []
        let expectedOutput = ""
        
        // Act
        let result = parseString(from: jobs)
        
        // Assert
        XCTAssertEqual(result, expectedOutput)
    }
    
    func testParseString_withJobHavingNilDueDate() {
        // Arrange
        let job = Job(id: "1", name: "Job", dueDate: nil, price: 15, image: "Job", description: "Description for job")
        let jobs = [job]
        
        let expectedOutput = "1, Job, , 15.0, Job, Description for job; "
        
        // Act
        let result = parseString(from: jobs)
        
        // Assert
        XCTAssertEqual(result, expectedOutput)
    }
    
    func testParseJob_withValidString() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let job1 = Job(id: "1", name: "Dishwasher", dueDate: dateFormatter.date(from: "2024/06/09 15:30"), price: 5, image: "Dishwasher", description: "Description for job one")
        let job2 = Job(id: "2", name: "Vacuuming", dueDate: dateFormatter.date(from: "2024/06/10 10:00"), price: 10, image: "Vacuum", description: "Description for job two")
        let job3 = Job(id: "3", name: "Job", dueDate: nil, price: 15, image: "Job", description: "Description for job three")
        let jobs = [job1, job2, job3]
        
        let input = "1, Dishwasher, 15:30 Sun 9 Jun 2024, 5.0, Dishwasher, Description for job one; 2, Vacuuming, 10:00 Mon 10 Jun 2024, 10.0, Vacuum, Description for job two; 3, Job, , 15.0, Job, Description for job three; "
        
        let output = parseJobs(from: input)
        
        XCTAssertEqual(jobs, output)
    }
    
    func testParseJob_withInvalidString() {
        
    }
    
    func testRemoveJob() {
        // Arrange
        let job1 = Job(id: "1", name: "Dishwasher", dueDate: Date(), price: 50, image: "Dishwasher", description: "Description for job one")
        let job2 = Job(id: "2", name: "Vacuuming", dueDate: Date(), price: 100, image: "Vacuum", description: "Description for job two")
        
        let user = User(id: "testUserID", email: "test@example.com", firstName: "Test", lastName: "User", profileImage: "blank", savedAmount: 100.0, saveGoal: 200.0, goalName: "Test Goal", colourSchemeName: "Mint", goalImage: nil, jobs: [job1, job2])
        
        let authViewModel = AuthViewModel()
        authViewModel.user = user
        
        // Act - Mark job1 as finished
        authViewModel.user?.savedAmount += job1.price
        authViewModel.removeJob(jobId: job1.id)
        authViewModel.updateUser()
        
        // Assert
        XCTAssertEqual(authViewModel.user?.savedAmount, 150.0) // 100.0 + 50.0
        XCTAssertEqual(authViewModel.user?.jobs.count, 1)
        XCTAssertEqual(authViewModel.user?.jobs.first?.id, job2.id)
    }

}

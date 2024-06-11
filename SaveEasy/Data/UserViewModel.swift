//
//  UserViewModel.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
//    func removeJob(jobId: UUID) {
//        user.jobs.removeAll { $0.id == jobId }
//    }
}

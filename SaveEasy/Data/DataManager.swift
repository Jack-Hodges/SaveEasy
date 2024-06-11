//
//  DataManager.swift
//  SaveEasy
//
//  Created by Jack Hodges on 5/6/2024.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var currentUser: User?

    init() {}

    func fetchUser(email: String, completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").whereField("email", isEqualTo: email)
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                let document = snapshot.documents.first!
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let profileImage = data["profileImage"] as? String ?? ""
                let savedAmount = data["savedAmount"] as? Double ?? 0.0
                let saveGoal = data["saveGoal"] as? Double ?? 0.0
                let goalName = data["goalName"] as? String ?? ""
                let colourSchemeName = data["colourSchemeName"] as? String ?? "Mint"
                let goalImage = data["goalImage"] as? String ?? ""
                let jobs = data["jobs"] as? String ?? ""
                let parent = data["parent"] as? Bool ?? false
                let linkedAccounts = data["linkedAccounts"] as? String ?? ""

                let user = User(id: id, email: email, firstName: firstName, lastName: lastName, profileImage: profileImage, savedAmount: savedAmount, saveGoal: saveGoal, goalName: goalName, colourSchemeName: colourSchemeName, jobs: parseJobs(from: jobs), parent: parent, linkedAccounts: "")
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func addUser(email: String, firstName: String, lastName: String, profileImage: String, saveGoal: Double, goalName: String, colourSchemeName: String, goalImage: String) {
        let id = UUID().uuidString
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(id)
        ref.setData(["id": id, "email": email, "firstName": firstName, "lastName": lastName, "profileImage": profileImage, "savedAmount": 0.0, "saveGoal": saveGoal, "goalName": goalName, "colourSchemeName": colourSchemeName, "goalImage": goalImage, "jobs": ""]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUser(_ user: User) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(user.id)
        ref.updateData([
            "email": user.email,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "profileImage": user.profileImage,
            "savedAmount": user.savedAmount,
            "saveGoal": user.saveGoal,
            "goalName": user.goalName,
            "colourSchemeName": user.colourSchemeName,
            "goalImage": user.goalImage,
            "jobs": parseString(from: user.jobs)
        ]) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
            } else {
                print("User \(user.firstName) updated")
            }
        }
    }
    
    func refreshUserData(email: String, completion: @escaping (User?) -> Void) {
        fetchUser(email: email) { [weak self] user in
            DispatchQueue.main.async {
                self?.currentUser = user
                completion(user)
                print("User \(user!.firstName) refreshed")
            }
        }
    }
}

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    let dataManager = DataManager()

    init() {
        if let currentUser = Auth.auth().currentUser {
            let email = currentUser.email!
            self.user = User(
                id: currentUser.uid,
                email: email,
                firstName: "", // Default name, should be fetched or set later
                lastName: "",
                profileImage: "default_profile_image",
                savedAmount: 0,
                saveGoal: 0,
                goalName: "",
                colourSchemeName: "Default",
                goalImage: nil,
                jobs: []
            )
            dataManager.fetchUser(email: email) { user in
                DispatchQueue.main.async {
                    self.user = user
                    if let user = user {
                        print("User \(user.firstName) Fetched")
                    }
                }
            }
        }
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            if let firebaseUser = result?.user {
                DispatchQueue.main.async {
                    self?.user = User(
                        id: firebaseUser.uid,
                        email: email,
                        firstName: "", // Default name, should be fetched or set later
                        lastName: "",
                        profileImage: "default_profile_image",
                        savedAmount: 0,
                        saveGoal: 0,
                        goalName: "",
                        colourSchemeName: "Default",
                        goalImage: nil,
                        jobs: []
                    )
                    self?.dataManager.fetchUser(email: email) { user in
                        DispatchQueue.main.async {
                            self?.user = user
                        }
                    }
                }
            }
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            if let firebaseUser = result?.user {
                DispatchQueue.main.async {
                    self?.user = User(
                        id: firebaseUser.uid,
                        email: email,
                        firstName: "", // Default name, should be fetched or set later
                        lastName: "",
                        profileImage: "default_profile_image",
                        savedAmount: 0,
                        saveGoal: 0,
                        goalName: "",
                        colourSchemeName: "Default",
                        goalImage: nil,
                        jobs: []
                    )
                    self?.dataManager.fetchUser(email: email) { user in
                        DispatchQueue.main.async {
                            self?.user = user
                        }
                    }
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
            }
        } catch let signOutError as NSError {
            DispatchQueue.main.async {
                self.errorMessage = signOutError.localizedDescription
            }
        }
    }
    
    func refreshData() {
        if let user = user {
            dataManager.refreshUserData(email: user.email) { [weak self] updatedUser in
                DispatchQueue.main.async {
                    self?.user = updatedUser
                }
            }
        }
    }
    
    func updateUser() {
        dataManager.updateUser(user!)
    }
    
    func removeJob(jobId: String) {
        user?.jobs.removeAll { $0.id == jobId }
    }
}

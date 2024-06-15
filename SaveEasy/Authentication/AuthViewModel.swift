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
                goalImage: "",
                jobs: [],
                parent: false,
                linkedAccountString: ""
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
                        goalImage: "",
                        jobs: [],
                        parent: false,
                        linkedAccountString: ""
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
                        goalImage: "",
                        jobs: [],
                        parent: false,
                        linkedAccountString: ""
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
    
    func updateUser(user: User) {
        dataManager.updateUser(user)
        for linkedAccount in user.linkedAccounts {
            dataManager.updateUser(linkedAccount)
        }
    }
    
    func removeJob(jobId: String) {
        user?.jobs.removeAll { $0.id == jobId }
    }
    
//    func removeJobFromAll(jobId: String) {
//        guard var currentUser = user else { return }
//        
//        // Remove job from the current user
//        currentUser.jobs.removeAll { $0.id == jobId }
//        print("\(currentUser.firstName) linked accounts = \(currentUser.linkedAccounts)")
//        
//        // Remove job from all linked accounts
//        for (index, var account) in currentUser.childLinkedAccounts.enumerated() {
//            print("\(account.firstName) jobs = \(account.jobs)")
//            print("removing")
//            account.jobs.removeAll { $0.id == jobId }
//            currentUser.childLinkedAccounts[index] = account
//            print("\(account.firstName) jobs = \(account.jobs)")
//        }
//        
//        // Update the original user with the modified copy
//        user = currentUser
//        updateUser(user: currentUser)
//    }
}

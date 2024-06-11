//
//  AuthManager.swift
//  SaveEasy
//
//  Created by Jack Hodges on 30/5/2024.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore

enum AuthState {
    case authenticated // Anonymously authenticated in Firebase.
    case signedIn // Authenticated in Firebase using one of service providers, and not anonymous.
    case signedOut // Not authenticated in Firebase.
}

@MainActor
class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var authState = AuthState.signedOut
}

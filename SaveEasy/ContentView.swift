//
//  ContentView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 17/5/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    @State private var login: Bool = true

    var body: some View {
        if authViewModel.user == nil {
            VStack {
                if (login) {
                    LoginView(authViewModel: authViewModel)
                } else {
                    RegisterView(authViewModel: authViewModel)
                }
                
                Button(action: {
                    login.toggle()
                }, label: {
                    Text(login ? "Sign Up" : "Login")
                        .bold()
                        .foregroundStyle(Color(red: 0.843, green: 0.475, blue: 0.718))
                })
            }
        } else {
            HomeView(authViewModel: authViewModel)
        }
    }
}

#Preview {
    ContentView()
}

//
//  LoginView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 30/5/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Welcome to SaveEasy")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color(red: 0.843, green: 0.475, blue: 0.718))
            
            Image("PiggyBank")
                .resizable()
                .scaledToFit()
            
            VStack {
                inputHeader(text: "Email")
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.bottom, 10)

            VStack {
                inputHeader(text: "Password")
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            Spacer()
            
            Button(action: {
                authViewModel.login(email: email, password: password)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 250, height: 50)
                        .foregroundColor(Color(red: 0.843, green: 0.475, blue: 0.718))
                    Text("Login")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                }
            })

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel())
    }
}

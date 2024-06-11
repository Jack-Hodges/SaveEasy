//
//  RegisterView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 30/5/2024.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var saveGoal: String = ""
    @State private var goalName: String = ""
    @State private var colourSchemeName: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            
            HStack {
                TextField("First Name", text: $firstName)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                TextField("Last Name", text: $lastName)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            TextField("Save Goal", text: $saveGoal)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            TextField("Goal Name", text: $goalName)
                .keyboardType(.default)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(AppColour.allColours, id: \.name) { colour in
                    ZStack {
                        Circle()
                            .fill(colour.primaryColour)
                            .frame(width: 40, height: 40)
                        Circle()
                            .fill(colour.backgroundColour)
                            .frame(width: 30, height: 30)
                        
                        if (colourSchemeName == colour.name) {
                            Circle()
                                .stroke(Color.white, lineWidth: 10)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .onTapGesture {
                        colourSchemeName = colour.name
                    }
                }
            }

            Button(action: {
                if (firstName != "" && lastName != "" && email != "" && saveGoal != "" && password == confirmPassword && colourSchemeName != "" && goalName != "") {
                    authViewModel.register(email: email, password: password)
                    authViewModel.dataManager.addUser(email: email, firstName: firstName, lastName: lastName, profileImage: "", saveGoal: Double(saveGoal) ?? 0, goalName: goalName, colourSchemeName: colourSchemeName, goalImage: "")
                    authViewModel.login(email: email, password: password)
                }
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authViewModel: AuthViewModel())
    }
}

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
    @Environment(\.colorScheme) var colorScheme
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            
            Text("Welcome to SaveEasy")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color(red: 0.843, green: 0.475, blue: 0.718))
            
            VStack {
                inputHeader(text: "Name")
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
            }
            
            VStack {
                inputHeader(text: "Email")
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            VStack {
                inputHeader(text: "Password")
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack {
                inputHeader(text: "Goal")
                TextField("Save Goal", text: $saveGoal)
                    .keyboardType(.decimalPad)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            TextField("Goal Name", text: $goalName)
                .keyboardType(.default)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            
            
            Spacer()
            
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
                                .stroke(colorScheme == .dark ? Color.black : Color.white, lineWidth: 10)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .onTapGesture {
                        colourSchemeName = colour.name
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                if (firstName != "" && lastName != "" && email != "" && saveGoal != "" && password == confirmPassword && colourSchemeName != "" && goalName != "") {
                    authViewModel.register(email: email, password: password)
                    authViewModel.dataManager.addUser(email: email, firstName: firstName, lastName: lastName, profileImage: "", saveGoal: Double(saveGoal) ?? 0, goalName: goalName, colourSchemeName: colourSchemeName, goalImage: "")
                    authViewModel.login(email: email, password: password)
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 250, height: 50)
                        .foregroundColor(Color(red: 0.843, green: 0.475, blue: 0.718))
                    Text("Sign Up")
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
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authViewModel: AuthViewModel())
    }
}

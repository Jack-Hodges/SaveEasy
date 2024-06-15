//
//  ProfileView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @State var editMode = true
    @Environment(\.presentationMode) var presentationMode
    @State private var resetSavingsAlert = false
    @State private var userFirstName: String = ""
    @State private var userLastName: String = ""
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        
        if (authViewModel.user != nil) {
            VStack {
                if (!editMode) {
                    Text("Hi \(authViewModel.user!.firstName)!")
                        .font(.largeTitle)
                        .padding()
                        .bold()
                        .foregroundColor(authViewModel.user!.colourScheme.primaryColour)
                } else {
                    List {
                        Section(header: Text("Profile Information")) {
                            TextField("Enter your first name", text: $userFirstName)
                                .background(Color.white)
                            TextField("Enter your last name", text: $userLastName)
                                .background(Color.white)
                        }
                        
                        Section(header: Text("Colour Scheme")) {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(AppColour.allColours, id: \.name) { colour in
                                    ZStack {
                                        Circle()
                                            .fill(colour.primaryColour)
                                            .frame(width: 40, height: 40)
                                        Circle()
                                            .fill(colour.backgroundColour)
                                            .frame(width: 30, height: 30)
                                        
                                        if (authViewModel.user!.colourSchemeName == colour.name) {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 10)
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                    .onTapGesture {
                                        authViewModel.user!.colourSchemeName = colour.name
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            resetSavingsAlert.toggle()
                        }, label: {
                            Text("Reset Savings")
                                .foregroundStyle(.red)
                        })
                        
                        Button(action: {
                            authViewModel.logout()
                        }, label: {
                            Text("Log Out")
                        })
                    }
                    
                }
            }
            .navigationTitle("Profile")
            .alert(isPresented: $resetSavingsAlert) {
                Alert(
                    title: Text("Reset Savings?"),
                    message: Text("Are you sure you want to reset your savings? This cannot be undone."),
                    primaryButton: .default(Text("Yes")) {
                        authViewModel.user!.savedAmount = 0.0
                        authViewModel.updateUser(user: authViewModel.user!)
                    },
                    secondaryButton: .cancel()
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.editMode.toggle()
                        if (editMode == false) {
                            authViewModel.user?.firstName = userFirstName
                            authViewModel.user?.lastName = userLastName
                            authViewModel.updateUser(user: authViewModel.user!)
                            authViewModel.refreshData()
                        }
                    }) {
                        Text(editMode ? "Save" : "Edit")
                    }
                }
            }
            .onAppear {
                userFirstName = authViewModel.user?.firstName ?? ""
                userLastName = authViewModel.user?.lastName ?? ""
            }
        } else {
            ContentView()
                .navigationBarBackButtonHidden()
        }
    }
}


#Preview {
    ProfileView(authViewModel: AuthViewModel())
}

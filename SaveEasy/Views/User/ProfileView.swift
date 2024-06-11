//
//  ProfileView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var userViewModel: UserViewModel
    @State var editMode = true
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        
        VStack {
            if (!editMode) {
                Text("Hi \(userViewModel.user.name)!")
                    .font(.largeTitle)
                    .padding()
                    .bold()
                    .foregroundColor(userViewModel.user.colourScheme.primaryColour)
            } else {
                List {
                    Section(header: Text("Profile Information")) {
                        TextField("Enter your name", text: $userViewModel.user.name)
                            .background(Color.white)
                    }
                    
                    Section(header: Text("Savings")) {
                        
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
                                    
                                    if (userViewModel.user.colourSchemeName == colour.name) {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 10)
                                            .frame(width: 10, height: 10)
                                    }
                                }
                                .onTapGesture {
                                    userViewModel.user.colourSchemeName = colour.name
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.editMode.toggle()
                }) {
                    Text(editMode ? "Done" : "Edit")
                }
            }
        }
    }
}


#Preview {
    ProfileView(userViewModel: UserViewModel(user: sampleUsers[0]))
}

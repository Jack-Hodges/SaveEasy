//  HomeView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 17/5/2024.
//

import SwiftUI
import FirebaseCore

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var cardOffset: CGFloat = 0
    @State private var isSheetPresented: Bool = false
    @State private var childLayout = "List"
    @State private var isDragging = false
    @State private var isAddJobSheetPresented = false
    
    var body: some View {
        NavigationStack {
            if let user = authViewModel.user {
                ZStack {
                    user.colourScheme.backgroundColour
                        .ignoresSafeArea()
                    
                    VStack {
                        if (isDragging) {
                            ProgressView()
                        }
                        if (user.parent == false) {
                            // display child view
                            childView(authViewModel: authViewModel)
                        } else {
                            // display parent view
                            parentView(authViewModel: authViewModel)
                        }
                    }
                }
                
            } else {
                // Handle the case where user is nil (e.g., show a loading indicator or an error message)
                ContentView()
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            ChangeGoalView(authViewModel: authViewModel)
        }
        .onAppear {
            authViewModel.refreshData()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func titleSection(authViewModel: AuthViewModel) -> some View {
        HStack {
            if let user = authViewModel.user {
                Button(action: {
                    authViewModel.refreshData()
                }, label: {
                    Text("Hi \(user.firstName)!")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(user.colourScheme.primaryColour)
                        .padding(.leading, 5)
                })
                
                Spacer()
                
                NavigationLink(destination: ProfileView(authViewModel: AuthViewModel())) {
                    ZStack {
                        Circle()
                            .frame(width: 60)
                            .foregroundStyle(user.colourScheme.primaryColour)
                        Image(systemName: "person")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(user.colourScheme.backgroundColour)
                    }
                }
            }
        }
    }
    
    func childView(authViewModel: AuthViewModel) -> some View {
        let user = authViewModel.user!
        return ZStack {
            VStack {
                titleSection(authViewModel: authViewModel)
                
                Image("PiggyBank")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .scaleEffect(x: -1, y: 1)
                    .padding(.top, -60)
                
                PiggyBankTextView(authViewModel: authViewModel)
                
                Text("\(priceString(price: user.savedAmount))/\(priceString(price: user.saveGoal))")
                    .foregroundStyle(user.colourScheme.primaryColour)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                ColouredProgressBar(authViewModel: authViewModel)
                    .frame(width: 300, height: 50)
                    .padding(.top, -18)
                    .padding(.bottom, 10)
                
                Button(action: {
                    isSheetPresented = true
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 250, height: 50)
                            .foregroundColor(user.colourScheme.primaryColour)
                        Text("Change Goal")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                    }
                })
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .gesture(
                DragGesture()
                    .onChanged({ _ in
                        isDragging = true
                    })
                    .onEnded({ _ in
                        isDragging = false
                        authViewModel.refreshData()
                    })
            )
                
            SwipeCard(authViewModel: authViewModel, cardOffset: $cardOffset)
                .offset(y: 515)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func parentView(authViewModel: AuthViewModel) -> some View {
        let user = authViewModel.user!
        return VStack {
            titleSection(authViewModel: authViewModel)
            
            // linked accounts section
            HStack {
                Text("Linked Accounts")
                    .foregroundStyle(user.colourScheme.secondaryColour)
                    .font(.system(size: 30, weight: .bold))
                Spacer()
                Picker(selection: $childLayout, label: Text("Picker")) {
                    Image(systemName: "list.dash").tag("List")
                    Image(systemName: "square.grid.2x2").tag("Grid")
                }
                .pickerStyle(.segmented)
                .frame(width: 100)
            }
            .padding(.leading, 5)
            
            if user.childLinkedAccounts.isEmpty {
                Text("No linked child accounts.")
            } else {
                (childLayout == "List") ? AnyView(ChildProgressLinear(user: user)) : AnyView(ChildProgressBlock(user: user))
            }
            // end linked accounts section
            
            // job section
            HStack {
                Text("Jobs")
                    .foregroundStyle(user.colourScheme.secondaryColour)
                    .font(.system(size: 30, weight: .bold))
                Spacer()
                Image(systemName: "plus")
                    .font(.system(size: 50))
                    .foregroundStyle(user.colourScheme.secondaryColour)
                    .onTapGesture {
                        isAddJobSheetPresented = true
                    }
            }
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .gesture(
            DragGesture()
                .onChanged({ _ in
                    isDragging = true
                })
                .onEnded({ _ in
                    isDragging = false
                    authViewModel.refreshData()
                })
        )
        .sheet(isPresented: $isAddJobSheetPresented) {
            AddJobView(authViewModel: authViewModel)
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}

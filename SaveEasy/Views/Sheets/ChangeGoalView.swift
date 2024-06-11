//
//  ChangeGoalView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 28/5/2024.
//

import SwiftUI
import PhotosUI

struct ChangeGoalView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalName: String = ""
    @State private var saveAmount: String = ""
    @State private var selectedImage: UIImage?
    @State private var isShowingPhotoPicker = false
    @State private var changeGoal = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            if changeGoal {
                changeGoal(authViewModel: authViewModel)
            } else {
                currentGoal(authViewModel: authViewModel)
            }
        }
    }
    
    
    func saveImageToDocuments(image: UIImage, imageName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0]
        let fileURL = documentDirectory.appendingPathComponent(imageName)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    // UI for sheet before the user decides to press change goal
    func currentGoal(authViewModel: AuthViewModel) -> some View {
        let user = authViewModel.user!
        
        return VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                        .foregroundStyle(user.colourScheme.primaryColour)
                        .bold()
                })
                
            }
            .padding()
            .padding(.trailing, -5)
            
            Spacer()
            
            Text("Your Goal")
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .foregroundStyle(user.colourScheme.primaryColour)
                .padding(.top, -70)
            
            if let uiImage = UIImage(named: user.goalImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .opacity(0.9)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .opacity(0.9)
            }
            
            Text("You're currently saving for \(user.goalName). You've saved \(priceString(price: user.savedAmount)) out of \(priceString(price: user.saveGoal)).")
                .foregroundStyle(user.colourScheme.secondaryColour)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("Do you want to change your goal?")
                .font(.title2)
                .foregroundStyle(user.colourScheme.primaryColour)
                .multilineTextAlignment(.center)
                .bold()
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 250, height: 50)
                    .foregroundColor(user.colourScheme.primaryColour)
                Button("Change Goal") {
                    changeGoal = true
                }
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
            }
        }
    }
    
    // UI for sheet after the user presses to change goal
    func changeGoal(authViewModel: AuthViewModel) -> some View {
        
        var user = authViewModel.user!
        let inputWidth: CGFloat = 320
        
        return VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                        .foregroundStyle(user.colourScheme.primaryColour)
                        .bold()
                })
                
            }
            .padding(.trailing, 5)
            
            Spacer()
            
            Text("New Goal")
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .foregroundStyle(user.colourScheme.primaryColour)
                .padding(.top, -50)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Goal Name")
                    .inputTitle(color: user.colourScheme.primaryColour)
                TextField("Goal Name", text: $goalName)
                    .frame(width: inputWidth)
                    .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text("Save Amount")
                    .inputTitle(color: user.colourScheme.primaryColour)
                TextField("Save Amount", text: $saveAmount)
                    .keyboardType(.decimalPad)
                    .frame(width: inputWidth)
                    .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text("Goal Image")
                    .inputTitle(color: user.colourScheme.primaryColour)
                Button(action: {
                    isShowingPhotoPicker = true
                }) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: inputWidth, height: 50)
                            .cornerRadius(15)
                            .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                    } else {
                        Rectangle()
                            .fill(Color("PrimaryBackgroundColor"))
                            .frame(width: inputWidth, height: 50)
                            .cornerRadius(15)
                            .overlay(Text("Select Image").foregroundColor(user.colourScheme.primaryColour))
                            .neumorphicStyle(cornerRadius: 15, color: Color(UIColor.systemBackground))
                    }
                }
                .sheet(isPresented: $isShowingPhotoPicker) {
                    PhotoPicker(selectedImage: $selectedImage)
                }
            }
            .padding(.bottom, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 250, height: 50)
                    .foregroundColor(user.colourScheme.primaryColour)
                Button("Change Goal") {
                    showAlert = true
                }
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Change Goal"),
                    message: Text("Are you sure you want to change your goal from \(user.goalName) to \(goalName)?"),
                    primaryButton: .default(Text("Confirm")) {
                        if goalName.isEmpty {
                            alertMessage = "Goal name cannot be empty."
                        } else if saveAmount.isEmpty || Double(saveAmount) == nil {
                            alertMessage = "Save amount must be a valid number."
                        } else if selectedImage == nil {
                            alertMessage = "Please select an image."
                        } else {
                            user.goalName = goalName
                            user.saveGoal = Double(saveAmount) ?? 0.0
                            if let selectedImage = selectedImage {
                                if let imagePath = saveImageToDocuments(image: selectedImage, imageName: "goalImage.png") {
                                    user.goalImage = imagePath
                                }
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        showAlert = true
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ChangeGoalView(authViewModel: AuthViewModel())
}

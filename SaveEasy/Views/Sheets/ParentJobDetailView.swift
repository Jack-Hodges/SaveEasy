//
//  ParentJobDetailView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 26/6/2024.
//

import SwiftUI

struct ParentJobDetailView: View {
    
    var job: Job
    var assignees: [String]
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button(action: {
                        // eventually add edit functionality and update children
                    }, label: {
                        Text("Edit")
                            .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                            .bold()
                    })
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Close")
                            .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                            .bold()
                    })
                    
                }
                .padding()
                
                Text(job.name)
                    .font(.system(size: 50))
                    .fontWeight(.heavy)
                    .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                    .offset(y: -20)
                
                Text("Assigned to: \(assignees.joined(separator: ", "))")
                    .offset(y: -30)
                
                Image(job.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.leading, -10)
                    .offset(y: -50)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(job.dueDateString)")
                            .padding(.leading, -5)
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                }
                .padding(.leading, -10)
                .offset(y: -75)
                
                Text(priceString(price: job.price))
                    .font(.system(size: 100, weight: .bold))
                    .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                    .offset(y: -50)
                
                Text(job.description)
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .offset(y: -40)
                
                Button(action: {
                    showingAlert = true
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 200, height: 50)
                            .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                        Text("Finished")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                })
                
                Spacer()
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Mark Job as Finished"),
                    message: Text("Are you sure you want to mark this job as finished?"),
                    primaryButton: .default(Text("Yes")) {
                        authViewModel.user!.savedAmount += job.price
                        authViewModel.removeJob(jobId: job.id)
                        authViewModel.updateUser(user: authViewModel.user!)
                        authViewModel.dataManager.finishJob(emails: authViewModel.user!.linkedAccountString, job: job)
                        authViewModel.refreshData()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
        }
        }
    }
}

#Preview {
    ParentJobDetailView(job: sampleJobs[0], assignees: ["Jack", "Hannah"], authViewModel: AuthViewModel())
}

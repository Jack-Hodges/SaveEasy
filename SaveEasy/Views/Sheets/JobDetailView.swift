//
//  JobDetailView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct JobDetailView: View {
    
    var job: Job
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
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
                
                Spacer()
                
                Text(job.name)
                    .font(.system(size: 50))
                    .fontWeight(.heavy)
                    .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                
                Image(job.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.leading, -10)
                
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
                
                Text(priceString(price: job.price))
                    .font(.system(size: 100, weight: .bold))
                    .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                Text(job.description)
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)
                
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
                        authViewModel.dataManager.updateUser(authViewModel.user!)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
        }
        }
    }
}

#Preview {
    JobDetailView(job: sampleJobs[0], authViewModel: AuthViewModel())
}

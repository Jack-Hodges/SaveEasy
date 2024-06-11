//
//  ColouredProgressBar.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct ColouredProgressBar: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(authViewModel.user!.colourScheme.primaryColour)
                    .frame(width: geometry.size.width + 10, height: geometry.size.height + 10)
                    .cornerRadius(100)
                
                Rectangle()
                    .foregroundColor(authViewModel.user!.colourScheme.backgroundColour)
                    .frame(width: min(CGFloat(authViewModel.user!.percentage / 100) * geometry.size.width, geometry.size.width),
                           height: geometry.size.height)
                    .cornerRadius(geometry.size.height / 2)
                    .padding(.leading, 5)
                    .animation(.easeInOut(duration: 0.5), value: authViewModel.user!.percentage / 100)
                
                HStack {
                    let roundedPercentage = roundedPercentage(percent: authViewModel.user!.percentage)
                    Text("\(roundedPercentage)%")
                        .font(.title)
                        .bold()
                        .foregroundStyle(authViewModel.user!.colourScheme.primaryColour)
                        .padding(.leading, 5)
                    Spacer()
                    if let goalImageName = authViewModel.user!.goalImage,
                       let uiImage = UIImage(named: goalImageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .opacity(0.9)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .opacity(0.9)
                    }
                }
                .padding(5)
            }
        }
    }
    
    func roundedPercentage(percent: Double) -> Int {
        return Int(round(percent))
    }
}

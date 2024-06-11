//
//  ChildProgress.swift
//  SaveEasy
//
//  Created by Jack Hodges on 11/6/2024.
//

import SwiftUI

struct ChildProgress: View {
    @State var user: User
    var body: some View {
        ZStack {
            Color(.white)
            HStack {
                VStack(alignment: .leading) {
                    Text(user.firstName)
                        .foregroundStyle(user.colourScheme.primaryColour)
                        .font(.system(size: 50, weight: .bold))
                    Text("\(priceString(price: user.savedAmount))/\(priceString(price: user.saveGoal))")
                        .foregroundStyle(user.colourScheme.secondaryColour)
                        .font(.system(size: 20, weight: .bold))
                }
                
                Spacer()
                
                ZStack {
                    CircularProgressView(progress: 0.7, lineWidth: 10, color: user.colourScheme.primaryColour, frameSize: 75)
                    Text("\(roundedPercentage(percent: user.percentage))%")
                        .foregroundStyle(user.colourScheme.primaryColour)
                        .bold()
                }
                
            }
            .padding()
        }
        .frame(width: 350, height: 100)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    ChildProgress(user: sampleUsers[0])
}

struct CircularProgressView: View {
    var progress: Double // Progress percentage between 0 and 1
    var lineWidth: CGFloat
    var color: Color
    var frameSize: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: lineWidth)
                .frame(width: frameSize, height: frameSize)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
                .frame(width: frameSize, height: frameSize)
        }
    }
}

//
//  ChildProgress.swift
//  SaveEasy
//
//  Created by Jack Hodges on 11/6/2024.
//

import SwiftUI

struct ChildProgressLinear: View {
    @State var user: User
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ForEach(user.linkedAccounts) { child in
            ZStack {
                Color(colorScheme == .dark ? Color.black : Color.white)
                HStack {
                    VStack(alignment: .leading) {
                        Text(child.firstName)
                            .foregroundStyle(child.colourScheme.primaryColour)
                            .font(.system(size: 50, weight: .bold))
                        Text("\(priceString(price: child.savedAmount))/\(priceString(price: child.saveGoal))")
                            .foregroundStyle(child.colourScheme.secondaryColour)
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        CircularProgressView(progress: child.percentage / 100, lineWidth: 10, color: child.colourScheme.primaryColour, frameSize: 75)
                        Text("\(roundedPercentage(percent: child.percentage))%")
                            .foregroundStyle(child.colourScheme.primaryColour)
                            .bold()
                    }
                    
                }
                .padding()
            }
            .frame(width: 375, height: 100)
            .cornerRadius(20)
        }
    }
}

#Preview {
    ChildProgressLinear(user: sampleUsers[0])
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

//
//  ChildProgressBlock.swift
//  SaveEasy
//
//  Created by Jack Hodges on 11/6/2024.
//

import SwiftUI

struct ChildProgressBlock: View {
    @State var user: User
    @Environment(\.colorScheme) var colorScheme
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(user.linkedAccounts) { child in
                ZStack {
                    Color(colorScheme == .dark ? Color.black : Color.white)
                    VStack(alignment: .leading) {
                        Text(child.firstName)
                            .foregroundStyle(child.colourScheme.primaryColour)
                            .font(.system(size: 35, weight: .bold))
                        
                        Text("\(priceString(price: child.savedAmount))/\(priceString(price: child.saveGoal))")
                            .foregroundStyle(child.colourScheme.secondaryColour)
                            .font(.system(size: 20, weight: .bold))
                        
                        Spacer()
                        
                        HStack {

                            HorizontalProgressView(progress: child.percentage / 100, lineWidth: 10, color: child.colourScheme.primaryColour)
                            Text("\(roundedPercentage(percent: child.percentage))%")
                                .foregroundStyle(child.colourScheme.primaryColour)
                                .bold()
                            
                        }
                    }
                    .padding()
                    
                }
                .frame(width: 175, height: 175)
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    ChildProgressBlock(user: sampleUsers[0])
}

struct HorizontalProgressView: View {
    var progress: Double // Progress percentage between 0 and 1
    var lineWidth: CGFloat
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(color.opacity(0.3))
                    .frame(width: geometry.size.width, height: lineWidth)
                    .cornerRadius(lineWidth / 2)
                
                Rectangle()
                    .fill(color)
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: lineWidth)
                    .cornerRadius(lineWidth / 2)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: lineWidth)
    }
}

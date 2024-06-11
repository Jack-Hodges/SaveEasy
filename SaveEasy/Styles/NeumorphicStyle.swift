//
//  NeumorphicStyle.swift
//  SaveEasy
//
//  Created by Jack Hodges on 27/5/2024.
//

import SwiftUI

struct NeumorphicStyle: ViewModifier {
    var cornerRadius: CGFloat = 10
    var color: Color = Color.white
    var shadowRadius: CGFloat = 10
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(color)
                        .shadow(color: Color.black.opacity(0.2), radius: shadowRadius, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: shadowRadius, x: -5, y: -5)
                }
            )
            .padding(10)
    }
}

extension View {
    func neumorphicStyle(cornerRadius: CGFloat = 10, color: Color = Color.white, shadowRadius: CGFloat = 10) -> some View {
        self.modifier(NeumorphicStyle(cornerRadius: cornerRadius, color: color, shadowRadius: shadowRadius))
    }
}

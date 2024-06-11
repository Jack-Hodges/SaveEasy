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
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(color)
                }
            )
            .padding(10)
    }
}

extension View {
    func neumorphicStyle(cornerRadius: CGFloat = 10, color: Color = Color.white) -> some View {
        self.modifier(NeumorphicStyle(cornerRadius: cornerRadius, color: color))
    }
}

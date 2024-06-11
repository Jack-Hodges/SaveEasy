//
//  InputTitle.swift
//  SaveEasy
//
//  Created by Jack Hodges on 27/5/2024.
//

import SwiftUI

struct InputTitle: ViewModifier {
    var color: Color = Color.white
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .bold()
            .foregroundStyle(color)
            .padding(.leading, 10)
            .padding(.bottom, -10)
    }
}

extension View {
    func inputTitle(color: Color = Color.white) -> some View {
        self.modifier(InputTitle(color: color))
    }
}

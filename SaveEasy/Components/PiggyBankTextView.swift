//
//  PiggyBankTextView.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct PiggyBankTextView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        Text(changeText(savePercent: authViewModel.user!.percentage))
            .foregroundStyle(authViewModel.user!.colourScheme.secondaryColour)
            .font(.title3)
            .bold()
            .multilineTextAlignment(.center)
            .padding(.top, -40)
    }
}

#Preview {
    PiggyBankTextView(authViewModel: AuthViewModel())
}

//
//  OnboardingProgressView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 07.06.2023.
//

import SwiftUI

struct OnboardingProgressView: View {
    var totalSteps: CGFloat
    var currentStep: CGFloat
    
    var body: some View {
        ZStack {
            Color.colorLightGrey
            
            HStack {
                Color.theme
                    .frame(width: (screenSize.width / totalSteps) * currentStep)
                
                Spacer(minLength: 0)
            }
        }
        .frame(height: 4)
    }
}

struct OnboardingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingProgressView(totalSteps: 9, currentStep: 8)
    }
}

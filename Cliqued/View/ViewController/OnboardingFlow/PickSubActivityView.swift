//
//  PickSubActivityView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.05.2023.
//

import SwiftUI

struct PickSubActivityView: View {
    @StateObject private var viewModel = OnboardingViewModel.shared
    
    var isFromEditProfile: Bool
    var categoryIds: String
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PickSubActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PickSubActivityView(isFromEditProfile: false, categoryIds: "")
    }
}

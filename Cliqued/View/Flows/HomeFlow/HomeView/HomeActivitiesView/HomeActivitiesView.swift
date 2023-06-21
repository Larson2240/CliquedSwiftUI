//
//  HomeActivitiesView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 11.06.2023.
//

import SwiftUI

struct HomeActivitiesView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var guideViewPresented = false
    
    var category: ActivityCategoryClass?
    var userID = ""
    
    var body: some View {
        ZStack {
            content
        }
        .background(background)
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        ActivitiesViewRepresentable(category: category)
            .ignoresSafeArea()
    }
}

struct HomeActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        HomeActivitiesView(category: nil)
    }
}

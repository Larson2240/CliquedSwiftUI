//
//  TabBarView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 07.06.2023.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var welcomeViewModel = WelcomeViewModel(fromOnboarding: false)
    @StateObject private var vieWModelMessage = MessageViewModel()
    
    @State var selectionValue = 0
    
    var body: some View {
        TabView(selection: $selectionValue) {
            HomeView()
                .tabItem {
                    VStack {
                        Text(Constants.label_tabHome)
                        
                        Image("ic_home_unselected")
                            .renderingMode(.template)
                    }
                }
            
            Text("2")
                .tabItem {
                    VStack {
                        Text(Constants.label_tabActivities)
                        
                        Image("ic_activity_unselected")
                            .renderingMode(.template)
                    }
                }
            
            Text("3")
                .tabItem {
                    VStack {
                        Text(Constants.label_tabChat)
                        
                        Image("ic_chat_unselected")
                            .renderingMode(.template)
                    }
                }
            
            Text("4")
                .tabItem {
                    VStack {
                        Text(Constants.label_tabProfile)
                        
                        Image("ic_profile_unselected")
                            .renderingMode(.template)
                    }
                }
        }
        .accentColor(.theme)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

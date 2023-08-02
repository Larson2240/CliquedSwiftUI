//
//  TabBarView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 02.08.2023.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedIndex = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        TabView(selection: $selectedIndex) {
            HomeView()
                .tabItem {
                    tabItem(imageName: "ic_home_unselected", title: Constants.label_tabHome)
                }
            
            ProfileView()
                .tabItem {
                    tabItem(imageName: "ic_profile_unselected", title: Constants.label_tabProfile)
                }
        }
    }
    
    private var presentables: some View {
        ZStack {
            
        }
    }
    
    private func tabItem(imageName: String, title: String) -> some View {
        VStack {
            Image(imageName)
                .renderingMode(.template)
            
            Text(title)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

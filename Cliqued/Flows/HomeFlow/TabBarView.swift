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
            tabBar
        }
        .onAppear { onAppearConfig() }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var tabBar: some View {
        TabView(selection: $selectedIndex) {
            HomeView()
                .tabItem {
                    tabItem(imageName: "ic_home_unselected", title: Constants.label_tabHome)
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    tabItem(imageName: "ic_profile_unselected", title: Constants.label_tabProfile)
                }
                .tag(1)
        }
        .accentColor(.theme)
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
    
    private func onAppearConfig() {
        setupTabbarUI()
    }
    
    private func setupTabbarUI() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.color_themeColor, NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(12)!], for: .selected)
        
        UITabBar.appearance().layer.shadowColor = UIColor.lightGray.cgColor
        UITabBar.appearance().layer.shadowOpacity = 0.5
        UITabBar.appearance().layer.shadowOffset = CGSize.zero
        UITabBar.appearance().layer.shadowRadius = 5
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        UITabBar.appearance().layer.borderWidth = 0
        UITabBar.appearance().clipsToBounds = false
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .darkGray
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

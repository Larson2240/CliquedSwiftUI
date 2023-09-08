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
            
            ActivitiesView().ignoresSafeArea()
                .tabItem {
                    tabItem(imageName: "ic_activity_unselected", title: Constants.label_tabActivities)
                }
                .tag(1)
            
            ChatView().ignoresSafeArea()
                .tabItem {
                    tabItem(imageName: "ic_chat_unselected", title: Constants.label_tabChat)
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    tabItem(imageName: "ic_profile_unselected", title: Constants.label_tabProfile)
                }
                .tag(3)
        }
        .introspectTabBarController(customize: { tabBarController in
            setupTabBarUI(tabBarController: tabBarController)
        })
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
    
    private func setupTabBarUI(tabBarController: UITabBarController) {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.color_themeColor, NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(12)!], for: .selected)
        
        tabBarController.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.5
        tabBarController.tabBar.layer.shadowOffset = CGSize.zero
        tabBarController.tabBar.layer.shadowRadius = 5
        tabBarController.tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBarController.tabBar.layer.borderWidth = 0
        tabBarController.tabBar.clipsToBounds = false
        tabBarController.tabBar.backgroundColor = UIColor.white
        
        UITabBar.appearance().tintColor = Constants.color_themeColor
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

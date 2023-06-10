//
//  TabBarVC.swift
//  Cliqued
//
//  Created by C211 on 10/01/23.
//

import SwiftUI

final class TabBarVC: UITabBarController {

    //MARK: IBOutlet
    
    //MARK: Variable
    let viewOverTabBar = UIView()
    var btnBecomeFamousHeight0 = NSLayoutConstraint()
    var is_comingCall = false
    var textLog = TextLog()
    
    //MARK: Enum for tabbar items
    enum enumTabbarItem: Int, CaseIterable {
        case home = 0
        case activity
        case chat
        case profile
    }
    
    //MARK: Array of normal tabbar image
    let tabBarItemImage = [UIImage(named: "ic_home_unselected"),
                           UIImage(named: "ic_activity_unselected"),
                           UIImage(named: "ic_chat_unselected"),
                           UIImage(named: "ic_profile_unselected")]
    
    //MARK: Array of normal selected tabbar image
    let tabBarSelectedItemImage = [UIImage(named: "ic_home_selected"),
                                   UIImage(named: "ic_activity_selected"),
                                   UIImage(named: "ic_chat_selected"),
                                   UIImage(named: "ic_profile_selected")]
    
    //MARK: Array of tabbar title
    let tabBarItemsTitle = [Constants.label_tabHome, Constants.label_tabActivities, Constants.label_tabChat, Constants.label_tabProfile]
    
    lazy var welcomeViewModel = WelcomeViewModel(fromOnboarding: false)
    lazy var vieWModelMessage = MessageViewModel()
    
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if APP_DELEGATE.socketIOHandler == nil {
            APP_DELEGATE.socketIOHandler = SocketIOHandler()
        }
        
        setupTabbarUI()
        welcomeViewModel.callGetUserDetailsAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(incomingCall(_:)), name: .incomingCall, object: nil)
    }
    
    @objc func incomingCall(_ notification: Notification) {
       
        print("incoming call 12345")
                 
        vieWModelMessage.setSenderId(value: "\(Constants.loggedInUser?.id ?? 0)")
        vieWModelMessage.setRoomName(value: "\(Calling.room_Name)")
        vieWModelMessage.setIsVideo(value: "\(Calling.is_audio_call == "1" ? "0" : "1")")
        vieWModelMessage.apiGetAccessToken()
    }
}
//MARK: Extension UDF
extension TabBarVC {
    
    func viewDidLoadMethod() {
        self.delegate = self
        
        viewControllers = [UIHostingController(rootView: HomeView()),
                           UINavigationController(rootViewController: ActivitiesVC.loadFromNib()),
                           UINavigationController(rootViewController: ChatVC.loadFromNib()),
                           UINavigationController(rootViewController: ProfileVC.loadFromNib())]
        
        setupTabBarItems()
        handleApiResponse()
    }
    
    //MARK: Setup tabbarUI
    func setupTabbarUI() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.color_themeColor, NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(12)!], for: .selected)
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = Constants.color_themeColor
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    //MARK: Setup tabbar images
    func setupTabBarItems() {
        for i in 0..<4 {
            let item = UITabBarItem()
            item.image = tabBarItemImage[i]
            item.selectedImage = tabBarSelectedItemImage[i]
            
            if UIDevice.current.hasNotch {
                item.title = tabBarItemsTitle[i]
            } else {
                item.title = tabBarItemsTitle[i]
            }
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
            item.imageInsets = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
            viewControllers?[i].tabBarItem = item
        }
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        vieWModelMessage.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            
            print("SRM LOG Calling is audio => \(Calling.is_audio_call)")
            
            NotificationCenter.default.removeObserver(self,name: .incomingCall, object: nil)
                          
               if let topVC = UIApplication.getTopViewController(), topVC is VideoCallVC {
                   
               } else {
                   let vc = VideoCallVC.loadFromNib()
                   vc.sender_id = "\(Constants.loggedInUser?.id ?? 0)"
                   vc.accessToken = self.vieWModelMessage.getAccessToken()
                   vc.roomName = Calling.room_Name
                   vc.hidesBottomBarWhenPushed = true
                   vc.is_incomingCall = true
                   vc.userName = "\(Calling.receiver_name )"
                   vc.is_audioCall = Calling.is_audio_call == "1" ? true : false
                   self.navigationController?.pushViewController(vc, animated: false)
               }
        }
    }
}
extension TabBarVC: UITabBarControllerDelegate {
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch enumTabbarItem(rawValue: tabBarController.selectedIndex)! {
        case .home:
            welcomeViewModel.callGetUserDetailsAPI()
        case .activity:
            welcomeViewModel.callGetUserDetailsAPI()
        case .chat:
            welcomeViewModel.callGetUserDetailsAPI()
        case .profile:
            break
        }
    }
}


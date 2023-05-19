//
//  StartExploringVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class StartExploringVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.font = CustomFont.THEME_FONT_Bold(30)
            labelTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_startExploringSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonStartExploring: UIButton!
    
    //MARK: Variable
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
        APP_DELEGATE.socketIOHandler = SocketIOHandler()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonStartExploring, buttonTitle: Constants.btn_startExploring)
    }

    //MARK: Button Start Exploring Click
    @IBAction func btnStartExploringTap(_ sender: Any) {
        let tabbarvc = TabBarVC.loadFromNib()
        tabbarvc.selectedIndex = 0
        APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabbarvc)
    }
}
//MARK: Extension UDF
extension StartExploringVC {
    
    func viewDidLoadMethod() {
        if let userName = Constants.loggedInUser?.name {
            labelTitle.text = "Hi \(userName)!"
        }
    }
}

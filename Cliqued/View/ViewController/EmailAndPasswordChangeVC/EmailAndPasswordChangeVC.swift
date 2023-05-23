//
//  EmailAndPasswordChangeVC.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class EmailAndPasswordChangeVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var button: UIButton!
    
    //MARK: Variable
    var isEmailChangeScreen: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI()
    }
    
    //MARK: Button Change Email And Password Click
    @IBAction func btnClick(_ sender: Any) {
        
    }
}
//MARK: Extension UDF
extension EmailAndPasswordChangeVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        if isEmailChangeScreen {
            viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_emailSettings
        } else {
            viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_passwordSettings
        }
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    func setupButtonUI() {
        if isEmailChangeScreen {
            setupButtonUI(buttonName: button, buttonTitle: Constants.btn_changeEmail)
        } else {
            setupButtonUI(buttonName: button, buttonTitle: Constants.btn_changePassword)
        }
    }
}

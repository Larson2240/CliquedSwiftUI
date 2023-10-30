//
//  ActivitiesVC.swift
//  Cliqued
//
//  Created by C211 on 11/01/23.
//

import UIKit
import SwiftUI

class ActivitiesVC: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Variable
    var dataSource : ActivitiesDataSource?
    lazy var viewModel = ActivitiesViewModel()
    private let preferenceTypeIds = PreferenceTypeIds()
    private let profileSetupType = ProfileSetupType()
    
    var favoriteActivity = [UserInterestedCategory]()
    var favoriteCategoryActivity = [UserInterestedCategory]()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension ActivitiesVC {
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = ActivitiesDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        handleApiResponse()
        viewModel.callAllActivityListAPI()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_activities
        viewNavigationBar.buttonBack.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
        viewNavigationBar.buttonRight.isHidden = false
        viewNavigationBar.buttonRight.addTarget(self, action: #selector(buttonGuideTap), for: .touchUpInside)
    }
    //MARK: Back Button Action
    @objc func buttonGuideTap() {
        let guidemanagervc = GuideManagerVC.loadFromNib()
        guidemanagervc.isFromActivitiesScreen = true
        guidemanagervc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(guidemanagervc, animated: false)
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                self.tableview.reloadData()
                self.dataSource!.hideHeaderLoader()
            }
        }
        
        viewModel.isLoaderShow.bind { [weak self] isLoader in
            guard let self = self else { return }
            
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
    
    //MARK: Function manage if user profile not complete
    func isProfileCompleted() -> Bool {
        return false
    }
    
    //MARK: Bind data on screen from the user object.
    func bindUserDetailsData() {
        
    }
}

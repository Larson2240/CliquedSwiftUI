//
//  ActivityDetailsVC.swift
//  Cliqued
//
//  Created by C211 on 24/03/23.
//

import UIKit

class ActivityDetailsVC: UIViewController {
    
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Variable
    var dataSource : ActivityDetailsDataSource?
    lazy var viewModel = ActivityDetailsViewModel()
    lazy var viewModel1 = InterestedActivityViewModel()
    var objActivityDetails : UserActivityClass!
    private let isPremium = IsPremium()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
//MARK: Extension UDF
extension ActivityDetailsVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = ActivityDetailsDataSource(tableView: tableview, viewModel: viewModel, viewModel1: viewModel1, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        viewModel.bindActivityDetailsData(activityDetails: objActivityDetails)
        viewModel.callInterestedActivityListAPI()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = self.objActivityDetails.title ?? ""
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = false
        viewNavigationBar.buttonSkip.isHidden = true
        viewNavigationBar.buttonRight.setImage(UIImage(named: "ic_edit_category"), for: .normal)
        viewNavigationBar.buttonRight.addTarget(self, action: #selector(buttonEditActivityTap), for: .touchUpInside)
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Button Action
    @objc func buttonEditActivityTap() {
//        if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
//            let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
//            subscriptionplanvc.isFromOtherScreen = true
//            self.present(subscriptionplanvc, animated: true)
//        } else {
            let addactivityvc = AddActivityVC.loadFromNib()

            addactivityvc.isEditActivity = true
            addactivityvc.objActivityDetails = objActivityDetails

            addactivityvc.callbackForUpdateActivityData = { [weak self] objActivityDetails in
                guard let self = self else { return }

                self.viewModel.bindActivityDetailsData(activityDetails: objActivityDetails)
                self.tableview.reloadData()
            }
            self.navigationController?.pushViewController(addactivityvc, animated: true)
//        }
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        viewModel1.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            if isSuccess {
                self?.tableview.reloadData()
            }
        }
        
        viewModel1.isLikdDislikeSuccess.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                if self.viewModel1.arrayOfFollowersList.count > 0 {
                    let followersData = self.viewModel1.arrayOfFollowersList[0]
                    
                    let arrayUsers = self.viewModel.getAllInterestedUserData()
                    var counterUser = 0
                    
//                    if followersData.userId == Constants.loggedInUser?.id {
//                        counterUser = followersData.counterUserId ?? 0
//                    } else {
//                        counterUser = followersData.userId ?? 0
//                    }
                    
                    let filterArray = arrayUsers.filter({$0.interestedUserId == counterUser})
                    
                    if filterArray.count > 0 {
                        var obj = filterArray[0]
                        obj.isInterested = followersData.isInterested
                        
                        if let index = arrayUsers.firstIndex(where: {$0.id == obj.id}) {
                            self.viewModel.removeInterestedActivityData(at: index)
                            self.viewModel.addInterestedActivityData(at: index, obj: obj)
                        }
                    }
                    
                    self.tableview.reloadData()                    
                }
            }
        }
        
        viewModel1.isViewLimitFinish.bind { [weak self] isSuccess in
//            if isSuccess {
//                if Constants.loggedInUser?.isPremiumUser == self?.isPremium.NotPremium {
//                    self?.showSubscriptionPlanScreen()
//                }
//            }
        }
        
        viewModel1.isLikeLimitFinish.bind { [weak self] isSuccess in
//            if isSuccess {
//                if Constants.loggedInUser?.isPremiumUser == self?.isPremium.NotPremium {
//                    self?.showSubscriptionPlanScreen()
//                }
//            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { [weak self] isLoader in
            if isLoader {
                self?.showLoader()
            } else {
                self?.dismissLoader()
            }
        }
        
        viewModel1.isLoaderShow.bind { [weak self] isLoader in
            if isLoader {
                self?.showLoader()
            } else {
                self?.dismissLoader()
            }
        }
    }
    //MARK: Show subscription screen for basic user
    func showSubscriptionPlanScreen() {
        let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
        subscriptionplanvc.isFromOtherScreen = true
        self.present(subscriptionplanvc, animated: true)
    }
    
}

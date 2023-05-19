//
//  OtherUserActivityDetailsVC.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class OtherUserActivityDetailsVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet var viewActivityAction: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    
    //MARK: Variable
    var dataSource : OtherUserActivityDetailsDataSource?
    lazy var viewModel = OtherUserActivityDetailsViewModel()
    var activity_id = ""
    var objActivityDetails: UserActivityClass!
    var callbackForIsLiked: ((_ isLiked: Bool) -> Void)?
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Button Like Click
    @IBAction func btnLikeClick(_ sender: Any) {
        viewModel.setActivityInterestStatus(value: "1")
        viewModel.callMarkActivityStatusAPI()
    }
    
    //MARK: Button Dislike Click
    @IBAction func btnDislikeClick(_ sender: Any) {
        viewModel.setActivityInterestStatus(value: "0")
        viewModel.callMarkActivityStatusAPI()
    }
}
//MARK: Extension UDF
extension OtherUserActivityDetailsVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = OtherUserActivityDetailsDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        self.viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
        self.viewModel.setActivityId(value: activity_id)
        self.viewModel.bindActivityDetailsData(activityDetails: objActivityDetails)
        handleApiResponse()
        if self.objActivityDetails?.interestedActivityStatus == nil {
            self.viewActivityAction.isHidden = false
        } else {
            self.viewActivityAction.isHidden = true
        }
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = objActivityDetails.title
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if isSuccess {
                self.viewNavigationBar.labelNavigationTitle.text = self.viewModel.objActivityDetails?.title
                if self.viewModel.objActivityDetails?.interestedActivityStatus == nil {
                    self.viewActivityAction.isHidden = false
                } else {
                    self.viewActivityAction.isHidden = true
                }
                self.tableview.reloadData()
            }
        }
        
        viewModel.isUserDataGet.bind { isSuccess in
            if isSuccess {
                
                if self.viewModel.arrayOfMainUserList.count > 0 {
                    let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
                    activityuserdetailsvc.objUserDetails = self.viewModel.arrayOfMainUserList[0]
                    activityuserdetailsvc.hidesBottomBarWhenPushed = true
                    activityuserdetailsvc.isFromOtherScreen = true
                    activityuserdetailsvc.is_fromChatActivity = true
                    self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
                }
            }
        }
        
        
        viewModel.isMarkStatusDataGet.bind { isSuccess in
            if isSuccess {
                if self.viewModel.getLikesStatus() == 1 {
                    self.callbackForIsLiked?(true)
                } else {
                    self.callbackForIsLiked?(false)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { isLoader in
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
}

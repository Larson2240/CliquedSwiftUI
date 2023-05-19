//
//  ActivitiesDataSource.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

enum enumActivitiesTableRow: Int,CaseIterable {
    case yourActivities = 0
    case othersActivities
}

class ActivitiesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

    private let viewController: ActivitiesVC
    private let tableView: UITableView
    private let viewModel: ActivitiesViewModel
       
    //MARK:- Init
    init(tableView: UITableView, viewModel: ActivitiesViewModel, viewController: ActivitiesVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    //MARK: - Class methods
    func setupTableView(){
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        registerTableCell()
    }
    
    func registerTableCell(){
        tableView.registerNib(nibNames: [YourActivitiesCell.identifier])
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setupPullToRefresh()
        }
    }
    
    //MARK: Pull To Refresh
    func setupPullToRefresh() {      
        viewController.pullToRefreshHeaderSetUpForTableview(tableview: tableView, strStatus: "") {
            self.viewModel.setIsRefresh(value: true)
            self.viewModel.setOffset(value: "0")
            self.viewModel.callAllActivityListAPI()
        }
    }
    
    //MARK: Hide header loader
    func hideHeaderLoader() {
        if viewController.isHeaderRefreshingForTableView(tableview: tableView) {
            DispatchQueue.main.async {
                self.tableView.mj_header!.endRefreshing(completionBlock: { })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumActivitiesTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumActivitiesTableRow(rawValue: indexPath.row)! {
        case .yourActivities:
            let cell = tableView.dequeueReusableCell(withIdentifier: YourActivitiesCell.identifier) as! YourActivitiesCell
            cell.selectionStyle = .none
            cell.isDataLoad = self.viewModel.getIsDataLoad()
            
            if viewModel.getIsDataLoad() && viewModel.arrMyActivities.count == 0 {
                cell.collectionview.isHidden = true
                cell.labelNoDataText.isHidden = false
                cell.labelNoDataText.text = Constants.label_noDataFound
                cell.collectionview.tag = enumActivitiesTableRow.yourActivities.rawValue
            } else {
                if viewModel.getIsDataLoad() {
                    cell.collectionview.isHidden = false
                    cell.labelNoDataText.isHidden = true
                    cell.collectionview.tag = enumActivitiesTableRow.yourActivities.rawValue
                    cell.arrMyActivities = self.viewModel.arrMyActivities
                    cell.collectionview.reloadData()
                } else {
                    cell.collectionview.isHidden = false
                    cell.labelNoDataText.isHidden = true
                    cell.collectionview.tag = enumActivitiesTableRow.yourActivities.rawValue
                }
            }
            
            cell.labelYourActivitiesTitle.text = Constants.label_yourActivities
            viewController.setupButtonUI(buttonName: cell.buttonActivity, buttonTitle: Constants.btn_addActivity)
            cell.buttonActivity.tag = enumActivitiesTableRow.yourActivities.rawValue
            cell.buttonActivity.addTarget(self, action: #selector(buttonAddActivityTap(_:)), for: .touchUpInside)
            
            cell.callbackForButtonClick = { isEditButton, isClick, selectedIndex in
                if isEditButton {
                    if isClick {
                        if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                            let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
                            subscriptionplanvc.isFromOtherScreen = true
                            self.viewController.present(subscriptionplanvc, animated: true)
                        } else {
                            let addactivityvc = AddActivityVC.loadFromNib()
                            addactivityvc.hidesBottomBarWhenPushed = true
                            addactivityvc.isEditActivity = true
                            addactivityvc.objActivityDetails = self.viewModel.arrMyActivities[selectedIndex]
                            self.viewController.navigationController?.pushViewController(addactivityvc, animated: true)
                        }
                    }
                } else {
                    let isIndexValid = self.viewModel.arrMyActivities.indices.contains(selectedIndex)
                    
                    if isIndexValid {
                        let interestedactivityvc = InterestedActivityVC.loadFromNib()
                        interestedactivityvc.hidesBottomBarWhenPushed = true
                        interestedactivityvc.activity_id = "\(self.viewModel.arrMyActivities[selectedIndex].id ?? 0)"
                        interestedactivityvc.categoryName = self.viewModel.arrMyActivities[selectedIndex].title ?? ""
                        interestedactivityvc.subCategoryName = self.viewModel.arrMyActivities[selectedIndex].activityCategoryTitle ?? ""
                        self.viewController.navigationController?.pushViewController(interestedactivityvc, animated: true)
                    }
                }
            }
            
            cell.callbackForDidSelectClick = { isClick, selectedIndex in
                if isClick {
                    
                    let isIndexValid = self.viewModel.arrMyActivities.indices.contains(selectedIndex)
                    if isIndexValid {
                        let activitydetailsvc = ActivityDetailsVC.loadFromNib()
                        activitydetailsvc.hidesBottomBarWhenPushed = true
                        activitydetailsvc.objActivityDetails = self.viewModel.arrMyActivities[selectedIndex]
                        self.viewController.navigationController?.pushViewController(activitydetailsvc, animated: true)
                    }
                }
            }
            
            let cellWidth = (cell.collectionview.frame.size.width - 10) / 3
            let height = cellWidth + (cellWidth * 0.6)
            cell.constraintCollectionHeight.constant = height
            cell.layoutIfNeeded()
            
            return cell
        case .othersActivities:
            let cell = tableView.dequeueReusableCell(withIdentifier: YourActivitiesCell.identifier) as! YourActivitiesCell
            cell.selectionStyle = .none
            cell.isDataLoad = self.viewModel.getIsDataLoad()
            
            if viewModel.getIsDataLoad() && viewModel.arrOtherActivities.count == 0 {
                cell.collectionview.isHidden = true
                cell.labelNoDataText.isHidden = false
                cell.labelNoDataText.text = Constants.label_noDataFound
                cell.collectionview.tag = enumActivitiesTableRow.othersActivities.rawValue
            } else {
                if viewModel.getIsDataLoad() {
                    cell.collectionview.isHidden = false
                    cell.labelNoDataText.isHidden = true
                    cell.collectionview.tag = enumActivitiesTableRow.othersActivities.rawValue
                    cell.arrOtherActivities = self.viewModel.arrOtherActivities
                    cell.collectionview.reloadData()
                } else {
                    cell.collectionview.isHidden = false
                    cell.labelNoDataText.isHidden = true
                }
            }   
           
           
            
            cell.imageviewLine.isHidden = true
            cell.labelYourActivitiesTitle.text = Constants.label_otherUserActivities
            
            if Int(viewModel.getOtherActivityCounter())! >= 5 {
                cell.buttonActivity.isHidden = false
                viewController.setupButtonUI(buttonName: cell.buttonActivity, buttonTitle: Constants.btn_startDiscovering)
                cell.buttonActivity.addTarget(self, action: #selector(buttonAddActivityTap(_:)), for: .touchUpInside)
            } else {
                cell.buttonActivity.isHidden = true
            }
            
            cell.buttonActivity.tag = enumActivitiesTableRow.othersActivities.rawValue
            
            cell.callbackForDidSelectClick = { isClick, selectedIndex in
                if isClick {
                    
                    let isIndexValid = self.viewModel.arrOtherActivities.indices.contains(selectedIndex)
                    
                    if isIndexValid {
                        let otheruseractivityvc = OtherUserActivityDetailsVC.loadFromNib()
                        otheruseractivityvc.hidesBottomBarWhenPushed = true
                        otheruseractivityvc.objActivityDetails = self.viewModel.arrOtherActivities[selectedIndex]
                        otheruseractivityvc.activity_id = "\(self.viewModel.arrOtherActivities[selectedIndex].id ?? 0)"
                        self.viewController.navigationController?.pushViewController(otheruseractivityvc, animated: true)
                    }                  
                }
            }
            
            let cellWidth = (cell.collectionview.frame.size.width - 10) / 3
            let height = cellWidth + (cellWidth * 0.6)
            cell.constraintCollectionHeight.constant = height
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    @objc func buttonAddActivityTap(_ sender: UIButton) {
        if sender.tag == enumActivitiesTableRow.yourActivities.rawValue {
            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                if Int(self.viewModel.getUserActivityCreateCount()) ?? 0 > 0 {
                    let addactivityvc = AddActivityVC.loadFromNib()
                    addactivityvc.hidesBottomBarWhenPushed = true
                    addactivityvc.isEditActivity = false
                    self.viewController.navigationController?.pushViewController(addactivityvc, animated: true)
                } else {
                    self.viewController.showAlertPopup(message: Constants_Message.user_create_activity_validation)
                    showSubscriptionPlanScreen()
                }
            } else {
                let addactivityvc = AddActivityVC.loadFromNib()
                addactivityvc.hidesBottomBarWhenPushed = true
                addactivityvc.isEditActivity = false
                self.viewController.navigationController?.pushViewController(addactivityvc, animated: true)
            }
        } else {
            let vc = DiscoverActivityVC.loadFromNib()
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: Show subscription screen for basic user
    func showSubscriptionPlanScreen() {
        let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
        subscriptionplanvc.isFromOtherScreen = true
        viewController.present(subscriptionplanvc, animated: true)
    }
}


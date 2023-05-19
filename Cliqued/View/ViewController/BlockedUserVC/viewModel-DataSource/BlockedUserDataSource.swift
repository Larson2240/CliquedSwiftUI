//
//  BlockedUserDataSource.swift
//  Cliqued
//
//  Created by C100-132 on 10/02/23.
//

import UIKit
import SDWebImage

class BlockedUserDataSource: NSObject {

    private let viewController: BlockedUserVC
    private let viewModel: BlockedUserViewModel
    private let tableView : UITableView
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: BlockedUserViewModel, viewController: BlockedUserVC) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setupPullToRefresh()
            self.setupLoadMore()
        }
    }
    
    //MARK: Register Tableview cell xibs
    func registerTableCell(){
        tableView.registerNib(nibNames: [BlockedUserTVCell.identifier, NoDataFoundCell.identifier])
        tableView.reloadData()
    }
    
    //MARK: Pull To Refresh
    func setupPullToRefresh() {
        viewController.pullToRefreshHeaderSetUpForTableview(tableview: tableView, strStatus: "") {
            self.viewModel.setIsRefresh(value: true)
            self.viewModel.setOffset(value: "0")
            self.viewModel.callUserListAPI()
        }
    }
    
    //MARK: Load More
    func setupLoadMore() {
        viewController.loadMoreFooterSetUpForTableview(tableview: tableView) {
            if self.viewController.isFooterRefreshingForTableView(tableview: self.tableView) {
                self.tableView.mj_footer?.endRefreshing(completionBlock: {
                    self.viewModel.setIsRefresh(value: true)
                    let offset = self.viewModel.arrBlockedUser.count + 1
                    self.viewModel.setOffset(value: "\(offset)")
                    self.viewModel.callUserListAPI()
                })
            }
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
    
    //MARK: Hide footer loader
    func hideFooterLoader() {
        if viewController.isFooterRefreshingForTableView(tableview: tableView) {
            DispatchQueue.main.async {
                self.tableView.mj_footer!.endRefreshing(completionBlock: { })
            }
        }
    }
    
    //MARK: Button action for unblock user
    @objc func buttonUnblockAction(_ sender: UIButton) {
        if viewModel.arrBlockedUser.count > 0 {
            viewController.alertCustom(btnNo: Constants_Message.cancel_title, btnYes: Constants_Message.title_ok, title: "", message: Constants_Message.alert_title_unblock_user) {
                
                let obj = self.viewModel.arrBlockedUser[sender.tag]
                self.viewModel.setUserIndex(value: sender.tag)
                self.viewModel.setCounterUserId(value: "\(obj.counterUserId ?? 0)")
                self.viewModel.setBlockType(value: "\(obj.blockedType ?? "0")")
                self.viewModel.setIsBlock(value: "0")
                self.viewModel.callMarkUserStatusAPI()
            }
        }
    }
}

//MARK: UITableview Delegate Datasource
extension BlockedUserDataSource : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isCheckEmptyData() {
            return 1
        } else {
            if viewModel.getIsDataLoad() {
                return viewModel.arrBlockedUser.count
            } else {
                return 10
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isCheckEmptyData() {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundCell.identifier, for: indexPath) as! NoDataFoundCell
            cell.selectionStyle = .none
            cell.labelNoDataFound.text = Constants.label_noDataFound
            tableView.isScrollEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BlockedUserTVCell.identifier, for: indexPath) as! BlockedUserTVCell
            cell.selectionStyle = .none
            
            if viewModel.getIsDataLoad() {
                cell.hideAnimation()
            } else {
                viewModel.setIsDataLoad(value: false)
                cell.layoutIfNeeded()
                return cell
            }
            
            let obj = viewModel.arrBlockedUser[indexPath.row]
            
            if let img = obj.userProfile {
                let strUrl = UrlProfileImage + img
                let imageWidth = cell.imageUserProfile.frame.size.width
                let imageHeight = cell.imageUserProfile.frame.size.height
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
                let url = URL(string: baseTimbThumb)
                cell.imageUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageUserProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            } else {
                cell.imageUserProfile.image = UIImage(named: "placeholder_matchuser")
            }
                    
            cell.labelUserName.text = obj.name
            cell.buttonUnblock.tag = indexPath.row
            cell.buttonUnblock.addTarget(self, action: #selector(buttonUnblockAction(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.isCheckEmptyData() {
            return 70
        } else {
            return tableView.frame.size.height
        }
    }
}

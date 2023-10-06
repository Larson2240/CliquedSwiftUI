//
//  BlockedUserVCViewController.swift
//  Cliqued
//
//  Created by C100-132 on 10/02/23.
//

import UIKit

class BlockedUserVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variables
    var viewModel = BlockedUserViewModel()
    var dataSource: BlockedUserDataSource?
    var user_id = UserDefaults.standard.string(forKey: kUserToken)

    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: Extension UDF
extension BlockedUserVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        
        dataSource = BlockedUserDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        
        self.viewModel.setUserId(value: "\(user_id)")
        self.viewModel.setOffset(value: "0")
        self.viewModel.callUserListAPI()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants_Message.title_blocked_users
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
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                self.tableView.reloadData()
                self.dataSource!.hideHeaderLoader()
                self.dataSource!.hideFooterLoader()
            }
        }
        
        viewModel.isMarkStatusDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                self.viewModel.arrBlockedUser.remove(at: self.viewModel.getUserIndex())
                            
                if self.viewModel.arrBlockedUser.count > 0 {
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [IndexPath(row: self.viewModel.getUserIndex(), section: 0)], with: .none)
                    self.tableView.endUpdates()
                    self.tableView.reloadData()
                } else {
                    self.tableView.reloadData()
                }

            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { [weak self] isLoader in
            guard let self = self else { return }
            
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
}

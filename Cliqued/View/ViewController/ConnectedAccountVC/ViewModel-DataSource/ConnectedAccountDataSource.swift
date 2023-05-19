//
//  ConnectedAccountDataSource.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class ConnectedAccountDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: ConnectedAccountVC
    private let tableView: UITableView
    private let viewModel: ConnectedAccountViewModel
    
    //MARK: Enum Section
    enum enumConnectedAccountTableRow: Int, CaseIterable {
        case apple = 0
        case facebook
        case google
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: ConnectedAccountViewModel, viewController: ConnectedAccountVC) {
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
        tableView.registerNib(nibNames: [ConnectedAccountCell.identifier])
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumConnectedAccountTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectedAccountCell.identifier) as! ConnectedAccountCell
        cell.selectionStyle = .none
        switch enumConnectedAccountTableRow(rawValue: indexPath.row)! {
        case .apple:
            cell.imageviewIcon.image = UIImage(named: "ic_connected_account_apple")
            cell.labelSocialPlatformName.text = Constants.label_apple
            cell.labelSocialEmailId.text = "cliequed123@apple.com"
            return cell
        case .facebook:
            cell.imageviewIcon.image = UIImage(named: "ic_connected_account_fb")
            cell.labelSocialPlatformName.text = Constants.label_facebook
            cell.labelSocialEmailId.text = "cliqued123@facebook.com"
            return cell
        case .google:
            cell.imageviewIcon.image = UIImage(named: "ic_connected_account_gmail")
            cell.labelSocialPlatformName.text = Constants.label_Google
            cell.labelSocialEmailId.text = "cliqued123@gmail.com"
            return cell
        }
    }
}

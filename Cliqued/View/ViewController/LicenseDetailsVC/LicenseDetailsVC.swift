//
//  LicenseDetailsVC.swift
//  Cliqued
//
//  Created by C211 on 27/04/23.
//

import UIKit

class LicenseDetailsVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variable
    var dataSource : LicenseDetailsDataSource?
    lazy var viewModel = LicenseDetailsViewModel()
    
    //MARK: viewDidLoad method
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
extension LicenseDetailsVC {
    
    func viewDidLoadMethod() {
        dataSource = LicenseDetailsDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        setupNavigationBar()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingRowTitle_licenses
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  ConnectedAccountVC.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class ConnectedAccountVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var labelConnectedAccountDescription: UILabel!{
        didSet {
            labelConnectedAccountDescription.text = Constants.label_connectedAccountDescription
            labelConnectedAccountDescription.font = CustomFont.THEME_FONT_Medium(14)
            labelConnectedAccountDescription.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Variable
    var dataSource : ConnectedAccountDataSource?
    lazy var viewModel = ConnectedAccountViewModel()
    
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
extension ConnectedAccountVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = ConnectedAccountDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_connectedAccount
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

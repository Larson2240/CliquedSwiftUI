//
//  SetLocationVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class SetLocationVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_setLocationScreenSubTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        }
    }
    
    //MARK: Variable
    var dataSource : SetLocationDataSource?
    lazy var viewModel = SetLocationViewModel()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        let notificationVC = NotificationPermissionVC.loadFromNib()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
}
//MARK: Extension UDF
extension SetLocationVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        dataSource = SetLocationDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_setYourLocation
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Setup ProgressView progress
    func setupProgressView() {
        let currentProgress = 8
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
}

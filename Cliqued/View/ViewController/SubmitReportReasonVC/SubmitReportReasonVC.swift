//
//  SubmitReportReasonVC.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class SubmitReportReasonVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var labelReasonTitle: UILabel!{
        didSet {
            labelReasonTitle.text = Constants.label_reportReasonTitle
            labelReasonTitle.font = CustomFont.THEME_FONT_Bold(22)
            labelReasonTitle.textColor = Constants.color_DarkGrey
            
            labelReasonTitle.linesCornerRadius = 10
            labelReasonTitle.skeletonTextNumberOfLines = 2
            labelReasonTitle.skeletonTextLineHeight = .fixed(20)
            labelReasonTitle.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonNext: UIButton!
    
    //MARK: Variable
    var dataSource : SubmitReportReasonDataSource?
    lazy var viewModel = SubmitReportReasonViewModel()
    var reportedUserId: String?
    
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
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonNext, buttonTitle: Constants.btn_next)
    }

    //MARK: Button Next Click
    @IBAction func btnNextClick(_ sender: Any) {
        self.viewModel.setReportedUserId(value: reportedUserId ?? "")
        self.viewModel.callAddReportForUserAPI()
    }
}
//MARK: Extension UDF
extension SubmitReportReasonVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = SubmitReportReasonDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        self.viewModel.callGetReportListAPI()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = ""
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
            if isSuccess {
                self?.tableview.reloadData()
            }
        }
        
        //If API success
        viewModel.isSubmitReason.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let reportuservc = ReportUserVC.loadFromNib()
                reportuservc.isSubmitReasonScreen = true
                self.navigationController?.pushViewController(reportuservc, animated: true)
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

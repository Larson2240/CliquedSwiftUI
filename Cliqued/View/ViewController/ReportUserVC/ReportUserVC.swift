//
//  ReportUserVC.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class ReportUserVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var labelReportUserTitle: UILabel!{
        didSet {
            
            labelReportUserTitle.font = CustomFont.THEME_FONT_Bold(22)
            labelReportUserTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelDescriptionFirst: UILabel!{
        didSet {
            labelDescriptionFirst.font = CustomFont.THEME_FONT_Medium(16)
            labelDescriptionFirst.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelDescriptionSecond: UILabel!{
        didSet {
            labelDescriptionSecond.text = Constants.label_reportUserDescriptionSecond
            labelDescriptionSecond.font = CustomFont.THEME_FONT_Medium(16)
            labelDescriptionSecond.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonNext: UIButton!
    
    //MARK: Variable
    var isSubmitReasonScreen: Bool = false
    var reportedUserId: String?
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isSubmitReasonScreen {
            setupButtonUI(buttonName: buttonNext, buttonTitle: Constants.btn_done)
        } else {
            setupButtonUI(buttonName: buttonNext, buttonTitle: Constants.btn_next)
        }
    }
    
    //MARK: Button Next Click Tap
    @IBAction func btnNextClick(_ sender: Any) {
        if isSubmitReasonScreen {
            let viewcontrollers = self.navigationController?.viewControllers
            viewcontrollers?.forEach({ [weak self] (vc) in
                guard let self = self else { return }
                
                if let activitydetailsvc = vc as? ActivityUserDetailsVC {
                    self.navigationController?.popToViewController(activitydetailsvc, animated: true)
                } else if let activitydetailsvc = vc as? ChatVC {
                    self.navigationController?.popToViewController(activitydetailsvc, animated: true)
                }
            })
        } else {
            let reportreasonvc = SubmitReportReasonVC.loadFromNib()
            reportreasonvc.reportedUserId = self.reportedUserId
            self.navigationController?.pushViewController(reportreasonvc, animated: true)
        }
    }
}
//MARK: Extension UDF
extension ReportUserVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        if isSubmitReasonScreen {
            labelReportUserTitle.text = Constants.label_reportThankYouTitle
            labelDescriptionFirst.text = Constants.label_reportThankYouDescription
            labelDescriptionSecond.isHidden = true
        } else {
            labelReportUserTitle.text = Constants.label_reportUser
            labelDescriptionFirst.text = Constants.label_reportUserDescriptionFirst
            labelDescriptionSecond.isHidden = false
        }
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = ""
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
        if isSubmitReasonScreen {
            viewNavigationBar.buttonBack.isHidden = true
        } else {
            viewNavigationBar.buttonBack.isHidden = false
        }
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

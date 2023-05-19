//
//  NameVC.swift
//  Cliqued
//
//  Created by C211 on 13/01/23.
//

import UIKit

class NameVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_nameScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_nameScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelTextFieldTitle: UILabel!{
        didSet {
            labelTextFieldTitle.text = Constants.label_name
            labelTextFieldTitle.font = CustomFont.THEME_FONT_Bold(18)
            labelTextFieldTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var textfiledName: UITextField!{
        didSet {
            textfiledName.font = CustomFont.THEME_FONT_Bold(18)
            textfiledName.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        }
    }
    
    //MARK: Variable
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func btnContinueTap(_ sender: Any) {
        let agevc = AgeVC.loadFromNib()
        self.navigationController?.pushViewController(agevc, animated: true)
    }
}
//MARK: Extension UDF
extension NameVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupTextfiledPlaceholder()
        setupProgressView()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_name
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
        let currentProgress = 1
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Setup TextFiled Placeholder
    func setupTextfiledPlaceholder() {
        textfiledName.attributedPlaceholder = NSAttributedString(
            string: Constants.placeholder_name,
            attributes: [NSAttributedString.Key.font: CustomFont.THEME_FONT_Regular(16)!]
        )
    }
}

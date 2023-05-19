//
//  PickActivityVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class PickActivityVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_pickActivityScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_pickActivityScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        }
    }
    
    
    //MARK: Variable
    var dataSource: PickActivityDataSource?
    
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
        let picksubactivityVC = PickSubActvityVC.loadFromNib()
        self.navigationController?.pushViewController(picksubactivityVC, animated: true)
    }
    
}
//MARK: Extension UDF
extension PickActivityVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        self.dataSource = PickActivityDataSource(collectionView: collectionview, viewController: self)
        self.collectionview.delegate = dataSource
        self.collectionview.dataSource = dataSource
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_pickActivity
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
        let currentProgress = 5
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
}

//
//  ActivityUserDetails.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class ActivityUserDetailsVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var buttonBack: UIButton!{
        didSet {
            buttonBack.layer.cornerRadius = buttonBack.frame.size.height / 2
        }
    }
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var pageviewcontrol: UIPageControl!
    @IBOutlet weak var labelUserNameAndAge: UILabel!{
        didSet {
            labelUserNameAndAge.text = "Liza Haydan, 60"
            labelUserNameAndAge.font = CustomFont.THEME_FONT_Bold(19)
            labelUserNameAndAge.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var labelLocationDistance: UILabel!{
        didSet {
            labelLocationDistance.text = "10 km away"
            labelLocationDistance.font = CustomFont.THEME_FONT_Bold(19)
            labelLocationDistance.textColor = Constants.color_white
        }
    }
    @IBOutlet var buttonLike: UIButton!    
    @IBOutlet var buttonDislike: UIButton!
    
    //MARK: Variable
    var dataSource : ActivityUserDetailsDataSource?
    lazy var viewModel = ActivityUserDetailsViewModel()
    lazy var viewModelActivity = HomeActivitiesViewModel()
    var objUserDetails: User?
    var callbackForIsLiked: ((_ isLiked: Bool) -> Void)?
    var callbackForBlockUser: ((_ isblocked: Bool) -> Void)?
    var is_fromChatActivity = false
    var isFromOtherScreen: Bool = false
    private let isMeetup = IsMeetupIds()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Button Back Tap
    @IBAction func btnBackTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Button Like Click
    @IBAction func btnLikeClick(_ sender: Any) {
        viewModelActivity.setIsFollow(value: "1")
        viewModelActivity.setCounterUserId(value: viewModel.getActivityUserId())
        viewModelActivity.callLikeDislikeUserAPI(isShowLoader: true)
    }
    
    //MARK: Button Dislike Click
    @IBAction func btnDislikeClick(_ sender: Any) {
        viewModelActivity.setIsFollow(value: "0")
        viewModelActivity.setCounterUserId(value: viewModel.getActivityUserId())
        viewModelActivity.callLikeDislikeUserAPI(isShowLoader: true)
    }
    
}
//MARK: Extension UDF
extension ActivityUserDetailsVC {
    
    func viewDidLoadMethod() {
        dataSource = ActivityUserDetailsDataSource(tableView: tableview, collectionView: collectionview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        collectionview.delegate = dataSource
        collectionview.dataSource = dataSource
        
        if is_fromChatActivity {
            buttonLike.isHidden = true
            buttonDislike.isHidden = true
        } else {
            buttonLike.isHidden = false
            buttonDislike.isHidden = false
        }
        
        if let objUserDetails = objUserDetails {
            viewModel.bindActivityUserDetailsData(userData: objUserDetails)
            setupUserDetails()
        }
        handleApiResponse()
    }
    //MARK: Setup user details
    func setupUserDetails() {
        let name = viewModel.getName()
        let age = viewModel.getAge()
        labelUserNameAndAge.text = "\(name), \(age)"
        
        if is_fromChatActivity {
            let city = viewModel.getLocation().first?.city
            labelLocationDistance.text = city
        } else {
            labelLocationDistance.text = "\(viewModel.getDistance()) km away"
        }
        
    }
    //MARK: Handle API response
    func handleApiResponse() {

        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        viewModelActivity.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }

        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                self.callbackForBlockUser?(true)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        //If API success
        viewModelActivity.isLikdDislikeSuccess.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let followersData = self.viewModelActivity.getFollowersData(at: 0)
                if followersData.isMeetup == self.isMeetup.Matched  {
                    /* comment added by srm
                    let matchscreenvc = MatchScreenVC.loadFromNib()
                    matchscreenvc.isFromUserDetailsScreen = true
                    matchscreenvc.arrayOfFollowers = self.viewModelActivity.getAllFollowersData()
                    matchscreenvc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(matchscreenvc, animated: true)
                     */
                } else {
                    if followersData.isFollow == "1" {
                        self.callbackForIsLiked?(true)
                    } else {
                        self.callbackForIsLiked?(false)
                    }
                    self.navigationController?.popViewController(animated: true)
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
        
        viewModelActivity.isLoaderShow.bind { [weak self] isLoader in
            guard let self = self else { return }
            
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
}

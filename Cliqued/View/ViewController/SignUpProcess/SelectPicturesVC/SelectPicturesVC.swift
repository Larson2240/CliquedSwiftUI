//
//  SelectPicturesVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import CoreImage

class SelectPicturesVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_selectPictureScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_selectPictureScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    
    //MARK: Variable
    var dataSource: SelectPicturesDataSource?
    lazy var viewModel = OnboardingViewModel()
    
    var isFromEditProfile: Bool = false
    var arrayOfProfileImage = [UserProfileImages]()
    private let profileSetupType = ProfileSetupType()
    private let mediaType = MediaType()
    
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
        setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
    }
    
    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        
        //Bind data in viewModel method
        viewModel.profileImages = []
        viewModel.thumbnails = []
        
        if !isFromEditProfile {
            for profileData in dataSource?.arrayOfSelectedImages ?? [] {
                if profileData.mediaType == 0 {
                    viewModel.profileImages.append(profileData.image ?? UIImage())
                    viewModel.thumbnails.append(profileData.image ?? UIImage())
                } else if profileData.mediaType == 1 {
                    viewModel.profileImages.append(profileData.videoURL ?? URL.self)
                    viewModel.thumbnails.append(profileData.thumbnail ?? UIImage())
                }
            }
            //Check array count
            if viewModel.profileImages.count > 1 {
                //Check at least one image is selected or not.
                let isImageContain = dataSource?.arrayOfSelectedImages.contains(where: {$0.mediaType == 0}) ?? Bool()
                if isImageContain {
                    viewModel.profileSetupType = profileSetupType.profile_images
                    viewModel.callSignUpProcessAPI()
                } else {
                    self.showAlertPopup(message: Constants.validMsg_selectImage)
                }
            } else {
                self.showAlertPopup(message: Constants.validMsg_selectPicture)
            }
            
            
        } else {
            if dataSource?.arrayOfSelectedImages.count ?? 0 > 1 {
                for profileData in dataSource?.arrayOfEditedImages ?? [] {
                    if profileData.mediaType == 0 {
                        viewModel.profileImages.append(profileData.image ?? UIImage())
                        viewModel.thumbnails.append(profileData.image ?? UIImage())
                    } else if profileData.mediaType == 1 {
                        viewModel.profileImages.append(profileData.videoURL ?? URL.self)
                        viewModel.thumbnails.append(profileData.thumbnail ?? UIImage())
                    }
                }
                //Check at least one image is selected or not.
                let isImageContain = dataSource?.arrayOfSelectedImages.contains(where: {$0.mediaType == 0}) ?? Bool()
                if isImageContain {
                    viewModel.profileSetupType = profileSetupType.completed
                    if let deleteImageIds = dataSource?.arrayOfDeletedImageIds.map({String($0)}).joined(separator: ", ") {
                        viewModel.deletedImageIds = deleteImageIds
                    }
                    viewModel.callSignUpProcessAPI()
                } else {
                    self.showAlertPopup(message: Constants.validMsg_selectImage)
                }
            } else {
                self.showAlertPopup(message: Constants.validMsg_selectPicture)
            }
        }
    }
    
}
//MARK: Extension UDF
extension SelectPicturesVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        self.dataSource = SelectPicturesDataSource(viewController: self, viewModel: viewModel, collectionView: collectionview)
        self.collectionview.delegate = dataSource
        self.collectionview.dataSource = dataSource
        if isFromEditProfile {
            setupProfileImageCollection()
        }
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_selectPictures
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonSkip.addTarget(self, action: #selector(buttonSkipTap), for: .touchUpInside)
        
        if !isFromEditProfile {
            progressView.isHidden = false
            viewNavigationBar.buttonBack.isHidden = true
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = false
        } else {
            progressView.isHidden = true
            viewNavigationBar.buttonBack.isHidden = false
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = true
        }
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Skip Action
    @objc func buttonSkipTap() {
        APP_DELEGATE.setTabBarRootViewController()
    }
    //MARK: Setup ProgressView progress
    func setupProgressView() {
        let currentProgress = 7
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Manage profile collection for edit profile time
    func setupProfileImageCollection() {
        for imagesData in arrayOfProfileImage {
            if imagesData.mediaType == mediaType.image {
                let strUrl = UrlProfileImage + imagesData.url!
                let url = URL(string: strUrl)
                if let imgUrl = url {
                    var dic = SelectPicturesDataSource.structProfileMedia()
                    dic.image = nil
                    dic.mediaType = 0
                    dic.thumbnail = nil
                    dic.videoURL = nil
                    dic.serverURL = imgUrl
                    dic.serverImageId = imagesData.id
                    self.dataSource?.arrayOfSelectedImages.append(dic)
                }
            } else {
                let strUrl = UrlProfileImage + imagesData.thumbnailUrl!
                let strVideoUrl = UrlProfileImage + imagesData.url!
                let videoURL = URL(string: strVideoUrl)
                let url = URL(string: strUrl)
                if let imgUrl = url {
                    var dic = SelectPicturesDataSource.structProfileMedia()
                    dic.image = nil
                    dic.mediaType = 1
                    dic.thumbnail = nil
                    dic.videoURL = videoURL
                    dic.serverURL = imgUrl
                    dic.serverImageId = imagesData.id
                    self.dataSource?.arrayOfSelectedImages.append(dic)
                }
            }
        }
        self.collectionview.reloadData()
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
                if self.isFromEditProfile {
                    NotificationCenter.default.post(name: Notification.Name("refreshProfileData"), object: nil, userInfo:nil)
                    let editprofilevc = EditProfileVC.loadFromNib()
                    editprofilevc.isUpdateData = true
                    self.navigationController?.pushViewController(editprofilevc, animated: true)
                } else {
                    let setlocationVC = SetLocationVC.loadFromNib()
                    self.navigationController?.pushViewController(setlocationVC, animated: true)
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

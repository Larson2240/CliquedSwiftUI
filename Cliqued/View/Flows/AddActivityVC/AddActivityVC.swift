//
//  AddActivityVC.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit
import MapKit
import CoreLocation

class AddActivityVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var stackviewEditButton: UIStackView!
    
    //MARK: Variable
    var dataSource : AddActivityDataSource?
    lazy var viewModel = AddActivityViewModel()
    var isEditActivity: Bool = false
    var objActivityDetails: UserActivityClass?
    var callbackForUpdateActivityData: ((_ objActivityDetails: UserActivityClass)->Void)?
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonSubmit, buttonTitle: Constants.btn_submit)
    }

    //MARK: Button Submit Click
    @IBAction func btnSubmitClick(_ sender: Any) {
        self.view.endEditing(true)
        if viewModel.getActivityDate().isEmpty {
            var currentData = Date.getCurrentDate()
            viewModel.setDate(value: currentData)
        }
        viewModel.callCreateActivityAPI()
    }
    
    //MARK: Button Edit Data Submit Click
    @IBAction func btnEditSubmitClick(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.callEditActivityAPI()
    }
    
    //MARK: Button Cancel Click
    @IBAction func btnCancelClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: Extension UDF
extension AddActivityVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = AddActivityDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
                   
        viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
        
        if isEditActivity {
            viewModel.objActivityDetails = objActivityDetails
            
            viewModel.setDate(value: (objActivityDetails?.activityDate)!)
            viewModel.setTitle(value: (objActivityDetails?.title)!)
            viewModel.setDescription(value: (objActivityDetails?.descriptionValue)!)
            viewModel.setActivityCategoryTitle(value: (objActivityDetails?.activityCategoryTitle)!)
            viewModel.setActivityId(value: "\(objActivityDetails?.id ?? 0)")
            
            if let arrCat = objActivityDetails?.activitySubCategory {
                for i in arrCat {
                    var objStructCategory = activitySubCategoryStruct()
                    objStructCategory.activity_category_id = "\(i.activityCategoryId ?? 0)"
                    objStructCategory.activity_sub_category_id = "\(i.subCategoryId ?? 0)"
                    
                    viewModel.setActivitySubCategory(value: objStructCategory)
                }
            }
            
            if let arrAddress = objActivityDetails?.activityDetails {
                for i in arrAddress {
                    var objStructAddress = activityAddressStruct()
                    objStructAddress.address = i.address!
                    objStructAddress.latitude = i.latitude!
                    objStructAddress.longitude = i.longitude!
                    objStructAddress.city = "\(i.city ?? "")"
                    objStructAddress.state = "\(i.state ?? "")"
                    objStructAddress.country = "\(i.country ?? "")"
                    objStructAddress.pincode = "\(i.pincode ?? "")"
                    objStructAddress.address_id = "\(i.id ?? 0)"
                    
                    viewModel.setActivityAddress(value: objStructAddress)
                }
            }
            
            if let arrMedia = objActivityDetails?.activityMedia {
                for i in arrMedia {
                    let img = i.url
                    let strUrl = UrlUserActivity + img!
                    
                    guard let url = URL(string: strUrl) else { return }

                    UIImage.loadFrom(url: url) { image in
                        self.viewModel.setActivityMedia(value: image!)
                        self.tableview.reloadData()
                    }
                }
            }
            tableview.reloadData()
        }
        
        setupButtons()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        if isEditActivity {
            viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_editActivity
        } else {
            viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_createActivity
        }
        
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Setup Button's
    func setupButtons() {
        if isEditActivity {
            stackviewEditButton.isHidden = false
            buttonSubmit.isHidden = true
        } else {
            stackviewEditButton.isHidden = true
            buttonSubmit.isHidden = false
        }
    }
}

extension AddActivityVC {
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
//            if !self.isEditActivity {
//                self.showAlertPopup(message: message)
//            }
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                if self.isEditActivity {
                    if let activityData = self.viewModel.objActivityDetails {
                        self.callbackForUpdateActivityData?(activityData)
                    }
                }
                self.navigationController?.popViewController(animated: true)
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

//
//  SubscriptionPlanVC.swift
//  Cliqued
//
//  Created by C211 on 20/02/23.
//

import UIKit
import StoreKit

class SubscriptionPlanVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var labelNoDataFound: UILabel!{
        didSet {
            labelNoDataFound.text = Constants.label_noDataFound
            labelNoDataFound.font = CustomFont.THEME_FONT_Medium(14)
            labelNoDataFound.textColor = Constants.color_MediumGrey
        }
    }
    @IBOutlet weak var labelTermConditionText: UILabel!{
        didSet{
            labelTermConditionText.text = Constants.label_subscriptionTerms
            labelTermConditionText.font = CustomFont.THEME_FONT_Medium(14)
            labelTermConditionText.textColor = Constants.color_DarkGrey
            labelTermConditionText.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet {
            buttonContinue.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var buttonNoThanks: UIButton!{
        didSet {
            buttonNoThanks.showAnimatedGradientSkeleton()
        }
    }
    
    //MARK: Variable
    var dataSource : SubscriptionPlanDataSource?
    lazy var viewModel = SubscriptionPlanViewModel()
    var isFromOtherScreen: Bool = false
    var arrProduct = [SKProduct]()
    var currentProduct = SKProduct()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let topVC = UIApplication.getTopViewController() {
            topVC.showAlerBox("", "In-App Purchase\n IN_PROGRESS") { _ in}
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        setupButtonUIWithGreyBackground(buttonName: buttonNoThanks, buttonTitle: Constants.btn_noThanks)
    }
    
    @IBAction func btnContinueClick(_ sender: Any) {
//        let obj = viewModel.getPlanData(at: 0)
//        purchaseProduct(productId: obj.storeProductId!)
//        buyProduct(productId: obj.storeProductId!, plan_id: obj.id!)
    }
    
    @IBAction func btnNoThanksClick(_ sender: Any) {
        if isFromOtherScreen {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
//MARK: Extension UDF
extension SubscriptionPlanVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = SubscriptionPlanDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
//        self.getProduct()
        self.viewModel.callGetSubscriptionPlanAPI()
        handleResponse()
//        labelTermConditionText.isHidden = true
//        buttonContinue.isHidden = true
//        buttonNoThanks.isHidden = true
        
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = ""
        viewNavigationBar.buttonSkip.isHidden = true
        
        if isFromOtherScreen {
            viewNavigationBar.buttonBack.isHidden = true
            viewNavigationBar.buttonRight.isHidden = false
            viewNavigationBar.buttonRight.setImage(UIImage(named: "close_ic"), for: .normal)
            viewNavigationBar.buttonRight.addTarget(self, action: #selector(buttonCloseTap), for: .touchUpInside)
        } else {
            viewNavigationBar.buttonBack.isHidden = false
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        }
    }
    func hideAnimation() {
        labelTermConditionText.hideSkeleton()
        buttonContinue.hideSkeleton()
        buttonNoThanks.hideSkeleton()
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Button Action
    @objc func buttonCloseTap() {
        self.dismiss(animated: true)
    }
    
    //MARK: - UserDefined Fuction
    func getProduct() {
        arrProduct.removeAll()
        print(Set.InAppAllPackageIds)
        IAPHelper.shared.getProducts(
            ofPackageIds: .InAppAllPackageIds,
            callbackForProducts: { products in
                DispatchQueue.main.async {
                    self.arrProduct.append(contentsOf: products)
                    
                    for objProduct in self.arrProduct {
                        let status = IAPHelper.shared.isProductPurchased(objProduct.productIdentifier)
                        if status {
                            self.currentProduct = objProduct
                        }
                    }
                }
            },
            callbackForError: { error in
                print(error)
            })
    }
    
    func handleResponse() {
        
        //Check response message
        viewModel.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if !self.viewModel.isCheckEmptyData() {
                let plans = self.viewModel.arrayOfPlan
                self.viewModel.arrayOfPlan.removeAll()
                
                for objProduct in plans {
                    let isAdded = self.arrProduct.filter({$0.productIdentifier == objProduct.storeProductId})
                    if isAdded.count > 0 {
                        self.viewModel.arrayOfPlan.append(objProduct)
                    }
                }
                
                if self.viewModel.arrayOfPlan.count > 0 {
                    self.tableview.isHidden = false
                    self.labelNoDataFound.isHidden = true
                    self.tableview.reloadData()
                    self.labelTermConditionText.isHidden = false
                    self.buttonContinue.isHidden = false
                    self.buttonNoThanks.isHidden = false
                } else {
                    self.tableview.isHidden = true
                    self.labelTermConditionText.isHidden = true
                    self.buttonContinue.isHidden = true
                    self.buttonNoThanks.isHidden = true
                    self.labelNoDataFound.isHidden = false
                }
            } else {
                self.tableview.isHidden = true
                self.labelNoDataFound.isHidden = false
            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { isLoader in
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
    //MARK: Purchase subscription plan
    func buyProduct(productId : String, plan_id: Int) {
        let StoreProduct = self.arrProduct.filter({$0.productIdentifier == productId})
        if StoreProduct.count > 0 {
            self.showLoader()
            IAPHelper.shared.buy(product: StoreProduct[0]) { transaction in
                self.dismissLoader()
                print(transaction)
                self.getReceiptData()
            }
        }
    }
    //MARK: Retrive subscription plan info
    func getReceiptData() {
        IAPHelper.shared.getReceiptData(
            responseData: { response in
                DispatchQueue.main.async {
                    self.dismissLoader()
                    self.storeResponse(response)
                }
            },
            errorData: { error in
                DispatchQueue.main.async {
                    self.dismissLoader()
                    print("===>", error)
                }
            })
    }
    //MARK: Manage subscription receipt data
    func storeResponse(_ response: NSDictionary) {
        
        guard response["latest_receipt"] is String else {
            return
        }
        
        guard let receiptInfo = response["latest_receipt_info"] as? NSArray else {
            return
        }
        
        var latestReceipt = NSDictionary()
        if let firstReceipt = receiptInfo.firstObject as? NSDictionary,
           let lastReceipt = receiptInfo.lastObject as? NSDictionary {
            
            if let expiresDateMilliesFirstStr = firstReceipt["expires_date_ms"] as? String,
               let expiresDateMilliesLastStr = lastReceipt["expires_date_ms"] as? String {
                
                let expiresDateMilliesFirst = Double(expiresDateMilliesFirstStr).aDoubleOrEmpty()
                let expiresDateMilliesLast = Double(expiresDateMilliesLastStr).aDoubleOrEmpty()
                
                if expiresDateMilliesFirst >= expiresDateMilliesLast {
                    latestReceipt = firstReceipt
                } else {
                    latestReceipt = lastReceipt
                }
            } else {
                latestReceipt = firstReceipt
            }
        }
        
        guard let productId = latestReceipt["product_id"] as? String,
              let transactionId = latestReceipt["original_transaction_id"] as? String,
              let purchaseDateMillies = latestReceipt["purchase_date_ms"] as? String,
              let expiresDateMillies = latestReceipt["expires_date_ms"] as? String else {
            return
        }
        
        let format = "yyyy-MM-dd HH:mm:ss"
        let startDate = Date(timeIntervalSince1970: Double(purchaseDateMillies).aDoubleOrEmpty() / 1000).localToUTC(format: format)
        let expiresDate = Date(timeIntervalSince1970: Double(expiresDateMillies).aDoubleOrEmpty() / 1000).localToUTC(format: format)
        
        self.viewModel.setSubscriptionId(value: productId)
        self.viewModel.setTransactionId(value: transactionId)
        self.viewModel.setPlanStartDate(value: startDate)
        self.viewModel.setPlanEndDate(value: expiresDate)
        
        if self.viewModel.getTransactionDate() == self.viewModel.getPlanStartDate() {
            self.viewModel.setIsActive(value: "1")
        } else {
            self.viewModel.setIsActive(value: "0")
        }
        
        print("getSubscriptionId: \(self.viewModel.getSubscriptionId())")
        print("getTransactionId: \(self.viewModel.getTransactionId())")
        print("getTransactionDate: \(self.viewModel.getTransactionDate())")
        print("getPlanStartDate: \(self.viewModel.getPlanStartDate())")
        print("getPlanEndDate: \(self.viewModel.getPlanEndDate())")
        self.viewModel.callAddSubscriptionDetailsAPI()
    }
}

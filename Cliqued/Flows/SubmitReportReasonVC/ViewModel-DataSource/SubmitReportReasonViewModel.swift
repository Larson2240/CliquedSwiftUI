//
//  SubmitReportReasonViewModel.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class SubmitReportReasonViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isSubmitReason: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    var arrayOfReportList = [ReportReason]()
    private var isRefresh: Bool = false
    private var reportReasonId = ""
    private var reportedUserId = ""
    private let apiParams = ApiParams()
    
    private let reportWebService = ReportWebService()
    
    //MARK: Call Get Report List Data API
    func callGetReportListAPI() {
        guard Connectivity.isConnectedToInternet() else {
            isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        self.arrayOfReportList.removeAll()
        
        reportWebService.getReportReasons { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.arrayOfReportList = model
            case .failure(let error):
                if let error = error as? ApiError, let errorDesc = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: errorDesc)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
            
            self.setIsDataLoad(value: true)
            self.isDataGet.value = true
        }
    }
    
    //MARK: Call SignIn API
    func callAddReportForUserAPI() {
        
        guard !getReportReasonId().isEmpty else {
            self.isMessage.value = Constants.validMsg_reportReason
            return
        }
        
        guard Connectivity.isConnectedToInternet() else {
            self.isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        
        let parameters: [String: Any] = ["reportedUser": "/api/users/\(getReportedUserId())",
                                         "reportReason": "/api/report_reasons/\(getReportReasonId())"]
        
        reportWebService.reportUser(parameters: parameters) { [weak self] result in
            switch result {
            case .success:
                self?.isLoaderShow.value = false
                self?.isSubmitReason.value = true
            case .failure(let error):
                if let error = error as? ApiError, let errorDesc = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: errorDesc)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
        }
    }
}
//MARK: getter/setter method
extension SubmitReportReasonViewModel {
    
    func getNumberOfReport() -> Int {
        arrayOfReportList.count
    }
    func getReportsData(at index: Int) -> ReportReason {
        arrayOfReportList[index]
    }
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfReportList.count == 0 {
            return true
        } else {
            return false
        }
    }
    func getIsRefresh() -> Bool {
        return isRefresh
    }
    
    func setIsRefresh(value:Bool) {
        isRefresh = value
    }
    
    func setReportReasonId(value:String) {
        reportReasonId = value
    }
    func setReportedUserId(value:String) {
        reportedUserId = value
    }
    
    func getReportReasonId() -> String {
        return reportReasonId
    }
    func getReportedUserId() -> String {
        return reportedUserId
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
}

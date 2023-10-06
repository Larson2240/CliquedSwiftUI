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
    var arrayOfReportList = [ReportClass]()
    private var isRefresh: Bool = false
    private var reportReasonId = ""
    private var reportedUserId = ""
    private let apiParams = ApiParams()
    
    //MARK: Call Get Report List Data API
    func callGetReportListAPI() {
        
        if(Connectivity.isConnectedToInternet()) {
            self.arrayOfReportList.removeAll()
            RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetMasterPreferenceAPI) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.setIsDataLoad(value: true)
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    _ = json?[API_MESSAGE] as? String
                
                    if status == SUCCESS {
                        if let reportArray = json?["report_reason"] as? NSArray {
                            if reportArray.count > 0 {
                                for reportInfo in reportArray {
                                    let dicReport = reportInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicReport)
                                        let reportData = try decoder.decode(ReportClass.self, from: jsonData)
                                        self.arrayOfReportList.append(reportData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                self.isDataGet.value = true
                            }
                        } else {
                            self.isDataGet.value = true
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Call SignIn API
    func callAddReportForUserAPI() {
        
        if getReportReasonId().isEmpty {
            self.isMessage.value = Constants.validMsg_reportReason
        } else {
            let params: NSDictionary = [
//                apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
                apiParams.reportedUserId : self.getReportedUserId(),
                apiParams.reportReasonId : self.getReportReasonId()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.AddReportForUser, parameters: params) { [weak self] response, error, message in
                    guard let self = self else { return }
                    
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        
                        if status == SUCCESS {
                            self.isSubmitReason.value = true
                        }  else {
                            self.isMessage.value = message ?? ""
                        }
                    }
                }
            } else {
                self.isMessage.value = Constants.alert_InternetConnectivity
            }
        }
    }
}
//MARK: getter/setter method
extension SubmitReportReasonViewModel {
    
    func getNumberOfReport() -> Int {
        arrayOfReportList.count
    }
    func getReportsData(at index: Int) -> ReportClass {
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

//
//  RestApiManager.swift
//  WebServiceDemo
//
//  Created by C211 on 21/02/20.
//  Copyright © 2020 C211. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

let MESSAGE = "something went wrong"

protocol UploadProgressDelegate{
    func didReceivedProgress(progress:Float)
}

protocol DownloadProgressDelegate {
    func didReceivedDownloadProgress(progress:Float,filename:String)
    func didFailedDownload(filename:String)
}

class RestApiManager {
    static let sharePreference = RestApiManager()
    var header: HTTPHeaders = [
        .contentType("application/json"),
        .userAgent("iOS")
    ]
    var responseObjectDic = Dictionary<String, AnyObject>()
    var URLString: String!
    var message: String!
    var responseObject: AnyObject!
    var delegat: UploadProgressDelegate?
    var downloadDelegate: DownloadProgressDelegate?
    
    init() {
        AF.session.configuration.timeoutIntervalForRequest = 50000 //seconds
        AF.session.configuration.timeoutIntervalForResource = 50000 //seconds
    }
    
    //MARK: Get Requestz
    func getResponseWithoutParams(webUrl: String, responseData:@escaping (_ data:AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        let additionalHeaders = includeSecurityCredentials()
        
        for headerKey in additionalHeaders {
            header.add(name: headerKey.key as! String, value: headerKey.value as! String)
        }
        print(additionalHeaders)
        
        AF.request(webUrl, method: .get, headers: header).responseJSON { response in
            
            if response.error != nil {
                if((response.error! as NSError).code == NSURLErrorNetworkConnectionLost || (response.error as! NSError).code == NSURLErrorTimedOut){
                    self.getResponseWithoutParams(webUrl: webUrl, responseData: responseData)
                }
                else
                {
                    responseData(nil, response.error as NSError?, nil)
                }
            }
            else
            {
                switch response.result {
                case .success(_):
                    if let data = response.value {
                        
                        let jsonDic = data as? NSDictionary
                        let status = jsonDic?[API_STATUS] as? Int
                        let message = jsonDic?[API_MESSAGE] as? String
                        if status == ALREADY_LOGIN {
                            if let topVC = UIApplication.getTopViewController(), topVC is UIAlertController == false {
                                topVC.showAlerBox("", message ?? "") { _ in
                                    callLogoutAPI()
                                }
                            }
                        } else {
                            self.responseObject = data as AnyObject
                            responseData(self.responseObject, nil, MESSAGE)
                        }
                    }
                    break
                case .failure(_):
                    responseData(nil, response.error as? NSError, MESSAGE)
                    break
                }
            }
        }
    }
    
    func getRequest(webUrl: String,  parameter: NSDictionary, responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        
        let additionalHeaders = includeSecurityCredentials()
        for headerKey in additionalHeaders {
            header.add(name: headerKey.key as! String, value: headerKey.value as! String)
        }
        print(additionalHeaders)
        AF.request(webUrl, method: .post, parameters: parameter as? [String:AnyObject], headers: header).responseJSON { response in
            
            if response.error != nil {
                if ((response.error as! NSError).code == NSURLErrorNetworkConnectionLost || (response.error as! NSError).code == NSURLErrorTimedOut){
                    self.getRequest(webUrl: webUrl, parameter: parameter, responseData: responseData)
                }
                else
                {
                    responseData(nil, response.error as NSError?, MESSAGE)
                }
            }
            else
            {
                switch response.result {
                case .success(_):
                    if let data = response.value {
                        let jsonDic = data as? NSDictionary
                        let status = jsonDic?[API_STATUS] as? Int
                        let message = jsonDic?[API_MESSAGE] as? String
                        if status == ALREADY_LOGIN {
                            if let topVC = UIApplication.getTopViewController(), topVC is UIAlertController == false {
                                topVC.showAlerBox("", message ?? "") { _ in
                                    callLogoutAPI()
                                }
                            }
                        } else {
                            self.responseObject = data as AnyObject
                            responseData(self.responseObject, nil, MESSAGE)
                        }
                    }
                    break
                case.failure(_):
                    responseData(nil, response.error as? NSError, MESSAGE)
                    break
                }
            }
        }
    }
    
    func convertStringToDictionary(data: Data) -> [String:AnyObject]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
        return nil
    }
    
    func postJSONRequest(endpointurl:String, parameters:NSDictionary, encodingType:ParameterEncoding = JSONEncoding.default, responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void){
        
        let additionalHeaders = includeSecurityCredentials()
        
        if endpointurl == APIName.Logout {
            header.add(name: kSecretKey, value: userDefaults.value(forKey: kTempToken) as! String)
            header.add(name: kAccessKey, value: "nousername")
            header.add(name: kDeviceType, value: "1")
            header.add(name: kDeviceToken, value: (userDefaults.object(forKey: kDeviceToken) as? String) ?? "")
        }else{
            for headerKey in additionalHeaders {
                header.add(name: headerKey.key as! String, value: headerKey.value as! String)
            }
        }
        print(additionalHeaders)
        
        AF.request(endpointurl, method: .post, parameters: parameters as? Parameters, encoding: encodingType, headers: header).responseJSON { response in
            
            if let _ = response.error{
                if((response.error! as NSError).code == NSURLErrorNetworkConnectionLost || (response.error! as NSError).code == NSURLErrorTimedOut){
                    self.postJSONRequest(endpointurl: endpointurl, parameters: parameters, responseData: responseData)
                }else{
                    responseData(nil, response.error as NSError?, MESSAGE)
                }
            }else
            {
                switch(response.result)
                {
                case .success(_):
                    if let data = response.value{
                        let jsonDic = data as? NSDictionary
                        let status = jsonDic?[API_STATUS] as? Int
                        let message = jsonDic?[API_MESSAGE] as? String
                        if status == ALREADY_LOGIN {
                            if let topVC = UIApplication.getTopViewController(), topVC is UIAlertController == false {
                                topVC.showAlerBox("", message ?? "") { _ in
                                    callLogoutAPI()
                                }
                            }
                        } else {
                            self.responseObject = data as AnyObject
                            responseData(self.responseObject, nil, MESSAGE)
                        }
                    }
                    break
                case .failure(_):
                    responseData(nil, response.error as NSError?, MESSAGE)
                    break
                }
            }
        }
    }
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    
    //MARK: Image Upload
    func postJSONFormDataRequest(endpoint:String, parameters:NSDictionary, encodingType: ParameterEncoding = JSONEncoding.default, responseData:@escaping ( _ data:AnyObject?,  _ response: NSError?, _ error: String?)->Void)
    {
        
        let additionalHeaders = includeSecurityCredentials()
        
        print("APIUrl: \(endpoint)")
        print("Parameters: \(parameters)")
        
        for headerKey in additionalHeaders {
            header.add(name: headerKey.key as! String, value: headerKey.value as! String)
        }
        print(header)
        
        AF.upload( multipartFormData:{ multipartFormData in
            
            for (key,value) in parameters {
                if value is UIImage {
                    let imageData:Data = (value as! UIImage).jpegData(compressionQuality: 0.3)!
                    multipartFormData.append(imageData, withName: key as! String, fileName: "profilePicture.jpg", mimeType: "image/*")
                } else if value is NSArray {
                    for childValue in value as! NSArray {
                        if childValue is UIImage {
                            let imageData:Data = (childValue as! UIImage).jpegData(compressionQuality: 0.3)!
                            multipartFormData.append(imageData, withName: key as! String, fileName: "media.jpg", mimeType: "image/*")
                        }
                        else  if childValue is NSURL || childValue is URL {
                            let videoData:Data
                            do {
                                let type = self.mimeTypeForPath(path: "\(childValue)")
                                var filename = "swift_file.mov"
                                switch type {
                                case "application/pdf":
                                    filename = "swift_file.pdf"
                                case "image/jpg":
                                    filename = "swift_file.jpg"
                                case "image/jpeg":
                                    filename = "swift_file.jpeg"
                                case "image/png":
                                    filename = "swift_file.png"
                                case "video/mp4":
                                    filename = "swift_file.mp4"
                                case "video/mov":
                                    filename = "swift_file.mov"
                                default:
                                    break;
                                }
                                videoData = try Data (contentsOf: (childValue as! URL), options: .mappedIfSafe)
                                multipartFormData.append(videoData, withName: key as! String, fileName: filename, mimeType: type)
                            } catch {
                                print(error)
                                return
                            }
                        }
                        else {
                            let valueData:Data = (value as! NSString).data(using: String.Encoding.utf8.rawValue)!
                            multipartFormData.append(valueData, withName: key as! String)
                        }
                    }
                }
                else if value is NSURL || value is URL {
                    let videoData:Data
                    do {
                        let type = self.mimeTypeForPath(path: "\(value)")
                        var filename = "swift_file.mp4"
                        switch type {
                        case "application/pdf":
                            filename = "swift_file.pdf"
                        case "image/jpg":
                            filename = "swift_file.jpg"
                        case "image/jpeg":
                            filename = "swift_file.jpeg"
                        case "image/png":
                            filename = "swift_file.png"
                        case "video/mp4":
                            filename = "swift_file.mp4"
                        case "video/mov":
                            filename = "swift_file.mov"
                        default:
                            break;
                        }
                        videoData = try Data (contentsOf: (value as! URL), options: .mappedIfSafe)
                        multipartFormData.append(videoData, withName: key as! String, fileName: filename, mimeType: type)
                        
                    } catch {
                        print(error)
                        return
                    }
                }
                else {
                    let valueData:Data = (NSString.init(string: "\(value)")).data(using: String.Encoding.utf8.rawValue)!
                    multipartFormData.append(valueData, withName: key as! String)
                }
            }
        } ,to: endpoint, method: .post, headers: header).responseJSON {
            response in
            
            if response.error != nil{
                //print(response.error)
                responseData(nil,response.error as NSError?, response.error?.localizedDescription)
            }
            else {
                
                switch response.result {
                case .success(_):
                    if let data = response.value{
                        let jsonDic = data as? NSDictionary
                        let status = jsonDic?[API_STATUS] as? Int
                        let message = jsonDic?[API_MESSAGE] as? String
                        if status == ALREADY_LOGIN {
                            if let topVC = UIApplication.getTopViewController(), topVC is UIAlertController == false {
                                topVC.showAlerBox("", message ?? "") { _ in
                                    callLogoutAPI()
                                }
                            }
                        } else {
                            self.responseObject = data as AnyObject
                            responseData(self.responseObject, nil, MESSAGE)
                        }
                    }
                    break
                case .failure(_):
                    responseData(nil,response.error as NSError?, "Something went wrong")
                }
            }
        }
    }
}

//MARK: Call Update Profile API
func callLogoutAPI() {
    let params: NSDictionary = [
        APIParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
    ]
    var topVC = UIViewController()
    topVC = UIApplication.getTopViewController() ?? UIViewController()
    if(Connectivity.isConnectedToInternet()){
        DispatchQueue.main.async {
            topVC.showLoader()
        }
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.Logout, parameters: params) { response, error, message in
            topVC.dismissLoader()
            if(error != nil && response == nil) {
                topVC.showAlertPopup(message: error?.localizedDescription ?? "")
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let message = json?[API_MESSAGE] as? String
                
                if(status == FAILED) {
                    topVC.showAlertPopup(message: message ?? "")
                }
                else {
                    topVC.dismissLoader()
                    clearUserDefault()
                    checkSecurity()
                    APP_DELEGATE.setRegisterOptionRootViewController()
                }
            }
        }
    } else {
        topVC.showAlertPopup(message: Constants.alert_InternetConnectivity)
    }
}


//MARK: Extension for get TopViewController
extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

//
//  UIViewController+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 10/04/20.
//  Copyright © 2020 C100-107. All rights reserved.
//


import UIKit
import SVProgressHUD
import MJRefresh
import MapKit
import SwiftMessages
import Photos
import DropDown

extension UIViewController {
    
    //MARK:- Static Function
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
    func showDefaultIOSAlert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlerBox(_ title: String, _ message: String, _ handler:@escaping(UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: handler )
        okButton.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alert.addAction(okButton)
        
        
        let messageAttributes = [NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(15), NSAttributedString.Key.foregroundColor: Constants.color_DarkGrey]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertCustom(btnNo:String,btnYes:String,title:String,message:String,block: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let messageAttributes = [NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(15), NSAttributedString.Key.foregroundColor: Constants.color_DarkGrey]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let cancelButton = UIAlertAction(title: btnNo, style: .destructive, handler: { (action: UIAlertAction!) in
        })
        cancelButton.setValue(Constants.color_MediumGrey, forKey: "titleTextColor")
        alert.addAction(cancelButton)
        
        let yesButton = UIAlertAction(title: btnYes, style: .default, handler: {(action: UIAlertAction!) in
            block()
        })
        yesButton.setValue(Constants.color_DarkGrey, forKey: "titleTextColor")
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertCustomForChat(btnNo:String,btnYes:String,title:String,message:String,blockNo:@escaping () -> (),block: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let messageAttributes = [NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(15), NSAttributedString.Key.foregroundColor: Constants.color_DarkGrey]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let cancelButton = UIAlertAction(title: btnNo, style: .destructive, handler: { (action: UIAlertAction!) in
            blockNo()
        })
        cancelButton.setValue(Constants.color_MediumGrey, forKey: "titleTextColor")
        alert.addAction(cancelButton)
        
        let yesButton = UIAlertAction(title: btnYes, style: .default, handler: {(action: UIAlertAction!) in
            block()
        })
        yesButton.setValue(Constants.color_DarkGrey, forKey: "titleTextColor")
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: nil)
    }
}
extension UIViewController {
    
    func showLoader() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.show()
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
    func showAlertPopup(message: String) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        //        warning.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        warning.configureTheme(backgroundColor: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5), foregroundColor: Constants.color_white, iconImage: nil)
        warning.button?.isHidden = true
        warning.configureDropShadow()
        warning.configureContent(title: nil, body: message, iconImage: UIImage(named: "ic_alert"), iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.dimMode = .gray(interactive: true)
        warningConfig.duration = .seconds(seconds: 10)
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    //MARK: -----------------------------------------------------------
    //MARK: Popup Animation With TabBar
    func showPopup()
    {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.view.alpha = 1.0
            self?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removePopup() {
        self.view.removeFromSuperview()
    }
    
    //MARK: -----------------------------------------------------------
    //MARK: MJRefresh Methods for Tableview
    func pullToRefreshHeaderSetUpForTableview(tableview: UITableView, strStatus: String, block: @escaping MJRefreshComponentAction)  {
        tableview.bounces = true
        
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.isAutomaticallyChangeAlpha = true
        header.setTitle(strStatus, for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        
        tableview.mj_header = header
    }
    //MARK: Load More Function
    func loadMoreFooterSetUpForTableview(tableview: UITableView, block: @escaping MJRefreshComponentAction) {
        tableview.bounces = true
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: block)
        footer.isAutomaticallyChangeAlpha = true
        
        tableview.mj_footer = footer
    }
    func isHeaderRefreshingForTableView(tableview: UITableView) -> Bool {
        if (tableview.mj_header != nil) {
            return tableview.mj_header!.isRefreshing
        }
        return false
    }
    
    func isFooterRefreshingForTableView(tableview: UITableView) -> Bool {
        if (tableview.mj_footer != nil) {
            return tableview.mj_footer!.isRefreshing
        }
        return false
    }
    
    //MARK: MJRefresh Methods for CollectionView
    func pullToRefreshHeaderSetUpForCollectionview(collectionview: UICollectionView, strStatus: String, block: @escaping MJRefreshComponentAction)  {
        collectionview.bounces = true
        
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.isAutomaticallyChangeAlpha = true
        header.setTitle(strStatus, for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        
        collectionview.mj_header = header
    }
    //MARK: Load More Function
    func loadMoreFooterSetUpForCollectionview(collectionview: UICollectionView, block: @escaping MJRefreshComponentAction) {
        collectionview.bounces = true
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: block)
        footer.isAutomaticallyChangeAlpha = true
        
        collectionview.mj_footer = footer
    }
    func isHeaderRefreshingForCollectionview(collectionview: UICollectionView) -> Bool {
        if (collectionview.mj_header != nil) {
            return collectionview.mj_header!.isRefreshing
        }
        return false
    }
    
    func isFooterRefreshingForCollectionView(collectionview: UICollectionView) -> Bool {
        if (collectionview.mj_footer != nil) {
            return collectionview.mj_footer!.isRefreshing
        }
        return false
    }
    
    //MARK: Button UI Setup
    func setupButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Bold(20)
        buttonName.setTitleColor(Constants.color_white, for: .normal)
        buttonName.backgroundColor = Constants.color_themeColor
        buttonName.layer.cornerRadius = buttonName.frame.height / 2
        buttonName.layer.masksToBounds = false
    }
    
    //MARK: Button UI Setup
    func setupButtonUIWithGreyBackground(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Bold(20)
        buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
        buttonName.backgroundColor = Constants.color_lightGrey
        buttonName.layer.cornerRadius = buttonName.frame.height / 2
        buttonName.layer.masksToBounds = false
    }
    
    func setupButtonUIWithOutBackground(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Bold(16)
        buttonName.setTitleColor(Constants.color_themeColor, for: .normal)
        buttonName.backgroundColor = .clear
        buttonName.layer.cornerRadius = buttonName.frame.height / 2
        buttonName.layer.masksToBounds = false
    }
    
    func UTCToLocal(date:String,format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: dt!)
    }
    
    func getChatDateFromServer(strDate:String) -> String
    {
        let todayDt = Date()
        
        let formatter        = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // formatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateStr  = strDate
        let currDate = formatter.date(from: dateStr)!
        
        if (todayDt >= currDate)
        {
            //           let difference = currDate.timeIntervalSince(todayDt)
            //           let int_days = Int(difference/(60 * 60 * 24 ))
            
            let int_days = Calendar.current.dateComponents([.day], from: todayDt, to: currDate).day
            
            if int_days == -1
            {
                let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy hh:mm a")
                return todaystr1
            }
            else if int_days == 0
            {
                let str1 = currDate.dateToStringWithFormat(format: "hh:mm a")
                return str1
            }
            else if int_days! < -1
            {
                let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy hh:mm a")
                return todaystr1
            }
            else
            {
                let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy hh:mm a")
                return todaystr1
            }
            
            
        }
        else
        {
            return ""
        }
    }
    
    func getChatDateFromServerForLastSeen1(strDate:String) -> String
    {
        let todayDt = Date()
        let dateStr  = strDate
        
        let formatter        = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        if dateStr == "0000-00-00 00:00:00" {
            return ""
        } else {
            
            //            let currDate = dateStr.toDate()
            let currDate = formatter.date(from: dateStr)!
            
            if (todayDt >= currDate) {
                //               let difference = currDate.timeIntervalSince(todayDt)
                //               let int_days = Int(difference/(60 * 60 * 24 ))
                
                let int_days = Calendar.current.dateComponents([.day], from: todayDt, to: currDate).day
                
                if int_days == -1
                {
                    let todaystr1 = currDate.UTCToLocal(format: TIME_FORMAT_FULL)
                    return "\(Constants_Message.title_yesterday_text) \(todaystr1) \(Constants_Message.title_ago_text)"
                }
                else if int_days == 0
                {
                    //                    let str1 = currDate.UTCToLocal(format: TIME_FORMAT)
                    if todayDt < currDate {
                        let int_min = Calendar.current.dateComponents([.minute], from: todayDt, to: currDate).minute
                        
                        if int_min ?? 0 >= 60 {
                            let int_hour = Calendar.current.dateComponents([.hour], from: todayDt, to: currDate).hour
                            
                            if int_hour == 1 {
                                return "\(int_hour ?? 0) \(Constants_Message.title_hr_text) \(Constants_Message.title_ago_text)"

                            } else {
                                return "\(int_hour ?? 0) \(Constants_Message.title_hrs_text) \(Constants_Message.title_ago_text)"
                            }
                        } else if int_min ?? 0 == 0 {
                            let int_sec = Calendar.current.dateComponents([.second], from: currDate, to: todayDt).second
                            
                            return "\(int_sec ?? 0) \(Constants_Message.title_sec_text) \(Constants_Message.title_ago_text)"
                        }
                        
                        
                        if int_min == 1 {
                            return "\(int_min ?? 0) \(Constants_Message.title_min_text) \(Constants_Message.title_ago_text)"

                        } else {
                            return "\(int_min ?? 0) \(Constants_Message.title_mins_text) \(Constants_Message.title_ago_text)"
                        }
                    } else {
                        let int_min = Calendar.current.dateComponents([.minute], from: currDate, to: todayDt).minute
                        
                        if int_min ?? 0 >= 60 {
                            let int_hour = Calendar.current.dateComponents([.hour], from: currDate, to: todayDt).hour
                            
                            if int_hour == 1 {
                                return "\(int_hour ?? 0) \(Constants_Message.title_hr_text) \(Constants_Message.title_ago_text)"

                            } else {
                                return "\(int_hour ?? 0) \(Constants_Message.title_hrs_text) \(Constants_Message.title_ago_text)"
                            }
                        } else if int_min ?? 0 == 0 {
                            var int_sec = Calendar.current.dateComponents([.second], from: currDate, to: todayDt).second
                            
                            if int_sec ?? 0 == 0 {
                                int_sec = 1
                            }
                            return "\(int_sec ?? 0) \(Constants_Message.title_sec_text) \(Constants_Message.title_ago_text)"
                        }
                        
                        if int_min == 1 {
                            return "\(int_min ?? 0) \(Constants_Message.title_min_text) \(Constants_Message.title_ago_text)"

                        } else {
                            return "\(int_min ?? 0) \(Constants_Message.title_mins_text) \(Constants_Message.title_ago_text)"
                        }
                    }
                    
                }
                else if int_days! < -1
                {
                    let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy HH:mm")
                    return "\(todaystr1)"
                }
                else
                {
                    let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy HH:mm")
                    return "\(todaystr1)"
                }
            }
            else
            {
                return ""
            }
        }
        
    }
    
    func getChatDateFromServerForLastSeen(strDate:String) -> String
    {
        let todayDt = Date()
        var dateStr  = strDate
        
        let formatter        = DateFormatter()
        
        if dateStr.contains(" +0000") {
            dateStr = dateStr.replacingOccurrences(of: " +0000", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        
        if dateStr == "0000-00-00 00:00:00" {
            return ""
        } else {
            
            let currDate = formatter.date(from: dateStr)!
            
            if (todayDt >= currDate) {
                              
                let int_days = Calendar.current.dateComponents([.day], from: todayDt, to: currDate).day
                
                if int_days == -1
                {
                    let todaystr1 = currDate.UTCToLocal(format: TIME_FORMAT_FULL)
                    return "\(Constants_Message.title_yesterday_text) \(todaystr1)"
                }
                else if int_days == 0
                {
                    let str1 = currDate.UTCToLocal(format: TIME_FORMAT_FULL)
                    return "\(str1)"
                }
                else if int_days! < -1
                {
                    let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy HH:mm")
                    return todaystr1
                }
                else
                {
                    let todaystr1 = currDate.dateToStringWithFormat(format: "dd/MM/yyyy HH:mm")
                    return todaystr1
                }
            }
            else
            {
                return ""
            }
        }
        
    }
    
    func getChatDateFromServerForSection(strDate:String) -> String
    {
        let todayDt = Date()
        
        let formatter        = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // formatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateStr  = strDate
        let currDate = formatter.date(from: dateStr)!
        
        if (todayDt >= currDate)
        {
            //           let difference = currDate.timeIntervalSince(todayDt)
            //           let int_days = Int(difference/(60 * 60 * 24 ))
            
            let int_days = Calendar.current.dateComponents([.day], from: todayDt, to: currDate).day
            
            if int_days == -1
            {
                return Constants_Message.title_yesterday_text
            }
            else if int_days == 0
            {
                
                return Constants_Message.title_today_text
            }
            else if int_days! < -1
            {
                let todaystr1 = currDate.dateToStringWithFormat(format: "dd, MMMM yyyy")
                return todaystr1
            }
            else
            {
                return "Tomorrow"
            }
        }
        else
        {
            return ""
        }
    }
    
    func createThumbnailOfVideoFromFileURL(videoURL: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: videoURL)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return #imageLiteral(resourceName: "ic_activity_unselected")
        }
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 30, y: self.view.frame.size.height - 160, width: self.view.frame.width - 60, height: 70))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = CustomFont.THEME_FONT_Regular(12)
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
extension UIButton
{
    func addBlurEffect()
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}

//
//  WebviewVC.swift
//  Cliqued
//
//  Created by C211 on 18/04/23.
//

import UIKit
import WebKit

class WebviewVC: UIViewController {
    
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var progressview: UIProgressView!
    
    //MARK: Variable
    var url: URL?
    var screenTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }

}
//MARK: Extension UDF
extension WebviewVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        self.webview.load(NSURLRequest(url: self.url!) as URLRequest)
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        if screenTitle == Constants.labelSettingSectionTitle_contactUs {
            viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingSectionTitle_contactUs
        } else if screenTitle == Constants.labelSettingRowTitle_communityGuidelines {
            viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingRowTitle_communityGuidelines
        } else if screenTitle == Constants.labelSettingRowTitle_safetyTips {
            viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingRowTitle_safetyTips
        } else if screenTitle == Constants.labelSettingRowTitle_cookiePolicy {
            viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingRowTitle_cookiePolicy
        } else if screenTitle == Constants.labelSettingRowTitle_privacyPolicy {
            viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingRowTitle_privacyPolicy
        } else if screenTitle == Constants.labelSettingRowTitle_termsOfService {
            viewNavigationBar.labelNavigationTitle.text = Constants.labelSettingRowTitle_termsOfService
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
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.webview.estimatedProgress);
            self.progressview.progress = Float(self.webview.estimatedProgress);
        }
        if self.webview.estimatedProgress == 1.0 {
            self.progressview.isHidden = true
        }
    }
}

//
//  UIApplication + Extension.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 23.05.2023.
//

import Foundation
import SwiftMessages
import SVProgressHUD

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    func showLoader() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.show()
    }
    
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
}

// MARK: - Alerts
extension UIApplication {
    func showAlerBox(_ title: String, _ message: String, _ handler: @escaping (UIAlertAction) -> Void) {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: handler )
        okButton.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alert.addAction(okButton)
        
        
        let messageAttributes = [NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(15), NSAttributedString.Key.foregroundColor: Constants.color_DarkGrey]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        rootVC.present(alert, animated: true, completion: nil)
    }
    
    func alertCustom(btnNo: String, btnYes: String, title: String, message: String, block: @escaping () -> ()) {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let messageAttributes = [NSAttributedString.Key.font: CustomFont.THEME_FONT_Medium(15), NSAttributedString.Key.foregroundColor: Constants.color_DarkGrey]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes as [NSAttributedString.Key : Any])
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let cancelButton = UIAlertAction(title: btnNo, style: .destructive, handler: { _ in })
        cancelButton.setValue(Constants.color_MediumGrey, forKey: "titleTextColor")
        
        alert.addAction(cancelButton)
        
        let yesButton = UIAlertAction(title: btnYes, style: .default, handler: { _ in
            block()
        })
        
        yesButton.setValue(Constants.color_DarkGrey, forKey: "titleTextColor")
        alert.addAction(yesButton)
        
        rootVC.present(alert, animated: true, completion: nil)
    }
    
    func showAlertPopup(message: String) {
        let warning = MessageView.viewFromNib(layout: .cardView)
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
    
    func presentAlert(title: String, message: String) {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        rootVC.present(alert, animated: true)
    }
}

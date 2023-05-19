//
//  RegisterOptionVC.swift
//  Cliqued
//
//  Created by C211 on 10/01/23.
//

import UIKit

class RegisterOptionVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var imageviewBkg: UIImageView!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    //MARK: Variable
    var context = CIContext(options: nil)
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonSignUp, buttonTitle: Constants.btn_signUp)
        setupButtonUIWithGreyBackground(buttonName: buttonLogin, buttonTitle: Constants.btn_logIn)
    }
    
    @IBAction func btnSignUpTap(_ sender: Any) {
        let signupvc = SignUpVC.loadFromNib()
        self.navigationController?.pushViewController(signupvc, animated: true)
    }
    
    @IBAction func btnLogInTap(_ sender: Any) {
        let signinvc = SignInVC.loadFromNib()
        self.navigationController?.pushViewController(signinvc, animated: true)
    }
    
    func isPasswordHasNumberAndCharacter(password: String) -> Bool {
        let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: password)
    }
    
}
//MARK: Extension UDF
extension RegisterOptionVC {
    
    func viewDidLoadMethod() {
    }
}

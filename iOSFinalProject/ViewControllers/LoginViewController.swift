//
//  ViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit
import Material

class LoginViewController: BaseLoginViewController {

    let initialPosition:CGFloat = 260

    @IBOutlet weak var loginButton: LoadingButton!
    fileprivate var passwordField: TextField!
    fileprivate var emailField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = ""
        loginButton.setStyle()
        loginButton.isEnabled = false
        preparePasswordField()
        prepareEmailField()
        setupAddTargetIsNotEmptyTextFields()
    }
    
    override func moveToApp() {
        self.performSegue(withIdentifier: "showAppFromLogin", sender: self)
    }
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.setEmailStyle()
        view.layout(emailField).left(sideMargin).right(sideMargin).top(initialPosition)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.setPasswordStyle()
        view.layout(passwordField).left(sideMargin).right(sideMargin).top(initialPosition + gap)
    }
    
    private func setupAddTargetIsNotEmptyTextFields() {
        emailField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                             for: .editingChanged)
        emailField.addTarget(self, action: #selector(textIsEmail), for: .editingDidEnd)
        passwordField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let email = emailField.text, !email.isEmpty && email.isValidEmail(),
            let password = passwordField.text, !password.isEmpty
            else
        {
            loginButton.isEnabled = false
            return
        }
        // enable login button if all conditions are met
        loginButton.isEnabled = true
    }
    
    override func notLoggedIn(error: String?) {
        loginButton.hideLoading()
        showErrorAlert(title: "Sorry, login wasn't succesfull.")
    }

    @IBAction func clickedLogin(_ sender: Any) {
        NSLog("clickedLogin")
        loginButton.showLoading()
        if let userName = emailField.text, let password = passwordField.text{
            Model.instance.signInUser(email: userName, password: password)
        }
    }
    
}

